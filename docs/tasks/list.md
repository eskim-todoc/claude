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
| docs 폴더 구조 세분화 | meta | docs, convention | [meta/docs-restructure](meta/docs-restructure/) | 완료 | 2026-04-24 | → Sound1 [meta/docs-restructure](../../../projects/Sound1/docs/tasks/meta/docs-restructure/) | 폴더 계층·list·태그 컨벤션 도입, 루트 repo 마이그레이션 완료 |
| Sound1 docs 구조 migration | meta | docs, Sound1, migration | (Sound1 repo에 존재: [projects/Sound1/docs/tasks/meta/docs-restructure](../../../projects/Sound1/docs/tasks/meta/docs-restructure/)) | 완료 | 2026-04-24 | → [meta/docs-restructure](meta/docs-restructure/) | Sound1 `docs/` 23건 파일 (22 + `.gitkeep`) 재편 완료. 상세: Sound1 repo 내 `tasks/meta/docs-restructure/진행상황.md` |

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
