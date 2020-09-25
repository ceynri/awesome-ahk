# AutoHotkey 常用脚本

简单介绍一下，AutoHotkey 是 windows 平台下的一款开源热键脚本语言，特点是编写自动化热键脚本非常容易。

它有多简单？举个例子，比如我想要实现快捷键 Win + N 打开 Chrome 浏览器，只需要在一个文件里写一行代码：

```ahk
#N::Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome"
```

将这个文件后缀名改为`.ahk`后，双击它即可将其放在后台运行，实现全局快捷键映射，且基本不消耗电脑性能。

关于更多的语法，可以参考中文文档：<https://wyagd001.github.io/zh-cn/docs/AutoHotkey.htm>

下面是一些自己比较常用的代码，对于路径相关字符串请自行替换：

<br>

## 快捷访问文件夹

我常用的主要有两类：

### 直接映射

按键：Win + Shift + C 打开 C 盘

按键：Win + Shift + Z 打开桌面

```ahk
#+C::Run "C:\"
#+Z::Run "C:\pathToUserFile\Desktop"
```

打开网页也是可以的：

```ahk
#B::Run "https://www.baidu.com/"
```

甚至可以打开系统界面：

```ahk
; Win + K 打开控制面板
#K::Run control.exe
; Win + Y 打开程序与功能
#Y::Run control.exe /name Microsoft.ProgramsAndFeatures
```

### 短按/长按分别触发不同效果

按键：Win + Shift + D

- 短按打开 Downloads 文件夹
- 长按打开 docs 文件夹

```ahk
#+D::
    KeyWait, D
    If (A_TimeSinceThisHotkey < 300) {
        ; 按下小于300ms，打开Downloads文件夹
        Run "C:\pathToUserFile\Downloads"
    } Else {
        ; 按下超过300ms，打开docs文件夹
        Run "D:\pathToUserFile\docs"
    }
    Return
```

<br>

## 功能类

### 窗口置顶

按键：Win + T

```ahk
#T::
    ; 切换窗口置顶状态
    WinSet, AlwaysOnTop, TOGGLE, A ; A在AutoHotkey里表示当前活动窗口的标题
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
```

### 隐藏/显示桌面文件

桌面洁癖者福音（可配合“打开桌面文件夹”快捷键）

按键：Win + Z

```ahk
#Z::
    ControlGet, class, Hwnd,, SysListView321, ahk_class Progman
    If class =
        ControlGet, class, Hwnd,, SysListView321, ahk_class WorkerW
    If DllCall("IsWindowVisible", UInt,class)
        WinHide, ahk_id %class%
    Else
        WinShow, ahk_id %class%
Return
```

### 获取选中的文件的绝对路径

按键：Win + S

注意：会覆盖剪贴板内容，且仅资源管理器/桌面下有效

```ahk
#S::
    Send ^c
    clipboard = %clipboard%
    tooltip, %clipboard%
    sleep, 500
    tooltip
Return
```

### 在当前活跃窗口打开控制命令行

这个代码有点搓，后续看下有没有好点的

```ahk
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
        Send cd %path%
    else
        Send cd C:\
    Send {Enter}
Return
```

### 关闭显示器

按键：Win + O

```ahk
#O:: 
    Sleep 2000 ; 让用户有机会释放按键 (以防释放它们时再次唤醒显视器).
    SendMessage, 0x112, 0xF170, 2,, Program Manager ; 关闭显示器: 0x112 为 WM_SYSCOMMAND, 0xF170 为 SC_MONITORPOWER. ; 可使用 -1 代替 2 打开显示器，1 代替 2 激活显示器的节能模式
return
```

<br>

## 应用类

### 计算器

按键：Win + J

```ahk
#J::Run calc
```

### 网易云

按键：Win + M

```ahk
#M::
    IfWinNotExist ahk_class OrpheusBrowserHost
    {
        Run "C:\Program Files (x86)\Netease\CloudMusic\cloudmusic.exe"
        winActivate
    }
    Else IfWinNotActive ahk_class OrpheusBrowserHost
        winActivate
    Else 
        winMinimize
Return
```

<br>

## 按键映射

### Capslock 组合键映射

60%键盘必备

> 前置代码：Capslock 键替换
>
> 按键：Win + Capslock / RAlt + Capslock 映射为 Capslock
> 按键：Capslock 禁用
>
> ```ahk
> ; 禁用大写键
> CapsLock::Return
>
> ; 左Alt、Ctrl修饰键常与 Capslock 键一同使用，但如果没有按下能与 Capslock 配合的键则会绕过上面的规则触发大写锁定，故禁用
> <!Capslock::Return
> <^Capslock::Return
>
> ; Win/Right Alt + Capslock 代替大写键
> #Capslock::
> >!Capslock::
>     isCaps = % GetKeyState("CapsLock", "T")
>     If (isCaps) {
>         SetCapsLockState, off
>         ToolTip
>     } Else {
>         SetCapsLockState, on
>         ToolTip Caps Locking
>     }
>     Return
> ```

### 上下左右

> 很好懂，就不标按键了

```ahk
Capslock & W::Up
Capslock & A::Left
Capslock & S::Down
Capslock & D::Right
```

### F 区映射

```ahk
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
```

### 页面定位

```ahk
Capslock & Q::Home
Capslock & E::End
Capslock & T::PgUp
Capslock & G::PgDn
```

<br>

## 系统控制

### 音量调节

```ahk
Capslock & R::Send {Volume_Up 1}
Capslock & F::Send {Volume_Down 1}
```

### 音乐控制

```ahk
Capslock & Z::Media_Prev
Capslock & X::Media_Next
Capslock & Space::Media_Play_Pause
```

### 亮度调节（笔记本电脑）

按键：Capslock + C / Win + ↓ 降低亮度
按键：Capslock + V / Win + ↑ 增加亮度

```ahk
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
```

---

<br>

## 便于调试的代码

> 在文件开头声明以下语句可以在重复启动脚本的时候，不进行提示，直接自动覆盖
>
> ```ahk
> #SingleInstance Force
> ```

### 重启该脚本

按键：Win + R 长按

```ahk
#R::
	KeyWait, R ; 等待 R 键抬起
	If (A_TimeSinceThisHotkey > 300) {
        ToolTip Reload Script
        Sleep 300
        ToolTip
	    Reload
    } Else {
        Run "C:\Users\yangruichen\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools\Run.lnk" ; 替换成你的脚本位置
    }
    Return
```

> 直接写在没有功能的组合键上就不用长按了：
>
> ```ahk
> #+R::Run "C:\pathToScript\ahk.ahk"
> ```

### 修改该脚本

按键：Win + E 长按

```ahk
#E::
    KeyWait, E ; 等待 E 键抬起
    If (A_TimeSinceThisHotkey > 300) {
        Run "C:\Users\Haze\AppData\Local\Programs\Microsoft VS Code\code.exe" "D:\ceynri\tools\ahk\ceynri.ahk" ; 使用 vs code 打开脚本（替换成你的脚本位置）
    }
Return
```

<br>

---

## 其他我不常用的

```ahk
; ---------------------------------------------------------
; Win + H  显示/隐藏系统隐藏文件
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
; Win + Shfit + J 计时器
; ---------------------------------------------------------
#+J::
    InputBox, time, 山风牌专用计时器, 请输入一个时间（单位是秒）
    time := time*1000
    ; 如果一个变量要做计算的话，一定要像这样写，和平常的算式相比，多了一个冒号
    Sleep,%time%
    MsgBox 计时结束
Return
; ---------------------------------------------------------

; ---------------------------------------------------------
; 右键+左键复制，右键粘贴
; ---------------------------------------------------------
~RButton & LButton::
    Hotkey, RButton, Paste
    Send ^c
    Hotkey, RButton, on
    Return

Paste:
    Send ^v
    Hotkey, RButton, off
    Return
; ---------------------------------------------------------

; ---------------------------------------------------------
; 双击Esc关闭窗口
; ---------------------------------------------------------
;~Esc::
    ; KeyWait用法：第一参数：目标按键； 第二参数：使用D：等待按键被按下；使用L：等待按键被释放；使用T：表示等待时间。
    ; 如果第二参数为空, 则命令会无限期等待用户松开指定的按键或鼠标/操纵杆按钮.（三个参数可以同时使用）
    KeyWait, Escape             ; 在第一个Esc按下之后该行代码即被执行，持续等待Escape键被松开，然后再进入到下面的判断（有点像C语言里的getchar()）（如果不是双击某个键的热键，则无需此行）
    KeyWait, Escape, D, T0.2    ; 等待0.2秒，观察期间esc是否被按下
    If errorlevel = 0           ; Esc被按下（不一定要松开），则errorlevel为0
        WinClose, A
    Return
; ---------------------------------------------------------
```
