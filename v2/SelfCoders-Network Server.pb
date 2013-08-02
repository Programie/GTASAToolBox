Structure Config
 SCN_Port.l
EndStructure

Global Config.Config

IncludeFile "Common.pbi"
Config\SCN_Port=9182

InitNetwork()

If CreateNetworkServer(1,Config\SCN_Port)
 Repeat
  Delay(1)
  Select NetworkServerEvent()
   Case #PB_NetworkEvent_Connect
    Value=#SCN_Connected
    SendNetworkData(EventClient(),@Value,4)
  EndSelect
 ForEver
EndIf