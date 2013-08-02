Enumeration 1
 #Server_GetVersion
 #Server_NeedUsername
 #Server_UsernameWrong
 #Server_NeedPassword
 #Server_PasswordWrong
 #Server_LoginOK
EndEnumeration

Enumeration 1
 #Client_Version
 #Client_Username
 #Client_Password
EndEnumeration

#Version=1

Procedure SendCommand(ClientID,Command)
 Buffer=AllocateMemory(4)
  If Buffer
   PokeL(Buffer,Command)
   SendNetworkData(ClientID,Buffer,4)
   FreeMemory(Buffer)
  EndIf
EndProcedure

If InitNetwork()=0
 MessageRequester("Error","No networkdevice found!",#MB_ICONERROR)
 End
EndIf