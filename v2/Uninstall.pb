#MaxLang=4

IncludeFile "Common.pbi"

Global Dim Language.s(#MaxLang)

Restore Language_English
For Language=0 To #MaxLang
 Read Language(Language)
Next

Select LCase(Trim(ProgramParameter()))
 Case "/step2"
  MessageRequester("2. Instanz",ProgramParameter())
 Default
  Path$=GetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\SelfCoders","GTA San Andreas ToolBox")
   If Path$
    File=ReadFile(#PB_Any,Path$+"GTA ToolBox.exe")
     If IsFile(File)
      CloseFile(File)
      If MessageRequester(Language(0),ReplaceString(ReplaceString(Language(1),"%1",Path$,1),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
       Temp$=Space(#MAX_PATH)
       GetTempPath_(#MAX_PATH,@Temp$)
       Temp$+GetFilePart(ProgramFilename())
       CopyFile(ProgramFilename(),Temp$)
       RunProgram(Temp$,"/step2 "+Chr(34)+Path$+Chr(34),GetPathPart(Temp$))
      EndIf
     Else
      MessageRequester(Language(2),ReplaceString(Language(3),"%1",Path$,1),#MB_ICONERROR)
     EndIf
   Else
    MessageRequester(Language(2),Language(4),#MB_ICONERROR)
   EndIf
EndSelect

DataSection
 Language_English:
  Data$ "Uninstall GTA San Andreas ToolBox"; 0
  Data$ "Are you sure to uninstall the GTA San Andreas ToolBox and remove all files and folders from the following directory?<br><br>%1"; 1
  Data$ "Error"; 2
  Data$ "The GTA San Andreas ToolBox wasn´t found in '%1'!"; 3
  Data$ "The GTA San Andreas ToolBox isn´t installed!"; 4
 Language_German:
  Data$ "GTA San Andreas ToolBox deinstallieren"; 0
  Data$ "Bist du dir sicher, dass du die GTA San Andreas ToolBox deinstallieren und alle Dateien und Ordner aus dem folgenden Verzeichnis löschen möchtest?<br><br>%1"; 1
  Data$ "Fehler"; 2
  Data$ "Die GTA San Andreas ToolBox wurde in '%1' nicht gefunden!"; 3
  Data$ "Die GTA San Andreas ToolBox ist nicht installiert!"; 4
EndDataSection