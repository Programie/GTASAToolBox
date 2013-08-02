Enumeration;- Enumeration
	#RunOnlyOnceCheckWindow
	#Window
	#CheatServer
	#Tray
	#Menu
	#Menu_ReloadAll
	#Menu_ReportBug
	#Menu_RestoreGTASA
EndEnumeration

Enumeration;- TextZone-Enumeration
	#TextZone_Timer
	#TextZone_SpawnVehicleEx
	#Reserved2
	#Reserved3
	#Reserved4
	#Reserved5
	#Reserved6
	#Reserved7
	#Reserved8
	#Reserved9
	#Reserved10
	#Reserved11
	#Reserved12
	#Reserved13
	#Reserved14
	#Reserved15
	#Reserved16
	#Reserved17
	#Reserved18
	#Reserved19
	#Reserved20
	#Reserved21
	#Reserved22
	#Reserved23
	#Reserved24
	#Reserved25
	#Reserved26
	#Reserved27
	#Reserved28
	#Reserved29
	#Reserved30
	#Reserved31
	#Reserved32
	#Reserved33
	#Reserved34
	#Reserved35
	#Reserved36
	#Reserved37
	#Reserved38
	#Reserved39
	#TextZone_VehicleDamage
	#TextZone_VehicleSpeed
EndEnumeration

Enumeration
	#DisplayMessage_LeftTop
	#DisplayMessage_MiddleBottom
EndEnumeration

Structure Config;- Structure, Config
	UserPath.s
	TempPath.s
	DisplayMessages.l
	Language.s
	ImageType.s
	DisableGTASplash.b
	CheatServerPort.l
	UseCheatSound.l
	CheatSound.s
	Key_OSDUp.l
	Key_OSDDown.l
	Key_SpawnVehicleEx.l
	Key_ScrollVehicleUp.l
	Key_ScrollVehicleDown.l
	TextZone_VehicleDamageX.f
	TextZone_VehicleDamageY.f
	TextZone_VehicleDamageColor.l
	TextZone_VehicleSpeedX.f
	TextZone_VehicleSpeedY.f
	TextZone_VehicleSpeedColor.l
	TextZone_TimerX.f
	TextZone_TimerY.f
	TextZone_TimerColor.l
	TextZone_SpawnVehicleX.f
	TextZone_SpawnVehicleY.f
	TextZone_SpawnVehicleColor.l
	CheatListCount.l
	TeleportListCount.l
	UsedKeys.l
	LastCheatIndex.l
	LastCheat.s
	FreezeTaxiTimer.l
	InfiniteHealth.l
	InfiniteNitro.l
	ShowCurrentTime.l
	GotoTargetPlace.l
	CarColor_VehicleID.l
	CarColor_Color.l
	ScrollVehicle.l
	ScrollVehicle_VehicleID.l
	ScrollVehicle_Pressed.b
	ShowHeightInfo.l
	ShowVehicleInfo.l
	ShowVehicleInfo_Damage.l
	ShowVehicleInfo_Speed.l
	SpawnVehicle_Memory.l
	SpawnVehicle_Num.s
	SpawnVehicle_OldNum.s
	SpawnVehicle_KeyPressed.l
	SpawnVehicle.l
	ToggleWeaponSlots_Current.b
	HigherProcessPriority.b
	LastVehicle.l
	PlaySound.l
	TransferCheat.l
	LastPlaceBuffer.l
	SendStartupCheats.b
	DisplayMessage_LeftTop.l
	JustActivateCheat.b
	Quit.l
EndStructure

Structure Vehicle;- Structure, Vehicle
	Name.s
	ModelName.s
	Colors.s
	Radio.b
EndStructure

Structure Weapon;- Structure, Weapon
	ID.l
	Name.s
	Slot.l
	AmmoClip.l
	TotalAmmo.l
EndStructure

Structure TeleportPlace;- Structure, TeleportPlace
	ID.l
	Interior.l
	X.f
	Y.f
	Z.f
EndStructure

Structure Direct;- Structure, Direct
	X.f
	Y.f
	Z.f
	VehicleID.l
EndStructure

Structure LanguageStrings;- Structure, LanguageStrings
	English.s
	Translation.s
EndStructure

#MaxWeapons=46
#Title="GTA San Andreas ToolBox CheatProcessor"

Global Config.Config
Global x.f,y.f,z.f
Global Dim Cheat.s(0)
Global Dim Shortcut.c(3,0)
Global Dim Vehicle.Vehicle(211)
Global Dim Weapon.Weapon(#MaxWeapons)
Global Dim TeleportPlace.TeleportPlace(0)
Global Dim Direct.Direct(9)
Global Dim Interior.s(18)
Global Dim LastVehicle(8)
Global NewList LanguageStrings.LanguageStrings()
Global NewList AutoCheats.s()

IncludeFile "Includes\Common.pbi"

Procedure.s Language(String$)
	If ListSize(LanguageStrings())
		ForEach LanguageStrings()
			If LanguageStrings()\English=String$
				ProcedureReturn LanguageStrings()\Translation
			EndIf
		Next
	EndIf
	ProcedureReturn String$
EndProcedure

Procedure LoadSettings()
	OpenPreferences(Common\ConfigPath+"Settings.ini")
		PreferenceGroup("General")
			Config\DisplayMessages=ReadPreferenceLong("DisplayMessages",#True)
			Config\Language=ReadPreferenceString("Language","en")
			Config\DisableGTASplash=ReadPreferenceLong("DisableGTASplash",#False)
			Config\ImageType=ReadPreferenceString("ImageType","jpg")
			Config\CheatServerPort=ReadPreferenceLong("CheatServerPort",8476)
			Config\HigherProcessPriority=ReadPreferenceLong("HigherProcessPriority",#True)
		PreferenceGroup("CheatProcessor_TextZone")
			Config\TextZone_VehicleDamageX=ReadPreferenceFloat("VehicleDamageX",10)
			Config\TextZone_VehicleDamageY=ReadPreferenceFloat("VehicleDamageY",50)
			Config\TextZone_VehicleDamageColor=ReadPreferenceLong("VehicleDamageColor",4281537023)
			Config\TextZone_VehicleSpeedX=ReadPreferenceFloat("VehicleSpeedX",10)
			Config\TextZone_VehicleSpeedY=ReadPreferenceFloat("VehicleSpeedY",10)
			Config\TextZone_VehicleSpeedColor=ReadPreferenceLong("VehicleSpeedColor",4281537023)
			Config\TextZone_TimerX=ReadPreferenceFloat("TimerX",10)
			Config\TextZone_TimerY=ReadPreferenceFloat("TimerY",130)
			Config\TextZone_TimerColor=ReadPreferenceLong("TimerColor",4281537023)
			Config\TextZone_SpawnVehicleX=ReadPreferenceFloat("SpawnVehicleX",10)
			Config\TextZone_SpawnVehicleY=ReadPreferenceFloat("SpawnVehicleY",90)
			Config\TextZone_SpawnVehicleColor=ReadPreferenceLong("SpawnVehicleColor",4281537023)
		PreferenceGroup("CheatSound")
			Config\UseCheatSound=ReadPreferenceLong("Use",#True)
			Config\CheatSound=ReadPreferenceString("Sound","Sounds\Cheat1.wav")
		PreferenceGroup("CheatProcessor_SpecialKeys")
			Config\Key_OSDUp=ReadPreferenceLong("OSDUp",#VK_UP)
			Config\Key_OSDDown=ReadPreferenceLong("OSDDown",#VK_DOWN)
			Config\Key_SpawnVehicleEx=ReadPreferenceLong("SpawnVehicleEx",#VK_CONTROL)
			Config\Key_ScrollVehicleUp=ReadPreferenceLong("ScrollVehicleUp",#VK_NUMPAD9)
			Config\Key_ScrollVehicleDown=ReadPreferenceLong("ScrollVehicleDown",#VK_NUMPAD3)
	ClosePreferences()
EndProcedure

Procedure ReloadVehicleList()
 File=ReadFile(#PB_Any,Common\ConfigPath+"Vehicles.cfg")
  If IsFile(File)
   Repeat
    String$=Trim(StringField(ReadString(File),1,";"))
     If String$
      VehicleID=Val(StringField(String$,1,Chr(9)))
       If VehicleID=>400 And VehicleID<=611
        Vehicle(VehicleID-400)\Radio=Val(StringField(String$,2,Chr(9)))
        Vehicle(VehicleID-400)\Name=Trim(StringField(String$,3,Chr(9)))
       EndIf
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
 File=ReadFile(#PB_Any,GetPathPart(Common\GTAFile)+"data\vehicles.ide")
  If IsFile(File)
   ReadNow=#False
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>"#"
      Select LCase(String$)
       Case "cars"
        ReadNow=#True
       Case "end"
        ReadNow=#False
       Default
        VehicleID=Val(Trim(StringField(String$,1,",")))
         If VehicleID=>400 And VehicleID<=611
          Vehicle(VehicleID-400)\ModelName=Trim(RemoveString(RemoveString(StringField(String$,2,","),Chr(9),1),Chr(10),1))
         EndIf
      EndSelect
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
 File=ReadFile(#PB_Any,GetPathPart(Common\GTAFile)+"data\carcols.dat")
  If IsFile(File)
   ReadNow=#False
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>"#"
      Select LCase(String$)
       Case "car"
        ReadNow=#True
       Case "end"
        ReadNow=#False
       Default
        If ReadNow
         For Vehicle=400 To 611
          If LCase(Vehicle(Vehicle-400)\ModelName)=LCase(Trim(StringField(String$,1,",")))
           Vehicle(Vehicle-400)\Colors=Trim(Mid(String$,FindString(String$,",",0)+1))
          EndIf
         Next
        EndIf
      EndSelect
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
EndProcedure

Procedure ReloadCheatlist()
	File=ReadFile(#PB_Any,Common\ConfigPath+"Cheats.dat")
	If IsFile(File)
		Config\CheatListCount=0
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				Shortcut$=Trim(StringField(String$,3,Chr(9)))
				If Shortcut$
					Config\CheatListCount+1
				EndIf
			EndIf
		Until Eof(File)
		FileFound=#True
	EndIf
	ReDim Cheat.s(Config\CheatListCount)
	ReDim Shortcut.c(3,Config\CheatListCount)
	If FileFound
		FileSeek(File,0)
		Count=1
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				Shortcut$=Trim(StringField(String$,3,Chr(9)))
				If Shortcut$
					Cheat(Count)=Trim(StringField(String$,1,Chr(9)))
					For Index=0 To 3
						Shortcut(Index,Count)=#False
					Next
					For Index=1 To 4
						KeyCode=Val(StringField(Shortcut$,Index,"+"))
						Select KeyCode
							Case #VK_CONTROL,#VK_LCONTROL,#VK_RCONTROL
								Shortcut(0,Count)=#True
							Case #VK_SHIFT,#VK_LSHIFT,#VK_RSHIFT
								Shortcut(1,Count)=#True
							Case #VK_MENU,#VK_LMENU,#VK_RMENU
								Shortcut(2,Count)=#True
							Case 0
							Default
								Shortcut(3,Count)=KeyCode
						EndSelect
					Next
					Count+1
				EndIf
			EndIf
		Until Eof(File)
		CloseFile(File)
	EndIf
EndProcedure

Procedure ReloadTeleportlist()
	File=ReadFile(#PB_Any,Common\InstallPath+"Teleporter.dat")
	If IsFile(File)
		Config\TeleportListCount=0
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				Config\TeleportListCount+1
			EndIf
		Until Eof(File)
		FileSeek(File,0)
		ReDim TeleportPlace.TeleportPlace(Config\TeleportListCount)
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				TeleportPlace(Count)\ID=Val(StringField(String$,1,Chr(9)))
				TeleportPlace(Count)\X=ValF(StringField(String$,3,Chr(9)))
				TeleportPlace(Count)\Y=ValF(StringField(String$,4,Chr(9)))
				TeleportPlace(Count)\Z=ValF(StringField(String$,5,Chr(9)))
				Interior$=Trim(StringField(String$,6,Chr(9)))
				If Interior$
					TeleportPlace(Count)\Interior=Val(Interior$)
				Else
					TeleportPlace(Count)\Interior=-1
				EndIf
				Count+1
			EndIf
		Until Eof(File)
		CloseFile(File)
	EndIf
EndProcedure

Procedure ReloadInteriors()
 OpenPreferences(Common\InstallPath+"Interiors.ini")
  For ID=0 To 18
   Name$=Trim(ReadPreferenceString(Str(ID),""))
    If Name$=""
     Name$=Str(ID)
    EndIf
   Interior(ID)=Name$
  Next
 ClosePreferences()
EndProcedure

Procedure ReloadWeaponConfig()
	File=ReadFile(#PB_Any,Common\ConfigPath+"Weapons.cfg")
	If IsFile(File)
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				Weapon=Val(StringField(String$,1,Chr(9)))
				Weapon(Weapon)\Name=StringField(String$,2,Chr(9))
				Weapon(Weapon)\ID=Val(StringField(String$,3,Chr(9)))
				Weapon(Weapon)\Slot=Val(StringField(String$,4,Chr(9)))
				Weapon(Weapon)\AmmoClip=Val(StringField(String$,5,Chr(9)))
				Weapon(Weapon)\TotalAmmo=Val(StringField(String$,6,Chr(9)))
			EndIf
		Until Eof(File)
		CloseFile(File)
	EndIf
EndProcedure

Procedure ReloadAutoCheats()
	ClearList(AutoCheats())
	File=ReadFile(#PB_Any,Common\ConfigPath+"AutoCheats.dat")
	If IsFile(File)
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				AddElement(AutoCheats())
				AutoCheats()=String$
			EndIf
		Until Eof(File)
		CloseFile(File)
	EndIf
EndProcedure

Procedure UpdateSysTrayToolTip()
	SysTrayIconToolTipEx(#Tray,WindowID(#Window),GetWindowTitle(#Window)+Chr(13)+"Cheats: "+Str(Config\CheatListCount)+Chr(13)+Language("Automatically activated cheats")+": "+Str(ListSize(AutoCheats()))+Chr(13)+Language("Last used cheat")+": "+Config\LastCheat)
EndProcedure

Procedure HideGame(State)
  If Common\GTASA_WindowID
   Select State
    Case 1
     ShowWindow_(Common\GTASA_WindowID,#SW_MINIMIZE)
     ShowWindow_(Common\GTASA_WindowID,#SW_HIDE)
    Case 0
     ShowWindow_(Common\GTASA_WindowID,#SW_SHOW)
     ShowWindow_(Common\GTASA_WindowID,#SW_RESTORE)
    Case -1
     ProcedureReturn IsWindowVisible_(Common\GTASA_WindowID)
   EndSelect
  EndIf
EndProcedure

Procedure WindowCallback(WindowID,Message,wParam,lParam)
	Select Message
		Case #WM_QUERYENDSESSION; Windows is logging off or shutting down
			Config\Quit=#True
		Case #WM_NOTIFYICON; The user clicked on the systray icon
			Select lParam
				Case #WM_LBUTTONDOWN,#WM_RBUTTONDOWN
					If CreatePopupMenu(#Menu)
						MenuItem(#Menu_ReloadAll,Language("Reload data"))
							MenuBar()
						MenuItem(#Menu_ReportBug,Language("Report bug"))
							MenuBar()
						If Common\GTASA_WindowID
							If HideGame(-1)
								MenuItem(#Menu_RestoreGTASA,Language("Restore GTA San Andreas"))
									MenuBar()
							EndIf
						EndIf
						DisplayPopupMenu(#Menu,WindowID(#Window))
					EndIf
			EndSelect
		Case Common\ExplorerMsg; Explorer (re)started... so rebuild the systray icon
			RemoveSysTrayIconEx(#Tray,WindowID(#Window))
			If AddSysTrayIconEx(#Tray,WindowID(#Window),ExtractIcon_(0,ProgramFilename(),0))
				UpdateSysTrayToolTip()
			EndIf
	EndSelect
	ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure IsDirectoryEx(Path$)
	Directory=ExamineDirectory(#PB_Any,Path$,"*.*")
	If IsDirectory(Directory)
		FinishDirectory(Directory)
		ProcedureReturn #True
	EndIf
EndProcedure

Procedure CreateDirectorys()
	CreateDirectoryEx(Config\UserPath+"Gallery\")
	CreateDirectoryEx(Config\UserPath+"User Tracks\")
	CreateDirectoryEx(Config\TempPath)
EndProcedure

Procedure DisplayMessage(Text$,Type)
	If Config\DisplayMessages
		Text$=ReplaceString(Text$,"ä",Chr(154))
		Text$=ReplaceString(Text$,"Ä",Chr(131))
		Text$=ReplaceString(Text$,"ö",Chr(168))
		Text$=ReplaceString(Text$,"Ö",Chr(145))
		Text$=ReplaceString(Text$,"ü",Chr(172))
		Text$=ReplaceString(Text$,"Ü",Chr(149))
		Text$=ReplaceString(Text$,"ß",Chr(150))
		Select Type
			Case #DisplayMessage_LeftTop
				Config\DisplayMessage_LeftTop=5000
				WriteProcessString($BAA7A0,LSet(Text$,255,Chr(0)))
			Case #DisplayMessage_MiddleBottom
				WriteProcessString($BAB040,LSet(Text$,255,Chr(0)))
		EndSelect
	EndIf
EndProcedure

Procedure.s CheckValidFile(SyntaxFile$,StartCount)
	If FindString(SyntaxFile$,"*",0)
		Repeat
			File$=ReplaceString(SyntaxFile$,"*",Str(StartCount),#PB_String_NoCase)
			If Not IsFileEx(File$)
				ProcedureReturn File$
			EndIf
			StartCount+1
		ForEver
	Else
		ProcedureReturn SyntaxFile$
	EndIf
EndProcedure

Procedure CaptureScreen(FileName$,ImageType,Flags)
	ScreenDM.DEVMODE
	Width=GetSystemMetrics_(#SM_CXSCREEN)
	Height=GetSystemMetrics_(#SM_CYSCREEN)
	ScreenDC=CreateDC_("DISPLAY","","",ScreenDM)
	DC=CreateCompatibleDC_(ScreenDC)
	ImageID=CreateCompatibleBitmap_(ScreenDC,Width,Height)
	SelectObject_(DC,ImageID)
	BitBlt_(DC,0,0,Width,Height,ScreenDC,0,0,#SRCCOPY)
	DeleteDC_(DC)
	ReleaseDC_(ImageID,ScreenDC)
	If ImageID
		Image=CreateImage(#PB_Any,Width,Height)
		If IsImage(Image)
			If StartDrawing(ImageOutput(Image))
				DrawImage(ImageID,0,0)
				StopDrawing()
			EndIf
			ProcedureReturn SaveImage(Image,FileName$,ImageType,Flags)
		EndIf
	EndIf
EndProcedure

Procedure SendNetworkResponseString(ClientID,ResultCode,String$)
	Size=StringByteLength(String$)
	SendNetworkData(ClientID,@ResultCode,1)
	SendNetworkData(ClientID,@Size,4)
	SendNetworkData(ClientID,@String$,Size)
EndProcedure

Procedure SendNetworkResult(ClientID,ResultCode)
	SendNetworkData(ClientID,@ResultCode,1)
EndProcedure

Procedure SpawnVehicle(VehicleID)
	If VehicleID=>400 And VehicleID<=611
		If VehicleID=449 Or VehicleID=537 Or VehicleID=538 Or VehicleID=569 Or VehicleID=570 Or VehicleID=590
			DisplayMessage(Language("This vehicle has been blocked!")+" (ID: ~r~"+Str(VehicleID)+"~s~)",#DisplayMessage_LeftTop)
		Else
			WriteProcessValue($01301000,VehicleID,#PB_Word)
			DisplayMessage(Language("Spawned vehicle")+": ~r~"+Vehicle(VehicleID-400)\Name+"~s~ (~r~"+Str(VehicleID)+"~s~)",#DisplayMessage_LeftTop)
		EndIf
	EndIf
EndProcedure

Procedure SpawnWeapon(Weapon)
	Slot=Weapon(Weapon)\Slot
	PED=ReadProcessValue($B6F3B8,#PB_Long)
	Offset=PED+$5A0+Slot*28
	WriteProcessValue(Offset,Weapon,#PB_Long)
	WriteProcessValue(Offset+4,0,#PB_Long)
	WriteProcessValue(Offset+8,ReadProcessValue(Offset+8,#PB_Long)+Weapon(Weapon)\AmmoClip,#PB_Long)
	WriteProcessValue(Offset+12,ReadProcessValue(Offset+12,#PB_Long)+Weapon(Weapon)\TotalAmmo,#PB_Long)
	WriteProcessValue($1301004+Slot*4,Weapon(Weapon)\ID,#PB_Long)
	DisplayMessage(Language("Spawned weapon")+": ~r~"+Weapon(Weapon-400)\Name+"~s~ (~r~"+Str(Weapon)+"~s~)",#DisplayMessage_LeftTop)
EndProcedure

Procedure.s MakeScreenshot()
	TmpFile$=Config\TempPath+"Screen.tmp"
	Path$=Config\UserPath+"Gallery\"
	Radar=ReadProcessValue($BA676C,#PB_Byte)
	HUD=ReadProcessValue($BA6769,#PB_Byte)
	WriteProcessValue($BA676C,2,#PB_Byte)
	WriteProcessValue($BA6769,0,#PB_Byte)
	Repeat
		Delay(100)
		TimeOut+1
		If ReadProcessValue($BA676C,#PB_Byte)=2 And Not ReadProcessValue($BA6769,#PB_Byte)
			Do=#True
		EndIf
		If TimeOut=20
			Do=#True
		EndIf
	Until Do
	DisplayMessage("",#DisplayMessage_LeftTop)
	DisplayMessage("",#DisplayMessage_MiddleBottom)
	Select LCase(Config\ImageType)
		Case "bmp"
			ImageType=#PB_ImagePlugin_BMP
		Case "jpg"
			ImageType=#PB_ImagePlugin_JPEG
		Case "png"
			ImageType=#PB_ImagePlugin_PNG
		Default
			ImageType=#PB_ImagePlugin_JPEG
			Config\ImageType="jpg"
	EndSelect
	CaptureScreen(TmpFile$,ImageType,10)
	WriteProcessValue($BA676C,Radar,#PB_Byte)
	WriteProcessValue($BA6769,HUD,#PB_Byte)
	FileName$=CheckValidFile(Path$+"ScreenShot_*."+LCase(Config\ImageType),1)
	In=ReadFile(#PB_Any,TmpFile$)
	If IsFile(In)
		Buffer=AllocateMemory(Lof(In))
		If Buffer
			ReadData(In,Buffer,Lof(In))
			PED=ReadProcessValue($B6F3B8,#PB_Long)
			Pool=ReadProcessValue(PED+20,#PB_Long)
			x.f=ReadProcessFloat(Pool+48)
			y.f=ReadProcessFloat(Pool+52)
			z.f=ReadProcessFloat(Pool+56)
			Out=CreateFile(#PB_Any,FileName$)
			If IsFile(Out)
				WriteData(Out,Buffer,Lof(In))
				WriteFloat(Out,x)
				WriteFloat(Out,y)
				WriteFloat(Out,z)
				CloseFile(Out)
			EndIf
			FreeMemory(Buffer)
		Else
			CopyFile(TmpFile$,FileName$)
		EndIf
		CloseFile(In)
	EndIf
	DeleteFile(TmpFile$)
	ProcedureReturn FileName$
EndProcedure

Procedure SetWantedLevel(Level)
 CWanted=ReadProcessValue($B7CD9C,#PB_Long)
 Select Level
  Case 1
   Cops=1
   WantedLevel=60
  Case 2
   Cops=3
   WantedLevel=200
  Case 3
   Cops=5
   WantedLevel=700
  Case 4
   Cops=9
   WantedLevel=1500
  Case 5
   Cops=15
   WantedLevel=3000
  Case 6
   Cops=25
   WantedLevel=5000
 EndSelect
 WriteProcessValue(CWanted,WantedLevel,#PB_Long)
 WriteProcessValue(CWanted+$19,Cops,#PB_Byte)
 WriteProcessValue(CWanted+$2C,Level,#PB_Byte)
EndProcedure

Procedure ActivateCheat(Offset,Cheat$)
 If Not ReadProcessValue(Offset,#PB_Byte) Or Config\JustActivateCheat
  WriteProcessValue(Offset,1,#PB_Byte)
  DisplayMessage(ReplaceString(Language("Cheat activated (%1)"),"%1","~b~"+Cheat$+"~s~",1),#DisplayMessage_LeftTop)
 Else
  WriteProcessValue(Offset,0,#PB_Byte)
  DisplayMessage(ReplaceString(Language("Cheat deactivated (%1)"),"%1","~b~"+Cheat$+"~s~",1),#DisplayMessage_LeftTop)
 EndIf
EndProcedure

Procedure GotoTargetPlace()
 If ReadProcessValue($BA6774,#PB_Byte)
  PED=ReadProcessValue($B6F3B8,#PB_Long)
  Pool=ReadProcessValue(PED+20,#PB_Long)
  usMarkerID=ReadProcessValue($BA6774,#PB_Word)&$FFFF
  usMarkerFlag=ReadProcessValue($BA6774,#PB_Word)&$FFFF>>16
  x.f=ReadProcessFloat($BA86F8+40*usMarkerID)
  y.f=ReadProcessFloat($BA86FC+40*usMarkerID)
  z.f=ReadProcessFloat(Pool+56)
  SetPosition(x,y,z,Config\LastPlaceBuffer)
  DisplayMessage(Language("You have been teleported to your target place!"),#DisplayMessage_LeftTop)
 Else
  DisplayMessage(Language("Destination not fixed!"),#DisplayMessage_LeftTop)
 EndIf
EndProcedure

Procedure SetCurrentWeather(WeatherID)
 If WeatherID=#PB_Any
  WeatherID=Random(45)
  DisplayMessage(ReplaceString(Language("Random weather (%1)"),"%1",Str(WeatherID),1),#DisplayMessage_LeftTop)
 Else
  DisplayMessage(ReplaceString(Language("Weather changed (%1)"),"%1",Str(WeatherID),1),#DisplayMessage_LeftTop)
 EndIf
 WriteProcessValue($C8131C,WeatherID,#PB_Word)
EndProcedure

Procedure RandomEx(Min,Max)
 Repeat
  Value=Random(Max)
 Until Value=>Min
 ProcedureReturn Value
EndProcedure

Procedure LoadLanguage()
	ClearList(LanguageStrings())
	OpenPreferences(Common\InstallPath+"Languages\"+Config\Language+".lang")
		PreferenceGroup("Translation")
			If ExaminePreferenceKeys()
				While NextPreferenceKey()
					AddElement(LanguageStrings())
					LanguageStrings()\English=PreferenceKeyName()
					String$=PreferenceKeyValue()
					For Char=$00 To $FF
						String$=ReplaceString(String$,"%"+RSet(Hex(Char),2,"0"),Chr(Char),#PB_String_NoCase)
					Next
					LanguageStrings()\Translation=String$
				Wend
			EndIf
	ClosePreferences()
EndProcedure

Procedure ReloadAll()
	LoadSettings()
	LoadLanguage()
	ReloadCheatlist()
	ReloadTeleportlist()
	ReloadInteriors()
	ReloadVehicleList()
	ReloadWeaponConfig()
	ReloadAutoCheats()
	HigherProcessPriority(Config\HigherProcessPriority)
	Config\SendStartupCheats=#False
EndProcedure

Procedure PlayBMF(SoundFile$)
 If LCase(GetExtensionPart(SoundFile$))="bmf"
  File=ReadFile(#PB_Any,SoundFile$)
   If IsFile(File)
    Repeat
     Frequency=ReadLong(File)
     Delay=ReadLong(File)
      If Frequency<>-1
       Beep_(Frequency,Delay)
      Else
       Delay(Delay)
      EndIf
    Until Eof(File) Or Not Config\PlaySound
    CloseFile(File)
   EndIf
 EndIf
EndProcedure

IncludeFile "Includes\SetCheat.pbi"

Procedure ProgressCheats()
	IsCheat=-1
	If GetAsyncKeyState_(#VK_CONTROL)
		Ctrl=#True
	EndIf
	If GetAsyncKeyState_(#VK_SHIFT)
		Shift=#True
	EndIf
	If GetAsyncKeyState_(#VK_MENU)
		Alt=#True
	EndIf
	For Key=#VK_A To #VK_Z
		If GetAsyncKeyState_(Key)
			AddKey=Key
		EndIf
	Next
	For Key=#VK_0 To #VK_9
		If GetAsyncKeyState_(Key)
			AddKey=Key
		EndIf
	Next
	For Key=#VK_NUMPAD0 To #VK_NUMPAD9
		If GetAsyncKeyState_(Key)
			AddKey=Key
		EndIf
	Next
	For Key=#VK_F1 To #VK_F12
		If GetAsyncKeyState_(Key)
			AddKey=Key
		EndIf
	Next
	If GetAsyncKeyState_(#VK_PRINT) Or GetAsyncKeyState_(#VK_SNAPSHOT)
		AddKey=#VK_PRINT
	EndIf
	If GetAsyncKeyState_(#VK_INSERT)
		AddKey=#VK_INSERT
	EndIf
	If GetAsyncKeyState_(#VK_PAUSE)
		AddKey=#VK_PAUSE
	EndIf
	If GetAsyncKeyState_(#VK_DELETE)
		AddKey=#VK_DELETE
	EndIf
	If GetAsyncKeyState_(#VK_HOME)
		AddKey=#VK_HOME
	EndIf
	If GetAsyncKeyState_(#VK_END)
		AddKey=#VK_END
	EndIf
	If Ctrl Or Shift Or Alt Or AddKey
		For Cheat=1 To Config\CheatListCount
			If Shortcut(0,Cheat)=Ctrl
				If Shortcut(1,Cheat)=Shift
					If Shortcut(2,Cheat)=Alt
						If Shortcut(3,Cheat)=AddKey
							IsCheat=Cheat
							Break
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		If IsCheat<>Config\LastCheatIndex
			Config\LastCheatIndex=IsCheat
			If IsCheat>0
				If GetForegroundWindow_()=Common\GTASA_WindowID And ReadProcessValue($B7CD98,#PB_Long)
					SetCheat(Cheat(IsCheat),#True)
				EndIf
			EndIf
		EndIf
	Else
		Config\LastCheatIndex=#False
	EndIf
EndProcedure

Procedure ProgressNetwork()
	Select NetworkServerEvent()
		Case #PB_NetworkEvent_Data
			ClientID=EventClient()
			String$=Space(1024)
	 		ReceiveNetworkData(ClientID,@String$,StringByteLength(String$))
	 		Parameters$=Mid(String$,FindString(String$,Chr(9),0)+1)
	 		Select LCase(Trim(StringField(String$,1,Chr(9))))
	 			Case "readmemory"
	 				If Common\GTASA_WindowID
	   				Offset=Hex2Dec(StringField(Parameters$,1,Chr(9)))
		   			Select LCase(Trim(StringField(Parameters$,2,Chr(9))))
		   				Case "byte"
		   					SendNetworkResponseString(ClientID,1,Str(ReadProcessValue(Offset,#PB_Byte)))
		   				Case "word"
		   					SendNetworkResponseString(ClientID,1,Str(ReadProcessValue(Offset,#PB_Word)))
		   				Case "long"
		   					SendNetworkResponseString(ClientID,1,Str(ReadProcessValue(Offset,#PB_Long)))
		   				Case "float"
		   					SendNetworkResponseString(ClientID,1,StrF(ReadProcessFloat(Offset)))
		   				Case "quad"
		   					SendNetworkResponseString(ClientID,1,StrD(ReadProcessFloat(Offset)))
		   				Case "string"
		   					SendNetworkResponseString(ClientID,1,ReadProcessString(Offset,Val(StringField(Parameters$,3,Chr(9)))))
		   				Case "double"
		   					SendNetworkResponseString(ClientID,1,StrD(ReadProcessFloat(Offset)))
		   				Case "character"
		   					SendNetworkResponseString(ClientID,1,Str(ReadProcessValue(Offset,#PB_Byte)))
		   				Case "array"
		   					SendNetworkResponseString(ClientID,1,ReadProcessArray(Offset,Val(StringField(Parameters$,3,Chr(9)))))
		   				Default
		   					SendNetworkResult(ClientID,2)
		   			EndSelect
		   		Else
		   			SendNetworkResult(ClientID,3)
		   		EndIf
	 			Case "reload"
	 				ReloadAll()
	 				SendNetworkResult(ClientID,1)
	  		Case "sendcheat"
	  			If Common\GTASA_WindowID
		  			If ReadProcessValue($B7CD98,#PB_Long)
	  					If SetCheat(Parameters$,#True)
	  						SendNetworkResult(ClientID,1)
	  					Else
	  						SendNetworkResult(ClientID,4)
	  					EndIf
		  			Else
		  				SendNetworkResult(ClientID,2)
		  			EndIf
	  			Else
	  				SendNetworkResult(ClientID,3)
	   			EndIf
	   		Case "writememory"
	   			If Common\GTASA_WindowID
	   				Offset=Hex2Dec(StringField(Parameters$,1,Chr(9)))
	   				Value=Val(StringField(Parameters$,3,Chr(9)))
		   			Select LCase(Trim(StringField(Parameters$,2,Chr(9))))
		   				Case "byte"
		   					WriteProcessValue(Offset,Value,#PB_Byte)
		   					SendNetworkResult(ClientID,1)
		   				Case "word"
		   					WriteProcessValue(Offset,Value,#PB_Word)
		   					SendNetworkResult(ClientID,1)
		   				Case "long"
		   					WriteProcessValue(Offset,Value,#PB_Long)
		   					SendNetworkResult(ClientID,1)
		   				Case "float"
		   					WriteProcessFloat(Offset,ValF(StringField(Parameters$,3,Chr(9))))
		   					SendNetworkResult(ClientID,1)
		   				Case "quad"
		   					WriteProcessFloat(Offset,ValD(StringField(Parameters$,3,Chr(9))))
		   					SendNetworkResult(ClientID,1)
		   				Case "string"
		   					WriteProcessString(Offset,StringField(Parameters$,3,Chr(9)))
		   					SendNetworkResult(ClientID,1)
		   				Case "double"
		   					WriteProcessFloat(Offset,ValD(StringField(Parameters$,3,Chr(9))))
		   					SendNetworkResult(ClientID,1)
		   				Case "character"
		   					WriteProcessValue(Offset,Val(StringField(Parameters$,3,Chr(9))),#PB_Byte)
		   					SendNetworkResult(ClientID,1)
		   				Case "array"
		   					WriteProcessArray(Offset,StringField(Parameters$,3,Chr(9)))
		   					SendNetworkResult(ClientID,1)
		   				Default
		   					SendNetworkResult(ClientID,2)
		   			EndSelect
		   		Else
		   			SendNetworkResult(ClientID,3)
		   		EndIf
	   		Default
	   			SendNetworkResult(ClientID,0)
	 		EndSelect
	EndSelect
EndProcedure

Procedure VirtualThreads()
	If Config\DisplayMessage_LeftTop>0
		Config\DisplayMessage_LeftTop-1
	ElseIf Not Config\DisplayMessage_LeftTop
		WriteProcessString($BAA7A0,Chr(0))
		Config\DisplayMessage_LeftTop=-1
	EndIf
	If GetForegroundWindow_()=Common\GTASA_WindowID
		If Config\FreezeTaxiTimer
			WriteProcessValue($A5197C,Config\FreezeTaxiTimer,#PB_Long)
		EndIf
		If Config\InfiniteHealth
			CPED=ReadProcessValue($B6F5F0,#PB_Long)
			CVehicle=ReadProcessValue($B6F980,#PB_Long)
			If CPED
				WriteProcessValue(CPED+66,$DC,#PB_Byte)
				WriteProcessFloat(CPED+$540,ReadProcessFloat(CPED+$544))
			EndIf
			If CVehicle
				WriteProcessValue(CVehicle+66,$DC,#PB_Byte)
				WriteProcessFloat(CVehicle+1216,1000)
			EndIf
		EndIf
		If Config\InfiniteNitro
			CPED=ReadProcessValue($B6F5F0,#PB_Long)
			CVehicle=ReadProcessValue($B6F980,#PB_Long)
			If CPED<>CVehicle
				If ReadProcessValue(CVehicle+$48A,#PB_Byte)>0
					WriteProcessFloat(CVehicle+$8A4,-0.01)
				EndIf
			EndIf
		EndIf
		If Config\ScrollVehicle
			Spawn=#False
			If GetAsyncKeyState_(Config\Key_ScrollVehicleUp)
				If Config\ScrollVehicle_Pressed<>1
					If Config\ScrollVehicle_VehicleID<611
						Config\ScrollVehicle_VehicleID+1
					Else
						Config\ScrollVehicle_VehicleID=400
					EndIf
					Config\ScrollVehicle_Pressed=#True
					Spawn=#True
				EndIf
			ElseIf GetAsyncKeyState_(Config\Key_ScrollVehicleDown)
				If Config\ScrollVehicle_Pressed<>2
					If Config\ScrollVehicle_VehicleID>400
						Config\ScrollVehicle_VehicleID-1
					Else
						Config\ScrollVehicle_VehicleID=400
					EndIf
					Config\ScrollVehicle_Pressed=2
					Spawn=#True
				EndIf
			Else
				Config\Scrollvehicle_Pressed=#False
			EndIf
			If Spawn
				SpawnVehicle(Config\ScrollVehicle_VehicleID)
			EndIf
		EndIf
		If Not ReadProcessValue($B6F5F0,#PB_Long)
			Config\SendStartupCheats=#False
		EndIf
		If Not Config\SendStartupCheats
			If Not ReadProcessValue($BA6748+$5C,#PB_Byte) And ReadProcessValue($B6F5F0,#PB_Long)
				Config\SendStartupCheats=#True
				Config\JustActivateCheat=#True
				ForEach AutoCheats()
					SetCheat(AutoCheats(),#False)
				Next
				Config\JustActivateCheat=#False
			EndIf
		EndIf
		For VehicleID=400 To 611
			Offset=$85D2CB+(VehicleID*36)
			Select Vehicle(VehicleID-400)
				Case -1
				Case 0
					WriteProcessValue(Offset,1,#PB_Byte)
				Case 1
					WriteProcessValue(Offset,0,#PB_Byte)
			EndSelect
		Next
		If Config\ShowCurrentTime
			WriteProcessValue($969168,1,#PB_Byte)
			WriteProcessValue($B70153,Hour(Date()),#PB_Byte)
			WriteProcessValue($B70152,Minute(Date()),#PB_Byte)
			WriteProcessValue($B7014E,DayOfWeek(Date())+1,#PB_Byte)
		EndIf
		If Config\ShowHeightInfo
			PED=ReadProcessValue($B6F3B8,#PB_Long)
			Pool=ReadProcessValue(PED+20,#PB_Long)
			DisplayMessage(StrF(ReadProcessFloat(Pool+56),2),#DisplayMessage_MiddleBottom)
		EndIf
		If Config\SpawnVehicle
			*SpawnVehicle.GTA_TextZone=Config\SpawnVehicle_Memory
			For Key=#VK_0 To #VK_9
				If GetAsyncKeyState_(Key) And Not Config\SpawnVehicle_KeyPressed
					Config\SpawnVehicle_KeyPressed=#True
					Config\SpawnVehicle_Num+Str(Key-#VK_0)
					Config\SpawnVehicle_Num=Right(Config\SpawnVehicle_Num,3)
				EndIf
			Next
			Config\SpawnVehicle_KeyPressed=#False
			For Key=#VK_0 To #VK_9
				If GetAsyncKeyState_(Key)
					Config\SpawnVehicle_KeyPressed=#True
				EndIf
			Next
			If Config\SpawnVehicle_Num<>Config\SpawnVehicle_OldNum
				Config\SpawnVehicle_OldNum=Config\SpawnVehicle_Num
				*SpawnVehicle\Num1=Val(Left(Config\SpawnVehicle_Num,3))
				DisplayTextZone(*SpawnVehicle,#TextZone_SpawnVehicleEx)
			EndIf
			If GetAsyncKeyState_(Config\Key_SpawnVehicleEx)
				SpawnVehicle(Val(Config\SpawnVehicle_Num))
			EndIf
		EndIf
	EndIf
EndProcedure

Procedure MainLoop(Null)
	Repeat
		If UpdateGTASAProcess()
			If GetForegroundWindow_()=Common\GTASA_WindowID
				VirtualThreads()
			EndIf
		EndIf
		ProgressNetwork()
		Select WaitWindowEvent(1)
			Case #PB_Event_Menu
				Select EventMenu()
					Case #Menu_ReloadAll
						ReloadAll()
					Case #Menu_ReportBug
						RunProgram("http://bugreport.selfcoders.com/?product=gta_sa_toolbox&version=3.0&application=cheatprocessor")
					Case #Menu_RestoreGTASA
						HideGame(#False)
				EndSelect
			EndSelect
		ProgressCheats()
	Until Config\Quit
EndProcedure

ProcedureDLL AttachProcess(Instance)
	log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
	FileSeek(log,Lof(log))
	WriteStringN(log,"injecting ("+Str(Instance)+")...")
	CloseFile(log)
; 	Config\UserPath=GetPath(5)+"GTA San Andreas User Files\"
; 	Config\LastPlaceBuffer=AllocateMemory(12)
; 	Config\LastCheat="N/A"
; 	LoadSettings()
; 	LoadLanguage()
; 	If IsModuleRunning(#Module_CheatProcessor)
; 		MessageRequester(#Title,Language("The GTA San Andreas ToolBox CheatProcessor has been already started!"),#MB_ICONERROR)
; 	Else
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"not running")
; 		CloseFile(log)
; 		OpenWindow(#RunOnlyOnceCheckWindow,0,0,0,0,#RunOnlyOnceTitle_CheatProcessor,#PB_Window_Invisible)
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"creating directories...")
; 		CloseFile(log)
; 		CreateDirectorys()
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"init network")
; 		CloseFile(log)
; 		InitNetwork()
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"init sound")
; 		CloseFile(log)
; 		;InitSound()
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"init image de/encoder")
; 		CloseFile(log)
; 		UseJPEGImageEncoder()
; 		UseJPEG2000ImageEncoder()
; 		UsePNGImageEncoder()
; 		UseOGGSoundDecoder()
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"unset keys")
; 		CloseFile(log)
; 		For Key=0 To 255
; 			GetAsyncKeyState_(Key)
; 		Next
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"reload all")
; 		CloseFile(log)
; 		ReloadAll()
; 		log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 		FileSeek(log,Lof(log))
; 		WriteStringN(log,"open #Window")
; 		CloseFile(log)
; 		If OpenWindow(#Window,0,0,0,0,#Title,#PB_Window_Invisible)
; 			If AddSysTrayIconEx(#Tray,WindowID(#Window),ExtractIcon_(0,ProgramFilename(),0))
; 				UpdateSysTrayToolTip()
; 			EndIf
; 			log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 			FileSeek(log,Lof(log))
; 			WriteStringN(log,"starting server...")
; 			CloseFile(log)
; 			If CreateNetworkServer(#CheatServer,Config\CheatServerPort)
; 				SetWindowCallback(@WindowCallback(),#Window)
; 				CreateThread(@MainLoop(),#Null)
; 			Else
; 		 		MessageRequester(#Title,ReplaceString(Language("Can not start the cheat server on port %1!"),"%1",Str(Config\CheatServerPort)),#MB_ICONERROR)
; 			EndIf
; 		EndIf
; 	EndIf
; 	log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
; 	FileSeek(log,Lof(log))
; 	WriteStringN(log,"Ready")
; 	CloseFile(log)
EndProcedure

ProcedureDLL DetachProcess(Instance)
	log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
	FileSeek(log,Lof(log))
	WriteStringN(log,"Detach process ("+Str(Instance)+")")
	CloseFile(log)
	Config\Quit=#True
	Repeat
		Delay(10)
	Until Not IsThread(Config\TransferCheat)
	CloseNetworkServer(#CheatServer)
	RemoveSysTrayIconEx(#Tray,WindowID(#Window))
	If Config\LastPlaceBuffer
		FreeMemory(Config\LastPlaceBuffer)
	EndIf
	log=OpenFile(#PB_Any,"E:\GTA San Andreas\SelfCoders-Mods\inject.log")
	FileSeek(log,Lof(log))
	WriteStringN(log,"Process detached")
	CloseFile(log)
EndProcedure