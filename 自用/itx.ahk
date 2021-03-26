
; Notes:  # == win    ! == Alt    ^ == Ctrl    + == Shift

#SingleInstance Force ; 重复启动的时候自动覆盖

; 检查管理员权限，没有则以管理员权限重新启动脚本，避免部分情况下无法使用ahk
Loop, %0%  ; For each parameter:
{
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    params .= A_Space . param
}
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
    If A_IsCompiled
        DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
    Else
        DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}

#IfWinActive, ahk_exe Explorer.EXE
; ---------------------------------------------------------
; Win + H 显示/隐藏系统隐藏文件
; ---------------------------------------------------------
#H::
    If value = 1
        value := 2
    Else
        value = 1
    RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\, Hidden, %Value%
    Send {Browser_Refresh}
    Return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + Z 显示/隐藏桌面文件
; ---------------------------------------------------------
#Z::
    ControlGet, class, Hwnd,, SysListView321, ahk_class Progman
    If class = 
        ControlGet, class, Hwnd,, SysListView321, ahk_class WorkerW
    If DllCall("IsWindowVisible", UInt,class)
        WinHide, ahk_id %class%
    Else
        WinShow, ahk_id %class%
    Return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + S 获得当前选中文件的路径（仅资源管理器/桌面下有效）
; ---------------------------------------------------------
#S::
    Send ^c
    clipboard = %clipboard%
    tooltip, %clipboard%
    sleep, 500
    tooltip
    Return
; ---------------------------------------------------------


; ; ---------------------------------------------------------
; ; Win + V 用 VS Code选中的文件
; ; ---------------------------------------------------------
; #V::
;     Send ^c
;     Run cmd /K code %clipboard%
;     Sleep 2000
;     Send !{Tab}
;     Sleep 100
;     Send {AltDown}{F4}{AltUp}
;     Return
; ; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + C 打开当前目录下的控制命令行
; ---------------------------------------------------------
#C::
    WinGetText, path, A
    StringSplit, word_array, path, `n ; Split on newline (`n)
    path := word_array9
    ToolTip %word_array9%
    Sleep 500
    ToolTip
    path := RegExReplace(path, "^地址: ", "") ; strip to bare address
    StringReplace, path, path, `r, , all ; Just in case - remove all carriage returns (`r)

    Run cmd ; run powershell Start-Process powershell -Verb runAs 
    Sleep 500
    IfInString path, \
    {
        Send cd %path%
    }
    else
    {
        Send cd C:\
    }
    Send {Enter}
    Return
; ---------------------------------------------------------
#If ; End "#IfWinActive, ahk_exe Explorer.EXE"


; ---------------------------------------------------------
; Win + O 关闭显示器
; ---------------------------------------------------------
#O:: 
Sleep 2000 ; 让用户有机会释放按键 (以防释放它们时再次唤醒显视器).
SendMessage, 0x112, 0xF170, 2,, Program Manager ; 关闭显示器: 0x112 为 WM_SYSCOMMAND, 0xF170 为 SC_MONITORPOWER. ; 可使用 -1 代替 2 打开显示器，1 代替 2 激活显示器的节能模式
return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + T 当前窗口置顶
; ---------------------------------------------------------
#T::
    winset, AlwaysOnTop, TOGGLE, A ; A在AutoHotkey里表示当前活动窗口的标题
    WinGet, ExStyle, ExStyle, A
    if (ExStyle & 0x8) ; 0x8 为 WS_EX_TOPMOST.在WinGet的帮助中
        tooltip 置顶
    else
        ToolTip 取消置顶
    Sleep 1000
    ToolTip
    Return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + J 计算器
; ---------------------------------------------------------
#J::Run calc
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win [+ Shift ]+ F 打开 ceynri 文件夹
; ---------------------------------------------------------
#F::Run C:\ceynri
#+F::Run C:\ceynri
; ---------------------------------------------------------
; Win + Shift + D 短按 打开 Downloads
;                 长按 打开 docs
; ---------------------------------------------------------
#+D::
    KeyWait, D
    If (A_TimeSinceThisHotkey < 300) {
        Run C:\Users\ceynri\Downloads
    } Else {
        Run C:\ceynri\docs
    }
    Return
; ---------------------------------------------------------
; Win + Shift + T 打开Tools文件夹
; ---------------------------------------------------------
#+T::Run C:\ceynri\tools
; ---------------------------------------------------------
; Win + Shift + P 打开 Pictures 文件夹
; ---------------------------------------------------------
#+P::Run C:\ceynri\picture
; ---------------------------------------------------------
; Win + Shift + Z 打开Desktop文件夹
; ---------------------------------------------------------
#+Z::Run C:\Users\ceynri\Desktop
; ---------------------------------------------------------
; Win + Shift + A 打开毕设文件夹
; ---------------------------------------------------------
#+A::Run C:\Users\ceynri\Desktop\毕设
; ---------------------------------------------------------
; Win + Shift + W 打开 workspace 文件夹
; ---------------------------------------------------------
#+W::Run C:\ceynri\workspace\
; ---------------------------------------------------------
; Win + Shift + N 打开 ceynri.cn 文件夹
; ---------------------------------------------------------
#+N::Run C:\ceynri\workspace\ceynri.cn\
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + C 打开控制命令行
; ---------------------------------------------------------
#C::Run C:\ceynri\tools\ahk-script\runcmd.exe
; ---------------------------------------------------------
; Win + K 打开控制面板
; ---------------------------------------------------------
#K::Run control.exe
; ---------------------------------------------------------
; Win + Y 打开程序与功能
; ---------------------------------------------------------
#Y::Run control.exe /name Microsoft.ProgramsAndFeatures
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + N 新建 Edge 窗口
; ---------------------------------------------------------
#N::
    KeyWait, N
    If(A_TimeSinceThisHotkey < 300) {
        ; Run "C:\Program Files\Google\Chrome\Application\chrome.exe"
        Run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    } Else {
        Run https://www1.szu.edu.cn/
    }
    Return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + M 打开网易云音乐
; ---------------------------------------------------------
#M::
    IfWinNotExist ahk_class OrpheusBrowserHost
    {
        Run C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe
        winActivate
    }
    Else IfWinNotActive ahk_class OrpheusBrowserHost
        winActivate
    Else 
        winMinimize
    Return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + G 打开Dr.com校园网登录页面
; ---------------------------------------------------------
; #G::Run C:\Drcom\DrUpdateClient\DrMain.exe
#G::
    KeyWait, G
    If(A_TimeSinceThisHotkey < 300) {
        Run "https://drcom.szu.edu.cn/a70.htm"
    } Else {
        Run "http://172.30.255.2/0.htm"
    }
    Return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + D 长按 创建新桌面
; ---------------------------------------------------------
#~D::
    KeyWait, D
    If (A_TimeSinceThisHotkey > 300) {
        Send #{Tab}
        Sleep 500
        Send {Tab}{End}{Enter}{Esc}
    }
    Return
; ---------------------------------------------------------



; ---------------------------------------------------------
; 将 CapsLock 替换为 Alt + CapsLock
; ---------------------------------------------------------
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
; 为60%或65%键盘进行F区映射（类似Fn键的逻辑）
; ---------------------------------------------------------
Capslock & Esc::`
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
Capslock & ,::Home
Capslock & .::End
; ---------------------------------------------------------
; 用 Capslock + W/A/S/D控制上下左右
; ---------------------------------------------------------
Capslock & W::Up
Capslock & A::Left
Capslock & S::Down
Capslock & D::Right
; ---------------------------------------------------------
; 用 Capslock + Q/E/T/G控制位置
; ---------------------------------------------------------
Capslock & Q::Home
Capslock & E::End
Capslock & T::PgUp
Capslock & G::PgDn
; ---------------------------------------------------------
; 利用Capslock + R/F调节音量
; ---------------------------------------------------------
Capslock & R::Send {Volume_Up 1}
Capslock & F::Send {Volume_Down 1}
; ---------------------------------------------------------
; 利用Capslock + Z/X切换歌曲  Capslock + Space暂停音乐
; ---------------------------------------------------------
Capslock & Z::Media_Prev
Capslock & X::Media_Next
Capslock & Space::Media_Play_Pause
; ---------------------------------------------------------
; 利用Capslock + C/V调节亮度（备用：Win + Up/Down）
; ---------------------------------------------------------
Capslock & C::
LWin & Down::
    AdjustScreenBrightness(-5)
    Return

Capslock & V::
LWin & Up::
    AdjustScreenBrightness(5)
    Return

AdjustScreenBrightness(step) {
    service := "winmgmts:{impersonationLevel=impersonate}!\\.\root\WMI"
    monitors := ComObjGet(service).ExecQuery("SELECT * FROM WmiMonitorBrightness WHERE Active=TRUE")
    monMethods := ComObjGet(service).ExecQuery("SELECT * FROM wmiMonitorBrightNessMethods WHERE Active=TRUE")
    minBrightness := 0

    for i in monitors {
        curt := i.CurrentBrightness
        break
    }
    toSet := curt + step
    If (toSet > 100) {
        Return
    }
    If (toSet < minBrightness) {
        toSet := minBrightness
    }

    for i in monMethods {
        i.WmiSetBrightness(1, toSet)
        break
    }
}
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + R 长按 重启该脚本
; ---------------------------------------------------------
#R::
    KeyWait, R
    If (A_TimeSinceThisHotkey > 300) {
        ToolTip Reload Script
        Sleep 300
        ToolTip
        Reload
    } Else {
        Run "C:\Users\ceynri\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Run.lnk"
    }
    Return
; ---------------------------------------------------------


; ---------------------------------------------------------
; Win + E 长按 修改该脚本
; ---------------------------------------------------------
#E::
    KeyWait, E ; 等待 E 键抬起
    If (A_TimeSinceThisHotkey > 300) {
        Run "C:\Users\ceynri\AppData\Local\Programs\Microsoft VS Code\code.exe" C:\ceynri\workspace\autohotkey-script\自用\itx.ahk ; 使用 vs code 打开脚本（替换成你的脚本位置）
    } Else {
        Run "C:\"
    }
Return
; ---------------------------------------------------------

; ---------------------------------------------------------
; 
; ---------------------------------------------------------


; ---------------------------------------------------------
