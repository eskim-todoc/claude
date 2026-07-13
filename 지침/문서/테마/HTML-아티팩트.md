---
name: 웜 페이퍼 테마 — HTML·아티팩트 적용
purpose: 웜 페이퍼 테마를 HTML 뷰어·Artifact에 적용하는 복붙 CSS 변수·컴포넌트 스니펫
type: 지침
applies_to: [root, projects]
maturity: experimental
tags: [docs, style, theme, html, artifact, css]
---

# 웜 페이퍼 테마 — HTML·아티팩트 적용

**TL;DR**: [문서 테마 스타일.md](../테마%20토큰.md) 토큰을 HTML 뷰어·self-contained 아티팩트에 입히는 복사-붙여넣기 가이드. `:root` 블록을 통째로 넣고 컴포넌트 CSS를 골라 쓴다. 라이트 전용 — Artifact 도구로 렌더 시 "의도적 단일톤 committing"임을 명시한다.

## 1. :root 토큰 블록 (복붙)

`<style>` 최상단에 그대로 붙인다. 토큰명은 [SSOT §2](../테마%20토큰.md)와 동일.

```css
:root {
  /* 배경·표면 */
  --page-plane: #EFE7D6;
  --surface-1: #FAF5EA;
  --card-bg: #FBF7EE;
  --card-border: #E2D5BC;
  --gridline: #E6DAC2;
  --baseline: #CBB999;
  /* 텍스트 */
  --text-primary: #33291C;
  --text-secondary: #6B5C46;
  --text-muted: #6E5F48;
  /* 액센트 1 — 주 강조 (테라코타) */
  --accent-1: #C15F3C;
  --accent-1-tint-1: #F5DECB;
  --accent-1-tint-2: #ECC7A6;
  --accent-1-tint-3: #E2AE82;
  /* 액센트 2 — 보조 (딥 틸) */
  --accent-2: #3E6E64;
  --accent-2-tint-1: #D6E6DF;
  --accent-2-tint-2: #C1D9CE;
  --accent-2-tint-3: #ACCCBD;
  /* semantic */
  --warn-bg: #F7E7BE;  --warn-fg: #7A5A0E;
  --danger-bg: #F4DCD0; --danger-fg: #A23B22;
  --info-bg: #DEE9E3;  --info-fg: #2F5C50;
  /* 유휴 */
  --idle-fill: #C7C0B0; --idle-border: #AAA089;
}

* { box-sizing: border-box; }
body {
  margin: 0; padding-bottom: 40px;
  background: var(--page-plane); color: var(--text-primary);
  font-family: system-ui, -apple-system, "Segoe UI", "Pretendard", "Noto Sans KR", sans-serif;
  font-size: 13px;
}
```

## 2. 컴포넌트 CSS 스니펫

필요한 것만 골라 쓴다. border 원칙: **solid=구조 컨테이너 / dashed=주석·보조**, 내부 반복 구분선은 더 옅은 `--gridline`.

### 2.1 카드 (12px 라운드)
```css
.card {
  background: var(--card-bg); border: 1px solid var(--card-border);
  border-radius: 12px; padding: 14px 18px;
}
```

### 2.2 stats 헤어라인 그리드
셀 사이 `gap:1px`에 배경색을 채워 개별 border 없이 1px 구분선을 만든다.
```css
.stats {
  display: grid; gap: 1px;
  background: var(--gridline); border: 1px solid var(--card-border);
  border-radius: 12px; overflow: hidden;   /* 자식 모서리 일괄 라운딩 */
}
.stats > div { background: var(--card-bg); padding: 9px 14px; }
.stats .head { font-weight: 700; background: var(--surface-1); }   /* 크기 아닌 weight+배경으로 헤더 구분 */
```

### 2.3 panel-title + dot 배지 (범례 스와치)
```css
.panel-title { display: flex; align-items: center; gap: 10px; font-size: 15px; font-weight: 700; }
.dot { width: 11px; height: 11px; border-radius: 50%; display: inline-block; }
.dot.primary { background: var(--accent-1); }
.dot.secondary { background: var(--accent-2); }
```

### 2.4 note / 빈 상태 (점선)
```css
.note {
  background: var(--card-bg); border: 1px dashed var(--card-border);
  border-radius: 10px; padding: 10px 12px;
  font-size: 12.5px; color: var(--text-secondary);
}
.empty-msg { text-align: center; padding: 16px; color: var(--text-secondary); }
```

### 2.5 tooltip (fixed + 그림자)
```css
.tooltip {
  position: fixed; pointer-events: none; white-space: nowrap;
  background: var(--card-bg); border: 1px solid var(--card-border);
  border-radius: 6px; padding: 5px 8px; color: var(--text-primary);
  box-shadow: 0 4px 14px rgba(51, 41, 28, 0.18);   /* 잉크색 틴트 그림자 */
}
```

### 2.6 액센트 컨트롤 (슬라이더·입력)
```css
input[type=range] { accent-color: var(--accent-1); }
input[type=number], select {
  border: 1px solid var(--card-border); border-radius: 6px;
  background: var(--surface-1); color: var(--text-primary);
  font-variant-numeric: tabular-nums;   /* 숫자 자리흔들림 방지 */
}
```

## 3. 타이포 위계

크기보다 **weight+색**으로 위계를 만든다.

| 용도 | size | weight | color |
|---|---|---|---|
| h1 | 17px | 700 | `--text-primary` |
| 패널 타이틀 | 15px | 700 | `--text-primary` |
| 본문·stats | 13px | 400 | `--text-primary` |
| 주 라벨 | 12px | 600 | `--text-secondary` |
| 부제·단위 | 12px | 400 | `--text-muted` |
| 보조 라벨 | 11px | 500 | `--text-muted` |

## 4. 라이트 전용 주의 (Artifact)

> [!IMPORTANT]
> **Claude Artifact로 렌더할 때**: Artifact 도구는 뷰어의 라이트/다크를 **모두** 스타일하는 것이 기본 계약이다. 웜 페이퍼는 라이트 단일이므로, 이는 **의도적 단일톤(라이트) committing**에 해당한다 — 페이지 상단 주석이나 문서 설명에 "라이트 전용 테마(의도적 단일톤)"임을 명시해 도구 계약과 어긋나지 않게 한다. 다크 뷰어에서도 크림 배경 그대로 나오는 것이 의도된 동작이다.
>
> **정적 `.html` 파일**(비-Artifact, 로컬 브라우저로 여는 뷰어·도구)은 이 계약과 무관하므로 라이트 전용이 자유 선택이다.

## 5. 관련

- [문서 테마 스타일.md](../테마%20토큰.md) — 토큰 SSOT(§2 색·§3 타이포)
- [Mermaid.md](Mermaid.md) · [Obsidian.md](Obsidian.md) — 다른 트랙
