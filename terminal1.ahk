;---------------------------------------------------------------
;alt-#       resize bash prompt
!#::
IfWinActive,ahk_class mintty
{
	WinShow, ahk_group HiddenWindows
    WinSet, Bottom,, ahk_class mintty
}
else
{
	EnumAddress := RegisterCallback("EnumWindowsProcHide", "Fast")
	DllCall("EnumWindows", UInt, EnumAddress, UInt, 0)
	winactivate,ahk_class mintty
}
return

EnumWindowsProcHide(hwnd, lParam)
{
    global Output
	DetectHiddenWindows, Off
    WinGetTitle, title, ahk_id %hwnd%
    WinGetClass, class, ahk_id %hwnd%
    if ((title)or(class="Shell_TrayWnd"))
    {
        Output .= "Title: " . title . "`tClass: " . class . "`n"
        WinHide, %title% ahk_class %class%
	GroupAdd, HiddenWindows, ahk_id %hwnd%
    }
    return true  ; Tell EnumWindows() to continue until all windows have been enumerated.
}