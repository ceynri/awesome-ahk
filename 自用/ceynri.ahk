/**
 * @encode: gbk
 * @Author: ceynri
 * @document: https://wyagd001.github.io/zh-cn/docs/AutoHotkey.htm
 */

; Notes:  # == win    ! == Alt    ^ == Ctrl    + == Shift

; 重复启动该脚本时，自动覆盖旧脚本进程
#SingleInstance Force

; ---------------------------------------------------------
; 创建Chrome浏览器新窗口
; ---------------------------------------------------------
#N::Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome"
; ---------------------------------------------------------

; ---------------------------------------------------------
; 常用文件夹的快捷打开方式
; ---------------------------------------------------------
#+C::Run "C:\"
#+D::
    KeyWait, D
    If (A_TimeSinceThisHotkey < 300) {
        ; 按下小于300ms，打开Downloads文件夹
        Run "C:\Users\yangruichen\Downloads"
    } Else {
        ; 按下超过300ms，打开docs文件夹
        Run "D:\ceynri\docs"
    }
Return
#+E::Run "D:\ceynri"
#+N::Run "D:\ceynri\docs\notes"
#+T::Run "D:\ceynri\tools"
#+W::Run "D:\workspace"
#+Z::Run "C:\Users\yangruichen\Desktop"
; ---------------------------------------------------------

; ---------------------------------------------------------
; Win + T 当前窗口置顶
; ---------------------------------------------------------
#T::
    ; 切换窗口置顶状态
    WinSet, AlwaysOnTop, TOGGLE, A	; A在AutoHotkey里表示当前活动窗口的标题
    ; 获取窗口置顶状态
    WinGet, ExStyle, ExStyle, A
    If (ExStyle & 0x8) { ; 0x8 为 WS_EX_TOPMOST.在WinGet的帮助中
        ToolTip 置顶
    } Else {
        ToolTip 取消置顶
    }
    Sleep 1000
    ; 关闭 ToolTip 提示
    ToolTip
Return
; ---------------------------------------------------------

; ---------------------------------------------------------
; 将 CapsLock 替换为 RAlt + CapsLock
; ---------------------------------------------------------
; 禁用大写键
CapsLock::Return
; 左Alt、Ctrl修饰键常与 Capslock 键一同使用，但如果没有按下能与 Capslock 配合的键则会绕过上面的规则触发大写锁定，故禁用
<!Capslock::Return
<^Capslock::Return
; Win/Right Alt + Capslock 代替大写键
#Capslock::
>!Capslock::
    isCaps = % GetKeyState("CapsLock", "T")
    If (isCaps) {
        SetCapsLockState, off
        ToolTip
    } Else {
        SetCapsLockState, on
        ToolTip Caps Locking
    }
Return
; ---------------------------------------------------------
; 对60%~65%键盘进行F区兼容适配
; ---------------------------------------------------------
Capslock & 1::F1
Capslock & 2::F2
Capslock & 3::F3
Capslock & 4::F4
Capslock & 5::F5
Capslock & 6::F6
Capslock & 7::F7
Capslock & 8::F8
Capslock & 9::F9
Capslock & 0::F10
Capslock & -::F11
Capslock & +::F12
Capslock & `::Esc
Capslock & Esc::`
; ---------------------------------------------------------
; 上下左右
; ---------------------------------------------------------
Capslock & W::Up
Capslock & A::Left
Capslock & S::Down
Capslock & D::Right
; ---------------------------------------------------------
; 定位
; ---------------------------------------------------------
Capslock & Q::Home
Capslock & E::End
Capslock & T::PgUp
Capslock & G::PgDn
; ---------------------------------------------------------
; 调节音量
; ---------------------------------------------------------
Capslock & R::Send {Volume_Up 1}
Capslock & F::Send {Volume_Down 1}
; ---------------------------------------------------------
; 切换歌曲/暂停音乐
; ---------------------------------------------------------
Capslock & Z::Media_Prev
Capslock & X::Media_Next
Capslock & Space::Media_Play_Pause
; ---------------------------------------------------------

#IfWinActive, ahk_exe Explorer.EXE ; 仅资源管理器/桌面下有效
; ---------------------------------------------------------
; Win + S 获得当前选中文件的路径
; ---------------------------------------------------------
#S::
    Send ^c
    clipboard = %clipboard%
    tooltip, %clipboard%
    sleep, 500
    tooltip
    Return
; ---------------------------------------------------------
#If ; End #IfWinActive, ahk_exe Explorer.EXE

; ---------------------------------------------------------
; Win + O 关闭显示器
; ---------------------------------------------------------
#O:: 
Sleep 2000  ; 让用户有机会释放按键 (以防释放它们时再次唤醒显视器).
SendMessage, 0x112, 0xF170, 2,, Program Manager   ; 关闭显示器: 0x112 为 WM_SYSCOMMAND, 0xF170 为 SC_MONITORPOWER. ; 可使用 -1 代替 2 打开显示器，1 代替 2 激活显示器的节能模式
return
; ---------------------------------------------------------

; ---------------------------------------------------------
; Win + T 当前窗口置顶
; ---------------------------------------------------------
#T::
    winset, AlwaysOnTop, TOGGLE, A	;A在AutoHotkey里表示当前活动窗口的标题
    WinGet, ExStyle, ExStyle, A
    if (ExStyle & 0x8)  ; 0x8 为 WS_EX_TOPMOST.在WinGet的帮助中
        tooltip 置顶
    else
        ToolTip 取消置顶
    Sleep 1000
    ToolTip
    Return
; ---------------------------------------------------------

; ---------------------------------------------------------
; Win + R 长按 重启该脚本
; ---------------------------------------------------------
#R::
	KeyWait, R ; 等待 R 键抬起
	If (A_TimeSinceThisHotkey > 300) {
        ToolTip Reload Script
        Sleep 300
        ToolTip
	    Reload
    } Else {
        Run "C:\Users\yangruichen\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Run.lnk"
    }
    Return
; ---------------------------------------------------------
; Win + E 长按 修改该脚本 （如果想保留原快捷键打开快速访问的效果，可以在E前面加~）
; ---------------------------------------------------------
#E::
    KeyWait, E ; 等待 E 键抬起
    If (A_TimeSinceThisHotkey > 300) {
        Run "C:\Users\Haze\AppData\Local\Programs\Microsoft VS Code\code.exe" "D:\ceynri\tools\ahk\ceynri.ahk" ; 使用 vs code 打开脚本（替换成你的脚本位置）
    }
Return
; ---------------------------------------------------------
