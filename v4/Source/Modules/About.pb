Structure Objects
	Gadget_Banner.l
	Gadget_Text.l
	Gadget_Close.l
EndStructure

Global Objects.Objects

IncludeFile "..\Common.pbi"

ProcedureDLL.s GetModuleInfo(MainPath$)
	InitCommonValues(MainPath$)
	LoadSettings()
	ProcedureReturn "Title="+Language("About")+Chr(13)+"Version=3.1"+Chr(13)+"Build="+Str(#PB_Editor_BuildCount)+Chr(13)+"Author=SelfCoders"+Chr(13)+"Hide=1"+Chr(13)+"WindowSize=400x180"
EndProcedure

ProcedureDLL OnModuleLoad(MainWindowID,WindowID,MainPath$)
	Common\MainWindowID=MainWindowID
	Common\WindowID=WindowID
	UseJPEGImageDecoder()
	InitCommonValues(MainPath$)
	UseGadgetList(Common\WindowID)
	Rect.RECT
	GetClientRect_(Common\WindowID,Rect)
	WindowWidth=Rect\right
	WindowHeight=Rect\bottom
	Objects\Gadget_Banner=ImageGadget(#PB_Any,0,0,WindowWidth,80,ImageID(LoadImage(#PB_Any,Common\DataPath+"Banner.jpg")))
	Objects\Gadget_Text=TextGadget(#PB_Any,10,90,WindowWidth-20,WindowHeight-100,"Developed by SelfCoders"+Chr(13)+Chr(13)+Chr(169)+" 2011 SelfCoders")
	Objects\Gadget_Close=ButtonGadget(#PB_Any,WindowWidth/2-50,WindowHeight-30,100,20,Language("Close"))
EndProcedure

ProcedureDLL OnEvent(EventID,ObjectID)
	Select EventID
		Case #PB_Event_Gadget
			Select ObjectID
				Case Objects\Gadget_Close
					SendMessage_(Common\WindowID,#WM_CLOSE,#Null,#Null)
			EndSelect
	EndSelect
EndProcedure

ProcedureDLL OnModuleMessage(SenderModule$,Type$,Message$)
	Select LCase(Type$)
		Case "changelanguage"
			Config\Language=Message$
	EndSelect
EndProcedure

ProcedureDLL OnModuleUnload()
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 12
; FirstLine = 2
; Folding = -
; EnableXP
; Executable = ..\..\Modules\About.dll
; EnableCompileCount = 37
; EnableBuildCount = 33
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0
; VersionField6 = GTA San Andreas ToolBox About Module
; VersionField7 = About
; VersionField8 = %EXECUTABLE
; VersionField9 = © 2011 SelfCoders
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT