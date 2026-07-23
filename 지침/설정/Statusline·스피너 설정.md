---
name: Statusline·스피너 설정
purpose: 상태줄·스피너 동사·UI 언어 한글화 설정(사용자 홈 User scope) 캡처
type: 지침
applies_to: [root]
tags: [설정, statusline, spinner, 한글화, user-scope, refreshInterval]
---

# Statusline·스피너 설정 (한글화)

**TL;DR**: 상태줄(statusline)·스피너 동사·UI 언어를 한글로 맞추는 설정. 모든 세션 공통이라 **사용자 홈 User scope**(`~/.claude/settings.json` + `~/.claude/statusline.ps1`)에 있고 git 추적 밖 — rules는 값만 캡처한다. 세션 시작 직후 상태줄이 비어 보이는 문제는 `refreshInterval`로 해결.

## 위치 (User scope, git 밖)

| 요소 | 위치 |
|---|---|
| statusline 스크립트 | `C:\Users\<사용자>\.claude\statusline.ps1` |
| 설정(statusLine·spinnerVerbs·language) | `C:\Users\<사용자>\.claude\settings.json` |

Claude Code 전역 규약상 위치가 고정이라 `tools/`로 옮기지 않는다 — rules는 값만 캡처한다.

## 설정 값 (`~/.claude/settings.json`)

```jsonc
{
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -File C:/Users/<사용자>/.claude/statusline.ps1",
    "refreshInterval": 3
  },
  "language": "한국어",
  "spinnerVerbs": { "mode": "replace", "verbs": ["생각하는 중", "분석하는 중", "궁리하는 중", ...] }
}
```

- **language**: `한국어` — UI 문구 한글화.
- **spinnerVerbs**: `mode: replace`로 기본 영어 동사를 한글 27종으로 완전 대체(생각하는 중·분석하는 중·궁리하는 중·골몰하는 중·구상하는 중·숙고하는 중·다듬는 중·매만지는 중·엮어가는 중·짜맞추는 중 등).
- **statusLine**: PowerShell 스크립트 출력을 상태줄로. (모델·effort 색은 `effortLevel` 설정과 연동.)
- **refreshInterval**: `3`(초) — 이벤트 기반 갱신에 **더해** N초마다 스크립트 재실행. 세션 시작 직후 상태줄이 비어 보이는 문제 해결(아래 §세션 시작 직후 표시).

## 세션 시작 직후 표시 (`refreshInterval`)

**증상**: `claude --bg ""`로 만든 백그라운드 세션을 `claude agents`로 열면 상태줄이 없고, 프롬프트를 1회 입력해야 나타난다.

**원인**: 상태줄 커맨드는 **컴포넌트 마운트 시 1회** 실행되고, 이후에는 **이벤트 기반**(메시지 ID·권한 모드·모델·effort·thinking·PR 상태 변경)으로만 재실행된다. idle 상태의 세션은 갱신 이벤트가 없어 초기 1회 결과에 머문다. 게다가 세션 시작 시점의 stdin JSON에는 `rate_limits`가 **아직 없어** 사용량 세그먼트가 통째로 빠진다.

**해결**: `refreshInterval`(공식 옵션, 최소 1초)을 주면 이벤트가 없어도 N초마다 재실행되어 상태줄이 채워지고 최신 상태로 유지된다.

**실측 근거** (2026-07-23, Claude Code 2.1.218):

| 조건 | 프롬프트 0회 상태의 상태줄 |
|---|---|
| `refreshInterval` 없음 | `cwd \| 모델 \| 브랜치 \| 컨텍스트: 0/1m` (사용량 세그먼트 누락, 이후 갱신 없음) |
| `refreshInterval: 3` | 위 + `5시간: 4% 7일: 15% \| 토큰 초기화: 13시 20분` (전 세그먼트 표시) |

> [!NOTE]
> 상태줄 실행을 막는 조건은 `disableAllHooks`(정책 설정)와 **workspace trust 미승인** 두 가지뿐이다. 상태줄이 아예 안 나오면 이 둘을 먼저 확인한다.

> [!TIP]
> `subagentStatusLine`은 별개 설정 — `claude agents` **패널의 각 행**에 붙는 per-subagent 표시줄이며, 세션 하단 상태줄과 무관하다.

## statusline.ps1 표시 항목

stdin(JSON)으로 받은 세션 정보를 파싱해 ` | ` 구분으로 한 줄 출력(ANSI 24bit 색):

| 세그먼트 | 내용 |
|---|---|
| cwd | 현재 작업 디렉토리(흰색) |
| 모델 [effort] | 모델명 + effort, effort별 색(low 파랑 → max 빨강) |
| 브랜치 | git 현재 브랜치(보라, detached HEAD·빈 브랜치는 생략) |
| 컨텍스트 | `컨텍스트: 사용/전체 (%)` — 사용률 그라디언트(초록→빨강) |
| 사용량 | `5시간: N% · 7일: N% · 토큰 초기화: H시 M분` — 한글 시각 |

## 새 환경 재현

새 PC에서는 `~/.claude/settings.json`에 위 키를 넣고 `statusline.ps1`을 같은 경로에 둔다. `~/.claude/settings.json` 수정은 **`update-config` 스킬을 먼저 로드한 뒤** Claude가 직접 반영한다(2026-07-23 실적 — 스킬 없이 임의 편집 금지). statusline.ps1 원본은 rules에 사본을 두지 않으므로(현재), 필요 시 이 문서의 항목 명세로 재작성하거나 은수님 홈에서 복사한다.

> [!WARNING]
> PowerShell 5.1의 `Get-Content -Raw | ConvertFrom-Json`은 UTF-8 파일을 ANSI로 읽어 한글이 깨지고 파싱이 실패한다. 검증은 `[System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)`로 읽어서 한다.
