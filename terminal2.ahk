#InstallKeybdHook

runwait C:\cygwin64\bin\mintty.exe -w max -i /Cygwin-Terminal.ico -,,
WinActivate, ahk_class mintty
WinGet,terminalpid,PId,A


^SC029::
AlwaysAtBottom(WinExist("A"))
return

AlwaysAtBottom(Child_ID)
{
WinSet, ExStyle, +0x8000008, A
WinSet, ExStyle, +0x8000008, A
WinSet, Bottom, , A
}
