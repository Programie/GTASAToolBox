Enumeration
 #Window
 #Menu
 #ConnectTo
 #GetMemoryList
 #Quit
 #English
 #German
 #Help
 #About
 #Remove
 #Text1
 #State
 #EditContainer
 #Text2
 #Text3
 #Text4
 #Text5
 #Name
 #Address
 #DataType
 #Value
 #Add
 #Set
 #Read
 #Write
 #List
 #ConnectTo_Window
 #ConnectTo_Text1
 #ConnectTo_Text2
 #ConnectTo_IP
 #ConnectTo_Port
 #ConnectTo_OK
 #ConnectTo_Cancel
EndEnumeration

Enumeration
 #Font_Bold
EndEnumeration

#MaxLang=36

Structure Config
 Language.l
 ConnectionID.l
 IP.s
 Port.l
 StateChanged.b
 SpeedTest_StartTime.l
 SpeedTest_Delay.l
EndStructure

Global Config.Config
Global Dim Language.s(#MaxLang)
Global NewList LastIP.s()

IncludeFile "Common.pbi"

Procedure ReloadLanguage()
 Select Config\Language
  Case #LANG_ENGLISH
   Restore Language_English
  Case #LANG_GERMAN
   Restore Language_German
 EndSelect
 For Lang=0 To #MaxLang
  Read.s Language(Lang)
 Next
 If CreateMenu(#Menu,WindowID(#Window))
  MenuTitle(Language(0))
   MenuItem(#ConnectTo,Language(1)+Chr(9)+"Alt+C")
    MenuBar()
   MenuItem(#GetMemoryList,Language(30))
    MenuBar()
   MenuItem(#Quit,Language(2)+Chr(9)+"Alt+F4")
  MenuTitle(Language(3))
   MenuItem(#English,Language(4))
   MenuItem(#German,Language(5))
  MenuTitle(Language(6))
   MenuItem(#Help,Language(6)+Chr(9)+"F1")
    MenuBar()
   MenuItem(#About,Language(7)+Chr(9)+"Alt+F1")
 EndIf
 Select Config\Language
  Case #LANG_ENGLISH
   SetMenuItemState(#Menu,#English,1)
  Case #LANG_GERMAN
   SetMenuItemState(#Menu,#German,1)
 EndSelect
 SetGadgetText(#Text3,Language(18)+":")
 SetGadgetText(#Text4,Language(19)+":")
 SetGadgetText(#Text5,Language(20)+":")
 SetGadgetText(#Add,Language(21))
 SetGadgetText(#Set,Language(22))
 SetGadgetText(#Read,Language(23))
 SetGadgetText(#Write,Language(24))
 SetGadgetItemText(#List,-1,Language(18),1)
 SetGadgetItemText(#List,-1,Language(19),2)
 SetGadgetItemText(#List,-1,Language(20),3)
 Config\StateChanged=1
EndProcedure

Procedure ConnectTo()
 For Gadget=#ConnectTo_Text1 To #ConnectTo_Cancel
  DisableGadget(Gadget,1)
 Next
 If Config\ConnectionID
  CloseNetworkConnection(Config\ConnectionID)
 EndIf
 IP$=Trim(GetGadgetText(#ConnectTo_IP))
 Port=Val(Trim(GetGadgetText(#ConnectTo_Port)))
  If IP$ And Port>0
   ID=OpenNetworkConnection(IP$,Port)
    If ID
     Repeat
      Delay(1)
      WindowEvent()
      If NetworkClientEvent(ID)=#PB_NetworkEvent_Data
       ReceiveNetworkData(ID,@VersionTest,4)
       If VersionTest=#MemoryNetwork_VersionTest
        ForEach LastIP()
         If LCase(LastIP())=LCase(IP$)
          DeleteElement(LastIP())
          Break
         EndIf
        Next
        SelectElement(LastIP(),0)
        InsertElement(LastIP())
        LastIP()=IP$
        File=CreateFile(#PB_Any,Common\InstallPath+"LastIP.cfg")
         If IsFile(File)
          ForEach LastIP()
           WriteStringN(File,LastIP())
          Next
          CloseFile(File)
         EndIf
        Config\ConnectionID=ID
        Config\IP=IP$
        Config\Port=Port
        Config\StateChanged=1
        CloseWindow(#ConnectTo_Window)
        DisableWindow(#Window,0)
        Valid=1
       Else
        Valid=-1
       EndIf
      EndIf
      Timeout+1
     Until Timeout=>5000 Or Valid
     If Valid<1
      MessageRequester(Language(12),ReplaceString(Language(17),"%1",IP$+":"+Str(Port),1),#MB_ICONERROR)
     EndIf
    Else
     MessageRequester(Language(12),ReplaceString(Language(11),"%1",IP$+":"+Str(Port),1),#MB_ICONERROR)
    EndIf
  EndIf
 If IsWindow(#ConnectTo_Window)
  For Gadget=#ConnectTo_Text1 To #ConnectTo_Cancel
   DisableGadget(Gadget,0)
  Next
  SetGadgetText(#ConnectTo_OK,"OK")
 EndIf
EndProcedure

OpenPreferences(Common\PrefsFile)
 PreferenceGroup("Global")
  Config\Language=ReadPreferenceLong("Language",#LANG_GERMAN)
 PreferenceGroup("MemoryNetwork")
  Config\IP=ReadPreferenceString("LastIP","Localhost")
  Config\Port=ReadPreferenceLong("Port",#MemoryNetwork_DefaultPort)
ClosePreferences()

Config\StateChanged=1
InitNetwork()

LoadFont(#Font_Bold,"Arial",12,#PB_Font_Bold)

File=ReadFile(#PB_Any,Common\InstallPath+"LastIP.cfg")
 If IsFile(File)
  Repeat
   IP$=Trim(ReadString(File))
    If IP$
     AddElement(LastIP())
     LastIP()=IP$
    EndIf
  Until Eof(File)
  CloseFile(File)
 EndIf

If OpenWindow(#Window,100,100,600,400,"GTA San Andreas ToolBox MemoryClient",#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered)
 TextGadget(#Text1,10,10,50,20,"Status:")
 StringGadget(#State,70,10,WindowWidth(#Window)-80,20,Language(13),#PB_String_ReadOnly|#PB_String_BorderLess)
 ContainerGadget(#EditContainer,0,40,WindowWidth(#Window),130,#PB_Container_Flat)
  TextGadget(#Text2,10,10,50,20,"Name:")
  TextGadget(#Text3,10,40,50,20,Language(18)+":")
  TextGadget(#Text4,10,70,50,20,Language(19)+":")
  TextGadget(#Text5,10,100,50,20,Language(20)+":")
  StringGadget(#Name,70,10,GadgetWidth(#EditContainer)-80,20,"")
  StringGadget(#Address,70,40,GadgetWidth(#EditContainer)-80,20,"",#PB_String_UpperCase)
  ComboBoxGadget(#DataType,70,70,GadgetWidth(#EditContainer)-80,20)
  StringGadget(#Value,70,100,GadgetWidth(#EditContainer)-80,20,"")
  For DataType=#PB_Byte To #PB_Character
   Name$=DataType(DataType,1)
   Size=Val(DataType(DataType,2))
   If Size
    Name$+" ("+Str(Size)+" Byte)"
   EndIf
   AddGadgetItem(#DataType,-1,Name$)
  Next
 CloseGadgetList()
 ButtonGadget(#Add,0,GadgetHeight(#EditContainer)+40,WindowWidth(#Window)/4,30,Language(21))
 ButtonGadget(#Set,GadgetWidth(#Add),GadgetY(#Add),GadgetWidth(#Add),30,Language(22))
 ButtonGadget(#Read,GadgetWidth(#Add)*2,GadgetY(#Add),GadgetWidth(#Add),30,Language(23))
 ButtonGadget(#Write,GadgetWidth(#Add)*3,GadgetY(#Add),GadgetWidth(#Add),30,Language(24))
 ListIconGadget(#List,0,GadgetY(#Add)+30,WindowWidth(#Window),WindowHeight(#Window)-GadgetY(#Add)-MenuHeight()-30,"Name",200,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
  AddGadgetColumn(#List,1,Language(18),100)
  AddGadgetColumn(#List,2,Language(19),200)
  AddGadgetColumn(#List,3,Language(20),200)
 ReloadLanguage()
 AddKeyboardShortcut(#Window,#PB_Shortcut_Alt|#PB_Shortcut_C,#ConnectTo)
 AddKeyboardShortcut(#Window,#PB_Shortcut_Alt|#PB_Shortcut_F4,#Quit)
 AddKeyboardShortcut(#Window,#PB_Shortcut_F1,#Help)
 AddKeyboardShortcut(#Window,#PB_Shortcut_Alt|#PB_Shortcut_F1,#About)
 AddKeyboardShortcut(#Window,#PB_Shortcut_Delete,#Remove)
 SetGadgetState(#DataType,0)
 SetGadgetData(#Set,-1)
 DisableGadget(#Add,1)
 DisableGadget(#Set,1)
 SetGadgetFont(#State,FontID(#Font_Bold))
 File=ReadFile(#PB_Any,Common\InstallPath+"MemoryChanger.dat")
  If IsFile(File)
   Repeat
    Name$=Trim(ReadString(File))
     If Name$
      Address=ReadLong(File)
      DataType=ReadByte(File)
      AddGadgetItem(#List,-1,Name$+Chr(10)+Hex(Address)+Chr(10)+DataType(DataType,1))
      SetGadgetItemData(#List,CountGadgetItems(#List)-1,DataType)
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
 Repeat
  If Config\StateChanged
   Config\StateChanged=0
   If Config\ConnectionID
    SetGadgetText(#State,ReplaceString(ReplaceString(Language(14),"%1",Config\IP+":"+Str(Config\Port),1),"%2",Str(Config\SpeedTest_Delay),1))
    DisableGadget(#Read,0)
    If Trim(GetGadgetText(#Address))
     DisableGadget(#Write,0)
    Else
     DisableGadget(#Write,1)
    EndIf
   Else
    SetGadgetText(#State,Language(13))
    DisableGadget(#Read,1)
    DisableGadget(#Write,1)
   EndIf
  EndIf
  Select WaitWindowEvent(5)
   Case #PB_Event_Menu
    Select EventMenu()
     Case #ConnectTo
      If OpenWindow(#ConnectTo_Window,100,100,330,110,Language(1),#PB_Window_WindowCentered,WindowID(#Window))
       TextGadget(#ConnectTo_Text1,10,10,100,20,Language(8)+":")
       TextGadget(#ConnectTo_Text2,10,40,100,20,"Port:")
       ComboBoxGadget(#ConnectTo_IP,120,10,200,20,#PB_ComboBox_Editable)
       StringGadget(#ConnectTo_Port,120,40,200,20,Str(Config\Port),#PB_String_Numeric)
       ButtonGadget(#ConnectTo_OK,60,70,100,30,"OK")
       ButtonGadget(#ConnectTo_Cancel,170,70,100,30,Language(9))
       ForEach LastIP()
        AddGadgetItem(#ConnectTo_IP,-1,LastIP())
       Next
       SetGadgetText(#ConnectTo_IP,Config\IP)
       DisableWindow(#Window,1)
       AddKeyboardShortcut(#ConnectTo_Window,#PB_Shortcut_Return,#ConnectTo_OK)
       AddKeyboardShortcut(#ConnectTo_Window,#PB_Shortcut_Escape,#ConnectTo_Cancel)
       If Config\IP="" Or Config\Port<=0
        DisableGadget(#ConnectTo_OK,1)
       EndIf
      EndIf
     Case #GetMemoryList
      If Config\ConnectionID
       If MessageRequester(Language(30),ReplaceString(Language(31),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
        Command=#Network_GetMemoryListFile
        SendNetworkData(Config\ConnectionID,@Command,4)
        Timeout=0
        Repeat
         Delay(1)
         Timeout+1
         Select NetworkClientEvent(Config\ConnectionID)
          Case #PB_NetworkEvent_File
           ReceiveNetworkFile(Config\ConnectionID,Common\InstallPath+"MemoryChanger.tmp")
           ClearGadgetItems(#List)
           File=ReadFile(#PB_Any,Common\InstallPath+"MemoryChanger.tmp")
            If IsFile(File)
             Repeat
              Name$=Trim(ReadString(File))
               If Name$
                Address=ReadLong(File)
                DataType=ReadByte(File)
                AddGadgetItem(#List,-1,Name$+Chr(10)+Hex(Address)+Chr(10)+DataType(DataType,1))
                SetGadgetItemData(#List,CountGadgetItems(#List)-1,DataType)
               EndIf
             Until Eof(File)
             CloseFile(File)
            EndIf
           DeleteFile(Common\InstallPath+"MemoryChanger.tmp")
           Timeout=-1
          Case #PB_NetworkEvent_Data
           ReceiveNetworkData(Config\ConnectionID,@Result,4)
           Select Result
            Case -1
             MessageRequester(Language(12),Language(34),#MB_ICONERROR)
            Case -2
             MessageRequester(Language(12),Language(35),#MB_ICONERROR)
            Default
             MessageRequester(Language(12),Language(33),#MB_ICONERROR)
           EndSelect
           Timeout=-1
         EndSelect
        Until Timeout=>5000 Or Timeout=-1
        If Timeout>0
         MessageRequester(Language(12),Language(27),#MB_ICONERROR)
        EndIf
       EndIf
      Else
       MessageRequester(Language(12),Language(32),#MB_ICONERROR)
      EndIf
     Case #Quit
      Quit=1
     Case #English
      Config\Language=#LANG_ENGLISH
      ReloadLanguage()
     Case #German
      Config\Language=#LANG_GERMAN
      ReloadLanguage()
     Case #Help
      MessageRequester("Information",Language(16),#MB_ICONINFORMATION)
     Case #About
      MessageRequester(Language(7),Language(15),#MB_ICONQUESTION)
     Case #Remove
      Item=GetGadgetState(#List)
       If Item<>-1
        If MessageRequester(Language(25),ReplaceString(Language(26),"%1",GetGadgetItemText(#List,Item,0),1),#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
         RemoveGadgetItem(#List,Item)
         SetGadgetData(#Set,-1)
         DisableGadget(#Set,1)
        EndIf
       EndIf
     Case #ConnectTo_OK
      If Trim(GetGadgetText(#ConnectTo_IP)) And Val(Trim(GetGadgetText(#ConnectTo_Port)))>0
       ConnectTo()
      EndIf
     Case #ConnectTo_Cancel
      CloseWindow(#ConnectTo_Window)
      DisableWindow(#Window,0)
    EndSelect
   Case #PB_Event_Gadget
    Select EventGadget()
     Case #Name,#Address
      Select EventType()
       Case #PB_EventType_Change
        SendMessage_(GadgetID(#Address),#EM_GETSEL,@Pos1,@Pos2)
        SetGadgetText(#Address,IsValidString(GetGadgetText(#Address),"ABCDEF0123456789",1))
        SendMessage_(GadgetID(#Address),#EM_SETSEL,Pos1,Pos2)
      EndSelect
      If Config\ConnectionID
       If Trim(GetGadgetText(#Address))
        DisableGadget(#Write,0)
       Else
        DisableGadget(#Write,1)
       EndIf
      Else
       DisableGadget(#Write,1)
      EndIf
      If Trim(GetGadgetText(#Name)) And Trim(GetGadgetText(#Address))
       DisableGadget(#Add,0)
       If GetGadgetData(#Set)<>-1
        DisableGadget(#Set,0)
       Else
        DisableGadget(#Set,1)
       EndIf
      Else
       DisableGadget(#Add,1)
       DisableGadget(#Set,1)
      EndIf
     Case #Add
      DataType=GetGadgetState(#DataType)
      AddGadgetItem(#List,-1,GetGadgetText(#Name)+Chr(10)+GetGadgetText(#Address)+Chr(10)+DataType(DataType,1))
      SetGadgetItemData(#List,CountGadgetItems(#List)-1,DataType)
     Case #Set
      Item=GetGadgetData(#Set)
       If Item<>-1
        DataType=GetGadgetState(#DataType)
        SetGadgetItemText(#List,Item,GetGadgetText(#Name),0)
        SetGadgetItemText(#List,Item,GetGadgetText(#Address),1)
        SetGadgetItemText(#List,Item,DataType(DataType,1),2)
        SetGadgetItemData(#List,Item,DataType)
       EndIf
     Case #Read
      Config\SpeedTest_StartTime=ElapsedMilliseconds()
      Buffer=AllocateMemory(12)
       If Buffer
        PokeL(Buffer,#Network_ReadAddress)
        For Item=0 To CountGadgetItems(#List)-1
         DataType=GetGadgetItemData(#List,Item)
         Size=Val(DataType(DataType,2))
         PokeL(Buffer+4,Hex2Dec(Trim(GetGadgetItemText(#List,Item,1))))
         PokeL(Buffer+8,Size)
         SendNetworkData(Config\ConnectionID,Buffer,12)
         If Size
          Memory=AllocateMemory(Size+4)
         Else
          Memory=0
         EndIf
         If Memory
          Timeout=0
          Repeat
           Delay(1)
           Timeout+1
           If NetworkClientEvent(Config\ConnectionID)=#PB_NetworkEvent_Data
            ReceiveNetworkData(Config\ConnectionID,Memory,Size+4)
            Select PeekL(Memory)
             Case #Network_ReadAddress
              Timeout=-1
             Case #Network_Error_GTASANotFound
              Timeout=-2
            EndSelect
           EndIf
          Until Timeout=>5000 Or Timeout<0
          If Timeout>0
           FreeMemory(Memory)
           MessageRequester(Language(12),Language(27),#MB_ICONERROR)
           Break
          ElseIf Timeout=-2
           FreeMemory(Memory)
           MessageRequester(Language(12),Language(36),#MB_ICONERROR)
           Break
          EndIf
          Select DataType
           Case #PB_Byte
            Value$=Str(PeekB(Memory))
           Case #PB_Word
            Value$=Str(PeekW(Memory))
           Case #PB_Long
            Value$=Str(PeekL(Memory))
           Case #PB_Float
            Value$=StrF(PeekF(Memory))
           Case #PB_Quad
            Value$=StrD(PeekQ(Memory))
           Case #PB_String
            Value$=PeekS(Memory)
           Case #PB_Double
            Value$=StrD(PeekD(Memory))
           Case #PB_Character
            Value$=Str(PeekC(Memory))
          EndSelect
          FreeMemory(Memory)
          SetGadgetItemText(#List,Item,Value$,3)
         EndIf
        Next
        FreeMemory(Buffer)
       EndIf
      Config\SpeedTest_Delay=ElapsedMilliseconds()-Config\SpeedTest_StartTime
      Config\StateChanged=1
     Case #Write
      Address=Hex2Dec(Trim(GetGadgetText(#Address)))
       If Address
        DataType=GetGadgetState(#DataType)
        Value$=GetGadgetText(#Value)
        If DataType=#PB_String
         Size=Len(Value$)+1
        Else
         Size=Val(DataType(DataType,2))
        EndIf
        Buffer=AllocateMemory(Size+12)
         If Buffer
          PokeL(Buffer,#Network_WriteAddress)
          PokeL(Buffer+4,Address)
          PokeL(Buffer+8,Size)
          Send=0
          Select DataType
           Case #PB_Byte,#PB_Word,#PB_Character,#PB_Long
            If IsValidString(Trim(Value$),"-+0123456789")=Trim(Value$)
             Select DataType
              Case #PB_Byte
               PokeB(Buffer+12,Val(Value$))
              Case #PB_Word
               PokeW(Buffer+12,Val(Value$))
              Case #PB_Character
               PokeC(Buffer+12,Val(Value$))
              Case #PB_Long
               PokeL(Buffer+12,Val(Value$))
             EndSelect
             Send=1
            Else
             MessageRequester(Language(12),ReplaceString(Language(28),"%1",DataType(DataType,1),1),#MB_ICONERROR)
            EndIf
           Case #PB_Float,#PB_Double,#PB_Quad
            If IsValidString(Trim(Value$),"-+0123456789.")=Trim(Value$)
             Select DataType
              Case #PB_Float
               PokeF(Buffer+12,ValF(Value$))
              Case #PB_Double
               PokeD(Buffer+12,ValD(Value$))
              Case #PB_Quad
               PokeQ(Buffer+12,ValD(Value$))
             EndSelect
             Send=1
            Else
             MessageRequester(Language(12),ReplaceString(Language(28),"%1",DataType(DataType,1),1),#MB_ICONERROR)
            EndIf
           Case #PB_String
            PokeL(Buffer+8,Len(Value$)+1)
            PokeS(Buffer+12,Value$)
            Send=1
           Default
            MessageRequester(Language(12),Language(29),#MB_ICONERROR)
          EndSelect
          If Send
           SendNetworkData(Config\ConnectionID,Buffer,Size+12)
           Timeout=0
           Repeat
            Delay(1)
            Timeout+1
            If NetworkClientEvent(Config\ConnectionID)=#PB_NetworkEvent_Data
             ReceiveNetworkData(Config\ConnectionID,@Result,4)
             Select Result
              Case #Network_WriteAddress
               Timeout=-1
              Case #Network_Error_GTASANotFound
               Timeout=-2
             EndSelect
            EndIf
           Until Timeout=>5000 Or Timeout<0
           If Timeout>0
            MessageRequester(Language(12),Language(27),#MB_ICONERROR)
           ElseIf Timeout=-2
            MessageRequester(Language(12),Language(36),#MB_ICONERROR)
           EndIf
          EndIf
          FreeMemory(Buffer)
         EndIf
       EndIf
      Config\StateChanged=1
     Case #List
      Select EventType()
       Case #PB_EventType_LeftDoubleClick
        Item=GetGadgetState(#List)
         If Item<>-1
          SetGadgetData(#Set,Item)
          SetGadgetText(#Name,GetGadgetItemText(#List,Item,0))
          SetGadgetText(#Address,GetGadgetItemText(#List,Item,1))
          SetGadgetState(#DataType,GetGadgetItemData(#List,Item))
          SetGadgetText(#Value,GetGadgetItemText(#List,Item,3))
          DisableGadget(#Add,0)
          DisableGadget(#Set,0)
         EndIf
      EndSelect
     Case #ConnectTo_IP,#ConnectTo_Port
      If Trim(GetGadgetText(#ConnectTo_IP)) And Val(Trim(GetGadgetText(#ConnectTo_Port)))>0
       DisableGadget(#ConnectTo_OK,0)
      Else
       DisableGadget(#ConnectTo_OK,1)
      EndIf
     Case #ConnectTo_OK
      ConnectTo()
     Case #ConnectTo_Cancel
      CloseWindow(#ConnectTo_Window)
      DisableWindow(#Window,0)
    EndSelect
   Case #PB_Event_SizeWindow
    ResizeGadget(#State,70,10,WindowWidth(#Window)-80,20)
    ResizeGadget(#EditContainer,0,40,WindowWidth(#Window),130)
    ResizeGadget(#Name,70,10,GadgetWidth(#EditContainer)-80,20)
    ResizeGadget(#Address,70,40,GadgetWidth(#EditContainer)-80,20)
    ResizeGadget(#DataType,70,70,GadgetWidth(#EditContainer)-80,20)
    ResizeGadget(#Value,70,100,GadgetWidth(#EditContainer)-80,20)
    ResizeGadget(#Add,0,GadgetHeight(#EditContainer)+40,WindowWidth(#Window)/4,30)
    ResizeGadget(#Set,GadgetWidth(#Add),GadgetY(#Add),GadgetWidth(#Add),30)
    ResizeGadget(#Read,GadgetWidth(#Add)*2,GadgetY(#Add),GadgetWidth(#Add),30)
    ResizeGadget(#Write,GadgetWidth(#Add)*3,GadgetY(#Add),GadgetWidth(#Add),30)
    ResizeGadget(#List,0,GadgetY(#Add)+30,WindowWidth(#Window),WindowHeight(#Window)-GadgetY(#Add)-MenuHeight()-30)
   Case #PB_Event_CloseWindow
    Quit=1
  EndSelect
 Until Quit
 If Config\ConnectionID
  CloseNetworkConnection(Config\ConnectionID)
 EndIf
 File=CreateFile(#PB_Any,Common\InstallPath+"MemoryChanger.dat")
  If IsFile(File)
   For Item=0 To CountGadgetItems(#List)-1
    WriteStringN(File,Trim(GetGadgetItemText(#List,Item,0)))
    WriteLong(File,Hex2Dec(UCase(Trim(GetGadgetItemText(#List,Item,1)))))
    WriteByte(File,GetGadgetItemData(#List,Item))
   Next
   CloseFile(File)
  EndIf
 OpenPreferences(Common\PrefsFile)
  PreferenceGroup("Global")
   WritePreferenceLong("Language",Config\Language)
  PreferenceGroup("MemoryNetwork")
   WritePreferenceString("LastIP",Config\IP)
   WritePreferenceLong("Port",Config\Port)
 ClosePreferences()
EndIf

DataSection
 Language_English:
  Data$ "File"; 0
  Data$ "Connect to..."; 1
  Data$ "Quit"; 2
  Data$ "Language"; 3
  Data$ "English"; 4
  Data$ "German"; 5
  Data$ "Help"; 6
  Data$ "About..."; 7
  Data$ "IP-address"; 8
  Data$ "Cancel"; 9
  Data$ "Connection to %1 successful!"; 10
  Data$ "Can not connect to %1!"; 11
  Data$ "Error"; 12
  Data$ "Not connected!"; 13
  Data$ "Connected to %1 (Requesttime: %2 ms)"; 14
  Data$ "Written by Programie in PureBasic 4.20"; 15
  Data$ "See help from GTA San Andreas ToolBox GUI"; 16
  Data$ "The server %1 is not a valid GTA San Andreas ToolBox MemoryServer!"; 17
  Data$ "Address"; 18
  Data$ "Datatype"; 19
  Data$ "Value"; 20
  Data$ "Add"; 21
  Data$ "Apply"; 22
  Data$ "Read"; 23
  Data$ "Write"; 24
  Data$ "Remove item"; 25
  Data$ "Should the item '%1' be removed?"; 26
  Data$ "The server does not respond!"; 27
  Data$ "In the datatype '%1' are only numbers allowed!"; 28
  Data$ "Unknown datatype!"; 29
  Data$ "Copy addresslist from server"; 30
  Data$ "If you copy the addresslist from the server the current addresslist will be overwrited!<br>Really continue?"; 31
  Data$ "There is no connection to any server yet!"; 32
  Data$ "Unknown error!"; 33
  Data$ "Can not find the file on the server!"; 34
  Data$ "Can not send the file!"; 35
  Data$ "GTA San Andreas is not running on the server!"; 36
 Language_German:
  Data$ "Datei"; 0
  Data$ "Verbinden mit..."; 1
  Data$ "Beenden"; 2
  Data$ "Sprache"; 3
  Data$ "Englisch"; 4
  Data$ "Deutsch"; 5
  Data$ "Hilfe"; 6
  Data$ "Über..."; 7
  Data$ "IP-Adresse"; 8
  Data$ "Abbrechen"; 9
  Data$ "Erfolgreich zu %1 verbunden!"; 10
  Data$ "Es kann keine Verbindung zu %1 hergestellt werden!"; 11
  Data$ "Fehler"; 12
  Data$ "Nicht verbunden!"; 13
  Data$ "Verbunden mit %1 (Anforderungszeit: %2 ms)"; 14
  Data$ "Geschrieben von Programie in Purebasic 4.20"; 15
  Data$ "Siehe Hilfe von der GTA San Andreas ToolBox GUI"; 16
  Data$ "Der Server %1 ist kein gültiger GTA San Andreas ToolBox MemoryServer!"; 17
  Data$ "Adresse"; 18
  Data$ "Datentyp"; 19
  Data$ "Wert"; 20
  Data$ "Hinzufügen"; 21
  Data$ "Übernehmen"; 22
  Data$ "Lesen"; 23
  Data$ "Schreiben"; 24
  Data$ "Eintrag entfernen"; 25
  Data$ "Soll der Eintrag '%1' entfernt werden?"; 26
  Data$ "Der Server antwortet nicht!"; 27
  Data$ "In dem Datentyp '%1' sind nur Nummern erlaubt!"; 28
  Data$ "Unbekannter Datentyp!"; 29
  Data$ "Adressliste vom Server kopieren"; 30
  Data$ "Durch das Kopieren der Adressliste vom Server wird die aktuelle Liste überschrieben!<br>Wirklich fortfahren?"; 31
  Data$ "Es wurde noch keine Verbindung zu einem Server hergestellt!"; 32
  Data$ "Unbekannter Fehler!"; 33
  Data$ "Die Datei wurde auf dem Server nicht gefunden!"; 34
  Data$ "Die Datei konnte nicht gesendet werden!"; 35
  Data$ "GTA San Andreas ist auf dem Server nicht gestartet!"; 36
EndDataSection