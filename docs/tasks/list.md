# 작업 목록 (Root tasks index)

루트 스코프(`E:\Claude`) 작업의 중앙 레지스트리.

- 신규 작업 시 먼저 이 목록을 조회해 관련 작업 여부 확인 → 기존 폴더에서 이어갈지 신규 분리할지 사용자 확인
- 컨벤션 상세: [`../지침/일반/문서 작성 규칙.md`](../지침/일반/문서%20작성%20규칙.md) (섹션 3·4·5)

---

## 활성

| 작업명 | 모듈 | 태그 | 폴더 | 상태 | 시작일 | 연계 | 요약 |
|---|---|---|---|---|---|---|---|
| _(없음)_ | | | | | | | |

## 완료

| 작업명 | 모듈 | 태그 | 폴더 | 상태 | 시작·완료 | 연계 | 요약 |
|---|---|---|---|---|---|---|---|
| docs 폴더 구조 세분화 | meta | docs, convention | [_archive/meta/docs-restructure](_archive/meta/docs-restructure/) | 완료 | 2026-04-24 | → Sound1 [meta/docs-restructure](../../../projects/Sound1/docs/tasks/meta/docs-restructure/) | 폴더 계층·list·태그 컨벤션 도입, 루트 repo 마이그레이션 완료 |
| Sound1 docs 구조 migration | meta | docs, Sound1, migration | (Sound1 repo에 존재: [projects/Sound1/docs/tasks/meta/docs-restructure](../../../projects/Sound1/docs/tasks/meta/docs-restructure/)) | 완료 | 2026-04-24 | → [_archive/meta/docs-restructure](_archive/meta/docs-restructure/) | Sound1 `docs/` 23건 파일 (22 + `.gitkeep`) 재편 완료. 상세: Sound1 repo 내 `tasks/meta/docs-restructure/진행상황.md` |
| 정책 정련 (lifecycle·우선순위·승격) | meta | docs, convention, lifecycle | [_archive/meta/policy-refinement](_archive/meta/policy-refinement/) | 완료 | 2026-04-27 ~ 2026-04-27 | ← [_archive/meta/docs-restructure](_archive/meta/docs-restructure/) | tasks/_archive 도입, `이력.md` 형식, 프로젝트 우선 규칙, 회고 즉시효력 |
| docs md 효율 향상 | meta | docs, llm-efficiency, frontmatter | [_archive/meta/md-efficiency](_archive/meta/md-efficiency/) | 완료 | 2026-04-27 ~ 2026-04-27 | - | frontmatter·TL;DR·폴더 README 전 영역 도입 (Phase 1+2) |
| docs 컨텍스트 절약 지침 추가 | meta | docs, guideline, token-efficiency | [_archive/meta/context-rules](_archive/meta/context-rules/) | 완료 | 2026-04-27 ~ 2026-04-27 | ← [_archive/meta/md-efficiency](_archive/meta/md-efficiency/) | 사용자 지침 → `지침/일반/컨텍스트 절약 규칙.md` 통합 + `작업 규칙.md §6` 신규 |
| 작업 진행 4단계 + Git 스코프 + 서브에이전트 활용 규칙 신설 | meta | docs, guideline, workflow, git-scope, subagent | [_archive/meta/work-process-git-scope](_archive/meta/work-process-git-scope/) | 완료 | 2026-05-07 ~ 2026-05-07 | - | 4단계 일반 규칙(요구사항→분석→계획→구현)·Git 작업 스코프 분리·서브에이전트 적극 활용 신설 |
| 문서 정합성 일괄 점검·수정 | meta | docs, audit, links, consistency | [_archive/meta/docs-consistency-audit](_archive/meta/docs-consistency-audit/) | 완료 | 2026-05-07 ~ 2026-05-07 | - | 루트·프로젝트 docs 전수 점검(서브에이전트 3개 병렬). 루트 4건 수정(CLAUDE.md Projects 표·Slack md frontmatter·rename README frontmatter·meta/ 잔재 정리). 프로젝트 repo 작업은 후속 분기 권고 |
| 새 프로젝트 초기 세팅 절차 신설 | meta | docs, guideline, automation, project-bootstrap | [_archive/meta/project-init-procedure](_archive/meta/project-init-procedure/) | 완료 | 2026-05-08 ~ 2026-05-08 | ← Sound1·auto-rtt-viewer·ez8300·sullivan 슬림화 (선행 패턴 검증) | 자유 트리거(예: "기본 세팅 해줘") 인식 + 5단계 정형 절차(진단·CLAUDE.md·표준 폴더·루트 인덱스·Git 자동 push) 지침 신설. CLAUDE.md·list.md 템플릿 인라인. 본 절차 적용은 4단계 면제, 변경 시는 4단계 적용. placeholder 정책(TBD)·default branch 보호 옵션 처리 포함 |

---

## 상태 정의

| 상태 | 의미 |
|---|---|
| `진행` | 작업 진행 중 |
| `대기` | 선행 조건 충족 대기 (다른 작업 완료·사용자 지시 등) |
| `차단` | 외부 요인으로 진행 불가 (이슈 명시 필요) |
| `완료` | 병합·릴리즈 완료 |
| `취소` | 작업 취소 (이유 명시) |

## 갱신 이력

| 날짜 | 이벤트 |
|---|---|
| 2026-04-24 | 레지스트리 생성. `meta/docs-restructure` 등재 (진행). Sound1 migration 등재 (대기). |
| 2026-04-24 | `meta/docs-restructure` 완료 (루트 repo 병합 `174cc7d`). Sound1 migration 완료 (Sound1 repo 병합 `129212e`). 양자 완료 섹션으로 이동. |
| 2026-04-24 | 구조 정정 follow-up — Sound1: `기준/` → `지침/` 통합 + `참고/` 모듈 분할(칩·LED·터치). 루트: `문서 작성 규칙.md`에 scope꯳ 지침/ 허용 + 참고 모듈화 + 기준 폴더 금지 규정 반영. |
| 2026-04-27 | `meta/policy-refinement` 등재 (진행). 정책 적용 첫 사례로 `meta/docs-restructure` → `_archive/meta/docs-restructure/` 이동 + `이력.md` 백필. |
| 2026-04-27 | `meta/policy-refinement` 완료. 동일 절차로 `_archive/meta/policy-refinement/`로 이동, `이력.md` 작성. |
| 2026-04-27 | `meta/md-efficiency` 등재 (진행). docs LLM 토큰 효율 향상 Phase 1 (frontmatter·TL;DR·폴더 README 도입) 시작. |
| 2026-04-27 | `meta/md-efficiency` Phase 1 완료 (claude_develop 병합 `2ed13f0`). Phase 2 진행 — 회고·지침·사용방법·tasks 전반에 frontmatter+TL;DR+README 확장. |
| 2026-04-27 | `meta/md-efficiency` Phase 2 완료 (claude_develop 병합 `99c475a`). 작업 완료 처리 — `_archive/meta/md-efficiency/`로 이동, `이력.md` 작성. |
| 2026-04-27 | `meta/context-rules` 등재 (진행). 사용자 추가 지침(`claude_code_context_rules.md`)을 `docs/지침/일반/컨텍스트 절약 규칙.md`로 통합. |
| 2026-04-27 | `meta/context-rules` 완료 (claude_develop 병합 `0f40002`). 작업 완료 처리 — `_archive/meta/context-rules/`로 이동, `이력.md` 작성. |
| 2026-05-07 | `meta/work-process-git-scope` 등재·완료 (claude_develop 병합 `c2e8864`). 작업 진행 4단계 일반화 + Git 작업 스코프 분리 + 서브에이전트 활용 규칙 신설. 작업 자체가 신규 4단계 첫 적용 사례. `_archive/meta/work-process-git-scope/`로 이동, `이력.md` 작성. |
| 2026-05-07 | `meta/docs-consistency-audit` 등재·완료. Explore 서브에이전트 3개 병렬로 루트·프로젝트·링크 점검 → 루트 repo 4건 일괄 수정 (CLAUDE.md Projects 표 확장 / Slack md·rename README frontmatter+TL;DR / `meta/` 빈 잔재 제거). 프로젝트 repo 정합성 작업(Sound1 README, auto-rtt-viewer·ez8300-study 마이그레이션)은 후속 분기 권고로 이력에 명시. `_archive/meta/docs-consistency-audit/`로 이동. |
| 2026-05-08 | `meta/project-init-procedure` 등재·완료 (claude_develop 병합 `0c23642`). 새 프로젝트 초기 세팅 5단계 정형 절차 지침 신설 — 자유 트리거 → CLAUDE.md(슬림 패턴+placeholder)·표준 폴더 풀 세트·루트 인덱스·Git 자동 push. 본 절차 적용은 4단계 면제. `_archive/meta/project-init-procedure/`로 이동, `이력.md` 작성. |
