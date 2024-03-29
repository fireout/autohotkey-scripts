ZoneMove(window,monitor:=0,xp:=0.8,yp:=0.8,padding:=10)
{
   SysGet, mCount, MonitorCount

   if (monId > monitor)
   {
      MsgBox, Error
      return
   }

   SysGet, targetMon, MonitorWorkArea, %monitor%

   xpos := xp
   ypos := yp

   targetW := % (targetMonRight - targetMonLeft - (padding * 2)) * (xpos > 0 ? xpos : 1 + xpos) ;
   targetH := % (targetMonBottom - targetMonTop - (padding * 2)) * (ypos > 0 ? ypos : 1 + ypos) ;

   targetX := % xpos < 0 ? (targetMonRight - targetW - padding) : targetMonLeft + padding ;
   targetY := % ypos < 0 ? (targetMonBottom - targetH - padding) : targetMonTop + padding ;

   WinGet,state,MinMax,%window%
   if(%state% != 0) {
      WinRestore,%window%
   }
   WinMove,%window%,,%targetX%,%targetY%,%targetW%,%targetH%
}
/*


SetTitleMatchMode, 2

window := A_Args.Length() > 0 ? A_Args[1] : "A"
monitor := A_Args.Length() > 1 ? A_Args[2] : 0
xp := A_Args.Length() > 2 ? A_Args[3] : 0.8
yp := A_Args.Length() > 3 ? A_Args[4] : 1

WinRestore,%window%
ZoneMove(window,monitor,xp,yp)
if (window != "A")
{
   WinActivate,%window%
}
*/
