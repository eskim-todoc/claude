# Git 규칙

## 브랜치 모델

| 브랜치 | 용도 | 분기 원점 | 병합 대상 |
|---|---|---|---|
| `main` | 릴리즈 전용 (사용자 직접 관리) | — | — |
| `claude_main` | Claude 측 안정 브랜치 | `main` | `main` (사용자 승인 시) |
| `claude_develop` | 지속 개발 | `claude_main` | `claude_main` |
| `claude_feature_*` | 기능 구현/수정 | `claude_develop` | `claude_develop` |
| `claude_hotfix` | main 긴급 수정 | `claude_main` | `claude_main` + `claude_develop` |

## 브랜치 규칙
- `main`에 직접 커밋·푸시 **절대 금지**. 사용자가 릴리즈 시점에 직접 관리.
- Claude의 모든 작업은 `claude_` 접두사 브랜치에서 수행.
- 기능 개발: `claude_develop`에서 `claude_feature_<설명>` 분기 → 완료 후 `claude_develop`에 병합.
- 안정 병합: 사용자 요청 시 `claude_develop` → `claude_main` 병합.
- 긴급 수정: `claude_main`에서 `claude_hotfix` 분기 → 수정 후 양쪽에 병합.

## 병합 규칙
- **모든 병합은 `--no-ff`**(fast-forward 금지)로 수행. merge commit을 남겨서 이력 보존.
- 사용자가 명시적으로 요청할 때만 커밋 정리(squash/rebase).

## 작업 흐름 (기본: 브랜치 체크아웃)
1. 파일 수정 전, feature 브랜치 생성 후 `git checkout`으로 전환.
2. 작업 완료 후: 커밋 → **사용자 확인** → `--no-ff` 병합 → feature 브랜치 삭제.
3. 커밋 완료 후, 대상 브랜치에 병합하기 전에 **반드시 사용자에게 확인**을 받는다.

## 워크트리 (사용자 명시 요청 시에만)
- 사용자가 "워크트리로 작업"이라고 명시한 경우에만 워크트리 생성.
- 디렉토리 이름: `wt_<브랜치명>` 형식.
- 병합 완료 후 워크트리 제거. 병합 전 제거 금지 (커밋 유실 위험).

## Git Identity
- **Author/Committer**: `김은수 <eunsu.kim@to-doc.com>`
- AI 에이전트(Claude 등) 이름이나 이메일이 commit에 **절대 남아서는 안 됨**.
- `Co-Authored-By` 등 AI 관련 표시 **절대 금지**.
- `--author` 플래그로 임시 override 하지 말 것.

## 프로젝트별 적용
각 `projects/<이름>/` repo도 동일한 브랜치 모델과 작업 흐름 적용. 프로젝트 고유 사항은 해당 프로젝트 `CLAUDE.md`에 기술.

## 상세 Workflow 다이어그램
브랜치 흐름도·절차 다이어그램은 [`[지침][Git] 워크플로우.md`]([지침][Git]%20워크플로우.md) 참조.
