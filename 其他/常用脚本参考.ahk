; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

;让脚本持久运行 (即直到用户关闭或遇到 ExitApp).
;#Persistent

;强制加载新的脚本
#SingleInstance force

;尝试加载图标
IfExist, icon.ico ;花括号“{”不能和 IfExist 写在同一行
{
Menu TRAY, Icon, icon.ico ;这句会把 icon.ico 作为图标
}

;定时器 输入为分钟数
#t::
; 弹出一个输入框，标题 内容
InputBox ,time,定时器,请输入一个时间（单位是分钟）,,200,100 ;InputBox, time, 计时器, 请输入一个时间（单位是分钟）
time := time*1000*60 ; 变量赋值，多一个冒号，乘以 1000*60  变time为分钟数
Sleep,%time%
MsgBox,,提示信息, 打卡啦
return

/*
;打开ie浏览器
#1::
run C:\Program Files\Internet Explorer\iexplore.exe
return
 
;打开firefox浏览器
#2::
;run D:\Program Files\Mozilla Firefox\firefox.exe
run C:\Documents and Settings\koujincheng\Local Settings\Application Data\Google\Chrome\Application\chrome.exe
return
*/

;打开everything
^!e::
Run D:\Program Files\everything\Everything.exe
return
 
;打开任务管理器
^!K::
Run taskmgr
return
 
;打开远程连接
^!m::
Run mstsc
return
 
;新建或激活记事本窗口
^!n::
IfWinExist ahk_class Notepad
WinActivate
else
Run Notepad
return
 
;UltraEdit32
^!u::
Run D:\Program Files\UltraEdit\Uedit32.exe
return
 
;截图工具 FSCapture
^!c::
Run D:\Program Files (x86)\FScapture\FSCapture.exe
return
 
; Foxmail
^!f::
Run D:\Program Files (x86)\Foxmail7.2\Foxmail.exe
return

; P2PSearcher
^!p::
Run D:\Program Files (x86)\P2PSearchers\P2PSearcher.exe
return
 
;重新加载脚本
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.

;##################################################window script#############################################################
;###################################################窗口操作#################################################################
 
;最大化或还原(取消最大化)窗口
~LAlt::            
Keywait, LAlt, , t0.3
if errorlevel = 1
return
else
Keywait, LAlt, d, t0.3
if errorlevel = 0
{
WinGet, DAXIAO , MinMax, A
if (DAXIAO = "1")
{
PostMessage, 0x112, 0xF120,,, A  ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE
}
else
{
PostMessage, 0x112, 0xF030,,, A  ; 0x112 = WM_SYSCOMMAND, 0xF030 = SC_MAXIMIZE
}
}
return
 
;最小化窗口 记录最后三个最小化的窗口
~RAlt::     
Keywait, RAlt, , t0.3
if errorlevel = 1
return
else
Keywait, RAlt, d, t0.3
if errorlevel = 0
{
If (WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW"))
{
}
else
{
Last_Max_Id=0
WinGet, Last_Min_Id, ID, A
if (MinMemo1 = "0")
MinMemo1=%Last_Min_Id%
else if(MinMemo2 = "0")
{
MinMemo2=%MinMemo1%
MinMemo1=%Last_Min_Id%
}
else
{
MinMemo3=%MinMemo2%
MinMemo2=%MinMemo1%
MinMemo1=%Last_Min_Id%
}
IfWinNotActive ahk_class TXGuiFoundation
WinMinimize, A
else  ;qq窗口使用ctrl+alt+z 最小化
{
WinGetTitle, Temp0 , A
If Temp0 contains QQ20
{
sleep,100
Send, {CTRLDOWN}{ALTDOWN}z{ALTUP}{CTRLUP}
}
else
WinMinimize, A
}
}
} ;end if  errorlevel = 0
return
;恢复最小化的窗口,最多三个(只能识别通过脚本最小化的窗口)
>!Space::      
if (MinMemo1 = "0") ;不存在通过脚本最小化的窗口
{
WinRestore, A
WinActivate,A
}
else if (MinMemo2 = "0") ;只有一个
{
WinRestore, ahk_id %MinMemo1%
WinActivate, ahk_id %MinMemo1%
MinMemo1=0
}
else if (MinMemo3 = "0")
{
WinRestore, ahk_id %MinMemo1%
WinActivate, ahk_id %MinMemo1%
MinMemo1=%MinMemo2%
MinMemo2=0
}
else
{
WinRestore, ahk_id %MinMemo1%
WinActivate, ahk_id %MinMemo1%
MinMemo1=%MinMemo2%
MinMemo2=%MinMemo3%
MinMemo3=0
}
return
 
;关闭窗口,在浏览器中为关闭标签页
~Esc::     
Keywait, Esc, , t0.5
if errorlevel = 1
return
else
Keywait, Esc, d, t0.2
if errorlevel = 0
{
IfWinActive ahk_class ahk_class IEFrame ;识别IE浏览器
Send {ctrldown}w{ctrlup}
else IfWinActive ahk_class MozillaWindowClass ;识别firfox 浏览器
Send {ctrldown}w{ctrlup}
else
send !{F4}
}
return
 
;##################################################other script#############################################################
;###################################################其它脚本################################################################
 
 
;快速按下两次Ctrl 快速粘贴
/*
~LCtrl::
Keywait, LCtrl, , t0.5
if errorlevel = 1
return
else
Keywait, LCtrl, d, t0.3
if errorlevel = 0
{
Send,^v
}
return
*/
 
 
;win+shift+f 在桌面上建立一个以当前日期命名的文件夹
#+f::
Click right ;在桌面当前鼠标所在位置点击鼠标右键
Send, wf ;快捷键新建文件夹
Sleep, 125 ; 把暂停时间改小
clipboard = %A_MM%-%A_DD%-%A_YYYY% ;%A_Hour%-%A_Min%-%A_Sec%-%A_MSec%;把当前的系统日期发送到剪贴板
Send, ^v{Enter} ;发送 Ctrl + v 和回车确认修改文件夹名称
return
 
;ctrl+win+c 得到当前选中文件的路径,保存到剪贴板中
^#c::
send ^c
sleep,200
clipboard=%clipboard% ;解释:windows复制的时候,剪贴板保存的是“路径”.只是路径而不是字符串,只要转换成字符串就可以粘贴出来了
tooltip,%clipboard% ;提示文本
sleep,2000
tooltip, ;置空
return
 
; Win+O 关闭显示器
#o:: 
Sleep 1000  ; 让用户有机会释放按键 (以防释放它们时再次唤醒显视器).
SendMessage, 0x112, 0xF170, 2,, Program Manager   ; 关闭显示器: 0x112 为 WM_SYSCOMMAND, 0xF170 为 SC_MONITORPOWER. ; 可使用 -1 代替 2 打开显示器，1 代替 2 激活显示器的节能模式
return

;获取当前系统日期
::ddd::
;获得系统时间比如今天的时间：2013-07-17。如果需要“年”的话请替换上面的“-”。
d = %A_YYYY%-%A_MM%-%A_DD% 
;把 d 的值发送到剪贴板，变量不用声明，引用变量的值时在变量的前后加“%”。clipboard是 AHK 自带的变量:剪切板
clipboard = %d% 
Send ^v
return

;获取当前系统时间
::/time::
d = %A_Hour%:%A_Min%:%A_sec% 
clipboard = %d% 
Send ^v
return

;获取系统日期和时间
::/all::
d = %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_sec%
clipboard = %d% 
Send ^v
return

::/kou::
Send , koujincheng{Shift}{Tab}1234.abcdd{Enter}
return

;选中路径，快速打开
#j::
send ^c ; 复制选中的文字
clipwait ; 等待复制动作的完成
Clipboard := Trim(clipboard,A_Space) ;去除空格
Run  %clipboard%
return


; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.
