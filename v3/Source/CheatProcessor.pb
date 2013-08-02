Enumeration;- Enumeration
	#RunOnlyOnceCheckWindow
	#Window
	#CheatServer
	#Tray
	#Menu
	#Menu_ReloadAll
	#Menu_ReportBug
	#Menu_RestoreGTASA
	#Menu_RunGTASA
	#Menu_Quit
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

#MaxWeapons=46
#Title="GTA San Andreas ToolBox CheatProcessor"

IncludeFile "Includes\Common.pbi"

Structure GlobalData;- Structure, GlobalData
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

Global GlobalData.GlobalData
Global x.f,y.f,z.f
Global Dim Cheat.s(0)
Global Dim Shortcut.c(3,0)
Global Dim Vehicle.Vehicle(211)
Global Dim Weapon.Weapon(#MaxWeapons)
Global Dim TeleportPlace.TeleportPlace(0)
Global Dim Direct.Direct(9)
Global Dim Interior.s(18)
Global Dim LastVehicle(8)
Global NewList AutoCheats.s()
Global NewList RemoteUsers()

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
		GlobalData\CheatListCount=0
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				Shortcut$=Trim(StringField(String$,3,Chr(9)))
				If Shortcut$
					GlobalData\CheatListCount+1
				EndIf
			EndIf
		Until Eof(File)
		FileFound=#True
	EndIf
	ReDim Cheat.s(GlobalData\CheatListCount)
	ReDim Shortcut.c(3,GlobalData\CheatListCount)
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
		GlobalData\TeleportListCount=0
		Repeat
			String$=Trim(ReadString(File))
			If String$ And Left(String$,1)<>";"
				GlobalData\TeleportListCount+1
			EndIf
		Until Eof(File)
		FileSeek(File,0)
		ReDim TeleportPlace.TeleportPlace(GlobalData\TeleportListCount)
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
	SysTrayIconToolTipEx(#Tray,WindowID(#Window),"Cheats: "+Str(GlobalData\CheatListCount)+Chr(13)+Language("Automatically activated cheats")+": "+Str(ListSize(AutoCheats()))+Chr(13)+Language("Last used cheat")+": "+GlobalData\LastCheat+Chr(13)+Language("Connected remote users")+": "+Str(ListSize(RemoteUsers())))
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
			GlobalData\Quit=#True
		Case #WM_NOTIFYICON; The user clicked on the systray icon
			Select lParam
				Case #WM_LBUTTONDOWN,#WM_RBUTTONDOWN
					If CreatePopupMenu(#Menu)
						MenuItem(#Menu_ReloadAll,Language("Reload data"))
							MenuBar()
						MenuItem(#Menu_ReportBug,Language("Report bug"))
							MenuBar()
						If Common\GTASA_WindowID
							MenuItem(#Menu_RestoreGTASA,Language("Restore GTA San Andreas"))
						Else
							MenuItem(#Menu_RunGTASA,Language("Launch GTA San Andreas"))
						EndIf
							MenuBar()
						MenuItem(#Menu_Quit,Language("Quit"))
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
	CreateDirectoryEx(Common\UserPath+"Gallery\")
	CreateDirectoryEx(Common\UserPath+"User Tracks\")
	CreateDirectoryEx(Common\TempPath)
EndProcedure

Procedure DisplayMessage(Text$,Type)
	If Config\DisplayMessages
		Text$=ReplaceString(Text$,Chr($E4),Chr($9A)); auml
		Text$=ReplaceString(Text$,Chr($C4),Chr($83)); Auml
		Text$=ReplaceString(Text$,Chr($F6),Chr($A8)); ouml
		Text$=ReplaceString(Text$,Chr($D6),Chr($91)); Ouml
		Text$=ReplaceString(Text$,Chr($FC),Chr($AC)); uuml
		Text$=ReplaceString(Text$,Chr($DC),Chr($95)); Uuml
		Text$=ReplaceString(Text$,Chr($DF),Chr($96)); Szlig
		Select Type
			Case #DisplayMessage_LeftTop
				GlobalData\DisplayMessage_LeftTop=5000
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
	TmpFile$=Common\TempPath+"Screen.tmp"
	Path$=Common\UserPath+"Gallery\"
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
 If Not ReadProcessValue(Offset,#PB_Byte) Or GlobalData\JustActivateCheat
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
  SetPosition(x,y,z,GlobalData\LastPlaceBuffer)
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

Procedure ReloadAll()
	LoadSettings()
	LoadLanguage()
	ReloadCheatlist()
	ReloadTeleportlist()
	ReloadInteriors()
	ReloadVehicleList()
	ReloadWeaponConfig()
	ReloadAutoCheats()
	HigherProcessPriority(Config\CheatProcessor_HigherProcessPriority)
	GlobalData\SendStartupCheats=#False
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
    Until Eof(File) Or Not GlobalData\PlaySound
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
		For Cheat=1 To GlobalData\CheatListCount
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
		If IsCheat<>GlobalData\LastCheatIndex
			GlobalData\LastCheatIndex=IsCheat
			If IsCheat>0
				If GetForegroundWindow_()=Common\GTASA_WindowID And ReadProcessValue($B7CD98,#PB_Long)
					SetCheat(Cheat(IsCheat),#True)
				EndIf
			EndIf
		EndIf
	Else
		GlobalData\LastCheatIndex=#False
	EndIf
EndProcedure

Procedure ProgressNetworkCommand(ClientID,Command$,Parameters$)
	Select Command$
		Case "login"
			SendNetworkResult(ClientID,3)
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
EndProcedure

Procedure ProgressNetwork()
	Select NetworkServerEvent()
		Case #PB_NetworkEvent_Disconnect
			ClientID=EventClient()
			ForEach RemoteUsers()
				If RemoteUsers()=ClientID
					DeleteElement(RemoteUsers())
					UpdateSysTrayToolTip()
					Break
				EndIf
			Next
		Case #PB_NetworkEvent_Data
			ClientID=EventClient()
			String$=Space(1024)
			ReceiveNetworkData(ClientID,@String$,StringByteLength(String$))
			Command$=LCase(Trim(StringField(String$,1,Chr(9))))
			Parameters$=Trim(Mid(String$,FindString(String$,Chr(9),0)+1))
			If Command$
				If GetClientIP(ClientID)=MakeIPAddress(127,0,0,1)
					LoggedIn=#True
				Else
					ForEach RemoteUsers()
						If RemoteUsers()=ClientID
							LoggedIn=#True
							Break
						EndIf
					Next
				EndIf
				If LoggedIn
					ProgressNetworkCommand(ClientID,Command$,Parameters$)
				Else
					If Command$="login"
						Username$=StringField(Parameters$,1,":")
						Password$=StringField(Parameters$,2,":")
						If Username$ And Password$
							If OpenPreferences(Common\ConfigPath+"RemoteUsers.ini")
								If LCase(ReadPreferenceString(Username$,""))=LCase(MD5FingerprintEx(Password$))
									LoggedIn=#True
									AddElement(RemoteUsers())
									RemoteUsers()=ClientID
									UpdateSysTrayToolTip()
								EndIf
								ClosePreferences()
							EndIf
						EndIf
						If LoggedIn
							SendNetworkResult(ClientID,1)
						Else
							SendNetworkResult(ClientID,2)
						EndIf
					EndIf
				EndIf
			EndIf
	EndSelect
EndProcedure

Procedure VirtualThreads()
	If GlobalData\DisplayMessage_LeftTop>0
		GlobalData\DisplayMessage_LeftTop-1
	ElseIf Not GlobalData\DisplayMessage_LeftTop
		WriteProcessString($BAA7A0,Chr(0))
		GlobalData\DisplayMessage_LeftTop=-1
	EndIf
	If GetForegroundWindow_()=Common\GTASA_WindowID
		If GlobalData\FreezeTaxiTimer
			WriteProcessValue($A5197C,GlobalData\FreezeTaxiTimer,#PB_Long)
		EndIf
		If GlobalData\InfiniteHealth
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
		If GlobalData\InfiniteNitro
			CPED=ReadProcessValue($B6F5F0,#PB_Long)
			CVehicle=ReadProcessValue($B6F980,#PB_Long)
			If CPED<>CVehicle
				If ReadProcessValue(CVehicle+$48A,#PB_Byte)>0
					WriteProcessFloat(CVehicle+$8A4,-0.01)
				EndIf
			EndIf
		EndIf
		If GlobalData\ScrollVehicle
			Spawn=#False
			If GetAsyncKeyState_(Config\Key_ScrollVehicleUp)
				If GlobalData\ScrollVehicle_Pressed<>1
					If GlobalData\ScrollVehicle_VehicleID<611
						GlobalData\ScrollVehicle_VehicleID+1
					Else
						GlobalData\ScrollVehicle_VehicleID=400
					EndIf
					GlobalData\ScrollVehicle_Pressed=#True
					Spawn=#True
				EndIf
			ElseIf GetAsyncKeyState_(Config\Key_ScrollVehicleDown)
				If GlobalData\ScrollVehicle_Pressed<>2
					If GlobalData\ScrollVehicle_VehicleID>400
						GlobalData\ScrollVehicle_VehicleID-1
					Else
						GlobalData\ScrollVehicle_VehicleID=400
					EndIf
					GlobalData\ScrollVehicle_Pressed=2
					Spawn=#True
				EndIf
			Else
				GlobalData\Scrollvehicle_Pressed=#False
			EndIf
			If Spawn
				SpawnVehicle(GlobalData\ScrollVehicle_VehicleID)
			EndIf
		EndIf
		If Not ReadProcessValue($B6F5F0,#PB_Long)
			GlobalData\SendStartupCheats=#False
		EndIf
		If Not GlobalData\SendStartupCheats
			If Not ReadProcessValue($BA6748+$5C,#PB_Byte) And ReadProcessValue($B6F5F0,#PB_Long)
				GlobalData\SendStartupCheats=#True
				GlobalData\JustActivateCheat=#True
				ForEach AutoCheats()
					SetCheat(AutoCheats(),#False)
				Next
				GlobalData\JustActivateCheat=#False
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
		If GlobalData\ShowCurrentTime
			WriteProcessValue($969168,1,#PB_Byte)
			WriteProcessValue($B70153,Hour(Date()),#PB_Byte)
			WriteProcessValue($B70152,Minute(Date()),#PB_Byte)
			WriteProcessValue($B7014E,DayOfWeek(Date())+1,#PB_Byte)
		EndIf
		If GlobalData\ShowHeightInfo
			PED=ReadProcessValue($B6F3B8,#PB_Long)
			Pool=ReadProcessValue(PED+20,#PB_Long)
			DisplayMessage(StrF(ReadProcessFloat(Pool+56),2),#DisplayMessage_MiddleBottom)
		EndIf
		If GlobalData\SpawnVehicle
			*SpawnVehicle.GTA_TextZone=GlobalData\SpawnVehicle_Memory
			For Key=#VK_0 To #VK_9
				If GetAsyncKeyState_(Key) And Not GlobalData\SpawnVehicle_KeyPressed
					GlobalData\SpawnVehicle_KeyPressed=#True
					GlobalData\SpawnVehicle_Num+Str(Key-#VK_0)
					GlobalData\SpawnVehicle_Num=Right(GlobalData\SpawnVehicle_Num,3)
				EndIf
			Next
			GlobalData\SpawnVehicle_KeyPressed=#False
			For Key=#VK_0 To #VK_9
				If GetAsyncKeyState_(Key)
					GlobalData\SpawnVehicle_KeyPressed=#True
				EndIf
			Next
			If GlobalData\SpawnVehicle_Num<>GlobalData\SpawnVehicle_OldNum
				GlobalData\SpawnVehicle_OldNum=GlobalData\SpawnVehicle_Num
				*SpawnVehicle\Num1=Val(Left(GlobalData\SpawnVehicle_Num,3))
				DisplayTextZone(*SpawnVehicle,#TextZone_SpawnVehicleEx)
			EndIf
			If GetAsyncKeyState_(Config\Key_SpawnVehicleEx)
				SpawnVehicle(Val(GlobalData\SpawnVehicle_Num))
			EndIf
		EndIf
	EndIf
EndProcedure

;- Main
GlobalData\LastPlaceBuffer=AllocateMemory(12)
GlobalData\LastCheat="N/A"

LoadSettings()
LoadLanguage()

If Not RegisterModule("CheatProcessor")
	MessageRequester(#Title,Language("The GTA San Andreas ToolBox CheatProcessor has been already started!"),#MB_ICONERROR)
	End
EndIf

CreateDirectorys()

InitNetwork()
InitSound()

UseJPEGImageEncoder()
UseJPEG2000ImageEncoder()
UsePNGImageEncoder()
UseOGGSoundDecoder()

For Key=0 To 255
	GetAsyncKeyState_(Key)
Next

ReloadAll()

If OpenWindow(#Window,0,0,0,0,#Title,#PB_Window_Invisible)
	If AddSysTrayIconEx(#Tray,WindowID(#Window),ExtractIcon_(0,ProgramFilename(),0))
		UpdateSysTrayToolTip()
	EndIf
	If CreateNetworkServer(#CheatServer,Config\CheatServerPort)
		SetWindowCallback(@WindowCallback(),#Window)
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
						Case #Menu_RunGTASA
							RunProgram(Common\GTAFile,"",GetPathPart(Common\GTAFile))
							If Config\DisableSplashScreens
								DisableGTASplash()
							EndIf
						Case #Menu_Quit
							GlobalData\Quit=#True
					EndSelect
				Case #PB_Event_CloseWindow
					Select EventWindow()
						Case #RunOnlyOnceCheckWindow
							GlobalData\Quit=#True
					EndSelect
  		EndSelect
  		ProgressCheats()
 		Until GlobalData\Quit
		Repeat
 			Delay(10)
 		Until Not IsThread(GlobalData\TransferCheat)
 		CloseNetworkServer(#CheatServer)
 	Else
 		MessageRequester(#Title,ReplaceString(Language("Can not start the cheat server on port %1!"),"%1",Str(Config\CheatServerPort)),#MB_ICONERROR)
	EndIf
EndIf
RemoveSysTrayIconEx(#Tray,WindowID(#Window))
If GlobalData\LastPlaceBuffer
	FreeMemory(GlobalData\LastPlaceBuffer)
EndIf
End
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 57
; FirstLine = 42
; Folding = ------
; EnableXP