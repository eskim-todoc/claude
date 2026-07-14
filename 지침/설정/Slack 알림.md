---
name: Slack 알림
purpose: Stop 훅 기반 Slack DM 작업 완료 알림 배선·동작·트러블슈팅
type: 지침
applies_to: [root]
tags: [설정, slack, hook, notification]
---

# Slack 알림 (작업 완료 DM)

**TL;DR**: Claude Code가 응답을 마칠 때(Stop 훅) `tools/slack-notify.ps1`이 transcript의 마지막 assistant 텍스트 첫 줄을 추출해 `✅ {요약}` 형태로 Slack DM에 보낸다. 배선은 rules repo `.claude/settings.json` Stop 훅, webhook은 `tools/credentials/slack/webhook.url`(gitignored). webhook 파일이 없으면 조용히 종료(silent) — 알림이 안 오면 여기부터 점검.

## 구성 요소 (Project scope, git 추적)

| 요소 | 위치 | 역할 |
|---|---|---|
| 훅 배선 | `.claude/settings.json` → `Stop` 훅 | 응답 종료 시 스크립트 호출(`async: true`) |
| 실행 스크립트 | [`../../tools/slack-notify.ps1`](../../tools/slack-notify.ps1) | transcript 파싱 → Slack POST |
| webhook URL | `tools/credentials/slack/webhook.url` | Slack Incoming Webhook (gitignored) |

## 동작

1. Stop 훅이 transcript 경로를 stdin(JSON)으로 스크립트에 전달.
2. 스크립트가 마지막 `assistant` 메시지의 text 블록 **첫 줄**을 추출(마크다운 기호 제거·140자 컷). 없으면 마지막 사용자 메시지로 폴백.
3. `✅ {요약}`을 webhook URL로 POST.

> [!TIP]
> 응답 말미에 명사구 한 줄 요약을 남기는 컨벤션([`../일반/커뮤니케이션 규칙.md`](../일반/커뮤니케이션%20규칙.md))이 이 알림의 품질을 좌우한다 — 첫 줄이 곧 알림 본문이 되기 때문.

> [!NOTE]
> 같은 Stop 훅에서 **우하단 커스텀 팝업**(웜 페이퍼 테마)도 병행 표시된다 — Slack DM은 그대로 유지하고 PC에 추가로 띄운다. 상세: [`완료 알림 팝업.md`](완료%20알림%20팝업.md).

## 트러블슈팅

- **알림이 안 온다**: 스크립트는 webhook 파일이 없거나(`Test-Path` 실패) POST 실패 시 **`exit 0`으로 조용히 종료**(silent failure)한다. 먼저 `tools/credentials/slack/webhook.url` 존재를 확인하라.
- **경로 이동 후**: credentials나 스크립트 위치가 바뀌면 `slack-notify.ps1` L4의 상대경로(`$PSScriptRoot\credentials\slack\webhook.url`)와 `.claude/settings.json` 훅의 `-File` 경로를 함께 갱신하고, 1회 수동 트리거로 수신을 확인한다(silent라 테스트 없이는 회귀를 못 잡음).
