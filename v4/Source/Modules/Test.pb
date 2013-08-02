IncludeFile "..\Common.pbi"

Global MyButton1
Global MyButton2

ProcedureDLL.s GetModuleInfo(MainPath$)
	InitCommonValues(MainPath$)
	LoadSettings()
	Info$="Title=Test Module"+Chr(13)
	Info$+"Version=3.1"+Chr(13)
	Info$+"Build="+Str(#PB_Editor_BuildCount)+Chr(13)
	Info$+"Author=SelfCoders"+Chr(13)
	Info$+"WindowFlags="+Str(#PB_Window_Tool)
	ProcedureReturn Info$
EndProcedure

ProcedureDLL OnEvent(EventID,ObjectID)
	Select EventID
		Case #PB_Event_Gadget
			Select ObjectID
				Case MyButton1
					SendModuleMessage("Test","example","This message has been sent by a module.")
				Case MyButton2
					ShowMenu("testmenu1")
			EndSelect
	EndSelect
EndProcedure

ProcedureDLL OnModuleLoad(MainWindowID,WindowID,MainPath$)
	Common\MainWindowID=MainWindowID
	Common\WindowID=WindowID
	InitCommonValues(MainPath$)
	LoadSettings()
	UseGadgetList(WindowID)
	MyButton1=ButtonGadget(#PB_Any,10,10,100,30,"Message")
	MyButton2=ButtonGadget(#PB_Any,10,50,100,30,"Menu")
EndProcedure

ProcedureDLL OnModuleMessage(SenderModule$,Type$,Message$)
	Select LCase(Type$)
		Case "changelanguage"
			Config\Language=Message$
		Case "example"
			MessageRequester("Message Example",Message$)
	EndSelect
EndProcedure

ProcedureDLL OnMenuEvent(Menu$,MenuItem$)
	MessageRequester("MenuEvent","Menu: "+Menu$+Chr(13)+"Item: "+MenuItem$)
EndProcedure

ProcedureDLL OnModuleUnload()
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 7
; FirstLine = 6
; Folding = --
; EnableXP
; Executable = ..\..\Modules\Test.dll
; EnableCompileCount = 101
; EnableBuildCount = 96
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0
; VersionField6 = GTA San Andreas ToolBox Test Module
; VersionField7 = Test
; VersionField8 = %EXECUTABLE
; VersionField9 = © 2011 SelfCoders
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT