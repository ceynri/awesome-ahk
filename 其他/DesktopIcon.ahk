; 双击桌面右上角显示隐藏桌面图标

#Persistent             ; 反复运行该脚本
#NoTrayIcon             ; 不显示图标
#SingleInstance Force   ; 重复启动的时候自动覆盖

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; 桌面Progman|WorkerW
GroupAdd, Desktop, ahk_class ExploreWClass
GroupAdd, Desktop, ahk_class WorkerW

; 获得系统的默认双击间隔时间
WaitTime := DllCall("GetDoubleClickTime")/1000

edge := 10

; 限制仅在桌面下启用以下代码
#IfWinActive, ahk_group Desktop

; 左键双击监听
~LButton::
    KeyWait, LButton
    KeyWait, LButton, D, T %WaitTime%
    If Errorlevel = 0
    {
        MouseGetPos, x, y
        if (x > A_ScreenWidth - edge and y < edge)  ; 屏幕右上角10*10px
        {
            HideOrShowDesktopIcons()
        }
    }
    Return

; 显示/隐藏桌面图标的函数
HideOrShowDesktopIcons()
{
	ControlGet, class, Hwnd,, SysListView321, ahk_class Progman
	If class =
		ControlGet, class, Hwnd,, SysListView321, ahk_class WorkerW
	If DllCall("IsWindowVisible", UInt,class)
	{
		WinHide, ahk_id %class%
		ToolTip HideDesktopIcons
		Sleep,500
		ToolTip
	}
	Else
	{
		WinShow, ahk_id %class%
		ToolTip ShowDesktopIcons
		Sleep,500
		ToolTip
	}
}
