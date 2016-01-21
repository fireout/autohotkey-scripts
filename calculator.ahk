;---------------------------------------------------------------
;win-e         bring advanced calculator
SC121::
#c::
ifwinexist,PowerToy Calc
   winactivate,PowerToy Calc
else
   {
   run C:\Users\pmartin\Tools\PowerCalc\powercalc.exe
   winwait,PowerToy Calc
   winactivate,PowerToy Calc
   }
return
