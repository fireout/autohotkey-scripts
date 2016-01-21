#Left::
MoveWindowToPreviousScreen()
return
#Right::
MoveWindowToNextScreen()
return

#NumPad1::
PositionWindow("","bottom","left")
return
#NumPad2::
PositionWindow("","bottom","center")
return
#NumPad3::
PositionWindow("","bottom","right")
return
#NumPad4::
PositionWindow("","center","left")
return
#NumPad5::
PositionWindow("","center","center")
;CenterWindow("")
return
#NumPad6::
PositionWindow("","center","right")
return
#NumPad7::
PositionWindow("","top","left")
return
#NumPad8::
PositionWindow("","top","center")
return
#NumPad9::
PositionWindow("","top","right")
return


;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;  Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.


CenterWindow(caption)
{
   

   if StrLen(caption) = 0
      WinGet,WinId,ID,A
   else
      WinGet,WinId,ID,%caption%
   
   WinGetPos, WinX, WinY, WinWidth, WinHeight, ahk_id %WinId%

   NewWinX := (A_ScreenWidth - WinWidth) // 2
   NewWinY := (A_ScreenHeight - WinHeight) // 2
   
   WinMove,ahk_id %WinId%,,%NewWinX%,%NewWinY%
}

PositionWindow(caption, vertical, horizontal)
{
   if StrLen(caption) = 0
      WinGet,WinId,ID,A
   else
      WinGet,WinId,ID,%caption%
   
   WinGetPos, WinX, WinY, WinWidth, WinHeight, ahk_id %WinId%
   ;WinGetPos tbrX, tbrY, tbrWidth, tbrHeight, ahk_class Shell_TrayWnd

   monNm := GetMonitorAt(WinX + WinWidth / 2, WinY + WinHeight / 2)
   ;msgbox,% WinX + (WinWidth / 2) . "," . WinY + (WinHeight / 2)
   
   SysGet,monPos,MonitorWorkArea,%monNm%
   ;msgbox,%monNm%`,%monPosLeft% - (%monPosRight%)`, %monPosTop% - (%monPosBottom%)
   
   tmpSense := A_StringCaseSense 
   StringCaseSense, Off

   if (vertical = "top")
      NewWinY := monPosTop
   else if (vertical = "center")
      NewWinY := monPosTop + ((monPosBottom - monPosTop) - WinHeight) // 2
   else if (vertical := "bottom")
      NewWinY := monPosTop + ((monPosBottom - monPosTop) - WinHeight)
      
   if (horizontal = "left")
      NewWinX := monPosLeft
   else if (horizontal = "center")
      NewWinX := monPosLeft + ((monPosRight - monPosLeft) - WinWidth) // 2
   else if (horizontal := "right")
      NewWinX := monPosLeft + ((monPosRight - monPosLeft) - WinWidth)
   
   WinMove,ahk_id %WinId%,,%NewWinX%,%NewWinY%
   
}

GetMonitorAt(x, y, default=1)
{
    SysGet, m, MonitorCount
    ; Iterate through all monitors.
    Loop, %m%
    {   ; Check if the window is on this monitor.
        SysGet, Mon, Monitor, %A_Index%
        if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom){
   ;msgbox,%m%`,%MonLeft% - (%MonRight%)`, %MonTop% - (%MonBottom%)
            return A_Index
   }
    }

;msgbox "DEFAULT"
    return default
}

MoveWindowToNextScreen(caption = "A")
{
    WinGet,WinState, MinMax, %caption%
    isFullScreen := WinState = 1
    
    if (isFullScreen)
      WinRestore, %caption%

    WinGetPos, x, y, w, h, %caption%
   
    ; Determine which monitor contains the center of the window.
    ms := GetMonitorAt(x+w/2, y+h/2)
   
    ; Determine which monitor to move to.
    md := ms+1
    SysGet, mon, MonitorCount
    if (md > mon)
        md := 1
   
    ; This may happen if someone tries it with only one screen. :P
    if (md = ms)
        return

    ; Get source and destination work areas (excludes taskbar-reserved space.)
    SysGet, ms, MonitorWorkArea, %ms%
    SysGet, md, MonitorWorkArea, %md%
    msw := msRight - msLeft, msh := msBottom - msTop
    mdw := mdRight - mdLeft, mdh := mdBottom - mdTop

    ; Calculate new size.
    ;if (IsResizable()) {
        w *= (mdw/msw)
        h *= (mdh/msh)
    ;}
    SetWinDelay, -1
    ; Move window, using resolution difference to scale co-ordinates.
    WinMove,%caption%,, mdLeft + (x-msLeft)*(mdw/msw), mdTop + (y-msTop)*(mdh/msh), w, h

    if (isFullScreen)
      WinMaximize, %caption%
}

MoveWindowToPreviousScreen(caption = "A")
{
    WinGet,WinState, MinMax, %caption%
    isFullScreen := WinState = 1
    
    if (isFullScreen)
      WinRestore, %caption%
      
    WinGetPos, x, y, w, h, %caption%
   
    ; Determine which monitor contains the center of the window.
    ms := GetMonitorAt(x+w/2, y+h/2)
   
    ; Determine which monitor to move to.
    md := ms-1
    SysGet, mon, MonitorCount
    if (md < 1)
        md := mon
   
    ; This may happen if someone tries it with only one screen. :P
    if (md = ms)
        return

    ; Get source and destination work areas (excludes taskbar-reserved space.)
    SysGet, ms, MonitorWorkArea, %ms%
    SysGet, md, MonitorWorkArea, %md%
    msw := msRight - msLeft, msh := msBottom - msTop
    mdw := mdRight - mdLeft, mdh := mdBottom - mdTop

    ; Calculate new size.
    ;if (IsResizable()) {
        w *= (mdw/msw)
        h *= (mdh/msh)
    ;}
    

    SetWinDelay, -1
    ; Move window, using resolution difference to scale co-ordinates.
    WinMove,%caption%,, mdLeft + (x-msLeft)*(mdw/msw), mdTop + (y-msTop)*(mdh/msh), w, h
    
    if (isFullScreen)
      WinMaximize, %caption%
}

IsResizable(caption = "A")
{
    WinGet, Style, Style, %caption%
    return (Style & 0x40000) ; WS_SIZEBOX
}
