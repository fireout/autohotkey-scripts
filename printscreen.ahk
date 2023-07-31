;---------------------------------------------------------------
;printscreen  Load Screen Clipper
$VK2C::
{
   If !WinExist("Snip & Sketch") {
      runWait "C:\Users\Pmartin\AppsShortcut\Snip & Sketch"
   } else {
      WinActivate "Snip & Sketch"
   }
   WinWaitActive "Snip & Sketch"
   
   Send "^n"
   return
}
