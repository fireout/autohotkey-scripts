;---------------------------------------------------------------
;alt-1       bring a bash prompt
!1::
ifwinexist,ahk_class mintty
	IfWinActive,ahk_class mintty
	{
		WinMinimize,ahk_class mintty
		return
	}
	else
	{
		WinMinimizeAll 
		winmaximize,ahk_class mintty
		winactivate,ahk_class mintty
	}
else
   {
   ; runwait C:\cygwin64\bin\mintty.exe -w full -i /Cygwin-Terminal.ico -,,
   runwait "C:\Program Files\Git\git-bash.exe" --cd-to-home,,
   WinActivate, ahk_class mintty
   ;WinGet,terminal1pid,PId,A
   }
return

;---------------------------------------------------------------
;alt-#       resize bash prompt
!#::
IfWinActive,ahk_class mintty
{
;	WinGetPos,winX,winY,winWidth,winHeight,A
;	monitorNo := GetMonitorAt(winX + winWidth / 2, winY + winHeight / 2)
;	SysGet,mon,Monitor,%monitorNo%
;	winTop:= monBottom - 40
;	if (winHeight > 40)
;	{
;		WinMove,A,, 0,%winTop%,%winWidth%,40
;		WinSet, AlwaysOnTop, on, A		
;	}
;	else 
;	{
;		WinMove,A,, 0,0,%winWidth%,%winTop%
;		WinSet, AlwaysOnTop, off, A		
;	}
;	return
    WinSet, Bottom,, ahk_class mintty
}
else
{
	WinMinimizeAll 
	winactivate,ahk_class mintty
}
return
