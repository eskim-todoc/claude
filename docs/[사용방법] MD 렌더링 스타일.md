# Markdown 렌더링 스타일

VSCode 로컬 Markdown Preview의 폰트·Mermaid 다이어그램 굵기를 커스터마이징하는 세팅.

> [!NOTE]
> **적용 범위**: VSCode 빌트인 Markdown Preview + `bierner.markdown-preview-github-styles` 확장.
> **적용 안 되는 곳**: GitHub.com 웹 뷰어(전역 CSS 사용), 다른 에디터.

## 파일 구성

| 파일 | 역할 | Git 추적 |
|---|---|---|
| `.vscode/settings.json` | VSCode workspace 설정 — 프리뷰 기본 폰트, 커스텀 CSS 경로 | ✅ |
| `tools/vscode-markdown.css` | 실제 스타일 — 본문·표·헤딩 폰트, Mermaid 선 굵기 | ✅ |

두 파일 모두 `E:/Claude` 내부라 repo 복제 시 따라간다. 단, 아래 "폰트 의존성" 참조.

## 폰트 의존성

| 용도 | 기본 폰트 | Fallback |
|---|---|---|
| 본문·표·헤딩 | **NanumSquareRound** (나눔스퀘어 라운드) | Pretendard → 시스템 기본 sans-serif |
| 코드블록·인라인 코드 | **JB Pretendard Centered** | Pretendard → Consolas → Courier New → monospace |
| Mermaid 다이어그램 텍스트 | 본문과 동일 | 본문과 동일 |

로컬 PC에 해당 폰트가 **설치되어 있어야** 렌더링된다. 미설치 시 fallback chain 순으로 대체되므로 의도한 느낌과 달라질 수 있다.

설치처:
- 나눔스퀘어 라운드: <https://hangeul.naver.com/font/nanum>
- Pretendard (fallback): <https://github.com/orioncactus/pretendard>

## 본문 크기

`.vscode/settings.json` 의 `markdown.preview.fontSize` 로만 제어 (단일 소스).

> [!IMPORTANT]
> 이전 버전에서 CSS `.markdown-body { font-size: ... !important }` 로 하드코딩해 두었다가, settings.json 을 바꿔도 크기가 변하지 않는 현상이 있었다. `!important` 가 설정값을 덮어쓴 게 원인. 지금은 CSS 에서 font-size 하드코딩을 제거하여 `markdown.preview.fontSize` 만으로 크기가 제어된다.

범위: 8 ~ 100 (VSCode 기본 제약). 너무 작으면 렌더러가 번질 수 있으니 보통 10~14 권장.

## Mermaid 다이어그램 축소 방지

기본 동작: Mermaid SVG 는 `max-width: 100%` 로 컨테이너 폭에 맞춰 축소된다 → 큰 다이어그램의 **내부 텍스트도 함께 작아짐**.

현 스타일은 이 규칙을 해제하여 SVG 가 원본 크기를 유지하고, 컨테이너에서 **좌우 스크롤**로 탐색하게 한다. 결과적으로 다이어그램 내부 글자가 항상 일정 크기로 보인다.

```css
.markdown-body .mermaid { overflow-x: auto; }
.markdown-body .mermaid svg {
    max-width: none !important;
    width: auto !important;
    height: auto !important;
}
```

원래 동작(화면 폭에 맞춰 전체 축소)으로 되돌리려면 이 규칙을 제거하면 된다.

## Mermaid 선 굵기

기본 1px 수준 → **2.5px 로 확대**.

영향:
- flowchart / graph 엣지 (화살표)
- 노드 테두리 (사각형·원·타원 등)
- sequenceDiagram 메시지 라인, actor
- stateDiagram 전이
- gitGraph 브랜치 라인

굵기 조정이 필요하면 `tools/vscode-markdown.css` 의 `stroke-width: 2.5px` 값을 일괄 변경.

## 활성화 절차

1. `E:/Claude` 를 VSCode 에서 워크스페이스로 연다 (폴더로 연 상태).
2. Markdown 파일을 열고 `Ctrl+Shift+V` 또는 `Ctrl+K V` 로 Preview 실행.
3. 변경사항이 반영 안 될 때: Command Palette → **Developer: Reload Window**.

## 커스터마이징 포인트

| 바꾸고 싶은 것 | 수정 위치 |
|---|---|
| 본문 폰트 | `tools/vscode-markdown.css` 의 `font-family`, `.vscode/settings.json` 의 `markdown.preview.fontFamily` |
| 본문 크기 | `.vscode/settings.json` 의 `markdown.preview.fontSize` (단일 소스) |
| 선 굵기 | `tools/vscode-markdown.css` 의 `stroke-width` |
| 코드블록 폰트 | `tools/vscode-markdown.css` 의 `.markdown-body code, pre` 블록 |
| Mermaid 테마 색 | Mermaid `%%{init: {...}}%%` directive (문서별), 또는 CSS 에서 `.mermaid svg .node rect { fill: ... }` |

## 주의사항

> [!CAUTION]
> `markdown.styles` 경로는 **워크스페이스 루트 기준 상대경로**. `E:/Claude` 외 다른 경로에서 VSCode 를 열면 CSS 가 로드되지 않는다.

> [!NOTE]
> GitHub PR/Issue 에서는 이 스타일이 적용되지 않는다. 팀원이나 외부 공유 시 다이어그램 가독성은 Mermaid 자체의 `themeVariables` 설정으로 보강해야 한다.
