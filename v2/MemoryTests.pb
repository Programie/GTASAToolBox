; ***Common Area***

Global DebugThisApp
Global NewList PED()

IncludeFile "Common.pbi"

Procedure DisplayMessage(Text$)
 Text$=ReplaceString(Text$,"ä",Chr(154))
 Text$=ReplaceString(Text$,"Ä",Chr(131))
 Text$=ReplaceString(Text$,"ö",Chr(168))
 Text$=ReplaceString(Text$,"Ö",Chr(145))
 Text$=ReplaceString(Text$,"ü",Chr(172))
 Text$=ReplaceString(Text$,"Ü",Chr(149))
 Text$=ReplaceString(Text$,"ß",Chr(150))
 WriteProcessString($BAB040,LSet(Text$,255,Chr(0)))
EndProcedure

UpdateGTASAProcess(); Update the PID of GTA San Andreas

; ***Start Of Testarea***

PED=ReadProcessValue($B7CD98,#PB_Long)
Debug PED

PED2=ReadProcessValue($B74490,#PB_Long)
Debug PED2


Memory=AllocateMemory(1988)
Memory2=AllocateMemory(1988)
ReadProcessMemory_(Common\GTASA_PID,PED,Memory,1988,0)
ReadProcessMemory_(Common\GTASA_PID,PED2,Memory2,1988,0)
WriteProcessMemory(PED,Memory2,1988)
WriteProcessMemory(PED2,Memory,1988)