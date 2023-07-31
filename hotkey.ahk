SetTitleMatchMode "RegEx"

Volume_Mute::
F13::
{
	last_found:=WinActive("A")
	if WinExist(".*Microsoft Teams$") {
		WinActivate ; Use the window found by WinExist.
		Send "^+M"
		WinActivate "ahk_id " . last_found
	}
	return
}

+F13::
{
	if WinExist(".*Microsoft Teams$") {
		WinActivate
	}
	return
}

F14::
{
	if !WinExist(" - Slack") {
		Run "C:\Users\PMartin\AppsShortcut\Slack"
		WinWait " - Slack"
	}
	WinRestore " - Slack"
	ZoneMove(" - Slack", 2, 1, -0.70)
	WinActivate " - Slack"
}

+F14::
{
	if !WinExist(" - Slack") {
		Run "C:\Users\PMartin\AppsShortcut\Slack"
		WinWait " - Slack"
	}
	WinRestore " - Slack"
	ZoneMove(" - Slack", 3, 0.75,0.75)
	WinActivate " - Slack"
	WinMaximize " - Slack"
}

F21::
{
	if !WinExist("OneNote for Windows 10") {
		Run "C:\Users\PMartin\AppsShortcut\OneNote"
		WinWait "OneNote for Windows 10"
	}
	WinRestore "OneNote for Windows 10"
	ZoneMove("OneNote for Windows 10",1,-0.65,1)
	WinActivate "OneNote for Windows 10"
	return
}

+F21::
{
	if !WinExist("OneNote for Windows 10") {
		Run "C:\Users\PMartin\AppsShortcut\OneNote"
		WinWait "OneNote for Windows 10"
	}
	WinRestore "OneNote for Windows 10"
	ZoneMove("OneNote for Windows 10",3,1,1)
	WinMaximize "OneNote for Windows 10"
	WinActivate "OneNote for Windows 10"
	return
}


#T::WinMoveTop

!End::WinSetAlwaysOnTop -1,"A"
