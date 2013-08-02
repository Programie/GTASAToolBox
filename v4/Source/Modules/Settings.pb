Structure Objects_Gadgets
	Panel.l
	General_Text1.l
	General_Language.l
EndStructure

Structure Objects
	Gadgets.Objects_Gadgets
EndStructure

Structure Globals
	MainThreadID.l
EndStructure

Global Objects.Objects
Global Globals.Globals
Global NewList Languages.s()

IncludeFile "..\Common.pbi"

DeclareDLL OnEvent(EventID,ObjectID)

Procedure ResizeGadgets()
	Rect.RECT
	GetClientRect_(Common\WindowID,Rect)
	WindowWidth=Rect\right
	WindowHeight=Rect\bottom
	ResizeGadget(Objects\Gadgets\Panel,#PB_Ignore,#PB_Ignore,WindowWidth,WindowHeight)
	ResizeGadget(Objects\Gadgets\General_Language,#PB_Ignore,#PB_Ignore,GetGadgetAttribute(Objects\Gadgets\Panel,#PB_Panel_ItemWidth)-130,#PB_Ignore)
EndProcedure

Procedure MainThread(Null)
	OpenWindow(0,0,0,0,0,"",#PB_Window_Invisible)
	UseGadgetList(Common\WindowID)
		Objects\Gadgets\Panel=PanelGadget(#PB_Any,0,0,0,0)
		AddGadgetItem(Objects\Gadgets\Panel,-1,Language("General"))
			Objects\Gadgets\General_Text1=TextGadget(#PB_Any,10,10,100,20,Language("Language")+":")
			Objects\Gadgets\General_Language=ComboBoxGadget(#PB_Any,120,10,150,20)
			AddGadgetItem(Objects\Gadgets\General_Language,-1,"English (Build in)")
			;CloseGadgetList
			SetGadgetState(Objects\Gadgets\General_Language,0)
			AddElement(Languages())
			Languages()="en"
			Dir=ExamineDirectory(#PB_Any,Common\MainPath+"Languages","*.lng")
			If IsDirectory(Dir)
				While NextDirectoryEntry(Dir)
					Name$=DirectoryEntryName(Dir)
					If Name$<>"." And Name$<>".." And DirectoryEntryType(Dir)=#PB_DirectoryEntry_File
						If OpenPreferences(Common\MainPath+"Languages\"+Name$)
								PreferenceGroup("Info")
									Language$=ReadPreferenceString("Name_Translated","")
									If Language$
										AddGadgetItem(Objects\Gadgets\General_Language,-1,Language$)
										;CloseGadgetList
										Name$=GetFileName(Name$)
										AddElement(Languages())
										Languages()=Name$
										If LCase(GetSettingsValue("general/language","en"))=LCase(Name$)
											SetGadgetState(Objects\Gadgets\General_Language,ListIndex(Languages()))
										EndIf
									EndIf
								;EndPreferenceGroup
							ClosePreferences()
						EndIf
					EndIf
				Wend
				FinishDirectory(Dir)
			EndIf
		CloseGadgetList()
	CloseGadgetList()
	ResizeGadgets()
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
	ProcedureReturn "Title="+Language("Settings")+Chr(13)+"Version=3.1"+Chr(13)+"Build="+Str(#PB_Editor_BuildCount)+Chr(13)+"Author=SelfCoders"+Chr(13)+"WindowSize=500x350"+Chr(13)+"WindowFlags="+Str(#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
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
				Case Objects\Gadgets\General_Language
					Item=GetGadgetState(Objects\Gadgets\General_Language)
					If Item<>-1 And ListIndex(Languages())<>Item
						SelectElement(Languages(),Item)
						SetSettingsValue("general/language",Languages())
						SaveSettings()
						SendModuleMessage("main","ChangeLanguage",Languages())
					EndIf
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
; CursorPosition = 81
; FirstLine = 79
; Folding = --
; EnableXP
; Executable = ..\..\Modules\Settings.dll
; EnableCompileCount = 25
; EnableBuildCount = 25
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0.0.0
; VersionField6 = GTA San Andreas ToolBox Settings Module
; VersionField7 = Settings
; VersionField8 = %EXECUTABLE
; VersionField9 = © SelfCoders 2011
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT