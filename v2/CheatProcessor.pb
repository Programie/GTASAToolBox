Enumeration;- Enumeration
 #RunOnlyOnceCheckWindow
 #Window
 #Window_TransferCheat
 #Tray
 #Menu
 #Menu_ReloadAll
 #Menu_ReportBug
 #Menu_RestoreGTASA
 #Menu_Quit
 #Sound_Alarm
 #Sound_NetworkCheat
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
 Language.l
 ImageType.l
 Screenshot_ShowHUD.l
 DisableGTASplash.b
 ActivateCheat.s
 UseCheatSound.l
 CheatSound.s
 IgnoreList_Vehicles.s
 IgnoreList_Cheats.s
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
 LastCheat.l
 FreezeTaxiTimer.l
 InfiniteHealth.l
 InfiniteNitro.l
 ShowCurrentTime.l
 GotoTargetPlace.l
 CarColor_VehicleID.l
 CarColor_Color.l
 Timer.l
 Timer_Date.l
 Timer_Memory.l
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
 Cheat.s
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

#MaxLang=69
#MaxWeapons=46

Global Config.Config
Global x.f,y.f,z.f
Global Dim Language.s(#MaxLang)
Global Dim Cheat.s(0)
Global Dim Shortcut.c(3,0)
Global Dim Sound.s(0)
Global Dim Vehicle.Vehicle(211)
Global Dim Weapon.Weapon(#MaxWeapons)
Global Dim TeleportPlace.TeleportPlace(0)
Global Dim Direct.Direct(9)
Global Dim Interior.s(18)
Global Dim LastVehicle(8)

IncludeFile "Common.pbi"

Procedure LoadSettings()
 OpenPreferences(Common\PrefsFile)
  PreferenceGroup("Global")
   Config\DisplayMessages=ReadPreferenceLong("DisplayMessages",1)
   Config\Language=ReadPreferenceLong("Language",#LANG_GERMAN)
   Config\DisableGTASplash=ReadPreferenceLong("DisableGTASplash",0)
   Config\ActivateCheat=ReadPreferenceString("ActivateCheat","")
   Config\ImageType=ReadPreferenceLong("ImageType",#PB_ImagePlugin_JPEG)
  PreferenceGroup("IgnoreList")
   Config\IgnoreList_Vehicles=ReadPreferenceString("Vehicles","449;537;538;569;570;590")
   Config\IgnoreList_Cheats=ReadPreferenceString("Cheats","")
  PreferenceGroup("TextZone")
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
   Config\UseCheatSound=ReadPreferenceLong("UseCheatSound",1)
   Config\CheatSound=ReadPreferenceString("CheatSound","Cheat.wav")
  PreferenceGroup("CheatProcessorKeys")
   Config\Key_OSDUp=ReadPreferenceLong("OSDUp",#VK_UP)
   Config\Key_OSDDown=ReadPreferenceLong("OSDDown",#VK_DOWN)
   Config\Key_SpawnVehicleEx=ReadPreferenceLong("SpawnVehicleEx",#VK_CONTROL)
   Config\Key_ScrollVehicleUp=ReadPreferenceLong("ScrollVehicleUp",#VK_NUMPAD9)
   Config\Key_ScrollVehicleDown=ReadPreferenceLong("ScrollVehicleDown",#VK_NUMPAD3)
  PreferenceGroup("HigherProcessPriority")
   Config\HigherProcessPriority=ReadPreferenceLong("CheatProcessor",1)
 ClosePreferences()
EndProcedure

Procedure ReloadVehicleList()
 File=ReadFile(#PB_Any,Common\InstallPath+"Vehicles.cfg")
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
   ReadNow=0
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>"#"
      Select LCase(String$)
       Case "cars"
        ReadNow=1
       Case "end"
        ReadNow=0
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
   ReadNow=0
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>"#"
      Select LCase(String$)
       Case "car"
        ReadNow=1
       Case "end"
        ReadNow=0
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
 File=ReadFile(#PB_Any,Common\InstallPath+"Cheats.clf")
  If IsFile(File)
   Config\CheatListCount=0
   Repeat
    String$=Trim(ReadString(File))
     Select LCase(String$)
      Case "; cheatlist"
       Mode=1
      Case "; teleportlist"
       Mode=2
      Default
       If String$ And Left(String$,1)<>";" And Mode=1
        Shortcut$=Trim(StringField(String$,3,"|"))
         If Shortcut$
          Config\CheatListCount+1
         EndIf
       EndIf
     EndSelect
   Until Eof(File)
   FileSeek(File,0)
   ReDim Cheat.s(Config\CheatListCount)
   ReDim Shortcut.c(3,Config\CheatListCount)
   ReDim Sound.s(Config\CheatListCount)
   Mode=0
   Count=1
   Repeat
    String$=Trim(ReadString(File))
     Select LCase(String$)
      Case "; cheatlist"
       Mode=1
      Case "; teleportlist"
       Mode=2
      Default
       If String$ And Left(String$,1)<>";" And Mode=1
        Shortcut$=Trim(StringField(String$,3,"|"))
        If Shortcut$
         Cheat(Count)=Trim(StringField(String$,1,"|"))
         For Index=0 To 3
          Shortcut(Index,Count)=0
         Next
         For Index=1 To 4
          KeyCode=Val(StringField(Shortcut$,Index,"+"))
           Select KeyCode
            Case #VK_CONTROL,#VK_LCONTROL,#VK_RCONTROL
             Shortcut(0,Count)=1
            Case #VK_SHIFT,#VK_LSHIFT,#VK_RSHIFT
             Shortcut(1,Count)=1
            Case #VK_MENU,#VK_LMENU,#VK_RMENU
             Shortcut(2,Count)=1
            Case 0
            Default
             Shortcut(3,Count)=KeyCode
           EndSelect
         Next
         Sound(Count)=Trim(StringField(String$,4,"|"))
         Count+1
        EndIf
       EndIf
     EndSelect
   Until Eof(File)
   CloseFile(File)
  Else
   If MessageRequester(Language(0),ReplaceString(Language(1),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONERROR)=#PB_MessageRequester_Yes
    RunProgram(Common\InstallPath+"GTA ToolBox.exe","",Common\InstallPath)
   EndIf
  EndIf
EndProcedure

Procedure ReloadTeleportlist()
 File=ReadFile(#PB_Any,Common\InstallPath+"Teleporter.clf")
  If IsFile(File)
   Config\TeleportListCount=0
   Repeat
    String$=Trim(ReadString(File))
     Select LCase(String$)
      Case "; cheatlist"
       Mode=1
      Case "; teleportlist"
       Mode=2
      Default
       If String$ And Left(String$,1)<>";" And Mode=2
        Config\TeleportListCount+1
       EndIf
     EndSelect
   Until Eof(File)
   FileSeek(File,0)
   ReDim TeleportPlace.TeleportPlace(Config\TeleportListCount)
   Mode=0
   Repeat
    String$=Trim(ReadString(File))
     Select LCase(String$)
      Case "; cheatlist"
       Mode=1
      Case "; teleportlist"
       Mode=2
      Default
       If String$ And Left(String$,1)<>";" And Mode=2
        Pos$=Trim(StringField(String$,1,"|"))
        Interior$=Trim(StringField(String$,3,"|"))
        TeleportPlace(Count)\Cheat=Trim(StringField(String$,2,"|"))
        TeleportPlace(Count)\X=ValF(StringField(Pos$,1,";"))
        TeleportPlace(Count)\Y=ValF(StringField(Pos$,2,";"))
        TeleportPlace(Count)\Z=ValF(StringField(Pos$,3,";"))
        If Interior$
         TeleportPlace(Count)\Interior=Val(Interior$)
        Else
         TeleportPlace(Count)\Interior=-1
        EndIf
        Count+1
       EndIf
     EndSelect
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
 File=ReadFile(#PB_Any,Common\InstallPath+"Weapons.cfg")
  If IsFile(File)
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>";"
      Weapon=Val(StringField(String$,1,"|"))
      Weapon(Weapon)\Name=StringField(String$,2,"|")
      Weapon(Weapon)\ID=Val(StringField(String$,3,"|"))
      Weapon(Weapon)\Slot=Val(StringField(String$,4,"|"))
      Weapon(Weapon)\AmmoClip=Val(StringField(String$,5,"|"))
      Weapon(Weapon)\TotalAmmo=Val(StringField(String$,6,"|"))
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
EndProcedure

Procedure WindowCallback(WindowID,Message,wParam,lParam)
 Select Message
  Case #WM_QUERYENDSESSION
   Config\Quit=1
  Case Common\ExplorerMsg
   If IsSysTrayIcon(0)
    RemoveSysTrayIcon(0)
   EndIf
   If AddSysTrayIcon(0,WindowID(0),ExtractIcon_(0,ProgramFilename(),0))
    SysTrayIconToolTip(0,GetWindowTitle(0))
   EndIf
 EndSelect
 ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure IsDirectoryEx(Path$)
 Directory=ExamineDirectory(#PB_Any,Path$,"*.*")
  If IsDirectory(Directory)
   FinishDirectory(Directory)
   ProcedureReturn 1
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
 Repeat
  File$=ReplaceString(SyntaxFile$,"*",Str(StartCount),1)
  If IsFileEx(File$)=0
   ProcedureReturn File$
  EndIf
  StartCount+1
 ForEver
EndProcedure

Procedure CaptureScreen(FileName$,ImageTyp,Flags)
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
 Image=CreateImage(#PB_Any,Width,Height)
  If IsImage(Image)
    If StartDrawing(ImageOutput(Image))
      DrawImage(ImageID,0,0)
     StopDrawing()
    EndIf
   ProcedureReturn SaveImage(Image,FileName$,ImageTyp,Flags)
  EndIf
EndProcedure

Procedure SpawnVehicle(VehicleID)
 Spawn=1
 If VehicleID=>400 And VehicleID<=611
  If Config\IgnoreList_Vehicles
   For Index=1 To CountString(Config\IgnoreList_Vehicles,";")+1
    If Val(StringField(Config\IgnoreList_Vehicles,Index,";"))=VehicleID
     Spawn=0
    EndIf
   Next
  EndIf
  If Spawn
   WriteProcessValue($01301000,VehicleID,#PB_Word)
   DisplayMessage(ReplaceString(ReplaceString(Language(5),"%1",Vehicle(VehicleID-400)\Name,1),"%2",Str(VehicleID),1),#DisplayMessage_LeftTop)
  ElseIf Spawn=0
   DisplayMessage(ReplaceString(Language(8),"%1",Str(VehicleID),1),#DisplayMessage_LeftTop)
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
 DisplayMessage(ReplaceString(ReplaceString(Language(9),"%1",Weapon(Weapon)\Name,1),"%2",Str(Weapon),1),#DisplayMessage_LeftTop)
EndProcedure

Procedure.s MakeScreenshot()
 TmpFile$=Config\TempPath+"Screen.tmp"
 Path$=Config\UserPath+"Gallery\"
 If Config\Screenshot_ShowHUD=0
  Radar=ReadProcessValue($BA676C,#PB_Byte)
  HUD=ReadProcessValue($BA6769,#PB_Byte)
  WriteProcessValue($BA676C,2,#PB_Byte)
  WriteProcessValue($BA6769,0,#PB_Byte)
  Repeat
   Delay(100)
   TimeOut+1
   If ReadProcessValue($BA676C,#PB_Byte)=2 And ReadProcessValue($BA6769,#PB_Byte)=0
    Do=1
   EndIf
   If TimeOut=20
    Do=1
   EndIf
  Until Do
 EndIf
 DisplayMessage("",#DisplayMessage_LeftTop)
 DisplayMessage("",#DisplayMessage_MiddleBottom)
 Select Config\ImageType
  Case #PB_ImagePlugin_BMP
   Ext$="bmp"
  Case #PB_ImagePlugin_JPEG
   Ext$="jpg"
  Case #PB_ImagePlugin_PNG
   Ext$="png"
  Default
   Config\ImageType=#PB_ImagePlugin_JPEG
   Ext$="jpg"
 EndSelect
 CaptureScreen(TmpFile$,Config\ImageType,10)
 If Config\Screenshot_ShowHUD=0
  WriteProcessValue($BA676C,Radar,#PB_Byte)
  WriteProcessValue($BA6769,HUD,#PB_Byte)
 EndIf
 FileName$=CheckValidFile(Path$+"ScreenShot_*."+Ext$,1)
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
     CopyFile=1
    EndIf
   CloseFile(In)
  EndIf
 If CopyFile
  CopyFile(TmpFile$,FileName$)
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
 If ReadProcessValue(Offset,#PB_Byte)=0 Or Config\JustActivateCheat
  WriteProcessValue(Offset,1,#PB_Byte)
  DisplayMessage(ReplaceString(Language(21),"%1","~b~"+Cheat$+"~s~",1),#DisplayMessage_LeftTop)
 Else
  WriteProcessValue(Offset,0,#PB_Byte)
  DisplayMessage(ReplaceString(Language(22),"%1","~b~"+Cheat$+"~s~",1),#DisplayMessage_LeftTop)
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
  DisplayMessage(ReplaceString(ReplaceString(ReplaceString(Language(35),"%1",StrF(x,2),1),"%2",StrF(y,2),1),"%3",StrF(z,2),1),#DisplayMessage_LeftTop)
 Else
  DisplayMessage(Language(37),#DisplayMessage_LeftTop)
 EndIf
EndProcedure

Procedure SetCurrentWeather(WeatherID)
 If WeatherID=#PB_Any
  WeatherID=Random(45)
  DisplayMessage(ReplaceString(Language(23),"%1",Str(WeatherID),1),#DisplayMessage_LeftTop)
 Else
  DisplayMessage(ReplaceString(Language(24),"%1",Str(WeatherID),1),#DisplayMessage_LeftTop)
 EndIf
 WriteProcessValue($C8131C,WeatherID,#PB_Word)
EndProcedure

Procedure RandomEx(Min,Max)
 Repeat
  Value=Random(Max)
 Until Value=>Min
 ProcedureReturn Value
EndProcedure

Procedure HideGame(State)
  If GTASAWindowID()
   Select State
    Case 1
     ShowWindow_(GTASAWindowID(),#SW_MINIMIZE)
     ShowWindow_(GTASAWindowID(),#SW_HIDE)
    Case 0
     ShowWindow_(GTASAWindowID(),#SW_SHOW)
     ShowWindow_(GTASAWindowID(),#SW_RESTORE)
    Case -1
     ProcedureReturn IsWindowVisible_(GTASAWindowID())
   EndSelect
  EndIf
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
    Until Eof(File) Or Config\PlaySound=0
    CloseFile(File)
   EndIf
 EndIf
EndProcedure

Procedure SetCheat(Cheat$,SoundFile$)
 SetCheated=1
 SoundFile$=Trim(SoundFile$)
 RepeatX=Val(Cheat$)
  If RepeatX
   Cheat$=Right(Cheat$,Len(Cheat$)-Len(Str(RepeatX)))
  EndIf
 Value=Val(Cheat$)
  If Value
   Value$=Str(Value)
  Else
   Value$=""
  EndIf
 OldCheat$=Right(Cheat$,Len(Cheat$)-Len(Value$))
 Cheat$=OldCheat$
 Finish=Len(Cheat$)
 For Chr=1 To Len(Cheat$)
  Value$=Mid(Cheat$,Chr,1)
   If Value$=Str(Val(Value$))
    Finish=Chr-1
    Break
   EndIf
 Next
 Cheat$=Mid(Cheat$,0,Finish)
 CheatPar$=Trim(RemoveString(OldCheat$,Cheat$))
 If RepeatX<1
  RepeatX=1
 EndIf
 If Config\UseCheatSound And SoundFile$<>"NONE"
  If SoundFile$="" Or IsFileEx(SoundFile$)=0
   SoundFile$=Config\CheatSound
  EndIf
  If Config\PlaySound
   Config\PlaySound=0
  EndIf
  If LCase(GetExtensionPart(SoundFile$))="bmf"
   Config\PlaySound=CreateThread(@PlayBMF(),@SoundFile$)
  Else
   PlaySound_(SoundFile$,0,#SND_ASYNC)
  EndIf
 EndIf
 For Time=1 To RepeatX
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
      If ReadProcessValue(Offset,#PB_Byte) Or Config\JustActivateCheat
       WriteProcessValue(Offset,0,#PB_Byte)
       DisplayMessage(ReplaceString(Language(64),"%1",Vehicle(VehicleID-400)\Name,1),#DisplayMessage_LeftTop)
      Else
       WriteProcessValue(Offset,1,#PB_Byte)
       DisplayMessage(ReplaceString(Language(65),"%1",Vehicle(VehicleID-400)\Name,1),#DisplayMessage_LeftTop)
      EndIf
     EndIf
   Case "AEDUWNV"
    ActivateCheat($969174,Cheat$)
   Case "AEZAKMI"
    If ReadProcessValue($969171,#PB_Byte)=0 Or Config\JustActivateCheat
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
     DisplayMessage("Auto AIM deactivated",#DisplayMessage_LeftTop)
    Else
     WriteProcessValue($B6EC2E,1,#PB_Byte)
     DisplayMessage("Auto AIM activated",#DisplayMessage_LeftTop)
    EndIf
   Case "BAGUVIX"
    ActivateCheat($96916D,Cheat$)
   Case "BIGBANG"
    ; destroy all vehicles (excluded the own)
   Case "BSXSGGC"
    ActivateCheat($969166,Cheat$)
   Case "CHANGECARCOLOR"
    CPED=ReadProcessValue($B6F5F0,#PB_Long)
    CVehicle=ReadProcessValue($B6F980,#PB_Long)
     If CPED<>CVehicle And CVehicle
      VehicleID=ReadProcessValue(CVehicle+34,#PB_Word)
       If VehicleID=>400 And VehicleID<=611
        If VehicleID<>Config\CarColor_VehicleID
         Config\CarColor_VehicleID=VehicleID
         Config\CarColor_Color=0
        EndIf
        Colors$=Vehicle(VehicleID-400)\Colors
        If Config\CarColor_Color=>(CountString(Colors$,",")+1)/2
         Config\CarColor_Color=1
        Else
         Config\CarColor_Color+1
        EndIf
        Color1=Val(Trim(StringField(Colors$,Config\CarColor_Color*2-1,",")))
        Color2=Val(Trim(StringField(Colors$,Config\CarColor_Color*2,",")))
        WriteProcessValue(CVehicle+1076,Color1,#PB_Byte)
        WriteProcessValue(CVehicle+1077,Color2,#PB_Byte)
        Text$=ReplaceString(ReplaceString(ReplaceString(Language(61),"%1",Str(Color1),1),"%2",Str(Color2),1),"%3",Str(Config\CarColor_Color),1)
        DisplayMessage(Text$,#DisplayMessage_LeftTop)
       EndIf
     Else
      DisplayMessage(Language(19),#DisplayMessage_LeftTop)
     EndIf
   Case "CLEARCHEATEDSTATE"
    WriteProcessValue($96918C,0,#PB_Byte)
    WriteProcessValue($BAA472,0,#PB_Word)
    WriteProcessValue($B79044,0,#PB_Word)
    DisplayMessage(Language(295),#DisplayMessage_LeftTop)
    SetCheated=0
   Case "COXEFGU"
    ActivateCheat($969165,Cheat$)
   Case "CVWKXAM"
    ActivateCheat($96916E,Cheat$)
   Case "DISABLECHEATS"
    NOP$="90 90 90 90 90"
    If ReadProcessArray($00438480,5)<>NOP$ Or Config\JustActivateCheat
     WriteProcessArray($00438480,NOP$)
     DisplayMessage(Language(30),#DisplayMessage_LeftTop)
    Else
     WriteProcessArray($00438480,"A0 51 F8 B5 00")
     DisplayMessage(Language(29),#DisplayMessage_LeftTop)
    EndIf
   Case "DISPLAYSTARTUPCHEATS"
    Text$=""
    For Cheat=0 To CountString(Config\ActivateCheat,";")
     Cheat$=Trim(StringField(Config\ActivateCheat,Cheat+1,";"))
      If Cheat$
       If Text$
        Text$+"~n~"
       EndIf
       Text$+Cheat$
      EndIf
    Next
    DisplayMessage(Text$,#DisplayMessage_LeftTop)
   Case "EEGCYXT"
    SpawnVehicle(486)
   Case "EHIBXQS"
    ActivateCheat($969180,Cheat$)
   Case "ENGINESTATE"
    PED=ReadProcessValue($B6F3B8,#PB_Long)
    State=ReadProcessValue(PED+1064,#PB_Byte)
     If State=0 Or Config\JustActivateCheat
      State=16
      DisplayMessage(Language(13),#DisplayMessage_LeftTop)
     Else
      State=0
      DisplayMessage(Language(14),#DisplayMessage_LeftTop)
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
      DisplayMessage(Language(46),#DisplayMessage_LeftTop)
     Else
      DisplayMessage(Language(19),#DisplayMessage_LeftTop)
     EndIf
   Case "FOOOXFT"
    ActivateCheat($969140,Cheat$)
   Case "FREEZEGAME"
    If ReadProcessValue($B7CB49,#PB_Byte)
     DisplayMessage("Unfrozen",#DisplayMessage_LeftTop)
     WriteProcessValue($B7CB49,0,#PB_Byte)
    Else
     DisplayMessage("Frozen",#DisplayMessage_LeftTop)
     WriteProcessValue($B7CB49,1,#PB_Byte)
    EndIf
   Case "FREEZETAXITIMER"
    If Config\FreezeTaxiTimer=0 Or Config\JustActivateCheat
     Config\FreezeTaxiTimer=ReadProcessValue($A5197C,#PB_Long)
     DisplayMessage(Language(62),#DisplayMessage_LeftTop)
    Else
     Config\FreezeTaxiTimer=0
     DisplayMessage(Language(63),#DisplayMessage_LeftTop)
    EndIf
   Case "GETLASTVEHICLE"
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
            DisplayMessage(Language(47),#DisplayMessage_LeftTop)
           EndIf
         EndIf
       EndIf
     EndIf
   Case "GOTOLASTVEHICLE"
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
            DisplayMessage(Language(47),#DisplayMessage_LeftTop)
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
      SetPosition(x,y,z,Config\LastPlaceBuffer)
      DisplayMessage(ReplaceString(ReplaceString(ReplaceString(Language(35),"%1",StrF(x,2),1),"%2",StrF(y,2),1),"%3",StrF(z,2),1),#DisplayMessage_LeftTop)
     Else
      DisplayMessage(Language(36),#DisplayMessage_LeftTop)
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
    DisplayMessage(ReplaceString(Language(38),"%1",StrF(Gravity),1),#DisplayMessage_LeftTop)
   Case "GRAVITY-"
    If CheatPar$
     Gravity.f=-ValF(CheatPar$)
    Else
     Gravity.f=0.008
    EndIf
    WriteProcessFloat($863984,Gravity)
    DisplayMessage(ReplaceString(Language(38),"%1",StrF(Gravity),1),#DisplayMessage_LeftTop)
   Case "HESOYAM"
    CallProcessFunction($00438E40)
    DisplayMessage(Language(49),#DisplayMessage_LeftTop)
   Case "HIDEGAME"
    HideGame(1)
   Case "HOOVERCAR"
    ActivateCheat($969152,Cheat$)
   Case "INFINITEHEALTH"
    If Config\InfiniteHealth=0 Or Config\JustActivateCheat
     Config\InfiniteHealth=1
     DisplayMessage(Language(6),#DisplayMessage_LeftTop)
    Else
     PED=ReadProcessValue($B6F3B8,#PB_Long)
      If PED
       WriteProcessValue(PED+66,0,#PB_Byte)
       DisplayMessage(Language(7),#DisplayMessage_LeftTop)
      EndIf
     Config\InfiniteHealth=0
    EndIf
   Case "INFINITEHEIGHT"
    If ReadProcessArray($67F24E,2)<>"EB 61" Or ReadProcessValue($6D261D,#PB_Byte)<>$EB Or Config\JustActivateCheat
     WriteProcessArray($67F24E,"EB 61")
     WriteProcessValue($6D261D,$EB,#PB_Byte)
     DisplayMessage(Language(40),#DisplayMessage_LeftTop)
    Else
     WriteProcessArray($67F24E,"6A 2")
     WriteProcessValue($6D261D,$7B,#PB_Byte)
     DisplayMessage(Language(41),#DisplayMessage_LeftTop)
    EndIf
   Case "INFINITENITRO"
    If Config\InfiniteNitro=0 Or Config\JustActivateCheat
     Config\InfiniteNitro=1
     DisplayMessage(Language(31),#DisplayMessage_LeftTop)
    Else
     Config\InfiniteNitro=0
     DisplayMessage(Language(32),#DisplayMessage_LeftTop)
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
    DisplayMessage(ReplaceString(Language(50),"%1","2",1),#DisplayMessage_LeftTop)
   Case "LASTPLACE"
    x=PeekF(Config\LastPlaceBuffer)
    y=PeekF(Config\LastPlaceBuffer+4)
    z=PeekF(Config\LastPlaceBuffer+8)
    SetPosition(x,y,z,Config\LastPlaceBuffer)
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
      DisplayMessage(ReplaceString(Language(33),"%1",Interior(ID),1),#DisplayMessage_LeftTop)
     Else
      DisplayMessage(ReplaceString(Language(34),"%1",Str(ID),1),#DisplayMessage_LeftTop)
     EndIf
   Case "LOADPLACE"
    ID=Val(CheatPar$)
     If ID=>1 And ID<=10
      SetPosition(Direct(ID-1)\X,Direct(ID-1)\Y,Direct(ID-1)\Z,Config\LastPlaceBuffer)
      DisplayMessage(ReplaceString(Language(15),"%1",Str(ID),1),#DisplayMessage_LeftTop)
     EndIf
   Case "LOADVEHICLE"
    ID=Val(CheatPar$)
     If ID=>1 And ID<=10
      SpawnVehicle(Direct(ID-1)\VehicleID)
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
       DisplayMessage(Language(60),#DisplayMessage_LeftTop)
      Else
       WriteProcessValue(CVehicle+1272,1,#PB_Long)
       DisplayMessage(Language(59),#DisplayMessage_LeftTop)
      EndIf
     EndIf
   Case "LXGIWYL"
    CallProcessFunction($004385B0)
    DisplayMessage(ReplaceString(Language(50),"%1","1",1),#DisplayMessage_LeftTop)
   Case "MAKESCREENSHOT"
    File$=Trim(MakeScreenshot())
     If File$
      DisplayMessage(ReplaceString(Language(25),"%1",GetFilePart(File$),1),#DisplayMessage_LeftTop)
     EndIf
   Case "MOONSIZE"
    WriteProcessValue($8D4B60,Val(CheatPar$),#PB_Long)
    DisplayMessage(ReplaceString(Language(57),"%1",Str(Val(CheatPar$)),1),#DisplayMessage_LeftTop)
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
    DisplayMessage(Language(53),#DisplayMessage_LeftTop)
   Case "SAVEPLACE"
    PED=ReadProcessValue($B6F3B8,#PB_Long)
     If PED
      Pool=ReadProcessValue(PED+20,#PB_Long)
       If Pool
        ID=Val(CheatPar$)
         If ID=>1 And ID<=10
          Direct(ID-1)\X=ReadProcessFloat(Pool+48)
          Direct(ID-1)\Y=ReadProcessFloat(Pool+52)
          Direct(ID-1)\Z=ReadProcessFloat(Pool+56)
          DisplayMessage(ReplaceString(Language(17),"%1",Str(ID),1),#DisplayMessage_LeftTop)
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
       DisplayMessage(ReplaceString(Language(18),"%1",Str(ID),1),#DisplayMessage_LeftTop)
      EndIf
     Else
      DisplayMessage(Language(19),#DisplayMessage_LeftTop)
     EndIf
   Case "SCROLLVEHICLE"
    If Config\ScrollVehicle=0 Or Config\JustActivateCheat
     Config\ScrollVehicle=1
     DisplayMessage(Language(51),#DisplayMessage_LeftTop)
    Else
     Config\ScrollVehicle=0
     DisplayMessage(Language(52),#DisplayMessage_LeftTop)
    EndIf
   Case "SETCASH"
    Money=Val(CheatPar$)
    WriteProcessValue($B7CE50,Money,#PB_Long)
    DisplayMessage(ReplaceString(Language(16),"%1",Str(Money)+"$",1),#DisplayMessage_LeftTop)
   Case "SETTIME"
    If IsThread(Config\ShowCurrentTime)
     Config\ShowCurrentTime=0
    EndIf
    WriteProcessValue($969168,0,#PB_Byte)
    TimeCode$=Left(Trim(CheatPar$),4)
     If Len(TimeCode$)<4
      TimeCode$=ReplaceString(Space(4-Len(TimeCode$))," ","0",1)+TimeCode$
     EndIf
    Hour$=Mid(TimeCode$,0,2)
    Minute$=Mid(TimeCode$,3,2)
    WriteProcessValue($B70153,Val(Hour$),#PB_Byte)
    WriteProcessValue($B70152,Val(Minute$),#PB_Byte)
    DisplayMessage(ReplaceString(ReplaceString(Language(20),"%hh",Hour$,1),"%mm",Minute$,1),#DisplayMessage_LeftTop)
   Case "SETWANTEDLEVEL"
    Level=Val(CheatPar$)
     If Level=>0 And Level<=6
      SetWantedLevel(Level)
      DisplayMessage(ReplaceString(Language(58),"%1",Str(Level),1),#DisplayMessage_LeftTop)
     EndIf
   Case "SETWEATHER"
    SetCurrentWeather(Val(CheatPar$))
   Case "SHOWCURRENTTIME"
    If Config\ShowCurrentTime=0 Or Config\JustActivateCheat
     Config\ShowCurrentTime=1
     DisplayMessage(Language(11),#DisplayMessage_LeftTop)
    Else
     Config\ShowCurrentTime=0
     WriteProcessValue($969168,0,#PB_Byte)
     DisplayMessage(Language(12),#DisplayMessage_LeftTop)
    EndIf
   Case "SHOWHEIGHTINFO"
    If Config\ShowHeightInfo=0 Or Config\JustActivateCheat
     Config\ShowHeightInfo=1
     DisplayMessage(Language(42),#DisplayMessage_LeftTop)
    Else
     Config\ShowHeightInfo=0
     DisplayMessage(Language(43),#DisplayMessage_LeftTop)
    EndIf
   Case "SHOWMONEYNOW"
    WriteProcessValue($B7CE54,ReadProcessValue($B7CE50,#PB_Long),#PB_Long)
   Case "SHOWVEHICLEINFO"
    If Config\ShowVehicleInfo=0 Or Config\JustActivateCheat
     Config\ShowVehicleInfo=1
     Config\ShowVehicleInfo_Damage=CreateTextZone()
     Config\ShowVehicleInfo_Speed=CreateTextZone()
     *Damage.GTA_TextZone=Config\ShowVehicleInfo_Damage
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
     *Speed.GTA_TextZone=Config\ShowVehicleInfo_Speed
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
     DisplayMessage(Language(44),#DisplayMessage_LeftTop)
    Else
     FreeTextZone(Config\ShowVehicleInfo_Damage,#TextZone_VehicleDamage)
     FreeTextZone(Config\ShowVehicleInfo_Speed,#TextZone_VehicleSpeed)
     Config\ShowVehicleInfo=0
     DisplayMessage(Language(45),#DisplayMessage_LeftTop)
    EndIf
   Case "SPAWNVEHICLE"
    ID=Val(CheatPar$)
     If ID>0
      SpawnVehicle(ID)
     Else
      If Config\SpawnVehicle
       Config\SpawnVehicle=0
       FreeTextZone(Config\SpawnVehicle_Memory,#TextZone_SpawnVehicleEx)
       DisplayMessage(Language(56),#DisplayMessage_LeftTop)
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
       Config\SpawnVehicle_Num="000"
       Config\SpawnVehicle_OldNum="000"
       Config\SpawnVehicle_Memory=*SpawnVehicle
       Config\SpawnVehicle=1
       DisplayMessage(Language(55),#DisplayMessage_LeftTop)
      EndIf
     EndIf
   Case "SPAWNWEAPON"
    SpawnWeapon(Val(CheatPar$))
   Case "STATEOFEMERGENCY"
    ActivateCheat($969175,Cheat$)
   ;Case "SZCMAWO"
   ; Comming soon
   Case "TIMER"
    If IsThread(Config\Timer)=0 Or Config\JustActivateCheat
     Config\Timer_Date=Val(CheatPar$)
     *GTA_TextZone.GTA_TextZone=CreateTextZone()
     *GTA_TextZone\X=Config\TextZone_TimerX
     *GTA_TextZone\Y=Config\TextZone_TimerY
     *GTA_TextZone\Font=1
     *GTA_TextZone\gxt1=1112364366
     *GTA_TextZone\gxt2=21061
     *GTA_TextZone\Proportional=1
     *GTA_TextZone\TextWidth=1
     *GTA_TextZone\TextHeight=1.5
     *GTA_TextZone\TextColor=Config\TextZone_TimerColor
     *GTA_TextZone\ShadeType=1
     Hour=Val(Mid(Str(Config\Timer_Date),1,2))
     Minute=Val(Mid(Str(Config\Timer_Date),3,2))
     Config\Timer_Date=Date(Year(Date()),Month(Date()),Day(Date()),Hour,Minute,0)
     Config\Timer_Memory=*GTA_TextZone
     Config\Timer=1
    Else
     Config\Timer=0
     FreeTextZone(Config\Timer_Memory,#TextZone_Timer)
     DisplayMessage(Language(28),#DisplayMessage_LeftTop)
    EndIf
   Case "TOGGLEWEAPONSLOTS"
    Slot1=Val(StringField(CheatPar$,1,"_"))
    Slot2=Val(StringField(CheatPar$,2,"_"))
     If Slot1=Slot2
      DisplayMessage(Language(68),#DisplayMessage_LeftTop)
     Else
      If Config\ToggleWeaponSlots_Current=1
       Config\ToggleWeaponSlots_Current=2
       WriteProcessValue($B7CDBC,Slot1,#PB_Long)
       DisplayMessage(ReplaceString(ReplaceString(Language(69),"%1","1",1),"%2",Str(Slot1),1),#DisplayMessage_LeftTop)
      Else
       Config\ToggleWeaponSlots_Current=1
       WriteProcessValue($B7CDBC,Slot2,#PB_Long)
       DisplayMessage(ReplaceString(ReplaceString(Language(69),"%1","2",1),"%2",Str(Slot2),1),#DisplayMessage_LeftTop)
      EndIf
     EndIf
   Case "URKQSRK"
    SpawnVehicle(513)
   Case "UZUMYMW"
    CallProcessFunction($00438B30)
    DisplayMessage(ReplaceString(Language(50),"%1","3",1),#DisplayMessage_LeftTop)
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
    IsPlace=0
    For Pos=0 To Config\TeleportListCount-1
     If UCase(TeleportPlace(Pos)\Cheat)=UCase(Cheat$)
      LoadInterior(TeleportPlace(Pos)\Interior)
      SetPosition(TeleportPlace(Pos)\X,TeleportPlace(Pos)\Y,TeleportPlace(Pos)\Z,Config\LastPlaceBuffer)
      IsPlace=1
      Break
     EndIf
    Next
    If IsPlace=0
     SetCheated=0
     DisplayMessage(ReplaceString(Language(39),"%1",Cheat$,1),#DisplayMessage_LeftTop)
     Delay(500)
     For Key=1 To Len(Cheat$)
      SendKey(Asc(UCase(Mid(Cheat$,Key,1))))
     Next
    EndIf
  EndSelect
 Next
 If SetCheated
  WriteProcessValue($96918C,1,#PB_Byte)
 EndIf
EndProcedure

Procedure ProgressCheats()
 IsCheat=-1
 AddKey=0
 If GetAsyncKeyState_(#VK_CONTROL)
  Ctrl=1
 Else
  Ctrl=0
 EndIf
 If GetAsyncKeyState_(#VK_SHIFT)
  Shift=1
 Else
  Shift=0
 EndIf
 If GetAsyncKeyState_(#VK_MENU)
  Alt=1
 Else
  Alt=0
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
  If IsCheat<>Config\LastCheat
   Config\LastCheat=IsCheat
   If IsCheat>0
    If GetForegroundWindow_()=GTASAWindowID() And ReadProcessValue($B7CD98,#PB_Long)
     SetCheat(Cheat(IsCheat),Sound(IsCheat))
    EndIf
   EndIf
  EndIf
 EndIf
EndProcedure

Procedure VirtualThreads()
 If Config\DisplayMessage_LeftTop>0
  Config\DisplayMessage_LeftTop-1
 ElseIf Config\DisplayMessage_LeftTop=0
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
   Spawn=0
   If GetAsyncKeyState_(Config\Key_ScrollVehicleUp)
    If Config\ScrollVehicle_Pressed<>1
     If Config\ScrollVehicle_VehicleID<611
      Config\ScrollVehicle_VehicleID+1
     Else
      Config\ScrollVehicle_VehicleID=400
     EndIf
     Config\ScrollVehicle_Pressed=1
     Spawn=1
    EndIf
   ElseIf GetAsyncKeyState_(Config\Key_ScrollVehicleDown)
    If Config\ScrollVehicle_Pressed<>2
     If Config\ScrollVehicle_VehicleID>400
      Config\ScrollVehicle_VehicleID-1
     Else
      Config\ScrollVehicle_VehicleID=400
     EndIf
     Config\ScrollVehicle_Pressed=2
     Spawn=1
    EndIf
   Else
    Config\Scrollvehicle_Pressed=0
   EndIf
   If Spawn
    SpawnVehicle(Config\ScrollVehicle_VehicleID)
   EndIf
  EndIf
  If ReadProcessValue($B6F5F0,#PB_Long)=0
   Config\SendStartupCheats=0
  EndIf
  If Config\SendStartupCheats=0
   If ReadProcessValue($BA6748+$5C,#PB_Byte)=0 And ReadProcessValue($B6F5F0,#PB_Long)
    Config\SendStartupCheats=1
    If Trim(Config\ActivateCheat)
     Config\JustActivateCheat=1
     For Cheat=0 To CountString(Config\ActivateCheat,";")
      Cheat$=Trim(StringField(Config\ActivateCheat,Cheat+1,";"))
       If Cheat$
        SetCheat(Cheat$,"NONE")
       EndIf
     Next
     Config\JustActivateCheat=0
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
   EndIf
  EndIf
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
    If GetAsyncKeyState_(Key) And Config\SpawnVehicle_KeyPressed=0
     Config\SpawnVehicle_KeyPressed=1
     Config\SpawnVehicle_Num+Str(Key-#VK_0)
     Config\SpawnVehicle_Num=Right(Config\SpawnVehicle_Num,3)
    EndIf
   Next
   Config\SpawnVehicle_KeyPressed=0
   For Key=#VK_0 To #VK_9
    If GetAsyncKeyState_(Key)
     Config\SpawnVehicle_KeyPressed=1
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
  If Config\Timer
   CDate=Date()
   *Timer.GTA_TextZone=Config\Timer_Memory
   If Config\Timer_Date>CDate
    *Timer\Num1=Config\Timer_Date-CDate
    DisplayTextZone(*Timer,#TextZone_Timer)
   Else
    DisplayMessage(Language(27),#DisplayMessage_LeftTop)
    PlaySound(#Sound_Alarm)
    Config\Timer=0
   EndIf
  EndIf
 EndIf
EndProcedure

Procedure LoadLanguage()
 Select Config\Language
  Case #LANG_ENGLISH
   Restore Language_English
  Case #LANG_GERMAN
   Restore Language_German
  Default
   Restore Language_English
 EndSelect
 For Lang=0 To #MaxLang
  Read.s Language(Lang)
 Next
EndProcedure

Procedure ReloadAll()
 Debug "Reload all"
 LoadSettings()
 LoadLanguage()
 ReloadCheatlist()
 ReloadTeleportlist()
 ReloadInteriors()
 ReloadVehicleList()
 ReloadWeaponConfig()
 HigherProcessPriority(Config\HigherProcessPriority)
 Config\SendStartupCheats=0
EndProcedure

;- Main

Config\UserPath=GetPath($05)+"GTA San Andreas User Files\"
Config\LastPlaceBuffer=AllocateMemory(12)

LoadSettings()
LoadLanguage()

If IsModuleRunning(#Module_CheatProcessor)
 MessageRequester(Language(0),Language(2),#MB_ICONERROR)
 End
EndIf
OpenWindow(#RunOnlyOnceCheckWindow,0,0,0,0,#RunOnlyOnceTitle_CheatProcessor,#PB_Window_Invisible)

CreateDirectorys()
ReloadAll()

InitSound()

UseJPEGImageEncoder()
UseJPEG2000ImageEncoder()
UsePNGImageEncoder()
UseOGGSoundDecoder()

CatchSound(#Sound_Alarm,?Sound_Alarm)

Select Config\Language
 Case #LANG_ENGLISH
  Restore Language_English
 Case #LANG_GERMAN
  Restore Language_German
 Default
  Info$="Error in languageconfiguration!"+Chr(13)
  Info$+"Please run the GUI to fix this problem."+Chr(13)
  Info$+"Do you want to start the GUI now?"+Chr(13)
  Info$+Chr(13)
  Info$+"Fehler in der Sprachkonfiguration!"+Chr(13)
  Info$+"Starte die GUI um das Problem zu beheben."+Chr(13)
  Info$+"Soll die GUI nun gestartet werden?"
  If MessageRequester("GTA San Andreas ToolBox - CheatProcessor",Info$,#MB_YESNO|#MB_ICONERROR)=#PB_MessageRequester_Yes
   RunProgram(Common\InstallPath+"GTA ToolBox.exe","",Common\InstallPath)
  EndIf
  End
EndSelect

For Key=0 To 255
 GetAsyncKeyState_(Key)
Next

If IsFileEx(Common\InstallPath+"Sounds\NetworkCheat.wav")=0
 SaveData(Common\InstallPath+"Sounds\NetworkCheat.wav",?Sound_NetworkCheat,?EOF)
EndIf

If OpenWindow(#Window,0,0,0,0,"GTA San Andreas ToolBox - CheatProcessor",#PB_Window_Invisible)
 If AddSysTrayIcon(#Tray,WindowID(#Window),ExtractIcon_(0,ProgramFilename(),0))
  SysTrayIconToolTip(#Tray,GetWindowTitle(#Window))
 EndIf
 OpenWindow(#Window_TransferCheat,0,0,0,0,#CheatTransferWindow,#PB_Window_Invisible)
 SetWindowCallback(@WindowCallback(),0)
 Repeat
  WindowID=UpdateGTASAProcess()
   If WindowID
    If GetForegroundWindow_()=WindowID
     VirtualThreads()
    EndIf
   EndIf
  Title$=GetWindowTitle(#RunOnlyOnceCheckWindow)
  Title$=Trim(Right(Title$,Len(Title$)-Len(#RunOnlyOnceTitle_CheatProcessor)))
   If Title$
    Select Title$
     Case #Module_CMD_ReloadAll
      ReloadAll()
     Case #Module_CMD_Quit
      Config\Quit=1
    EndSelect
    SetWindowTitle(#RunOnlyOnceCheckWindow,#RunOnlyOnceTitle_CheatProcessor)
   EndIf
  Cheat$=UCase(Trim(RemoveString(GetWindowTitle(#Window_TransferCheat),#CheatTransferWindow)))
   If Cheat$
    SetWindowTitle(#Window_TransferCheat,#CheatTransferWindow)
    PlaySound_(Common\InstallPath+"Sounds\NetworkCheat.wav",0,#SND_ASYNC)
    SetCheat(Cheat$,"NONE")
   EndIf
  Select WaitWindowEvent(1)
   Case #PB_Event_Menu
    Select EventMenu()
     Case #Menu_ReloadAll
      ReloadAll()
     Case #Menu_ReportBug
      RunProgram(Common\InstallPath+"BugReporter.exe","/Select CheatProcessor",Common\InstallPath)
     Case #Menu_RestoreGTASA
      HideGame(0)
     Case #Menu_Quit
      If MessageRequester(Language(3),Language(4),#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
       Config\Quit=1
      EndIf
    EndSelect
   Case #PB_Event_SysTray
    If CreatePopupMenu(#Menu)
     MenuItem(#Menu_ReloadAll,Language(10))
      MenuBar()
     MenuItem(#Menu_ReportBug,Language(67))
      MenuBar()
     If Common\GTASA_WindowID
      If HideGame(-1)
       MenuItem(#Menu_RestoreGTASA,Language(26))
       MenuBar()
      EndIf
     EndIf
     MenuItem(#Menu_Quit,Language(3))
    EndIf
    DisplayPopupMenu(#Menu,WindowID(#Window))
  EndSelect
  ProgressCheats()
 Until Config\Quit
 Repeat
  Delay(10)
 Until IsThread(Config\TransferCheat)=0
EndIf

If Config\LastPlaceBuffer
 FreeMemory(Config\LastPlaceBuffer)
EndIf

End

DataSection
 Language_English:
  Data$ "Error"; 0
  Data$ "The Cheatlist file was not found!<br>Please run the GUI to edit the cheatlist.<br>Run it now?"; 1
  Data$ "The GTA San Andreas ToolBox CheatProcessor has been already started!"; 2
  Data$ "Quit CheatProcessor"; 3
  Data$ "Are you sure to quit the CheatProcessor?"; 4
  Data$ "Spawned vehicle: ~r~%1~s~ (~r~%2~s~)"; 5
  Data$ "Infinite health ~b~enabled~s~"; 6
  Data$ "Infinite health ~b~disabled~s~"; 7
  Data$ "This vehicle was blocked! (ID: ~g~%1~s~)"; 8
  Data$ "Spawned weapon: ~r~%1~s~ (~r~%2~s~)"; 9
  Data$ "Reload data"; 10
  Data$ "Time synchronization ~b~enabled~s~"; 11
  Data$ "Time synchronization ~b~disabled~s~"; 12
  Data$ "Engine ~b~on~s~"; 13
  Data$ "Engine ~b~off~s~"; 14
  Data$ "Teleported to place ~r~%1~s~"; 15
  Data$ "Money set to ~r~%1~s~"; 16
  Data$ "Current place saved to slot ~r~%1~s~"; 17
  Data$ "Current vehicle saved to slot ~r~%1~s~"; 18
  Data$ "You are not in a vehicle!"; 19
  Data$ "Clock set to ~g~%hh:%mm~s~"; 20
  Data$ "Cheat ~b~activated~s~ (~r~%1~s~)"; 21
  Data$ "Cheat ~b~deactivated~s~ (~r~%1~s~)"; 22
  Data$ "Random weather: ~r~%1~s~"; 23
  Data$ "Weather changed to: ~r~%1~s~"; 24
  Data$ "Screenshot created (~r~%1~s~)"; 25
  Data$ "Restore GTA San Andreas"; 26
  Data$ "The timer has expired!"; 27
  Data$ "The timer has been stopped!"; 28
  Data$ "Cheats ~b~enabled~s~"; 29
  Data$ "Cheats ~b~disabled~s+"; 30
  Data$ "Infinite nitro ~b~activated~s~"; 31
  Data$ "Infinite nitro ~b~deactivated~s~"; 32
  Data$ "Interior loaded: ~r~%1~s~"; 33
  Data$ "Could not load interior with ID ~b~%1~s~!~n~Invalid ID!"; 34
  Data$ "Teleported!~n~~n~x: ~r~%1~s~~n~y: ~r~%2~s~~n~z: ~r~%3~s~"; 35
  Data$ "No position given!"; 36
  Data$ "Destination not fixed!"; 37
  Data$ "Gravity set to ~r~%1~s~"; 38
  Data$ "Send cheat: ~b~%1~s~"; 39
  Data$ "Infinite height ~b~activated~s~"; 40
  Data$ "Infinite height ~b~deactivated~s~"; 41
  Data$ "~r~Show~s~ height information"; 42
  Data$ "~r~Hide~s~ height information"; 43
  Data$ "~r~Show~s~ vehicle informations"; 44
  Data$ "~r~Hide~s~ vehicle informations"; 44
  Data$ "Vehicle flipped"; 46
  Data$ "Last vehicle teleported"; 47
  Data$ "Teleported to last vehicle"; 48
  Data$ "Health, Armor, 250000$"; 49
  Data$ "Weaponset ~b~%1~s~"; 50
  Data$ "ScrollVehicle ~b~activated~s~"; 51
  Data$ "ScrollVehicle ~b~deactivated~s~"; 52
  Data$ "Jetpack spawned"; 53
  Data$ "Start GTA San Andreas"; 54
  Data$ "Advanced spawning ~b~activated~s~"; 55
  Data$ "Advanced spawning ~b~deactivated~s~"; 56
  Data$ "Monsize changed to factor ~r~%1~s~"; 57
  Data$ "Wantedlevel set to level ~r~%1~s~"; 58
  Data$ "Vehicledoor ~b~unlocked~s~"; 59
  Data$ "Vehicledoor ~b~locked~s~"; 60
  Data$ "Vehiclecolor changed!~n~~n~Body color: ~r~%1~s~~n~Stripe color: ~r~%2~s~~n~Color index: ~r~%3~s~"; 61
  Data$ "Taxitimer ~b~freezed~s~"; 62
  Data$ "Taxitimer ~b~unfreezed~s~"; 63
  Data$ "Radio ~b~activated~s~ in ~r~%1~s~"; 64
  Data$ "Radio ~b~deactivated~s~ in ~r~%1~s~"; 65
  Data$ "The Vehicle list is empty!"; 66
  Data$ "Report bug"; 67
  Data$ "Slot 1 is the same as slot 2"; 68
  Data$ "Switched to slot %1 (#%2)"; 69
 Language_German:
  Data$ "Fehler"; 0
  Data$ "Die Cheatlistendatei wurde nicht gefunden!<br>Starte die GUI, um die Cheatliste zu bearbeiten.<br>Jetzt starten?"; 1
  Data$ "Der GTA San Andreas ToolBox CheatProcessor wurde bereits gestartet!"; 2
  Data$ "CheatProcessor beenden"; 3
  Data$ "Möchtest du den CheatProcessor wirklich beenden?"; 4
  Data$ "Gespawntes Fahrzeug: ~r~%1~s~ (~r~%2~s~)"; 5
  Data$ "Unverwundbar ~b~aktiviert~s~"; 6
  Data$ "Unverwundbar ~b~deaktiviert~s~"; 7
  Data$ "Dieses Fahrzeug wurde geblockt! (ID: ~g~%1~s~)"; 8
  Data$ "Gespawnte Waffe: ~r~%1~s~ (~r~%2~s~)"; 9
  Data$ "Daten neuladen"; 10
  Data$ "Uhrzeitsynchronisation ~b~aktiviert~s~"; 11
  Data$ "Uhrzeitsynchronisation ~b~deaktiviert~s~"; 12
  Data$ "Motor ~b~an~s~"; 13
  Data$ "Motor ~b~aus~s~"; 14
  Data$ "Teleportiert zu Platz ~r~%1~s~"; 15
  Data$ "Geld gesetzt auf ~r~%1~s~"; 16
  Data$ "Aktueller Ort in Slot ~r~%1~s~ gespeichert"; 17
  Data$ "Aktuelles Fahrzeug in Slot ~r~%1~s~ gespeichert"; 18
  Data$ "Du bist nicht in einem Fahrzeug!"; 19
  Data$ "Uhr gesetzt auf ~g~%hh:%mm~s~"; 20
  Data$ "Cheat ~b~aktiviert~s~ (~r~%1~s~)"; 21
  Data$ "Cheat ~b~deaktiviert~s~ (~r~%1~s~)"; 22
  Data$ "Zufälliges Wetter: ~r~%1~s~"; 23
  Data$ "Wetter gewechselt zu: ~r~%1~s~"; 24
  Data$ "Screenshot erstellt (~r~%1~s~)"; 25
  Data$ "GTA San Andreas wiederherstellen"; 26
  Data$ "Der Timer ist abgelaufen!"; 27
  Data$ "Der Timer wurde abgebrochen!"; 28
  Data$ "Cheats ~b~aktiviert~s~"; 29
  Data$ "Cheats ~b~deaktiviert~s~"; 30
  Data$ "Endlos Nitro ~b~aktiviert~s~"; 31
  Data$ "Endlos Nitro ~b~deaktiviert~s~"; 32
  Data$ "Interior geladen: ~r~%1~s~"; 33
  Data$ "Der Interior mit der ID ~b~%1~s~ kann nicht geladen werden!~n~Ungültige ID!"; 34
  Data$ "Teleportiert!~n~~n~x: ~r~%1~s~~n~y: ~r~%2~s~~n~z: ~r~%3~s~"; 35
  Data$ "Keine Position angegeben!"; 36
  Data$ "Zielort nicht festgelegt!"; 37
  Data$ "Gravitation gesetzt auf ~r~%1~s~"; 38
  Data$ "Cheat gesendet: ~b~%1~s~"; 39
  Data$ "Endlos hoch fliegen ~b~aktiviert~s~"; 40
  Data$ "Endlos hoch fliegen ~b~deaktiviert~s~"; 41
  Data$ "Höheninformationen ~r~anzeigen~s~"; 42
  Data$ "Höheninformationen ~r~nicht anzeigen~s~"; 43
  Data$ "Fahrzeuginformationen ~r~anzeigen~s~"; 44
  Data$ "Fahrzeuginformationen ~r~nicht anzeigen~s~"; 45
  Data$ "Fahrzeug umgedreht"; 46
  Data$ "Letztes Fahrzeug teleportiert"; 47
  Data$ "Zum letzten Fahrzeug teleportiert"; 48
  Data$ "Leben, Schutzweste,250000$"; 49
  Data$ "Waffenset ~b~%1~s~"; 50
  Data$ "ScrollVehicle ~b~aktiviert~s~"; 51
  Data$ "ScrollVehicle ~b~deaktiviert~s~"; 52
  Data$ "Jetpack gespawnt"; 53
  Data$ "GTA San Andreas starten"; 54
  Data$ "Erweitertes Spawnen ~b~aktiviert~s~"; 55
  Data$ "Erweitertes Spawnen ~b~deaktiviert~s~"; 56
  Data$ "Mondgröße auf Faktor ~r~%1~s~ geändert"; 57
  Data$ "Fandungslevel auf Level ~r~%1~s~ geändert"; 58
  Data$ "Fahrzeugtür ~b~geöffnet~s~"; 59
  Data$ "Fahrzeugtür ~b~abgeschlossen~s~"; 60
  Data$ "Fahrzeugfarbe gewechselt!~n~~n~Farbe: ~r~%1~s~~n~Streifenfarbe: ~r~%2~s~~n~Farbenindex: ~r~%3~s~"; 61
  Data$ "Taxitimer ~b~gestoppt~s~"; 62
  Data$ "Taxttimer ~b~fortgesetzt~s~"; 63
  Data$ "Radio in ~r~%1~s~ ~b~aktiviert~s~"; 64
  Data$ "Radio in ~r~%1~s~ ~b~deaktiviert~s~"; 65
  Data$ "Die Fahrzeugsliste ist leer!"; 66
  Data$ "Bug berichten"; 67
  Data$ "Slot 1 ist der selbe wie Slot 2"; 68
  Data$ "Gewechselt auf Slot %1 (#%2)"; 69
 Sound_Alarm:
  IncludeBinary "Sounds\Alarm.wav"
 Sound_NetworkCheat:
  IncludeBinary "Sounds\NetworkCheat.wav"
 EOF:
EndDataSection