#Persistent
#NoEnv
;---------------------------------------------------
;|                                                 |
;|              Clipboard Monitor                  |
;|                                                 |
;|  Monitors clipboard and happends it to a        |
;|  variable and a file.                           |
;|                                                 |

clipMonitorActive := true ; Default monitor state  |
clipMonitorLength := 32768 ; Maximum monitor size  |
showDuplicateWarning := false ;                     |
monitorDataFile = %A_AppData%\ClipboardMonitor\clipMonitor.dat

;|                                                 |
;---------------------------------------------------

; Initialize

clipMonitorActive := true
clipMonitorLength := 32768
FileRead, monitorContent, %monitorDataFile%
lastClip := clipboard
lastClipLength := StrLen(lastClip)
; Ignores the first clipboard change (sent when application start)
ignoreClip := true
StartPos := -1
EndPos := -1
Process, Priority,,High
Setbatchlines -1
setkeydelay -1
OnExit, End

LVM_SCROLL := 4116
EM_GETSEL := 0xB0
EM_SETSEL := 0xB1
EM_SCROLLCARET := 0xB7
WM_GETTEXTLENGTH := 0x0E
EM_SETMODIFY := 0xB9
ES_NOHIDESEL := 0x100

; Initialize tray menu
Menu, Tray, Tip, Clipboard Monitor

IfExist, %A_ScriptDir%\clipMonitor.ico
   Menu, Tray, Icon, %A_ScriptDir%\clipMonitor.ico

Menu, Tray, NoStandard
Menu, Tray, Add, Monitor Clipboard, ToggleMonitoring
Menu, Tray, Add, AlwaysOnTop, ToggleAOT
Menu, Tray, Check, AlwaysOnTop
Menu, Tray, Add,
Menu, Tray, Add, Monitor Window, ShowMonitor
Menu, Tray, Default, Monitor Window
Menu, Tray, Check, Monitor Clipboard
Menu, Tray, Add, Quit, QuitApp

return

OnClipboardChange:
TrayTip

if (ignoreClip = true)
{
   ignoreClip := false
   ;Message(clipboard, 2)
   return
}

if (clipMonitorActive <> true)
   return

if (A_EventInfo = 2)
   return

if WinActive("Clipboard Monitor History")
   return

clipLength := StrLen(clipboard)
StringRight, lastClip, monitorContent, clipLength

if (clipLength = lastClipLength)
{
   if (lastClip = clipboard)
   {
      if (showDuplicateWarning = true)
         Message("Ignoring duplicate clip", 1)
      return
   }
}
lastClipLength := clipLength

if (clipLength > clipMonitorLength)
{
   Message("Clipped content is too big",2)
   return
}

StartPos := -1
EndPos := -1

IfWinExist, Clipboard Monitor History
   GuiControlGet, monitorContent,, contentBox

if (monitorContent = "")
   monitorContent = %clipboard%
else
   monitorContent = %monitorContent%`n%clipboard%

IfWinExist, Clipboard Monitor History
{
   GuiControl,, contentBox, %monitorContent%
   gosub,SelectCurrentClip
}


if (StrLen(monitorContent) > clipMonitorLength)
   StringRight monitorContent, monitorContent, clipMonitorLength

return

ShowMonitor:
^+c::
KeyWait, Control
IfWinNotExist, Clipboard Monitor History
{

   if (clipMonitorActive = true)
      Gui, Add, CheckBox, x0 y0 w110 h22 vmonitorCheck gToggleMonitoring Checked , &Monitor clipboard
   else
      Gui, Add, CheckBox, x0 y0 w110 h22 vmonitorCheck gToggleMonitoring , &Monitor clipboard
   Gui, Add, Button, x450 y0 w170 h22 vsendCapture gSendCapture, Send Selection (CTRL-ENTER)
   Gui, Add, Edit, x0 y22 w500 h22 vcontentBox HwndcontentBoxId Multi -Wrap HScroll %ES_NOHIDESEL%, %monitorContent%
   Gui, +AlwaysOnTop
   Gui, +Resize
   Gui, -MinimizeBox -MaximizeBox
   Gui, +MinSize270x100
   ; Gui, -Caption -Theme
   Gui, +ToolWindow
   
   Gui +LastFound
   WinGet, clipMonitorId, ID, A
   WinGetClass, winClass, A
   
   WinGetPos, AWinX, AWinY, AWinW, AWinH, A
   monNm := GetMonitorAt(AWinX + AWinW / 2, AWinY + AWinH / 2)
   SysGet, monPos, MonitorWorkArea, %monNm%
   winW := Abs(monPosRight - monPosLeft) / 3
   winH := Abs(monPosBottom - monPosTop) / 2
      
   if (winClass = "Shell_TrayWnd")
   {
      winX := monPosRight - winW - 10
      winY := monPosBottom - winH - 30

      Gui, Show, x%winX% h%winH% w%winW% y%winY%, Clipboard Monitor History
   }
   else
   {
      winX := AWinX + A_CaretX + 10
      winY := AWinY + A_CaretY - winH
      
      if (winX + winW > monPosRight)
         winW := monPosRight - winX - 20
      if (winY < monPosTop){
         winH := monPosTop + AWinY + A_CaretY -  10
         winY := monPosTop
      }
      
      ;winY := WinY + A_CaretY - winH
      
      Gui, Show, x%winX% y%winY% h%winH% w%winW%, Clipboard Monitor History
   }
;msgbox, AWinX: %AWinX%`, AWinY: %AWinY%`nAWinW: %AWinW%`, AWinH: %AWinH%,Monitor %monNm%`nwinX: %winX%`, winY: %winY%`nwinW: %winW%`, winH: %winH%`nmonPosLeft: %monPosLeft%`, monPosRight: %monPosRight%`nmonPosTop: %monPosTop%`, monPosBottom: %monPosBottom%`n
   gosub,GuiSize

   
   ;Sleep 32
   WinWait ahk_id %clipMonitorId%
   gosub,SelectCurrentClip
   Hotkey, Esc, ManualEscape
   Hotkey, ^Enter, SendCapture
}
Hotkey, Esc, On
Hotkey, ^Enter, On
GuiControl, Focus, contentBox
Return

SelectCurrentClip:
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

ToggleAOT:
Menu, tray, ToggleCheck, AlwaysOnTop
if isChecked(A_ThisMenu, A_ThisMenuItemPos)
   Gui, +AlwaysOnTop
else
   Gui, -AlwaysOnTop

return

^!m::
ToggleMonitoring:
if (clipMonitorActive = true)
{
   Menu, Tray, Uncheck, Monitor Clipboard
   GuiControl,, monitorCheck, 0
   clipMonitorActive := false
   Message("Monitor disabled", 1)
}
else
{
   Menu, Tray, Check, Monitor Clipboard
   GuiControl,, monitorCheck, 1
   clipMonitorActive := true
   Message("Monitor enabled", 1)
}
return


GuiSize:
;GuiControl, Move, monitorCheck, x0 y0 w%A_GuiWidth% h22
buttonWidth := A_GuiWidth - 170
GuiControl, Move, sendCapture, x%buttonWidth%
editHeight := A_GuiHeight - 22
GuiControl, Move, contentBox, x0 y22 w%A_GuiWidth% h%editHeight%
SendMessage, EM_SCROLLCARET, 0, 0, , ahk_id %contentBoxId%
SendMessage, EM_SETMODIFY, 0, 0, , ahk_id %contentBoxId%
return

ManualEscape:
GuiEscape:
GuiClose:
Hotkey, Esc, Off
Hotkey, ^Enter, Off
GuiControl, Focus, contentBox
GuiControlGet, monitorContent,, contentBox

SendMessage, EM_GETSEL, &StartPos, &EndPos, , ahk_id %contentBoxId%
StartPos := NumGet(StartPos)
EndPos := NumGet(EndPos)

Gui, Destroy
return


SendCapture:
KeyWait, Control
KeyWait, LButton
GuiControl, Focus, contentBox

ControlGet,tmpMonitorBox,Selected, , , ahk_id %contentBoxId% ;, Clipboard Monitor History
;msgbox %tmpMonitorBox%
gosub, ManualEscape
WinWait, A

; Pasting selection
ignoreClip := true
clipboard:=tmpMonitorBox
ClipWait
sendplay ^v
Sleep 100
; ignoreClip := true
; clipboard:=lastClip

; Alternate method
; sendplay {raw}%tmpMonitorBox%
return

QuitApp:
End:
FileDelete, %monitorDataFile%
if ErrorLevel
{
   pathSep=\
   StringGetPos, dirEndPos, monitorDataFile, %pathSep%, R
   StringLeft, dirPath, monitorDataFile, dirEndPos
   FileCreateDir, %dirPath%
}
FileAppend, %monitorContent%, %monitorDataFile%
ExitApp
return

Message(msg, level)
{
   Delay := ((level - 1) * 5) + level
   TrayTip, ClipMonitor, %msg%, %Delay%, %level%
   ;SetTimer, ClearTip, 150
   return
   
   ClearTip:
   TrayTip
   return
}

GetMonitorAt(x, y, default=1)
{
    SysGet, m, MonitorCount
    ; Iterate through all monitors.
    Loop, %m%
    {   ; Check if the window is on this monitor.
        SysGet, Mon, Monitor, %A_Index%
        if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom){
            return A_Index
         }
    }

    return default
}

isChecked(MenuNameOrHandle, Position)
{
    static AlreadyDone, mii
   
    if (!AlreadyDone)
    {
        AlreadyDone := true
        VarSetCapacity(mii, 48, 0), NumPut(48, mii), NumPut(1, mii, 4)
    }

    if MenuNameOrHandle is integer
        hMenu := MenuNameOrHandle
    else
        hMenu := MI_GetMenuHandle(MenuNameOrHandle)

    DllCall("GetMenuItemInfo"
        , "uint", hMenu
        , "uint", Position - 1
        , "uint", 0x400         ;MF_BYPOSITION
        , "uint", &mii)
       
    ;MFS_CHECKED = 0x8
    return NumGet(mii, 12) & 0x8
}

;Copied directly from Lexikos' menu icons version 2.2

; Gets a menu handle from a menu name.
; Adapted from Shimanov's Menu_AssignBitmap()
;   http://www.autohotkey.com/forum/topic7526.html
MI_GetMenuHandle(menu_name)
{
    static   h_menuDummy
    ; v2.2: Check for !h_menuDummy instead of h_menuDummy="" in case init failed last time.
    If !h_menuDummy
    {
        Menu, menuDummy, Add
        Menu, menuDummy, DeleteAll

        Gui, 99:Menu, menuDummy
        ; v2.2: Use LastFound method instead of window title. [Thanks animeaime.]
        Gui, 99:+LastFound

        h_menuDummy := DllCall("GetMenu", "uint", WinExist())

        Gui, 99:Menu
        Gui, 99:Destroy

        ; v2.2: Return only after cleaning up. [Thanks animeaime.]
        if !h_menuDummy
            return 0
    }

    Menu, menuDummy, Add, :%menu_name%

    h_menu := DllCall( "GetSubMenu", "uint", h_menuDummy, "int", 0 )

    DllCall( "RemoveMenu", "uint", h_menuDummy, "uint", 0, "uint", 0x400)
    Menu, menuDummy, Delete, :%menu_name%

    return h_menu
}