Enumeration
	#RunOnlyOnceCheckWindow; Just to use Common.pbi
EndEnumeration

Enumeration
	#DisplayMessage_LeftTop; 0
	#DisplayMessage_MiddleBottom; 1
EndEnumeration

#IsDLL=#True

IncludeFile "Includes\Common.pbi"

; Each cheat function have to be declared with specific parameters
; You get data (in) from the Cheat Processor and have to send data back (out) to the cheat processor
; The out variables are pointers to the variables

; GTASA_PID [in, long] = ProcessID of GTA San Andreas
; GTASA_WindowID [in, long] = WindowID of the GTA San Andreas window
; Result [out, byte] = Return non-zero to say if the cheat has been processed
; Message [out, string] = Return a string to display a message (Leave empty to not show a message)
; MessageType [out, long] = Return the type for displaying the message (left top or middle top displaying)
; CheatParameter [in, string] = Parameters passed to this cheat
; CheatParameterLength [in, long] = Parameter length in bytes

; Example declaration
; MyCheat( GTASA_PID , GTASA_WindowID , Result , Message , MessageType , CheatParameter, CheatParameterLength )



; Send a simple text message to GTA San Andreas which will be displayed at the upper left corner

ProcedureDLL Test(GTASA_PID,GTASA_WindowID,Result,Message,MessageType,CheatParameter,CheatParameterLength)
	PokeS(Message,"This is a plugin to extend the GTA San Andreas ToolBox cheats")
	PokeL(MessageType,#DisplayMessage_LeftTop)
	PokeL(Result,#True)
EndProcedure


; Kill your player

ProcedureDLL KillPlayer(GTASA_PID,GTASA_WindowID,Result,Message,MessageType,CheatParameter,CheatParameterLength)
	Common\GTASA_PID=GTASA_PID
	Common\GTASA_WindowID=GTASA_WindowID
	CPED=ReadProcessValue($B6F5F0,#PB_Long)
	CVehicle=ReadProcessValue($B6F980,#PB_Long)
	If CPED
		WriteProcessValue(CPED+66,$DC,#PB_Byte)
		WriteProcessFloat(CPED+$540,0)
		IsPED=#True
	EndIf
	If CVehicle
		WriteProcessValue(CVehicle+66,$DC,#PB_Byte)
		WriteProcessFloat(CVehicle+1216,0)
		IsVehicle=#True
	EndIf
	PokeS(Message,"Player killed (P/V: "+Str(IsPED)+"/"+Str(IsVehicle)+")")
	PokeL(MessageType,#DisplayMessage_LeftTop)
	PokeL(Result,#True)
EndProcedure


; Explode all vehicles excluded your own (Experimental!)

ProcedureDLL Boom(GTASA_PID,GTASA_WindowID,Result,Message,MessageType,CheatParameter,CheatParameterLength)
	Common\GTASA_PID=GTASA_PID
	Common\GTASA_WindowID=GTASA_WindowID
	VehiclePool=ReadProcessValue($B74494,#PB_Long)
	If VehiclePool
		Elements=ReadProcessValue(VehiclePool+12,#PB_Long)
		FirstVehicle=ReadProcessValue(VehiclePool,#PB_Long)
		CVehicle=ReadProcessValue($B6F980,#PB_Long)
		If Elements And FirstVehicle And CVehicle
			For Vehicle=0 To Elements-1
				Pointer=FirstVehicle+(Vehicle*$A18)
				If Pointer<>CVehicle
					WriteProcessFloat(Pointer+1216,0)
					Destroyed+1
				EndIf
			Next
			PokeS(Message,Str(Destroyed)+" of "+Str(Elements)+" vehicles destroyed")
			PokeL(MessageType,#DisplayMessage_LeftTop)
		EndIf
	EndIf
	PokeL(Result,#True)
EndProcedure


; Write the current handling data into a file (Ini format)

ProcedureDLL LogHandling(GTASA_PID,GTASA_WindowID,Result,Message,MessageType,CheatParameter,CheatParameterLength)
	Common\GTASA_PID=GTASA_PID
	Common\GTASA_WindowID=GTASA_WindowID
	If CreatePreferences(GetPathPart(ProgramFilename())+"Handling.log")
		For Block=0 To 210
			Start=$C2B9DC+224*Block
			PreferenceGroup(Str(ReadProcessValue(Start,#PB_Long)))
				WritePreferenceFloat("Mass",ReadProcessFloat(Start+$4))
				WritePreferenceFloat("1.0/Mass",ReadProcessFloat(Start+$8))
				WritePreferenceFloat("TurnMass",ReadProcessFloat(Start+$C))
				WritePreferenceFloat("DragMass",ReadProcessFloat(Start+$10))
				WritePreferenceFloat("CenterOfMass X",ReadProcessFloat(Start+$14))
				WritePreferenceFloat("CenterOfMass Y",ReadProcessFloat(Start+$18))
				WritePreferenceFloat("CenterOfMass Z",ReadProcessFloat(Start+$1C))
				WritePreferenceLong("PercentSubmerged",ReadProcessValue(Start+$20,#PB_Byte))
		Next
		ClosePreferences()
	EndIf
	PokeL(Result,#True)
EndProcedure


; Toggle head lights

ProcedureDLL ToggleHeadlights(GTASA_PID,GTASA_WindowID,Result,Message,MessageType,CheatParameter,CheatParameterLength)
	Common\GTASA_PID=GTASA_PID
	Common\GTASA_WindowID=GTASA_WindowID
	CPED=ReadProcessValue($B6F5F0,#PB_Long)
	CVehicle=ReadProcessValue($B6F980,#PB_Long)
	If CPED<>CVehicle
		NOP($6E1EDE,6)
		If ReadProcessValue(CVehicle+1412,#PB_Long)
			WriteProcessValue(CVehicle+1412,#False,#PB_Long)
			PokeS(Message,"Head lights turned off")
		Else
			WriteProcessValue(CVehicle+1412,#True,#PB_Long)
			PokeS(Message,"Head lights turned on")
		EndIf
	Else
		PokeS(Message,"You are not in a vehicle")
	EndIf
	PokeL(MessageType,#DisplayMessage_LeftTop)
	PokeL(Result,#True)
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 120
; FirstLine = 103
; Folding = -
; EnableXP
; Executable = ..\Plugins\Cheats\Example.dll