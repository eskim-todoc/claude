---
name: Git 워크플로우 회고
purpose: 브랜치 모델·병합·클론 절차 학습 누적
type: 회고
tags: [git, branch, merge, workflow, clone]
---

# Git 워크플로우 회고

**TL;DR**: `claude_*` 브랜치 체계, 모든 병합 `--no-ff` + 사용자 승인 후, 클론 직후 자동으로 `claude_develop` 체크아웃 (확인 생략).

브랜치 모델, 병합, 클론 절차 관련 학습.

## Git 브랜치 워크플로우 (2026-04-17)

루트 repo(`E:\Claude`) 및 각 프로젝트 repo 공통 브랜치 모델:

| 브랜치 | 용도 | 분기 원점 | 병합 대상 |
|---|---|---|---|
| `main` | 릴리즈 전용 (사용자 직접 관리) | — | — |
| `claude_main` | Claude 측 안정 브랜치 | `main` | `main` (사용자 승인 시) |
| `claude_develop` | 지속 개발 | `claude_main` | `claude_main` |
| `claude_feature_*` | 기능 구현/수정 | `claude_develop` | `claude_develop` |
| `claude_hotfix` | main 긴급 수정 | `claude_main` | `claude_main` + `claude_develop` |

**Why:** main을 릴리즈 전용으로 보호하면서, Claude 작업은 `claude_` 접두사 브랜치 체계로 분리 운영.

**How to apply:**
- 기본 작업 방식: feature 브랜치 생성 → `git checkout` → 작업 (IDE 실시간 빌드·테스트 호환)
- 워크트리는 사용자가 *"워크트리로 작업"*이라고 명시한 경우에만 사용
- 모든 병합은 `--no-ff`로 수행 (merge commit 보존 → 브랜치 삭제 후에도 이력 추적 가능)
- 작업 완료 흐름: 커밋 → 사용자 확인 → `--no-ff` 병합 → 브랜치 삭제
- 단순 조회/질문은 브랜치 생성 없이 가능

상세: [`docs/지침/Git/브랜치, 병합 규칙.md`](../지침/Git/브랜치,%20병합%20규칙.md), [`docs/지침/Git/워크플로우.md`](../지침/Git/워크플로우.md)

## 병합 전 사용자 승인 필수 (2026-04-17)

작업 후 커밋까지 했으면, `claude_develop`에 병합하기 전에 반드시 사용자에게 확인을 받는다.

**Why:** 사용자가 커밋 내용을 검토하고 병합 여부를 직접 판단하고 싶어함. 자동으로 병합까지 진행하면 원치 않는 변경이 develop에 들어갈 수 있음.

**How to apply:** 커밋 완료 후 *"커밋 완료했습니다. claude_develop에 병합할까요?"*와 같이 확인을 요청하고, 승인 후에만 병합 진행.

## `.gitignore` whitelisting + `git rm --cached` 머지 사이클 함정 (2026-05-08)

폴더 구조는 git에 유지하면서 안의 운용 데이터는 추적 안 하고 싶을 때 다음 둘이 한 세트:

1. **`.gitignore` whitelisting 패턴**: 디렉토리 통째 ignore하면 `.gitkeep` 같은 자식을 negation으로 살릴 수 없다 — 반드시 `dir/*` (디렉토리 *내용*) + `!dir/.gitkeep` 형태.
2. **`git rm --cached`의 머지 시점 효과**: `--cached`는 그 commit *작성 시점*의 working tree만 보호한다. 다른 브랜치(예: `claude_develop`)에서 추적 중이던 파일이 untrack commit과 함께 머지되면, **머지 시점에 working tree에서도 삭제**된다. 단순 cached 해제와 다른 동작 — 운용 데이터를 working tree에 남기려는 의도가 깨질 수 있다.

**Why:** sound1-fw-extractor 작업(2026-05-08) — `src/in/`·`src/out/`을 폴더만 유지하고 안 데이터는 ignore하기 위해:

- 1차 시도: `.gitignore`에 `src/in/` `src/out/` (디렉토리 통째) + `!src/in/.gitkeep` `!src/out/.gitkeep`. **`git add src/in/.gitkeep`이 거부**됨 — git의 알려진 제약: 부모 디렉토리가 ignore되면 자식 negation 무효. `src/in/*` (와일드카드, 내용만) + `!src/in/.gitkeep`로 수정해야 정상 동작.
- 2차 시도: feature 브랜치에서 `git rm --cached` 후 commit (working tree 데이터 보존됨), 머지하려 `git checkout claude_develop` → 머지. **머지 후 working tree의 데이터 파일들이 사라짐**. develop에서 추적 중이던 상태와 머지된 untrack 변경이 동기화되며 발생. 사용자가 "그때그때 바뀐다"고 의도했으니 실제 영향은 없었지만, **데이터 보존 의도였다면 손실 위험**.

**How to apply:**

- **whitelisting 패턴 작성 시**:
  - `dir/` ❌ (폴더 통째 — negation 무효)
  - `dir/*` ✅ (내용만 — `.gitkeep` 등 negation 가능)
  - 작성 후 즉시 검증: `git check-ignore -v <test_file>` `<keepfile>`로 두 케이스 모두 확인
- **`git rm --cached`로 untrack할 때 사용자에게 사전 고지 의무**:
  - 머지 단계에서 다른 브랜치의 working tree에서도 파일이 사라짐
  - 운용 데이터 보존이 필요하면 머지 전에 별도 백업(예: 다른 폴더로 복사) 또는 `git stash`로 격리
  - 데이터를 git history에서 복원하려면 `git show <pre-untrack-commit>:<path> > <path>` 형태
- **검증 도구가 untrack된 baseline에 의존하는 경우**:
  - `tests/test_extract.py`처럼 `src/out/` 정답에 의존하면, 새 clone·새 환경에서 test 실행 불가
  - commit 메시지에 *"새 clone에서 검증 실행 시 baseline 별도 준비 필요"* 명시
  - 또는 별도 fixture 폴더(`tests/fixtures/` 등)에 정답 보관해 추적 유지 (운용 데이터와 분리)
- **데이터·코드 분리 설계**: 운용 데이터(매번 바뀜)와 코드(안정)는 폴더 자체를 분리. 같은 폴더에 섞지 않으면 ignore 패턴 단순화 + 검증 baseline 보존.

## 클론 후 claude_develop 자동 전환 (2026-04-17)

새 repo를 클론하거나 기존 repo의 초기 셋업을 끝낸 직후, 사용자가 지시하지 않아도 **기본적으로 `claude_develop` 브랜치로 체크아웃**해둔다. *"claude_develop으로 넘길까요?"* 같은 확인도 생략.

**Why:** Claude의 모든 작업은 `claude_` 접두사 브랜치에서 이루어지고, 실제 작업 시작점은 `claude_develop`이다. 클론 직후 `main`에 머물러 있으면 사용자가 매번 수동으로 전환 지시를 줘야 하므로 비효율적.

**How to apply:**
- `git clone` 직후 → 원격에 `claude_develop`이 있으면 바로 `git checkout claude_develop`
- 원격에 `claude_develop`이 없다면 사용자에게 생성 여부 확인 (`claude_main`에서 분기할지 등)
- 확인 질문(*"넘길까요?"*) 없이 수행하고, 결과만 보고
