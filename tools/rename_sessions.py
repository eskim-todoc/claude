#!/usr/bin/env python3
"""Bulk-rename Claude Code session titles using AI-generated summaries.

Walks every *.jsonl session file under %USERPROFILE%/.claude/projects/, asks
Claude Haiku 4.5 for a short Korean title, and appends a custom-title record
to each session file. Original conversation history is preserved (append-only).

See rename_sessions.README.md for detailed usage.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

import anthropic


DEFAULT_PROJECTS_DIR = Path(os.environ.get("USERPROFILE", "")) / ".claude" / "projects"
CREDENTIALS_FALLBACK = Path("E:/workspace/rules/tools/credentials/anthropic/api.key")
LOG_DIR = Path(__file__).resolve().parent / ".logs"

MODEL = "claude-haiku-4-5"
MAX_CHARS_PER_MSG = 3000
TITLE_MAX_LEN = 30

SYSTEM_PROMPT = (
    "너는 Claude Code 세션의 대화 이력을 읽고 한국어로 30자 이내의 간결한 "
    "세션 제목을 한 줄로 생성한다. 마침표/따옴표/이모지 금지. 명사구 위주. "
    "파일 경로·UUID·긴 코드는 제외하고 핵심 작업만 담는다. "
    "출력은 <title>제목</title> 태그로 감싼다."
)

TITLE_RE = re.compile(r"<title>(.*?)</title>", re.DOTALL)


def resolve_api_key() -> str:
    key = os.environ.get("ANTHROPIC_API_KEY", "").strip()
    if key:
        return key
    if CREDENTIALS_FALLBACK.exists():
        text = CREDENTIALS_FALLBACK.read_text(encoding="utf-8").strip()
        if text:
            return text
    sys.stderr.write(
        "[ERR] ANTHROPIC_API_KEY 환경변수가 설정되지 않았고,\n"
        f"      fallback 파일({CREDENTIALS_FALLBACK})도 비어있습니다.\n"
        "      Anthropic Console에서 API 키를 발급받아 아래 중 한 가지로 주입하세요:\n"
        '        $env:ANTHROPIC_API_KEY = "sk-ant-api03-..."\n'
        f"        또는 {CREDENTIALS_FALLBACK} 파일에 키만 한 줄로 저장\n"
    )
    sys.exit(2)


def extract_text(content) -> str:
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts = []
        for block in content:
            if not isinstance(block, dict):
                continue
            t = block.get("type")
            if t == "text":
                parts.append(block.get("text", ""))
            elif t == "tool_use":
                parts.append(f"[tool:{block.get('name', '')}]")
        return "\n".join(p for p in parts if p)
    return ""


def parse_jsonl(path: Path) -> list[dict]:
    msgs: list[dict] = []
    with path.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            t = rec.get("type")
            if t not in ("user", "assistant"):
                continue
            if rec.get("isMeta"):
                continue
            message = rec.get("message", {}) or {}
            text = extract_text(message.get("content", ""))
            if not text:
                continue
            if t == "user" and text.lstrip().startswith(("<system-reminder>", "<command-name>", "<local-command")):
                continue
            msgs.append({"role": t, "text": text})
    return msgs


def pick_sample(msgs: list[dict]) -> list[dict]:
    if not msgs:
        return []
    first_user = next((m for m in msgs if m["role"] == "user"), None)
    last_assistants = [m for m in msgs if m["role"] == "assistant"][-2:]
    picked: list[dict] = []
    if first_user:
        picked.append(dict(first_user))
    for a in last_assistants:
        picked.append(dict(a))
    for p in picked:
        if len(p["text"]) > MAX_CHARS_PER_MSG:
            p["text"] = p["text"][:MAX_CHARS_PER_MSG] + "…(truncated)"
    return picked


def format_sample(sample: list[dict]) -> str:
    lines = []
    for m in sample:
        prefix = "[USER]" if m["role"] == "user" else "[ASSISTANT]"
        lines.append(f"{prefix}: {m['text']}")
    return "\n\n".join(lines)


def sanitize_title(raw: str) -> str:
    t = raw.strip()
    t = t.strip("'\"“”‘’`")
    t = t.rstrip(".!?。")
    t = t.replace("\n", " ").strip()
    if len(t) > TITLE_MAX_LEN:
        t = t[:TITLE_MAX_LEN].rstrip()
    return t or "제목없음"


def summarize(client: anthropic.Anthropic, sample: list[dict]) -> str:
    body = format_sample(sample)
    if not body:
        return "빈 세션"
    resp = client.messages.create(
        model=MODEL,
        max_tokens=80,
        temperature=0.3,
        system=[
            {
                "type": "text",
                "text": SYSTEM_PROMPT,
                "cache_control": {"type": "ephemeral"},
            }
        ],
        messages=[{"role": "user", "content": body}],
    )
    parts = []
    for block in resp.content:
        if getattr(block, "type", None) == "text":
            parts.append(block.text)
    raw = "".join(parts)
    m = TITLE_RE.search(raw)
    if m:
        title = m.group(1)
    else:
        title = raw.splitlines()[0] if raw else ""
    return sanitize_title(title)


def append_custom_title(path: Path, sid: str, title: str) -> None:
    rec = {"type": "custom-title", "customTitle": title, "sessionId": sid}
    with path.open("a", encoding="utf-8", newline="") as f:
        f.write(json.dumps(rec, ensure_ascii=False) + "\n")


def enumerate_sessions(projects_dir: Path) -> list[tuple[Path, str]]:
    out: list[tuple[Path, str]] = []
    if not projects_dir.exists():
        return out
    for sub in projects_dir.iterdir():
        if not sub.is_dir():
            continue
        for f in sub.glob("*.jsonl"):
            out.append((f, f.stem))
    out.sort(key=lambda x: x[0].stat().st_mtime, reverse=True)
    return out


def backup_projects(projects_dir: Path) -> Path:
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    dest = projects_dir.with_name(projects_dir.name + f".bak-{ts}")
    shutil.copytree(projects_dir, dest)
    return dest


def write_log(results: list[dict]) -> Path:
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    logf = LOG_DIR / f"rename_sessions_{ts}.log"
    with logf.open("w", encoding="utf-8") as f:
        for r in results:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")
    return logf


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(
        description="Bulk-rename Claude Code session titles using AI-generated summaries."
    )
    mode = ap.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="(기본값) 실제 쓰기 없이 미리보기만")
    mode.add_argument("--apply", action="store_true", help="실제로 세션 파일에 custom-title 추가")
    ap.add_argument("--backup", action="store_true",
                    help="--apply 시 projects 폴더를 타임스탬프 붙은 백업 디렉토리로 복사")
    ap.add_argument("--no-backup", action="store_true",
                    help="--apply + --backup 없이 강행 (권장하지 않음)")
    ap.add_argument("--projects-dir", type=Path, default=DEFAULT_PROJECTS_DIR,
                    help="기본: %%USERPROFILE%%\\.claude\\projects")
    ap.add_argument("--max-sessions", type=int, default=0,
                    help="처리할 세션 최대 개수 (0=제한 없음)")
    args = ap.parse_args(argv)

    apply = args.apply
    dry_run = not apply

    if apply and not args.backup and not args.no_backup:
        sys.stderr.write(
            "[ERR] --apply 를 사용하려면 --backup 또는 --no-backup 중 하나를 명시하세요.\n"
        )
        return 2

    projects_dir: Path = args.projects_dir
    if not projects_dir.exists():
        sys.stderr.write(f"[ERR] projects 디렉토리가 없습니다: {projects_dir}\n")
        return 2

    if apply:
        print("[!] Claude Code Desktop app이 실행 중이면 파일 락 때문에 실패할 수 있습니다.")
        print("    Desktop app을 종료한 뒤 계속하세요.\n")

    sessions = enumerate_sessions(projects_dir)
    if args.max_sessions > 0:
        sessions = sessions[: args.max_sessions]
    if not sessions:
        print(f"[i] 대상 세션이 없습니다: {projects_dir}")
        return 0
    print(f"[i] 대상 세션 {len(sessions)}개 (모드: {'APPLY' if apply else 'DRY-RUN'})")

    if apply and args.backup:
        print("[i] 백업 생성 중...")
        dest = backup_projects(projects_dir)
        print(f"[i] 백업 완료: {dest}\n")

    client = anthropic.Anthropic(api_key=resolve_api_key())

    results: list[dict] = []
    ok = err = 0
    for i, (path, sid) in enumerate(sessions, start=1):
        try:
            msgs = parse_jsonl(path)
            if not msgs:
                title = "빈 세션"
            else:
                sample = pick_sample(msgs)
                title = summarize(client, sample)
            if dry_run:
                print(f"[DRY] ({i}/{len(sessions)}) {sid} -> {title}")
            else:
                append_custom_title(path, sid, title)
                print(f"[OK ] ({i}/{len(sessions)}) {sid} -> {title}")
            results.append({
                "sessionId": sid, "path": str(path), "title": title,
                "status": "ok", "applied": apply,
            })
            ok += 1
        except Exception as e:
            print(f"[ERR] ({i}/{len(sessions)}) {sid}: {e}")
            results.append({
                "sessionId": sid, "path": str(path),
                "error": str(e), "status": "error",
            })
            err += 1

    logf = write_log(results)
    print(f"\n[=] 완료: 성공 {ok}, 실패 {err}, 로그 {logf}")
    return 0 if err == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
