Enumeration
	#RunOnlyOnceCheckWindow
EndEnumeration

#Title="GTA San Andreas ToolBox PluginInfos"

IncludeFile "Includes\Common.pbi"

If OpenConsole()
	Name$=ProgramParameter(0)
	If Name$
		File$=Common\InstallPath+"CheatPlugins\"+Name$+".dll"
		If IsFileEx(File$)
			Dll=OpenLibrary(#PB_Any,File$)
			If IsLibrary(Dll)
				If ExamineLibraryFunctions(Dll)
					While NextLibraryFunction()
						PrintN(LibraryFunctionName())
					Wend
				EndIf
				CloseLibrary(Dll)
			Else
				PrintN("Can not load plugin: "+Name$)
			EndIf
		Else
			PrintN("Can not find plugin: "+Name$)
		EndIf
	Else
		PrintN("Usage: "+GetFilePart(ProgramFilename())+" <Plugin>")
	EndIf
EndIf
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 28
; EnableXP