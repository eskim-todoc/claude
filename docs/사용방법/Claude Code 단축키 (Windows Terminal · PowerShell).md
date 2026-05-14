---
name: Claude Code 단축키 (Windows Terminal · PowerShell)
purpose: Microsoft Store판 Windows Terminal + PowerShell 환경에서 동작이 검증된 Claude Code CLI 키 바인딩 정리
type: 사용방법
applies_to:
  - root
tags:
  - claude-code
  - keyboard
  - windows-terminal
  - powershell
  - keybindings
---

# Claude Code 단축키 (Windows Terminal · PowerShell)

**TL;DR**: Microsoft Store판 Windows Terminal에서 PowerShell로 Claude Code를 띄운 환경에서 실제 통과되는 단축키만 골라 정리한다. Claude Code의 기본 키 바인딩 대부분은 그대로 동작하지만, 터미널이 가로채는 키(`Ctrl+Shift+*`, `Ctrl+,`, `Ctrl+Tab`, `F11`, `Alt+Enter` 등)와 한글 IME 활성 시 충돌하는 키는 별도로 표기한다. macOS 전용 표기는 제외하고 Windows 표준 `Alt` 표기만 남긴다.

---

## 환경 전제

| 항목 | 값 |
|---|---|
| 터미널 | Microsoft Store 배포판 Windows Terminal (v1.18 이상 권장) |
| 셸 | Windows PowerShell 5.1 또는 PowerShell 7.x |
| 입력 모드 | 영문 모드(IME OFF) 권장 — 한글 IME ON일 때 일부 `Alt`/`Ctrl` 조합 충돌 가능 |
| Claude Code | CLI (`claude` 실행 후 인터랙티브 모드) |

> [!IMPORTANT]
> Windows Terminal의 **Settings → Actions(키 바인딩)** 에서 일부 키를 재정의했다면 표 내용과 다를 수 있다. 본 표는 **Windows Terminal 기본 키 바인딩** 기준이다.

---

## 1. 입력·편집

| 단축키 | 동작 | 비고 |
|---|---|---|
| `Ctrl+A` | 줄 시작으로 이동 | Emacs 스타일 |
| `Ctrl+E` | 줄 끝으로 이동 | |
| `Ctrl+K` | 커서~줄 끝 삭제 (yank 버퍼 저장) | |
| `Ctrl+U` | 줄 시작~커서 삭제 (yank 버퍼 저장) | |
| `Ctrl+W` | 이전 단어 삭제 | Windows Terminal 기본 매핑 없음 — 통과됨 |
| `Ctrl+Y` | yank 버퍼 붙여넣기 | |
| `Alt+Y` | 붙여넣기 후 이전 yank 항목 순환 | |
| `Alt+B` | 단어 단위 뒤로 이동 | |
| `Alt+F` | 단어 단위 앞으로 이동 | |
| `↑` / `↓` | 입력 히스토리 또는 커서 이동 | 멀티라인 입력 시 줄 단위 |
| `Ctrl+P` / `Ctrl+N` | 히스토리 ↑/↓ 또는 커서 이동 | |
| `Shift+Enter` | 줄바꿈 (개행) | Windows Terminal v1.4+ 기본 통과. 안 되면 `Ctrl+J` 또는 `\` + `Enter` |
| `Ctrl+J` | 줄바꿈 (모든 터미널 호환) | 키 충돌 없음 — 가장 안전한 줄바꿈 |
| `\` + `Enter` | 줄바꿈 (빠른 입력) | |
| `Ctrl+_` (`Ctrl+Shift+-`) | Undo | 한글 키보드에선 `Ctrl+Shift+-` 권장. 일부 키맵에서 전달 실패 가능 — [§7](#7-windows-terminal--powershell-충돌·주의사항) 참고 |

---

## 2. 모드 전환

| 단축키 | 동작 | 비고 |
|---|---|---|
| `Shift+Tab` | 권한 모드 순환 (`default` → `acceptEdits` → `plan` → …) | Windows Terminal에서 정상 전달 |
| `Alt+M` | `Shift+Tab` 대체 | 일부 SSH/터미널에서 Shift+Tab이 안 잡힐 때 보조 |
| `Alt+P` | 모델 선택기 열기 | |
| `Alt+T` | Extended Thinking(확장 사고) 토글 | |
| `Alt+O` | Fast Mode 토글 | Opus 4.6 / 4.7에서만 활성 |

---

## 3. 슬래시·메뉴·자동완성

| 단축키 | 동작 |
|---|---|
| `/` | 슬래시 명령·스킬 자동완성 메뉴 열기 |
| `!` | 셸 명령 직접 실행 모드 (PowerShell로 명령 전달) |
| `@` | 파일 경로 자동완성 메뉴 열기 |

---

## 4. 화면·세션 제어

| 단축키 | 동작 | 비고 |
|---|---|---|
| `Ctrl+L` | 화면 redraw (입력·히스토리 보존) | |
| `Ctrl+O` | 트랜스크립트 뷰어 토글 | 진입 후 단축키는 [§5](#5-트랜스크립트-뷰어-ctrlo-진입-후) |
| `Ctrl+C` | 현재 입력 또는 생성 취소 | |
| `Esc` | Claude 응답 중단 (진행 상황 보존) | |
| `Esc` × 2 | 이전 상태로 되돌리기 / 요약 | |
| `Ctrl+D` | Claude Code 세션 종료 | 빈 입력 상태에서만 동작 |
| `Ctrl+R` | 입력 히스토리 역순 검색 | Claude Code 내부 검색 — PSReadLine과 별개 |
| `Ctrl+T` | 작업(TaskList) 목록 토글 | Windows Terminal 기본 매핑 없음 — 통과됨 |

---

## 5. 트랜스크립트 뷰어 (`Ctrl+O` 진입 후)

| 단축키 | 동작 |
|---|---|
| `?` | 키보드 도움말 (전체화면 렌더링) |
| `{` / `}` | 이전 / 다음 사용자 프롬프트로 점프 |
| `Ctrl+E` | 메시지 전체 내용 표시 토글 |
| `[` | 스크롤백 영역으로 대화 기록 출력 (`Ctrl+Shift+F`로 터미널 검색 가능) |
| `v` | 임시 파일로 `$VISUAL` / `$EDITOR` 열기 |
| `q` / `Ctrl+C` / `Esc` | 뷰어 종료 |

---

## 6. 기타 단축키

| 단축키 | 동작 | 비고 |
|---|---|---|
| `Ctrl+G` 또는 `Ctrl+X Ctrl+E` | 외부 에디터로 프롬프트 편집 | `$EDITOR` 또는 `$VISUAL` 환경변수 |
| `Ctrl+B` | 백그라운드 작업 전환 | Tmux 사용자는 2회 |
| `Ctrl+X Ctrl+K` | 모든 서브에이전트 종료 | 2회 누름 확인 필요 |
| `Ctrl+V` | 클립보드에서 텍스트·이미지 붙여넣기 | Windows Terminal 기본 `Ctrl+V`=paste → 텍스트는 정상 통과. **이미지는 `Alt+V` 권장** |
| `Alt+V` | 클립보드 이미지 붙여넣기 (Windows 권장) | |
| `←` / `→` | 대화 탭 순환 | |

---

## 7. Windows Terminal · PowerShell 충돌·주의사항

### 7.1 Windows Terminal이 가로채는 키 (Claude Code로 전달 안 됨)

| 단축키 | Windows Terminal 동작 |
|---|---|
| `Ctrl+Shift+T` | 새 탭 |
| `Ctrl+Shift+W` | 탭 닫기 |
| `Ctrl+Shift+N` | 새 창 |
| `Ctrl+Shift+P` | 명령 팔레트 |
| `Ctrl+Shift+F` | 터미널 텍스트 검색 |
| `Ctrl+Shift+C` | 복사 |
| `Ctrl+Shift+Space` | 새 탭 선택기 |
| `Ctrl+,` | 설정 GUI |
| `Ctrl+Shift+,` | `settings.json` 직접 편집 |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | 탭 전환 |
| `Ctrl+Alt+<숫자>` | 특정 탭으로 이동 |
| `Alt+Shift+화살표` | 분할창 리사이즈 |
| `Alt+화살표` | 분할창 포커스 이동 |
| `Alt+Shift+D` | 창 분할 |
| `Alt+Enter` | 전체화면 토글 |
| `F11` | 전체화면 |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | 폰트 크기 |

> [!WARNING]
> **`Ctrl+-` 그대로는 폰트 축소이지만, `Ctrl+Shift+-`(=`Ctrl+_`)는 Claude Code의 Undo로 전달된다.** 한글 키보드에서 `_`는 `Shift+-`이므로 Shift도 같이 누르면 Undo가 발동된다.

### 7.2 PSReadLine과의 관계

Claude Code 실행 중에는 입력 처리를 Claude가 직접 담당하므로 PSReadLine 키바인딩은 **간섭하지 않는다**. 단, `!` 셸 모드로 PowerShell 명령을 호출하거나 Claude Code 외부 PowerShell 프롬프트에서는 PSReadLine 단축키(`Ctrl+R`, `Ctrl+A` 등)가 PSReadLine 쪽으로 처리된다.

### 7.3 한글 IME 충돌

| 키 조합 | 충돌 양상 |
|---|---|
| `한/영` 전환 | 일부 단축키 전달 직전 IME가 키를 가로채서 무반응 발생 가능 |
| `Alt+한자` | 한자 변환창 호출 — Claude Code의 `Alt+*` 일부 조합과 시각적 혼동 |
| `Shift+Space` | 한/영 전환(IME 설정에 따라) — Claude Code 입력 흐름 끊김 |

> [!TIP]
> 단축키 입력 직전엔 **영문 모드(한/영 키)** 로 전환할 것. 단축키 입력 후 다시 한글 모드로 돌려도 무방.

### 7.4 `Shift+Enter`가 줄바꿈으로 안 먹을 때

Windows Terminal 구버전 또는 프로파일 설정에 따라 `Shift+Enter`가 그냥 `Enter`로 처리될 수 있다. 대안:

1. **`Ctrl+J`** — POSIX LF 코드를 직접 보냄. 모든 터미널에서 동작.
2. **`\` + `Enter`** — Claude Code가 줄 끝 백슬래시를 줄바꿈으로 해석.
3. Windows Terminal `settings.json`의 해당 프로파일에 다음 키 바인딩 추가:

   ```json
   {
     "command": { "action": "sendInput", "input": "\r" },
     "keys": "shift+enter"
   }
   ```

---

## 8. Vim 모드 (활성화 시)

`/config` → Editor mode를 `vim`으로 변경하면 모달 입력이 활성화된다. NORMAL/INSERT/VISUAL 표준 vim 명령이 동작한다.

| 모드 | 주요 키 |
|---|---|
| NORMAL | `h` `j` `k` `l` (이동) / `dd` `x` (삭제) / `u` (undo) / `yy` `p` (yank/paste) |
| INSERT | `i` `I` `a` `A` `o` `O` |
| VISUAL | `v` (문자) / `V` (줄) |

> [!IMPORTANT]
> Vim 모드에서 `Esc`는 **INSERT → NORMAL 전환만** 한다. Claude 응답 중단(`Esc`)은 NORMAL 모드에서만 동작.

---

## 9. 커스터마이즈

사용자 단축키 재정의 파일: `~/.claude/keybindings.json` (Windows: `C:\Users\<USER>\.claude\keybindings.json`).

- 존재하지 않으면 모든 단축키가 기본값으로 동작
- 편집 가이드는 Claude Code 슬래시 명령 `/keybindings-help` 스킬에서 받을 수 있음

> [!NOTE]
> 본 문서는 기본값 기준이다. `keybindings.json`에서 재정의했다면 그쪽이 우선한다.

---

## 부록: 빠른 참조 카드

```
입력 편집:   Ctrl+A/E    Ctrl+K/U/W    Alt+B/F   Alt+Y   Ctrl+J(줄바꿈)
모드 전환:   Shift+Tab(권한)  Alt+P(모델)  Alt+T(thinking)  Alt+O(fast)
세션 제어:   Ctrl+L   Ctrl+O(트랜스크립트)   Esc(중단)   Esc×2(되돌리기)   Ctrl+D(종료)
취소 / Undo: Ctrl+C(취소)   Ctrl+Shift+-(Undo)
붙여넣기:    Ctrl+V(텍스트)   Alt+V(이미지)
서브에이전트 일괄 종료: Ctrl+X Ctrl+K (×2)
```
