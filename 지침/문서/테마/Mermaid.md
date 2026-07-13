---
name: 웜 페이퍼 테마 — Mermaid 적용
purpose: 웜 페이퍼 팔레트를 Mermaid 다이어그램에 적용하는 themeVariables·classDef (대비 안전)
type: 지침
applies_to: [root, projects]
maturity: experimental
tags: [docs, style, theme, mermaid, diagram]
---

# 웜 페이퍼 테마 — Mermaid 적용

**TL;DR**: 문서 frontmatter에 `theme: warm-paper`가 있을 때만 웜 페이퍼 팔레트를 Mermaid에 적용한다. `themeVariables`로 전역 색을 잡고 `classDef`로 노드 유형별 채색하되, **stroke는 잉크·액센트 계열**로 잡아 대비를 확보한다(옅은 구분선 토큰을 테두리에 쓰면 대비 실패). [작성-스타일.md §4.3.1](../작성-스타일.md) 8요소 구조 정책은 그대로 준수한다.

## 1. 선택 기준 (기계적)

> [!IMPORTANT]
> **`theme: warm-paper`일 때만 적용한다.** 문서 frontmatter에 `theme: warm-paper` 필드가 있으면 아래 웜 페이퍼 classDef를 쓰고, 없으면 [작성-스타일.md §4.3.2](../작성-스타일.md)의 기본 5색 muted 팔레트를 쓴다. 두 팔레트는 **같은 taxonomy 슬롯(terminal·step·io·trigger·core)의 대체재**이지 병용 대상이 아니다.

```yaml
---
theme: warm-paper   # 이 필드가 있을 때만 아래 팔레트 적용
---
```

## 2. themeVariables (전역 색)

`init` 지시자로 다이어그램 전역 기본색을 웜 페이퍼로 잡는다. `darkMode:false` 고정(배경 환경 무관 — §4.3.1 요소⑤와 정합).

```
%%{init: {'theme':'base','themeVariables':{
  'darkMode': false,
  'background': '#EFE7D6',
  'primaryColor': '#FBF7EE',
  'primaryTextColor': '#33291C',
  'primaryBorderColor': '#33291C',
  'secondaryColor': '#D6E6DF',
  'tertiaryColor': '#FAF5EA',
  'lineColor': '#6B5C46',
  'textColor': '#33291C',
  'fontFamily': 'system-ui, -apple-system, "Segoe UI", "Pretendard", "Noto Sans KR", sans-serif'
}}}%%
```

- `lineColor`(엣지)는 옅은 `--gridline`이 아니라 `--text-secondary #6B5C46`를 쓴다 — 화살표가 배경에 묻히지 않게.

## 3. classDef (노드 유형별, 대비 안전)

flowchart 5 taxonomy에 대응. **stroke는 반드시 잉크·액센트 계열**(fill의 옅은 톤이 아니라). 아래 조합은 WCAG 3:1 비텍스트 대비를 확보한다.

```
    classDef terminal fill:#FAF5EA,stroke:#33291C,stroke-width:2px,color:#33291C;
    classDef step     fill:#FBF7EE,stroke:#6B5C46,stroke-width:1px,color:#33291C;
    classDef io       fill:#D6E6DF,stroke:#3E6E64,stroke-width:1.5px,color:#2F5C50;
    classDef trigger  fill:#F7E7BE,stroke:#7A5A0E,stroke-width:1.5px,color:#7A5A0E;
    classDef core     fill:#F5DECB,stroke:#C15F3C,stroke-width:2px,color:#A23B22;
```

| 클래스 | 의미 | fill | stroke | 근거 |
|---|---|---|---|---|
| `terminal` | 시작·종료 | surface-1 | text-primary | 잉크 테두리 강조 |
| `step` | 일반 처리 | card-bg | text-secondary | 기본 카드 |
| `io` | 입출력 | accent-2-tint-1 | accent-2 | 틸 계열 |
| `trigger` | 조건·분기 | warn-bg | warn-fg | 주의 환기 |
| `core` | 핵심·강조 | accent-1-tint-1 | accent-1 | 테라코타 강조 |

> [!WARNING]
> **옅은 구분선 토큰(`--card-border`·`--gridline`·`--idle-border`·`--baseline`)을 노드 stroke에 쓰지 말 것.** 이들은 배경과 대비 1.1~1.6:1로 3px 테두리에서도 거의 안 보인다. stroke는 반드시 텍스트·액센트 계열(위 표)로 잡는다.

## 4. 예시 (flowchart)

노드 라벨 특수문자는 큰따옴표로 감싼다([작성-스타일.md §4.5](../작성-스타일.md)).

```
%%{init: {'theme':'base','themeVariables':{'darkMode':false,'background':'#EFE7D6','primaryColor':'#FBF7EE','primaryTextColor':'#33291C','lineColor':'#6B5C46'}}}%%
flowchart TD
    A["시작"] --> B["입력 파싱"]
    B --> C{"유효한가?"}
    C -->|"예"| D["핵심 처리"]
    C -->|"아니오"| E["오류 반환"]
    D --> F["결과 출력"]

    class A,F terminal
    class B step
    class C trigger
    class D core
    class E trigger
    classDef terminal fill:#FAF5EA,stroke:#33291C,stroke-width:2px,color:#33291C;
    classDef step     fill:#FBF7EE,stroke:#6B5C46,stroke-width:1px,color:#33291C;
    classDef trigger  fill:#F7E7BE,stroke:#7A5A0E,stroke-width:1.5px,color:#7A5A0E;
    classDef core     fill:#F5DECB,stroke:#C15F3C,stroke-width:2px,color:#A23B22;
```

## 5. 기존 정책과의 관계

| 기존 정책 | 관계 |
|---|---|
| [§4.3.1](../작성-스타일.md) flowchart 8요소 구조 정책 | **무충돌** — 색과 무관한 구조 규칙(방향·노드 모양·라벨 등). 그대로 준수 |
| [§4.3.2](../작성-스타일.md) 기본 5색 muted 팔레트 | **대체 팔레트** — `theme: warm-paper`일 때 이 파일 §3 classDef로 전환(§1) |
| [§4.5](../작성-스타일.md) 노드 라벨 안전 규칙 | **보완** — 특수문자 큰따옴표·`<br/>` 줄바꿈 등 그대로 적용 |

## 6. 관련

- [문서 테마 스타일.md](../테마%20토큰.md) — 토큰 SSOT
- [HTML-아티팩트.md](HTML-아티팩트.md) · [Obsidian.md](Obsidian.md) — 다른 트랙
