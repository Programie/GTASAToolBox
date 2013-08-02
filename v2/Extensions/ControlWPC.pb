; Diese Erweiterung pausiert den WallpaperChanger während die GTA San Andreas ToolBox gestartet ist.

Procedure Send(Value)
 MessageRequester("EXT",Str(Value))
 MsgID=RegisterWindowMessage_("WallpaperChangerCMD")
 SendMessage_(#HWND_BROADCAST,MsgID,0,Value)
EndProcedure

ProcedureDLL InitExtension(WindowID,Language,MainPath$)
 Send(-1)
EndProcedure

ProcedureDLL QuitExtension()
 Send(1)
EndProcedure