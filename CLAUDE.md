# Claude Project Context

Root: `E:\Claude` — 이 폴더를 복제하면 다른 환경에서도 컨텍스트 유지 가능.

## Layout

```
E:\Claude\
├── CLAUDE.md              이 파일 — 전역 진입점
├── .claude/memory/        장기 메모리
├── credentials/           서비스별 토큰 (gitignored)
├── projects/              제품별 독립 repo (gitignored)
│   └── Sound1/            E8300 embedded firmware
├── tools/                 공용 스크립트 · 자동화
├── scratch/               일회성 실험 (gitignored)
└── .gitignore
```

루트 Git은 `CLAUDE.md`, `.claude/memory/`, `tools/`를 추적. `credentials/`, `projects/`, `scratch/`는 `.gitignore`로 차단.

## Credentials
인증 정보는 `credentials/` 폴더에서 서비스별로 관리.

- GitHub: `credentials/github/classic.token`, `credentials/github/fine-grained.token`

## Projects
프로젝트(제품 모델)는 `projects/<이름>/` 폴더에서 **독립 repo**로 관리. 각 프로젝트 내 `CLAUDE.md`에서 프로젝트별 컨텍스트 관리.

- [Sound1](projects/Sound1/CLAUDE.md) — E8300 embedded firmware

### 프로젝트 내부 표준 구조
각 프로젝트 폴더는 다음 레이아웃을 따름:

```
projects/<이름>/
├── CLAUDE.md       프로젝트 컨텍스트
├── src/            펌웨어 / SW 코드
├── tests/          단위 · 통합 테스트
└── docs/           SW 문서 (파일명 prefix로 분류)
```

### 문서 파일명 prefix 컨벤션
`docs/` 안의 문서 파일명은 `[카테고리] 문서명.확장자` 형태로 작성. 카테고리는 회사 설계 단계와 매핑:

| Prefix | 회사 단계 / 성격 | 문서 예시 (회사 코드) |
|---|---|---|
| `[계획]` | 01_설계 계획 | SDP, SCMP, SCCP, SRMP, SPRP, SMP |
| `[입력]` | 02_설계 입력 | SR, SRS |
| `[분석]` | (비공식) 입력 → 설계 사이의 탐색·원인·구조 분석 | 현행 구조 분석, 원인 분석, 수정 방향 검토 |
| `[설계]` | 03_설계 출력 (아키텍처) | SAD |
| `[상세설계]` | 03_설계 출력 (상세설계·구현) | SDDD, SIP |
| `[기준]` | 03_설계 출력 (시험 기준서) | SITC, SSTC, SUVC |
| `[테스트]` | (비공식) 테스트 수행 메모·재현 스크립트·결과 기록 | 테스트 노트, 재현 절차 |
| `[검증]` | 04_설계 검증 | SVVR |
| `[이력]` | — | SRRH |
| `[메모]` | (비공식) | 작업 노트 · 초안 |

예시: `[계획] LED 제어.md`, `[입력] LED 요구사항.md`, `[분석] LED 운용 방식.md`

컨벤션은 강제 규칙이 아니라 가이드. 다른 prefix(`[리뷰]`, `[참고]` 등)도 자유롭게 사용 가능.

## 문서 작성 기본 포멧
**기본값**: 사용자가 명시적으로 다른 포멧(docx / xlsx / pdf / pptx / html 등)을 지정하지 않는 한, **모든 문서는 Markdown (`.md`)로 작성한다.** 예외 없음.

- 적용 범위: 일반 문서, 노트, 기획서, 설명서, 리포트, README, 회사 SW 문서(`[계획]`/`[입력]`/`[설계]`/`[기준]`/`[검증]` 등) 모두 포함
- 예외는 단 하나: 사용자가 "docx / xlsx / pdf / pptx / html로 만들어줘"라고 명시한 경우만 해당 포멧으로 작성
- Markdown으로 작성 시에는 표·코드 블록·링크 등 Markdown 기본 문법을 적극 활용
- 회사 공유폴더로 전달할 때 `.docx`/`.xlsx` 변환이 필요하면, 그시점에 사용자가 명시적으로 요청한다

## Git Workflow (전역 규칙)

### 브랜치 모델
| 브랜치 | 용도 | 분기 원점 | 병합 대상 |
|---|---|---|---|
| `main` | 릴리즈 전용 (사용자 직접 관리) | — | — |
| `claude_main` | Claude 측 안정 브랜치 | `main` | `main` (사용자 승인 시) |
| `claude_develop` | 지속 개발 | `claude_main` | `claude_main` |
| `claude_feature_*` | 기능 구현/수정 | `claude_develop` | `claude_develop` |
| `claude_hotfix` | main 긴급 수정 | `claude_main` | `claude_main` + `claude_develop` |

### 규칙
- `main`에 직접 커밋·푸시 절대 금지. 사용자가 릴리즈 시점에 직접 관리.
- Claude의 모든 작업은 `claude_` 접두사 브랜치에서 수행.
- 기능 개발: `claude_develop`에서 `claude_feature_<설명>` 분기 → 완료 후 `claude_develop`에 병합.
- 안정 병합: 사용자 요청 시 `claude_develop` → `claude_main` 병합.
- 긴급 수정: `claude_main`에서 `claude_hotfix` 분기 → 수정 후 `claude_main` + `claude_develop` 양쪽에 병합.
- **모든 병합은 `--no-ff` (fast-forward 금지)로 수행.** merge commit을 남겨서 분기·병합 이력을 보존한다.
- 사용자가 명시적으로 요청할 때만 커밋 정리(squash/rebase) 후 상위 브랜치에 병합·푸시.

### 작업 흐름 (기본: 브랜치 체크아웃)
- 파일 수정이 수반되는 작업을 시작하기 전에, feature 브랜치를 생성하고 `git checkout`으로 전환한다.
- IDE(Eclipse 등)가 프로젝트 디렉토리를 직접 참조하므로, 브랜치 체크아웃 방식이 실시간 빌드·테스트에 유리하다.
- 작업 완료 후 흐름: 커밋 → **사용자 확인** → 대상 브랜치에 `--no-ff` 병합 → feature 브랜치 삭제.
  - 커밋 완료 후, 대상 브랜치(claude_develop 등)에 병합하기 전에 **반드시 사용자에게 확인을 받는다.**
  - `--no-ff` 병합으로 merge commit이 남아 있으므로, 브랜치 삭제 후에도 `git log --graph`로 기능 단위 이력 확인 가능.

### 워크트리 운영 (사용자 명시 요청 시에만)
- **사용자가 "워크트리로 작업"이라고 명시한 경우에만** 워크트리를 생성한다.
- 워크트리 디렉토리 이름은 `wt_<브랜치명>` 형식으로 생성한다 (예: 브랜치 `claude_feature_led-control` → 워크트리 `wt_claude_feature_led-control`).
- 작업 완료 후 흐름: 커밋 → **사용자 확인** → 대상 브랜치에 `--no-ff` 병합 → 워크트리 제거(remove).
  - 병합 전에 워크트리를 제거하면 커밋이 유실되므로, 반드시 병합 완료 후 제거한다.

### 프로젝트별 적용
각 `projects/<이름>/` repo도 이 브랜치 모델과 작업 흐름을 동일하게 적용. 프로젝트 고유 사항(upstream 동기화 등)은 해당 프로젝트 `CLAUDE.md`에 기술.

## Git Identity (중요)
**모든 commit과 push의 author/committer는 아래 정보로 표시되어야 함.** AI 에이전트(Claude 등) 이름이나 이메일이 commit에 절대 남아서는 안 됨.

- Name: `김은수`
- Email: `eunsu.kim@to-doc.com`

### 적용 방식
1. **루트 `E:\Claude` repo와 각 `projects/<이름>` repo** 모두 위 identity로 설정되어 있어야 함.
2. Claude가 commit을 만들 때는 해당 repo에 설정된 local config를 사용하거나, 명시적으로 author를 지정:
   ```
   git -c user.name="김은수" -c user.email="eunsu.kim@to-doc.com" commit -m "..."
   ```
3. 새 프로젝트 repo를 추가할 때마다 해당 repo에 local config를 설정할 것:
   ```
   git config user.name "김은수"
   git config user.email "eunsu.kim@to-doc.com"
   ```
4. `--author` 플래그로 임시 override 하지 말 것. committer 정보가 섞이면 히스토리가 더러워짐.

## Tools
`tools/`는 공용 스크립트와 자동화 보관소. 예: 문서 템플릿 복사·파일명 규칙 자동 적용·프로젝트 간 공용 유틸.

## Scratch
`scratch/`는 일회성 실험·초안·임시 파일 공간. git 추적 안 됨. 가치 있는 결과물은 적절한 프로젝트나 `tools/`로 승격, 아니면 삭제.

## Memory
상세 내용은 `.claude/memory/` 참조.

- [GitHub 설정](.claude/memory/github.md)
- [사용자 선호](.claude/memory/preferences.md)
