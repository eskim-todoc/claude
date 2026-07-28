# tools (공용 스크립트 · 자동화)

rules repo의 공용 스크립트·자동화 보관소. 실행 파일은 여기에, 각 도구의 설정·사용법 설명 문서는 `지침/설정/`에 둔다.

| 파일 | 용도 | 트리거 |
|---|---|---|
| [`slack-notify.ps1`](slack-notify.ps1) | Stop 훅에서 호출 — 작업 완료 시 Slack DM 알림 | `.claude/settings.json` Stop 훅 (자동) |
| [`check-links.ps1`](check-links.ps1) | 결정론적 마크다운 상대링크 실존 검사 (온디맨드 무결성) | 수동 / 온디맨드 검증 시 |
| [`rename_sessions.py`](rename_sessions.py) | Claude Code Desktop 세션 제목 일괄 요약 변경 | 수동 실행 (`rename_sessions.README.md` 참조) |
| `rename_sessions.README.md` | `rename_sessions.py` 사용법 | — |
| `requirements-rename-sessions.txt` | `rename_sessions.py` 파이썬 의존성 | — |
| `credentials/` | 서비스별 인증 토큰·SSH 키(anthropic·github·gitlab·slack) — **gitignored**, 로컬 전용 | slack-notify·rename_sessions·git remote(SSH) |

## check-links.ps1

```powershell
powershell -NoProfile -File tools/check-links.ps1              # 기본: 지침/·CLAUDE.md·tasks 인덱스
powershell -NoProfile -File tools/check-links.ps1 -Include 지침 # 대상 지정
```

모든 `.md`의 마크다운 링크 `[..](경로)`를 파싱해 상대경로가 실제 파일로 해석되는지 검사한다. 코드펜스·인라인코드 안 예시 링크와 외부 URL·순수 앵커는 제외. bare 상대링크(디렉토리 접두어 없는 파일명)까지 잡아 단순 grep의 사각지대를 보완한다. 깨진 링크가 있으면 목록 출력 + exit 1.

## Git remote SSH 배선

repo remote는 SSH로 인증하며, **키는 호스트별로 분리**한다. 실제 키·상세 절차는 `credentials/README.md`(gitignored)에 있다.

| 호스트 | 사용할 키 | remote 형식 | 등록 계정 | 배선 시점 |
|---|---|---|---|---|
| GitHub | `credentials/github/ssh-key` | `git@github.com:<owner>/<repo>.git` | `eskim-todoc` | 2026-07-14~ |
| GitLab | `credentials/gitlab/ssh-key` | `git@gitlab.com:<owner>/<repo>.git` | `kes0481_todoc` | 2026-07-28~ |

> [!IMPORTANT]
> **GitLab 저장소에는 반드시 `credentials/gitlab/ssh-key`를 쓴다.** 두 공개키는 각자 호스트 계정에만 등록돼 있어 교차 사용하면 인증에 실패한다(GitHub 키로 GitLab 접근 불가, 그 반대도 동일).

재현 절차:

1. remote 전환 — `git remote set-url origin git@<호스트>:<owner>/<repo>.git`
2. 키 배선 — `git config core.sshCommand 'ssh -i "E:/workspace/rules/tools/credentials/<github|gitlab>/ssh-key" -o IdentitiesOnly=yes'`
3. 검증 — `git ls-remote origin HEAD` 성공, 또는 `ssh -T git@github.com` → `Hi eskim-todoc!` / `ssh -T git@gitlab.com` → `Welcome to GitLab, @kes0481_todoc!`

`core.sshCommand`는 각 repo `.git/config`에 로컬 저장(비추적)이라 클론·환경 재구성 시 위 절차를 재수행한다.

## 설정·사용법 문서 위치

- Slack 알림 배선·트러블슈팅: [`지침/설정/Slack 알림.md`](../지침/설정/Slack%20알림.md)
- statusline·스피너 한글 설정: [`지침/설정/Statusline·스피너 설정.md`](../지침/설정/Statusline·스피너%20설정.md)
