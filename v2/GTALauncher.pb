IncludeFile "Common.pbi"

If Common\InstallPath
 If IsFileEx(Common\InstallPath+"GTA ToolBox.exe")
  RunProgram(Common\InstallPath+"GTA ToolBox.exe","/rungta /nosplash /min",Common\InstallPath)
 Else
  Repeat
   If Right(Common\InstallPath,1)="\"
    Common\InstallPath=Left(Common\InstallPath,Len(Common\InstallPath)-1)
   EndIf
  Until Right(Common\InstallPath,1)<>"\" Or Len(Common\InstallPath)=0
  MessageRequester("Error","GTA San Andreas ToolBox not installed in '"+Common\InstallPath+"'!",#MB_ICONERROR)
 EndIf
EndIf