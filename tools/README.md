# tools (공용 스크립트 · 자동화)

rules repo의 공용 스크립트·자동화 보관소. 실행 파일은 여기에, 각 도구의 설정·사용법 설명 문서는 `지침/설정/`에 둔다.

| 파일 | 용도 | 트리거 |
|---|---|---|
| [`slack-notify.ps1`](slack-notify.ps1) | Stop 훅에서 호출 — 작업 완료 시 Slack DM 알림 | `.claude/settings.json` Stop 훅 (자동) |
| [`check-links.ps1`](check-links.ps1) | 결정론적 마크다운 상대링크 실존 검사 (온디맨드 무결성) | 수동 / 온디맨드 검증 시 |
| [`rename_sessions.py`](rename_sessions.py) | Claude Code Desktop 세션 제목 일괄 요약 변경 | 수동 실행 (`rename_sessions.README.md` 참조) |
| `rename_sessions.README.md` | `rename_sessions.py` 사용법 | — |
| `requirements-rename-sessions.txt` | `rename_sessions.py` 파이썬 의존성 | — |

## check-links.ps1

```powershell
powershell -NoProfile -File tools/check-links.ps1              # 기본: 지침/·CLAUDE.md·tasks 인덱스
powershell -NoProfile -File tools/check-links.ps1 -Include 지침 # 대상 지정
```

모든 `.md`의 마크다운 링크 `[..](경로)`를 파싱해 상대경로가 실제 파일로 해석되는지 검사한다. 코드펜스·인라인코드 안 예시 링크와 외부 URL·순수 앵커는 제외. bare 상대링크(디렉토리 접두어 없는 파일명)까지 잡아 단순 grep의 사각지대를 보완한다. 깨진 링크가 있으면 목록 출력 + exit 1.

## 설정·사용법 문서 위치

- Slack 알림 배선·트러블슈팅: `지침/설정/Slack 알림.md`
- statusline·스피너 한글 설정: `지침/설정/Statusline·스피너 설정.md`

(위 문서는 `지침/설정/` 폴더에 있다.)
