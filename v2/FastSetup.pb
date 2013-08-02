Enumeration
 #Window
 #Language
 #OK
 #Text1
 #InstallDir
 #OpenInstallDir
 #Text2
 #GTAFile
 #OpenGTAFile
 #AdvancedOptions
 #AdvancedContainer
 #CreateStartmenufolder
 #Text3
 #CreateDesktopicon
 #Text4
 #InstallSplashMod
 #Text5
 #Autostart
 #Text6
 #RegSATBS
 #Text7
 #RunAfterInstall
 #Text8
 #Install
EndEnumeration

Enumeration
 #Font_Normal
 #Font_Bold
EndEnumeration

Structure Config
 MainPath.s
 PrefsFile.s
 GTAFile.s
 Parameter.s
 ExplorerMsg.l
EndStructure

#MaxLang=25

Global Config.Config
Global Dim Language.s(#MaxLang)

IncludeFile "Common.pbi"

Procedure CreateInternetShortcut(File$,Url$)
 If CreateDirectoryEx(GetPathPart(File$))
  If CreatePreferences(File$)
   PreferenceGroup("InternetShortcut")
    WritePreferenceString("Url",Url$)
   ClosePreferences()
  EndIf
 EndIf
EndProcedure

Procedure DeleteRegKey(HKey,Path$)
 MessageRequester("Information","DeleteRegKey is not included yet!",#MB_ICONINFORMATION)
EndProcedure

Procedure RegFile(Extension$,Name$,DisplayName$,Command$)
 SetRegValue(#HKEY_CLASSES_ROOT,"."+Extension$+"\shell\"+Name$,"",DisplayName$)
 SetRegValue(#HKEY_CLASSES_ROOT,"."+Extension$+"\shell\"+Name$+"\Command","",Command$)
EndProcedure

Procedure UnRegFile(Extension$,Name$)
 If Name$
  Name$="\"+Name$
  DeleteRegValue(#HKEY_CLASSES_ROOT,"."+Extension$+"\shell"+Name$+"\Command","")
  DeleteRegKey(#HKEY_CLASSES_ROOT,"."+Extension$+"\shell"+Name$+"\Command")
 EndIf
 DeleteRegValue(#HKEY_CLASSES_ROOT,"."+Extension$+"\shell"+Name$,"")
 DeleteRegKey(#HKEY_CLASSES_ROOT,"."+Extension$+"\shell"+Name$)
EndProcedure

LoadFont(#Font_Normal,"Arial",8)
LoadFont(#Font_Bold,"Arial",10,#PB_Font_Bold)

If OpenWindow(#Window,100,100,250,75,"GTA San Andreas ToolBox Setup",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible)
 ComboBoxGadget(#Language,10,10,WindowWidth(#Window)-20,20)
  AddGadgetItem(#Language,-1,"English")
  AddGadgetItem(#Language,-1,"Deutsch")
 ButtonGadget(#OK,WindowWidth(#Window)/2-50,40,100,25,"OK")
 SetGadgetState(#Language,1)
 AddKeyboardShortcut(#Window,#PB_Shortcut_Return,#OK)
 HideWindow(#Window,0)
 Repeat
  Select WaitWindowEvent()
   Case #PB_Event_Menu,#PB_Event_Gadget
    If EventGadget()<>#Language
     Select GetGadgetState(#Language)
      Case 0; English
       Restore Language_English
       Language=#LANG_ENGLISH
       Width=520
      Case 1; German
       Restore Language_German
       Language=#LANG_GERMAN
       Width=610
     EndSelect
     For Lang=0 To #MaxLang
      Read.s Language(Lang)
     Next
     Close=1
    EndIf
   Case #PB_Event_CloseWindow
    End
  EndSelect
 Until Close
 CloseWindow(#Window)
EndIf

InstallPath$=GetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\SelfCoders","GTA San Andreas ToolBox")
 If InstallPath$=""
  InstallPath$=GetPath(38)+"SelfCoders\GTA San Andreas ToolBox\"
 EndIf
InstallPath$=ReplaceString(InstallPath$,"/","\",1)
If Right(InstallPath$,1)="\"
 InstallPath$=Left(InstallPath$,Len(InstallPath$)-1)
EndIf

If OpenWindow(#Window,100,100,Width,130,"GTA San Andreas ToolBox Setup",#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible)
 TextGadget(#Text1,10,10,100,20,Language(0))
 StringGadget(#InstallDir,110,10,WindowWidth(#Window)-250,20,InstallPath$)
 ButtonGadget(#OpenInstallDir,WindowWidth(#Window)-130,10,120,20,Language(1))
 TextGadget(#Text2,10,40,100,20,"GTA San Andreas:")
 StringGadget(#GTAFile,110,40,WindowWidth(#Window)-250,20,GetRegGTASAFile())
 ButtonGadget(#OpenGTAFile,WindowWidth(#Window)-130,40,120,20,Language(1))
 HyperLinkGadget(#AdvancedOptions,10,70,WindowWidth(#Window)-20,15,Language(2)+" >>",$0000FF)
 ContainerGadget(#AdvancedContainer,0,90,WindowWidth(#Window),310,#PB_Container_Flat)
  CheckBoxGadget(#CreateStartmenufolder,10,10,GadgetWidth(#AdvancedContainer)-20,20,Language(3))
   TextGadget(#Text3,30,30,GadgetWidth(#AdvancedContainer)-30,20,Language(4))
  CheckBoxGadget(#CreateDesktopicon,10,60,GadgetWidth(#AdvancedContainer)-20,20,Language(5))
   TextGadget(#Text4,30,80,GadgetWidth(#AdvancedContainer)-30,20,Language(6))
  CheckBoxGadget(#InstallSplashMod,10,110,GadgetWidth(#AdvancedContainer)-20,20,Language(7))
   TextGadget(#Text5,30,130,GadgetWidth(#AdvancedContainer)-30,20,Language(8))
  CheckBoxGadget(#Autostart,10,160,GadgetWidth(#AdvancedContainer)-20,20,Language(20))
   TextGadget(#Text6,30,180,GadgetWidth(#AdvancedContainer)-30,20,Language(21))
  CheckBoxGadget(#RegSATBS,10,210,GadgetWidth(#AdvancedContainer)-20,20,Language(22))
   TextGadget(#Text7,30,230,GadgetWidth(#AdvancedContainer)-30,20,Language(23))
  CheckBoxGadget(#RunAfterInstall,10,260,GadgetWidth(#AdvancedContainer)-20,20,Language(17))
   TextGadget(#Text8,30,280,GadgetWidth(#AdvancedContainer)-30,20,Language(18))
  CloseGadgetList()
 ButtonGadget(#Install,WindowWidth(#Window)-110,WindowHeight(#Window)-40,100,30,Language(9))
 For Gadget=#Text1 To #Text6
  SetGadgetFont(Gadget,FontID(#Font_Normal))
 Next
 SetGadgetFont(#OpenInstallDir,FontID(#Font_Bold))
 SetGadgetFont(#OpenGTAFile,FontID(#Font_Bold))
 SetGadgetFont(#Install,FontID(#Font_Bold))
 SetGadgetState(#CreateStartmenufolder,1)
 SetGadgetState(#CreateDesktopicon,1)
 SetGadgetState(#RegSATBS,1)
 If FindString(LCase(Config\Parameter),"/showadvanced",0)
  SetGadgetData(#AdvancedOptions,1)
  SetGadgetText(#AdvancedOptions,"<< "+Language(2))
  ResizeWindow(#Window,#PB_Ignore,#PB_Ignore,#PB_Ignore,460)
  ResizeGadget(#Install,WindowWidth(#Window)-110,WindowHeight(#Window)-40,100,30)
  HideGadget(#AdvancedContainer,0)
 Else
  HideGadget(#AdvancedContainer,1)
 EndIf
 If GetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Microsoft\Windows\CurrentVersion\Run","GTA San Andreas ToolBox SpeedLauncher")
  SetGadgetState(#Autostart,1)
 EndIf
 If GetRegValue(#HKEY_CLASSES_ROOT,"."+Extension$+"\shell"+Name$,"")
  SetGadgetState(#RegSATBS,1)
 EndIf
 HideWindow(#Window,0)
 Repeat
  Select WaitWindowEvent()
   Case #PB_Event_Gadget
    Select EventGadget()
     Case #OpenInstallDir
      Path$=Trim(ReplaceString(GetGadgetText(#InstallDir),"/","\",1))
       If Right(Path$,1)<>"\"
        Path$+"\"
       EndIf
      Path$=PathRequester(Language(10),Path$)
       If Path$
        If Path$="\"
         MessageRequester(Language(11),Language(12),#MB_ICONERROR)
        Else
         If Right(Path$,1)="\"
          Path$=Left(Path$,Len(Path$)-1)
         EndIf
         SetGadgetText(#InstallDir,Path$)
        EndIf
       EndIf
     Case #OpenGTAFile
      File$=OpenFileRequester(Language(13),Trim(GetGadgetText(#GTAFile)),Language(14),0)
       If File$
        If IsFileEx(File$)
         SetGadgetText(#GTAFile,File$)
        Else
         MessageRequester(Language(11),ReplaceString(Language(15),"%1",GetFilePart(File$),1),#MB_ICONERROR)
        EndIf
       EndIf
     Case #AdvancedOptions
      If GetGadgetData(#AdvancedOptions)
       SetGadgetData(#AdvancedOptions,0)
       SetGadgetText(#AdvancedOptions,Language(2)+" >>")
       ResizeWindow(#Window,#PB_Ignore,#PB_Ignore,#PB_Ignore,130)
       ResizeGadget(#Install,WindowWidth(#Window)-110,WindowHeight(#Window)-40,100,30)
       HideGadget(#AdvancedContainer,1)
      Else
       SetGadgetData(#AdvancedOptions,1)
       SetGadgetText(#AdvancedOptions,"<< "+Language(2))
       ResizeWindow(#Window,#PB_Ignore,#PB_Ignore,#PB_Ignore,460)
       ResizeGadget(#Install,WindowWidth(#Window)-110,WindowHeight(#Window)-40,100,30)
       HideGadget(#AdvancedContainer,0)
      EndIf
     Case #InstallSplashMod
      If GetGadgetState(#InstallSplashMod)
       Files$="models\txd\LOADSCS.txd"
       If MessageRequester(GetGadgetText(#InstallSplashMod),Language(16)+Chr(13)+Chr(13)+Files$,#MB_OKCANCEL|#MB_ICONWARNING)=#PB_MessageRequester_Cancel
        SetGadgetState(#InstallSplashMod,0)
       EndIf
      EndIf
     Case #Install
      Path$=Trim(ReplaceString(GetGadgetText(#InstallDir),"/","\",1))
       If Right(Path$,1)<>"\"
        Path$+"\"
       EndIf
      GTAFile$=Trim(ReplaceString(GetGadgetText(#GTAFile),"/","\",1))
      Startmenu$=GetPath(23)+"SelfCoders\GTA San Andreas ToolBox\"
      SetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\SelfCoders","GTA San Andreas ToolBox",Path$)
      SaveData(Path$+"BugReporter.exe",?File_BugReporter,?File_CheatProcessor)
      SaveData(Path$+"CheatProcessor.exe",?File_CheatProcessor,?File_Extras)
      SaveData(Path$+"Extras.exe",?File_Extras,?File_GUI)
      SaveData(Path$+"GTA ToolBox.exe",?File_GUI,?File_MemoryClient)
      SaveData(Path$+"MemoryClient.exe",?File_MemoryClient,?File_MemoryServer)
      SaveData(Path$+"MemoryServer.exe",?File_MemoryServer,?File_Script)
      SaveData(Path$+"Script.exe",?File_Script,?File_SpeedLauncher)
      SaveData(Path$+"SpeedLauncher.exe",?File_SpeedLauncher,?File_UpdateGUI)
      SaveData(Path$+"UpdateGUI.exe",?File_UpdateGUI,?File_WebServer)
      SaveData(Path$+"WebServer.exe",?File_WebServer,?File_GTALauncher)
      SaveData(GetPathPart(GTAFile$)+"GTALauncher.exe",?File_GTALauncher,?File_ResourceLib)
      SaveData(Path$+"Resources.dll",?File_ResourceLib,?File_Vehicles)
      SaveData(Path$+"Vehicles.cfg",?File_Vehicles,?File_Weapons)
      SaveData(Path$+"Weapons.cfg",?File_Weapons,?File_Background)
      SaveData(Path$+"Background.jpg",?File_Background,?File_SplashMod_LoadSCS)
      SetRegGTASAFile(GTAFile$)
      CreateInternetShortcut(Path$+"SelfCoders-Home.url","http://www.selfcoders.com")
      CreateInternetShortcut(Path$+"SelfCoders-Forum.url","http://board.selfcoders.com")
      CreateInternetShortcut(Path$+"Downloadpage.url","http://www.selfcoders.com/?page=downloads&download=gta_sa_toolbox")
      If CreatePreferences(Path$+"Settings.ini")
       PreferenceGroup("Global")
        WritePreferenceLong("Language",Language)
       ClosePreferences()
      EndIf
      If GetGadgetState(#CreateStartmenufolder)
       CreateDirectoryEx(Startmenu$)
       CreateDirectoryEx(Startmenu$+"Network\")
       CreateDirectoryEx(Startmenu$+"Links\")
       CreateShortcut(Path$+"BugReporter.exe",StartMenu$+Language(25)+".lnk","",Language(25),"",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"CheatProcessor.exe",Startmenu$+"CheatProcessor.lnk","","GTA San Andreas ToolBox CheatProcessor","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"GTA ToolBox.exe",Startmenu$+"GUI.lnk","","GTA San Andreas ToolBox GUI","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"SpeedLauncher.exe",Startmenu$+"SpeedLauncher.lnk","","GTA San Andreas ToolBox SpeedLauncher","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(GetPathPart(GTAFile$)+"GTALauncher.exe",Startmenu$+"GTA San Andreas.lnk","","GTA San Andreas","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"MemoryClient.exe",Startmenu$+"Network\MemoryClient.lnk","","GTA San Andreas ToolBox MemoryClient","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"MemoryServer.exe",Startmenu$+"Network\MemoryServer.lnk","","GTA San Andreas ToolBox MemoryServer","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"WebServer.exe",Startmenu$+"Network\WebServer.lnk","","GTA San Andreas ToolBox WebServer","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"SelfCoders-Home.url",Startmenu$+"Links\SelfCoders-Home.lnk","","SelfCoders-Home","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"SelfCoders-Forum.url",Startmenu$+"Links\SelfCoders-Forum.lnk","","SelfCoders-Forum","",#SW_SHOWNORMAL,"",0)
       CreateShortcut(Path$+"Downloadpage.url",Startmenu$+"Links\Downloadpage.lnk","","GTA San Andreas ToolBox Downloadpage","",#SW_SHOWNORMAL,"",0)
      EndIf
      If GetGadgetState(#CreateDesktopicon)
       CreateDirectoryEx(GetPath(16))
       CreateShortcut(Path$+"GTA ToolBox.exe",GetPath(16)+"GTA San Andreas ToolBox.lnk","","GTA San Andreas ToolBox","",#SW_SHOWNORMAL,"",0)
      EndIf
      If GetGadgetState(#InstallSplashMod)
       SaveData(GetPathPart(GTAFile$)+"models\txd\LOADSCS.txd",?File_SplashMod_LoadSCS,?EOF)
      EndIf
      If GetGadgetState(#Autostart)
       SetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Microsoft\Windows\CurrentVersion\Run","GTA San Andreas ToolBox SpeedLauncher",Chr(34)+Path$+"SpeedLauncher.exe"+Chr(34))
      Else
       DeleteRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Microsoft\Windows\CurrentVersion\Run","GTA San Andreas ToolBox SpeedLauncher")
      EndIf
      If GetGadgetState(#RegSATBS)
       RegFile("satbs","Run",Language(19),Chr(34)+Path$+"Script.exe"+Chr(34)+" "+Chr(34)+"%1"+Chr(34))
      Else
       UnRegFile("satbs","Run")
      EndIf
      MessageRequester(GetWindowTitle(#Window),Language(24),#MB_ICONINFORMATION)
      If GetGadgetState(#RunAfterInstall)
       RunProgram(Path$+"GTA ToolBox.exe","",Path$+"GTA ToolBox.exe")
      EndIf
      Quit=1
    EndSelect
   Case #PB_Event_CloseWindow
    Quit=1
  EndSelect
 Until Quit
EndIf

DataSection
 Language_English:
  Data$ "Installationfolder:"; 0
  Data$ "Browse..."; 1
  Data$ "Advanced options"; 2
  Data$ "Create startmenufolder"; 3
  Data$ "Creates a folder in the startmenu to quickly launch the GTA San Andreas ToolBox."; 4
  Data$ "Create desktop icon"; 5
  Data$ "Creates an icon on your desktop to quickly launch the GTA San Andreas ToolBox."; 6
  Data$ "Install SplashMod"; 7
  Data$ "Installs custom splashscreens for the loadingscreen. It also replaces the nVidia and THX logos."; 8
  Data$ "Install"; 9
  Data$ "Select an installationdirectory for the GTA San Andreas ToolBox."; 10
  Data$ "Error"; 11
  Data$ "The selected directory isn´t a valid installationdirectory!"; 12
  Data$ "Select the GTA San Andreas executable"; 13
  Data$ "GTA San Andreas executable|gta_sa.exe|Application|*.exe|All files|*.*"; 14
  Data$ "The file '%1' wasn´t found!"; 15
  Data$ "If you enable this action, the following files in the selected GTA San Andreas folder would be replaced:"; 16
  Data$ "Launch the GTA San Andreas ToolBox after installation"; 17
  Data$ "Launch the GTA San Andreas ToolBox automatically after the installation is complete."; 18
  Data$ "Run script"; 19
  Data$ "Start SpeedLauncher with Windows"; 20
  Data$ "Starts the SpeedLauncher automatically on every system startup."; 21
  Data$ "Register satbs-filetype"; 22
  Data$ "Associate satbs-files with the GTA San Andreas ToolBox ScriptParser."; 23
  Data$ "Installation completed!"; 24
  Data$ "Report bug"; 25
 Language_German:
  Data$ "Installationsordner:"; 0
  Data$ "Durchsuchen..."; 1
  Data$ "Erweiterte Optionen"; 2
  Data$ "Startmenüordner erstellen"; 3
  Data$ "Erstellt einen Ordner im Startmenü, um die GTA San Andreas ToolBox schnell zu starten."; 4
  Data$ "Desktopsymbol erstellen"; 5
  Data$ "Erstellt ein Desktopsymbol, um die GTA San Andreas ToolBox schnell zu starten."; 6
  Data$ "SplashMod installieren"; 7
  Data$ "Installiert neue Splashscreens für die Ladebildschirme. Dadurch werden auch die nVidia und THX Logos ersetzt."; 8
  Data$ "Installieren"; 9
  Data$ "Wähle ein Installationsverzeichnis für die GTA San Andreas ToolBox aus."; 10
  Data$ "Fehler"; 11
  Data$ "Das ausgewählte Verzeichnis ist kein gültiges Installationsverzeichnis!"; 12
  Data$ "Wähle die GTA San Andreas Datei"; 13
  Data$ "GTA San Andreas|gta_sa.exe|Anwendung|*.exe|Alle Dateien|*.*"; 14
  Data$ "Die Datei' wurde nicht gefunden!"; 15
  Data$ "Wenn du diese Aktion aktivierst, werden die folgenden Dateien in dem ausgewählten GTA San Andreas Ordner ersetzt:"; 16
  Data$ "GTA San Andreas ToolBox nach der Installation starten"; 17
  Data$ "Die GTA San Andreas ToolBox starten, wenn die Installation abgeschlossen ist."; 18
  Data$ "Script ausführen"; 19
  Data$ "SpeedLauncher mit Windows starten"; 20
  Data$ "Startet den SpeedLauncher automatisch bei jedem Systemstart."; 21
  Data$ "SATBS-Dateiformat registrieren"; 22
  Data$ "SATBS-Dateien mit dem GTA San Andreas ToolBox ScriptParser verknüpfen."; 23
  Data$ "Installation abgeschlossen!"; 24
  Data$ "Bug berichten"; 25
 File_BugReporter:
  IncludeBinary "BugReporter.exe"
 File_CheatProcessor:
  IncludeBinary "CheatProcessor.exe"
 File_Extras:
  IncludeBinary "Extras.exe"
 File_GUI:
  IncludeBinary "GTA ToolBox.exe"
 File_MemoryClient:
  IncludeBinary "MemoryClient.exe"
 File_MemoryServer:
  IncludeBinary "MemoryServer.exe"
 File_Script:
  IncludeBinary "Script.exe"
 File_SpeedLauncher:
  IncludeBinary "SpeedLauncher.exe"
 File_UpdateGUI:
  IncludeBinary "UpdateGUI.exe"
 File_WebServer:
  IncludeBinary "WebServer.exe"
 File_GTALauncher:
  IncludeBinary "GTALauncher.exe"
 File_ResourceLib:
  IncludeBinary "Resources.dll"
 File_Vehicles:
  IncludeBinary "Default\Vehicles.cfg"
 File_Weapons:
  IncludeBinary "Default\Weapons.cfg"
 File_Background:
  IncludeBinary "Default\Background.jpg"
 File_SplashMod_LoadSCS:
  IncludeBinary "SplashMod\LOADSCS.txd"
 EOF:
EndDataSection