Structure Objects
	Gadget_ToolBar_Container.l
	Gadget_ToolBar_Home.l
	Gadget_Topics.l
	Gadget_Content.l
	Gadget_Splitter.l
EndStructure

#IndexFile="Index.rtf"

Global Objects.Objects
Global MainThreadID
Global NewList TopicFiles.s()

IncludeFile "..\Common.pbi"

DeclareDLL OnEvent(EventID,ObjectID)

Procedure ListHelpTopics(Path$="")
	If Path$
		Path$+"\"
	EndIf
	FullPath$=Common\MainPath+"Help\"+Config\Language+"\"+Path$
	Dir=ExamineDirectory(#PB_Any,FullPath$,"*.*")
	If IsDirectory(Dir)
		While NextDirectoryEntry(Dir)
			Name$=DirectoryEntryName(Dir)
			If Left(Name$,1)<>"."
				Select DirectoryEntryType(Dir)
					Case #PB_DirectoryEntry_Directory
						AddGadgetItem(Objects\Gadget_Topics,-1,Name$,0,CountString(Path$,"\"))
						AddElement(TopicFiles())
						TopicFiles()=FullPath$+Name$+"\"+#IndexFile
						ListHelpTopics(Path$+Name$)
					Case #PB_DirectoryEntry_File
						If LCase(Name$)<>LCase(#IndexFile)
							AddGadgetItem(Objects\Gadget_Topics,-1,GetFileName(Name$),0,CountString(Path$,"\"))
							AddElement(TopicFiles())
							TopicFiles()=FullPath$+Name$
						EndIf
				EndSelect
			EndIf
		Wend
		FinishDirectory(Dir)
	EndIf
EndProcedure

Procedure MainThread(Null)
	OpenWindow(0,0,0,0,0,"",#PB_Window_Invisible)
	UseGadgetList(Common\WindowID)
	Rect.RECT
	GetClientRect_(Common\WindowID,Rect)
	WindowWidth=Rect\right
	WindowHeight=Rect\bottom
	Objects\Gadget_ToolBar_Container=ContainerGadget(#PB_Any,0,0,WindowWidth,Config\IconSize\ToolBar+10)
		Objects\Gadget_ToolBar_Home=ButtonImageGadget(#PB_Any,0,0,Config\IconSize\ToolBar+10,Config\IconSize\ToolBar+10,ImageID(LoadImage(#PB_Any,Common\IconPath+Str(Config\IconSize\ToolBar)+"\Home.ico")))
	CloseGadgetList()
	Objects\Gadget_Topics=TreeGadget(#PB_Any,0,0,0,0,#PB_Tree_AlwaysShowSelection)
	Objects\Gadget_Content=EditorGadget(#PB_Any,0,0,0,0,#PB_Editor_ReadOnly)
	Objects\Gadget_Splitter=SplitterGadget(#PB_Any,0,Config\IconSize\ToolBar+10,WindowWidth,WindowHeight-Config\IconSize\ToolBar-10,Objects\Gadget_Topics,Objects\Gadget_Content,#PB_Splitter_Separator|#PB_Splitter_Vertical)
	LoadRTF(Objects\Gadget_Content,Common\MainPath+"Help\"+Config\Language+"\"+#IndexFile)
	ListHelpTopics()
	Repeat
		EventID=WaitWindowEvent(5)
		If EventID
			OnEvent(EventID,EventGadget())
		EndIf
	Until Common\Quit
EndProcedure

ProcedureDLL.s GetModuleInfo(MainPath$)
	InitCommonValues(MainPath$)
	LoadSettings()
	ProcedureReturn "Title="+Language("Help")+Chr(13)+"Version=3.1"+Chr(13)+"Build="+Str(#PB_Editor_BuildCount)+Chr(13)+"Author=SelfCoders"+Chr(13)+"Hide=1"+Chr(13)+"WindowFlags="+Str(#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
EndProcedure

ProcedureDLL OnModuleLoad(MainWindowID,WindowID,MainPath$)
	Common\MainWindowID=MainWindowID
	Common\WindowID=WindowID
	InitCommonValues(MainPath$)
	LoadSettings()
	MainThreadID=CreateThread(@MainThread(),#Null)
EndProcedure

ProcedureDLL OnEvent(EventID,ObjectID)
	Select EventID
		Case #PB_Event_Gadget
			Select ObjectID
				Case Objects\Gadget_ToolBar_Home
					LoadRTF(Objects\Gadget_Content,Common\MainPath+"Help\"+Config\Language+"\"+#IndexFile)
				Case Objects\Gadget_Topics
					Item=GetGadgetState(Objects\Gadget_Topics)
					If Item<>-1
						SelectElement(TopicFiles(),Item)
						LoadRTF(Objects\Gadget_Content,TopicFiles())
					EndIf
			EndSelect
		Case #PB_Event_SizeWindow
			Rect.RECT
			GetClientRect_(Common\WindowID,Rect)
			WindowWidth=Rect\right
			WindowHeight=Rect\bottom
			ResizeGadget(Objects\Gadget_ToolBar_Container,#PB_Ignore,#PB_Ignore,WindowWidth,#PB_Ignore)
			ResizeGadget(Objects\Gadget_Splitter,#PB_Ignore,#PB_Ignore,WindowWidth,WindowHeight-Config\IconSize\ToolBar-10)
	EndSelect
EndProcedure

ProcedureDLL OnModuleMessage(SenderModule$,Type$,Message$)
	Select LCase(Type$)
		Case "changelanguage"
			Config\Language=Message$
	EndSelect
EndProcedure

ProcedureDLL OnModuleUnload()
	Common\Quit=#True
	WaitThread(MainThreadID,3000)
	If IsThread(MainThreadID)
		KillThread(MainThreadID)
	EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 72
; FirstLine = 70
; Folding = --
; EnableXP
; Executable = ..\..\Modules\Help.dll
; EnableCompileCount = 101
; EnableBuildCount = 98
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0
; VersionField6 = GTA San Andreas ToolBox Help Module
; VersionField7 = Help
; VersionField8 = %EXECUTABLE
; VersionField9 = © 2011 SelfCoders
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT