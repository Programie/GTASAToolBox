Enumeration
 #Window
 #Tray
 #Menu
 #Quit
EndEnumeration

#Buffer=1024*1024

Structure Config
 HigherProcessPriority.b
 Quit.b
 MemoryNetwork_Port.l
EndStructure

Global Config.Config
IncludeFile "Common.pbi"

Procedure WindowCallback(WindowID,Message,wParam,lParam)
 Select Message
  Case #WM_QUERYENDSESSION
   Config\Quit=1
  Case Common\ExplorerMsg
   If IsSysTrayIcon(#Tray)
    RemoveSysTrayIcon(#Tray)
   EndIf
   If AddSysTrayIcon(#Tray,WindowID(#Window),ImageID(#Tray))
    SysTrayIconToolTip(#Tray,"GTA San Andreas ToolBox MemoryServer"+Chr(13)+"Port: "+Str(Config\MemoryNetwork_Port))
   EndIf
 EndSelect
 ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

InitNetwork()
CatchImage(#Tray,?Tray)

OpenPreferences(Common\PrefsFile)
 PreferenceGroup("HigherProcessPriority")
  Config\HigherProcessPriority=ReadPreferenceLong("MemoryServer",0)
 PreferenceGroup("MemoryNetwork")
  Config\MemoryNetwork_Port=ReadPreferenceLong("Port",#MemoryNetwork_DefaultPort)
ClosePreferences()

If IsModuleRunning(#Module_MemoryServer)
 MessageRequester("Error","The MemoryServer was allready started!",#MB_ICONERROR)
 End
Else
 HigherProcessPriority(Config\HigherProcessPriority)
 If CreateNetworkServer(1,Config\MemoryNetwork_Port)
  If OpenWindow(#Window,0,0,0,0,#RunOnlyOnceTitle_MemoryServer,#PB_Window_Invisible)
   If AddSysTrayIcon(#Tray,WindowID(#Window),ImageID(#Tray))
    SysTrayIconToolTip(#Tray,"GTA San Andreas ToolBox MemoryServer"+Chr(13)+"Port: "+Str(Config\MemoryNetwork_Port))
   EndIf
   If CreatePopupMenu(#Menu)
    MenuItem(#Quit,"Quit")
   EndIf
   SetWindowCallback(@WindowCallback())
   Repeat
    Title$=GetWindowTitle(#Window)
    Title$=Trim(Right(Title$,Len(Title$)-Len(#RunOnlyOnceTitle_MemoryServer)))
     If Title$
      Select Title$
       Case #Module_CMD_Quit
        Config\Quit=1
      EndSelect
      SetWindowTitle(#Window,#RunOnlyOnceTitle_MemoryServer)
     EndIf
    Select WaitWindowEvent(5)
     Case #PB_Event_SysTray
      DisplayPopupMenu(#Menu,WindowID(#Window))
     Case #PB_Event_Menu
      Select EventMenu()
       Case #Quit
        Config\Quit=1
      EndSelect
    EndSelect
    Select NetworkServerEvent()
     Case #PB_NetworkEvent_Connect
      VersionInfo=#MemoryNetwork_VersionTest
      SendNetworkData(EventClient(),@VersionInfo,4)
     Case #PB_NetworkEvent_Data
      Client=EventClient()
      Buffer=AllocateMemory(#Buffer)
       If Buffer
        UpdateGTASAProcess()
        ReceiveNetworkData(Client,Buffer,#Buffer)
        Select PeekL(Buffer)
         Case #Network_GetPID
          SendNetworkData(Client,@Common\GTASA_PID,4)
         Case #Network_ReadAddress
          Debug "Read address"
          If Common\GTASA_PID
           Debug "GTA SA found"
           Address=PeekL(Buffer+4)
           Size=PeekL(Buffer+8)
           Debug "Offset: 0x"+Hex(Address)
           Debug "Size: "+Str(Size)+" bytes"
            If Address And Size
             Memory=AllocateMemory(Size+4)
              If Memory
               Debug "Memory allocated with "+Str(Size+4)+" bytes"
               PokeL(Memory,#Network_ReadAddress)
               VirtualProtectEx_(Common\GTASA_PID,Address,Size,#PAGE_EXECUTE_READWRITE,@OldProtect)
               ReadProcessMemory_(Common\GTASA_PID,Address,Memory+4,Size,0)
               VirtualProtectEx_(Common\GTASA_PID,Address,Size,@OldProtect,@Protect)
               Debug "Send memory"
               SendNetworkData(Client,Memory,Size+4)
               Debug "Memory sended to client"
              EndIf
            EndIf
          Else
           Result=#Network_Error_GTASANotFound
           SendNetworkData(Client,@Result,4)
           Debug "GTA SA PID is zero"
          EndIf
         Case #Network_WriteAddress
          If Common\GTASA_PID
           Address=PeekL(Buffer+4)
           Size=PeekL(Buffer+8)
            If Address And Size And Size<=#Buffer-12
             VirtualProtectEx_(Common\GTASA_PID,Address,Size,#PAGE_EXECUTE_READWRITE,@OldProtect)
             WriteProcessMemory_(Common\GTASA_PID,Address,Buffer+12,Size,0)
             VirtualProtectEx_(Common\GTASA_PID,Address,Size,@OldProtect,@Protect)
             Result=#Network_WriteAddress
             SendNetworkData(Client,@Result,4)
            EndIf
          Else
           Result=#Network_Error_GTASANotFound
           SendNetworkData(Client,@Result,4)
          EndIf
         Case #Network_GetMemoryListFile
          If IsFileEx(Common\InstallPath+"MemoryChanger.dat")
           If SendNetworkFile(Client,Common\InstallPath+"MemoryChanger.dat")=0
            Result=-2
            SendNetworkData(Client,@Result,4)
           EndIf
          Else
           Result=-1
           SendNetworkData(Client,@Result,4)
          EndIf
        EndSelect
        FreeMemory(Buffer)
       EndIf
    EndSelect
   Until Config\Quit
  EndIf
  CloseNetworkServer(1)
  RemoveSysTrayIcon(#Tray)
 Else
  MessageRequester("Error","Can launch server on port "+Str(Config\MemoryNetwork_Port)+"!",#MB_ICONERROR)
 EndIf
EndIf

DataSection
 Tray:
  IncludeBinary "MemoryServer.ico"
EndDataSection