;---------------------------------------------------------------
;win+pageup    set current window opaque
#pgup::
winset, transparent, off, a
winset, redraw,, a
return

;---------------------------------------------------------------
;win+pagedown  set current window semi transparent
#pgdn::
WinGet, trans, Transparent, a

if trans=
   trans=255
;trans:= trans - ((256 - trans) * 0.9)
trans:=trans - (trans*0.1)

winset, transparent, %trans%, a
return