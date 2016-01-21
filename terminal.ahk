;---------------------------------------------------------------
;alt-1       bring a bash prompt
!1::
ifwinexist,ahk_pid %terminal1pid%
	IfWinActive,ahk_pid %terminal1pid%
	{
		WinMinimize,ahk_pid %terminal1pid%
		return
	}
	else
	{
		winmaximize,ahk_pid %terminal1pid%
		winactivate,ahk_pid %terminal1pid%
	}
else
   {
   runwait C:\cygwin64\bin\mintty.exe -w full -i /Cygwin-Terminal.ico -,,
   ; WinWait, ahk_class mintty
   WinActivate, ahk_class mintty
   WinGet,terminal1pid,PId,A
   }
return

;---------------------------------------------------------------
;alt-2       bring a bash prompt
!2::
WinGetPos,winX,winY,winWidth,winHeight,ahk_pid %terminal2pid%
monitorNo := GetMonitorAt(winX + winWidth / 2, winY + winHeight / 2)
SysGet,mon,Monitor,%monitorNo%
winTop:= monBottom - 80
ifwinexist,ahk_pid %terminal2pid%
{
	IfWinActive,ahk_pid %terminal2pid%
	{
		if (winHeight > 40)
			WinMove,ahk_pid %terminal2pid%,, 0,%winTop%,%winWidth%,40
		else 
			WinMove,ahk_pid %terminal2pid%,, 0,0,%winWidth%,%monBottom%
		return
	}
	else
	{
		winactivate,ahk_pid %terminal2pid%
		;WinMove,ahk_pid %terminal2pid%,, 0,%winTop%,%winWidth%,40
	}
}
else
   {
   runwait C:\cygwin64\bin\mintty.exe -w full -i /Cygwin-Terminal.ico -,,
   ; WinWait, ahk_class mintty
   WinActivate, ahk_class mintty
   WinGet,terminal2pid,PId,A
   WinMove,ahk_pid %terminal2pid%,, 0,%winTop%,%winWidth%,40
   }
return
