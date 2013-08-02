Procedure SetCheat(Cheat$,PlaySound)
	Cheat$=Trim(Cheat$)
	CheatPar$=Mid(Cheat$,FindString(Cheat$," ",0)+1)
	Cheat$=StringField(Cheat$,1," ")
	If Config\UseCheatSound And PlaySound
		If GlobalData\PlaySound
			GlobalData\PlaySound=0
		EndIf
		SoundFile$=Common\InstallPath+"Sounds\"+Config\CheatSound
		If LCase(GetExtensionPart(SoundFile$))="bmf"
			GlobalData\PlaySound=CreateThread(@PlayBMF(),@SoundFile$)
		Else
			PlaySound_(SoundFile$,0,#SND_ASYNC)
		EndIf
	EndIf
	If Cheat$
		GlobalData\LastCheat=Cheat$
		CheatSent=#True
		UpdateSysTrayToolTip()
		Select UCase(Cheat$);- Cheats
			Case "ACTIVATERADIO"
				VehicleID=Val(Trim(CheatPar$))
				If VehicleID<400 Or VehicleID>611
					CVehicle=ReadProcessValue($B6F980,#PB_Long)
					If CVehicle
						VehicleID=ReadProcessValue(CVehicle+34,#PB_Word)
					EndIf
				EndIf
				If VehicleID=>400 And VehicleID<=611
					Offset=$85D2CB+(VehicleID*36)
					If ReadProcessValue(Offset,#PB_Byte) Or GlobalData\JustActivateCheat
						WriteProcessValue(Offset,0,#PB_Byte)
						DisplayMessage(ReplaceString(Language("Radio activated in %1"),"%1","~r~"+Vehicle(VehicleID-400)\Name,1)+"~s~",#DisplayMessage_LeftTop)
					Else
						WriteProcessValue(Offset,1,#PB_Byte)
						DisplayMessage(ReplaceString(Language("Radio deactivated in %1"),"%1","~r~"+Vehicle(VehicleID-400)\Name,1)+"~s~",#DisplayMessage_LeftTop)
					EndIf
				Else
					CheatSent=#False
				EndIf
			Case "AEDUWNV"
				ActivateCheat($969174,Cheat$)
			Case "AEZAKMI"
				If ReadProcessValue($969171,#PB_Byte)=0 Or GlobalData\JustActivateCheat
					WriteProcessValue($969171,1,#PB_Byte)
					SetWantedLevel(0)
				Else
				WriteProcessValue($969171,0,#PB_Byte)
				EndIf
			Case "AFSNMSMW"
				ActivateCheat($969153,Cheat$)
			Case "AGBDLCID"
				SpawnVehicle(556)
			Case "AJLOJYQY"
				ActivateCheat($96913E,Cheat$)
			Case "AKJJYGLC"
				SpawnVehicle(471)
			Case "AMOMHRER"
				CallProcessFunction($0043A570)
			Case "ASNAEB"
				CallProcessFunction($00438F20)
			Case "AUTOAIM"
				If ReadProcessValue($B6EC2E,#PB_Byte)
					WriteProcessValue($B6EC2E,0,#PB_Byte)
					DisplayMessage("Auto aim deactivated",#DisplayMessage_LeftTop)
				Else
					WriteProcessValue($B6EC2E,1,#PB_Byte)
					DisplayMessage("Auto aim activated",#DisplayMessage_LeftTop)
				EndIf
			Case "BAGUVIX"
				ActivateCheat($96916D,Cheat$)
			Case "BIGBANG"
				; Destroy all vehicles (excluded the own)
			Case "BSXSGGC"
				ActivateCheat($969166,Cheat$)
			Case "CALLPLUGIN"
				CheatSent=#False
				File$=Common\InstallPath+"CheatPlugins\"+StringField(CheatPar$,1," ")+".dll"
				If IsFileEx(File$)
					Dll=OpenLibrary(#PB_Any,File$)
					If IsLibrary(Dll)
						Function=GetFunction(Dll,StringField(CheatPar$,2," "))
						If Function
							Message$=Space(1024)
							CallFunctionFast(Function,Common\GTASA_PID,Common\GTASA_WindowID,@CheatSent,@Message$,@MessageType)
							If Message$
								DisplayMessage(Message$,MessageType)
							EndIf
						EndIf
						CloseLibrary(Dll)
					EndIf
				EndIf
			Case "CHANGECARCOLOR"
				CPED=ReadProcessValue($B6F5F0,#PB_Long)
				CVehicle=ReadProcessValue($B6F980,#PB_Long)
				If CPED<>CVehicle And CVehicle
					VehicleID=ReadProcessValue(CVehicle+34,#PB_Word)
					If VehicleID=>400 And VehicleID<=611
						If VehicleID<>GlobalData\CarColor_VehicleID
							GlobalData\CarColor_VehicleID=VehicleID
							GlobalData\CarColor_Color=0
						EndIf
						Colors$=Vehicle(VehicleID-400)\Colors
						If GlobalData\CarColor_Color=>(CountString(Colors$,",")+1)/2
							GlobalData\CarColor_Color=1
						Else
							GlobalData\CarColor_Color+1
						EndIf
						Color1=Val(Trim(StringField(Colors$,GlobalData\CarColor_Color*2-1,",")))
						Color2=Val(Trim(StringField(Colors$,GlobalData\CarColor_Color*2,",")))
						WriteProcessValue(CVehicle+1076,Color1,#PB_Byte)
						WriteProcessValue(CVehicle+1077,Color2,#PB_Byte)
						Text$=ReplaceString(ReplaceString(ReplaceString(ReplaceString(Language("Body color: %1\nStripe color: %2\nColor index: %3"),"%1","~r~"+Str(Color1)+"~s~"),"%2","~r~"+Str(Color2)+"~s~"),"%3","~r~"+Str(GlobalData\CarColor_Color)+"~s~"),"\n","~n~",#PB_String_NoCase)
						DisplayMessage(Text$,#DisplayMessage_LeftTop)
					Else
						CheatSent=#False
					EndIf
				Else
					DisplayMessage(Language("You are not in a vehicle!"),#DisplayMessage_LeftTop)
					CheatSent=#False
				EndIf
			Case "CLEARCHEATEDSTATE"
				WriteProcessValue($96918C,0,#PB_Byte)
				WriteProcessValue($BAA472,0,#PB_Word)
				WriteProcessValue($B79044,0,#PB_Word)
				DisplayMessage(Language("Cheated status reseted"),#DisplayMessage_LeftTop)
			Case "COXEFGU"
				ActivateCheat($969165,Cheat$)
			Case "CVWKXAM"
				ActivateCheat($96916E,Cheat$)
			Case "DISABLECHEATS"
				NOP$="90 90 90 90 90"
				If ReadProcessArray($00438480,5)<>NOP$ Or GlobalData\JustActivateCheat
					WriteProcessArray($00438480,NOP$)
					DisplayMessage(Language("Cheats disabled"),#DisplayMessage_LeftTop)
				Else
					WriteProcessArray($00438480,"A0 51 F8 B5 00")
					DisplayMessage(Language("Cheats enabled"),#DisplayMessage_LeftTop)
				EndIf
			Case "EEGCYXT"
				SpawnVehicle(486)
			Case "EHIBXQS"
				ActivateCheat($969180,Cheat$)
			Case "ENGINESTATE"
				PED=ReadProcessValue($B6F3B8,#PB_Long)
				State=ReadProcessValue(PED+1064,#PB_Byte)
				If State=0 Or GlobalData\JustActivateCheat
					State=16
					DisplayMessage(Language("Engine on"),#DisplayMessage_LeftTop)
				Else
					State=0
					DisplayMessage(Language("Engine off"),#DisplayMessage_LeftTop)
				EndIf
				WriteProcessValue(PED+1064,State,#PB_Byte)
			Case "FLIPVEHICLE"
				CPED=ReadProcessValue($B6F5F0,#PB_Long)
				CVehicle=ReadProcessValue($B6F980,#PB_Long)
				If CPED<>CVehicle And CVehicle
					Offset=ReadProcessValue(CVehicle+20,#PB_Long)
					WriteProcessFloat(Offset,0-ReadProcessFloat(Offset))
					WriteProcessFloat(Offset+4,0-ReadProcessFloat(Offset+4))
					WriteProcessFloat(Offset+56,ReadProcessFloat(Offset+56)+0.1)
					DisplayMessage(Language("Vehicle flipped"),#DisplayMessage_LeftTop)
				Else
					DisplayMessage(Language("You are not in a vehicle!"),#DisplayMessage_LeftTop)
					CheatSent=#False
				EndIf
			Case "FOOOXFT"
				ActivateCheat($969140,Cheat$)
			Case "FREEZEGAME"
				If ReadProcessValue($B7CB49,#PB_Byte)
					DisplayMessage(Language("Game unfreezed"),#DisplayMessage_LeftTop)
					WriteProcessValue($B7CB49,0,#PB_Byte)
				Else
					DisplayMessage(Language("Game frozen"),#DisplayMessage_LeftTop)
					WriteProcessValue($B7CB49,1,#PB_Byte)
				EndIf
			Case "FREEZETAXITIMER"
				If GlobalData\FreezeTaxiTimer=0 Or GlobalData\JustActivateCheat
					GlobalData\FreezeTaxiTimer=ReadProcessValue($A5197C,#PB_Long)
					DisplayMessage(Language("Taxi mission timer frozen"),#DisplayMessage_LeftTop)
				Else
					GlobalData\FreezeTaxiTimer=0
					DisplayMessage(Language("Taxi mission timer unfreezed"),#DisplayMessage_LeftTop)
				EndIf
			Case "GETLASTVEHICLE"
				CheatSent=#False
				CPED=ReadProcessValue($B7CD98,#PB_Long)
				If CPED
					Pool=ReadProcessValue(CPED+$14,#PB_Long)
					If Pool
						x=ReadProcessFloat(Pool+48)
						y=ReadProcessFloat(Pool+52)
						z=ReadProcessFloat(Pool+56)
						CVehicle=ReadProcessValue(CPED+$58C,#PB_Long)
						If CVehicle
							Pool=ReadProcessValue(CVehicle+$14,#PB_Long)
							If Pool
								WriteProcessFloat(Pool+48,x+1)
								WriteProcessFloat(Pool+52,y+1)
								WriteProcessFloat(Pool+56,z+1)
								DisplayMessage(Language("Last vehicle teleported"),#DisplayMessage_LeftTop)
								CheatSent=#True
							EndIf
						EndIf
					EndIf
				EndIf
			Case "GOTOLASTVEHICLE"
				CheatSent=#False
				CPED=ReadProcessValue($B7CD98,#PB_Long)
				If CPED
					CVehicle=ReadProcessValue(CPED+$58C,#PB_Long)
					If CVehicle
						Pool=ReadProcessValue(CVehicle+$14,#PB_Long)
						If Pool
							x=ReadProcessFloat(Pool+48)
							y=ReadProcessFloat(Pool+52)
							z=ReadProcessFloat(Pool+56)
							Pool=ReadProcessValue(CPED+$14,#PB_Long)
							If Pool
								WriteProcessFloat(Pool+48,x+1)
								WriteProcessFloat(Pool+52,y+1)
								WriteProcessFloat(Pool+56,z+1)
								DisplayMessage(Language("Teleported to last vehicle"),#DisplayMessage_LeftTop)
								CheatSent=#True
							EndIf
						EndIf
					EndIf
				EndIf
			Case "GOTOPOSITION"
				Pos$=Trim(CheatPar$)
				If Pos$
					x=ValF(StringField(Pos$,1,","))
					y=ValF(StringField(Pos$,2,","))
					z=ValF(StringField(Pos$,3,","))
					SetPosition(x,y,z,GlobalData\LastPlaceBuffer)
					DisplayMessage(Language("You have been teleported to your target place!"),#DisplayMessage_LeftTop)
				Else
					DisplayMessage(Language("No position given!"),#DisplayMessage_LeftTop)
					CheatSent=#False
				EndIf
			Case "GOTOTARGETPLACE"
				GotoTargetPlace()
			Case "GRAVITY"
				If CheatPar$
					Gravity.f=ValF(CheatPar$)
				Else
					Gravity.f=0.008
				EndIf
				WriteProcessFloat($863984,Gravity)
				DisplayMessage(ReplaceString(Language("Gravity set to %1"),"%1",StrF(Gravity),1),#DisplayMessage_LeftTop)
			Case "HESOYAM"
				CallProcessFunction($00438E40)
				DisplayMessage(Language("Health, Armor, 250000$"),#DisplayMessage_LeftTop)
			Case "HIDEGAME"
				HideGame(1)
			Case "HOOVERCAR"
				ActivateCheat($969152,Cheat$)
			Case "INFINITEHEALTH"
				If Not GlobalData\InfiniteHealth Or GlobalData\JustActivateCheat
					GlobalData\InfiniteHealth=#True
					DisplayMessage(Language("Infinite health activated"),#DisplayMessage_LeftTop)
				Else
					PED=ReadProcessValue($B6F3B8,#PB_Long)
					If PED
						WriteProcessValue(PED+66,0,#PB_Byte)
						DisplayMessage(Language("Infinite health deactivated"),#DisplayMessage_LeftTop)
					EndIf
					GlobalData\InfiniteHealth=#False
				EndIf
			Case "INFINITEHEIGHT"
				If ReadProcessArray($67F24E,2)<>"EB 61" Or ReadProcessValue($6D261D,#PB_Byte)<>$EB Or GlobalData\JustActivateCheat
					WriteProcessArray($67F24E,"EB 61")
					WriteProcessValue($6D261D,$EB,#PB_Byte)
					DisplayMessage(Language("Infinite height activated"),#DisplayMessage_LeftTop)
				Else
					WriteProcessArray($67F24E,"6A 2")
					WriteProcessValue($6D261D,$7B,#PB_Byte)
					DisplayMessage(Language("Infinite height deactivated"),#DisplayMessage_LeftTop)
				EndIf
			Case "INFINITENITRO"
				If GlobalData\InfiniteNitro Or GlobalData\JustActivateCheat
					GlobalData\InfiniteNitro=#True
					DisplayMessage(Language("Infinite nitro activated"),#DisplayMessage_LeftTop)
				Else
					GlobalData\InfiniteNitro=#False
					DisplayMessage(Language("Infinite nitro deactivated"),#DisplayMessage_LeftTop)
				EndIf
			Case "JCNRUAD"
				ActivateCheat($969164,Cheat$)
			Case "IOWDLAC"
				ActivateCheat($969151,Cheat$)
			Case "JHJOECW"
				ActivateCheat($969161,Cheat$)
			Case "JQNTDMH"
				SpawnVehicle(505)
			Case "JUMPJET"
				SpawnVehicle(520)
			Case "KANGAROO"
				ActivateCheat($96916C,Cheat$)
			Case "KGGGDKP"
				SpawnVehicle(539)
			Case "KJKSZPJ"
				CallProcessFunction($00438890)
				DisplayMessage(ReplaceString(Language("Weapon set %1 spawned"),"%1","2",1),#DisplayMessage_LeftTop)
			Case "LASTPLACE"
				X=PeekF(GlobalData\LastPlaceBuffer)
				Y=PeekF(GlobalData\LastPlaceBuffer+4)
				Z=PeekF(GlobalData\LastPlaceBuffer+8)
				SetPosition(X,Y,Z,GlobalData\LastPlaceBuffer)
			Case "LASTSPAWNEDVEHICLES"
				Text$=""
				OpenPreferences(Common\InstallPath+"Vehicles.ini")
				For Vehicle=1 To 9
					VehicleID=LastVehicle(Vehicle)
					If VehicleID=>400 And VehicleID<=611
						If Text$
							Text$+"~n~"
						EndIf
					EndIf
					Text$+Str(Vehicle)+" "+Trim(ReadPreferenceString(Str(VehicleID),Str(LastVehicle(Vehicle))))
				Next
				ClosePreferences()
				DisplayMessage(Text$,#DisplayMessage_LeftTop)
			Case "LIFEINWATER"
				ActivateCheat($6C2759,Cheat$)
			Case "LIYOAAY"
				CallProcessFunction($00438FC0)
			Case "LLQPFBN"
				ActivateCheat($969150,Cheat$)
			Case "LOADINTERIOR"
				ID=Val(CheatPar$)
				If ID=>0 And ID<=18
					LoadInterior(ID)
					DisplayMessage(ReplaceString(Language("Interior loaded: %1"),"%1","~r~"+Interior(ID)+"~s~",1),#DisplayMessage_LeftTop)
				Else
					DisplayMessage(ReplaceString(Language("Invalid interior ID!"),"%1",Str(ID),1),#DisplayMessage_LeftTop)
					CheatSent=#False
				EndIf
			Case "LOADPLACE"
				ID=Val(CheatPar$)
				If ID=>1 And ID<=10
					SetPosition(Direct(ID-1)\X,Direct(ID-1)\Y,Direct(ID-1)\Z,GlobalData\LastPlaceBuffer)
					DisplayMessage(ReplaceString(Language("Teleported to place %1"),"%1","~r~"+Str(ID)+"~s~",1),#DisplayMessage_LeftTop)
				Else
					CheatSent=#False
				EndIf
			Case "LOADVEHICLE"
					ID=Val(CheatPar$)
				If ID=>1 And ID<=10
					SpawnVehicle(Direct(ID-1)\VehicleID)
				Else
					CheatSent=#False
				EndIf
			Case "LOCKVEHICLE"
				CPED=ReadProcessValue($B6F5F0,#PB_Long)
				CVehicle=ReadProcessValue($B6F980,#PB_Long)
				If CPED=CVehicle Or CVehicle=0
					If CPED
						CVehicle=ReadProcessValue(PED+$58C,#PB_Long)
					EndIf
				EndIf
				If CVehicle
					If ReadProcessValue(CVehicle+1272,#PB_Long)=1
						WriteProcessValue(CVehicle+1272,2,#PB_Long)
						DisplayMessage(Language("Vehicle doors locked"),#DisplayMessage_LeftTop)
					Else
						WriteProcessValue(CVehicle+1272,1,#PB_Long)
						DisplayMessage(Language("Vehicle doors unlocked"),#DisplayMessage_LeftTop)
					EndIf
				Else
					CheatSent=#False
				EndIf
			Case "LXGIWYL"
				CallProcessFunction($004385B0)
				DisplayMessage(ReplaceString(Language("Weapon set %1 spawned"),"%1","1",1),#DisplayMessage_LeftTop)
			Case "MAKESCREENSHOT"
				File$=Trim(MakeScreenshot())
				If File$
					DisplayMessage(ReplaceString(Language("Screenshot created (%1)"),"%1","~r~"+GetFilePart(File$)+"~s~",1),#DisplayMessage_LeftTop)
				Else
					CheatSent=#False
				EndIf
			Case "MOONSIZE"
				WriteProcessValue($8D4B60,Val(CheatPar$),#PB_Long)
				DisplayMessage(ReplaceString(Language("Moon size changed to factor %1"),"%1",Str(Val(CheatPar$)),1),#DisplayMessage_LeftTop)
			Case "OGXSDAG"
				ActivateCheat($96917F,Cheat$)
			Case "OHDUDE"
				SpawnVehicle(425)
			Case "OSRBLHH"
				CallProcessFunction($00438E90)
			Case "OUIQDMW"
				ActivateCheat($969179,Cheat$)
			Case "PGGOMOY"
				ActivateCheat($96914C,Cheat$)
			Case "PPGWJHT"
				CallProcessFunction($00438F90)
			Case "RANDOMVEHICLE"
				SpawnVehicle(RandomEx(400,611))
			Case "RANDOMWEATHER"
				SetCurrentWeather(#PB_Any)
			Case "RIPAZHA"
				ActivateCheat($969160,Cheat$)
			Case "ROCKETMAN"
				CallProcessFunction($00439600)
				DisplayMessage(Language("Jet pack spawned"),#DisplayMessage_LeftTop)
			Case "SAVEPLACE"
				CheatSent=#False
				PED=ReadProcessValue($B6F3B8,#PB_Long)
				If PED
					Pool=ReadProcessValue(PED+20,#PB_Long)
					If Pool
						ID=Val(CheatPar$)
						If ID=>1 And ID<=10
							Direct(ID-1)\X=ReadProcessFloat(Pool+48)
							Direct(ID-1)\Y=ReadProcessFloat(Pool+52)
							Direct(ID-1)\Z=ReadProcessFloat(Pool+56)
							DisplayMessage(ReplaceString(Language("Current place saved to slot %1"),"%1",Str(ID),1),#DisplayMessage_LeftTop)
							CheatSent=#True
						EndIf
					EndIf
				EndIf
			Case "SAVEVEHICLE"
				PED=ReadProcessValue($B6F3B8,#PB_Long)
				VehicleID=ReadProcessValue(PED+34,#PB_Word)
				ID=Val(CheatPar$)
				If VehicleID=>400 And VehicleID<=611
					If ID=>1 And ID<=ID
						Direct(ID-1)\VehicleID=VehicleID
						DisplayMessage(ReplaceString(Language("Current vehicle saved to slot %1"),"%1",Str(ID),1),#DisplayMessage_LeftTop)
					EndIf
				Else
					DisplayMessage(Language("You are not in a vehicle!"),#DisplayMessage_LeftTop)
					CheatSent=#False
				EndIf
			Case "SCROLLVEHICLE"
				If Not GlobalData\ScrollVehicle Or GlobalData\JustActivateCheat
					GlobalData\ScrollVehicle=#True
					DisplayMessage(Language("ScrollVehicle activated"),#DisplayMessage_LeftTop)
				Else
					GlobalData\ScrollVehicle=#False
					DisplayMessage(Language("ScrollVehicle deactivated"),#DisplayMessage_LeftTop)
				EndIf
			Case "SETCASH"
				Money=Val(CheatPar$)
				WriteProcessValue($B7CE50,Money,#PB_Long)
				DisplayMessage(ReplaceString(Language("Money set to $%1"),"%1",Str(Money)+"$",1),#DisplayMessage_LeftTop)
			Case "SETTIME"
				If IsThread(GlobalData\ShowCurrentTime)
					GlobalData\ShowCurrentTime=#False
				EndIf
				WriteProcessValue($969168,0,#PB_Byte)
				TimeCode$=RSet(Trim(CheatPar$),4,"0")
				Hour$=Mid(TimeCode$,0,2)
				Minute$=Mid(TimeCode$,3,2)
				WriteProcessValue($B70153,Val(Hour$),#PB_Byte)
				WriteProcessValue($B70152,Val(Minute$),#PB_Byte)
				DisplayMessage(ReplaceString(ReplaceString(Language("Clock set to %hh:%mm"),"%hh",Hour$,1),"%mm",Minute$,1),#DisplayMessage_LeftTop)
			Case "SETWANTEDLEVEL"
				Level=Val(CheatPar$)
				If Level=>0 And Level<=6
					SetWantedLevel(Level)
					DisplayMessage(ReplaceString(Language("Wanted level set to level %1"),"%1",Str(Level),1),#DisplayMessage_LeftTop)
				Else
					CheatSent=#False
				EndIf
			Case "SETWEATHER"
				SetCurrentWeather(Val(CheatPar$))
			Case "SHOWCURRENTTIME"
				If Not GlobalData\ShowCurrentTime Or GlobalData\JustActivateCheat
					GlobalData\ShowCurrentTime=#True
					DisplayMessage(Language("Time synchronization activated"),#DisplayMessage_LeftTop)
				Else
					GlobalData\ShowCurrentTime=#False
					WriteProcessValue($969168,0,#PB_Byte)
					DisplayMessage(Language("Time synchronization deactivated"),#DisplayMessage_LeftTop)
				EndIf
			Case "SHOWHEIGHTINFO"
				If Not GlobalData\ShowHeightInfo Or GlobalData\JustActivateCheat
					GlobalData\ShowHeightInfo=#True
					DisplayMessage(Language("High information display activated"),#DisplayMessage_LeftTop)
				Else
					GlobalData\ShowHeightInfo=#False
					DisplayMessage(Language("High information display deactivated"),#DisplayMessage_LeftTop)
				EndIf
			Case "SHOWMONEYNOW"
				WriteProcessValue($B7CE54,ReadProcessValue($B7CE50,#PB_Long),#PB_Long)
			Case "SHOWVEHICLEINFO"
				If Not GlobalData\ShowVehicleInfo Or GlobalData\JustActivateCheat
					GlobalData\ShowVehicleInfo=#True
					GlobalData\ShowVehicleInfo_Damage=CreateTextZone()
					GlobalData\ShowVehicleInfo_Speed=CreateTextZone()
					*Damage.GTA_TextZone=GlobalData\ShowVehicleInfo_Damage
					*Damage\X=Config\TextZone_VehicleDamageX
					*Damage\Y=Config\TextZone_VehicleDamageY
					*Damage\Font=1
					*Damage\gxt1=1112364366
					*Damage\gxt2=21061
					*Damage\Proportional=1
					*Damage\TextWidth=1
					*Damage\TextHeight=1.5
					*Damage\TextColor=Config\TextZone_VehicleDamageColor
					*Damage\ShadeType=1
					*Speed.GTA_TextZone=GlobalData\ShowVehicleInfo_Speed
					*Speed\X=Config\TextZone_VehicleSpeedX
					*Speed\Y=Config\TextZone_VehicleSpeedY
					*Speed\Font=1
					*Speed\gxt1=1112364366
					*Speed\gxt2=21061
					*Speed\Proportional=1
					*Speed\TextWidth=1
					*Speed\TextHeight=1.5
					*Speed\TextColor=Config\TextZone_VehicleSpeedColor
					*Speed\ShadeType=1
					DisplayTextZone(*Damage,#TextZone_VehicleDamage)
					DisplayTextZone(*Speed,#TextZone_VehicleSpeed)
					DisplayMessage(Language("Vehicle information display activated"),#DisplayMessage_LeftTop)
				Else
					FreeTextZone(GlobalData\ShowVehicleInfo_Damage,#TextZone_VehicleDamage)
					FreeTextZone(GlobalData\ShowVehicleInfo_Speed,#TextZone_VehicleSpeed)
					GlobalData\ShowVehicleInfo=#False
					DisplayMessage(Language("Vehicle information display deactivated"),#DisplayMessage_LeftTop)
				EndIf
			Case "SPAWNVEHICLE"
				ID=Val(CheatPar$)
				If ID>0
					SpawnVehicle(ID)
				Else
					If GlobalData\SpawnVehicle
						GlobalData\SpawnVehicle=#False
						FreeTextZone(GlobalData\SpawnVehicle_Memory,#TextZone_SpawnVehicleEx)
						DisplayMessage(Language("Advanced vehicle spawning deactivated"),#DisplayMessage_LeftTop)
					Else
						*SpawnVehicle.GTA_TextZone=CreateTextZone()
						*SpawnVehicle\X=Config\TextZone_SpawnVehicleX
						*SpawnVehicle\Y=Config\TextZone_SpawnVehicleY
						*SpawnVehicle\Font=1
						*SpawnVehicle\gxt1=1112364366
						*SpawnVehicle\gxt2=21061
						*SpawnVehicle\Proportional=1
						*SpawnVehicle\TextWidth=1
						*SpawnVehicle\TextHeight=1.5
						*SpawnVehicle\TextColor=Config\TextZone_SpawnVehicleColor
						*SpawnVehicle\ShadeType=1
						For Key=#VK_0 To #VK_9
							GetAsyncKeyState_(Key)
						Next
						GlobalData\SpawnVehicle_Num="000"
						GlobalData\SpawnVehicle_OldNum="000"
						GlobalData\SpawnVehicle_Memory=*SpawnVehicle
						GlobalData\SpawnVehicle=#True
						DisplayMessage(Language("Advanced vehicle spawning activated"),#DisplayMessage_LeftTop)
					EndIf
				EndIf
			Case "SPAWNWEAPON"
				SpawnWeapon(Val(CheatPar$))
			Case "STATEOFEMERGENCY"
				ActivateCheat($969175,Cheat$)
			;Case "SZCMAWO"
				; Coming soon
			Case "TELEPORTTO"
				For Pos=0 To GlobalData\TeleportListCount-1
					If TeleportPlace(Pos)\ID=Val(CheatPar$)
						LoadInterior(TeleportPlace(Pos)\Interior)
						SetPosition(TeleportPlace(Pos)\X,TeleportPlace(Pos)\Y,TeleportPlace(Pos)\Z,GlobalData\LastPlaceBuffer)
						PlaceFound=#True
						Break
					EndIf
				Next
				If Not PlaceFound
					CheatSent=#False
				EndIf
			Case "TOGGLEWEAPONSLOTS"
				Slot1=Val(StringField(CheatPar$,1,","))
				Slot2=Val(StringField(CheatPar$,2,","))
				If Slot1=Slot2
					DisplayMessage(Language("Slot 1 is the same as slot 2!"),#DisplayMessage_LeftTop)
					CheatSent=#False
				Else
					If GlobalData\ToggleWeaponSlots_Current=1
						GlobalData\ToggleWeaponSlots_Current=2
						WriteProcessValue($B7CDBC,Slot1,#PB_Long)
						DisplayMessage(ReplaceString(ReplaceString(Language("Switched to slot %1 (#%2)"),"%1","1",1),"%2",Str(Slot1),1),#DisplayMessage_LeftTop)
					Else
						GlobalData\ToggleWeaponSlots_Current=1
						WriteProcessValue($B7CDBC,Slot2,#PB_Long)
						DisplayMessage(ReplaceString(ReplaceString(Language("Switched to slot %1 (#%2)"),"%1","2",1),"%2",Str(Slot2),1),#DisplayMessage_LeftTop)
					EndIf
				EndIf
			Case "URKQSRK"
				SpawnVehicle(513)
			Case "UZUMYMW"
				CallProcessFunction($00438B30)
				DisplayMessage(ReplaceString(Language("Weapon set %1 spawned"),"%1","3",1),#DisplayMessage_LeftTop)
			Case "WANRLTW"
				ActivateCheat($969178,Cheat$)
			Case "XICWMD"
				ActivateCheat($96914B,Cheat$)
			Case "YLTEICZ"
				ActivateCheat($96914F,Cheat$)
			Case "YSOHNUL"
				ActivateCheat($96913B,Cheat$)
			Case "ZEIIVG"
				ActivateCheat($96914E,Cheat$)
			Case "ZSOXFSQ"
				ActivateCheat($96917E,Cheat$)
			Default
				DisplayMessage(ReplaceString(Language("Send cheat: %1"),"%1","~r~"+Cheat$+"~s~",1),#DisplayMessage_LeftTop)
				Delay(500)
				For Key=1 To Len(Cheat$)
					SendKey(Asc(UCase(Mid(Cheat$,Key,1))))
				Next
		EndSelect
	EndIf
	ProcedureReturn CheatSent
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 560
; FirstLine = 557
; Folding = -
; EnableXP
; EnableCompileCount = 0
; EnableBuildCount = 0
; EnableExeConstant