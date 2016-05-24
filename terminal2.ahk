#InstallKeybdHook

runwait C:\cygwin64\bin\mintty.exe -w max -i /Cygwin-Terminal.ico -,,
WinActivate, ahk_class mintty
WinGet,terminalpid,PId,A
WinSet, Bottom, , ahk_pid terminalpid
AlwaysAtBottom2(WinExist(ahk_pid %terminalpid%))


^SC029::
return

AlwaysAtBottom(Child_ID)
{
WinSet, ExStyle, +0x8000000, ahk_pid Child_ID
WinSet, ExStyle, +0x8000008, ahk_pid Child_ID
}


AlwaysAtBottom2(wid)
{
DllCall("SetParent", UInt, wid, UInt, WinExist("Program Manager"))
}