SetTitleMatchMode RegEx

Volume_Mute::
F13::
last_found:=WinActive("A")
if WinExist(".*Microsoft Teams$") {
    WinActivate ; Use the window found by WinExist.
    Send, ^+M
    WinActivate ahk_id %last_found%
}
return

+F13::
if WinExist(".*Microsoft Teams$") {
    WinActivate
}
return

F14::
;#last_found:=WinActive("A")
WinRestore,A
ZoneMove("A",3,1,1)
WinMaximize,A
return

+F14::
;#last_found:=WinActive("A")
WinRestore,"A"
ZoneMove("A",2,1,1)
return

F24::
if !WinExist("ahk_exe firefox.exe") {
	Run,C:\Users\PMartin\AppsShortcut\Firefox
	WinWait, ahk_exe firefox.exe
}
WinRestore,ahk_exe firefox.exe
ZoneMove("ahk_exe firefox.exe",1,-0.35,0.75)
WinActivate
return

+F23::
if !WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS") {
	Run,C:\Users\PMartin\AppsShortcut\Terminal
	WinWait,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
}
WinRestore,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
ZoneMove("ahk_class CASCADIA_HOSTING_WINDOW_CLASS",2,0,0,0)
WinMaximize,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
WinActivate,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
return

F23::
if !WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS") {
	Run,C:\Users\PMartin\AppsShortcut\Terminal
	WinWait,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
}
WinRestore,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
ZoneMove("ahk_class CASCADIA_HOSTING_WINDOW_CLASS",3,0,-0.75,15)
WinActivate,ahk_class CASCADIA_HOSTING_WINDOW_CLASS
return

F21::
if !WinExist("OneNote for Windows 10") {
	Run,C:\Users\PMartin\AppsShortcut\OneNote
	WinWait,OneNote for Windows 10
}
WinRestore,OneNote for Windows 10
ZoneMove("OneNote for Windows 10",1,-0.65,1)
WinActivate,OneNote for Windows 10
return

+F21::
if !WinExist("OneNote for Windows 10") {
	Run,C:\Users\PMartin\AppsShortcut\OneNote
	WinWait,OneNote for Windows 10
}
WinRestore,OneNote for Windows 10
ZoneMove("OneNote for Windows 10",2,1,1)
WinMaximize,OneNote for Windows 10
WinActivate,OneNote for Windows 10
return

#T::WinSet,TopMost,On, 

!End::WinSet, AlwaysOnTop, Off
