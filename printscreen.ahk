;---------------------------------------------------------------
;printscreen  Load Screen Clipper
;#IfWinNotExist ahk_class SnagIt5UI
$VK2C::
   Process, Exist, SnippingTool.exe
   if (!ErrorLevel)
   {
      EnvGet, windir, windir
      run, %windir%\system32\SnippingTool.exe
	}
return
;#IfWinNotExist
