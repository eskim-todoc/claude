---
name: Obsidian 파워유저 — 플러그인 생태계 실전 활용 딥리서치
purpose: 현재 wiki vault의 실제 설정(core-plugins.json/community-plugins.json)을 근거로, 1인 PKM 자동화(백링크 대시보드·최근 갱신 추적·미연결 문서 탐지)에 실질적으로 유용한 플러그인·설정을 조사·제안
type: tasks/에이전트-로그
applies_to: [root, projects/wiki]
maturity: stable
tags: [meta, wiki, pkm]
---

# 03_페르소나_Obsidian파워유저 — Obsidian 플러그인 생태계 실전 활용 제안

**TL;DR**: 현재 wiki vault는 **커뮤니티 플러그인이 0개**이고, 코어 플러그인만으로 그래프·백링크·태그·데일리노트가 이미 켜져 있으나 활용되지 않고 있다. `Dataview`(커뮤니티) + `Templater`(커뮤니티) 딱 2개만 추가하면 "최근 갱신 추적"·"미연결 문서 탐지"·"frontmatter 자동화"가 모두 해결된다. 단, **Obsidian vault 루트는 `wiki vault/`뿐**이라 Dataview/Bases는 그 바깥의 `운영/`이나 다른 프로젝트 repo(`projects/Sound1/docs/tasks/` 등)를 절대 쿼리할 수 없다는 구조적 사실이 확인됐다 — 이는 "Claude가 세션 중 판단해 push"하는 새 방향과 정확히 맞고, 기존 설계 문서의 "wiki가 pull한다"는 전제와는 애초에 안 맞았다는 근거가 된다.

## 1. 현재 상태 진단 (실제 설정 파일 근거)

`/mnt/e/Claude/projects/wiki/wiki vault/.obsidian/` 확인 결과:

- `community-plugins.json` → `[]` (커뮤니티 플러그인 **전무**, Dataview/Templater 등 아무것도 설치 안 됨)
- `core-plugins.json` → 이미 켜져 있는 것: `graph`, `backlink`, `outgoing-link`, `tag-pane`, `daily-notes`, `templates`, `bookmarks`, `properties`, `bases`(!), `sync`, `outline`, `word-count`
- `graph.json` → `showOrphans: true`, `colorGroups: []` (고아 노드는 표시하되 폴더별 색상 그룹은 미설정)
- `.obsidian/plugins/` 폴더 자체가 완전히 비어 있음 (설치 이력조차 없음)

**핵심 구조적 사실**: `.obsidian/`이 `projects/wiki/wiki vault/` 안에 있으므로 **Obsidian vault 루트는 `wiki vault/`이고, 그 한 단계 위 `projects/wiki/운영/`조차 vault 바깥**이다. Dataview·Bases 등 어떤 플러그인도 vault 루트 밖의 파일(운영 문서, 다른 프로젝트의 `docs/tasks/`)은 인덱싱·쿼리할 수 없다. 즉 기존 `Wiki 동기화 운영.md`가 그리는 "wiki가 각 프로젝트의 작업 목록.md를 직접 읽어 pull"이라는 그림은 Obsidian 플러그인 레벨에서 자동화될 수 없고, **Claude(또는 외부 스크립트)가 vault 밖에서 읽어 vault 안으로 write하는 방식만 가능**하다. 이는 은수님이 이번에 원하는 "세션 중 Claude가 판단해 반영" 방향과 정확히 일치하며, 오히려 이 구조적 제약이 새 방향이 옳다는 근거가 된다.

## 2. 제안: 딱 2개만 추가 (Dataview + Templater)

1인 운영에 플러그인을 늘리는 것 자체가 유지보수 부채다. 조사한 여러 1인 PKM 운영기(Medium/개인 블로그 사례, 출처 하단)의 공통 결론은 "plugin은 workhorse 몇 개로 충분, 나머지는 습관이 대체한다"였다. 이번 프로젝트에는 아래 2개만 권장한다.

| 플러그인 | 용도 | 왜 필요한가 |
|---|---|---|
| **Dataview** | 최근 갱신 목록, 미연결(orphan) 문서 탐지, 백링크 수 기반 정렬 | 코어 `bases`가 못 하는 **링크 그래프 쿼리**(`file.inlinks`/`file.outlinks`)가 이것만 가능 |
| **Templater** | MOC/허브/일반 지식 문서 frontmatter 자동 생성 (`Wiki 동기화 운영.md`가 이미 정의한 frontmatter 스키마를 손으로 재입력하지 않게) | `last_reviewed` 자동 채움, `type`/`sensitivity` 선택 프롬프트, 반복 오타 방지 |

**추가하지 않을 것**(과잉 도구 방지): Kanban, Tasks 플러그인(작업 관리는 `docs/tasks/`가 이미 담당), QuickAdd/자동 캡처, Excalidraw, Advanced Tables, Full Calendar. 이 vault는 문서량이 적고(수십~수백 건) 검색·그래프 규모 문제가 없으므로 성능 최적화용 도구도 불필요.

**주의**: `community-plugins.json`이 빈 배열이라는 것은 설치가 0건이라는 뜻이지 커뮤니티 플러그인이 막혀 있다는 뜻은 아니다. 다만 Obsidian 설정에서 "커뮤니티 플러그인 켜기"를 실제로 활성화한 이력이 없을 가능성이 있으므로, 도입 시 Settings → Community plugins 토글부터 확인 필요.

## 3. 코어 `Bases`(이미 켜져 있음)를 먼저 써볼 것

core-plugins.json에 `"bases": true`가 이미 있다 — Obsidian이 2025년에 추가한 **네이티브 데이터베이스 뷰(Notion 데이터베이스와 유사)**로, frontmatter 속성·폴더·수정일 기반 테이블/리스트를 커뮤니티 플러그인 설치 없이 만들 수 있다. 조사 결과([Obsidian Rocks 비교](https://obsidian.rocks/dataview-vs-datacore-vs-obsidian-bases/), [Obsidian Forum](https://forum.obsidian.md/t/bases-access-the-number-of-incoming-links-backlinks-of-a-file/101235)) 요지:

- Bases는 **속도가 빠르고 유지보수 부담이 없다**(코어 기능이라 업데이트 걱정 없음) → "최근 갱신 문서" 같은 **frontmatter/mtime 기반** 뷰는 Bases로 충분
- 그러나 Bases는 **아직 `file.inlinks`/`file.outlinks`(백링크 개수)를 노출하지 않는다** → "미연결 문서 탐지"·"백링크 수 기준 정렬"은 Bases로 불가능, Dataview가 유일한 대안

**결론**: 최근 갱신 대시보드는 Bases(코어, 설치 불필요)로 먼저 시도하고, 링크 그래프 기반 기능(고아 탐지)에만 Dataview를 추가하는 것이 가장 얇은 구성이다.

## 4. 구체 설정 예시 (이 vault 구조에 맞춤)

### 4.1 최근 갱신 추적 — `홈.md`에 Bases 또는 Dataview 블록 추가

```dataview
TABLE file.mtime AS "수정일"
FROM ""
WHERE !contains(file.path, "_attachments")
SORT file.mtime DESC
LIMIT 10
```

- `docs/tasks/meta/` 쪽에서 8건이 갱신됐는데 wiki가 7주간 안 건드려졌다는 이번 감사 결과처럼, "최근 갱신 없음" 자체가 신호다. 아래처럼 **역방향(오래 방치된 MOC/허브)** 쿼리도 함께 두면 세션 중 Claude가 "이 문서 갱신할 때가 됐다"를 판단하는 데 직접 근거가 된다.

```dataview
TABLE file.mtime AS "마지막 수정"
FROM ""
WHERE file.name = "MOC" AND date(now) - file.mtime > dur(30 days)
SORT file.mtime ASC
```

### 4.2 미연결(orphan) 문서 탐지 — 별도 "유지보수" 뷰 (vault 내부, 비공개용)

```dataview
LIST
FROM ""
WHERE length(file.inlinks) = 0 AND file.name != "MOC" AND file.name != "홈"
```

- 이 vault는 "모든 공개 후보 문서는 적어도 하나의 MOC나 허브에서 링크되어야 한다"는 원칙(`Wiki 탐색 구조 분석.md`)을 이미 명문화했다 — 이 쿼리가 바로 그 원칙의 **자동 검증 도구**가 된다. 이 쿼리 결과가 0이 아니면 공개 검수 전 반드시 MOC 연결부터 하도록 세션 체크리스트에 넣을 것을 제안.
- 이 뷰는 독자용 콘텐츠가 아니므로 `publish: false`를 붙여 `사용방법/` 옆에 두지 않고, vault 안이지만 별도 내부용 노트(예: `wiki vault/_내부/유지보수.md`, `_` 접두로 카테고리와 시각 분리 — 기존 `_attachments` 컨벤션과 동일 패턴)에 둘 것을 권장.

### 4.3 그래프 뷰 — 폴더별 색상 그룹만 추가 (이미 `showOrphans:true`는 켜져 있음)

`graph.json`의 `colorGroups: []`가 비어 있다. 5개 카테고리(`프로젝트`/`학습`/`일상`/`참고`/`사용방법`)를 폴더 경로 정규식으로 색상 그룹화하면, 그래프 뷰 자체가 "이 카테고리가 얼마나 촘촘히 연결됐는지"를 한눈에 보여주는 자가진단 도구가 된다. 예: `path:^프로젝트/` → 파랑, `path:^참고/` → 초록 식. 설정 비용이 거의 없으므로(그래프 뷰 UI에서 그룹 추가) 우선순위 높음.

### 4.4 Templater — frontmatter 자동화

`Wiki 동기화 운영.md`가 이미 표준 frontmatter(`name`/`purpose`/`type`/`applies_to`/`maturity`/`tags`/`publish`/`public_status`/`sensitivity`/`source_repo`/`source_path`/`source_tasks`/`last_reviewed`/`redaction_checked`)를 정의해뒀다. 이걸 매번 손으로 채우는 대신 Templater 템플릿 3종을 제안:

- `_templates/일반문서.md` — 위 전체 frontmatter, `last_reviewed`는 `tp.date.now("YYYY-MM-DD")`로 자동 채움
- `_templates/MOC.md` — 카테고리 인덱스용, `type: 메타` 고정 + 하위 문서 자동 나열용 Dataview 블록 포함
- `_templates/프로젝트허브.md` — `Wiki 탐색 구조 분석.md`가 정의한 "무엇인가/설치/사용법/문제해결/더 깊게" 랜딩 페이지 골격 (frontmatter 없이, 해당 문서는 원래 공개 랜딩용이라 YAML 노출 안 함 원칙과 일치)

Templater의 `tp.system.suggester()`로 `type`(프로젝트/참고/사용방법/학습/일상/메타) 선택 프롬프트를 만들면 오타·불일치를 줄일 수 있다.

### 4.5 백링크 패널 — Unlinked Mentions 활용

`backlink` 코어 플러그인은 이미 켜져 있고, 기본으로 "Unlinked Mentions"(위키링크 없이 제목만 텍스트로 언급된 곳)도 함께 뜬다. task 산출물 기반으로 새 문서를 만들 때 기존 문서 안에 그 제목이 텍스트로만 언급돼 있는 경우가 흔할 것이므로(예: 새 "워크플로우 오케스트레이션" 페이지를 만들면 과거 문서에 이미 "워크플로우 오케스트레이션"이라는 말이 텍스트로 있었을 가능성), 신규 문서 작성 직후 이 패널을 열어 링크로 승격시키는 습관을 세션 체크리스트에 한 줄 추가하는 것을 제안.

## 5. 태그 팬(`tag-pane`) — 보조 역할 유지, 확장은 최소로

기존 설계 문서(`Wiki 탐색 구조 분석.md`)가 "태그는 보조, 독자 이동성은 MOC·허브가 책임"이라고 이미 명시했고 이는 타당하다. 다만 완전 방치보다는 아주 얕은 상태 태그 하나만 추가 제안:

- `#상태/초안`, `#상태/검수완료`, `#상태/공개` — `public_status` frontmatter 값과 1:1 대응하는 태그를 병행하면 태그 팬 클릭 한 번으로 "검수 안 된 문서 전체"를 훑을 수 있다(현재는 frontmatter 값을 Dataview로 쿼리해야만 보임). 태그 팬은 코어 기능이라 추가 비용 없음.
- 그 이상(주제별 태그 트리 등)은 만들지 않는다 — MOC 체계와 중복되고 유지보수 비용만 늘어남.

## 6. 유지보수 가능성 판단

| 항목 | 판단 |
|---|---|
| Dataview | 안정적이고 가장 널리 쓰이는 커뮤니티 플러그인([Obsibrain 가이드](https://www.obsibrain.com/blog/obsidian-dataview-complete-guide)) — 유지보수 위험 낮음 |
| Templater | 마찬가지로 정착된 플러그인, frontmatter 스키마가 이미 문서화돼 있어 템플릿 작성 비용이 낮음 |
| Bases | 코어 기능이라 설치·업데이트 관리 자체가 없음 — 가장 저비용 |
| 그 외 미채택 도구 | 문서량·인원(1인) 규모에서 이득 대비 유지보수 비용이 큼 → 채택 안 함 |

쿼리는 반드시 `LIMIT`을 걸고(대형 vault에서 대시보드 로딩 저하 방지 사례가 보고됨), 폴더 수가 적은 현재 규모에서는 문제 없으나 관행으로 못박아둘 것을 권장.

## 출처

- [Obsidian Dataview: The Complete Guide (Obsibrain)](https://www.obsibrain.com/blog/obsidian-dataview-complete-guide)
- [Dataview - List Recently Modified Notes (Obsidian TTRPG Tutorials)](https://obsidianttrpgtutorials.com/Obsidian+TTRPG+Tutorials/Plugin+Tutorials/Dataview/Dataview+-+List+Recently+Modified+Notes)
- [Finding Old Notes in Obsidian with Dataview](https://obsidian.rocks/finding-old-notes-in-obsidian-with-dataview/)
- [Find orphaned files and broken links · Obsidian Stats](https://www.obsidianstats.com/plugins/find-unlinked-files)
- [I had 500 orphan notes in Obsidian (MakeUseOf)](https://www.makeuseof.com/orphan-notes-in-obsidian-linking-system/)
- [Finding orphans in Obsidian (Christopher B. Goodman)](https://www.cgoodman.com/blog/2025-05-05-obsidian-orphans/)
- [List Unlinked (Orphaned) Notes in Obsidian (safjan.com)](https://safjan.com/list-unlinked-orphaned-notes-obsidian/)
- [Resurface your Obsidian notes with Dataview queries (Medium)](https://efemkay.medium.com/resurface-your-obsidian-notes-with-these-dataview-queries-97f254c6c9c5)
- [My Obsidian (community) Plugin Stack (Medium)](https://medium.com/a-voice-in-the-conversation/my-obsidian-community-plugin-stack-6fd20520f210)
- [An Overview of the Bases Core Plugin in Obsidian](https://practicalpkm.com/bases-plugin-overview/)
- [Dataview vs Datacore vs Obsidian Bases (Obsidian Rocks)](https://obsidian.rocks/dataview-vs-datacore-vs-obsidian-bases/)
- [Bases: Access backlinks count — Obsidian Forum](https://forum.obsidian.md/t/bases-access-the-number-of-incoming-links-backlinks-of-a-file/101235)
- [The Best Obsidian Plugins for 2026 (dsebastien.net)](https://www.dsebastien.net/the-must-have-obsidian-plugins-for-2026/)
- 로컬 근거: `/mnt/e/Claude/projects/wiki/wiki vault/.obsidian/community-plugins.json`, `core-plugins.json`, `graph.json`
- 로컬 근거: `/mnt/e/Claude/projects/wiki/운영/Wiki 동기화 운영.md`, `Wiki 탐색 구조 분석.md`
