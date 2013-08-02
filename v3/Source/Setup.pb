Enumeration
	#RunOnlyOnceCheckWindow
	#Window
	#Text1
	#Text2
	#Text3
	#Text4
	#GTASAPath
	#InstallPath
	#WebServerPort
	#Language
	#SearchGTASAPath
	#SearchInstallPath
	#WebServerPortInfo
	#Url
	#Install
	#Progress
EndEnumeration

Global Language
Global Quit
Global InstallPath$

#Title="GTA San Andreas ToolBox Setup"
#ServiceName="GTASAToolBoxWebSrv"

IncludeFile "Includes/Common.pbi"

Procedure.s LanguageEx(String$)
	If GetGadgetState(#Language)=1
		Select String$
			Case "GTA San Andreas Path"
				ProcedureReturn "GTA San Andreas Verzeichnis"
			Case "Installation Path"
				ProcedureReturn "Installationsverzeichnis"
			Case "Language"
				ProcedureReturn "Sprache"
			Case "Browse..."
				ProcedureReturn "Durchsuchen..."
			Case "Install"
				ProcedureReturn "Installieren"
			Case "The GTA San Andreas ToolBox uses a web server to display the GTA San Andreas ToolBox user interface.<br>After you installed the GTA San Andreas ToolBox you can access the user interface in your web browser via http://localhost:<Web Server Port>."
				ProcedureReturn "Die GTA San Andreas ToolBox verwendet einen Webserver um die GTA San Andreas ToolBox Oberfläche anzuzeigen.<br>Nachdem du die GTA San Andreas ToolBox installiert hast, kannst du die Oberfläche in deinem Webbrowser via http://localhost:<Web Server Port> erreichen."
			Case "Search for gta_sa.exe"
				ProcedureReturn "Nach gta_sa.exe suchen"
			Case "GTA San Andreas was not found in the selected directory!"
				ProcedureReturn "GTA San Andreas wurde in dem ausgewählten Verzeichnis nicht gefunden!"
			Case "Choose the directory where you want to install the GTA San Andreas ToolBox."
				ProcedureReturn "Wähle das Verzeichnis aus, in welchem du die GTA San Andreas ToolBox installieren möchtest."
			Case "The selected directory is invalid!"
				ProcedureReturn "Das ausgewählte Verzeichnis ist ungültig!"
			Case "The installation is not complete!<br>Are you sure you want to cancel?"
				ProcedureReturn "Die Installation ist noch nicht abgeschlossen!<br>Bist du dir sicher, dass du die Installation abbrechen möchtest?"
			Case "The installer found an old GTA San Andreas ToolBox installation in the selected installation directory.<br>Do you want to convert the files like your cheat list or teleport list?"
				ProcedureReturn "Der Installer hat eine alte GTA San Andreas ToolBox Installation in dem ausgewählten Installationsverzeichnis gefunden.<br>Möchtest du Dateien wie deine Cheatliste oder Teleportliste konvertieren?"
			Case "The MemoryChanger list has been already converted!<br>Skip it?"
				ProcedureReturn "Die MemoryChanger-Liste wurde bereits konvertiert!<br>Soll diese übersprungen werden?"
			Case "The cheat list has been already converted!<br>Skip it?"
				ProcedureReturn "Die Cheatliste wurde bereits konvertiert!<br>Soll diese übersprungen werden?"
			Case "The teleport list has been already converted!<br>Skip it?"
				ProcedureReturn "Die Teleportliste wurde bereits konvertiert!<br>Soll diese übersprungen werden?"
			Case "The installer needs to download some files from the internet.<br>Make sure you are connected to the internet and click 'OK'."
				ProcedureReturn "Der Installer muss einige Dateien aus dem Internet herunterladen.<br>Stelle sicher, dass du mit dem Internet verbunden bist und klicke auf 'OK'."
			Case "The installation is complete!<br>Click 'OK' to see the GTA San Andreas ToolBox Webinterface."
				ProcedureReturn "Die Installation ist abgeschlossen!<br>Klicke auf 'OK' um das GTA San Andreas ToolBox Webinterface zu sehen."
			Case "Can not install the web server service!"
				ProcedureReturn "Konnte den Webserverdienst nicht installieren!"
			Case "Download failed!"
				ProcedureReturn "Download fehlgeschlagen!"
			Case "Can not write configuration!"
				ProcedureReturn "Konnte Konfiguration nicht schreiben!"
			Case "The web server service can not be stopped!"
				ProcedureReturn "Der Webserverdienst konnte nicht gestoppt werden!"
			Case "The highest number for a port is 65000!"
				ProcedureReturn "Die höchste Zahl für ein Port ist 65000!"
			Case "You have to fill all fields!"
				ProcedureReturn "Du musst alle Felder ausfüllen!"
		EndSelect
	Else
		ProcedureReturn String$
	EndIf
EndProcedure

Procedure DownloadFileEx(Url$,FileName$)
	If IsFileEx(FileName$)
		ProcedureReturn #True
	Else
		ProcedureReturn ReceiveHTTPFile(Url$,FileName$)
	EndIf
EndProcedure

Procedure MessageRequesterEx(Text$,Flags)
	ProcedureReturn MessageRequester(#Title,ReplaceString(LanguageEx(Text$),"<br>",Chr(13),#PB_String_NoCase),Flags)
EndProcedure

Procedure ConvertFiles(Path$)
	If IsFileEx(Path$+"Config\MemoryChanger.dat")
		Select MessageRequesterEx("The MemoryChanger list has been already converted!<br>Skip it?",#MB_YESNO|#MB_ICONWARNING)
			Case #PB_MessageRequester_Yes
				ConvertMemoryChanger=#False
			Case #PB_MessageRequester_No
				ConvertMemoryChanger=#True
		EndSelect
	Else
		ConvertMemoryChanger=#True
	EndIf
	If ConvertMemoryChanger
		File=ReadFile(#PB_Any,Path$+"MemoryChanger.dat")
		If IsFile(File)
			File2=CreateFile(#PB_Any,Path$+"Config\MemoryChanger.dat")
			If IsFile(File2)
				Repeat
					Name$=Trim(ReadString(File))
					Address=ReadLong(File)
					DataType=ReadByte(File)
					WriteStringN(File2,Name$+Chr(9)+Str(Address)+Chr(9)+Str(DataType))
				Until Eof(File)
				CloseFile(File2)
			EndIf
			CloseFile(File)
		EndIf
	EndIf
	If IsFileEx(Path$+"Config\Cheats.dat")
		Select MessageRequesterEx("The cheat list has been already converted!<br>Skip it?",#MB_YESNO|#MB_ICONWARNING)
			Case #PB_MessageRequester_Yes
				ConvertCheats=#False
			Case #PB_MessageRequester_No
				ConvertCheats=#True
		EndSelect
	Else
		ConvertCheats=#True
	EndIf
	If ConvertCheats
		File=ReadFile(#PB_Any,Path$+"Cheats.clf")
		If IsFile(File)
			File2=CreateFile(#PB_Any,Path$+"Config\Cheats.dat")
			If IsFile(File2)
				Repeat
					Line$=Trim(ReadString(File))
					If Line$
						Select LCase(Line$)
							Case "; cheatlist"
								IsCheatlist=#True
							Case "; teleportlist"
								IsCheatlist=#False
							Default
								If Left(Line$,1)<>";" And IsCheatlist
									Cheat$=StringField(Line$,1,"|")
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
									WriteStringN(File2,Cheat$+Chr(9)+StringField(Line$,2,"|")+Chr(9)+StringField(Line$,3,"|"))
								EndIf
						EndSelect
					EndIf
				Until Eof(File)
				CloseFile(File2)
			EndIf
			CloseFile(File)
		EndIf
	EndIf
	If IsFileEx(Path$+"Config\Teleporter.dat")
		Select MessageRequesterEx("The teleport list has been already converted!<br>Skip it?",#MB_YESNO|#MB_ICONWARNING)
			Case #PB_MessageRequester_Yes
				ConvertTeleporter=#False
			Case #PB_MessageRequester_No
				ConvertTeleporter=#True
		EndSelect
	Else
		ConvertTeleporter=#True
	EndIf
	If ConvertTeleporter
		File=ReadFile(#PB_Any,Path$+"Teleporter.clf")
		If IsFile(File)
			File2=CreateFile(#PB_Any,Path$+"Config\Teleporter.dat")
			If IsFile(File2)
				ID=0
				Repeat
					Line$=Trim(ReadString(File))
					If Line$
						Select LCase(Line$)
							Case "; cheatlist"
								IsTeleportlist=#False
							Case "; teleportlist"
								IsTeleportlist=#True
							Default
								If Left(Line$,1)<>";" And IsTeleportlist
									Pos$=StringField(Line$,1,"|")
									PosX$=StringField(Pos$,1,";")
									PosY$=StringField(Pos$,2,";")
									PosZ$=StringField(Pos$,3,";")
									ID+1
									WriteStringN(File2,Str(ID)+Chr(9)+StringField(Line$,2,"|")+Chr(9)+PosX$+Chr(9)+PosY$+Chr(9)+PosZ$+Chr(9)+StringField(Line$,3,"|"))
								EndIf
						EndSelect
					EndIf
				Until Eof(File)
				CloseFile(File2)
			EndIf
			CloseFile(File)
		EndIf
	EndIf
EndProcedure

Procedure SetLanguageEx()
	SetGadgetText(#Text1,LanguageEx("GTA San Andreas Path")+":")
	SetGadgetText(#Text2,LanguageEx("Installation Path")+":")
	SetGadgetText(#Text4,LanguageEx("Language")+":")
	SetGadgetText(#SearchGTASAPath,LanguageEx("Browse..."))
	SetGadgetText(#SearchInstallPath,LanguageEx("Browse..."))
	SetGadgetText(#Install,LanguageEx("Install"))
EndProcedure

Procedure Install(Null)
	For Gadget=#Text1 To #Install
		DisableGadget(Gadget,#True)
	Next
	InstallPath$=FormatPath(GetGadgetText(#InstallPath),#True)
	Port=Val(GetGadgetText(#WebServerPort))
	If InstallPath$ And Port>0
		If Port<65000
			CreateDirectoryEx(InstallPath$)
			CreateDirectory(InstallPath$+"Logs")
			IsUpgrade=#False
			File=ReadFile(#PB_Any,InstallPath$+"Cheats.clf")
			If IsFile(File)
				Repeat
					WindowEvent()
					String$=Trim(ReadString(File))
					If LCase(String$)="; cheatlist"
						IsUpgrade=#True
					EndIf
				Until Eof(File)
				CloseFile(File)
			EndIf
			DoInstall=#True
			If IsUpgrade
				Select MessageRequesterEx("The installer found an old GTA San Andreas ToolBox installation in the selected installation directory.<br>Do you want to convert the files like your cheat list or teleport list?",#MB_YESNOCANCEL|#MB_ICONQUESTION)
					Case #PB_MessageRequester_Yes
						Convert=#True
					Case #PB_MessageRequester_No
					Default
						DoInstall=#False
				EndSelect
			EndIf
			If DoInstall
				ServiceStopOK=#True
				SCManager=OpenSCManager_(0,0,#SC_MANAGER_ALL_ACCESS)
				If SCManager
					Service=OpenService_(SCManager,#ServiceName,#SERVICE_ALL_ACCESS)
					If Service
						Status.SERVICE_STATUS
						ControlService_(Service,#SERVICE_CONTROL_STOP,Status)
						Timeout=0
						Repeat
							WindowEvent()
							QueryServiceStatus_(Service,Status)
							Timeout+100
							Delay(100)
						Until Status\dwCurrentState=#SERVICE_STOPPED Or Timeout>5000
						If Status\dwCurrentState=#SERVICE_STOPPED
							DeleteService_(Service)
						Else
							ServiceStopOK=#False
						EndIf
						CloseServiceHandle_(Service)
					EndIf
					CloseServiceHandle_(SCManager)
				EndIf
				If ServiceStopOK
					CreateDirectory(InstallPath$+"Config")
					File=CreateFile(#PB_Any,InstallPath$+"Config\Apache.cfg")
					If IsFile(File)
						WriteStringN(File,"LoadModule authz_host_module Modules/mod_authz_host.so")
						WriteStringN(File,"LoadModule dir_module Modules/mod_dir.so")
						WriteStringN(File,"LoadModule mime_module Modules/mod_mime.so")
						WriteStringN(File,"LoadModule rewrite_module Modules/mod_rewrite.so")
						WriteStringN(File,"LoadModule php5_module Modules/php5apache2_2.dll")
						WriteStringN(File,"Listen "+Str(Port))
						WriteStringN(File,"ServerName localhost:"+Str(Port))
						WriteStringN(File,"PHPIniDir "+Chr(34)+"Config"+Chr(34))
						WriteStringN(File,"DocumentRoot "+Chr(34)+"Web/httproot"+Chr(34))
						WriteStringN(File,"AddType Application/x-httpd-php .php")
						WriteStringN(File,"<IfModule mod_dir.c>")
						WriteStringN(File,"    DirectoryIndex index.php")
						WriteStringN(File,"</IfModule>")
						WriteStringN(File,"<Directory "+Chr(34)+"Web/httproot/tools/"+Chr(34)+">")
						WriteStringN(File,"    RewriteEngine On")
						WriteStringN(File,"    RewriteRule (.*)/index.php /index.php?tool=$1&script=$2 [QSA,L]")
						WriteStringN(File,"</Directory>")
						CloseFile(File)
						If GetGadgetState(#Language)=1
							Language$="de"
						Else
							Language$="en"
						EndIf
						OpenPreferences(InstallPath$+"Config\Settings.ini")
							PreferenceGroup("General")
								WritePreferenceString("Language",Language$)
							PreferenceGroup("Paths")
								WritePreferenceString("GTASAUserFiles",GetPath(5)+"GTA San Andreas User Files")
						ClosePreferences()
						OpenPreferences(InstallPath$+"Config\Paths.info")
							For PathID=1 To 1000
								WritePreferenceString(Str(PathID),GetPath(PathID))
							Next
						ClosePreferences()
						If CreatePreferences(InstallPath$+"Config\WebUsers.ini")
							PreferenceComment("This file is used to prevent network users to access your GTA San Andreas ToolBox.")
							PreferenceComment("Add one user for each line in format "+Chr(34)+"Username = MD5 Password"+Chr(34)+".")
							PreferenceComment("Example:")
							PreferenceComment("My Username = "+MD5Fingerprint(@InstallPath$,Len(InstallPath$)))
							ClosePreferences()
							If Convert
								ConvertFiles(InstallPath$)
							EndIf
							ConfigOK=#True
						EndIf
					EndIf
					If ConfigOK
						MessageRequesterEx("The installer needs to download some files from the internet.<br>Make sure you are connected to the internet and click 'OK'.",#MB_ICONQUESTION)
						CreateDirectory(InstallPath$+"Languages")
						SaveData(InstallPath$+"Languages/de.lang",?Language_de,?Updater)
						SaveData(InstallPath$+"Updater.exe",?Updater,?EOF)
						SetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\SelfCoders","GTA San Andreas ToolBox",FormatPath(InstallPath$,#False))
						App=RunProgram(InstallPath$+"Updater.exe","/setup",InstallPath$,#PB_Program_Open)
						If IsProgram(App)
							DisableWindow(#Window,#True)
							Repeat
								WaitWindowEvent(10)
							Until Not ProgramRunning(App)
							DisableWindow(#Window,#False)
							If ProgramExitCode(App)
								SCManager=OpenSCManager_(0,0,#SC_MANAGER_CREATE_SERVICE)
								If SCManager
									Service=CreateService_(SCManager,#ServiceName,"GTA San Andreas ToolBox WebServer",#SERVICE_ALL_ACCESS,#SERVICE_WIN32_OWN_PROCESS,#SERVICE_AUTO_START,#SERVICE_ERROR_NORMAL,Chr(34)+InstallPath$+"WebServer.exe"+Chr(34)+" -k runservice",0,0,0,0,0)
									If Service
										Description.SERVICE_DESCRIPTION
										Description\lpDescription=@"Webserver for the GTA San Andreas ToolBox Webinterface"
										ChangeServiceConfig2_(Service,#SERVICE_CONFIG_DESCRIPTION,Description)
										StartService_(Service,#Null,#Null)
										CloseServiceHandle_(Service)
										ServiceOK=#True
									EndIf
									CloseServiceHandle_(SCManager)
								EndIf
								If ServiceOK
									CreateInternetShortcut(InstallPath$+"BugReport.url","http://bugreport.selfcoders.com/?product=gta_sa_toolbox&version=3.0")
									CreateInternetShortcut(InstallPath$+"SelfCoders-Home.url","http://www.selfcoders.com")
									StartmenuPath$=GetPath(23)+"SelfCoders\GTA San Andreas ToolBox\"
									CreateDirectoryEx(StartmenuPath$)
									If CreateShortcut(InstallPath$+"CheatProcessor.exe",StartmenuPath$+"CheatProcessor.lnk","","GTA San Andreas ToolBox CheatProcessor",InstallPath$,#SW_NORMAL,InstallPath$+"CheatProcessor.exe",0)
										If CreateShortcut(InstallPath$+"WebInterface.exe",StartmenuPath$+"Webinterface.lnk","","GTA San Andreas ToolBox Webinterface",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"WebInterface.exe",0)
											If CreateShortcut(InstallPath$+"Uninstall.exe",StartmenuPath$+"Uninstall.lnk","","GTA San Andreas ToolBox Uninstaller",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"Uninstall.exe",0)
												If CreateShortcut(InstallPath$+"BugReport.url",StartmenuPath$+"BugReport.lnk","","Report a bug",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"Web.ico",0)
													If CreateShortcut(InstallPath$+"WebInterface.exe",StartmenuPath$+"Help.lnk","?page=help","GTA San Andreas ToolBox Help",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"Help.ico",0)
														If CreateShortcut(InstallPath$+"SelfCoders-Home.url",StartmenuPath$+"SelfCoders-Home.lnk","","Visit SelfCoders-Home",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"Web.ico",0)
															If CreateShortcut(InstallPath$+"Source",StartmenuPath$+"Source Code.lnk","","GTA San Andreas ToolBox Source Code",InstallPath$,#SW_SHOWNORMAL,InstallPath$+"Source.ico",0)
																ShortcutsOK=#True
															EndIf
														EndIf
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
									If ShortcutsOK
										SetRegGTASAFile(GetRegGTASAFile())
										MessageRequesterEx("The installation is complete!<br>Click 'OK' to see the GTA San Andreas ToolBox Webinterface.",#MB_ICONINFORMATION)
										RunProgram(GetGadgetText(#Url))
										Quit=#True
									EndIf
								Else
									MessageRequesterEx("Can not install the web server service!",#MB_ICONERROR)
								EndIf
							Else
								MessageRequesterEx("Download failed!",#MB_ICONERROR)
							EndIf
						Else
							MessageRequesterEx("Can not execute the updater!",#MB_ICONERROR)
						EndIf
					Else
						MessageRequesterEx("Can not write configuration!",#MB_ICONERROR)
					EndIf
				Else
					MessageRequesterEx("The web server service can not be stopped!",#MB_ICONERROR)
				EndIf
			EndIf
		Else
			MessageRequesterEx("The highest number for a port is 65000!",#MB_ICONERROR)
		EndIf
	Else
		MessageRequesterEx("You have to fill all fields!",#MB_ICONERROR)
	EndIf
	For Gadget=#Text1 To #Install
		DisableGadget(Gadget,#False)
	Next
EndProcedure

InitNetwork()

If OpenWindow(#Window,100,100,550,130,#Title,#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
	TextGadget(#Text1,10,15,150,20,"")
	TextGadget(#Text2,10,45,150,20,"")
	TextGadget(#Text3,10,75,150,20,"Web Server Port:")
	TextGadget(#Text4,10,105,150,20,"")
	StringGadget(#GTASAPath,160,10,270,20,FormatPath(GetPathPart(Trim(RemoveString(GetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Rockstar Games\GTA San Andreas\Installation","ExePath"),Chr(34),1))),#False))
	StringGadget(#InstallPath,160,40,270,20,FormatPath(Trim(GetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\SelfCoders","GTA San Andreas ToolBox",GetPath(38)+"SelfCoders\GTA San Andreas ToolBox")),#False))
	StringGadget(#WebServerPort,160,70,50,20,"8080",#PB_String_Numeric)
	ComboBoxGadget(#Language,160,100,80,20)
	AddGadgetItem(#Language,0,"English")
	AddGadgetItem(#Language,1,"Deutsch")
	ButtonGadget(#SearchGTASAPath,440,10,100,20,"")
	ButtonGadget(#SearchInstallPath,440,40,100,20,"")
	ButtonGadget(#WebServerPortInfo,220,70,20,20,"?")
	HyperLinkGadget(#Url,250,70,110,20,"http://127.0.0.1:8080",$FF0000,#PB_HyperLink_Underline)
	ButtonGadget(#Install,440,90,100,30,"")
	SetGadgetState(#Language,0)
	SetLanguageEx()
	EnableGadgetDrop(#GTASAPath,#PB_Drop_Files,#PB_Drag_Link)
	EnableGadgetDrop(#InstallPath,#PB_Drop_Files,#PB_Drag_Link)
	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #SearchGTASAPath
						File$=OpenFileRequester(LanguageEx("Search for gta_sa.exe"),FormatPath(GetGadgetText(#GTASAPath),#True)+"gta_sa.exe","GTA San Andreas|gta_sa.exe",0)
						If File$
							Path$=GetPathPart(File$)
							If IsFileEx(Path$+"gta_sa.exe")
								SetGadgetText(#GTASAPath,FormatPath(Path$,#False))
							Else
								MessageRequesterEx("GTA San Andreas was not found in the selected directory!",#MB_ICONERROR)
							EndIf
						EndIf
					Case #SearchInstallPath
						Path$=PathRequester(LanguageEx("Choose the directory where you want to install the GTA San Andreas ToolBox."),FormatPath(GetGadgetText(#InstallPath),#True))
						If Path$
							If Path$<>"\" And Path$<>"/"
								SetGadgetText(#InstallPath,FormatPath(Path$,#False))
							Else
								MessageRequesterEx("The selected directory is invalid!",#MB_ICONERROR)
							EndIf
						EndIf
					Case #WebServerPort
						Port=Val(GetGadgetText(#WebServerPort))
						If Port=80
							Port$=""
						Else
							Port$=":"+Str(Port)
						EndIf
						SetGadgetText(#Url,"http://127.0.0.1"+Port$)
					Case #Language
						SetLanguageEx()
					Case #WebServerPortInfo
						MessageRequesterEx("The GTA San Andreas ToolBox uses a web server to display the GTA San Andreas ToolBox user interface.<br>After you installed the GTA San Andreas ToolBox you can access the user interface in your web browser via http://localhost:<Web Server Port>.",#MB_ICONINFORMATION)
					Case #Url
						RunProgram(GetGadgetText(#Url))
					Case #Install
						ThreadID=CreateThread(@Install(),#Null)
				EndSelect
			Case #PB_Event_GadgetDrop
				Select EventGadget()
					Case #GTASAPath
						File$=StringField(EventDropFiles(),1,Chr(10))
						If IsFileEx(File$)
							Path$=GetPathPart(File$)
						Else
							Path$=FormatPath(File$,#True)
						EndIf
						If IsFileEx(Path$+"gta_sa.exe")
							SetGadgetText(#GTASAPath,FormatPath(Path$,#False))
						Else
							MessageRequesterEx("GTA San Andreas was not found in the selected directory!",#MB_ICONERROR)
						EndIf
					Case #InstallPath
						File$=StringField(EventDropFiles(),1,Chr(10))
						If IsFileEx(File$)
							Path$=GetPathPart(File$)
						Else
							Path$=FormatPath(File$,#True)
						EndIf
						If Path$<>"\" And Path$<>"/"
							SetGadgetText(#InstallPath,FormatPath(Path$,#False))
						Else
							MessageRequesterEx("The selected directory is invalid!",#MB_ICONERROR)
						EndIf
				EndSelect
			Case #PB_Event_CloseWindow
				If IsThread(ThreadID)
					If MessageRequesterEx("The installation is not complete!<br>Are you sure you want to cancel?",#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
						Quit=#True
					EndIf
				Else
					Quit=#True
				EndIf
		EndSelect
	Until Quit
	If IsThread(ThreadID)
		KillThread(ThreadID)
	EndIf
EndIf

DataSection
	Language_de:
		IncludeBinary "../Languages/de.lang"
	Updater:
		IncludeBinary "../Updater.exe"
	EOF:
EndDataSection
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 343
; FirstLine = 333
; Folding = --
; EnableXP