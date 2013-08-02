Enumeration
	#Mode_Normal
	#Mode_ReadMemory
	#Mode_SendCheat
	#Mode_WriteMemory
EndEnumeration

Global ConnectionID
Global UseConsoleColor
Global Address$
Global NewList Parameters.s()

Procedure.s GetParameter(Name$)
	ForEach Parameters()
		If LCase(Trim(StringField(Parameters(),1,"=")))=LCase(Trim(Name$))
			Value$=Trim(StringField(Parameters(),2,"="))
			If Not Value$
				Value$="1"
			EndIf
			ProcedureReturn Value$
		EndIf
	Next
EndProcedure

Procedure ConsoleColorEx(Color)
	If UseConsoleColor
		ConsoleColor(Color,0)
	EndIf
EndProcedure

Procedure ExecuteCommand(Command$,Parameter$="")
	String$=Trim(StringField(Command$,1," ")+Chr(9)+Parameter$)
	If String$
		If ConnectionID
			SendNetworkData(ConnectionID,@String$,StringByteLength(String$))
			ReceiveNetworkData(ConnectionID,@Result,1)
			Select LCase(Command$)
				Case "login"
					Select Result
						Case 1
							PrintN("Login OK")
						Case 2
							PrintN("Login failed!")
						Case 3
							PrintN("You are already logged in!")
						Default
							UnknownError=#True
					EndSelect
				Case "readmemory"
					Select Result
						Case 1
							ReceiveNetworkData(ConnectionID,@Size,4)
							If Size>0
								String$=Space(Size)
								ReceiveNetworkData(ConnectionID,@String$,Size)
								Print("Current value: ")
								ConsoleColorEx(10)
								PrintN(String$)
							Else
								ConsoleColorEx(12)
								PrintN("Data read error!")
							EndIf
							ConsoleColorEx(7)
						Case 2
							ConsoleColorEx(12)
							PrintN("Unknown data type!")
							ConsoleColorEx(7)
							PrintN("")
							PrintN("Possible data types:")
							ConsoleColorEx(10)
							PrintN("Byte")
							PrintN("Character")
		   				PrintN("Double")
		   				PrintN("Float")
		   				PrintN("Long")
		   				PrintN("Quad")
		   				PrintN("String")
		   				PrintN("Word")
		   				ConsoleColorEx(7)
						Case 3
							ConsoleColorEx(12)
							PrintN("GTA San Andreas is not running!")
						Default
							UnknownError=#True
					EndSelect
					ConsoleColorEx(7)
				Case "reload"
					PrintN("The data has been reloaded")
				Case "sendcheat"
					Select Result
						Case 1
							ConsoleColorEx(10)
							PrintN("The cheat has been executed.")
						Case 2:
							ConsoleColorEx(12)
							PrintN("The game is not ready!")
						Case 3:
							ConsoleColorEx(12)
							PrintN("GTA San Andreas is not running!")
						Case 4:
							ConsoleColorEx(12)
							PrintN("The cheat has been not processed by the CheatProcessor!")
						Case 5:
							ConsoleColorEx(12)
							PrintN("The CheatProcessor is not running!")
						Default:
							UnknownError=#True
					EndSelect
					ConsoleColorEx(7)
				Case "writememory"
					Select Result
						Case 1
							ConsoleColorEx(10)
							PrintN("The address has been changed.")
						Case 2
							ConsoleColorEx(12)
							PrintN("Unknown data type!")
							ConsoleColorEx(7)
							PrintN("")
							PrintN("Possible data types:")
							ConsoleColorEx(10)
							PrintN("Byte")
							PrintN("Character")
		   				PrintN("Double")
		   				PrintN("Float")
		   				PrintN("Long")
		   				PrintN("Quad")
		   				PrintN("String")
		   				PrintN("Word")
		   				ConsoleColorEx(7)
						Case 3
							ConsoleColorEx(12)
							PrintN("GTA San Andreas is not running!")
						Default
							UnknownError=#True
					EndSelect
			EndSelect
			If UnknownError
				ConsoleColorEx(12)
				PrintN("Unknown error (Error "+Str(Result)+")")
			EndIf
		Else
			PrintN("Not connected!")
		EndIf
	EndIf
	ConsoleColorEx(7)
	ProcedureReturn Result
EndProcedure

Procedure Connect()
	Host$=Trim(StringField(Address$,1,":"))
	Port=Val(StringField(Address$,2,":"))
	If Not Host$
		Host$="localhost"
	EndIf
	If Port<1 Or Port>65000
		Port=8476
	EndIf
	Print("Connecting to ")
	ConsoleColorEx(10)
	Print(Host$+":"+Str(Port))
	ConsoleColorEx(7)
	Print("... ")
	NewConnectionID=OpenNetworkConnection(Host$,Port)
	If NewConnectionID
		If ConnectionID
			CloseNetworkConnection(ConnectionID)
		EndIf
		ConnectionID=NewConnectionID
		ConsoleColorEx(10)
		PrintN("OK")
	Else
		ConsoleColorEx(12)
		PrintN("failed!")
	EndIf
	ConsoleColorEx(7)
	ProcedureReturn ConnectionID
EndProcedure

InitNetwork()

For Index=0 To CountProgramParameters()-1
	AddElement(Parameters())
	Parameters()=ProgramParameter()
Next

Address$=GetParameter("host")
Command$=GetParameter("command")
Parameter$=GetParameter("parameter")

If Not GetParameter("nocolor")
	UseConsoleColor=#True
EndIf

If OpenConsole()
	ConsoleTitle("GTA San Andreas ToolBox Console")
	ConsoleColorEx(7)
	CheckAddress:
	If Not Address$
		Print("Connect to: ")
		ConsoleColorEx(10)
		Address$=Input()
		ConsoleColorEx(7)
		Goto CheckAddress
	EndIf
	If Connect()
		If Command$
			ExecuteCommand(Command$,Parameter$)
		Else
			ConsoleColorEx(12)
			PrintN("Use 'help' to see all available command.")
			ConsoleColorEx(7)
			PrintN("")
			Repeat
				Select Mode
					Case #Mode_ReadMemory
						Print("ReadMemory> ")
					Case #Mode_SendCheat
						Print("SendCheat> ")
					Case #Mode_WriteMemory
						Print("WriteMemory> ")
					Default
						Print("Command> ")
				EndSelect
				ConsoleColorEx(10)
				FullCommand$=Trim(Input())
				ConsoleColorEx(7)
				Command$=StringField(FullCommand$,1," ")
				Find=FindString(FullCommand$," ",0)
				If Find
					Parameter$=Trim(Mid(FullCommand$,Find+1))
				Else
					Parameter$=""
				EndIf
				Select Mode
					Case #Mode_ReadMemory
						Select LCase(Command$)
							Case "exit"
								Mode=#Mode_Normal
							Default
								If FullCommand$
									ExecuteCommand("readmemory",StringField(FullCommand$,1," ")+Chr(9)+StringField(FullCommand$,2," "))
								EndIf
						EndSelect
					Case #Mode_SendCheat
						Select LCase(Command$)
							Case "exit"
								Mode=#Mode_Normal
							Default
								If FullCommand$
									ExecuteCommand("sendcheat",FullCommand$)
								EndIf
						EndSelect
					Case #Mode_WriteMemory
						Select LCase(Command$)
							Case "exit"
								Mode=#Mode_Normal
							Default
								If FullCommand$
									ExecuteCommand("writememory",StringField(FullCommand$,1," ")+Chr(9)+StringField(FullCommand$,2," ")+Chr(9)+StringField(FullCommand$,3," "))
								EndIf
						EndSelect
					Default
						Select LCase(Command$)
							Case "connect"
								If Parameter$
									Address$=Parameter$
								EndIf
								Connect()
							Case "exit"
								Break
							Case "help"
								PrintN("***** GTA San Andreas ToolBox Console Help *****")
								PrintN("")
								ConsoleColorEx(14)
								Print("connect")
								ConsoleColorEx(7)
								Print(" [")
								ConsoleColorEx(10)
								Print("Address")
								ConsoleColorEx(7)
								PrintN("]")
								PrintN("Connect to another host")
								PrintN("*****")
								ConsoleColorEx(10)
								Print("Address")
								ConsoleColorEx(7)
								PrintN(": The address you want to connect to (e.g. localhost or 127.0.0.1)")
								PrintN("*****")
								PrintN("Note: Use without an address to reconnect to the current host.")
								PrintN("")
								ConsoleColorEx(14)
								Print("readmemory")
								ConsoleColorEx(7)
								Print(" [")
								ConsoleColorEx(10)
								Print("Address")
								ConsoleColorEx(7)
								Print("] [")
								ConsoleColorEx(10)
								Print("Type")
								ConsoleColorEx(7)
								PrintN("]")
								PrintN("Read a value from the GTA San Andreas memory")
								PrintN("*****")
								ConsoleColorEx(10)
								Print("Address")
								ConsoleColorEx(7)
								Print(": The address in the memory (e.g. ")
								ConsoleColorEx(10)
								Print("0xB6F3B8")
								ConsoleColorEx(7)
								PrintN(")")
								ConsoleColorEx(10)
								Print("Type")
								ConsoleColorEx(7)
								Print(": The data type (e.g.")
								ConsoleColorEx(10)
								Print("long")
								ConsoleColorEx(7)
								Print(" or ")
								ConsoleColorEx(10)
								Print("string")
								ConsoleColorEx(7)
								PrintN(")")
								PrintN("*****")
								PrintN("Note: Use without parameters to open the memory console.")
								PrintN("")
								ConsoleColorEx(14)
								PrintN("reload")
								ConsoleColorEx(7)
								PrintN("Reload all data like cheat list, teleport list, etc.")
								PrintN("")
								Print("sendcheat [")
								ConsoleColorEx(10)
								Print("CHEAT")
								ConsoleColorEx(7)
								PrintN("]")
								PrintN("Send a cheat")
								PrintN("*****")
								ConsoleColorEx(10)
								Print("CHEAT")
								ConsoleColorEx(7)
								Print(": The cheat you want to execute (e.g. ")
								ConsoleColorEx(10)
								Print("SPAWNVEHICLE 451")
								ConsoleColorEx(7)
								Print(" or ")
								ConsoleColorEx(10)
								Print("HESOYAM")
								ConsoleColorEx(7)
								PrintN(")")
								PrintN("*****")
								PrintN("Note: Use without a cheat to open the cheat console.")
								PrintN("")
								ConsoleColorEx(14)
								Print("writememory")
								ConsoleColorEx(7)
								Print(" [")
								ConsoleColorEx(10)
								Print("Address")
								ConsoleColorEx(7)
								Print("] [")
								ConsoleColorEx(10)
								Print("Type")
								ConsoleColorEx(7)
								Print("] [")
								ConsoleColorEx(10)
								Print("Value")
								ConsoleColorEx(7)
								PrintN("]")
								PrintN("Write a value to the GTA San Andreas memory")
								PrintN("*****")
								ConsoleColorEx(10)
								Print("Address")
								ConsoleColorEx(7)
								Print(": The address in the memory (e.g. ")
								ConsoleColorEx(10)
								Print("0xB6F3B8")
								ConsoleColorEx(7)
								PrintN(")")
								ConsoleColorEx(10)
								Print("Type")
								ConsoleColorEx(7)
								Print(": The data type (e.g.")
								ConsoleColorEx(10)
								Print("long")
								ConsoleColorEx(7)
								Print(" or ")
								ConsoleColorEx(10)
								Print("string")
								ConsoleColorEx(7)
								PrintN(")")
								ConsoleColorEx(10)
								Print("Value")
								ConsoleColorEx(7)
								PrintN(": The value you want to write into the memory")
								PrintN("*****")
								PrintN("Note: Use without parameters to open the memory console.")
								PrintN("")
							Case "login"
								ExecuteCommand(Command$,Parameter$)
							Case "readmemory"
								If Parameter$
									ExecuteCommand(Command$,StringField(Parameter$,1," ")+Chr(9)+StringField(Parameter$,2," "))
								Else
									Mode=#Mode_ReadMemory
								EndIf
							Case "reload"
								ExecuteCommand(Command$)
							Case "sendcheat"
								If Parameter$
									ExecuteCommand(Command$,Parameter$)
								Else
									Mode=#Mode_SendCheat
								EndIf
							Case "writememory"
								If Parameter$
									ExecuteCommand(Command$,StringField(Parameter$,1," ")+Chr(9)+StringField(Parameter$,2," ")+Chr(9)+StringField(Parameter$,3," "))
								Else
									Mode=#Mode_WriteMemory
								EndIf
							Default
						EndSelect
				EndSelect
			ForEver
		EndIf
		If ConnectionID
			CloseNetworkConnection(ConnectionID)
		EndIf
	Else
		If Not Command$
			Address$=""
			Goto CheckAddress
		EndIf
	EndIf
	CloseConsole()
EndIf
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 432
; FirstLine = 409
; Folding = -
; EnableXP