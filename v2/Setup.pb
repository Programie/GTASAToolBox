Enumeration
 #Window
 #Page1; Einführung/Sprache
 #Page2; Programmverezichnis
 #Page3; Startmenü
 #Page4; GTA San Andreas Ordner
 #Page5; WebServer Einstellungen
 #Page6; Erweiterte Optionen
 #Page7; Zusammenfassung
 #Page8; Installation
 #Page9; Fertiggestellt
 #Header
 #Page1_TextInfo
 #Page1_TextLanguage
 #Page1_Language
 #Page2_TextInfo
 #Page2_TextDirectory
 #Page2_InstallDir
 #Page2_SelectDir
 #Page3_TextInfo
 #Page3_TextNewDir
 #Page3_TextPresentDir
 #Page3_NewDir
 #Page3_PresentDir
 #Page3_NoStartmenu
 #Page4_TextInfo
 #Page4_TextDirectory
 #Page4_GTASADir
 #Page4_SelectDir
 #Page5_TextInfo
 #Page5_TextPort
 #Page5_Port
 #Page5_RandomPort
 #Page5_FramePasswords
 #Page5_TextAdminPW
 #Page5_TextUserPW
 #Page5_AdminPassword
 #Page5_UserPassword
 #Page5_ConfigureLater
 #Page6_TextInfo
 #Page6_ScrollArea
 #Page6_DesktopIcon
 #Page6_InstallSplashScreens
 #Page7_TextInfo
 #Page7_ScrollArea
 #Page7_FrameDir
 #Page7_TextInstallDir
 #Page7_TextStartmenuDir
 #Page7_TextGTASADir
 #Page7_InstallDir
 #Page7_StartmenuDir
 #Page7_GTASADir
 #Page7_FrameWebServer
 #Page7_WebServer
 #Page7_FrameAdvanced
 #Page7_Advanced
 #Page8_TextInfo
 #Page8_Text
 #Page8_TextStatus
 #Page8_FrameProgress
 #Page8_TextStatusAll
 #Page8_TextStatusFile
 #Page8_StatusAll
 #Page8_StatusFile
 #Page9_TextInfo
 #Page9_Frame
 #Page9_RunGUI
 #Page9_ShowHelp
 #Page9_GotoSelfCodersHome
 #Back
 #Next
EndEnumeration

Enumeration
 #Font_Header
 #Font_Normal
 #Font_Bold
EndEnumeration

Enumeration
 #Dll_shlwapi
EndEnumeration

Structure Config
 MainPath.s
 Parameter.s
 Page.l
 AutoCompletePath.l
 ContinueSetup.b
 SetupThread.l
 SetupStatusAll.l
 SetupStatusFile.l
 GTASA_PID.l
 GTASA_WindowID.l
 GTASA_OldWindowID.l
 Msg_GUI.l
 Msg_CheatProcessor.l
 Msg_SpeedLauncher.l
 Msg_WebServer.l
 Msg_Updater.l
 AddPackOnQuit.s
EndStructure

#MaxLang=52;- Language

Global Config.Config
Global Dim Language.s(#MaxLang)
Global NewList Picture()

IncludeFile "Common.pbi"
IncludeFile "Images.pbi"

Procedure GetUserLanguage()
 ProcedureReturn GetUserDefaultLCID_()&$FF
EndProcedure

Procedure RandomEx(Min,Max)
 Repeat
  Value=Random(Max)
   If Value=>Min
    If Min<0
     If Random(1)
      Value=Val("-"+Str(Value))
     EndIf
    EndIf
    ProcedureReturn Value
   EndIf
 ForEver
EndProcedure

Procedure IsToolBoxRunning()
 If FindWindow_(0,#RunOnlyOnceTitle_GUI) Or FindWindow_(0,#RunOnlyOnceTitle_CheatProcessor) Or FindWindow_(0,#RunOnlyOnceTitle_SpeedLauncher) Or FindWindow_(0,#RunOnlyOnceTitle_WebServer) Or FindWindow_(0,#RunOnlyOnceTitle_Updater)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure CheckToolBoxRunning()
 If IsToolBoxRunning()
  Select MessageRequester(Language(36),ReplaceString(Language(37),"<br>",Chr(13),1),#MB_RETRYCANCEL|#MB_ICONERROR)
   Case 4
    CheckToolBoxRunning()
   Case #PB_MessageRequester_Cancel
    Config\ContinueSetup=0
  EndSelect
 Else
  Config\ContinueSetup=1
 EndIf
EndProcedure

Procedure.s ReadRegValue(HKey,Path$,Name$)
 Size=10000
 Buffer$=Space(Size)
 If RegOpenKeyEx_(HKey,Path$,0,#KEY_ALL_ACCESS,@Key)=#ERROR_SUCCESS
  If RegQueryValueEx_(Key,Name$,0,@Type,@Buffer$,@Size)=#ERROR_SUCCESS
   ProcedureReturn Trim(Buffer$)
  EndIf
 EndIf
EndProcedure

Procedure CreateShortcut(FileName$,LinkFile$,Parameter$,Description$,WorkingDir$,ShowCommand,IconFile$,IconIndex)
 CoInitialize_(0)
 If WorkingDir$=""
  WorkingDir$=GetPathPart(FileName$)
 EndIf
 If IconFile$=""
  IconFile$=FileName$
 EndIf
 If CoCreateInstance_(?CreateShortcut_ShellLink1,0,1,?CreateShortcut_ShellLink2,@CreateShortcut.IShellLinkA)=0
  CreateShortcut\SetPath(@FileName$)
  CreateShortcut\SetArguments(@Parameter$)
  CreateShortcut\SetWorkingDirectory(@WorkingDir$)
  CreateShortcut\SetDescription(@Description$)
  CreateShortcut\SetShowCmd(ShowCommand)
  CreateShortcut\SetHotkey(0)
  CreateShortcut\SetIconLocation(@IconFile$,IconIndex)
  If CreateShortcut\QueryInterface(?CreateShortcut_PersistFile,@PersistFile.IPersistFile)=0
   Size=1000
   Buffer$=Space(Size)
   MultiByteToWideChar_(#CP_ACP,0,LinkFile$,#PB_Any,Buffer$,Size)
   Result=1
   PersistFile\Save(@Buffer$,1)
   PersistFile\Release()
  EndIf
  CreateShortcut\Release()
 EndIf
 CoUninitialize_()
 ProcedureReturn Result
 DataSection
  CreateShortcut_ShellLink1:
   Data.l $00021401
   Data.w $0000,$0000
   Data.b $C0,$00,$00,$00,$00,$00,$00,$46
  CreateShortcut_ShellLink2:
   Data.l $000214EE
   Data.w $0000,$0000
   Data.b $C0,$00,$00,$00,$00,$00,$00,$46
  CreateShortcut_PersistFile:
   Data.l $0000010B
   Data.w $0000,$0000
   Data.b $C0,$00,$00,$00,$00,$00,$00,$46
 EndDataSection
EndProcedure

Procedure OpenPage(Page)
 ContainerGadget(Page,0,50,WindowWidth(#Window),WindowHeight(#Window)-100,#PB_Container_Flat)
EndProcedure

Procedure Quit()
 If MessageRequester(Language(6),ReplaceString(Language(7),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
  If IsLibrary(#Dll_shlwapi)
   CloseLibrary(#Dll_shlwapi)
  EndIf
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure AddState()
 Config\SetupStatusAll+1
EndProcedure

Procedure Setup(Null)
 Setup=0
 InstallPath$=Trim(GetGadgetText(#Page2_InstallDir))
 GTAPath$=Trim(GetGadgetText(#Page4_GTASADir))
  If Right(InstallPath$,1)<>"\" And Right(InstallPath$,1)<>"/"
   InstallPath$+"\"
  EndIf
  If Right(GTAPath$,1)<>"\" And Right(GTAPath$,1)<>"/"
   GTAPath$+"\"
  EndIf
 If CreateDirectoryEx(InstallPath$)
  PackFile$=InstallPath$+"Setup.pack"
  InfoFile$=InstallPath$+"Setup.info"
  File=ReadFile(#PB_Any,ProgramFilename())
   If IsFile(File)
    FileSeek(File,Lof(File)-4)
    If ReadLong(File)=#SetupInfoValue
     FileSeek(File,Lof(File)-8)
     DataStart=ReadLong(File)
      If DataStart<Lof(File)
       DataFound=1
       FileSeek(File,DataStart)
       Pack=CreateFile(#PB_Any,PackFile$)
        If IsFile(Pack)
         For Byte=1 To Lof(File)-8
          WriteByte(Pack,ReadByte(File))
         Next
         CloseFile(Pack)
        EndIf
      EndIf
    EndIf
    CloseFile(File)
   EndIf
  If DataFound
   If OpenPack(PackFile$)
    UnpackFile(InfoFile$)
    SetGadgetText(#Page8_TextStatus,Language(42))
    File=ReadFile(#PB_Any,InfoFile$)
     If IsFile(File)
      Repeat
       String$=Trim(ReadString(File))
        If String$ And Left(String$,1)<>";"
         Files+1
        EndIf
      Until Eof(File)
      FileSeek(File,0)
      SetGadgetAttribute(#Page8_StatusAll,#PB_ProgressBar_Maximum,Files)
      Repeat
       String$=Trim(ReadString(File))
        If String$ And Left(String$,1)<>";"
         SetGadgetState(#Page8_StatusAll,GetGadgetState(#Page8_StatusAll)+1)
         UnpackFile(InstallPath$+String$)
        EndIf
      Until Eof(File)
      CloseFile(File)
      DeleteFile(InfoFile$)
     EndIf
    ClosePack()
    DeleteFile(PackFile$)
   Else
    MessageRequester(Language(36),ReplaceString(Language(52),"<br>",Chr(13),1),#MB_ICONERROR)
   EndIf
  Else
   If MessageRequester(Language(25),ReplaceString(Language(29),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
    SetGadgetText(#Page8_TextStatus,Language(43))
    Info$=InstallPath$+"Updates.info"
    DownloadFile("http://www.selfcoders.de/?page=updates&product=gta_sa_toolbox&type=updatelist",Info$)
    File=ReadFile(#PB_Any,Info$)
     If IsFile(File)
      Repeat
       String$=Trim(ReadString(File))
        If String$ And Left(String$,1)<>";"
         Files+1
        EndIf
      Until Eof(File)
      FileSeek(File,0)
      SetGadgetAttribute(#Page8_StatusAll,#PB_ProgressBar_Maximum,Files)
      Repeat
       String$=Trim(ReadString(File))
        If String$ And Left(String$,1)<>";"
         File$=Trim(StringField(String$,1,"|"))
         MD5$=Trim(StringField(String$,2,"|"))
         LFile$=ReplaceString(File$,"/","\",1)
         Download=1
          If IsFileEx(InstallPath$+LFile$)
           If LCase(MD5FileFingerprint(InstallPath$+LFile$))=LCase(MD5$)
            Download=0
           EndIf
          EndIf
          SetGadgetState(#Page8_StatusAll,GetGadgetState(#Page8_StatusAll)+1)
          If Download
           DownloadFile("http://www.selfcoders.de/"+File$,InstallPath$+LFile$)
          EndIf
        EndIf
      Until Eof(File)
      FileSeek(File,0)
      If OpenPack(PackFile$)
       Repeat
        String$=Trim(ReadString(File))
         If String$ And Left(String$,1)<>";"
          File$=ReplaceString(Trim(StringField(String$,1,"|")),"/","\",1)
          MD5$=Trim(StringField(String$,2,"|"))
          AddPackFile(InstallPath$+File$,9)
         EndIf
       Until Eof(File)
       ClosePack()
       Config\AddPackOnQuit=PackFile$
      EndIf
      CloseFile(File)
      DeleteFile(Info$)
     EndIf
   Else
    Setup=0
   EndIf
  EndIf
  If Setup
   SetGadgetText(#Page8_TextStatus,Language(46))
   If CreatePreferences(InstallPath$+"Settings.ini")
    PreferenceGroup("Global")
     Select GetGadgetState(#Page1_Language)
      Case 0
       WritePreferenceLong("Language",#LANG_ENGLISH)
      Case 1
       WritePreferenceLong("Language",#LANG_GERMAN)
     EndSelect
     WritePreferenceString("GTAFile",GTAPath$+"gta_sa.exe")
    PreferenceGroup("IgnoreList")
     WritePreferenceString("Vehicles","449;537;538;569;570;590")
    PreferenceGroup("CheatSound")
     WritePreferenceLong("UseCheatSound",1)
     WritePreferenceString("CheatSound",InstallPath$+"Sounds\Cheat5.wav")
    If GetGadgetState(#Page5_ConfigureLater)=0
     AdminPassword$=Trim(GetGadgetText(#Page5_AdminPassword))
     UserPassword$=Trim(GetGadgetText(#Page5_UserPassword))
     PreferenceGroup("WebServer")
      If AdminPassword$
       WritePreferenceString("AdminPassword",MD5Fingerprint(@AdminPassword$,Len(AdminPassword$)))
      EndIf
      If UserPassword$
       WritePreferenceString("UserPassword",MD5Fingerprint(@UserPassword$,Len(UserPassword$)))
      EndIf
      WritePreferenceLong("Port",Val(GetGadgetText(#Page5_Port)))
    EndIf
    PreferenceGroup("FileTypes")
     WritePreferenceString("col","Collision")
     WritePreferenceString("dat","Data")
     WritePreferenceString("dff","Model")
     WritePreferenceString("gxt","Text")
     WritePreferenceString("ide","Item Definition")
     WritePreferenceString("ifp","Animation")
     WritePreferenceString("img","IMG-Archive")
     WritePreferenceString("ipl","Map")
     WritePreferenceString("rrr","R3")
     WritePreferenceString("scm","Mission Script")
     WritePreferenceString("txd","Texture Archive")
     WritePreferenceString("zon","Zone")
    ClosePreferences()
   EndIf
   AddState()
   SetGadgetText(#Page8_TextStatus,Language(47))
    If RegCreateKeyEx_(#HKEY_LOCAL_MACHINE,"Software\SelfCoders",0,0,#REG_OPTION_NON_VOLATILE,#KEY_ALL_ACCESS,0,@NewKey,@KeyInfo)=#ERROR_SUCCESS
     RegSetValueEx_(NewKey,"GTA San Andreas ToolBox",0,#REG_SZ,InstallPath$,Len(InstallPath$)+1)
     RegCloseKey_(NewKey)
    EndIf
   File=CreateFile(#PB_Any,InstallPath$+"Reg.info")
    If IsFile(File)
     WriteFloat(File,#Version)
     WriteLong(File,#Build)
     CloseFile(File)
    EndIf
   AddState()
   If GetGadgetState(#Page3_NoStartmenu)=0
    SetGadgetText(#Page8_TextStatus,Language(48))
    If GetGadgetState(#Page3_TextNewDir)
     StartmenuPath$=GetPath(23)+Trim(GetGadgetText(#Page3_NewDir))
    ElseIf GetGadgetState(#Page3_TextPresentDir)
     StartmenuPath$=GetPath(23)+Trim(GetGadgetText(#Page3_PresentDir))
    EndIf
    If Right(StartmenuPath$,1)<>"\" And Right(StartmenuPath$,1)<>"/"
     StartmenuPath$+"\"
    EndIf
    If CreateDirectoryEx(StartmenuPath$)
     CreateShortcut(InstallPath$+"GTA ToolBox GUI.exe",StartmenuPath$+"GUI.lnk","","GTA San Andreas ToolBox GUI",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"GTA ToolBox GUI.exe",0)
     CreateShortcut(InstallPath$+"GTATB_CheatProcessor.exe",StartmenuPath$+"CheatProcessor.lnk","","GTA San Andreas ToolBox CheatProcessor",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"GTATB_CheatProcessor.exe",0)
     CreateShortcut(InstallPath$+"GTATB_WebServ.exe",StartmenuPath$+"WebServer.lnk","","GTA San Andreas ToolBox WebServer",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"GTATB_WebServ.exe",0)
     If CreateDirectoryEx(StartmenuPath$+"Help\")
      CreateShortcut(InstallPath$+"Help.exe",StartmenuPath$+"Help\English.lnk","Help\English.tbh","GTA San Andreas ToolBox HelpViewer",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"Help.exe",0)
      CreateShortcut(InstallPath$+"Help.exe",StartmenuPath$+"Help\Deutsch.lnk","Help\German.tbh","GTA San Andreas ToolBox HelpViewer",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"Help.exe",0)
     EndIf
    EndIf
   EndIf
   If GetGadgetState(#Page6_DesktopIcon)
    CreateShortcut(InstallPath$+"GTA ToolBox GUI.exe",GetPath(16)+"GTA San Andreas ToolBox.lnk","","GTA San Andreas ToolBox GUI",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"GTA ToolBox GUI.exe",0)
   EndIf
   AddState()
   If GetGadgetState(#Page6_InstallSplashScreens)
    RenameFile(GTAPath$+"models\txd\LOADSCS.txd",GTAPath$+"models\txd\LOADSCS.txd.old")
    CopyFile(InstallPath$+"SplashMod\LOADSCS.txd",GTAPath$+"models\txd\LOADSCS.txd")
   EndIf
  EndIf
 EndIf
EndProcedure

Procedure SelectPage()
 For Gadget=#Page1 To #Page9
  HideGadget(Gadget,1)
 Next
 HideGadget(Config\Page,0)
 SetGadgetText(#Back,Language(2))
 SetGadgetText(#Next,Language(3))
 DisableGadget(#Back,0)
 DisableGadget(#Next,0)
 SetWindowTitle(#Window,"GTA San Andreas ToolBox - Setup ["+Language(20)+" "+Str(Config\Page)+"/9]")
 Select Config\Page
  Case #Page1
   SetGadgetText(#Back,Language(4))
   SetGadgetText(#Header,"GTA San Andreas ToolBox v2.00")
  Case #Page2
   SetGadgetText(#Header,Language(9))
  Case #Page3
   SetGadgetText(#Header,Language(13))
  Case #Page4
   SetGadgetText(#Header,Language(18))
  Case #Page5
   SetGadgetText(#Header,"WebServer")
  Case #Page6
   SetGadgetText(#Header,Language(21))
  Case #Page7
   SetGadgetText(#Header,Language(26))
   SetGadgetText(#Page7_InstallDir,GetGadgetText(#Page2_InstallDir))
   If GetGadgetState(#Page3_NoStartmenu)=0
    If GetGadgetState(#Page3_TextNewDir)
     SetGadgetText(#Page7_StartmenuDir,GetGadgetText(#Page3_NewDir))
    ElseIf GetGadgetState(#Page3_TextPresentDir)
     SetGadgetText(#Page7_StartmenuDir,GetGadgetText(#Page3_PresentDir))
    EndIf
   EndIf
   SetGadgetText(#Page7_GTASADir,GetGadgetText(#Page4_GTASADir))
   If GetGadgetState(#Page5_ConfigureLater)
    SetGadgetText(#Page7_WebServer,Language(34))
   Else
    SetGadgetText(#Page7_WebServer,"Port: "+GetGadgetText(#Page5_Port))
   EndIf
   If GetGadgetState(#Page6_DesktopIcon)
    Advanced$+Language(23)+Chr(13)
   EndIf
   If GetGadgetState(#Page6_InstallSplashScreens)
    Advanced$+Language(24)+Chr(13)
   EndIf
   SetGadgetText(#Page7_Advanced,Left(Advanced$,Len(Advanced$)-1))
   SetGadgetText(#Next,Language(5))
  Case #Page8
   SetGadgetText(#Header,"Installation")
   DisableGadget(#Back,1)
   DisableGadget(#Next,1)
   Config\SetupThread=CreateThread(@Setup(),0)
  Case #Page9
   SetGadgetText(#Header,Language(35))
   DisableGadget(#Back,1)
   SetGadgetText(#Next,Language(8))
 EndSelect
EndProcedure

Procedure DownloadUpdates()
 Config\Page=#Page8
 SelectPage()
 Path$=ReadRegValue(#HKEY_LOCAL_MACHINE,"Software\SelfCoders","GTA San Andreas ToolBox")
  If Path$
   DownloadFile("http://www.selfcoders.de/?page=updates&product=gta_sa_toolbox&type=updatelist",Path$+"Update.info")
   File=ReadFile(#PB_Any,Path$+"Update.info")
    If IsFile(File)
     ReadString(File)
     Repeat
      String$=Trim(ReadString(File))
       If String$ And Left(String$,1)<>";"
        Files+1
       EndIf
      WindowEvent()
     Until Eof(File)
     FileSeek(File,0)
     SetGadgetAttribute(#Page8_StatusAll,#PB_ProgressBar_Maximum,Files)
     Url$=Trim(ReadString(File))
     Repeat
      WindowEvent()
      String$=Trim(ReadString(File))
       If String$ And Left(String$,1)<>";"
        File$=Trim(StringField(String$,1,"|"))
        MD5$=Trim(StringField(String$,2,"|"))
        SetGadgetState(#Page8_StatusAll,GetGadgetState(#Page8_StatusAll)+1)
        Download=1
        If IsFileEx(Path$+File$)
         If LCase(Trim(MD5FileFingerprint(Path$+File$)))=LCase(Trim(MD5$))
          Download=0
         EndIf
        EndIf
        If Download
         DownloadFile(Url$+File$,Path$+File$)
        EndIf
       EndIf
     Until Eof(File)
     CloseFile(File)
    EndIf
  EndIf
 Config\Page=#Page9
 SelectPage()
EndProcedure

Procedure ReloadLanguage(Language)
 Select Language
  Case 0
   Restore Language_English
  Case 1
   Restore Language_German
 EndSelect
 For Lang=0 To #MaxLang
  Read Language(Lang)
 Next
 SetGadgetText(#Page1_TextInfo,ReplaceString(Language(0),"<br>",Chr(13),1))
 SetGadgetText(#Page1_TextLanguage,Language(1))
 SetGadgetText(#Page2_TextInfo,Language(10))
 SetGadgetText(#Page2_TextDirectory,Language(11))
 SetGadgetText(#Page2_SelectDir,Language(12))
 SetGadgetText(#Page3_TextInfo,Language(14))
 SetGadgetText(#Page3_TextNewDir,Language(15))
 SetGadgetText(#Page3_TextPresentDir,Language(16))
 SetGadgetText(#Page3_NoStartmenu,Language(17))
 SetGadgetText(#Page4_TextInfo,Language(19))
 SetGadgetText(#Page4_TextDirectory,Language(11))
 SetGadgetText(#Page4_SelectDir,Language(12))
 SetGadgetText(#Page5_TextInfo,Language(30))
 SetGadgetText(#Page5_RandomPort,Language(31))
 SetGadgetText(#Page5_FramePasswords,Language(32))
 SetGadgetText(#Page5_TextUserPW,Language(33))
 SetGadgetText(#Page5_ConfigureLater,Language(34))
 SetGadgetText(#Page6_TextInfo,Language(22))
 SetGadgetText(#Page6_DesktopIcon,Language(23))
 SetGadgetText(#Page6_InstallSplashScreens,Language(24))
 SetGadgetText(#Page7_TextInfo,Language(26))
 SetGadgetText(#Page7_FrameDir,Language(27))
 SetGadgetText(#Page7_TextInstallDir,Language(9)+":")
 SetGadgetText(#Page7_TextStartmenuDir,Language(13)+":")
 SetGadgetText(#Page7_TextGTASADir,Language(18)+":")
 SetGadgetText(#Page7_FrameAdvanced,Language(21))
 SetGadgetText(#Page8_TextInfo,Language(41))
 SetGadgetText(#Page8_TextStatusAll,Language(44))
 SetGadgetText(#Page8_TextStatusFile,Language(45))
 SetGadgetText(#Page9_TextInfo,ReplaceString(Language(46),"<br>",Chr(13),1))
 SetGadgetText(#Page9_Frame,Language(47))
 SetGadgetText(#Page9_RunGUI,Language(48))
 SetGadgetText(#Page9_ShowHelp,Language(49))
 SetGadgetText(#Page9_GotoSelfCodersHome,Language(50))
 SelectPage()
EndProcedure

Procedure AutoCompletePath(Gadget)
 If CallFunctionFast(Config\AutoCompletePath,GadgetID(Gadget),$40000000|$10000000|$00000001)=#S_OK
  ProcedureReturn 1
 EndIf
EndProcedure

LoadFont(#Font_Header,"Arial",20,#PB_Font_Bold)
LoadFont(#Font_Normal,"Arial",10)
LoadFont(#Font_Bold,"Arial",10,#PB_Font_Bold)

Config\Parameter=Trim(GetFullProgramparameter())
Config\Page=#Page1

If LCase(StringField(Config\Parameter,1,"="))="/renamefile"
 File$=GetPathPart(ProgramFilename())+Trim(StringField(Config\Parameter,2,"="))
 CopyFile(ProgramFilename(),File$)
 RunProgram(File$,"/deletetmp="+GetFilePart(ProgramFilename()),GetPathPart(File$))
 End
ElseIf LCase(StringField(Config\Parameter,1,"="))="/deletetmp"
 DeleteFile(GetPathPart(ProgramFilename())+Trim(StringField(Config\Parameter,2,"=")))
 MessageRequester("Info","Successful!",#MB_ICONINFORMATION)
 End
EndIf

If OpenLibrary(#Dll_shlwapi,"shlwapi.dll")
 Config\AutoCompletePath=GetFunction(#Dll_shlwapi,"SHAutoComplete")
EndIf

Restore ImageInfo
For Image=0 To #MaxImages
 Read String$
 AddElement(Picture())
 Picture()=Val(String$)
Next

If OpenWindow(#Window,100,100,600,500,"",#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
 If CreateGadgetList(WindowID(#Window))
  TextGadget(#Header,10,10,WindowWidth(#Window)-20,30,"",#PB_Text_Center)
  OpenPage(#Page1)
   TextGadget(#Page1_TextInfo,10,10,GadgetWidth(#Page1)-20,GadgetHeight(#Page1)-110,"")
   TextGadget(#Page1_TextLanguage,10,GadgetHeight(#Page1_TextInfo)+80,60,20,"")
   ComboBoxGadget(#Page1_Language,80,GadgetY(#Page1_TextLanguage),100,20)
    AddGadgetItem(#Page1_Language,-1,"English")
    AddGadgetItem(#Page1_Language,-1,"Deutsch")
  CloseGadgetList()
  OpenPage(#Page2)
   TextGadget(#Page2_TextInfo,10,10,GadgetWidth(#Page2)-20,50,"")
   TextGadget(#Page2_TextDirectory,10,70,70,20,"")
   StringGadget(#Page2_InstallDir,90,70,GadgetWidth(#Page2)-210,20,GetPath(38)+"SelfCoders\GTA San Andreas ToolBox")
   ButtonGadget(#Page2_SelectDir,GadgetWidth(#Page2_InstallDir)+100,70,100,20,"")
  CloseGadgetList()
  OpenPage(#Page3)
   TextGadget(#Page3_TextInfo,10,10,GadgetWidth(#Page3)-20,50,"")
   OptionGadget(#Page3_TextNewDir,10,70,100,20,"")
   OptionGadget(#Page3_TextPresentDir,10,100,140,20,"")
   StringGadget(#Page3_NewDir,120,70,GadgetWidth(#Page3)-130,20,"SelfCoders\GTA San Andreas ToolBox")
   ListViewGadget(#Page3_PresentDir,10,120,GadgetWidth(#Page3)-20,GadgetHeight(#Page3)-160)
   CheckBoxGadget(#Page3_NoStartmenu,10,GadgetHeight(#Page3)-30,GadgetWidth(#Page3)-20,20,"")
  CloseGadgetList()
  OpenPage(#Page4)
   TextGadget(#Page4_TextInfo,10,10,GadgetWidth(#Page4)-20,50,"")
   TextGadget(#Page4_TextDirectory,10,70,70,20,"")
   StringGadget(#Page4_GTASADir,90,70,GadgetWidth(#Page4)-210,20,"")
   ButtonGadget(#Page4_SelectDir,GadgetWidth(#Page4_GTASADir)+100,70,100,20,"")
  CloseGadgetList()
  OpenPage(#Page5)
   TextGadget(#Page5_TextInfo,10,10,GadgetWidth(#Page5)-20,50,"")
   TextGadget(#Page5_TextPort,10,70,40,20,"Port:")
   StringGadget(#Page5_Port,60,70,100,20,"80",#PB_String_Numeric)
   ButtonGadget(#Page5_RandomPort,170,70,100,20,"")
   Frame3DGadget(#Page5_FramePasswords,10,100,GadgetWidth(#Page5)-20,90,"")
    TextGadget(#Page5_TextAdminPW,20,130,90,20,"Administrator:")
    TextGadget(#Page5_TextUserPW,20,160,90,20,"")
    StringGadget(#Page5_AdminPassword,110,130,GadgetWidth(#Page5_FramePasswords)-110,20,"",#PB_String_Password)
    StringGadget(#Page5_UserPassword,110,160,GadgetWidth(#Page5_FramePasswords)-110,20,"",#PB_String_Password)
   CheckBoxGadget(#Page5_ConfigureLater,10,GadgetHeight(#Page5)-30,GadgetWidth(#Page5)-20,20,"")
  CloseGadgetList()
  OpenPage(#Page6)
   TextGadget(#Page6_TextInfo,10,10,GadgetWidth(#Page6)-20,50,"")
   ScrollAreaGadget(#Page6_ScrollArea,10,70,GadgetWidth(#Page6)-20,GadgetHeight(#Page6)-80,GadgetWidth(#Page6)-30,100,10,#PB_ScrollArea_Flat)
    CheckBoxGadget(#Page6_DesktopIcon,10,10,GadgetWidth(#Page6_ScrollArea)-20,20,"")
    CheckBoxGadget(#Page6_InstallSplashScreens,10,30,GadgetWidth(#Page6_ScrollArea)-20,20,"")
   CloseGadgetList()
  CloseGadgetList()
  OpenPage(#Page7)
   TextGadget(#Page7_TextInfo,10,10,GadgetWidth(#Page7)-20,50,"")
   ScrollAreaGadget(#Page7_ScrollArea,10,70,GadgetWidth(#Page7)-20,GadgetHeight(#Page7)-80,GadgetWidth(#Page7)-30,300,10,#PB_ScrollArea_Flat)
    Frame3DGadget(#Page7_FrameDir,10,10,GadgetWidth(#Page7_ScrollArea)-20,110,"")
     HyperLinkGadget(#Page7_TextInstallDir,20,30,190,20,"",0)
     HyperLinkGadget(#Page7_TextStartmenuDir,20,60,190,20,"",0)
     HyperLinkGadget(#Page7_TextGTASADir,20,90,190,20,"",0)
     StringGadget(#Page7_InstallDir,210,30,GadgetWidth(#Page7_FrameDir)-210,20,"",#PB_String_ReadOnly)
     StringGadget(#Page7_StartmenuDir,210,60,GadgetWidth(#Page7_FrameDir)-210,20,"",#PB_String_ReadOnly)
     StringGadget(#Page7_GTASADir,210,90,GadgetWidth(#Page7_FrameDir)-210,20,"",#PB_String_ReadOnly)
    Frame3DGadget(#Page7_FrameWebServer,10,130,GadgetWidth(#Page7_ScrollArea)-20,50,"WebServer")
     TextGadget(#Page7_WebServer,20,150,GadgetWidth(#Page7_FrameWebServer)-20,GadgetHeight(#Page7_FrameWebServer)-30,"")
    Frame3DGadget(#Page7_FrameAdvanced,10,190,GadgetWidth(#Page7_ScrollArea)-20,110,"")
     TextGadget(#Page7_Advanced,20,210,GadgetWidth(#Page7_FrameAdvanced)-20,GadgetHeight(#Page7_FrameAdvanced)-30,"")
   CloseGadgetList()
  CloseGadgetList()
  OpenPage(#Page8)
   TextGadget(#Page8_TextInfo,10,10,GadgetWidth(#Page8)-20,50,"")
   TextGadget(#Page8_Text,10,70,40,20,"Status:")
   TextGadget(#Page8_TextStatus,60,70,GadgetWidth(#Page8)-70,20,"")
   Frame3DGadget(#Page8_FrameProgress,10,100,GadgetWidth(#Page8)-20,80,"")
    TextGadget(#Page8_TextStatusAll,20,120,90,20,"")
    TextGadget(#Page8_TextStatusFile,20,150,90,20,"")
    ProgressBarGadget(#Page8_StatusAll,120,120,GadgetWidth(#Page8_FrameProgress)-120,20,0,21,#PB_ProgressBar_Smooth)
    ProgressBarGadget(#Page8_StatusFile,120,150,GadgetWidth(#Page8_FrameProgress)-120,20,0,0,#PB_ProgressBar_Smooth)
  CloseGadgetList()
  OpenPage(#Page9)
   TextGadget(#Page9_TextInfo,10,10,GadgetWidth(#Page9)-20,100,"")
   Frame3DGadget(#Page9_Frame,10,GadgetHeight(#Page9_TextInfo)+20,GadgetWidth(#Page9)-20,90,"")
    CheckBoxGadget(#Page9_RunGUI,20,GadgetY(#Page9_Frame)+20,GadgetWidth(#Page9_Frame)-20,20,"")
    CheckBoxGadget(#Page9_ShowHelp,20,GadgetY(#Page9_Frame)+40,GadgetWidth(#Page9_Frame)-20,20,"")
    CheckBoxGadget(#Page9_GotoSelfCodersHome,20,GadgetY(#Page9_Frame)+60,GadgetWidth(#Page9_Frame)-20,20,"")
  CloseGadgetList()
  ButtonGadget(#Back,10,WindowHeight(#Window)-40,100,30,"")
  ButtonGadget(#Next,WindowWidth(#Window)-110,GadgetY(#Back),100,30,"")
 EndIf
 For Gadget=#Page1 To #Next
  If IsGadget(Gadget)
   SetGadgetFont(Gadget,FontID(#Font_Normal))
  EndIf
 Next
 Dir=ExamineDirectory(#PB_Any,GetPath(23),"*.*")
  If IsDirectory(Dir)
   While NextDirectoryEntry(Dir)
    Name$=DirectoryEntryName(Dir)
     If Name$<>"." And Name$<>".."
      If DirectoryEntryType(Dir)=#PB_DirectoryEntry_Directory
       AddGadgetItem(#Page3_PresentDir,-1,Name$)
      EndIf
     EndIf
   Wend
   FinishDirectory(Dir)
  EndIf
 Path$=GetPathPart(RemoveString(ReadRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Rockstar Games\GTA San Andreas\Installation","ExePath"),Chr(34),1))
  If Right(Path$,1)="\" Or Right(Path$,1)="/"
   Path$=Left(Path$,Len(Path$)-1)
  EndIf
 SetGadgetText(#Page4_GTASADir,Path$)
 SetGadgetState(#Page3_TextNewDir,1)
 DisableGadget(#Page3_PresentDir,1)
 SetGadgetFont(#Back,FontID(#Font_Bold))
 SetGadgetFont(#Next,FontID(#Font_Bold))
 SetGadgetFont(#Header,FontID(#Font_Header))
 If GetUserLanguage()=#LANG_GERMAN
  SetGadgetState(#Page1_Language,1)
  ReloadLanguage(1)
 Else
  SetGadgetState(#Page1_Language,0)
  ReloadLanguage(0)
 EndIf
 AutoCompletePath(#Page2_InstallDir)
 AutoCompletePath(#Page4_GTASADir)
 SelectPage()
 Repeat
  If Config\Page=#Page8
   If IsThread(Config\SetupThread)
    SetGadgetState(#Page8_StatusAll,Config\SetupStatusAll)
    SetGadgetState(#Page8_StatusFile,Config\SetupStatusFile)
   Else
    Config\Page=#Page9
    SelectPage()
   EndIf
  EndIf
  Select WaitWindowEvent(5)
   Case #PB_Event_Gadget
    Select EventGadget()
     Case #Page1_Language
      ReloadLanguage(GetGadgetState(#Page1_Language))
     Case #Page2_SelectDir
      Path$=GetGadgetText(#Page2_InstallDir)
       If Right(Path$,1)<>"\" And Right(Path$,1)<>"/"
        Path$+"\"
       EndIf
      Path$=PathRequester(Language(10),Path$)
       If Path$ And Path$<>"\" And Path$<>"/"
        If Right(Path$,1)="\" Or Right(Path$,1)="/"
         Path$=Left(Path$,Len(Path$)-1)
        EndIf
        SetGadgetText(#Page2_InstallDir,Path$)
       EndIf
     Case #Page3_TextNewDir
      DisableGadget(#Page3_NewDir,0)
      DisableGadget(#Page3_PresentDir,1)
     Case #Page3_TextPresentDir
      DisableGadget(#Page3_NewDir,1)
      DisableGadget(#Page3_PresentDir,0)
     Case #Page3_NoStartmenu
      If GetGadgetState(#Page3_NoStartmenu)
       DisableGadget(#Page3_TextNewDir,1)
       DisableGadget(#Page3_TextPresentDir,1)
       DisableGadget(#Page3_NewDir,1)
       DisableGadget(#Page3_PresentDir,1)
      Else
       DisableGadget(#Page3_TextNewDir,0)
       DisableGadget(#Page3_TextPresentDir,0)
       If GetGadgetState(#Page3_TextNewDir)
        DisableGadget(#Page3_NewDir,0)
       ElseIf GetGadgetState(#Page3_TextPresentDir)
        DisableGadget(#Page3_PresentDir,0)
       EndIf
      EndIf
     Case #Page4_SelectDir
      Path$=GetGadgetText(#Page4_GTASADir)
       If Right(Path$,1)<>"\" And Right(Path$,1)<>"/"
        Path$+"\"
       EndIf
      Path$=PathRequester(Language(19),Path$)
       If Path$ And Path$<>"\" And Path$<>"/"
        If Right(Path$,1)="\" Or Right(Path$,1)="/"
         Path$=Left(Path$,Len(Path$)-1)
        EndIf
        SetGadgetText(#Page4_GTASADir,Path$)
       EndIf
     Case #Page5_RandomPort
      SetGadgetText(#Page5_Port,Str(RandomEx(1,65000)))
     Case #Page5_ConfigureLater
      For Gadget=#Page5_TextPort To #Page5_UserPassword
       DisableGadget(Gadget,GetGadgetState(#Page5_ConfigureLater))
      Next
     Case #Page7_TextInstallDir
      Config\Page=#Page2
      SelectPage()
     Case #Page7_TextStartmenuDir
      Config\Page=#Page3
      SelectPage()
     Case #Page7_TextGTASADir
      Config\Page=#Page4
      SelectPage()
     Case #Back
      If Config\Page=#Page1
       Quit=Quit()
      Else
       Config\Page-1
      EndIf
      SelectPage()
     Case #Next
      Select Config\Page
       Case #Page1
        Config\Page=#Page2
       Case #Page2
        Path$=Trim(GetGadgetText(#Page2_InstallDir))
         If Path$ And Path$<>"\" And Path$<>"/"
          Config\Page=#Page3
         Else
          MessageRequester(Language(36),Language(38),#MB_ICONERROR)
         EndIf
       Case #Page3
        If GetGadgetState(#Page3_NoStartmenu)
         Config\Page=#Page4
        Else
         If GetGadgetState(#Page3_TextNewDir)
          If Trim(GetGadgetText(#Page3_NewDir))
           Config\Page=#Page4
          Else
           MessageRequester(Language(36),Language(39),#MB_ICONERROR)
          EndIf
         ElseIf GetGadgetState(#Page3_TextPresentDir)
          If GetGadgetState(#Page3_PresentDir)=-1
           MessageRequester(Language(36),Language(39),#MB_ICONERROR)
          Else
           Config\Page=#Page4
          EndIf
         EndIf
        EndIf
       Case #Page4
        Path$=Trim(GetGadgetText(#Page4_GTASADir))
         If Path$ And Path$<>"\" And Path$<>"/"
          If Right(Path$,1)<>"\" And Right(Path$,1)<>"/"
           Path$+"\"
          EndIf
          If IsFileEx(Path$+"gta_sa.exe")
           Config\Page=#Page5
          Else
           MessageRequester(Language(36),Language(40),#MB_ICONERROR)
          EndIf
         Else
          MessageRequester(Language(36),Language(38),#MB_ICONERROR)
         EndIf
       Case #Page5
        If GetGadgetState(#Page5_ConfigureLater)=0
         Port=Val(GetGadgetText(#Page5_Port))
          If Port=>1 And Port<=65000
           Config\Page=#Page6
          Else
           MessageRequester(Language(36),Language(41),#MB_ICONERROR)
          EndIf
        Else
         Config\Page=#Page6
        EndIf
       Case #Page6
        Config\Page=#Page7
       Case #Page7
        CheckToolBoxRunning()
        If Config\ContinueSetup
         Config\Page=#Page8
        EndIf
       Case #Page9
        InstallPath$=Trim(GetGadgetText(#Page2_InstallDir))
         If Right(InstallPath$,1)<>"\" And Right(InstallPath$,1)<>"/"
          InstallPath$+"\"
         EndIf
        If GetGadgetState(#Page9_RunGUI)
         RunProgram(InstallPath$+"GTA ToolBox GUI.exe","",InstallPath$)
        EndIf
        If GetGadgetState(#Page9_ShowHelp)
         Select GetGadgetState(#Page1_Language)
          Case 0
           File$="Help\English.tbh"
          Case 1
           File$="Help\German.tbh"
         EndSelect
         RunProgram(InstallPath$+"Help.exe",File$,InstallPath$)
        EndIf
        If GetGadgetState(#Page9_GotoSelfCodersHome)
         RunProgram("http://www.selfcoders.de")
        EndIf
        Quit=1
      EndSelect
      SelectPage()
    EndSelect
   Case #PB_Event_CloseWindow
    If Config\Page=#Page9
     Quit=1
    Else
     Quit=Quit()
    EndIf
  EndSelect
 Until Quit
EndIf

If Config\AddPackOnQuit
 Tmp$=ProgramFilename()+".tmp.exe"
 File=ReadFile(#PB_Any,ProgramFilename())
  If IsFile(File)
   FileSeek(File,Lof(File)-4)
   Save=CreateFile(#PB_Any,Tmp$)
    If IsFile(Save)
     If ReadLong(File)=#SetupInfoValue
      FileSeek(File,Lof(File)-8)
      EndMain=ReadLong(File)-1
     Else
      EndMain=Lof(File)
     EndIf
     For Byte=1 To EndMain
      WriteByte(Save,ReadByte(File))
     Next
     DataStart=Lof(Save)
     Pack=ReadFile(#PB_Any,Config\AddPackOnQuit)
      If IsFile(Pack)
       Repeat
        WriteByte(Save,ReadByte(Pack))
       Until Eof(Pack)
       CloseFile(Pack)
      EndIf
     WriteLong(Save,DataStart)
     WriteLong(Save,#SetupInfoValue)
     CloseFile(Save)
     RunProgram(Tmp$,"/renamefile="+GetFilePart(ProgramFilename()),GetPathPart(Tmp$))
    EndIf
   CloseFile(File)
  EndIf
EndIf

DataSection
 Language_English:
  Data$ "Welcome to the setupwizzard of the GTA San Andreas ToolBox!<br>This wizzard will help you to install the GTA San Andreas ToolBox on your computer.<br><br>Select the language, you want to use while the setup and in the GTA San Andreas ToolBox and than press 'Next'."; 0
  Data$ "Language:"; 1
  Data$ "Back"; 2
  Data$ "Next"; 3
  Data$ "Cancel"; 4
  Data$ "Install"; 5
  Data$ "Cancel setup"; 6
  Data$ "The installation is not complete!<br><br>Are you sure to cancel the installation?"; 7
  Data$ "Close"; 8
  Data$ "Installdirectory"; 9
  Data$ "Select the directory you want to install the GTA San Andreas ToolBox in."; 10
  Data$ "Directory:"; 11
  Data$ "Open"; 12
  Data$ "Startmenufolder"; 13
  Data$ "Select the startmenufolder for the GTA San Andreas ToolBox."; 14
  Data$ "New folder"; 15
  Data$ "Present folder"; 16
  Data$ "Don´t create items in startmenu"; 17
  Data$ "GTA San Andreas directory"; 18
  Data$ "Select the directory in which GTA San Andreas is installed."; 19
  Data$ "Page"; 20
  Data$ "Advanced options"; 21
  Data$ "On this page you can select optional components and options."; 22
  Data$ "Create shortcut on desktop"; 23
  Data$ "Replace splashscreens of GTA San Andreas"; 24
  Data$ ""; 25
  Data$ "Summary"; 26
  Data$ "On this page you can see the details for the installation."; 27
  Data$ "Directories"; 28
  Data$ ""; 29
  Data$ "Input the data for the WebServer or select 'Configure later'."; 30
  Data$ "Random"; 31
  Data$ "Passwords"; 32
  Data$ "user"; 33
  Data$ "Configure later"; 34
  Data$ "Installation complete"; 35
  Data$ "Error"; 36
  Data$ "You have to close the GTA San Andreas ToolBox before starting the installation!<br>Please close the GTA San Andreas ToolBox and click on 'Retry'."; 37
  Data$ "The given directory is invalid!"; 38
  Data$ "Please select a startmenufolder!"; 39
  Data$ "The given directory contains no GTA San Andreas!"; 40
  Data$ "The port must be a value from 1 to 65000!"; 41
  Data$ "Please wait while the installation of the GTA San Andreas is running."; 42
  Data$ "extracting files"; 43
  Data$ "downloading files"; 44
  Data$ "Total:"; 45
  Data$ "Current file:"; 46
  Data$ "The GTA San Andreas ToolBox was successful installed!<br>Now you can run the GTA San Andreas ToolBox if you select 'Run GTA San Andreas ToolBox' and click on 'Close', with the startmenu or the desktop.<br><br>Have fun with the GTA San Andreas ToolBox!"; 47
  Data$ "Options"; 48
  Data$ "Run GTA San Andreas ToolBox"; 49
  Data$ "Show help"; 50
  Data$ "Goto SelfCoders-Home"; 51
 Language_German:
  Data$ "Willkommen bei dem Setupwizzard von der GTA San Andreas ToolBox!<br>Dieser Wizzard wird dir nun helfen, die GTA San Andreas ToolBox auf deinem Computer zu installieren.<br><br>Wähle die Sprache, die du während dem Setup und in der GTA San Andreas ToolBox verwenden möchtest und drücke dann auf 'Weiter'."; 0
  Data$ "Sprache:"; 1
  Data$ "Zurück"; 2
  Data$ "Weiter"; 3
  Data$ "Abbrechen"; 4
  Data$ "Installieren"; 5
  Data$ "Setup abbrechen"; 6
  Data$ "Die Installation ist noch nicht vollständig!<br><br>Bist du dir sicher, dass du die Installation abbrechen möchtest?"; 7
  Data$ "Schließen"; 8
  Data$ "Installationsverzeichnis"; 9
  Data$ "Wähle das Verzeichnis aus, in welchem du die GTA San Andreas ToolBox installieren möchtest."; 10
  Data$ "Verzeichnis:"; 11
  Data$ "Öffnen"; 12
  Data$ "Startmenüordner"; 13
  Data$ "Wähle den Startmenüordner für die GTA San Andreas ToolBox aus."; 14
  Data$ "Neuer Ordner"; 15
  Data$ "Vorhandener Ordner"; 16
  Data$ "Keine Einträge im Startmenü erstellen"; 17
  Data$ "GTA San Andreas Verzeichnis"; 18
  Data$ "Wähle das Verzeichnis aus, in welchem GTA San Andreas installiert ist."; 19
  Data$ "Seite"; 20
  Data$ "Erweiterte Optionen"; 21
  Data$ "Auf dieser Seite kannst du optionale Komponenten und Optionen auswählen."; 22
  Data$ "Verknüpfung auf dem Desktop erstellen"; 23
  Data$ "Splashscreens in GTA San Andreas ersetzen"; 24
  Data$ "Dateien herunterladen"; 25
  Data$ "Zusammenfassung"; 26
  Data$ "Auf dieser Seite kannst du dir noch einmal die Details für die Installation ansehen."; 27
  Data$ "Verzeichnisse"; 26
  Data$ "Die Installationsdateien wurden noch nicht heruntergeladen!<br>Sollen diese nun heruntergeladen werden?"; 29
  Data$ "Gebe die Daten für den WebServer an oder wähle 'Später konfiguieren'."; 30
  Data$ "Zufall"; 31
  Data$ "Passwörter"; 32
  Data$ "Benutzer"; 33
  Data$ "Später konfiguieren"; 34
  Data$ "Installation abgeschlossen"; 35
  Data$ "Fehler"; 36
  Data$ "Die GTA San Andreas ToolBox muss beendet werden, bevor die Installation gestartet werden kann!<br>Bitte beende die GTA San Andreas ToolBox und klicke auf 'Wiederholen'."; 37
  Data$ "Das angegebene Verzeichnis ist ungültig!"; 38
  Data$ "Bitte wähle einen Startmenüordner aus!"; 39
  Data$ "Das angegebene Verzeichnis enthält kein GTA San Andreas!"; 40
  Data$ "Der Port muss ein Wert von 1 bis 65000 sein!"; 41
  Data$ "Bitte warte, während die Installation der GTA San Andreas ToolBox durchgeführt wird."; 42
  Data$ "Dateien entpacken"; 43
  Data$ "Dateien herunterladen"; 44
  Data$ "Gesamt:"; 45
  Data$ "Aktuelle Datei:"; 46
  Data$ "Die GTA San Andreas ToolBox wurde erfolgreich installiert!<br>Du kannst nun die GTA San Andreas ToolBox starten, in dem du unten 'GTA San Andreas ToolBox starten' auswählst und auf 'Schließen' klickst, oder über das Startmenü bzw. über den Desktop.<br><br>Viel Spass mit der GTA San Andreas ToolBox!"; 47
  Data$ "Optionen"; 48
  Data$ "GTA San Andreas ToolBox starten"; 49
  Data$ "Hilfe anzeigen"; 50
  Data$ "Auf SelfCoders-Home gehen"; 51
  Data$ "Die eingebundenen Installationsdateien sind beschädigt!<br>Bitte lade die Installationsdateien erneut runter."; 52
EndDataSection