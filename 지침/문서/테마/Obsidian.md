---
name: 웜 페이퍼 테마 — Obsidian 적용
purpose: 웜 페이퍼 팔레트를 Obsidian(특히 wiki Vault)에 CSS 스니펫으로 적용하는 가이드
type: 지침
applies_to: [root, projects]
maturity: experimental
tags: [docs, style, theme, obsidian, wiki, css-snippet]
---

# 웜 페이퍼 테마 — Obsidian 적용

**TL;DR**: [문서 테마 스타일.md](../테마%20토큰.md) 팔레트를 Obsidian CSS 변수로 오버라이드하는 `.theme-light` 스니펫. 표준 변수 + GitHub Alert 콜아웃 + Things 테마 보강 3계층. **베이스 스킴을 Light로 전환해야** 적용된다(wiki Vault는 현재 다크 베이스).

## 1. CSS 스니펫

`.obsidian/snippets/warm-paper.css`로 저장한다. `.theme-light` 스코프라 라이트 모드에서만 적용된다.

```css
/* 웜 페이퍼 테마 — Obsidian 라이트 전용 스니펫 */
.theme-light {
  /* 배경 (밝기 위계: card-bg > surface-1 > page-plane) */
  --background-primary: #FBF7EE;         /* 본문 읽기/편집 */
  --background-primary-alt: #FAF5EA;
  --background-secondary: #EFE7D6;        /* 사이드바·탭바·상태바 */
  --background-secondary-alt: #E6DAC2;
  --background-modifier-border: #E2D5BC;
  --background-modifier-border-focus: #C15F3C;
  --background-modifier-form-field: #FAF5EA;
  --background-modifier-error: #F4DCD0;

  /* 텍스트 */
  --text-normal: #33291C;
  --text-muted: #6E5F48;
  --text-faint: #AAA089;
  --text-accent: #C15F3C;                 /* 주 액센트 */
  --text-accent-hover: #9C4D30;           /* accent-1 명도 낮춤 */
  --text-warning: #7A5A0E;
  --text-error: #A23B22;
  --text-success: #2F5C50;
  --text-selection: rgba(193, 95, 60, 0.25);

  /* 인터랙티브·링크 */
  --interactive-accent: #C15F3C;
  --interactive-accent-hover: #9C4D30;
  --interactive-success: #3E6E64;         /* 보조 액센트 */
  --link-color: #C15F3C;
  --link-color-hover: #9C4D30;
  --link-external-color: #3E6E64;         /* 외부 링크는 보조색으로 구분 */

  /* 스크롤바 */
  --scrollbar-thumb-bg: #C7C0B0;
  --scrollbar-active-thumb-bg: #AAA089;
}

/* GitHub Alert 콜아웃 매핑 */
.theme-light {
  --callout-note: 47, 92, 80;             /* info-fg */
  --callout-tip: 62, 110, 100;            /* accent-2 */
  --callout-important: 193, 95, 60;       /* accent-1 */
  --callout-warning: 122, 90, 14;         /* warn-fg */
  --callout-error: 162, 59, 34;           /* danger-fg */
}
```

### 1.1 Things 테마 보강 (선택)

wiki Vault가 커뮤니티 테마 **Things**를 쓰는 경우, 헤더·태그는 Things 자체 커스텀 변수로만 색이 잡히므로 표준 변수만으로는 불완전하다. 아래를 함께 켠다.

```css
.theme-light {
  --h1-color: #33291C;  --h2-color: #33291C;
  --h3-color: #3E6E64;  --h4-color: #7A5A0E;
  --h5-color: #A23B22;  --h6-color: #6E5F48;
  --tag-background-color-l: #D6E6DF;
  --tag-font-color-l: #2F5C50;
}
```

## 2. 활성화 안내

> [!IMPORTANT]
> **① 베이스 스킴을 Light로 먼저 전환** — Settings → Appearance → Base color scheme을 **Light**로. 이 스니펫은 `.theme-light` 스코프라, 다크 베이스에서는 켜도 **아무 변화가 없다**(가장 흔한 함정). wiki Vault는 현재 다크 베이스다.
>
> **② 스니펫 배치·활성화** — `<Vault>/.obsidian/snippets/warm-paper.css`에 저장 → Settings → Appearance → CSS snippets에서 토글 ON. 저장 즉시 핫리로드(재시작 불필요), 앱 전역(본문·사이드바·탭바·설정 모달)에 적용.

> [!WARNING]
> **기존 `wiki-site.css`와 혼재 주의** — wiki Vault에 이미 `wiki-site.css`(cool blue, `.markdown-preview-view` 스코프)가 활성화돼 있으면, 신규 웜 페이퍼(전역 변수)와 동시 적용 시 일부 요소(`.wiki-hero`·표·H1/H2)는 기존 blue로 남고 나머지는 warm paper로 바뀌는 팔레트 혼재가 생긴다. **병행 / 치환 / 양자택일**을 먼저 정한다.

## 3. 라이트 전용

웜 페이퍼는 다크 변형이 없다([문서 테마 스타일.md §6](../테마%20토큰.md)). 다크 모드가 필요하면 이 스니펫 대신 Obsidian 기본 다크를 쓴다(웜 페이퍼는 라이트에서만).

## 4. 관련

- [문서 테마 스타일.md](../테마%20토큰.md) — 토큰 SSOT
- [HTML-아티팩트.md](HTML-아티팩트.md) · [Mermaid.md](Mermaid.md) — 다른 트랙
