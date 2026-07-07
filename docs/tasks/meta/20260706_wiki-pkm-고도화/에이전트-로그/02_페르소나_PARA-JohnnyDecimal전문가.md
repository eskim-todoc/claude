---
name: PARA/Johnny Decimal 전문가 — PARA·Johnny Decimal을 기존 5카테고리 wiki 구조에 오버레이할지 대체할지 판단
purpose: PARA(Projects/Areas/Resources/Archives)와 Johnny Decimal 넘버링 체계를 조사하고, 기존 프로젝트/학습/일상/참고/사용방법 5카테고리 구조와의 결합·대체 가능성을 판단·제안
type: tasks/에이전트-로그
applies_to: [root, projects/wiki]
maturity: stable
tags: [meta, wiki, pkm]
---

# 02_페르소나_PARA-JohnnyDecimal전문가 — PARA는 대체가 아니라 "액션성 레이어"로, Johnny Decimal은 숫자가 아니라 "규율"만 차용

**TL;DR**: PARA와 Johnny Decimal 모두 기존 5카테고리(프로젝트/학습/일상/참고/사용방법) 폴더를 갈아엎을 근거가 없다. PARA는 "이게 언제 끝나는가"라는 액션성 질문에 답하는 **얇은 메타데이터 레이어**로 기존 카테고리 위에 얹고, Johnny Decimal은 십진 번호 자체가 아니라 "고정 폭(최대 10개 안팎)·단일 색인·안정 주소" 3가지 **규율**만 차용할 것을 제안한다.

## 1. PARA 핵심 개념 (Tiago Forte, *Building a Second Brain*)

PARA는 "무엇에 관한 것인가(주제)"가 아니라 **"지금 얼마나 실행 가능한가(actionability)"**로 정보를 나눈다 — 이것이 기존 도서관식/주제식 분류와 가장 다른 설계 축이다.

| 카테고리 | 정의 | 핵심 테스트 |
|---|---|---|
| **Projects** | 명확한 끝(완료 기준)이 있는 단기 노력 | "이게 언젠가 끝나는가?" → Yes |
| **Areas** | 끝이 없는 지속적 책임 영역 (건강, 재무, 특정 고객 관계 등) | "이게 언젠가 끝나는가?" → No, 계속 유지해야 함 |
| **Resources** | 현재 프로젝트와 무관하게 관심 있는 주제·참고 자료 | 지금 당장 실행할 일은 아니지만 나중에 쓸모 있음 |
| **Archives** | 위 3개 중 비활성화된 것 (완료된 프로젝트, 더 이상 안 하는 Area, 흥미 잃은 Resource) | 지금 안 씀, 하지만 보존 |

Forte가 제시하는 결정적 구분 기준(Projects vs Areas)은 "끝이 있는가"이다. "웹페이지 디자인 완료"는 끝이 있고, "전략 기획"이나 "휴가 관리"는 끝이 없이 반복된다. 이 구분이 중요한 이유는, Area를 영구적인 것으로 착각하면 심리적 부담이 쌓이고, 반대로 완료된 Project는 완료 자체가 동기부여가 되기 때문이다. 항목은 시간이 지나며 Projects/Areas/Resources → Archives로 자연스럽게 흘러간다(완료·중단·흥미 소멸 시 Archives로 이동) — 즉 4개 폴더는 정적 분류함이 아니라 **활성 상태를 반영하는 동적 시스템**이다. (출처: [Forte Labs, "The PARA Method"](https://fortelabs.com/blog/para/), [Building a Second Brain 공식](https://www.buildingasecondbrain.com/para))

## 2. Johnny Decimal 핵심 개념 (Johnny Noble, 2010, Dewey Decimal 참고)

Johnny.Decimal(JD)은 "**10개 고정 Area**(선반) × Area당 **10개 Category**(상자) × Category당 **최대 100개 ID**"라는 3단 계층에 숫자를 매겨 어디에도 두 곳에 속하지 않는 **단일하고 안정적인 주소**를 만드는 체계다. 표기법은 `AC.ID` (예: `11.02` = Area 1, Category 11, ID 02). 핵심은 "**10개 이하**" 제약 — 어느 레벨에서든 선택지가 10개를 넘지 않게 강제해, 찾을 때 나머지 9개를 무시하고 바로 좁혀 들어갈 수 있게 한다. 그리고 시스템 전체의 마스터 레코드인 **JDex**(모든 ID의 색인)를 별도로 유지해, 폴더를 뒤지지 않고 색인 한 곳만 보면 무엇이 어디 있는지 알 수 있게 한다. (출처: [johnnydecimal.com 공식 문서](https://johnnydecimal.com/documentation/introduction), [10-19 Concepts](https://johnnydecimal.com/10-19-concepts/), [kiko.io 요약](https://kiko.io/post/Johnny-Decimal-Emerging-from-the-Abyss/))

### 비판/한계 (교차검증)

- 숫자 접두어 자체가 파일/폴더명을 지저분하게 만들고, 매번 `61.28` 같은 번호를 타이핑/선택하는 마찰이 얻는 이득보다 클 수 있다는 실사용 후기가 다수 존재한다. (출처: [Medium, Geet Duggal, "Can you Johnny Decimal Without the Decimal?"](https://medium.com/@geetduggal/tech-habits-can-you-johnny-decimal-without-the-decimal-31927f0f2e82))
- JD는 본질적으로 **폴더/파일 주소 체계**이며 다중 소속(한 문서가 여러 맥락에 걸침)을 표현 못하는 계층 구조의 근본 한계를 그대로 물려받는다 — 예: "회사 관련이면서 건강 관련인 진단서"는 계층 하나에만 못 넣는다. 반면 태그는 이 중복 소속 문제를 해결한다. (출처: [dsebastien.net, "Organize Anything With The Johnny Decimal System"](https://www.dsebastien.net/2022-04-29-johnny-decimal/))
- Area는 너무 넓고 Category는 너무 좁아서 실제 분류가 애매해지는 구현 난점도 보고된다. (동일 출처, [Hacker News 토론](https://news.ycombinator.com/item?id=36308366))

### PARA와 JD의 근본 차이

두 체계는 답하는 질문이 다르다: **PARA는 "이게 지금 어디에 속하는가"(유동적, 재평가 가능)에 답하고, JD는 "이게 영원히 어디 있을 것인가"(고정 주소)에 답한다.** 그래서 실무에서는 종종 "PARA로 분류 원칙을 세우고, JD로 그 분류에 영구 번호를 매겨 폴더 재정리 빈도를 낮춘다"는 결합이 제안된다. 다만 JD는 폴더 시스템에 최적화된 것이라 도구 불가지론적인 PARA와 달리, 앱을 넘나드는 적용에는 제약이 있다. (출처: [Shuvangkar Das, "Johnny Decimal Organization Method for Obsidian"](https://blog.shuvangkardas.com/johnny-decimal-obsidian-organization-method/), [dsebastien.net, "The PARA Method"](https://www.dsebastien.net/2022-04-26-para/))

## 3. 이 프로젝트 현재 구조 진단 (직접 확인)

`wiki vault/` 실제 파일 확인 결과:

```
프로젝트/  MOC.md, Sound1.md, auto-rtt-viewer.md, ez8300-study.md, sound1-fw-extractor.md
학습/      MOC.md (본문만 있고 실제 페이지 0개 — "페이지 목록: (추가 시 등재)"만 존재)
일상/      MOC.md (내용 사실상 비어 있음)
참고/      MOC.md + CFX/, LED/, RTT/, 칩/, 터치/ 하위 MOC 5개 (이미 서브폴더+서브MOC 패턴 실사용 중)
사용방법/  MOC.md + 실사용 페이지 7개 (Slack 알림, UI 명령어, fw.txt 형식, 디버깅 가이드 등)
```

`프로젝트/MOC.md`는 **`/projects/` 하위 소스 repo 4개(Sound1·auto-rtt-viewer·ez8300-study·sound1-fw-extractor)만** 허브로 연결하고 있다. 루트 저장소 자체의 `docs/tasks/meta/`(오케스트레이션 정책, 워크플로우 이식 등 이번 세션이 다루는 바로 그 영역)는 **wiki의 "프로젝트" 개념 어디에도 대응 항목이 없다** — 이것이 배경에 적힌 "meta 8건 완료, wiki 반영 0건" 현상의 구조적 원인 중 하나다: 애초에 반영할 허브 슬롯이 없었다.

### PARA 렌즈로 본 기존 5카테고리 매핑

| 기존 카테고리 | PARA 대응 | 근거 |
|---|---|---|
| 프로젝트 (Sound1 등) | **혼합**: Sound1 자체는 끝이 없는 Area(펌웨어는 계속 유지보수됨), 그 안의 개별 task(`docs/tasks/<모듈>/YYYYMMDD_<slug>/`)는 완료 기준이 있는 진짜 Project | "언제 끝나는가" 테스트를 상위 폴더(끝없음=Area)와 개별 task(끝있음=Project)에 **서로 다르게** 적용해야 함 |
| 학습 | Resources (미완성/진행 중 성격) | 아직 실제 페이지가 0개 — 카테고리만 있고 콘텐츠 없음. 참고와의 경계가 설계상으로도 불명확 |
| 참고 | Resources (안정화된 참고 자료) | CFX/LED/RTT/칩/터치처럼 이미 JD식 "서브폴더+서브 MOC" 패턴을 자생적으로 쓰고 있음 |
| 사용방법 | Resources의 하위 유형(절차형) | 실사용 콘텐츠가 가장 많음 — Resources 중에서도 "how-to"라는 별도 결이 있어 분리해둔 것 자체는 타당 |
| 일상 | PARA 어디에도 안 맞음 | 시간 축 로그/저널은 actionability 축과 직교 — Forte 자신도 저널은 PARA 밖에 둠 |
| (없음) | **Archives 슬롯 자체가 없음** | 완료된 프로젝트/흥미를 잃은 리소스를 치울 곳이 현재 구조에 없음 |

핵심 발견: **"학습"과 "참고"가 PARA의 Resources 하나를 인위적으로 둘로 쪼갠 것**일 가능성이 있다 — 다만 실제로는 "진행 중인 미숙성 노트(학습)" vs "안정화된 룩업 자료(참고)"라는 **성숙도 축**으로 구분한 것이라면 이는 PARA에 없는 유용한 축이므로 유지할 가치가 있다(§5에서 판단 제안).

## 4. 제안 A — PARA는 폴더 대체가 아니라 "액션성 메타데이터 레이어"로 얹는다

기존 5개 폴더명(프로젝트/학습/일상/참고/사용방법)을 Projects/Areas/Resources/Archives 영문 4개로 갈아엎지 말 것을 제안한다. 이유:

1. **위키링크 파손 비용**: 폴더명을 바꾸면 기존 `[[위키링크]]`와 MOC 연결이 전부 깨진다. 콘텐츠가 아직 얼마 없는 지금(홈.md, 사용방법 7건, 프로젝트 4건)이 오히려 손 대기 쉬운 시점이지만, 그렇다고 이득 없는 리네임을 정당화하진 않는다.
2. **1:1 대응이 안 됨**: 위 표에서 보듯 "프로젝트" 폴더 자체가 PARA의 Area와 Project를 섞어 담고 있어 폴더명을 4개로 줄여도 애매함이 사라지지 않는다.
3. **일상은 PARA 밖**: Forte 본인도 저널(시간 축 로그)은 PARA 카테고리 밖에 둔다. 굳이 욱여넣을 이유가 없다.

대신 각 wiki 문서 frontmatter에 이미 있는 `maturity`(콘텐츠 성숙도)·`public_status`(공개 준비도)와는 **별도 축**으로 PARA 유래 상태 필드를 추가할 것을 제안한다:

```yaml
status: project   # project(끝이 정해진 활동, 완료되면 archived로) | area(끝없는 지속 책임) | resource(참고 자료) | archived(비활성)
```

이 필드의 실익은 이번 세션 배경이 요구하는 바로 그 판단 — **"지금 이걸 wiki에 반영할 때가 됐는가"**를 세션 중 Claude가 즉시 결정할 수 있게 해준다는 것이다:
- source task가 **project형**(끝 있음, 예: 이번 `20260706_wiki-pkm-고도화` 같은 1회성 결정 task)으로 완료되면 → wiki에 한 번 기록하고 그 즉시 `archived` 후보로 표시.
- source task가 **area형**(끝없음, 예: "서브에이전트 활용" 지침처럼 계속 개정되는 정책)이면 → 새 페이지를 만들지 않고 **기존 허브를 갱신**(살아있는 문서로 계속 덮어쓰기).

이 구분이 없으면 지금처럼 "완료 판단 시점"과 "wiki 반영 시점"의 트리거가 뒤섞여 8건이 누락되는 일이 반복된다.

## 5. 제안 B — Johnny Decimal은 숫자가 아니라 3가지 "규율"만 차용

이 프로젝트는 **1인 Obsidian vault**다. Obsidian은 이미 전체 텍스트 검색·백링크·그래프뷰로 "이게 어디 있더라"를 해결해준다 — 이는 JD가 애초에 겨냥한 문제(폴더 탐색기 안에서 팀 다수가 문서를 찾는 문제)와 다르다. 따라서 **`11.02` 같은 십진 ID 부여는 이 프로젝트에 도입하지 않을 것을 제안**한다 — 비판 사례들이 지적하듯 파일명만 지저분해지고 얻는 게 없다.

반면 JD의 다음 3가지 **구조적 규율**은 이미 이 프로젝트가 부분적으로 실천 중이며, 명문화할 가치가 있다:

| JD 규율 | 이미 하고 있는 것 | 명문화 제안 |
|---|---|---|
| **레벨당 최대 폭 ~10개 안팎** | `참고/`가 이미 5개 하위주제(CFX/LED/RTT/칩/터치)로 유지되며 무한정 늘지 않음 | "한 MOC 아래 직속 페이지가 10~15개를 넘으면 서브폴더+서브 MOC로 분리" 규칙을 `문서 작성 규칙.md`에 명문화 (참고/ 패턴을 일반 규칙으로 승격) |
| **단일 색인(JDex)** | MOC.md 자체가 사실상 JDex 역할 | 카테고리별 MOC는 있지만 **전체를 가로지르는 단일 색인이 없음** — `홈.md`를 모든 MOC + 활성 허브를 한 표로 나열하는 최상위 JDex로 강화 제안. Claude가 세션 중 아무 문서나 갱신할 때마다 이 표도 함께 건드리는 걸 "저장 완료의 정의"로 삼으면, 배치 동기화 없이도 드리프트를 즉시 잡을 수 있음 |
| **안정 주소(재번호 금지)** | 아직 심각한 리네임 이력 없음(콘텐츠가 적어서) | "한 번 MOC에 등재된 허브 페이지의 경로/이름은 변경 시 반드시 프로젝트 전체 백링크를 확인 후에만" 규칙화 — 숫자 주소 대신 **경로 안정성**으로 JD의 안정 주소 원칙을 대체 구현 |

## 6. 종합 제안 (구체적 실행안)

1. **폴더명 변경 없음** — 프로젝트/학습/일상/참고/사용방법 유지.
2. **frontmatter에 `status` 필드 추가**(`project`/`area`/`resource`/`archived`) — PARA의 액션성 판단을 세션 중 즉시 트리거 기준으로 사용.
3. **"보관" 전용 6번째 최상위 폴더는 만들지 않음** — 파일 이동은 위키링크를 깨뜨리므로, `archived` 상태는 frontmatter 태그로만 표시(폴더 이동 없이 필터/그래프로 걸러보기). 이는 JD·PARA 실무자들이 개인 위키에서 공통 권고하는 방식이다(참고: dsebastien.net PKM 글).
4. **`학습` vs `참고`의 경계를 성숙도 축으로 명문화**: 학습 = 진행 중·미검증 노트, 참고 = 안정화된 룩업 자료. 학습 페이지가 안정화되면 참고로 "승격"(PARA의 Project→Archive 전환과 유사한 명시적 전이 규칙).
5. **`프로젝트/MOC.md`에 "메타"(루트 저장소 자체의 지침/운영 영역) 허브 슬롯 신설** — 현재 `/projects/` 하위 소스 repo만 나열하고 있어 이번 세션이 다루는 `docs/tasks/meta/` 같은 루트 차원 활동이 반영될 자리가 원천적으로 없었다는 구조적 공백을 메움.
6. **`참고/` 서브폴더 패턴(최대 폭 규율)을 문서 작성 규칙에 명문화** — 이미 실천 중인 것을 규칙화만 하면 됨.
7. **`홈.md`을 전체 MOC 목록을 나열하는 단일 색인(JDex 역할)으로 강화**, "문서 갱신 시 색인도 갱신"을 완료 정의에 포함.

## 7. 리스크·트레이드오프

- `status` 필드 도입은 frontmatter 스키마가 이미 여러 필드(`maturity`, `public_status`, `sensitivity`, `redaction_checked` 등)로 무거워지고 있는 흐름을 하나 더 늘리는 것 — 다른 페르소나(문서 스키마 담당)와 필드 중복·의미 충돌이 없는지 교차 확인 필요.
- "학습→참고 승격" 규칙은 승격 기준(누가/언제 판단)이 없으면 문서가 영원히 학습에 머무를 위험 — 승격 트리거를 세션 중 Claude 판단으로 둘지, 명시적 리뷰 주기로 둘지는 별도 결정 필요(이번 페르소나 범위 밖).
- JD의 십진 번호를 완전히 배제하는 결정은 향후 vault 규모가 수백~수천 노트로 커질 경우 재검토 여지가 있음(현재는 페이지 수가 20건 미만으로 매우 작아 번호 체계의 이득이 비용을 못 넘음 — 이 판단은 콘텐츠 규모에 종속적).

## 8. 출처

- [Forte Labs — The PARA Method](https://fortelabs.com/blog/para/)
- [Building a Second Brain — PARA 공식](https://www.buildingasecondbrain.com/para)
- [Johnny.Decimal 공식 문서 — Introduction](https://johnnydecimal.com/documentation/introduction)
- [Johnny.Decimal — 10-19 Concepts](https://johnnydecimal.com/10-19-concepts/)
- [kiko.io — Johnny Decimal: Emerging from the Abyss](https://kiko.io/post/Johnny-Decimal-Emerging-from-the-Abyss/)
- [dsebastien.net — Organize Anything With The Johnny Decimal System](https://www.dsebastien.net/2022-04-29-johnny-decimal/)
- [dsebastien.net — The PARA Method](https://www.dsebastien.net/2022-04-26-para/)
- [Shuvangkar Das — Johnny Decimal Organization Method for Obsidian](https://blog.shuvangkardas.com/johnny-decimal-obsidian-organization-method/)
- [Medium, Geet Duggal — Can you Johnny Decimal Without the Decimal?](https://medium.com/@geetduggal/tech-habits-can-you-johnny-decimal-without-the-decimal-31927f0f2e82)
- [Hacker News — Johnny Decimal 토론](https://news.ycombinator.com/item?id=36308366)
- 로컬 확인: `/mnt/e/Claude/projects/wiki/wiki vault/` 실제 파일 구조 및 `프로젝트/MOC.md`·`학습/MOC.md` 내용 직접 열람
