#Persistent
DetectHiddenWindows, on
CoordMode, ToolTip, Relative

stdWidth := "320,400,640,800,960,1024,1280,1600,1920,2800,3200"
stdHeight := "240,300,360,480,600,720,768,900,960,1080,1200,2100,2400"

#Home::
Winset, Alwaysontop, On, A

return
#End::
Winset, Alwaysontop, Off, A

return

+#Left::
WinGetPos,winX,winY,winWidth,winHeight,A
winWidth := GetStandardRes(StdWidth,winWidth,-1)
WinMove,A,,,,%winWidth%, %winHeight%
ToolTip,% winWidth "x" winHeight ", " GetAspectRatio(winWidth, winHeight) " (" winWidth / winHeight ")", 0, 0
SetTimer, HideToolTip, 10024
return
+#Right::
WinGetPos,winX,winY,winWidth,winHeight,A
winWidth := GetStandardRes(stdWidth,winWidth)
monitorNo := GetMonitorAt(winX + winWidth / 2, winY + winHeight / 2)
SysGet,mon,MonitorWorkArea,%monitorNo%
if (winWidth > monRight - monLeft)
   winWidth := monRight - monLeft
if (winWidth + winX > monRight)
   winX := monRight - winWidth
WinMove,A,,%winX%,,%winWidth%, %winHeight%
WinMove,A,,,,%winWidth%, %winHeight%
ToolTip,% winWidth "x" winHeight ", " GetAspectRatio(winWidth, winHeight) " (" winWidth / winHeight ")", 0, 0
SetTimer, HideToolTip, 10024
return
#+Up::
WinGetPos,winX,winY,winWidth,winHeight,A
winHeight := GetStandardRes(stdHeight,winHeight,-1)
WinMove,A,,,,%winWidth%, %winHeight%
ToolTip,% winWidth "x" winHeight ", " GetAspectRatio(winWidth, winHeight) " (" winWidth / winHeight ")", 0, 0
SetTimer, HideToolTip, 10024
return
#+Down::
WinGetPos,winX,winY,winWidth,winHeight,A
winHeight := GetStandardRes(stdHeight,winHeight)
monitorNo := GetMonitorAt(winX + winWidth / 2, winY + winHeight / 2)
SysGet,mon,MonitorWorkArea,%monitorNo%
if (winHeight > monBottom - monTop)
   winHeight := monBottom - monTop
if (winHeight + winY > monBottom)
   winY := monBottom - winHeight
WinMove,A,,,%winY%,%winWidth%, %winHeight%
ToolTip,% winWidth "x" winHeight ", " GetAspectRatio(winWidth, winHeight) " (" winWidth / winHeight ")", 0, 0
SetTimer, HideToolTip, 10024
return

HideToolTip:
ToolTip,
SetTimer, HideToolTip, Off
return

GetStandardRes(resList, current, direction = 1)
{
StringSplit, res, resList, `,

if (direction > 0)
   start := 1
else
   start := res0
loop, %res0%
{
   if (direction > 0 and res%A_Index% > current)
      return res%A_Index%
   else if (direction < 1)
   {
      curIndex := start - A_Index
      if (res%curIndex% < current and curIndex > 0)
         return res%curIndex%
   }
}
return current

}

GetAspectRatio(width, height)
{
   return
   ratioDiv := 1
   loop
   {
      ratioDiv += 1
      upFrac := width / height * ratioDiv
      rndFrac := Round(upFrac, 0)
      if (upFrac = rndFrac)
         return % Round(width / height * ratioDiv, 0) ":" ratioDiv
   }
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
