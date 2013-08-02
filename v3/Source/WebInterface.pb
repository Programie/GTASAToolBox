File=ReadFile(#PB_Any,GetPathPart(ProgramFilename())+"Config\Apache.cfg")
If IsFile(File)
	Repeat
		String$=Trim(ReplaceString(ReadString(File),Chr(9)," "))
		If String$ And Left(String$,1)<>"#"
			If LCase(StringField(String$,1," "))="listen"
				Port=Val(StringField(String$,CountString(String$," ")+1," "))
			EndIf
		EndIf
	Until Eof(File)
	CloseFile(File)
EndIf

If Port
	RunProgram("http://127.0.0.1:"+Str(Port)+"/"+ProgramParameter())
Else
	MessageRequester("GTA San Andreas ToolBox WebInterface Launcher","Can not find the port of the web server!"+Chr(13)+"You should reinstall the GTA San Andreas ToolBox.",#MB_ICONERROR)
EndIf