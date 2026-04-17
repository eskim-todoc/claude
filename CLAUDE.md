# Claude Project Context

> **작업 전 필수 참조**: [`docs/[지침] 작업 규칙.md`](docs/[지침]%20작업%20규칙.md) — 모든 작업을 시작하기 전에 반드시 확인할 것.

Root: `E:\Claude` — 이 폴더를 복제하면 다른 환경에서도 컨텍스트 유지 가능.

## Layout

```
E:\Claude\
├── CLAUDE.md              이 파일 — 전역 진입점
├── .claude/memory/        장기 메모리
├── credentials/           서비스별 토큰 (gitignored)
├── projects/              제품별 독립 repo (gitignored)
│   └── Sound1/            E8300 embedded firmware
├── docs/                  전역 공용 문서 (네이밍 컨벤션 등)
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

## 지침 문서
작업 시 준수해야 할 규칙은 `docs/` 폴더의 `[지침]` 문서에서 관리. 세부 내용은 각 문서를 참조:

| 문서 | 내용 |
|---|---|
| [`[지침] 작업 규칙.md`](docs/[지침]%20작업%20규칙.md) | **전체 체크리스트** (마스터) |
| **일반** | |
| [`[지침][일반] 커뮤니케이션 규칙.md`](docs/[지침][일반]%20커뮤니케이션%20규칙.md) | 존댓말 사용 등 |
| [`[지침][일반] 문서 작성 규칙.md`](docs/[지침][일반]%20문서%20작성%20규칙.md) | 기본 포멧(.md), 파일명 prefix 컨벤션 |
| **Git** | |
| [`[지침][Git] 브랜치, 병합 규칙.md`](docs/[지침][Git]%20브랜치, 병합%20규칙.md) | 브랜치 모델, 병합, Identity |
| [`[지침][Git] 워크플로우.md`](docs/[지침][Git]%20워크플로우.md) | 브랜치 흐름도·절차 다이어그램 |
| **프로그래밍** | |
| [`[지침][코딩] 작업 규칙.md`](docs/[지침][코딩]%20작업%20규칙.md) | 문서 선행 → 승인 → 구현 |
| [`[지침][코딩] 네이밍 컨벤션.md`](docs/[지침][코딩]%20네이밍%20컨벤션.md) | C 코드 변수·함수·매크로·타입·파일 네이밍 |

## Tools
`tools/`는 공용 스크립트와 자동화 보관소. 예: 문서 템플릿 복사·파일명 규칙 자동 적용·프로젝트 간 공용 유틸.

## Scratch
`scratch/`는 일회성 실험·초안·임시 파일 공간. git 추적 안 됨. 가치 있는 결과물은 적절한 프로젝트나 `tools/`로 승격, 아니면 삭제.

## Memory
상세 내용은 `.claude/memory/` 참조.

- [GitHub 설정](.claude/memory/github.md)
- [사용자 선호](.claude/memory/preferences.md)
