---
name: Statusline·스피너 설정
purpose: 상태줄·스피너 동사·UI 언어 한글화 설정(사용자 홈 User scope) 캡처
type: 지침
applies_to: [root]
tags: [설정, statusline, spinner, 한글화, user-scope]
---

# Statusline·스피너 설정 (한글화)

**TL;DR**: 상태줄(statusline)·스피너 동사·UI 언어를 한글로 맞추는 설정. 모든 세션 공통이라 **사용자 홈 User scope**(`~/.claude/settings.json` + `~/.claude/statusline.ps1`)에 있고 git 추적 밖 — rules는 값만 캡처한다. Claude Code 전역 규약상 위치가 고정이라 tools/로 옮기지 않는다.

## 위치 (User scope, git 밖)

| 요소 | 위치 |
|---|---|
| statusline 스크립트 | `C:\Users\<사용자>\.claude\statusline.ps1` |
| 설정(statusLine·spinnerVerbs·language) | `C:\Users\<사용자>\.claude\settings.json` |

## 설정 값 (`~/.claude/settings.json`)

```jsonc
{
  "statusLine": { "type": "command", "command": "powershell -NoProfile -File C:/Users/<사용자>/.claude/statusline.ps1" },
  "language": "한국어",
  "spinnerVerbs": { "mode": "replace", "verbs": ["생각하는 중", "분석하는 중", "궁리하는 중", ...] }
}
```

- **language**: `한국어` — UI 문구 한글화.
- **spinnerVerbs**: `mode: replace`로 기본 영어 동사를 한글 27종으로 완전 대체(생각하는 중·분석하는 중·궁리하는 중·골몰하는 중·구상하는 중·숙고하는 중·다듬는 중·매만지는 중·엮어가는 중·짜맞추는 중 등).
- **statusLine**: PowerShell 스크립트 출력을 상태줄로. (모델·effort 색은 `effortLevel` 설정과 연동.)

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

새 PC에서는 `~/.claude/settings.json`에 위 키를 넣고 `statusline.ps1`을 같은 경로에 둔다. **자기설정 수정 가드**(Claude가 `~/.claude/settings.json`을 직접 Edit 불가 — `/update-config` 필요) 때문에 이 설정은 은수님이 직접 반영한다. statusline.ps1 원본은 rules에 사본을 두지 않으므로(현재), 필요 시 이 문서의 항목 명세로 재작성하거나 은수님 홈에서 복사한다.
