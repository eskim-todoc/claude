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

| Prefix | 회사 단계 | 문서 예시 (회사 코드) |
|---|---|---|
| `[계획]` | 01_설계 계획 | SDP, SCMP, SCCP, SRMP, SPRP, SMP |
| `[입력]` | 02_설계 입력 | SR, SRS |
| `[설계]` | 03_설계 출력 | SAD, SDDD, SIP |
| `[기준]` | 03_설계 출력 (시험 기준서) | SITC, SSTC, SUVC |
| `[검증]` | 04_설계 검증 | SVVR |
| `[이력]` | — | SRRH |
| `[메모]` | (비공식) | 작업 노트 · 초안 |

예시: `[계획] LED 제어.docx`, `[입력] LED 요구사항.xlsx`

컨벤션은 강제 규칙이 아니라 가이드. 다른 prefix(`[리뷰]`, `[참고]` 등)도 자유롭게 사용 가능.

## Git Workflow (전역 규칙)
- 모든 작업은 `claude_<설명>` 형태의 브랜치에서 수행 (예: `claude_fix-dma`, `claude_add-filter`).
- 메인 브랜치(`main` / `master` / `Develop` 등)에 직접 커밋·푸시 금지.
- 현재 브랜치가 `claude_` 접두사가 아니면 작업 전 새 브랜치 생성.
- 사용자가 명시적으로 요청할 때만 그동안의 커밋을 정리(squash/rebase)해서 메인 브랜치에 병합·푸시.

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
