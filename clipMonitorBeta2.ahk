#Persistent
#NoEnv
; Environment Variables
monitorDataFile = %A_AppData%\ClipboardMonitor\clipMonitor.dat
FileRead, monitorContent, %monitorDataFile%

; Gui Managment
;ShowMonitor:
;^+c::
;KeyWait, Control
;IfWinNotExist, Clipboard Monitor History
;{

	WinGetPos, AWinX, AWinY, AWinW, AWinH, A
	monNm := GetMonitorAt(AWinX + AWinW / 2, AWinY + AWinH / 2)
	SysGet, monPos, MonitorWorkArea, %monNm%
   
	winW := Floor(Abs(monPosRight - monPosLeft) / 3)
	winH := Floor(Abs(monPosBottom - monPosTop) / 2)
	
	winX := Floor(monPosLeft + (Abs(monPosRight - monPosLeft) / 2)) - Floor(winW / 2)
	winY := Floor(monPosTop + (Abs(monPosBottom - monPosTop) / 2)) - Floor(winH / 2)
     
	Gui, Add, Edit, x0 y0 w%winW% h%winH% vcontentBox HwndcontentBoxId Multi -Wrap HScroll %ES_NOHIDESEL%, %monitorContent%
	Gui, +AlwaysOnTop
	Gui, +Resize
	Gui, -MinimizeBox -MaximizeBox
	Gui, +MinSize270x100
	; Gui, -Caption -Theme
	Gui, +ToolWindow

	Gui +LastFound
	WinGet, clipMonitorId, ID, A
	WinGetClass, winClass, A

	Gui, Show, x%winX% y%winY% h%winH% w%winW%, Clipboard Monitor History
;msgbox, AWinX: %AWinX%`, AWinY: %AWinY%`nAWinW: %AWinW%`, AWinH: %AWinH%,Monitor %monNm%`nwinX: %winX%`, winY: %winY%`nwinW: %winW%`, winH: %winH%`nmonPosLeft: %monPosLeft%`, monPosRight: %monPosRight%`nmonPosTop: %monPosTop%`, monPosBottom: %monPosBottom%`n
   WinWait ahk_id %clipMonitorId%
   gosub,GuiSize
   gosub,GuiSelectCurrentClip

   
   ;Sleep 32
   ;gosub,SelectCurrentClip
   ;Hotkey, Esc, ManualEscape
   ;Hotkey, ^Enter, SendCapture
;}
;Hotkey, Esc, On
;Hotkey, ^Enter, On
;GuiControl, Focus, contentBox
;Return
return 
GuiSize:
GuiControl, Move, contentBox, x0 y0 w%A_GuiWidth% h%A_GuiHeight%
return

GuiScrollToBottom:
SendMessage, EM_SCROLLCARET, 0, 0, , ahk_id %contentBoxId%
SendMessage, EM_SETMODIFY, 0, 0, , ahk_id %contentBoxId%
return

GuiSelectCurrentClip:
if (StartPos > -1)
{
   selectionEnd := StartPos
   selectionStart := EndPos
}
else
{
   SendMessage, WM_GETTEXTLENGTH, 0, 0, , ahk_id %contentBoxId%
   selectionEnd := ErrorLevel
   selectionStart := selectionEnd - StrLen(clipboard)
}

SendMessage, EM_SETSEL, selectionStart, selectionEnd, , ahk_id %contentBoxId%
SendMessage, EM_SCROLLCARET, 0, 0, , ahk_id %contentBoxId%
SendMessage, EM_SETMODIFY, 0, 0, , ahk_id %contentBoxId%
return

GetMonitorAt(x, y, default=1) {
    SysGet, m, MonitorCount
    ; Iterate through all monitors.
    Loop, %m% {   
	; Check if the window is on this monitor.
        SysGet, Mon, Monitor, %A_Index%
        if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom) {
            return A_Index
         }
    }

    return default
}