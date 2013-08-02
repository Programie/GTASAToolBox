Enumeration
 #RunOnlyOnceCheckWindow
 #Window
 #Tray
 #Run_GUI
 #Run_CheatProcessor
 #Run_MemoryServer
 #Run_WebServer
 #Run_GTA
 #Quit
 #FirstCustomMenuItem
EndEnumeration

Structure Config
 Language.l
 DisableGTASplash.b
 Menu_SubMenu.l
 Menu_Item.l
EndStructure

Structure MenuToken
 SearchString.s
 ReplaceString.s
EndStructure

Structure Menu
 Item.l
 File.s
 Parameter.s
EndStructure

#MaxLang=8

Global Config.Config
Global Dim Language.s(#MaxLang)
Global NewList MenuToken.MenuToken()
Global NewList Menu.Menu()

IncludeFile "Common.pbi"

Procedure CheckApp(Module,MenuItem)
 If IsModuleRunning(Module)
  SetMenuItemState(#Tray,MenuItem,1)
 Else
  SetMenuItemState(#Tray,MenuItem,0)
 EndIf
EndProcedure

Procedure RunCommand(CMD$,Parameter$="")
 Select LCase(Trim(CMD$))
  Case "cheatprocessor"
   If IsModuleRunning(#Module_CheatProcessor)
    SendMessage(#Module_CheatProcessor,#Module_CMD_Quit)
   Else
    RunProgram(Common\InstallPath+"CheatProcessor.exe","",Common\InstallPath)
   EndIf
  Case "gta"
   If FindWindow_(0,#GTA_Title)
    MessageRequester(Language(0),Language(6),#MB_ICONERROR)
   Else
    RunProgram(Common\InstallPath+"GTA ToolBox.exe","/rungta",Common\InstallPath)
   EndIf
  Case "gui"
   If IsModuleRunning(#Module_GUI)
    MessageRequester(Language(0),Language(5),#MB_ICONERROR)
   Else
    RunProgram(Common\InstallPath+"GTA ToolBox.exe","",Common\InstallPath)
   EndIf
  Case "memoryserver"
   If IsModuleRunning(#Module_MemoryServer)
    SendMessage(#Module_MemoryServer,#Module_CMD_Quit)
   Else
    RunProgram(Common\InstallPath+"MemoryServer.exe","",Common\InstallPath)
   EndIf
  Case "webserver"
   If IsModuleRunning(#Module_WebServer)
    SendMessage(#Module_WebServer,#Module_CMD_Quit)
   Else
    RunProgram(Common\InstallPath+"WebServer.exe","",Common\InstallPath)
   EndIf
  Default
   If IsFileEx(CMD$)
    RunProgram(CMD$,Parameter$,GetPathPart(CMD$))
   Else
    MessageRequester(Language(0),ReplaceString(Language(4),"%1",GetFilePart(CMD$),1),#MB_ICONERROR)
   EndIf
 EndSelect
EndProcedure

Procedure LoadSettings()
 OpenPreferences(Common\InstallPath+"Settings.ini")
  PreferenceGroup("Global")
   Config\Language=ReadPreferenceLong("Language",#LANG_GERMAN)
   Config\DisableGTASplash=ReadPreferenceLong("DisableGTASplash",0)
 ClosePreferences()
EndProcedure

Procedure WindowCallback(WindowID,Message,wParam,lParam)
 Select Message
  Case Common\ExplorerMsg
   If IsSysTrayIcon(#Tray)
    RemoveSysTrayIcon(#Tray)
   EndIf
   If AddSysTrayIcon(#Tray,WindowID(#Window),CatchImage(#Tray,?Tray))
    SysTrayIconToolTip(#Tray,GetWindowTitle(#Window))
   EndIf
 EndSelect
 ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure AddTag(Tag$,Value$)
 ForEach MenuToken()
  If LCase(Trim(MenuToken()\SearchString))=Trim(Tag$)
   IsTag=1
   Break
  EndIf
 Next
 If IsTag=0
  AddElement(MenuToken())
  MenuToken()\SearchString=Trim(Tag$)
 EndIf
 MenuToken()\ReplaceString=Trim(Value$)
EndProcedure

Procedure.s ParseString(String$)
 ForEach MenuToken()
  String$=ReplaceString(String$,MenuToken()\SearchString,MenuToken()\ReplaceString,1)
 Next
 For Hex=1 To CountString(LCase(String$),"/0x")
  Start=FindString(LCase(String$),"/0x",Start+1)
   If Start
    Hex$=Mid(String$,Start+3,2)
    String$=ReplaceString(String$,"/0x"+Hex$,Chr(Hex2Dec(Trim(Hex$))),1)
   Else
    Break
   EndIf
 Next
 ProcedureReturn String$
EndProcedure

Procedure ParseXMLMenu(Node,SubMenu)
 If Node
  SubMenuOld2=Config\Menu_SubMenu
  For Menu=1 To SubMenuOld2
   If SubMenu<Config\Menu_SubMenu
    CloseSubMenu()
    Config\Menu_SubMenu-1
   EndIf
  Next
  If XMLNodeType(Node)=#PB_XML_Normal
   Select LCase(Trim(GetXMLNodeName(Node)))
    Case "xml"
    Case "define"
     AddTag(GetXMLAttribute(Node,"tag"),ParseString(GetXMLNodeText(Node)))
    Case "submenu"
     OpenSubMenu(ParseString(GetXMLAttribute(Node,"name")))
     IsSubmenu=1
    Case "item"
     MenuItemName$=ParseString(GetXMLNodeText(Node))
     File$=ParseString(GetXMLAttribute(Node,"file"))
     Parameter$=ParseString(GetXMLAttribute(Node,"parameter"))
     Select LCase(Trim(File$))
      Case "cheatprocessor"
       MenuItem(#Run_CheatProcessor,MenuItemName$)
      Case "gta"
       MenuItem(#Run_GTA,MenuItemName$)
      Case "gui"
       MenuItem(#Run_GUI,MenuItemName$)
      Case "memoryserver"
       MenuItem(#Run_MemoryServer,MenuItemName$)
      Case "quit"
       MenuItem(#Quit,MenuItemName$)
      Case "webserver"
       MenuItem(#Run_WebServer,MenuItemName$)
      Default
       MenuItem(Config\Menu_Item,MenuItemName$)
       AddElement(Menu())
       Menu()\Item=Config\Menu_Item
       Menu()\File=File$
       Menu()\Parameter=Parameter$
       Config\Menu_Item+1
     EndSelect
    Case "menubar"
     MenuBar()
   EndSelect
  EndIf
  Config\Menu_SubMenu=SubMenu
  ChildNode=ChildXMLNode(Node)
   While ChildNode<>0
    If IsSubmenu
     NewNode=SubMenu+1
    Else
     NewNode=SubMenu
    EndIf
    ParseXMLMenu(ChildNode,NewNode)
    ChildNode=NextXMLNode(ChildNode)
   Wend
 EndIf
EndProcedure

Procedure ParseStartupXML(Node)
 If Node
  If XMLNodeType(Node)=#PB_XML_Normal
   Select LCase(Trim(GetXMLNodeName(Node)))
    Case "define"
     AddTag(GetXMLAttribute(Node,"tag"),ParseString(GetXMLNodeText(Node)))
    Case "startup"
     RunCommand(ParseString(GetXMLAttribute(Node,"file")),ParseString(GetXMLAttribute(Node,"parameter")))
   EndSelect
  EndIf
  ChildNode=ChildXMLNode(Node)
   While ChildNode<>0
    ParseStartupXML(ChildNode)
    ChildNode=NextXMLNode(ChildNode)
   Wend
 EndIf
EndProcedure

SetCurrentDirectory(Common\InstallPath)
LoadSettings()

Select Config\Language
 Case #LANG_ENGLISH
  Restore Language_English
 Case #LANG_GERMAN
  Restore Language_German
EndSelect

For Lang=0 To #MaxLang
 Read.s Language(Lang)
Next

If IsModuleRunning(#Module_SpeedLauncher)
 MessageRequester(Language(0),Language(1),#MB_ICONERROR)
 End
EndIf
OpenWindow(#RunOnlyOnceCheckWindow,0,0,0,0,#RunOnlyOnceTitle_SpeedLauncher,#PB_Window_Invisible)

AddTag("%Language_Quit%",Language(2))

XML=LoadXML(#PB_Any,Common\InstallPath+"SpeedLauncher.xml")
 If IsXML(XML)
  If XMLStatus(XML)=#PB_XML_Success
   Node=MainXMLNode(XML)
    If Node
     ParseStartupXML(Node)
    EndIf
  Else
   MessageRequester(Language(0),Language(8),#MB_ICONERROR)
   Error=1
  EndIf
  FreeXML(XML)
 Else
  MessageRequester(Language(0),Language(7),#MB_ICONERROR)
  Error=1
 EndIf

If OpenWindow(#Window,0,0,0,0,"GTA San Andreas ToolBox SpeedLauncher",#PB_Window_Invisible)
 If AddSysTrayIcon(#Tray,WindowID(#Window),CatchImage(#Tray,?Tray))
  SysTrayIconToolTip(#Tray,GetWindowTitle(#Window))
 EndIf
 SetWindowCallback(@WindowCallback())
 Repeat
  Title$=GetWindowTitle(#RunOnlyOnceCheckWindow)
  Title$=Trim(Right(Title$,Len(Title$)-Len(#RunOnlyOnceTitle_SpeedLauncher)))
   If Title$
    Select Title$
     Case #Module_CMD_Quit
      Quit=1
    EndSelect
    SetWindowTitle(#RunOnlyOnceCheckWindow,#RunOnlyOnceTitle_SpeedLauncher)
   EndIf
  Select WaitWindowEvent(5)
   Case #PB_Event_Menu
    MenuItem=EventMenu()
     Select MenuItem
      Case #Run_CheatProcessor
       RunCommand("cheatprocessor")
      Case #Run_GTA
       RunCommand("gta")
      Case #Run_GUI
       RunCommand("gui")
      Case #Run_MemoryServer
       RunCommand("memoryserver")
      Case #Run_WebServer
       RunCommand("webserver")
      Case #Quit
       Quit=1
      Default
       ForEach Menu()
        If Menu()\Item=MenuItem
         RunCommand(Menu()\File,Menu()\Parameter)
        EndIf
       Next
     EndSelect
   Case #PB_Event_SysTray
    Error=0
    ClearList(Menu())
    Config\Menu_Item=#FirstCustomMenuItem
    If CreatePopupMenu(#Tray)
     XML=LoadXML(#PB_Any,Common\InstallPath+"SpeedLauncher.xml")
      If IsXML(XML)
       If XMLStatus(XML)=#PB_XML_Success
        Node=MainXMLNode(XML)
         If Node
          ParseXMLMenu(Node,0)
         EndIf
       Else
        MessageRequester(Language(0),Language(8),#MB_ICONERROR)
        Error=1
       EndIf
       FreeXML(XML)
      Else
       MessageRequester(Language(0),Language(7),#MB_ICONERROR)
       Error=1
      EndIf
    EndIf
    If Error=0
     CheckApp(#Module_GUI,#Run_GUI)
     CheckApp(#Module_CheatProcessor,#Run_CheatProcessor)
     CheckApp(#Module_MemoryServer,#Run_MemoryServer)
     CheckApp(#Module_WebServer,#Run_WebServer)
     If FindWindow_(0,#GTA_Title)
      SetMenuItemState(#Tray,#Run_GTA,1)
     Else
      SetMenuItemState(#Tray,#Run_GTA,0)
     EndIf
     DisplayPopupMenu(#Tray,WindowID(#Window))
    EndIf
  EndSelect
 Until Quit
EndIf

DataSection
 Tray:
  IncludeBinary "SpeedLauncher.ico"
 Language_English:
  Data$ "Error"; 0
  Data$ "SpeedLauncher was allready started!"; 1
  Data$ "Quit"; 2
  Data$ "GTA San Andreas was allready started!<br>Do you want to bring it to the foreground?"; 3
  Data$ "The file '%1' was not found!"; 4
  Data$ "The GTA San Andreas ToolBox GUI was allready started!"; 5
  Data$ "GTA San Andreas was allready started!"; 6
  Data$ "There wasn´t found a menuconfiguration!"; 7
  Data$ "There are errors in the menuconfiguration!"; 8
 Language_German:
  Data$ "Fehler"; 0
  Data$ "SpeedLauncher wurde bereits gestartet!"; 1
  Data$ "Beenden"; 2
  Data$ "GTA San Andreas wurde bereits gestartet<br>Soll es in den Vordergrund gebracht werden?"; 3
  Data$ "Die Datei '%1' wurde nicht gefunden!"; 4
  Data$ "Die GTA San Andreas ToolBox GUI wurde bereits gestartet!"; 5
  Data$ "GTA San Andreas wurde bereits gestartet!"; 6
  Data$ "Es wurde keine Menükonfiguration gefunden!"; 7
  Data$ "Es befinden sich Fehler in der Menükonfiguration!"; 8
EndDataSection