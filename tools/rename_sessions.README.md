---
name: rename_sessions.py — 세션 제목 일괄 요약 변경
purpose: Claude Code Desktop 세션 JSONL을 읽어 Haiku로 한국어 제목 생성·append
type: 사용방법
applies_to: [root]
tags: [tool, claude-code, session, batch-rename]
---

# rename_sessions.py

**TL;DR**: `%USERPROFILE%\.claude\projects\<프로젝트>\<sessionId>.jsonl`을 전수 스캔 → Claude Haiku 4.5로 한국어 제목(≤30자) 생성 → 각 JSONL 끝에 `custom-title` 한 줄 append (원본 대화 무손상). Desktop app이 가장 최근 `custom-title`을 우선 표시.

Claude Code Desktop app에 쌓인 모든 세션의 제목을, 대화 내용을 짧게 요약한 문구로 **일괄** 변경하는 스크립트입니다.

## 개요

- **대상**: `%USERPROFILE%\.claude\projects\<프로젝트>\<sessionId>.jsonl` 전부
- **동작**: 각 세션 JSONL을 읽어 Claude Haiku 4.5로 한국어 제목(≤30자)을 생성 → 파일 끝에 `custom-title` 한 줄 append
- **원본 대화 이력은 건드리지 않음** (append-only; `/compact` 미실행)
- 기존 `ai-title` / `custom-title` 존재 여부와 무관하게 항상 덮어씀 (Desktop app은 가장 최근의 `custom-title`을 우선)

## 사전 준비

### 1. Python 의존성 설치 (최초 1회)

```powershell
pip install -r E:\workspace\rules\tools\requirements-rename-sessions.txt
```

### 2. API 키 주입

[Anthropic Console](https://console.anthropic.com)에서 API 키(`sk-ant-api03-...`)를 발급받아 아래 두 방법 중 하나로 주입합니다.

**방법 A — 환경변수 (이 셸 세션 한정)**

```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-api03-..."
```

**방법 B — fallback 파일 (영구)**

```powershell
New-Item -ItemType Directory -Force -Path E:\workspace\rules\credentials\anthropic | Out-Null
Set-Content -Path E:\workspace\rules\credentials\anthropic\api.key -Value "sk-ant-api03-..." -NoNewline
```

프로젝트 루트의 `.gitignore`가 `credentials/` 폴더를 제외하므로 키는 버전 관리에 포함되지 않습니다.

> [!WARNING]
> **Agent SDK / Claude Code OAuth 토큰은 사용할 수 없습니다.** Agent SDK의 `query()`는 내부적으로 `claude` CLI 프로세스를 spawn하는 구조인데 현재 환경에 `claude` CLI가 없습니다. `CLAUDE_CODE_OAUTH_TOKEN`도 공식 `anthropic` SDK가 직접 읽지 않는 내부용 토큰입니다. 반드시 standalone API 키를 사용하세요.

### 3. Claude Code Desktop app 종료

스크립트가 각 JSONL 파일 끝에 한 줄을 append합니다. Desktop app이 실행 중이면 Windows 파일 락으로 append가 실패할 수 있으므로 작업 전 종료하세요.

## 사용법

### 드라이런 (기본값) — 어떤 이름으로 바뀔지 미리보기

```powershell
python E:\workspace\rules\tools\rename_sessions.py
# 또는
python E:\workspace\rules\tools\rename_sessions.py --dry-run
```

출력 예시:

```
[i] 대상 세션 26개 (모드: DRY-RUN)
[DRY] (1/26) 18769da6-ac3e-47aa-a1e9-0c65cc11b176 -> JLink 자동 재연결
[DRY] (2/26) ...
[=] 완료: 성공 26, 실패 0, 로그 E:\workspace\rules\tools\.logs\rename_sessions_20260424_153022.log
```

### 소량 테스트 (3개만, 백업 포함)

```powershell
python E:\workspace\rules\tools\rename_sessions.py --apply --backup --max-sessions 3
```

### 전체 적용

```powershell
python E:\workspace\rules\tools\rename_sessions.py --apply --backup
```

### 옵션

| 옵션 | 설명 |
|---|---|
| `--dry-run` | 실제 쓰기 없이 매핑만 출력 (기본값) |
| `--apply` | 실제로 세션 파일에 `custom-title` 라인 추가 |
| `--backup` | `--apply` 시 projects 디렉토리를 타임스탬프 붙은 폴더로 복사 |
| `--no-backup` | `--apply` 시 백업 없이 강행 (권장하지 않음) |
| `--projects-dir <PATH>` | 세션 디렉토리 경로 재정의 (기본: `%USERPROFILE%\.claude\projects`) |
| `--max-sessions N` | 처리할 세션 최대 개수 (0 = 제한 없음) |

`--apply` 사용 시 `--backup` 또는 `--no-backup` 중 하나를 **반드시 명시**해야 합니다.

## 동작 방식

1. `<projects>\*\*.jsonl` 전체 수집 (수정 시각 내림차순)
2. 각 JSONL 라인별로 `user` / `assistant` 메시지만 필터 (`isMeta`, system-reminder 래핑 메시지 제외)
3. 샘플링: **첫 사용자 메시지** + **마지막 assistant 메시지 1~2개** (각 3,000자 캡)
4. Claude Haiku 4.5로 한국어 30자 이내 제목 생성 (`<title>...</title>` 태그 파싱)
5. `--apply`이면 파일 끝에 다음 JSON 한 줄 append:

   ```json
   {"type":"custom-title","customTitle":"제목","sessionId":"<uuid>"}
   ```

6. 로그 파일: `E:\workspace\rules\tools\.logs\rename_sessions_YYYYMMDD_HHMMSS.log` (JSONL)

## 검증

1. **드라이런 개수 확인**: 출력의 세션 수가 `dir /s /b C:\Users\<user>\.claude\projects\*.jsonl | measure` 결과와 일치
2. **소량 적용 후 파일 검증**:
   - 백업 폴더 `projects.bak-<ts>\` 존재
   - 대상 JSONL 마지막 줄: `Get-Content <path> -Tail 1` → `{"type":"custom-title",...}`
   - 총 라인 수 = 기존 + 1 (원본 보존 확인)
3. **Desktop app 재실행**: 좌측 세션 목록에 새 제목 표시, 세션 열어 대화 이력 누락 없는지 육안 확인

## 복구 (롤백)

백업을 만들었다면 폴더 교체로 즉시 원복:

```powershell
Remove-Item -Recurse -Force C:\Users\<user>\.claude\projects
Rename-Item -Path C:\Users\<user>\.claude\projects.bak-<타임스탬프> -NewName projects
```

백업 없이 적용했다면 각 JSONL의 마지막 `custom-title` 라인을 수동 삭제해야 합니다. (이것이 `--backup`을 **강력 권장**하는 이유입니다.)

## 주의사항

- **파일 락**: Desktop app이 열려 있으면 쓰기가 실패할 수 있음. 반드시 종료 후 실행.
- **API 비용**: Haiku 4.5 기준, 세션 수십 개 × 수백 토큰 ≈ 센트 단위 소액. 시스템 프롬프트의 prompt caching으로 비용·지연 축소.
- **재실행 안전성**: 여러 번 실행하면 JSONL 마지막에 `custom-title` 라인이 누적되지만, Desktop app은 가장 마지막 라인만 사용하므로 기능상 문제 없음. 다만 파일이 불필요하게 길어지므로 잦은 재실행은 피하는 편이 좋음.
- **빈 세션**: 대화가 없는 세션은 `빈 세션`이라는 제목으로 처리됨.
