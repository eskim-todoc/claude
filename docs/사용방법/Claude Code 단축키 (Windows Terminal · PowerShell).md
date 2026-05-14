---
name: Claude Code 단축키 (Windows Terminal · PowerShell)
purpose: Claude Code 인터랙티브 모드를 제어하는 단축키 — Windows Terminal + PowerShell 환경 기준 동작·충돌 정리
type: 사용방법
applies_to:
  - root
tags:
  - claude-code
  - keyboard
  - keybindings
  - windows-terminal
  - powershell
---

# Claude Code 단축키 (Windows Terminal · PowerShell)

**TL;DR**: Claude Code 인터랙티브 세션을 *제어*하는 단축키 모음 — 권한 모드 순환·모델 선택·확장 사고/Fast Mode 토글·응답 중단/되돌리기·트랜스크립트 뷰어·작업 목록·서브에이전트 일괄 종료·외부 에디터 편집·이미지 붙여넣기 등 Claude Code 고유 제어 키를 중심으로 정리한다. Windows Terminal 기본 키와 충돌하는 항목만 별도 표기. 표준 readline 라인편집 키(`Ctrl+A/E/K` 등)는 부록으로 분리.

---

## 환경 전제

| 항목 | 값 |
|---|---|
| 터미널 | Microsoft Store 배포판 Windows Terminal (v1.18 이상 권장) |
| 셸 | Windows PowerShell 5.1 또는 PowerShell 7.x |
| Claude Code | CLI (`claude` 실행 후 인터랙티브 모드) |
| 입력 모드 | 영문 모드(IME OFF) 권장 — 한글 IME ON 시 일부 `Alt` 조합이 한자 변환 등으로 가로채일 수 있음 |

> [!NOTE]
> 본 문서는 **Claude Code를 제어하는 단축키**(모드 전환·세션 제어·뷰어·에이전트 등) 중심이다. PowerShell readline / Windows Terminal 자체의 단축키는 [§7 충돌·주의](#7-windows-terminal과의-충돌--주의)와 [부록 A](#부록-a-readline-라인편집-단축키-참고)에 참고용으로만 둔다.

---

## 1. 모드 전환 (Claude Code 고유)

| 단축키 | 동작 |
|---|---|
| `Shift+Tab` | 권한 모드 순환: `default` → `acceptEdits` → `plan` → … |
| `Alt+M` | `Shift+Tab` 대체 (Shift+Tab이 안 잡히는 환경용) |
| `Alt+P` | 모델 선택기 열기 |
| `Alt+T` | Extended Thinking(확장 사고) 토글 |
| `Alt+O` | Fast Mode 토글 (Opus 4.6 / 4.7 한정) |

---

## 2. 응답·세션 제어 (Claude Code 고유)

| 단축키 | 동작 |
|---|---|
| `Esc` | Claude 응답 중단 (진행 상황 보존) |
| `Esc` × 2 | 이전 상태로 되돌리기 / 요약 |
| `Ctrl+C` | 현재 입력 또는 생성 취소 |
| `Ctrl+D` | Claude Code 세션 종료 (빈 입력 상태에서) |
| `Ctrl+L` | 화면 redraw (입력·히스토리 보존) |
| `Ctrl+Shift+-` (`Ctrl+_`) | Undo |

> [!IMPORTANT]
> `Esc`는 **응답 생성을 즉시 멈추되 현재까지의 출력은 보존**한다. `Ctrl+C`는 **현재 입력 행을 취소** — 차이를 구분해 쓸 것.

---

## 3. 작업·에이전트·뷰어 제어 (Claude Code 고유)

| 단축키 | 동작 |
|---|---|
| `Ctrl+O` | 트랜스크립트 뷰어 토글 — 내부 키는 [§5](#5-트랜스크립트-뷰어-내부-키-ctrlo-진입-후) |
| `Ctrl+T` | 작업(TaskList) 목록 토글 |
| `Ctrl+B` | 백그라운드 작업 전환 (Tmux 사용자는 2회) |
| `Ctrl+X Ctrl+K` | 모든 서브에이전트 일괄 종료 (2회 확인) |
| `Ctrl+G` 또는 `Ctrl+X Ctrl+E` | 외부 에디터로 프롬프트 편집 (`$EDITOR` / `$VISUAL`) |
| `Alt+V` | 클립보드 이미지 붙여넣기 (Windows 권장) |
| `Ctrl+V` | 클립보드 텍스트·이미지 붙여넣기 (텍스트만 신뢰. 이미지는 `Alt+V` 권장) |
| `←` / `→` | 대화 탭 순환 |

---

## 4. 입력 도우미 (Claude Code 고유 메뉴 트리거)

| 단축키 | 동작 |
|---|---|
| `/` | 슬래시 명령·스킬 자동완성 메뉴 열기 |
| `!` | 셸 명령 직접 실행 모드 (PowerShell로 명령 전달) |
| `@` | 파일 경로 자동완성 메뉴 열기 |
| `Shift+Enter` | 입력 줄바꿈 |
| `Ctrl+J` | 줄바꿈 (모든 터미널 호환 — 가장 안전) |
| `\` + `Enter` | 줄바꿈 (빠른 입력) |

> [!TIP]
> `Shift+Enter`가 그냥 `Enter`로 처리되면 `Ctrl+J`를 쓰거나, Windows Terminal `settings.json`에 다음을 추가:
>
> ```json
> { "command": { "action": "sendInput", "input": "\r" }, "keys": "shift+enter" }
> ```

---

## 5. 트랜스크립트 뷰어 내부 키 (`Ctrl+O` 진입 후)

| 단축키 | 동작 |
|---|---|
| `?` | 키보드 도움말 (전체화면 렌더링) |
| `{` / `}` | 이전 / 다음 사용자 프롬프트로 점프 |
| `Ctrl+E` | 메시지 전체 내용 표시 토글 |
| `[` | 스크롤백 영역으로 대화 기록 출력 |
| `v` | 임시 파일로 `$VISUAL` / `$EDITOR` 열기 |
| `q` / `Ctrl+C` / `Esc` | 뷰어 종료 |

---

## 6. Vim 모드 (`/config` → Editor mode = `vim` 활성화 시)

| 모드 | 주요 키 |
|---|---|
| NORMAL | `h` `j` `k` `l` (이동) / `dd` `x` (삭제) / `u` (undo) / `yy` `p` (yank/paste) |
| INSERT | `i` `I` `a` `A` `o` `O` |
| VISUAL | `v` (문자 선택) / `V` (줄 선택) |

> [!IMPORTANT]
> Vim 모드에서 `Esc`는 **INSERT → NORMAL 전환만** 한다. Claude 응답 중단(`Esc`)은 NORMAL 모드에서만 동작.

---

## 7. Windows Terminal과의 충돌·주의

### 7.1 Claude Code 제어 단축키 중 Windows Terminal이 가로채는 키

| Claude Code가 원하는 키 | Windows Terminal이 가로채는 동작 | 회피 |
|---|---|---|
| (현재 충돌 없음) | — | — |

> [!NOTE]
> Claude Code의 **제어 단축키(§1~§4)** 는 모두 단일 `Ctrl/Alt + 키` 형태로, Windows Terminal 기본 키 바인딩(`Ctrl+Shift+*`, `Ctrl+,`, `Ctrl+Tab`, `Alt+Enter`, `F11` 등)과 직접 충돌하지 않는다. 정상 통과.

### 7.2 한글 IME 활성 시 주의

| 조합 | 충돌 양상 |
|---|---|
| `Alt+한자` | 한자 변환창 호출 — `Alt+T`/`Alt+P` 등과 시각적 혼동 가능 |
| `Shift+Space` | (IME 설정에 따라) 한/영 전환 — 입력 흐름 끊김 |
| `한/영` 전환 직후 | 첫 한두 키 입력이 IME에 잡혀 무반응 가능 |

> [!TIP]
> 단축키 누르기 직전 영문 모드로 전환할 것. 누른 뒤 한글로 돌려도 무방.

### 7.3 Windows Terminal 기본 단축키 (참고 — Claude Code 제어와 무관)

`Ctrl+Shift+T`(새 탭) · `Ctrl+Shift+W`(탭 닫기) · `Ctrl+Shift+P`(명령 팔레트) · `Ctrl+Shift+F`(터미널 검색) · `Ctrl+,`(설정) · `Ctrl+Tab`(탭 전환) · `Alt+Enter`(전체화면) · `F11`(전체화면) · `Ctrl+=` / `Ctrl+-` / `Ctrl+0`(폰트 크기).

→ Claude Code 제어 키와 겹치지 않으므로 사용 흐름에 영향 없음.

---

## 8. 커스터마이즈

| 항목 | 위치 |
|---|---|
| 사용자 키바인딩 재정의 | `C:\Users\<USER>\.claude\keybindings.json` |
| 편집 가이드 | Claude Code 슬래시 명령 `/keybindings-help` |

> [!NOTE]
> 본 문서는 **기본값** 기준이다. `keybindings.json`에서 재정의했다면 그쪽이 우선.

---

## 부록 A. readline 라인편집 단축키 (참고)

Claude Code 입력창은 표준 readline 키바인딩을 따른다. 아래 키들은 PowerShell의 PSReadLine에서도 동일하게 동작하므로 "Claude Code 고유"는 아니지만, 인터랙티브 입력 중 그대로 쓸 수 있다.

| 단축키 | 동작 |
|---|---|
| `Ctrl+A` / `Ctrl+E` | 줄 시작 / 끝 이동 |
| `Ctrl+K` / `Ctrl+U` | 커서~줄끝 / 줄시작~커서 삭제 |
| `Ctrl+W` | 이전 단어 삭제 |
| `Ctrl+Y` / `Alt+Y` | yank 붙여넣기 / yank 항목 순환 |
| `Alt+B` / `Alt+F` | 단어 단위 뒤 / 앞 이동 |
| `↑` / `↓` 또는 `Ctrl+P` / `Ctrl+N` | 입력 히스토리 |
| `Ctrl+R` | 입력 히스토리 역순 검색 |

---

## 부록 B. 빠른 참조 카드 (Claude Code 제어 키만)

```
모드:     Shift+Tab(권한)  Alt+M(대체)  Alt+P(모델)  Alt+T(thinking)  Alt+O(fast)
응답:     Esc(중단)  Esc×2(되돌리기)  Ctrl+C(취소)  Ctrl+L(redraw)  Ctrl+D(종료)
Undo:     Ctrl+Shift+-
뷰어:     Ctrl+O(트랜스크립트)  Ctrl+T(작업)  Ctrl+B(백그라운드)
에이전트: Ctrl+X Ctrl+K (×2 일괄 종료)
편집:     Ctrl+G  또는  Ctrl+X Ctrl+E (외부 에디터)
입력:     /(슬래시)  !(셸)  @(파일)  Shift+Enter/Ctrl+J/\+Enter(줄바꿈)
붙여넣기: Alt+V(이미지)  Ctrl+V(텍스트)
대화 탭:  ← / →
```
