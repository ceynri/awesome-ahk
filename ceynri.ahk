; @encode: gbk
; @Author: ceynri
; @document: https://wyagd001.github.io/zh-cn/docs/AutoHotkey.htm

; Notes:  # == win    ! == Alt    ^ == Ctrl    + == Shift

#SingleInstance Force ; 重复启动该脚本时，自动覆盖旧脚本进程

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
    If (ExStyle & 0x8) {  ; 0x8 为 WS_EX_TOPMOST.在WinGet的帮助中
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
CapsLock::Return ; 禁用大写键
#Capslock::
RAlt & Capslock::
Capslock & RAlt::
    isCaps = % GetKeyState("CapsLock", "T")
    If (isCaps) {
        SetCapsLockState, off
        ToolTip 大写锁定
    } Else {
        SetCapsLockState, on
        ToolTip 取消大写锁定
    }
    Sleep 300
    ToolTip
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


; ---------------------------------------------------------
; Win + R 长按 重启该脚本
; ---------------------------------------------------------
#~R::
	KeyWait, R
	If (A_TimeSinceThisHotkey > 300) {
        ; 关闭“运行”窗口
        WinClose ahk_class #32770
        ; 运行脚本
	    Run "D:\ceynri\tools\ahk\ceynri.ahk"
    }
    Return
; ---------------------------------------------------------
; Win + E 长按 修改该脚本
; ---------------------------------------------------------
#~E::
    ; 短按 Win + E 会打开快速访问窗口
    KeyWait, E
    If (A_TimeSinceThisHotkey > 300) {
        ; 关闭快速访问窗口
        WinClose ahk_class CabinetWClass
        ; 使用 vs code 打开脚本
        Run cmd /K code "D:\ceynri\tools\ahk\ceynri.ahk"
        ; 延迟2s（取决于电脑运行速度）后，关闭弹出的命令行
        Sleep 2000
        Send !{Tab}
        Sleep 100
        Send {AltDown}{F4}{AltUp}
    }
    Return
; ---------------------------------------------------------
