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

본문 기본 폰트: **JB Pretendard Centered**

- 로컬 PC에 해당 폰트가 **설치되어 있어야** 렌더링된다.
- 미설치 시 fallback chain 순으로 대체: `Pretendard` → `-apple-system` → `BlinkMacSystemFont` → `Segoe UI` → `Noto Sans KR` → sans-serif
- 설치 권장: <https://github.com/orioncactus/pretendard> (Pretendard) 또는 JetBrains 계열 커스텀.

코드블록은 `JetBrains Mono` → `Consolas` → `Courier New` 순.

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
| 선 굵기 | `tools/vscode-markdown.css` 의 `stroke-width` |
| 코드블록 폰트 | `tools/vscode-markdown.css` 의 `.markdown-body code, pre` 블록 |
| Mermaid 테마 색 | Mermaid `%%{init: {...}}%%` directive (문서별), 또는 CSS 에서 `.mermaid svg .node rect { fill: ... }` |

## 주의사항

> [!CAUTION]
> `markdown.styles` 경로는 **워크스페이스 루트 기준 상대경로**. `E:/Claude` 외 다른 경로에서 VSCode 를 열면 CSS 가 로드되지 않는다.

> [!NOTE]
> GitHub PR/Issue 에서는 이 스타일이 적용되지 않는다. 팀원이나 외부 공유 시 다이어그램 가독성은 Mermaid 자체의 `themeVariables` 설정으로 보강해야 한다.
