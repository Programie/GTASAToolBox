Enumeration
 #Window
 #LoginPage
 #Text1
 #Text2
 #Username
 #Password
 #Login
 #Cancel
 #Text3
EndEnumeration

Structure Config
 SCN_ConnectionID.l
 SCN_Host.s
 SCN_Port.l
 SCN_LoginThread.l
EndStructure

Global Config.Config

IncludeFile "Common.pbi"

Procedure SCN_WrongData()
 MessageRequester("Fehler","Der Server sendet falsche Daten!"+Chr(13)+"Möglicherweise ist der Server kein SelfCoders-Network Server oder die Version dieses Clientes ist zu alt.",#MB_ICONERROR)
EndProcedure

Procedure Login(Null)
 Username$=Trim(GetGadgetText(#Username))
 Password$=Trim(GetGadgetText(#Password))
 HideGadget(#LoginPage,1)
 HideGadget(#Text3,0)
 SetGadgetText(#Text3,"Verbindung wird hergestellt...")
 ID=OpenNetworkConnection(Config\SCN_Host,Config\SCN_Port)
  If ID
   For Timeout=1 To 10000
    Select NetworkClientEvent(ID)
     Case 0
     Case #PB_NetworkEvent_Data
      ReceiveNetworkData(ID,@Result,4)
      If Result=#SCN_Connected
       OK=1
      Else
       OK=-1
      EndIf
     Default
      OK=-1
    EndSelect
    If OK
     Break
    EndIf
    Delay(1)
   Next
   If OK<>1
    CloseNetworkConnection(ID)
   EndIf
   Select OK
    Case 1
     MD5$=MD5Fingerprint(@Password$,Len(Password$))
     Size=Len(Username$)+Len(MD5$)+8; 4 bytes freebuffer (Bufferoverflow protection)
     UserData=AllocateMemory(Size)
      If UserData
       PokeL(UserData,Size)
       PokeS(UserData+4,Username$)
       PokeS(UserData+Len(Username$)+4,MD5$)
       SendNetworkData(ID,UserData,Size)
       FreeMemory(UserData)
       OK=0
       For Timeout=1 To 10000
        Select NetworkClientEvent(ID)
         Case 0
         Case #PB_NetworkEvent_Data
          ReceiveNetworkData(ID,@Size,4)
          UserData=AllocateMemory(Size)
           If UserData
            ReceiveNetworkData(ID,UserData,Size)
            UserID=PeekL(UserData)
            Username$=PeekS(UserData)
            Debug "UserID: "+Str(UserID)
            Debug "Username: "+Username$
            FreeMemory(UserData)
           EndIf
          If Result=#SCN_Connected
           OK=1
          Else
           OK=-1
          EndIf
         Default
          OK=-1
        EndSelect
        If OK
         Break
        EndIf
       Next
       Password$=""
       MD5$=""
       If OK<>1
        CloseNetworkConnection(ID)
       EndIf
       Select OK
        Case 1
         Config\SCN_ConnectionID=ID
         MessageRequester("Information","Erfolgreich verbunden!",#MB_ICONINFORMATION)
         CloseNetworkConnection(Config\SCN_ConnectionID); disconnect because it´s just a connectiontest...
        Case -1
         SCN_WrongData()
        Case 0
         MessageRequester("Fehler","Der Server antwortet nicht!",#MB_ICONERROR)
       EndSelect
      EndIf
    Case -1
     SCN_WrongData()
    Case 0
     MessageRequester("Fehler","Der Server antwortet nicht!",#MB_ICONERROR)
   EndSelect
  Else
   MessageRequester("Fehler","Es konnte keine Verbindung zum SelfCoders-Network hergestellt werden!",#MB_ICONERROR)
  EndIf
 HideGadget(#Text3,1)
 HideGadget(#LoginPage,0)
 DisableWindow(#Window,0)
EndProcedure

InitNetwork()

OpenPreferences(Common\PrefsFile)
 PreferenceGroup("SelfCoders-Network")
  Config\SCN_Host=ReadPreferenceString("Host","selfcoders.de")
  Config\SCN_Port=ReadPreferenceLong("Port",9182)
ClosePreferences()

If OpenWindow(#Window,100,100,400,100,"SelfCoders-Network Login",#PB_Window_ScreenCentered)
 If CreateGadgetList(WindowID(#Window))
  ContainerGadget(#LoginPage,0,0,WindowWidth(#Window),WindowHeight(#Window))
   TextGadget(#Text1,10,10,100,20,"Benutzername:")
   TextGadget(#Text2,10,40,100,20,"Passwort:")
   StringGadget(#Username,120,10,270,20,"")
   StringGadget(#Password,120,40,270,20,"",#PB_String_Password)
   ButtonGadget(#Login,WindowWidth(#Window)-220,70,100,20,"Login")
   ButtonGadget(#Cancel,WindowWidth(#Window)-110,70,100,20,"Abbrechen")
  CloseGadgetList()
  TextGadget(#Text3,10,10,WindowWidth(#Window)-20,20,"")
 EndIf
 HideGadget(#Text3,1)
 AddKeyboardShortcut(#Window,#PB_Shortcut_Return,#Login)
 AddKeyboardShortcut(#Window,#PB_Shortcut_Escape,#Cancel)
 Repeat
  Select WaitWindowEvent()
   Case #PB_Event_Menu
    Select EventMenu()
     Case #Login
      If IsThread(Config\SCN_LoginThread)=0
       Config\SCN_LoginThread=CreateThread(@Login(),0)
      EndIf
     Case #Cancel
      Quit=1
    EndSelect
   Case #PB_Event_Gadget
    Select EventGadget()
     Case #Login
      If IsThread(Config\SCN_LoginThread)=0
       Config\SCN_LoginThread=CreateThread(@Login(),0)
      EndIf
     Case #Cancel
      Quit=1
    EndSelect
  EndSelect
 Until Quit
EndIf