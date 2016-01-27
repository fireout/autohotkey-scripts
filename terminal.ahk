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
   WinActivate, ahk_class mintty
   WinGet,terminal1pid,PId,A
   }
return

;---------------------------------------------------------------
;alt-2       bring a bash prompt
!2::
ifwinexist,ahk_pid %terminal2pid%
{
	IfWinActive,ahk_pid %terminal2pid%
	{
		WinMinimize,ahk_pid %terminal1pid%
		return
	}
	else
	{
		winmaximize,ahk_pid %terminal1pid%
		winactivate,ahk_pid %terminal1pid%
	}
}
else
   {
   runwait C:\cygwin64\bin\mintty.exe -w full -i /Cygwin-Terminal.ico -,,
   WinActivate, ahk_class mintty
   WinGet,terminal1pid,PId,A
   }
return

;---------------------------------------------------------------
;alt-#       resize bash prompt
!#::
IfWinActive,ahk_class mintty
{
	WinGetPos,winX,winY,winWidth,winHeight,A
	monitorNo := GetMonitorAt(winX + winWidth / 2, winY + winHeight / 2)
	SysGet,mon,Monitor,%monitorNo%
	winTop:= monBottom - 40
	if (winHeight > 40)
	{
		WinMove,A,, 0,%winTop%,%winWidth%,40
		WinSet, AlwaysOnTop, on, A		
	}
	else 
	{
		WinMove,A,, 0,0,%winWidth%,%winTop%
		WinSet, AlwaysOnTop, off, A		
	}
	return
}
else
{
	winactivate,ahk_class mintty
}
return
