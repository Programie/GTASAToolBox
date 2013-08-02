Structure Objects_Gadgets
	AvailableModules_Container.l
	AvailableModules_Frame.l
	AvailableModules_List.l
	InstalledModules_Container.l
	InstalledModules_Frame.l
	InstalledModules_List.l
	Splitter.l
EndStructure

Structure Objects
	Gadgets.Objects_Gadgets
EndStructure

Structure Globals
	MainThreadID.l
EndStructure

Global Objects.Objects
Global Globals.Globals

IncludeFile "..\Common.pbi"

DeclareDLL OnEvent(EventID,ObjectID)

Procedure ReloadAvailableModules()
EndProcedure

Procedure ReloadInstalledModules()
	Dir=ExamineDirectory(#PB_Any,Common\ModulesPath,"*.dll")
	If IsDirectory(Dir)
		While NextDirectoryEntry(Dir)
			If DirectoryEntryType(Dir)=#PB_DirectoryEntry_File
				Name$=DirectoryEntryName(Dir)
				If Name$<>"." And Name$<>".."
					Dll=OpenLibrary(#PB_Any,Common\ModulesPath+Name$)
					If IsLibrary(Dll)
						Function=GetFunction(Dll,"GetModuleInfo")
						If Function
							InfoData=CallFunctionFast(Function,@Common\MainPath)
							If InfoData
								InfoData$=PeekS(InfoData)
								WriteLog(InfoData$)
								Title$=""
								Version$=""
								Build$=""
								Author$=""
								For Line=1 To CountString(InfoData$,Chr(13))+1
									Line$=StringField(InfoData$,Line,Chr(13))
									Key$=Trim(StringField(Line$,1,"="))
									Value$=Trim(StringField(Line$,2,"="))
									Select LCase(Key$)
										Case "title"
											Title$=Value$
										Case "version"
											Version$=Value$
										Case "build"
											Build$=Value$
										Case "author"
											Author$=Value$
									EndSelect
								Next
								If Not Title$
									Title$="Unknown title ("+Name$+")"
								EndIf
								AddGadgetItem(Objects\Gadgets\InstalledModules_List,-1,Title$+Chr(10)+Version$+Chr(10)+Build$+Chr(10)+Author$)
							EndIf
						EndIf
						CloseLibrary(Dll)
					EndIf
				EndIf
			EndIf
		Wend
		FinishDirectory(Dir)
	EndIf
EndProcedure

Procedure ResizeGadgets()
	Rect.RECT
	GetClientRect_(Common\WindowID,Rect)
	WindowWidth=Rect\right
	WindowHeight=Rect\bottom
	ResizeGadget(Objects\Gadgets\Splitter,0,0,WindowWidth,Windowheight)
	ResizeGadget(Objects\Gadgets\AvailableModules_Frame,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\AvailableModules_Container)-20,GadgetHeight(Objects\Gadgets\AvailableModules_Container)-20)
	ResizeGadget(Objects\Gadgets\AvailableModules_List,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\AvailableModules_Frame)-20,GadgetHeight(Objects\Gadgets\AvailableModules_Frame)-30)
	ResizeGadget(Objects\Gadgets\InstalledModules_Frame,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\InstalledModules_Container)-20,GadgetHeight(Objects\Gadgets\InstalledModules_Container)-20)
	ResizeGadget(Objects\Gadgets\InstalledModules_List,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\InstalledModules_Frame)-20,GadgetHeight(Objects\Gadgets\InstalledModules_Frame)-30)
EndProcedure

Procedure MainThread(Null)
	OpenWindow(0,0,0,0,0,"",#PB_Window_Invisible)
	UseGadgetList(Common\WindowID)
	Objects\Gadgets\AvailableModules_Container=ContainerGadget(#PB_Any,0,0,0,0)
	Objects\Gadgets\AvailableModules_Frame=Frame3DGadget(#PB_Any,10,10,0,0,Language("Available modules"))
	Objects\Gadgets\AvailableModules_List=ListIconGadget(#PB_Any,20,30,0,0,"Name",150,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
	AddGadgetColumn(Objects\Gadgets\AvailableModules_List,2,"Version",100)
	AddGadgetColumn(Objects\Gadgets\AvailableModules_List,3,"Build",100)
	AddGadgetColumn(Objects\Gadgets\AvailableModules_List,4,Language("Author"),150)
	CloseGadgetList()
	Objects\Gadgets\InstalledModules_Container=ContainerGadget(#PB_Any,0,0,0,0)
	Objects\Gadgets\InstalledModules_Frame=Frame3DGadget(#PB_Any,10,10,0,0,Language("Installed modules"))
	Objects\Gadgets\InstalledModules_List=ListIconGadget(#PB_Any,20,30,0,0,"Name",150,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
	AddGadgetColumn(Objects\Gadgets\InstalledModules_List,2,"Version",100)
	AddGadgetColumn(Objects\Gadgets\InstalledModules_List,3,"Build",100)
	AddGadgetColumn(Objects\Gadgets\InstalledModules_List,4,Language("Author"),150)
	CloseGadgetList()
	Objects\Gadgets\Splitter=SplitterGadget(#PB_Any,0,0,0,0,Objects\Gadgets\AvailableModules_Container,Objects\Gadgets\InstalledModules_Container,#PB_Splitter_Separator)
	ResizeGadgets()
	ReloadAvailableModules()
	ReloadInstalledModules()
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
	ProcedureReturn "Title=Module Manager"+Chr(13)+"Version=3.1"+Chr(13)+"Build="+Str(#PB_Editor_BuildCount)+Chr(13)+"Author=SelfCoders"+Chr(13)+"WindowSize=500x350"+Chr(13)+"WindowFlags="+Str(#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
EndProcedure

ProcedureDLL OnModuleLoad(MainWindowID,WindowID,MainPath$)
	Common\MainWindowID=MainWindowID
	Common\WindowID=WindowID
	InitCommonValues(MainPath$)
	LoadSettings()
	Globals\MainThreadID=CreateThread(@MainThread(),#Null)
EndProcedure

ProcedureDLL OnEvent(EventID,ObjectID)
	Select EventID
		Case #PB_Event_Gadget
			Select ObjectID
				Case Objects\Gadgets\AvailableModules_List
					If GetGadgetState(Objects\Gadgets\AvailableModules_List)<>-1
						Select EventType()
							Case #PB_EventType_RightClick
								ShowMenu("availablemodules")
						EndSelect
					EndIf
				Case Objects\Gadgets\InstalledModules_List
					If GetGadgetState(Objects\Gadgets\InstalledModules_List)<>-1
						Select EventType()
							Case #PB_EventType_RightClick
								ShowMenu("installedmodules")
						EndSelect
					EndIf
				Case Objects\Gadgets\Splitter
					ResizeGadgets()
			EndSelect
		Case #PB_Event_SizeWindow
			ResizeGadgets()
	EndSelect
EndProcedure

ProcedureDLL OnMenuEvent(Menu$,MenuItem$)
	Select LCase(Menu$)
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
	WaitThread(Globals\MainThreadID,3000)
	If IsThread(Globals\MainThreadID)
		KillThread(Globals\MainThreadID)
	EndIf
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 148
; FirstLine = 119
; Folding = --
; EnableXP
; Executable = ..\..\Modules\ModuleManager.dll
; EnableCompileCount = 29
; EnableBuildCount = 26
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0.0.0
; VersionField6 = GTA San Andreas ToolBox Module Manager Module
; VersionField7 = Module Manager
; VersionField8 = %EXECUTABLE
; VersionField9 = © SelfCoders 2011
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT