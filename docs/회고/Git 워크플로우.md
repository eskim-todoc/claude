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

## 클론 후 claude_develop 자동 전환 (2026-04-17)

새 repo를 클론하거나 기존 repo의 초기 셋업을 끝낸 직후, 사용자가 지시하지 않아도 **기본적으로 `claude_develop` 브랜치로 체크아웃**해둔다. *"claude_develop으로 넘길까요?"* 같은 확인도 생략.

**Why:** Claude의 모든 작업은 `claude_` 접두사 브랜치에서 이루어지고, 실제 작업 시작점은 `claude_develop`이다. 클론 직후 `main`에 머물러 있으면 사용자가 매번 수동으로 전환 지시를 줘야 하므로 비효율적.

**How to apply:**
- `git clone` 직후 → 원격에 `claude_develop`이 있으면 바로 `git checkout claude_develop`
- 원격에 `claude_develop`이 없다면 사용자에게 생성 여부 확인 (`claude_main`에서 분기할지 등)
- 확인 질문(*"넘길까요?"*) 없이 수행하고, 결과만 보고
