# GitHub

## Tokens
- Classic token: `E:/Claude/credentials/github/classic.token`
- Fine-grained token: `E:/Claude/credentials/github/fine-grained.token`
- 개인계정(`eskim-todoc`)과 조직계정(`todoc-dev`) 모두 동일 토큰으로 접근 가능

## Remote URL 규칙
- 이 환경은 토큰을 URL에 임베드하는 방식 사용: `https://{token}@github.com/{owner}/{repo}.git`
- 새 repo 추가 시 같은 방식으로 세팅. 토큰을 명령에 하드코딩하지 말고 파일·기존 remote에서 추출:
  ```bash
  TOKEN=$(cd E:/Claude/projects/Sound1 && git config --get remote.origin.url | sed -E 's|https://([^@]+)@.*|\1|')
  git remote set-url origin "https://${TOKEN}@github.com/{owner}/{repo}.git"
  ```

## 보안 — 토큰 출력 시 마스킹 (필수)
- `git remote -v`, `git config --get remote.origin.url` 결과는 토큰을 **평문 포함** → 그대로 대화·로그에 출력하지 말 것
- 출력이 필요하면 반드시 파이프로 마스킹:
  ```bash
  git remote get-url origin | sed 's|https://[^@]*@|https://***@|'
  ```
- 한 번 노출된 토큰은 회수 불가. 실수로 노출 시 사용자에게 즉시 알리고 토큰 재발급 권고.

## Repositories
- **eskim-todoc/Claude** — E:\Claude 루트 설정 저장소 (claude_main 브랜치)
- **eskim-todoc/sullivan1.5-fw-download** — Sullivan 1.5세대 FW 다운로드 GUI (claude_main 브랜치)
- **todoc-dev/sound1-fw-e8300** — Sound1 펌웨어 (Develop 브랜치)

## Organizations
- eskim-todoc (개인)
- todoc-dev (조직)
