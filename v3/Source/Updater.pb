Enumeration
	#RunOnlyOnceCheckWindow
	#Window
	#FileList
	#Frame_Current
	#Progress_Current
	#Frame_Total
	#Progress_Total
	#Info
	#Start
	#Icon_Download
	#Icon_Error
	#Icon_OK
	#Icon_Warning
EndEnumeration

#Title="GTA San Andreas ToolBox Updater"

Structure GlobalData;- Structure, Config
	DownloadUrl.s
	StopThread.b
	Quit.b
	UpdatesFound.b
	DownloadFile_StopProcedure.b
	Thread_SearchUpdates.l
	Thread_DownloadFiles.l
EndStructure

Global GlobalData.GlobalData

IncludeFile "Includes\Common.pbi"

Procedure IsProgramParameter(Parameter$)
	For Index=0 To CountProgramParameters()-1
		If LCase(ProgramParameter(Index))=LCase(Parameter$)
			ProcedureReturn #True
		EndIf
	Next
EndProcedure

Procedure WindowThreadTimeout(Window,ThreadID,Timeout)
	StartTime=ElapsedMilliseconds()
	Title$=GetWindowTitle(Window)
	Repeat
		WaitWindowEvent(10)
		NewTitle$=Title$+" [Timeout "+Str((StartTime+Timeout-ElapsedMilliseconds())/1000)+"]"
		If NewTitle$<>OldTitle$
			OldTitle$=NewTitle$
			SetWindowTitle(Window,NewTitle$)
		EndIf
	Until Not IsThread(ThreadID) Or ElapsedMilliseconds()>StartTime+Timeout
	SetWindowTitle(Window,Title$)
	If IsThread(ThreadID)
		KillThread(ThreadID)
	EndIf
EndProcedure

Procedure CRC32(String$)
	ProcedureReturn CRC32Fingerprint(@String$,StringByteLength(String$))
EndProcedure

Procedure SearchUpdates(Null)
	DisableGadget(#Start,#True)
	ClearGadgetItems(#FileList)
	UpdateFile$=Common\InstallPath+"Updates.tmp"
	DownloadFile("http://projects.selfcoders.com/getinfo.php?project=gta_sa_toolbox&version=3.00",UpdateFile$,#Progress_Current)
	OpenPreferences(UpdateFile$)
		RootUrl$=ReadPreferenceString("RootUrl","http://projects.selfcoders.com/gta_sa_toolbox/")
		GlobalData\DownloadUrl=ReadPreferenceString("FilesUrl","http://projects.selfcoders.com/gta_sa_toolbox/files/")
	ClosePreferences()
	DownloadFile(RootUrl$+"filelist.php",UpdateFile$,#Progress_Current)
	SetGadgetState(#Progress_Current,0)
	If OpenPreferences(UpdateFile$)
		If ExaminePreferenceGroups()
			While NextPreferenceGroup()
				If GlobalData\StopThread
					Break
				EndIf
				MaxState+1
			Wend
		EndIf
		SetGadgetAttribute(#Progress_Total,#PB_ProgressBar_Maximum,MaxState)
		If ExaminePreferenceGroups()
			While NextPreferenceGroup()
				If GlobalData\StopThread
					Break
				EndIf
				File$=PreferenceGroupName()
				MD5$=LCase(ReadPreferenceString("MD5",""))
				Size=ReadPreferenceLong("Size",0)
				Date=ReadPreferenceLong("Date",0)
				If File$ And MD5$
					If Not IsFileEx(Common\InstallPath+File$) And Not IsFileEx(Common\InstallPath+"Updates\"+File$)
						Type$=Language("New file")
					ElseIf LCase(MD5FileFingerprintEx(Common\InstallPath+File$))<>MD5$ And LCase(MD5FileFingerprintEx(Common\InstallPath+"Updates\"+File$))<>MD5$
						Type$=Language("Updated file")
					Else
						Type$=""
					EndIf
					If Type$
						AddGadgetItem(#FileList,-1,Type$+Chr(10)+File$+Chr(10)+CalcSize(Size)+Chr(10)+FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss",Date))
						SetGadgetItemData(#FileList,CountGadgetItems(#FileList)-1,CRC32(MD5$))
						TotalSize+Size
						FilesCount+1
					EndIf
				EndIf
				CurrentState+1
				SetGadgetState(#Progress_Total,CurrentState)
			Wend
		EndIf
		ClosePreferences()
	EndIf
	DeleteFile(UpdateFile$)
	SetGadgetState(#Progress_Total,0)
	If FilesCount
		DisableGadget(#Start,#False)
		GlobalData\UpdatesFound=#True
	Else
		GlobalData\UpdatesFound=#False
	EndIf
	Select FilesCount
		Case 0
			SetGadgetText(#Info,Language("No new updates found"))
			If IsProgramParameter("/setup")
				GlobalData\Quit=#True
			EndIf
		Case 1
			SetGadgetText(#Info,Language("1 update found")+" ("+CalcSize(TotalSize)+")")
		Default
			SetGadgetText(#Info,ReplaceString(Language("%1 updates found"),"%1",Str(FilesCount),#PB_String_NoCase)+" ("+CalcSize(TotalSize)+")")
	EndSelect
EndProcedure

Procedure DownloadFiles(Null)
	FilesCount=CountGadgetItems(#FileList)
	SetGadgetAttribute(#Progress_Total,#PB_ProgressBar_Maximum,FilesCount)
	For File=0 To FilesCount-1
		Type$=GetGadgetItemText(#FileList,File,0)
		File$=GetGadgetItemText(#FileList,File,1)
		Size$=GetGadgetItemText(#FileList,File,2)
		Date$=GetGadgetItemText(#FileList,File,3)
		CRC32=GetGadgetItemData(#FileList,File)
		RemoveGadgetItem(#FileList,File)
		AddGadgetItem(#FileList,File,Type$+Chr(10)+File$+Chr(10)+Size$+Chr(10)+Date$,ImageID(#Icon_Download))
		SetGadgetItemData(#FileList,File,CRC32)
		CreateDirectoryEx(GetPathPart(Common\InstallPath+File$))
		DownloadFile(GlobalData\DownloadUrl+File$,Common\InstallPath+File$,#Progress_Current)
		RemoveGadgetItem(#FileList,File)
		If IsFileEx(Common\InstallPath+File$) And CRC32(MD5FileFingerprint(Common\InstallPath+File$))=CRC32
			Image=#Icon_OK
		Else
			CreateDirectoryEx(GetPathPart(Common\InstallPath+"Updates\"+File$))
			DownloadFile(GlobalData\DownloadUrl+File$,Common\InstallPath+"Updates\"+File$,#Progress_Current)
			If IsFileEx(Common\InstallPath+"Updates\"+File$) And CRC32(MD5FileFingerprint(Common\InstallPath+"Updates\"+File$))=CRC32
				Image=#Icon_Warning
			Else
				Image=#Icon_Error
			EndIf
		EndIf
		AddGadgetItem(#FileList,File,Type$+Chr(10)+File$+Chr(10)+Size$+Chr(10)+Date$,ImageID(Image))
		SetGadgetItemData(#FileList,File,CRC32)
		SetGadgetState(#Progress_Total,File+1)
		If GlobalData\StopThread
			Break
		EndIf
	Next
	SetGadgetState(#Progress_Current,0)
	SetGadgetState(#Progress_Total,0)
	SetGadgetText(#Start,"Start")
	If Not GlobalData\StopThread
		GlobalData\Thread_SearchUpdates=SearchUpdates(#Null)
	EndIf
EndProcedure

Procedure MoveDirectory(SourcePath$,DestinationPath$)
	Dir=ExamineDirectory(#PB_Any,SourcePath$,"*.*")
	If IsDirectory(Dir)
		While NextDirectoryEntry(Dir)
			Name$=DirectoryEntryName(Dir)
			If Name$<>"." And Name$<>".."
				Select DirectoryEntryType(Dir)
					Case #PB_DirectoryEntry_File
						CreateDirectoryEx(GetPathPart(DestinationPath$+Name$))
						DeleteFile(DestinationPath$+Name$)
						RenameFile(SourcePath$+Name$,DestinationPath$+Name$)
					Case #PB_DirectoryEntry_Directory
						MoveDirectory(SourcePath$+Name$+"\",DestinationPath$+Name$+"\")
				EndSelect
			EndIf
		Wend
		FinishDirectory(Dir)
		If IsDirectoryEmpty(SourcePath$)
			DeleteDirectory(SourcePath$,"*.*")
		EndIf
	EndIf
EndProcedure

CatchImage(#Icon_Download,?Icon_Download)
CatchImage(#Icon_Error,?Icon_Error)
CatchImage(#Icon_OK,?Icon_OK)
CatchImage(#Icon_Warning,?Icon_Warning)
LoadSettings()
LoadLanguage()

If IsProgramParameter("/fixupdate")
	Delay(1000)
	Path$=GetPathPart(RTrim(Common\InstallPath,"\"))
	MoveDirectory(Common\InstallPath,Path$)
	RunProgram(Path$+"Updater.exe","/removeupdatedir",Path$)
	End
EndIf

If IsProgramParameter("/removeupdatedir")
	Delay(1000)
	DeleteFile(Common\InstallPath+"Updates\Updater.exe")
	DeleteDirectory(Common\InstallPath+"Updates\","*.*",#PB_FileSystem_Recursive)
	End
EndIf

If OpenWindow(#Window,100,100,700,400,#Title,#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered)
	ListIconGadget(#FileList,10,10,WindowWidth(#Window)-20,WindowHeight(#Window)-200,Language("Type"),100,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)
		AddGadgetColumn(#FileList,1,"Name",250)
		AddGadgetColumn(#FileList,2,Language("Size"),70)
		AddGadgetColumn(#FileList,3,Language("Date"),120)
	Frame3DGadget(#Frame_Current,10,WindowHeight(#Window)-175,WindowWidth(#Window)-20,60,Language("Current progress"))
		ProgressBarGadget(#Progress_Current,20,WindowHeight(#Window)-155,WindowWidth(#Window)-40,30,0,0,#PB_ProgressBar_Smooth)
	Frame3DGadget(#Frame_Total,10,WindowHeight(#Window)-110,WindowWidth(#Window)-20,60,Language("Total progress"))
		ProgressBarGadget(#Progress_Total,20,WindowHeight(#Window)-90,WindowWidth(#Window)-40,30,0,0,#PB_ProgressBar_Smooth)
	TextGadget(#Info,10,WindowHeight(#Window)-30,WindowWidth(#Window)-130,20,"")
	ButtonGadget(#Start,WindowWidth(#Window)-110,WindowHeight(#Window)-40,100,30,"Start")
	DisableGadget(#Start,#True)
	FirstSearch=#True
	GlobalData\Thread_SearchUpdates=CreateThread(@SearchUpdates(),#Null)
	Repeat
		If FirstSearch And Not IsThread(GlobalData\Thread_SearchUpdates)
			FirstSearch=#False
			If IsProgramParameter("/setup")
				GlobalData\Thread_DownloadFiles=CreateThread(@DownloadFiles(),#Null)
				SetGadgetText(#Start,"Stop")
			EndIf
		EndIf
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #Start
						If IsThread(GlobalData\Thread_DownloadFiles)
							If MessageRequester(GetWindowTitle(#Window),Language("Are you sure to stop the download?"),#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
								GlobalData\StopThread=#True
								GlobalData\DownloadFile_StopProcedure=#True
								WindowThreadTimeout(#Window,GlobalData\Thread_DownloadFiles,10000)
								GlobalData\StopThread=#False
								GlobalData\DownloadFile_StopProcedure=#False
								SetGadgetState(#Progress_Current,0)
								SetGadgetState(#Progress_Total,0)
								GlobalData\Thread_SearchUpdates=CreateThread(@SearchUpdates(),#Null)
								SetGadgetText(#Start,"Start")
							EndIf
						Else
							GlobalData\Thread_DownloadFiles=CreateThread(@DownloadFiles(),#Null)
							SetGadgetText(#Start,"Stop")
						EndIf
				EndSelect
			Case #PB_Event_SizeWindow
				ResizeGadget(#FileList,10,10,WindowWidth(#Window)-20,WindowHeight(#Window)-200)
				ResizeGadget(#Frame_Current,10,WindowHeight(#Window)-175,WindowWidth(#Window)-20,60)
				ResizeGadget(#Progress_Current,20,WindowHeight(#Window)-155,WindowWidth(#Window)-40,30)
				ResizeGadget(#Frame_Total,10,WindowHeight(#Window)-110,WindowWidth(#Window)-20,60)
				ResizeGadget(#Progress_Total,20,WindowHeight(#Window)-90,WindowWidth(#Window)-40,30)
				ResizeGadget(#Info,10,WindowHeight(#Window)-30,WindowWidth(#Window)-130,20)
				ResizeGadget(#Start,WindowWidth(#Window)-110,WindowHeight(#Window)-40,100,30)
			Case #PB_Event_CloseWindow
				If IsThread(GlobalData\Thread_SearchUpdates) Or IsThread(GlobalData\Thread_DownloadFiles)
					If MessageRequester(GetWindowTitle(#Window),Language("Are you sure to stop the download?"),#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
						GlobalData\StopThread=#True
						GlobalData\DownloadFile_StopProcedure=#True
						WindowThreadTimeout(#Window,GlobalData\Thread_SearchUpdates,10000)
						WindowThreadTimeout(#Window,GlobalData\Thread_DownloadFiles,10000)
						GlobalData\Quit=#True
					EndIf
				Else
					GlobalData\Quit=#True
				EndIf
		EndSelect
	Until GlobalData\Quit
EndIf

If Not GlobalData\UpdatesFound
	If Not IsDirectoryEmpty(Common\InstallPath+"Updates")
		If Not IsFileEx(Common\InstallPath+"Updates\Updater.exe")
			CopyFile(Common\InstallPath+"Updater.exe",Common\InstallPath+"Updates\Updater.exe")
		EndIf
		RunProgram(Common\InstallPath+"Updates\Updater.exe","/fixupdate",Common\InstallPath+"Updates\")
	EndIf
	End #True
EndIf

IncludePath "Resources"

DataSection
 Icon_Download:
  IncludeBinary "Download.ico"
 Icon_Error:
  IncludeBinary "Error.ico"
 Icon_OK:
  IncludeBinary "OK.ico"
 Icon_Warning:
 	IncludeBinary "Warning.ico"
EndDataSection
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 124
; FirstLine = 106
; Folding = --
; EnableXP