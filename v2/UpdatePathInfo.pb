Procedure.s GetRegValue(HKey,Path$,Name$)
 DataCB=255
 DataLP$=Space(DataCB)
 If RegOpenKeyEx_(HKey,Path$,0,#KEY_ALL_ACCESS,@hKey)=#ERROR_SUCCESS
  If RegQueryValueEx_(HKey,Name$,0,@Type,@DataLP$,@DataCB)=#ERROR_SUCCESS
   Select Type
    Case #REG_SZ
     If RegQueryValueEx_(HKey,Name$,0,@Type,@DataLP$,@DataCB)=#ERROR_SUCCESS
      ProcedureReturn Trim(Left(DataLP$,DataCB-1))
     EndIf
    Case #REG_DWORD
     If RegQueryValueEx_(HKey,Name$,0,@Type,@DataLP2,@CBData)=#ERROR_SUCCESS
      ProcedureReturn Trim(Str(DataLP2))
     EndIf
   EndSelect
  EndIf
 EndIf
EndProcedure

Procedure.s GetPath(PathID)
 Path$=Space(#MAX_PATH)
 If SHGetSpecialFolderLocation_(0,PathID,@PID)=#NOERROR
  SHGetPathFromIDList_(PID,@Path$)
  Path$=Trim(Path$)
   If Path$
    If Right(Path$,1)<>"\"
     Path$+"\"
    EndIf
    ProcedureReturn Path$
   EndIf
  CoTaskMemFree_(PID)
 EndIf
EndProcedure

If CreatePreferences(GetPathPart(ProgramFilename())+"Config\Paths.ini")
 WritePreferenceString("GTASAUserFiles",GetPath(5)+"GTA San Andreas User Files\")
 WritePreferenceString("GTASAPath",Trim(RemoveString(GetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Rockstar Games\GTA San Andreas\Installation","ExePath"),Chr(34),1)))
 ClosePreferences()
EndIf