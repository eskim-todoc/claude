# 설정 (환경설정)

**TL;DR**: 이 하네스의 환경설정 문서 모음 — Slack 완료 알림·statusline·스피너 한글화. 실행 스크립트는 `tools/`(slack-notify.ps1)와 사용자 홈(statusline.ps1)에 있고, 본 폴더는 **배선·설정 값·트러블슈팅**만 설명한다.

| 파일 | 내용 |
|---|---|
| [Slack 알림.md](Slack%20알림.md) | Stop 훅 → Slack DM 작업 완료 알림 배선·동작·트러블슈팅 |
| [완료 알림 팝업.md](완료%20알림%20팝업.md) | 작업 완료 시 우하단 커스텀 WPF 팝업(웜 페이퍼 테마) 배선·동작·트러블슈팅 |
| [Statusline·스피너 설정.md](Statusline·스피너%20설정.md) | 상태줄·스피너 한글화·언어 설정 (사용자 홈 전역 스코프) |
| [워크트리 설정.md](워크트리%20설정.md) | 배경 세션 자동 워크트리 격리 해제(`worktree.bgIsolation`) 전역·프로젝트 설정 |

> [!IMPORTANT]
> **설정 스코프 구분**:
> - **Slack 알림** = rules repo 내 **Project scope**(`.claude/settings.json` Stop 훅 + `tools/slack-notify.ps1` + `tools/credentials/slack/`)로 자기완결 — git 추적됨.
> - **statusline·스피너·언어** = 모든 세션 공통이라 **User scope**(`~/.claude/settings.json`·`~/.claude/statusline.ps1`)에 둔다. Claude Code 전역 규약상 위치가 고정이며 **git 추적 밖** — rules는 그 값을 문서로만 캡처한다(실행 파일을 tools/로 옮기지 않는 예외).
> - **워크트리(bgIsolation)** = 모든 프로젝트 공통 기본값이면 **User scope**(`~/.claude/settings.json`, git 밖), 프로젝트별로만 다르게 하려면 **Project scope**(`<repo>/.claude/settings.json`). 전역 값도 rules는 문서로만 캡처한다.

상위 인덱스: [`../README.md`](../README.md)
