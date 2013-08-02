IncludeFile "Common.pbi"

Procedure DisplayMessage(Text$="")
;   Text$=ReplaceString(Text$,"ä","ä")
;   Text$=ReplaceString(Text$,"Ä","Ä")
;   Text$=ReplaceString(Text$,"ö","ö")
;   Text$=ReplaceString(Text$,"Ö","Ö")
  Text$=ReplaceString(Text$,"ü",Chr(172))
;   Text$=ReplaceString(Text$,"Ü","Ü")
  WriteProcessString($BAA7A0,Text$)
EndProcedure

UpdateGTASAProcess()

If ReadProcessValue($B6F3B8,#PB_Long)=0
 MessageRequester("Error","PositionSaver can not be started!"+Chr(13)+Chr(13)+"Can not access to GTA San Andreas-Process.",#MB_ICONERROR)
 End
EndIf

File=OpenFile(#PB_Any,"Position.txt")
 If IsFile(File)
  FileSeek(File,Lof(File))
  DisplayMessage("~s~PositionSaver was started!~n~~n~Press ~r~P~s~ to save the current position to file.~n~Press ~r~END~s~ to close PositionSaver.")
  Repeat
   If GetAsyncKeyState_(#VK_P)
    If PressedP=0
     PED=ReadProcessValue($B6F3B8,#PB_Long)
     Pool=ReadProcessValue(PED+20,#PB_Long)
     x.f=ReadProcessFloat(Pool+48)
     y.f=ReadProcessFloat(Pool+52)
     z.f=ReadProcessFloat(Pool+56)
     WriteStringN(File,StrF(x)+"; "+StrF(y)+"; "+StrF(z))
     DisplayMessage("~s~Position was saved!~n~~n~X: ~r~"+StrF(x,2)+"~s~~n~Y: ~r~"+StrF(y,2)+"~s~~n~Z: ~r~"+StrF(z,2)+"~s~")
     PressedP=1
    EndIf
   Else
    PressedP=0
   EndIf
   If GetAsyncKeyState_(#VK_END)
    If PressedEND
     DisplayMessage("~s~Are you really sure to close PositionSaver?~n~~n~Press ~r~Y~s~ to close.~n~Press ~r~N~s~ to cancel.")
     CanQuit=1
     PressedEND=1
    EndIf
   Else
    PressedEND=0
   EndIf
   If CanQuit
    If GetAsyncKeyState_(#VK_Y)
     DisplayMessage("~s~PositionSaver was closed!")
     Quit=1
    ElseIf GetAsyncKeyState_(#VK_N)
     DisplayMessage("~s~Closing canceled!")
     CanQuit=0
    EndIf
   EndIf
   Delay(5)
  Until Quit
  CloseFile(File)
 EndIf