Enumeration
	#Window
	#Preview_Text
	#Preview_Continue
	#Menu
	#Menu_Settings
	#Menu_Quit
	#Menu_Help
	#Menu_CheckForUpdates
	#Menu_About
	#MDI
	#FirstMDIWindow
	#FirstXMLMenuItem=#FirstMDIWindow+999
EndEnumeration

IncludeFile "Common.pbi"

Structure Modules_Menu_Items
	MenuItem.l
	Name.s
EndStructure

Structure Modules_Menu
	ID.l
	Name.s
	List Items.Modules_Menu_Items()
EndStructure

Structure Modules
	Name.s
	Dll.l
	Title.s
	EventFunction.l
	List Menu.Modules_Menu()
EndStructure

Structure DynamicXMLMenu
	MenuItem.l
	MenuItemName.s
	Menu.s
	Module.s
EndStructure

#Title="GTA San Andreas ToolBox"

Global NewList Modules.Modules()
Global NewList DynamicXMLMenu.DynamicXMLMenu()

Procedure SetMenuItemIcon(MenuItem,Name$)
	IconFile$=Common\IconPath+Str(Config\IconSize\Menu)+"\"+Name$+".ico"
	If IsFileEx(IconFile$)
		Icon=LoadImage(#PB_Any,IconFile$)
	EndIf
	Image=CreateImage(#PB_Any,32,32)
	If IsImage(Image)
		If StartDrawing(ImageOutput(Image))
			Box(0,0,32,32,GetSysColor_(#COLOR_MENU))
			If IsImage(Icon)
				DrawImage(ImageID(Icon),0,0)
			EndIf
			StopDrawing()
		EndIf
		If IsImage(Icon)
			FreeImage(Icon)
		EndIf
		SetMenuItemBitmaps_(MenuID(#Menu),MenuItem,#MF_BYCOMMAND,ImageID(Image),ImageID(Image))
	EndIf
EndProcedure

Procedure AddMenuItem(MenuItem,Text$,Name$)
	Shortcut=Val(GetSettingsValue("shortcuts/"+LCase(Name$)))
	If Shortcut
		Shortcut$=HumanReadableShortcut(Shortcut)
	EndIf
	If Shortcut$
		Shortcut$=Chr(9)+Shortcut$
	EndIf
	MenuItem(MenuItem,Text$+Shortcut$)
	SetMenuItemIcon(MenuItem,Name$)
	If Shortcut
		AddKeyboardShortcut(#Window,Shortcut,MenuItem)
	EndIf
EndProcedure

Procedure ActivateMDIChild(Window)
	HideWindow(Window,#False)
	SetGadgetState(#MDI,Window)
EndProcedure

Procedure ActiveModuleWindow(Module$)
	ForEach Modules()
		If LCase(Module$)=LCase(Modules()\Name)
			ActivateMDIChild(#FirstMDIWindow+ListIndex(Modules()))
			ProcedureReturn #True
		EndIf
	Next
	MessageRequester(#Title,ReplaceString(ReplaceString(Language("Module '%1' is missing!\n\nPlease reinstall the module and try again."),"\n",Chr(13),#PB_String_NoCase),"%1",Module$),#MB_ICONERROR)
EndProcedure

Procedure GadgetDisabledCountdown(Gadget)
	DisableGadget(Gadget,#True)
	Text$=GetGadgetText(Gadget)
	For Time=5 To 0 Step -1
		SetGadgetText(Gadget,Text$+" ("+Str(Time)+")")
		If Time>0
			Delay(1000)
		EndIf
	Next
	SetGadgetText(Gadget,Text$)
	DisableGadget(Gadget,#False)
EndProcedure

Procedure RefreshMenu()
	If CreateMenu(#Menu,WindowID(#Window))
		MenuTitle(Language("File"))
			AddMenuItem(#Menu_Settings,Language("Settings"),"Settings")
				MenuBar()
			AddMenuItem(#Menu_Quit,Language("Quit"),"Quit")
		;EndMenu "File"
		MenuTitle(Language("Modules"))
			ForEach Modules()
				Select LCase(Modules()\Name)
					Case "about","help","settings","updater"; Don't show internal modules in this menu... They have their own menu items in "File" or "Help"
					Default
						MenuItem=#FirstMDIWindow+ListIndex(Modules())
						AddMenuItem(MenuItem,Modules()\Title,Modules()\Name)
				EndSelect
			Next
		;EndMenu "Modules"
		MenuTitle(Language("Help"))
			AddMenuItem(#Menu_Help,Language("Help"),"Help")
				MenuBar()
			AddMenuItem(#Menu_CheckForUpdates,Language("Check for updates"),"Updater")
				MenuBar()
			AddMenuItem(#Menu_About,Language("About"),"About")
		;EndMenu "Help"
	EndIf
EndProcedure

Procedure XML2Menu(Node)
	Shared NextXMLMenuItem
	If XMLNodeType(Node)=#PB_XML_Normal
		While Node
			Select GetXMLNodeName(Node)
				Case "menuitem"
					TextNode=XMLNodeFromPath(Node,"text")
					DefaultTextNode=TextNode
					If TextNode
						Repeat
							If GetXMLNodeName(TextNode)="text"
								If GetXMLAttribute(TextNode,"language")=""
									DefaultTextNode=TextNode
								ElseIf GetXMLAttribute(TextNode,"language")=Config\Language
									Break
								EndIf
							EndIf
							TextNode=NextXMLNode(TextNode)
						Until Not TextNode
						If Not TextNode
							TextNode=DefaultTextNode
						EndIf
						MenuItem(#FirstXMLMenuItem+NextXMLMenuItem,GetXMLNodeText(TextNode))
						AddElement(Modules()\Menu()\Items())
						Modules()\Menu()\Items()\MenuItem=#FirstXMLMenuItem+NextXMLMenuItem
						Modules()\Menu()\Items()\Name=LCase(GetXMLAttribute(Node,"name"))
						If Val(GetXMLAttribute(Node,"default"))
							Info.MENUITEMINFO
							Info\cbSize=SizeOf(Info)
							Info\fMask=#MIIM_STATE
							Info\fState=#MFS_DEFAULT
							SetMenuItemInfo_(MenuID(Modules()\Menu()\ID),#FirstXMLMenuItem+NextXMLMenuItem,#False,Info)
						EndIf
						NextXMLMenuItem+1
					EndIf
				Case "menubar"
					MenuBar()
				Case "submenu"
					TitleNode=XMLNodeFromPath(Node,"title")
					DefaultTitleNode=TitleNode
					If TitleNode
						Repeat
							If GetXMLNodeName(TitleNode)="title"
								If GetXMLAttribute(TitleNode,"language")=""
									DefaultTitleNode=TitleNode
								ElseIf GetXMLAttribute(TitleNode,"language")=Config\Language
									Break
								EndIf
							EndIf
							TitleNode=NextXMLNode(TitleNode)
						Until Not TitleNode
						If Not TitleNode
							TitleNode=DefaultTitleNode
						EndIf
						OpenSubMenu(GetXMLNodeText(TitleNode))
							XML2Menu(ChildXMLNode(Node))
						CloseSubMenu()
					EndIf
			EndSelect
			Node=NextXMLNode(Node)
		Wend
	EndIf
EndProcedure

Procedure Callback(WindowID,Message,wParam,lParam)
	Select Message
		Case #WM_COPYDATA
			*DataString.COPYDATASTRUCT
			*DataString=lParam
			DataString$=Trim(PeekS(*DataString\lpData))
			ReceiverModule$=Trim(StringField(DataString$,1,":"))
			SenderModule$=Trim(StringField(DataString$,2,":"))
			MessageType$=StringField(DataString$,3,":")
			Message$=Trim(Mid(DataString$,FindString(DataString$,":",FindString(DataString$,":",FindString(DataString$,":",1)+1)+1)+1))
			If LCase(ReceiverModule$)="main"
				ForEach Modules()
					If LCase(SenderModule$)=LCase(Modules()\Name)
						HasSenderModule=#True
						Break
					EndIf
				Next
				Select LCase(MessageType$)
					Case "changelanguage"
						If HasSenderModule
							ForEach Modules()
								CallFunction(Modules()\Dll,"OnModuleMessage",@SenderModule$,@MessageType$,@Message$)
							Next
						EndIf
					Case "displaymenu"
						If HasSenderModule
							ForEach Modules()\Menu()
								If LCase(StringField(DataString$,4,":"))=LCase(Modules()\Menu()\Name)
									DisplayPopupMenu(Modules()\Menu()\ID,WindowID)
								EndIf
							Next
						EndIf
				EndSelect
			Else
				ForEach Modules()
					If LCase(ReceiverModule$)=LCase(Modules()\Name)
						CallFunction(Modules()\Dll,"OnModuleMessage",@SenderModule$,@MessageType$,@Message$)
						Break
					EndIf
				Next
			EndIf
	EndSelect
	ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

InitCommonValues()
LoadSettings()
ReloadKeys()

If Not Config\PreviewInfoSeen
	If OpenWindow(#Window,100,100,400,100,#Title,#PB_Window_ScreenCentered)
		TextGadget(#Preview_Text,10,10,WindowWidth(#Window),WindowHeight(#Window)-60,Language("This is an early preview release of the new GTA San Andreas ToolBox v3.1."+Chr(13)+Chr(13)+"The most features of this release may not work!"))
		ButtonGadget(#Preview_Continue,WindowWidth(#Window)/2-50,WindowHeight(#Window)-40,100,30,Language("Continue"))
		DisableGadget(#Preview_Continue,#True)
		CreateThread(@GadgetDisabledCountdown(),#Preview_Continue)
		Repeat
			Select WaitWindowEvent()
				Case #PB_Event_Gadget
					Select EventGadget()
						Case #Preview_Continue
							SetSettingsValue("general/previewinfoseen","1")
							SaveSettings()
							Break
					EndSelect
			EndSelect
		ForEver
		CloseWindow(#Window)
	EndIf
EndIf

If OpenWindow(#Window,100,100,600,400,#Title,#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible)
	RefreshMenu()
	MDIGadget(#MDI,0,0,0,0,-1,#FirstMDIWindow,#PB_MDI_AutoSize)
	Dir=ExamineDirectory(#PB_Any,Common\ModulesPath,"*.dll")
	If IsDirectory(Dir)
		While NextDirectoryEntry(Dir)
			If DirectoryEntryType(Dir)=#PB_DirectoryEntry_File
				Name$=DirectoryEntryName(Dir)
				If Name$<>"." And Name$<>".."
					Name$=GetFileName(Name$)
					If Val(GetSettingsValue("modules/"+Name$+"/enabled","1"))
						Dll=OpenLibrary(#PB_Any,Common\ModulesPath+Name$+".dll")
						If IsLibrary(Dll)
							LoadOK=#False
							Function=GetFunction(Dll,"GetModuleInfo")
							If Function
								InfoData=CallFunctionFast(Function,@Common\MainPath)
								If InfoData
									InfoData$=PeekS(InfoData)
									AddElement(Modules())
									Modules()\Name=Name$
									Modules()\Dll=Dll
									WindowFlags=0
									WindowX=#PB_Ignore
									WindowY=#PB_Ignore
									WindowWidth=#PB_Ignore
									WindowHeight=#PB_Ignore
									For Line=1 To CountString(InfoData$,Chr(13))+1
										Line$=StringField(InfoData$,Line,Chr(13))
										Key$=Trim(StringField(Line$,1,"="))
										Value$=Trim(StringField(Line$,2,"="))
										If Key$ And Value$
											Select LCase(Key$)
												Case "title"
													Modules()\Title=Value$
												Case "windowflags"
													WindowFlags=Val(Value$)
												Case "windowposition"
													WindowX=Val(StringField(Value$,1,"x"))
													WindowY=Val(StringField(Value$,2,"x"))
												Case "windowsize"
													WindowWidth=Val(StringField(Value$,1,"x"))
													WindowHeight=Val(StringField(Value$,2,"x"))
											EndSelect
										EndIf
									Next
									Window=#FirstMDIWindow+ListIndex(Modules())
									IconFile$=Common\IconPath+Str(Config\IconSize\Window)+"\"+Modules()\Name+".ico"
									ImageID=0
									If IsFileEx(IconFile$)
										Icon=LoadImage(#PB_Any,IconFile$)
										If IsImage(Icon)
											ImageID=ImageID(Icon)
										EndIf
									EndIf
									AddGadgetItem(#MDI,Window,Modules()\Title,ImageID,#PB_Window_Invisible|#PB_Window_SystemMenu|WindowFlags)
									ResizeWindow(Window,WindowX,WindowY,WindowWidth,WindowHeight)
									Hide=#False
									Select LCase(GetSettingsValue("modules/"+Modules()\Name+"/windowstate",""))
										Case "hidden"
											Hide=#True
										Case "minimized"
											SetWindowState(Window,#PB_Window_Minimize)
										Case "normal"
											SetWindowState(Window,#PB_Window_Normal)
										Case "maximized"
											SetWindowState(Window,#PB_Window_Maximize);! Maximizing a MDI child window does not work
										Default
											Select LCase(Modules()\Name)
												Case "about","help","settings","updater"
													Hide=#True
											EndSelect
									EndSelect
									HideWindow(Window,Hide)
									Function=GetFunction(Dll,"OnModuleLoad")
									If Function
										CallFunctionFast(Function,WindowID(#Window),WindowID(Window),@Common\MainPath)
									EndIf
									Modules()\EventFunction=GetFunction(Dll,"OnEvent")
									MenuXML=LoadXMLEx(#PB_Any,Common\MainPath+"Menu\"+Modules()\Name+".xml")
									If IsXML(MenuXML)
										MainNode=MainXMLNode(MenuXML)
										ClassNode=ChildXMLNode(MainNode)
										While ClassNode
											If GetXMLNodeName(ClassNode)="class"
												AddElement(Modules()\Menu())
												Modules()\Menu()\ID=CreatePopupMenu(#PB_Any)
												Modules()\Menu()\Name=GetXMLAttribute(ClassNode,"name")
												XML2Menu(ChildXMLNode(ClassNode))
											EndIf
											ClassNode=NextXMLNode(ClassNode)
										Wend
										FreeXML(MenuXML)
									EndIf
									LoadOK=#True
								EndIf
							EndIf
							If Not LoadOK
								CloseLibrary(Dll)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Wend
		FinishDirectory(Dir)
	EndIf
	ForEach Modules()
		ForEach Modules()\Menu()
			ForEach Modules()\Menu()\Items()
				AddElement(DynamicXMLMenu())
				DynamicXMLMenu()\MenuItem=Modules()\Menu()\Items()\MenuItem
				DynamicXMLMenu()\MenuItemName=Modules()\Menu()\Items()\Name
				DynamicXMLMenu()\Menu=Modules()\Menu()\Name
				DynamicXMLMenu()\Module=Modules()\Name
			Next
		Next
	Next
	SetWindowCallback(@Callback(),#Window)
	RefreshMenu()
	HideWindow(#Window,#False)
	Repeat
		EventID=WaitWindowEvent(5)
		Event_Window=EventWindow()
		Event_ObjectID=EventGadget(); Returns the PureBasic #Object (Menu, Gadget, Window, etc.)
		Select Event_Window
			Case #Window
				Select EventID
					Case #PB_Event_Menu
						Select Event_ObjectID
							Case #Menu_Settings
								ActiveModuleWindow("Settings")
							Case #Menu_Quit
								Common\Quit=#True
							Case #Menu_Help
								ActiveModuleWindow("Help")
							Case #Menu_CheckForUpdates
								ActiveModuleWindow("Updater")
							Case #Menu_About
								ActiveModuleWindow("About")
							Default
								If Event_ObjectID>=#FirstMDIWindow And Event_ObjectID<=#FirstMDIWindow+ListSize(Modules())
									ActivateMDIChild(Event_ObjectID)
								EndIf
								If Event_ObjectID>=#FirstXMLMenuItem And Event_ObjectID<=#FirstXMLMenuItem+ListSize(DynamicXMLMenu())
									SelectElement(DynamicXMLMenu(),Event_ObjectID-#FirstXMLMenuItem)
									ForEach Modules()
										If LCase(Modules()\Name)=LCase(DynamicXMLMenu()\Module)
											Function=GetFunction(Modules()\Dll,"OnMenuEvent")
											If Function
												CallFunctionFast(Function,@DynamicXMLMenu()\Menu,@DynamicXMLMenu()\MenuItemName)
											EndIf
											Break
										EndIf
									Next
								EndIf
						EndSelect
					Case #PB_Event_CloseWindow
						Common\Quit=#True
				EndSelect
			Default
				ForEach Modules()
					If #FirstMDIWindow+ListIndex(Modules())=Event_Window
						SendEvent=#False
						Select EventID
							Case #PB_Event_Menu
								If Event_ObjectID>=#FirstMDIWindow And Event_ObjectID<=#FirstMDIWindow+ListSize(Modules())
									ActivateMDIChild(Event_ObjectID)
								Else
									SendEvent=#True
								EndIf
							Case #PB_Event_CloseWindow
								SetWindowState(Event_Window,#PB_Window_Normal)
								HideWindow(Event_Window,#True)
							Default
								SendEvent=#True
						EndSelect
						If SendEvent And IsLibrary(Modules()\Dll) And Modules()\EventFunction
							CallFunctionFast(Modules()\EventFunction,EventID,Event_ObjectID)
						EndIf
						Break
					EndIf
				Next
		EndSelect
	Until Common\Quit
	ForEach Modules()
		If IsLibrary(Modules()\Dll)
			WindowState$=""
			If IsWindowVisible_(WindowID(#FirstMDIWindow+ListIndex(Modules())))
				Select GetWindowState(#FirstMDIWindow+ListIndex(Modules()))
					Case #PB_Window_Minimize
						WindowState$="minimized"
					Case #PB_Window_Normal
						WindowState$="normal"
					Case #PB_Window_Maximize
						WindowState$="maximized"
				EndSelect
			Else
				WindowState$="hidden"
			EndIf
			SetSettingsValue("modules/"+Modules()\Name+"/windowstate",WindowState$)
			Function=GetFunction(Modules()\Dll,"OnModuleUnload")
			If Function
				CallFunctionFast(Function)
			EndIf
		EndIf
	Next
	ForEach Modules()
		If IsLibrary(Modules()\Dll)
			CloseWindow(#FirstMDIWindow+ListIndex(Modules()))
			CloseLibrary(Modules()\Dll)
		EndIf
	Next
	SaveSettings()
EndIf
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 429
; FirstLine = 424
; Folding = --
; EnableXP
; UseIcon = GTATB.ico
; Executable = ..\GTA_SA_ToolBox.exe
; EnableCompileCount = 575
; EnableBuildCount = 84
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0
; VersionField6 = GTA San Andreas ToolBox
; VersionField7 = GTA San Andreas ToolBox
; VersionField8 = %EXECUTABLE
; VersionField9 = © 2011 SelfCoders
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_APP
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT