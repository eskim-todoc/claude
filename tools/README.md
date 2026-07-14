# tools (공용 스크립트 · 자동화)

rules repo의 공용 스크립트·자동화 보관소. 실행 파일은 여기에, 각 도구의 설정·사용법 설명 문서는 `지침/설정/`에 둔다.

| 파일 | 용도 | 트리거 |
|---|---|---|
| [`slack-notify.ps1`](slack-notify.ps1) | Stop 훅에서 호출 — 작업 완료 시 Slack DM 알림 | `.claude/settings.json` Stop 훅 (자동) |
| [`check-links.ps1`](check-links.ps1) | 결정론적 마크다운 상대링크 실존 검사 (온디맨드 무결성) | 수동 / 온디맨드 검증 시 |
| [`rename_sessions.py`](rename_sessions.py) | Claude Code Desktop 세션 제목 일괄 요약 변경 | 수동 실행 (`rename_sessions.README.md` 참조) |
| `rename_sessions.README.md` | `rename_sessions.py` 사용법 | — |
| `requirements-rename-sessions.txt` | `rename_sessions.py` 파이썬 의존성 | — |
| `credentials/` | 서비스별 인증 토큰·SSH 키(anthropic·github·slack) — **gitignored**, 로컬 전용 | slack-notify·rename_sessions·git remote(SSH) |

## check-links.ps1

```powershell
powershell -NoProfile -File tools/check-links.ps1              # 기본: 지침/·CLAUDE.md·tasks 인덱스
powershell -NoProfile -File tools/check-links.ps1 -Include 지침 # 대상 지정
```

모든 `.md`의 마크다운 링크 `[..](경로)`를 파싱해 상대경로가 실제 파일로 해석되는지 검사한다. 코드펜스·인라인코드 안 예시 링크와 외부 URL·순수 앵커는 제외. bare 상대링크(디렉토리 접두어 없는 파일명)까지 잡아 단순 grep의 사각지대를 보완한다. 깨진 링크가 있으면 목록 출력 + exit 1.

## Git remote SSH 배선

전 GitHub repo remote를 HTTPS→SSH로 전환하고 `credentials/github/ssh-key`로 인증한다(2026-07-14~). 실제 키·상세 절차는 `credentials/README.md`(gitignored)에 있고, 재현 절차 요지는:

1. `git remote set-url origin git@github.com:<owner>/<repo>.git`
2. `git config core.sshCommand 'ssh -i "E:/workspace/rules/tools/credentials/github/ssh-key" -o IdentitiesOnly=yes'`
3. 검증 — `git ls-remote origin HEAD` 성공 또는 `ssh -T git@github.com` → `Hi eskim-todoc!`

공개키 `ssh-key.pub`은 GitHub `eskim-todoc` 계정에 등록됨. GitLab(sullivan-1-5-fw)은 미등록으로 HTTPS 유지. `core.sshCommand`는 각 repo `.git/config`에 로컬 저장(비추적)이라 클론·환경 재구성 시 위 절차를 재수행한다.

## 설정·사용법 문서 위치

- Slack 알림 배선·트러블슈팅: [`지침/설정/Slack 알림.md`](../지침/설정/Slack%20알림.md)
- statusline·스피너 한글 설정: [`지침/설정/Statusline·스피너 설정.md`](../지침/설정/Statusline·스피너%20설정.md)
