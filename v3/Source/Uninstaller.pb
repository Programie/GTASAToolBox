Enumeration
	#RunOnlyOnceCheckWindow
EndEnumeration

#Title="GTA San Andreas ToolBox Uninstaller"

IncludeFile "Includes\Common.pbi"

Procedure DeleteDirectoryEx(Path$)
	Delay(1000)
	Path$=GetPathPart(FormatPath(Path$,#False))
	Dir=ExamineDirectory(#PB_Any,Path$,"*.*")
	Empty=#True
	If IsDirectory(Dir)
		While NextDirectoryEntry(Dir)
			Name$=DirectoryEntryName(Dir)
			If Name$<>"." And Name$<>".."
				Empty=#False
			EndIf
		Wend
		FinishDirectory(Dir)
	EndIf
	If Empty
		DeleteDirectory(Path$,"*.*")
		DeleteDirectoryEx(Path$)
	EndIf
EndProcedure

If ProgramParameter(0)="step2"
	Path$=FormatPath(ProgramParameter(1),#True)
	StartmenuPath$=GetPath(23)+"SelfCoders\GTA San Andreas ToolBox\"
	SCManager=OpenSCManager_(0,0,#SC_MANAGER_ALL_ACCESS)
	If SCManager
		Service=OpenService_(SCManager,"GTASAToolBoxWebSrv",#SERVICE_ALL_ACCESS)
		If Service
			Status.SERVICE_STATUS
			ControlService_(Service,#SERVICE_CONTROL_STOP,Status)
			Timeout=0
			Repeat
				QueryServiceStatus_(Service,Status)
				Timeout+100
				Delay(100)
			Until Status\dwCurrentState=#SERVICE_STOPPED Or Timeout>5000
			If Status\dwCurrentState=#SERVICE_STOPPED
				DeleteService_(Service)
			EndIf
			CloseServiceHandle_(Service)
		EndIf
		CloseServiceHandle_(SCManager)
	EndIf
	Delay(3000); Wait for exit of "step1" state of uninstaller
	DeleteDirectory(Path$,"*.*",#PB_FileSystem_Recursive|#PB_FileSystem_Force)
	DeleteDirectory(StartmenuPath$,"*.*",#PB_FileSystem_Recursive|#PB_FileSystem_Force)
	DeleteDirectoryEx(Path$)
	DeleteDirectoryEx(StartmenuPath$)
	MoveFileEx_(ProgramFilename(),#Null,#MOVEFILE_DELAY_UNTIL_REBOOT)
	MessageRequester(#Title,"Uninstall complete!",#MB_ICONINFORMATION)
Else
	InstallPath$=FormatPath(GetPathPart(ProgramFilename()),#False)
	If MessageRequester(#Title,"Are you sure you want to uninstall the GTA San Andreas ToolBox from your computer?"+Chr(13)+"Note: This will also remove your settings like the cheat list!"+Chr(13)+Chr(13)+"Path: "+InstallPath$,#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
		Path$=GetTemporaryDirectory()
		CopyFile(ProgramFilename(),Path$+"TBUninstall.exe")
		RunProgram(Path$+"TBUninstall.exe","step2 "+Chr(34)+InstallPath$+Chr(34),Path$)
	EndIf
EndIf
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 4
; Folding = -
; EnableXP