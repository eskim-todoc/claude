# GitHub

## Tokens
- Classic token: `E:/workspace/rules/credentials/github/classic.token`
- Fine-grained token: `E:/workspace/rules/credentials/github/fine-grained.token`
- 개인계정(`eskim-todoc`)과 조직계정(`todoc-dev`) 모두 동일 토큰으로 접근 가능

## Remote URL 규칙
- 이 환경은 토큰을 URL에 임베드하는 방식 사용: `https://{token}@github.com/{owner}/{repo}.git`
- 새 repo 추가 시 같은 방식으로 세팅. 토큰을 명령에 하드코딩하지 말고 파일·기존 remote에서 추출:
  ```bash
  TOKEN=$(cd E:/workspace/projects/Sound1 && git config --get remote.origin.url | sed -E 's|https://([^@]+)@.*|\1|')
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
- **eskim-todoc/claude** — rules 헌법·지침 저장소 (로컬 `E:\workspace\rules`, claude_main 브랜치)
- **eskim-todoc/sound1-fw-e8300** — Sound1 펌웨어 **origin** (본인 소유, claude_main / Develop)
- **todoc-dev/sound1-fw-e8300** — Sound1 펌웨어 **upstream** (원본, PR 기여 대상)
- **eskim-todoc/sound1-fw-extractor** — Sound1 FW Ezairo 영역 텍스트→바이너리 4종 추출 (claude_main / claude_develop)

## Fork-and-PR 패턴 (upstream push 권한 제한 시)
원본이 조직 저장소이고 직접 push 권한이 제한될 때 사용하는 2-remote 구조. **Sound1**이 이 패턴 적용 중.

- `origin` = 본인 저장소 (평소 push 자유)
- `upstream` = 원본 저장소 (PR 대상, 읽기 위주)
- 로컬 `Develop`은 `upstream/Develop`과 항상 동기화 유지 (PR base, 공통 조상 확보가 핵심)
- 일상 작업은 `claude_main`에 통합 → `origin` push
- 원본 기여: GitHub 웹에서 `{본인}/{repo}:claude_main` → `{조직}/{repo}:Develop` cross-repo PR 생성
- 빈 repo로 만든 경우 공식 fork 관계는 없지만 공통 커밋 조상만 있으면 PR 가능

### 새 repo에 이 패턴 적용하는 절차
```bash
# 기존 origin (원본)을 upstream으로 rename
git remote rename origin upstream

# 본인 저장소를 새 origin으로 등록 (토큰은 기존 remote에서 추출 — 평문 노출 금지)
TOKEN=$(git config --get remote.upstream.url | sed -E 's|https://([^@]+)@.*|\1|')
git remote add origin "https://${TOKEN}@github.com/{본인}/{repo}.git"

# Develop과 작업 브랜치를 origin에 push
git push -u origin Develop
git push -u origin claude_main
```

## Organizations
- eskim-todoc (개인)
- todoc-dev (조직)
