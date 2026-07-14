---
name: 문서 메타데이터 — Frontmatter + TL;DR + 폴더 README
purpose: 영속 .md의 frontmatter·TL;DR·폴더 README 작성 규칙 (LLM lazy-loading)
type: 지침
applies_to: [root, projects]
maturity: core
tags: [docs, frontmatter, metadata, lazy-loading, tldr]
---

# 문서 메타데이터: Frontmatter + TL;DR + 폴더 README

**TL;DR**: LLM lazy-loading 위해 3패턴 적용. (1) YAML frontmatter(name·purpose·type·maturity·tags) 모든 영속 .md에 의무. (2) TL;DR 80~250자, 핵심 결정·결론 보존. (3) 폴더별 README는 파일 단위 인덱스(CLAUDE.md는 폴더 단위). 적용 효과 30~50% 토큰 절감.

> [!IMPORTANT]
> LLM(Claude)이 매 세션마다 긴 md를 모두 읽는 비용을 줄이기 위해, lazy loading을 가능하게 하는 3패턴을 적용한다.

## 1. Frontmatter (YAML 메타데이터)

모든 영속 문서는 첫 헤더(`#`) 위에 YAML frontmatter를 둔다.

```yaml
---
name: 문서 메타데이터
purpose: 영속 .md의 frontmatter·TL;DR·폴더 README 작성 규칙
type: 지침
maturity: core
---
```

### 1.1 필드 정의

| 필드 | 필수 | 값 | 예 |
|---|---|---|---|
| `name` | O | 파일 제목 (한국어) | `문서 메타데이터` |
| `purpose` | O | 한 줄 목적 (50자 이내) | `영속 .md의 frontmatter·TL;DR 규칙` |
| `type` | O | `지침` / `사용방법` / `참고` / `tasks/<단계>` / `메타` | `지침` |
| `maturity` | O (지침만) | `core` / `stable` / `experimental` | `core` |
| `applies_to` | - | 적용 범위 한정 시 배열 | `[root, projects]` / `[Sound1]` |
| `tags` | - | 검색·필터용 키워드 배열 | `[git, branch, merge]` |

### 1.2 `maturity` 라벨 (2026-05-18~ 회고 흡수와 함께 도입)

회고와 지침이 통합되면서 항목별 성숙도를 명시:

| 등급 | 의미 | 비고 |
|---|---|---|
| `core` | 반드시 지켜야 할 절대 규칙 | CLAUDE.md 인라인 후보. 위반 시 즉시 중단 |
| `stable` | 검증된 패턴·정책 | 일반 적용. 변경 시 회고 트리거 |
| `experimental` | 최근 추가·1~2회 적용·검증 부족 | 분기별 정기 재검토 (core/stable로 승격 또는 폐기) |

라벨은 frontmatter 외에 섹션 헤더 옆 인라인 마커도 가능:
```markdown
## 새 항목 *(maturity: experimental)*
```

### 1.3 적용 대상

- **필수 적용**: 모든 영속 `.md` 문서. 구체적으로:
  - `지침/`, `사용방법/`, `참고/` 하위 전부
  - `tasks/<모듈>/<작업>/` 하위 전부 (`요구사항.md`/`분석.md`/`계획.md`/`이력 및 결과.md` + 첨부 `.md` 포함)
- **예외 (frontmatter 생략, TL;DR로 시작)**: 폴더별 `README.md`(인덱스 성격 — TL;DR + 파일 표만)·루트/프로젝트 진입점 `CLAUDE.md`(진입점). 실무 관례상 100% 무 frontmatter로 일관 유지한다.
- **미적용**: `scratch/` 등 git outside 임시 `.md`
- **금지 상태**: 같은 폴더 내 일부 `.md`에만 frontmatter가 있고 다른 `.md`엔 없는 부분 적용. 새로 작성하는 `.md`는 무조건 frontmatter 포함

> [!IMPORTANT]
> 신규 작성 시 의무. 기존 문서 소급은 [`작성-스타일.md §6`](작성-스타일.md) 원칙대로 — 기존 문서 손댈 때 같이 변경(점진적). 일괄 소급은 사용자 명시 요청 시에만.

### 1.4 `type` 값 — tasks 하위 확장

기본 값(`지침`/`사용방법`/`참고`/`메타`)에 더해 tasks 하위는 **`tasks/<파일명>` 형태**로 세분화한다 (예: `tasks/요구사항`, `tasks/분석`, `tasks/계획`, `tasks/이력`). 검색·필터 시 모듈별/단계별 추출이 가능하다.

## 2. TL;DR (한 줄 요약)

frontmatter 다음, 첫 헤더(`# 제목`) 바로 아래 1~3줄.

```markdown
---
name: ...
---

# 문서 메타데이터

**TL;DR**: LLM lazy-loading 위해 3패턴 적용. (1) YAML frontmatter 모든 영속 .md에 의무. (2) TL;DR 80~250자. (3) 폴더별 README는 파일 단위 인덱스.

## 1. ...
```

### 2.1 형식 규칙

- 굵게 prefix: `**TL;DR**:`
- **권장 길이: 80~250자 (한국어 기준)**. 50자 미만 금지
- 1~3줄, 본문 핵심 결정·결론을 **맥락이 보존되는 충분한 길이**로 작성
- 핵심 결정의 *왜*·*무엇을*·*어떻게* 중 적어도 둘이 드러나도록
- frontmatter `purpose`(50자 이내·명사구)와 분명히 구별 — `purpose` 복붙 금지

> [!IMPORTANT]
> 너무 짧은 TL;DR(예: `**TL;DR**: Foo 도구 사용 가이드` 한 마디)은 lazy load의 본 목적 — 본문을 들어가지 않고도 다음 단계 결정(이 문서를 더 깊이 읽어야 하나? 다른 문서를 봐야 하나?)에 충분한 정보를 얻기 — 을 충족하지 못한다. 짧으면 오히려 오해 소지가 커지므로, 본문에서 한 단락 이상 풀어 설명할 내용을 명확히 압축한다.

## 3. 폴더별 README

각 영속 폴더 루트에 `README.md`를 둔다. 폴더 진입 시 LLM이 가장 먼저 읽어 자식 파일 lazy load 판단.

### 3.1 형식

```markdown
# <폴더명> (역할)

폴더 목적 한 줄.

| 파일 | 목적 | 사용 시점 |
|---|---|---|
| [`xxx.md`](xxx.md) | ... | ... |
```

### 3.2 적용 대상

- **필수**: `지침/`, `사용방법/`, `참고/`
- **선택/권장**: 카테고리·서브폴더(`지침/일반/`·`지침/Git/`·`지침/코딩/`·`지침/서브에이전트/`·`지침/문서/`·`지침/설정/`·`지침/공통/`·`지침/문서/테마/`·`지침/문서/양식/`·`지침/일반/작업/` 등) — 5+ 파일 시 가치. **신설 최상위 카테고리는 파일 수 무관 README 권장**(라우팅 일관성)
- **미적용**: `tasks/<모듈>/<작업>/` (작업 자체가 단위)

## 4. CLAUDE.md와 폴더 README의 역할 구분

| 위치 | 역할 | 인덱싱 깊이 |
|---|---|---|
| `CLAUDE.md` (루트 진입점) | 전역 진입점, 폴더 단위 1줄 인덱스 + `maturity:core` 풀텍스트 인라인 | **폴더까지** + 핵심 본문 |
| `<폴더>/README.md` (폴더 인덱스) | 폴더 내 파일 단위 1줄 인덱스 | **파일까지** |

- **중복 회피(dedup-check)**: CLAUDE.md는 폴더 존재만 표시(루트는 `지침/`), 그 안 파일 인덱스는 `지침/README.md`가 SSOT. **신규 .md 작성 전 동일 규칙이 기존 SSOT 파일에 있는지 `Grep`으로 확인**하고, 있으면 그 파일에 두고 여기선 1줄+링크만 건다(중복 재생산 방지).
- CLAUDE.md의 표가 너무 깊어지면 폴더 README로 분산.
- **2026-05-18~ 변경**: CLAUDE.md에 `maturity: core` 항목 본문은 인라인 (자동 주입 보장 위해)

## 5. 적용 효과

- **frontmatter + TL;DR**: 본문 ~5%만 읽고 파일 필요성 판단 → 파일당 ~95% 토큰 절감
- **폴더 README**: 폴더 진입 시 자식 파일 전수 로드 회피 → 폴더당 ~70% 토큰 절감
- **maturity 라벨**: grep 필터로 `core`만 추출 가능 → CLAUDE.md 인라인 자동화 기반
- **합계**: 일반 작업당 ~30~50% 토큰 절감 예상
