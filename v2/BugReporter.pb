Enumeration
 #RunOnlyOnceCheckWindow
 #Window
 #Font
 #Text1
 #Text2
 #Text3
 #Name
 #Email
 #Module
 #Frame1
 #HelpText
 #Frame2
 #Description
 #AttachBugFile
 #SendCopy
 #Send
EndEnumeration

Structure ModuleFile
 File.s
EndStructure

#MaxLang=18

IncludeFile "Common.pbi"

Global Dim Language.s(#MaxLang)

Procedure OnMouseOver(WindowID)
 GetCursorPos_(Point.Point)
 MapWindowPoints_(0,WindowID,Point,1)
 ProcedureReturn ChildWindowFromPoint_(WindowID,PeekQ(Point))
EndProcedure

Procedure AddModule(Name$,File$)
 *ModuleFile.ModuleFile=AllocateMemory(SizeOf(ModuleFile))
 *ModuleFile\File=File$
 AddGadgetItem(#Module,-1,Name$)
 SetGadgetItemData(#Module,CountGadgetItems(#Module)-1,*ModuleFile)
EndProcedure

Procedure ToolTip()
 Select OnMouseOver(WindowID(#Window))
  Case GadgetID(#Name)
   Text$=Language(11)
  Case GadgetID(#Email)
   Text$=Language(12)
  Case GadgetID(#Module)
   Text$=Language(13)
  Case GadgetID(#Frame2),GadgetID(#Description)
   Text$=Language(14)
  Case GadgetID(#AttachBugFile)
   Text$=Language(15)
  Case GadgetID(#SendCopy)
   Text$=Language(16)
  Case GadgetID(#Send)
   Text$=Language(17)
  Default
   Text$=""
 EndSelect
 If GetGadgetText(#HelpText)<>Text$
  SetGadgetText(#HelpText,Text$)
 EndIf
EndProcedure

InitNetwork()

OpenPreferences(Common\PrefsFile)
 PreferenceGroup("Global")
  Language=ReadPreferenceLong("Language",#LANG_ENGLISH)
ClosePreferences()

LoadFont(#Font,"Arial",8)

Select Language
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

If IsModuleRunning(#Module_BugReporter)
 MessageRequester(Language(7),Language(18),#MB_ICONERROR)
 End
EndIf
OpenWindow(#RunOnlyOnceCheckWindow,0,0,0,0,#RunOnlyOnceTitle_BugReporter,#PB_Window_Invisible)

Image=CreateImage(#PB_Any,1000,100)
 If IsImage(Image)
  If StartDrawing(ImageOutput(Image))
   DrawingFont(FontID(#Font))
   TextWidth1=TextWidth(Language(1))
   TextWidth2=TextWidth(Language(2))
   Debug TextWidth1
   Debug TextWidth2
   StopDrawing()
  EndIf
  FreeImage(Image)
 EndIf
If TextWidth1<1 Or TextWidth2<1
 TextWidth1=120
 TextWidth2=120
EndIf

OpenPreferences(Common\InstallPath+"BugReporter.ini")
 Name$=ReadPreferenceString("Name","")
 Email$=ReadPreferenceString("Email","")
 AttachBugFile=ReadPreferenceLong("AttachBugFile",0)
 SendCopy=ReadPreferenceLong("SendCopy",0)
ClosePreferences()

If OpenWindow(#Window,100,100,600,350,"Bug Reporter",#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible)
 TextGadget(#Text1,10,10,50,20,"Name:")
 TextGadget(#Text2,10,40,50,20,"Email:")
 TextGadget(#Text3,10,70,50,20,"Module:")
 StringGadget(#Name,70,10,200,20,Name$)
 StringGadget(#Email,70,40,200,20,Email$)
 ComboBoxGadget(#Module,70,70,200,20)
  AddModule("CheatProcessor","CheatProcessor.exe")
  AddModule("GTA Launcher","GTALauncher.exe")
  AddModule("GUI","GTA ToolBox.exe")
  AddModule("MemoryClient","MemoryClient.exe")
  AddModule("MemoryServer","MemoryServer.exe")
  AddModule("ScriptParser","Script.exe")
  AddModule("SpeedLauncher","SpeedLauncher.exe")
  AddModule("GUI Updater","UpdateGUI.exe")
  AddModule("WebServer","WebServer.exe")
 Frame3DGadget(#Frame1,280,10,310,80,"",#PB_Frame3D_Flat)
  TextGadget(#HelpText,290,20,GadgetWidth(#Frame1)-20,GadgetHeight(#Frame1)-20,"")
 Frame3DGadget(#Frame2,10,100,WindowWidth(#Window)-20,200,Language(0))
  EditorGadget(#Description,20,120,GadgetWidth(#Frame2)-20,GadgetHeight(#Frame2)-30)
 CheckBoxGadget(#AttachBugFile,10,GadgetHeight(#Frame2)+110,TextWidth1+20,20,Language(1))
 CheckBoxGadget(#SendCopy,TextWidth1+40,GadgetY(#AttachBugFile),TextWidth2+20,20,Language(2)):DisableGadget(#SendCopy,1)
 ButtonGadget(#Send,WindowWidth(#Window)-110,GadgetY(#AttachBugFile),100,30,Language(3))
 For Gadget=#Text1 To #Send
  SetGadgetFont(Gadget,FontID(#Font))
 Next
 SetGadgetState(#AttachBugFile,AttachBugFile)
 ;SetGadgetState(#SendCopy,SendCopy)
 WindowBounds(#Window,550,300,GetSystemMetrics_(#SM_CXSCREEN),GetSystemMetrics_(#SM_CYSCREEN))
 Select LCase(Trim(ProgramParameter(0)))
  Case "/select"
   For Item=0 To CountGadgetItems(#Module)-1
    If LCase(Trim(GetGadgetItemText(#Module,Item)))=LCase(Trim(ProgramParameter(1)))
     SetGadgetState(#Module,Item)
    EndIf
   Next
 EndSelect
 HideWindow(#Window,0)
 Repeat
  Select WaitWindowEvent()
   Case #PB_Event_Gadget
    Select EventGadget()
     Case #Send
      Name$=Trim(GetGadgetText(#Name))
      Email$=Trim(LCase(GetGadgetText(#Email)))
      Module$=Trim(GetGadgetText(#Module))
      Description$=Trim(GetGadgetText(#Description))
       If Name$ And Email$ And Module$ And Description$
        Mail=CreateMail(#PB_Any,Email$,"Bug Report: GTA San Andreas ToolBox ("+Module$+")")
         If IsMail(Mail)
          Body$=ReplaceString(Language(4),"%1",Name$,1)+Chr(13)+Chr(10)
          Body$+Chr(13)+Chr(10)
          Body$+Language(0)+":"+Chr(13)+Chr(10)
          Body$+Description$
          SetMailBody(Mail,Body$)
          If GetGadgetState(#AttachBugFile)
           *ModuleFile.ModuleFile=GetGadgetItemData(#Module,GetGadgetState(#Module))
           AttachFile$=*ModuleFile\File
           AddMailAttachment(Mail,AttachFile$,Common\InstallPath+AttachFile$)
          EndIf
          AddMailRecipient(Mail,"admin@selfcoders.com",#PB_Mail_To)
          If GetGadgetState(#SendCopy)
           AddMailRecipient(Mail,Email$,#PB_Mail_Cc)
          EndIf
          If SendMail(Mail,"selfcoders.com",25,1)
           SetGadgetText(#Send,Language(5))
           For Gadget=#Text1 To #Send
            DisableGadget(Gadget,1)
           Next
           Repeat
            Progress=MailProgress(Mail)
            WaitWindowEvent(100)
           Until Progress=#PB_Mail_Finished Or Progress=#PB_Mail_Error
           Select Progress
            Case #PB_Mail_Finished
             MessageRequester("Bug Reporter",Language(6),#MB_ICONINFORMATION)
             Quit=1
            Case #PB_Mail_Error
             MessageRequester(Language(7),Language(8),#MB_ICONERROR)
           EndSelect
           For Gadget=#Text1 To #Send
            DisableGadget(Gadget,0)
           Next
           SetGadgetText(#Send,Language(3))
          Else
           MessageRequester(Language(7),Language(9),#MB_ICONERROR)
          EndIf
          FreeMail(Mail)
         EndIf
       Else
        MessageRequester(Language(7),Language(10),#MB_ICONERROR)
       EndIf
    EndSelect
   Case #PB_Event_SizeWindow
    ResizeGadget(#Name,#PB_Ignore,#PB_Ignore,WindowWidth(#Window)-GadgetWidth(#Frame1)-90,#PB_Ignore)
    ResizeGadget(#Email,#PB_Ignore,#PB_Ignore,GadgetWidth(#Name),#PB_Ignore)
    ResizeGadget(#Module,#PB_Ignore,#PB_Ignore,GadgetWidth(#Name),#PB_Ignore)
    ResizeGadget(#Frame1,GadgetWidth(#Name)+80,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    ResizeGadget(#HelpText,GadgetX(#Frame1)+10,#PB_Ignore,GadgetWidth(#Frame1)-20,GadgetHeight(#Frame1)-20)
    ResizeGadget(#Frame2,#PB_Ignore,#PB_Ignore,WindowWidth(#Window)-20,WindowHeight(#Window)-150)
    ResizeGadget(#Description,#PB_Ignore,#PB_Ignore,GadgetWidth(#Frame2)-20,GadgetHeight(#Frame2)-30)
    ResizeGadget(#AttachBugFile,#PB_Ignore,WindowHeight(#Window)-30,#PB_Ignore,#PB_Ignore)
    ResizeGadget(#SendCopy,#PB_Ignore,GadgetY(#AttachBugFile),#PB_Ignore,#PB_Ignore)
    ResizeGadget(#Send,WindowWidth(#Window)-110,WindowHeight(#Window)-40,#PB_Ignore,#PB_Ignore)
   Case #PB_Event_CloseWindow
    Quit=1
  EndSelect
  ToolTip()
 Until Quit
EndIf

If CreatePreferences(Common\InstallPath+"BugReporter.ini")
 WritePreferenceString("Name",Trim(GetGadgetText(#Name)))
 WritePreferenceString("Email",Trim(GetGadgetText(#Email)))
 WritePreferenceLong("AttachBugFile",GetGadgetState(#AttachBugFile))
 WritePreferenceLong("SendCopy",GetGadgetState(#SendCopy))
 ClosePreferences()
EndIf

DataSection
 Language_English:
  Data$ "Description"; 0
  Data$ "Attach program"; 1
  Data$ "Send copy to me"; 2
  Data$ "Send"; 3
  Data$ "Bug reported by %1."; 4
  Data$ "Sending..."; 5
  Data$ "Report sent successful!"; 6
  Data$ "Error"; 7
  Data$ "Can´t sent report!"; 8
  Data$ "Can´t sent report via SelfCoders-Mail!"; 9
  Data$ "All fields must be filled in!"; 10
  Data$ "Your name"; 11
  Data$ "Your email-address"; 12
  Data$ "Select the module of the GTA San Andreas ToolBox which has the bug"; 13
  Data$ "Write a report about the bug"; 14
  Data$ "Attach the selected module of the GTA San Andreas ToolBox to the report"; 15
  Data$ "Send a copy of the report mail to your email-address (Not available yet)"; 16
  Data$ "Send the bug report"; 17
  Data$ "Bug Reporter is allready running!"; 18
 Language_German:
  Data$ "Beschreibung"; 0
  Data$ "Programm anhängen"; 1
  Data$ "Kopie an mich senden"; 2
  Data$ "Senden"; 3
  Data$ "Bug berichtet von %1."; 4
  Data$ "Senden..."; 5
  Data$ "Bericht erfolgreich gesendet!"; 6
  Data$ "Fehler"; 7
  Data$ "Konnte Bericht nicht senden!"; 8
  Data$ "Konnte Bericht nicht über SelfCoders-Mail senden!"; 9
  Data$ "Alle Felder müssen ausgefüllt werden!"; 10
  Data$ "Dein Name"; 11
  Data$ "Deine Email-Adresse"; 12
  Data$ "Wähle das Modul der GTA San Andreas ToolBox aus, welches den Bug hat"; 13
  Data$ "Schreibe einen Bericht über den Bug"; 14
  Data$ "Das ausgewählte Modul der GTA San Andreas ToolBox an den Bericht anhängen"; 15
  Data$ "Eine Kopie des Berichtes an deine Email-Adresse senden (Noch nicht verfügbar)"; 16
  Data$ "Bug Bericht senden"; 17
  Data$ "Bug Reporter wurde bereits gestartet!"; 18
EndDataSection