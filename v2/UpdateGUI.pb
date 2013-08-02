Path$=GetPathPart(ProgramFilename())
File$=Path$+"Update\GTA ToolBox.exe"
File=ReadFile(#PB_Any,File$)
 If IsFile(File)
  CloseFile(File)
  App=RunProgram(File$,"/updatecheck",GetPathPart(File$),#PB_Program_Open|#PB_Program_Read)
   If IsProgram(App)
    If LCase(Trim(ReadProgramString(App)))=LCase(Trim(MD5FileFingerprint(File$)))
     If MessageRequester("UpdateGUI","Update GUI now?",#MB_YESNO)=#PB_MessageRequester_Yes
      CopyFile(File$,Path$+"GTA ToolBox.exe")
     EndIf
    Else
     MessageRequester("Error","The updatefile is invalid!",#MB_ICONERROR)
    EndIf
    CloseProgram(App)
   Else
    MessageRequester("Error","The updatefile is not a valid executable!",#MB_ICONERROR)
   EndIf
  DeleteFile(File$)
  If LCase(Trim(ProgramParameter()))="/rungui"
   RunProgram(Path$+"GTA ToolBox.exe","",Path$)
  EndIf
 Else
  MessageRequester("Error","Updatefile not found!",#MB_ICONERROR)
 EndIf