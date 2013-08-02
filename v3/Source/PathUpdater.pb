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

OpenPreferences(InstallPath$+"Config\Paths.info")
	For PathID=1 To 1000
		Path$=GetPath(PathID)
		If Path$
			WritePreferenceString(Str(PathID),Path$)
		EndIf
	Next
ClosePreferences()