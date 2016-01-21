;---------------------------------------------------------------
;printscreen  Load Screen Clipper
;#IfWinNotExist ahk_class SnagIt5UI
$VK2C::
   Process, Exist, SnippingTool.exe
   if (!ErrorLevel)
   {
      run, "C:\Windows\Sysnative\SnippingTool.exe"
	}
return
;#IfWinNotExist
