# Claude Project Context

> [!IMPORTANT]
> **세션 시작 첫 동작 (무조건)**: 새 세션이 시작되면 작업 착수 전, 본 파일(루트 `CLAUDE.md`)을 `Read` 도구로 **명시적으로 한 번 더 읽고**, 첫 응답 맨 첫 줄에 `루트 지침 확인 완료: <한 줄 요약>` 형식으로 보고한다. 자동 컨텍스트 주입과 무관하게 명시적 재확인을 강제한다.
>
> **작업 전 필수 참조**: [`docs/지침/작업 규칙.md`](docs/지침/작업%20규칙.md) — 모든 작업을 시작하기 전에 반드시 확인할 것.

Root: `E:\Claude` — 이 폴더를 복제하면 다른 환경에서도 컨텍스트 유지 가능.

## Layout

```
E:\Claude\
├── CLAUDE.md              이 파일 — 전역 진입점
├── .claude/memory/        장기 메모리
├── credentials/           서비스별 토큰 (gitignored)
├── projects/              제품별 독립 repo (gitignored)
│   └── Sound1/            E8300 embedded firmware
├── docs/                  전역 공용 문서 (지침/, 회고/, 사용방법/, tasks/)
├── tools/                 공용 스크립트 · 자동화
├── scratch/               일회성 실험 (gitignored)
└── .gitignore
```

루트 Git은 `CLAUDE.md`, `.claude/memory/`, `tools/`를 추적. `credentials/`, `projects/`, `scratch/`는 `.gitignore`로 차단.

## Credentials
인증 정보는 `credentials/` 폴더에서 서비스별로 관리.

- GitHub: `credentials/github/classic.token`, `credentials/github/fine-grained.token`
- Slack Webhook: `credentials/slack/webhook.url` — 작업 완료 알림 전송용 ([사용방법](docs/사용방법/Slack%20작업%20완료%20알림.md))

## Projects
프로젝트(제품 모델 또는 독립 산출물)는 `projects/<이름>/` 폴더에서 **독립 repo**로 관리. 각 프로젝트 내 `CLAUDE.md`에서 프로젝트별 컨텍스트 관리.

| 프로젝트 | 성격 | 비고 |
|---|---|---|
| [Sound1](projects/Sound1/CLAUDE.md) | E8300 embedded firmware | 표준 docs 구조 적용 완료 |
| [auto-rtt-viewer](projects/auto-rtt-viewer/CLAUDE.md) | J-Link RTT 자동 뷰어 (Sound1 디버깅 보조) | docs 구 prefix 컨벤션 잔존 — 후속 마이그레이션 권고 |
| [ez8300-study](projects/ez8300-study/CLAUDE.md) | EZ8300 CFX 아키텍처 학습 노트 | docs 구 prefix 컨벤션 잔존 — 후속 마이그레이션 권고 |
| [sullivan1.5-fw-download](projects/sullivan1.5-fw-download/CLAUDE.md) | Sullivan 1.5 FW 다운로드 도구 (초기 단계) | docs 비어 있음 — 작업 진행 시 표준 구조로 채움 |

> [!NOTE]
> `projects/markdown-css/` 는 VSCode Markdown Preview용 공용 CSS 자원(독립 GitHub repo)으로, 정식 프로젝트 표준 구조 대상이 아닌 단순 도구 자원. 사용 안내는 [`projects/markdown-css/README.md`](projects/markdown-css/README.md).
>
> `projects/travel_okinawa/` 는 잡담 메모 성격으로 정식 프로젝트가 아님 — `scratch/` 또는 외부로 이동 검토 필요.

### 프로젝트 내부 표준 구조
각 프로젝트 폴더는 다음 레이아웃을 따름:

```
projects/<이름>/
├── CLAUDE.md       프로젝트 컨텍스트
├── src/            펌웨어 / SW 코드
├── tests/          단위 · 통합 테스트
└── docs/           SW 문서 (지침/·사용방법/·참고/ 등 폴더 + tasks/<모듈>/<작업>/)
```

## 지침 문서
작업 시 준수해야 할 규칙은 `docs/지침/` 폴더에서 관리. 세부 내용은 각 문서를 참조:

| 문서 | 내용 |
|---|---|
| [`지침/작업 규칙.md`](docs/지침/작업%20규칙.md) | **전체 체크리스트** (마스터) |
| **일반** | |
| [`지침/일반/커뮤니케이션 규칙.md`](docs/지침/일반/커뮤니케이션%20규칙.md) | 존댓말 사용 등 |
| [`지침/일반/명령 해석 규칙.md`](docs/지침/일반/명령%20해석%20규칙.md) | 사용자 명령 모호 시 무조건 질문 (이분→yes/no, 다항→선택지) |
| [`지침/일반/작업 진행 규칙.md`](docs/지침/일반/작업%20진행%20규칙.md) | **모든 작업 4단계** (요구사항→분석→계획→구현), 산출물·자체검토·진행상황·이력 의무 |
| [`지침/일반/서브에이전트 활용.md`](docs/지침/일반/서브에이전트%20활용.md) | **서브에이전트 적극 활용** — 병렬·효율 위해 작업 패턴별 매핑·병렬 호출·안티패턴 |
| [`지침/일반/문서 작성 규칙.md`](docs/지침/일반/문서%20작성%20규칙.md) | 기본 포멧(.md), 폴더·파일명 컨벤션, tasks/ 레지스트리 |
| [`지침/일반/컨텍스트 절약 규칙.md`](docs/지침/일반/컨텍스트%20절약%20규칙.md) | 응답·툴 사용 시 컨텍스트·토큰 절감 |
| **Git** | |
| [`지침/Git/브랜치, 병합 규칙.md`](docs/지침/Git/브랜치,%20병합%20규칙.md) | 브랜치 모델, 병합, Identity |
| [`지침/Git/워크플로우.md`](docs/지침/Git/워크플로우.md) | 브랜치 흐름도·절차 다이어그램 |
| **프로그래밍** | |
| [`지침/코딩/작업 규칙.md`](docs/지침/코딩/작업%20규칙.md) | 문서 선행 → 승인 → 구현 |
| [`지침/코딩/네이밍 컨벤션.md`](docs/지침/코딩/네이밍%20컨벤션.md) | C 코드 변수·함수·매크로·타입·파일 네이밍 |
| [`지침/코딩/구현 패턴.md`](docs/지침/코딩/구현%20패턴.md) | FSM (유한 상태 머신) 우선 적용 등 구현 패턴 |
| [`지침/코딩/분석·디버깅 규칙.md`](docs/지침/코딩/분석·디버깅%20규칙.md) | 호출 경로 grep 검증, 가설 3개 cross-check, 사용자 변경 단서 활용 등 (실제 회귀 사례 포함) |

## 회고 (Lesson & Learn)
작업 중 학습한 사용자 피드백·검증된 판단·일반화 가능한 패턴은 `docs/회고/`에 카테고리별로 누적. 시간이 지나 검증된 회고는 `docs/지침/`으로 승격될 수 있음.

| 파일 | 내용 |
|---|---|
| [`회고/README.md`](docs/회고/README.md) | **회고 시스템 동작 원리** (트리거·저장 범위·형식) |
| [`회고/커뮤니케이션.md`](docs/회고/커뮤니케이션.md) | 말투, 응답 형식, 페르소나 |
| [`회고/Git 워크플로우.md`](docs/회고/Git%20워크플로우.md) | 브랜치, 병합, 클론 절차 |
| [`회고/작업 진행.md`](docs/회고/작업%20진행.md) | 문서 선행, 정리, 워크트리, 완료 시그널 |
| [`회고/코딩.md`](docs/회고/코딩.md) | 코드 작성 패턴, 안티패턴, 설계 결정 |
| [`회고/문서 스타일.md`](docs/회고/문서%20스타일.md) | Markdown, Mermaid, Alert |
| [`회고/환경.md`](docs/회고/환경.md) | 이식성, 설정 위치 |

**트리거**: Claude가 사용자 교정·비전형적 선택 승인·일반화 가능한 패턴을 감지하면 *"이 내용을 `docs/회고/<카테고리>.md`에 기록할까요?"* 라고 묻고, 승인 시 해당 파일에 추가.

## Tools
`tools/`는 공용 스크립트와 자동화 보관소. 예: 문서 템플릿 복사·파일명 규칙 자동 적용·프로젝트 간 공용 유틸.

- `slack-notify.ps1` — Stop 훅에서 호출되어 Slack DM으로 작업 완료 알림 전송. 상세: [사용방법 문서](docs/사용방법/Slack%20작업%20완료%20알림.md)
- `rename_sessions.py` — Claude Code Desktop app의 모든 세션 제목을 AI 요약으로 일괄 변경. 상세: [`tools/rename_sessions.README.md`](tools/rename_sessions.README.md)

## Scratch
`scratch/`는 일회성 실험·초안·임시 파일 공간. git 추적 안 됨. 가치 있는 결과물은 적절한 프로젝트나 `tools/`로 승격, 아니면 삭제.

## Memory

> [!IMPORTANT]
> **Claude Code 글로벌 auto-memory 시스템(`~/.claude/projects/<프로젝트>/memory/`) 사용 금지.** 모든 학습은 git tracked [`docs/회고/`](docs/회고/README.md)로 관리. 시스템 프롬프트의 auto-memory 안내는 이 프로젝트에서 비활성화.

프로젝트 내부 `.claude/memory/`는 별도 — git tracked, 수동 관리:

- [GitHub 설정](.claude/memory/github.md)
- [사용자 선호](.claude/memory/preferences.md)
