Structure Objects_Gadgets
	Cheatlist.l
	Container.l
	Edit_Frame.l
	Edit_Text1.l
	Edit_Text2.l
	Edit_Text3.l
	Edit_Text4.l
	Edit_Cheat.l
	Edit_Parameters.l
	Edit_Description.l
	Edit_Shortcut.l
	Edit_Clear.l
	Edit_AddEdit.l
	CheatBrowser_Container.l
	CheatBrowser_Frame.l
	CheatBrowser_List.l
	Info_Container.l
	Info_Frame.l
	Info_Text.l
	Splitter_CheatBrowser_Info.l
	Splitter.l
EndStructure

Structure Objects
	Gadgets.Objects_Gadgets
EndStructure

Structure Globals_OldEditState
	Cheat.s
	Parameters.s
	Description.s
	Shortcut.l
EndStructure

Structure Globals
	MainThreadID.l
	AddEditState.l
	CurrentEditItem.l
	CheatlistFile.s
	CheatInfoFile.s
	OldEditState.Globals_OldEditState
EndStructure

Structure CheatInfo_Parameters
	Value.s
	Description.s
EndStructure

Structure CheatInfo
	Cheat.s
	Description.s
	List Parameters.CheatInfo_Parameters()
EndStructure

Global Objects.Objects
Global Globals.Globals
Global NewList CheatInfo.CheatInfo()

IncludeFile "..\Common.pbi"

DeclareDLL OnEvent(EventID,ObjectID)

Procedure ReloadCheatlist()
	ClearGadgetItems(Objects\Gadgets\Cheatlist)
	XML=LoadXMLEx(#PB_Any,Globals\CheatlistFile)
	If IsXML(XML)
		MainNode=MainXMLNode(XML)
		FormatXML(XML,#PB_XML_CutNewline|#PB_XML_ReduceSpace)
		Node=XMLNodeFromPath(MainNode,"cheat")
		If Node
			Repeat
				If GetXMLNodeName(Node)="cheat"
					Cheat$=Trim(GetXMLAttribute(Node,"name"))
					Shortcut=Val(GetXMLAttribute(Node,"shortcut"))
					ParameterNode=ChildXMLNode(Node)
					Parameters$=""
					If ParameterNode
						Repeat
							If Parameters$
								Parameters$+" "
							EndIf
							If LCase(GetXMLNodeName(ParameterNode))="parameter"
								Parameters$+Trim(GetXMLNodeText(ParameterNode))
							EndIf
							ParameterNode=NextXMLNode(ParameterNode)
						Until Not ParameterNode
					EndIf
					Parameters$=Trim(Parameters$)
					DescriptionNode=XMLNodeFromPath(Node,"description")
					Description$=""
					If DescriptionNode
						Description$=Trim(GetXMLNodeText(DescriptionNode))
					EndIf
					AddGadgetItem(Objects\Gadgets\Cheatlist,-1,Cheat$+Chr(10)+Parameters$+Chr(10)+Description$+Chr(10)+HumanReadableShortcut(Shortcut))
					SetGadgetItemData(Objects\Gadgets\Cheatlist,CountGadgetItems(Objects\Gadgets\Cheatlist)-1,Shortcut)
				EndIf
				Node=NextXMLNode(Node)
			Until Not Node
		EndIf
		FreeXML(XML)
	EndIf
EndProcedure

Procedure ReloadCheatInfo()
	ClearList(CheatInfo())
	XML=LoadXMLEx(#PB_Any,Globals\CheatInfoFile)
	If IsXML(XML)
		MainNode=MainXMLNode(XML)
		FormatXML(XML,#PB_XML_CutNewline|#PB_XML_ReduceSpace)
		Node=XMLNodeFromPath(MainNode,"cheat")
		If Node
			Repeat
				If GetXMLNodeName(Node)="cheat"
					AddElement(CheatInfo())
					CheatInfo()\Cheat=Trim(GetXMLAttribute(Node,"name"))
					DescriptionNode=XMLNodeFromPath(Node,"description")
					If DescriptionNode
						Repeat
							If GetXMLNodeName(DescriptionNode)="description" And (GetXMLAttribute(DescriptionNode,"language")="" Or GetXMLAttribute(DescriptionNode,"language")=Config\Language)
								CheatInfo()\Description=Trim(GetXMLNodeText(DescriptionNode))
								Break
							EndIf
							DescriptionNode=NextXMLNode(DescriptionNode)
						Until Not DescriptionNode
					EndIf
					ParametersNode=XMLNodeFromPath(Node,"parameters")
					If ParametersNode
						Repeat
							If GetXMLAttribute(ParametersNode,"language")="" Or GetXMLAttribute(ParametersNode,"language")=Config\Language
								ParameterNode=XMLNodeFromPath(ParametersNode,"parameter")
								If ParameterNode
									Repeat
										If GetXMLNodeName(ParameterNode)="parameter"
											AddElement(CheatInfo()\Parameters())
											CheatInfo()\Parameters()\Value=GetXMLAttribute(ParameterNode,"name")
											CheatInfo()\Parameters()\Description=GetXMLNodeText(ParameterNode)
										EndIf
										ParameterNode=NextXMLNode(ParameterNode)
									Until Not ParameterNode
									Break
								EndIf
							EndIf
							ParametersNode=NextXMLNode(ParametersNode)
						Until Not ParametersNode
					EndIf
				EndIf
				Node=NextXMLNode(Node)
			Until Not Node
		EndIf
		FreeXML(XML)
	EndIf
	ClearGadgetItems(Objects\Gadgets\CheatBrowser_List)
	ForEach CheatInfo()
		Parameters$=""
		ForEach CheatInfo()\Parameters()
			If Parameters$
				Parameter$+" "
			EndIf
			Parameters$+CheatInfo()\Parameters()\Value
		Next
		AddGadgetItem(Objects\Gadgets\CheatBrowser_List,-1,CheatInfo()\Cheat+Chr(10)+Parameters$+Chr(10)+CheatInfo()\Description)
	Next
EndProcedure

Procedure SaveCheatlist()
	XML=CreateXML(#PB_Any)
	If IsXML(XML)
		MainNode=CreateXMLNode(RootXMLNode(XML))
		SetXMLNodeName(MainNode,"cheatlist")
		For Item=0 To CountGadgetItems(Objects\Gadgets\Cheatlist)-1
			Cheat$=Trim(GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,0))
			Parameters$=Trim(GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,1))
			Description$=Trim(GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,2))
			Shortcut=GetGadgetItemData(Objects\Gadgets\Cheatlist,Item)
			If Cheat$
				Node=CreateXMLNode(MainNode)
				SetXMLNodeName(Node,"cheat")
				SetXMLAttribute(Node,"name",Cheat$)
				SetXMLAttribute(Node,"shortcut",Str(Shortcut))
				For Parameter=1 To CountString(Parameters$," ")+1
					ParameterNode=CreateXMLNode(Node)
					SetXMLNodeName(ParameterNode,"parameter")
					SetXMLNodeText(ParameterNode,StringField(Parameters$,Parameter," "))
				Next
				DescriptionNode=CreateXMLNode(Node)
				SetXMLNodeName(DescriptionNode,"description")
				SetXMLNodeText(DescriptionNode,Description$)
			EndIf
		Next
		FormatXML(XML,#PB_XML_WindowsNewline|#PB_XML_ReFormat,2)
		SaveXML(XML,Globals\CheatlistFile)
		FreeXML(XML)
	EndIf
EndProcedure

Procedure SetCheatInfo(Cheat$,SetItem=#True)
	Description$=Language("Not available")
	Parameters$=""
	ForEach CheatInfo()
		If LCase(Cheat$)=LCase(CheatInfo()\Cheat)
			Cheat$=CheatInfo()\Cheat
			Description$=CheatInfo()\Description
			ParameterCount=ListSize(CheatInfo()\Parameters())
			ForEach CheatInfo()\Parameters()
				If Parameters$
					Parameters$+Chr(13)
				EndIf
				Parameters$+Chr(9)+CheatInfo()\Parameters()\Value+Chr(13)
				Parameters$+Chr(9)+CheatInfo()\Parameters()\Description
			Next
			If SetItem
				SetGadgetState(Objects\Gadgets\CheatBrowser_List,ListIndex(CheatInfo()))
			EndIf
			Break
		EndIf
	Next
	Text$=Cheat$+Chr(13)
	Text$+Chr(13)
	Text$+Chr(13)
	Text$+Language("Description")+Chr(13)
	Text$+Description$+Chr(13)
	Text$+Chr(13)
	Text$+Chr(13)
	Text$+Language("Parameters")+Chr(13)
	Text$+Parameters$
	SetGadgetText(Objects\Gadgets\Info_Text,Text$)
	FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",14,#CFE_BOLD); Cheat
	Line+1
	FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",8,0)
	Line+1
	FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",8,0)
	Line+1
	FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",10,#CFE_BOLD); String "Description"
	Line+1
	For DescriptionLine=1 To CountString(Description$,Chr(13))+1
		FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",8,0); Description
		Line+1
	Next
	FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",8,0)
	Line+1
	FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",8,0)
	Line+1
	FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",10,#CFE_BOLD); String "Parameters"
	Line+1
	For Parameter=1 To ParameterCount
		FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",8,#CFE_BOLD)
		Line+1
		FormatEditorGadgetLine(Objects\Gadgets\Info_Text,Line,"",8,0)
		Line+1
	Next
	Editor_Select(Objects\Gadgets\Info_Text,0,0,0,0)
EndProcedure

Procedure EditCheat()
	Item=GetGadgetState(Objects\Gadgets\Cheatlist)
	If Item<>-1
		If GetGadgetText(Objects\Gadgets\Edit_Cheat)<>Globals\OldEditState\Cheat Or GetGadgetText(Objects\Gadgets\Edit_Parameters)<>Globals\OldEditState\Parameters Or GetGadgetText(Objects\Gadgets\Edit_Description)<>Globals\OldEditState\Description Or GetGadgetState(Objects\Gadgets\Edit_Shortcut)<>Globals\OldEditState\Shortcut
			DoEdit=MessageRequester(Language("Cheat list"),ReplaceString(Language("You have changed some data in the edit fields.\nAre you sure to discard these changes?"),"\n",Chr(13),#PB_String_NoCase),#MB_YESNO|#MB_ICONQUESTION)
		Else
			DoEdit=#PB_MessageRequester_Yes
		EndIf
		If DoEdit=#PB_MessageRequester_Yes
			Globals\CurrentEditItem=Item
			Globals\OldEditState\Cheat=GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,0)
			Globals\OldEditState\Parameters=GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,1)
			Globals\OldEditState\Description=GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,2)
			Globals\OldEditState\Shortcut=GetGadgetItemData(Objects\Gadgets\Cheatlist,Item)
			SetGadgetText(Objects\Gadgets\Edit_Cheat,Globals\OldEditState\Cheat)
			SetGadgetText(Objects\Gadgets\Edit_Parameters,Globals\OldEditState\Parameters)
			SetGadgetText(Objects\Gadgets\Edit_Description,Globals\OldEditState\Description)
			SetGadgetState(Objects\Gadgets\Edit_Shortcut,Globals\OldEditState\Shortcut)
			SetGadgetText(Objects\Gadgets\Edit_Frame,Language("Edit cheat"))
			SetGadgetText(Objects\Gadgets\Edit_AddEdit,Language("Apply"))
			SetCheatInfo(Globals\OldEditState\Cheat)
		EndIf
	EndIf
EndProcedure

Procedure ResizeGadgets()
	Rect.RECT
	GetClientRect_(Common\WindowID,Rect)
	WindowWidth=Rect\right
	WindowHeight=Rect\bottom
	ResizeGadget(Objects\Gadgets\Splitter,#PB_Ignore,#PB_Ignore,WindowWidth,WindowHeight)
	ResizeGadget(Objects\Gadgets\Edit_Frame,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Container)-20,#PB_Ignore)
	ResizeGadget(Objects\Gadgets\Edit_Cheat,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Container)-130,#PB_Ignore)
	ResizeGadget(Objects\Gadgets\Edit_Parameters,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Container)-130,#PB_Ignore)
	ResizeGadget(Objects\Gadgets\Edit_Description,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Container)-130,#PB_Ignore)
	ResizeGadget(Objects\Gadgets\Edit_Shortcut,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Container)-130,#PB_Ignore)
	ResizeGadget(Objects\Gadgets\Edit_Clear,GadgetWidth(Objects\Gadgets\Container)-230,#PB_Ignore,#PB_Ignore,#PB_Ignore)
	ResizeGadget(Objects\Gadgets\Edit_AddEdit,GadgetWidth(Objects\Gadgets\Container)-120,#PB_Ignore,#PB_Ignore,#PB_Ignore)
	ResizeGadget(Objects\Gadgets\Splitter_CheatBrowser_Info,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Container),GadgetHeight(Objects\Gadgets\Container)-200)
	ResizeGadget(Objects\Gadgets\CheatBrowser_Frame,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\CheatBrowser_Container)-20,GadgetHeight(Objects\Gadgets\CheatBrowser_Container)-20)
	ResizeGadget(Objects\Gadgets\CheatBrowser_List,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\CheatBrowser_Frame)-20,GadgetHeight(Objects\Gadgets\CheatBrowser_Frame)-30)
	ResizeGadget(Objects\Gadgets\Info_Frame,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Info_Container)-20,GadgetHeight(Objects\Gadgets\Info_Container)-20)
	ResizeGadget(Objects\Gadgets\Info_Text,#PB_Ignore,#PB_Ignore,GadgetWidth(Objects\Gadgets\Info_Frame)-20,GadgetHeight(Objects\Gadgets\Info_Frame)-30)
EndProcedure

Procedure MainThread(Null)
	OpenWindow(0,0,0,0,0,"",#PB_Window_Invisible)
	UseGadgetList(Common\WindowID)
	;Rect.RECT
	;GetClientRect_(Common\WindowID,Rect)
	;WindowWidth=Rect\right
	;WindowHeight=Rect\bottom
	Objects\Gadgets\Cheatlist=ListIconGadget(#PB_Any,0,0,0,0,"Cheat",150,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_AlwaysShowSelection)
	AddGadgetColumn(Objects\Gadgets\Cheatlist,2,Language("Parameters"),150)
	AddGadgetColumn(Objects\Gadgets\Cheatlist,3,Language("Description"),350)
	AddGadgetColumn(Objects\Gadgets\Cheatlist,4,Language("Shortcut"),200)
	Objects\Gadgets\Container=ContainerGadget(#PB_Any,0,0,0,0)
	Objects\Gadgets\Edit_Frame=Frame3DGadget(#PB_Any,10,10,0,180,Language("Add cheat"))
	Objects\Gadgets\Edit_Text1=TextGadget(#PB_Any,20,30,80,20,"Cheat:")
	Objects\Gadgets\Edit_Text2=TextGadget(#PB_Any,20,60,80,20,Language("Parameters")+":")
	Objects\Gadgets\Edit_Text3=TextGadget(#PB_Any,20,90,80,20,Language("Description")+":")
	Objects\Gadgets\Edit_Text4=TextGadget(#PB_Any,20,120,80,20,Language("Shortcut")+":")
	Objects\Gadgets\Edit_Cheat=StringGadget(#PB_Any,110,30,0,20,"")
	Objects\Gadgets\Edit_Parameters=StringGadget(#PB_Any,110,60,0,20,"")
	Objects\Gadgets\Edit_Description=StringGadget(#PB_Any,110,90,0,20,"")
	Objects\Gadgets\Edit_Shortcut=ShortcutGadget(#PB_Any,110,120,0,20,0)
	Objects\Gadgets\Edit_Clear=ButtonGadget(#PB_Any,0,150,100,30,Language("Clear"))
	Objects\Gadgets\Edit_AddEdit=ButtonGadget(#PB_Any,0,150,100,30,Language("Add"))
	Objects\Gadgets\CheatBrowser_Container=ContainerGadget(#PB_Any,0,0,0,0)
	Objects\Gadgets\CheatBrowser_Frame=Frame3DGadget(#PB_Any,10,10,0,0,Language("Available cheats"))
	Objects\Gadgets\CheatBrowser_List=ListIconGadget(#PB_Any,20,30,0,0,"Cheat",150,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_AlwaysShowSelection)
	AddGadgetColumn(Objects\Gadgets\CheatBrowser_List,1,Language("Parameters"),150)
	AddGadgetColumn(Objects\Gadgets\CheatBrowser_List,2,Language("Description"),350)
	CloseGadgetList()
	Objects\Gadgets\Info_Container=ContainerGadget(#PB_Any,0,0,0,0)
	Objects\Gadgets\Info_Frame=Frame3DGadget(#PB_Any,10,10,0,0,Language("Information"))
	Objects\Gadgets\Info_Text=EditorGadget(#PB_Any,20,30,0,0,#PB_Editor_ReadOnly)
	CloseGadgetList()
	Objects\Gadgets\Splitter_CheatBrowser_Info=SplitterGadget(#PB_Any,0,200,0,0,Objects\Gadgets\CheatBrowser_Container,Objects\Gadgets\Info_Container,#PB_Splitter_Separator)
	CloseGadgetList()
	Objects\Gadgets\Splitter=SplitterGadget(#PB_Any,0,0,0,0,Objects\Gadgets\Cheatlist,Objects\Gadgets\Container,#PB_Splitter_Vertical)
	ReloadKeys()
	ReloadCheatInfo()
	ReloadCheatlist()
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
	ProcedureReturn "Title="+Language("Cheat list")+Chr(13)+"Version=3.1"+Chr(13)+"Build="+Str(#PB_Editor_BuildCount)+Chr(13)+"Author=SelfCoders"+Chr(13)+"WindowSize=600x450"+Chr(13)+"WindowFlags="+Str(#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
EndProcedure

ProcedureDLL OnModuleLoad(MainWindowID,WindowID,MainPath$)
	Common\MainWindowID=MainWindowID
	Common\WindowID=WindowID
	InitCommonValues(MainPath$)
	LoadSettings()
	Globals\CheatInfoFile=Common\DataPath+"CheatInfo.xml"
	Globals\CheatlistFile=Common\ConfigPath+"Cheats.xml"
	Globals\MainThreadID=CreateThread(@MainThread(),#Null)
EndProcedure

ProcedureDLL OnEvent(EventID,ObjectID)
	Select EventID
		Case #PB_Event_Gadget
			Select ObjectID
				Case Objects\Gadgets\Cheatlist
					Select EventType()
						Case #PB_EventType_LeftDoubleClick
							EditCheat()
						Case #PB_EventType_RightClick
							If GetGadgetState(Objects\Gadgets\Cheatlist)<>-1
								ShowMenu("cheatlist")
							EndIf
					EndSelect
				Case Objects\Gadgets\Edit_Clear
					If GetGadgetText(Objects\Gadgets\Edit_Cheat)<>Globals\OldEditState\Cheat Or GetGadgetText(Objects\Gadgets\Edit_Parameters)<>Globals\OldEditState\Parameters Or GetGadgetText(Objects\Gadgets\Edit_Description)<>Globals\OldEditState\Description Or GetGadgetState(Objects\Gadgets\Edit_Shortcut)<>Globals\OldEditState\Shortcut
						DoClear=MessageRequester(Language("Cheat list"),ReplaceString(Language("You have changed some data in the edit fields.\nAre you sure to discard these changes?"),"\n",Chr(13),#PB_String_NoCase),#MB_YESNO|#MB_ICONQUESTION)
					Else
						DoClear=#PB_MessageRequester_Yes
					EndIf
					If DoClear=#PB_MessageRequester_Yes
						Globals\OldEditState\Cheat=""
						Globals\OldEditState\Parameters=""
						Globals\OldEditState\Description=""
						Globals\OldEditState\Shortcut=0
						SetGadgetText(Objects\Gadgets\Edit_Cheat,"")
						SetGadgetText(Objects\Gadgets\Edit_Parameters,"")
						SetGadgetText(Objects\Gadgets\Edit_Description,"")
						SetGadgetState(Objects\Gadgets\Edit_Shortcut,0)
						SetGadgetText(Objects\Gadgets\Edit_Frame,Language("Add cheat"))
						SetGadgetText(Objects\Gadgets\Edit_AddEdit,Language("Add"))
					EndIf
				Case Objects\Gadgets\Edit_AddEdit
					Cheat$=Trim(GetGadgetText(Objects\Gadgets\Edit_Cheat))
					Parameters$=Trim(GetGadgetText(Objects\Gadgets\Edit_Parameters))
					Description$=Trim(GetGadgetText(Objects\Gadgets\Edit_Description))
					Shortcut=GetGadgetState(Objects\Gadgets\Edit_Shortcut)
					If Cheat$
						IsValidCheat=#False
						For Char=1 To Len(Cheat$)
							Ascii=Asc(Mid(Cheat$,Char,1))
							If (Ascii>=65 And Ascii<=90) Or (Ascii>=97 And Ascii<=122) Or (Ascii>=48 And Ascii<=57); Is character A-Z, a-z, 0-9
								IsValidCheat=#True
							Else
								IsValidCheat=#False
								Break
							EndIf
						Next
						If IsValidCheat
							AlreadyInList=#False
							For Item=0 To CountGadgetItems(Objects\Gadgets\Cheatlist)-1
								If Globals\CurrentEditItem=-1 Or Item<>Globals\CurrentEditItem
									If LCase(GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,0))=LCase(Cheat$) And LCase(GetGadgetItemText(Objects\Gadgets\Cheatlist,Item,1))=LCase(Parameters$)
										AlreadyInList=#True
										Break
									EndIf
								EndIf
							Next
							If AlreadyInList
								MessageRequester(Language("Duplicate cheat"),Language("The cheat with the same parameters already exists!"),#MB_ICONERROR)
							Else
								If Globals\CurrentEditItem=-1
									AddGadgetItem(Objects\Gadgets\Cheatlist,-1,Cheat$+Chr(10)+Parameters$+Chr(10)+Description$+Chr(10)+HumanReadableShortcut(Shortcut))
									SetGadgetItemData(Objects\Gadgets\Cheatlist,CountGadgetItems(Objects\Gadgets\Cheatlist)-1,Shortcut)
								Else
									SetGadgetItemText(Objects\Gadgets\Cheatlist,Globals\CurrentEditItem,Cheat$,0)
									SetGadgetItemText(Objects\Gadgets\Cheatlist,Globals\CurrentEditItem,Parameters$,1)
									SetGadgetItemText(Objects\Gadgets\Cheatlist,Globals\CurrentEditItem,Description$,2)
									SetGadgetItemText(Objects\Gadgets\Cheatlist,Globals\CurrentEditItem,HumanReadableShortcut(Shortcut),3)
									SetGadgetItemData(Objects\Gadgets\Cheatlist,Globals\CurrentEditItem,Shortcut)
								EndIf
								SaveCheatlist()
							EndIf
						Else
							MessageRequester(Language("Invalid cheat"),Language("Cheat contains invalid characters!"),#MB_ICONERROR)
						EndIf
					Else
						MessageRequester(Language("Invalid cheat"),Language("Cheat field is empty!"),#MB_ICONERROR)
					EndIf
				Case Objects\Gadgets\CheatBrowser_List
					Select EventType()
						Case #PB_EventType_Change
							Item=GetGadgetState(Objects\Gadgets\CheatBrowser_List)
							If Item<>-1
								SetCheatInfo(GetGadgetItemText(Objects\Gadgets\CheatBrowser_List,Item,0),#False)
							EndIf
						Case #PB_EventType_LeftDoubleClick
							Item=GetGadgetState(Objects\Gadgets\CheatBrowser_List)
							If Item<>-1
								SetGadgetText(Objects\Gadgets\Edit_Cheat,GetGadgetItemText(Objects\Gadgets\CheatBrowser_List,Item,0))
								SetGadgetText(Objects\Gadgets\Edit_Parameters,GetGadgetItemText(Objects\Gadgets\CheatBrowser_List,Item,1))
								SetGadgetText(Objects\Gadgets\Edit_Description,GetGadgetItemText(Objects\Gadgets\CheatBrowser_List,Item,2))
							EndIf
					EndSelect
				Case Objects\Gadgets\Splitter_CheatBrowser_Info
					ResizeGadgets()
				Case Objects\Gadgets\Splitter
					ResizeGadgets()
			EndSelect
		Case #PB_Event_SizeWindow
			ResizeGadgets()
	EndSelect
EndProcedure

ProcedureDLL OnMenuEvent(Menu$,MenuItem$)
	Select LCase(Menu$)
		Case "cheatlist"
			Select LCase(MenuItem$)
				Case "edit"
					EditCheat()
				Case "remove"
					
			EndSelect
	EndSelect
EndProcedure

ProcedureDLL OnModuleMessage(SenderModule$,Type$,Message$)
	Select LCase(Type$)
		Case "changelanguage"
			Config\Language=Message$
		Case "reloadcheatlist"
			ReloadCheatlist()
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
; CursorPosition = 349
; FirstLine = 347
; Folding = ---
; EnableXP
; Executable = ..\..\Modules\Cheatlist.dll
; EnableCompileCount = 272
; EnableBuildCount = 251
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0
; VersionField6 = GTA San Andreas ToolBox Cheat List Module
; VersionField7 = Cheat List
; VersionField8 = %EXECUTABLE
; VersionField9 = © 2011 SelfCoders
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT