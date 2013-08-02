Structure Config
 GTAUserFiles.s
 WebCfg.s
 Language.l
 Port.l
 AdminPassword.s
 UserPassword.s
 HigherProcessPriority.b
 CheatProcessorID.l
 Client.l
 Access.l
 Buffer.l
 Quit.l
EndStructure

Structure User
 IP.l
 Type.l
 Language.l
 Cheatlist_SortType.l
 Cheatlist_Offset.l
 Pictures_CurrentImage.l
 Vehicles_SortType.l
 Vehicles_Offset.l
 Weapons_SortType.l
 Weapons_Offset.l
EndStructure

Structure Cheats
 Cheat.s
 Description.s
EndStructure

Structure Vehicles
 ID.l
 Name.s
 Type.s
EndStructure

Structure Weapons
 Num.l
 Name.s
 ID.l
 Slot.l
 AmmoClip.l
 TotalAmmo.l
EndStructure

#MaxLang=15
#LiveViewImage=100

Global Config.Config
Global Dim Language.s(#MaxLang)
Global NewList User.User()
Global NewList Cheats.Cheats()
Global NewList Vehicles.Vehicles()
Global NewList Weapons.Weapons()
Global NewList GalleryPicture.s()

IncludeFile "Common.pbi"

Procedure.l BuildRequestHeader(*Buffer,DataLength,ContentType$)
 Length=PokeS(*Buffer,"HTTP/1.1 200 OK"+Chr(13)+Chr(10))
 *Buffer+Length
 Length=PokeS(*Buffer,"Date: Wed, 07 Aug 1996 11:15:43 GMT"+Chr(13)+Chr(10))
 *Buffer+Length
 Length=PokeS(*Buffer,"Server: GTA San Andreas ToolBox WebServer"+Chr(13)+Chr(10))
 *Buffer+Length
;  Length=PokeS(*Buffer,"Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0"+Chr(13)+Chr(10))
;  *Buffer+Length
;  Length=PokeS(*Buffer,"Pragma: no-cache"+Chr(13)+Chr(10))
;  *Buffer+Length
 Length=PokeS(*Buffer,"Content-Length: "+Str(DataLength)+Chr(13)+Chr(10))
 *Buffer+Length
 Length=PokeS(*Buffer,"Content-Type: "+ContentType$+Chr(13)+Chr(10))
 *Buffer+Length
 Length=PokeS(*Buffer,Chr(13)+Chr(10))
 *Buffer+Length
 ProcedureReturn *Buffer
EndProcedure

Procedure SendWebData(Code$,ContentType$)
 *Buffer=AllocateMemory(Len(Code$)+200)
 *FileBuffer=*Buffer
 *BufferOffset=BuildRequestHeader(*FileBuffer,Len(Code$),ContentType$)
 PokeS(*BufferOffset,Code$,Len(Code$))
 SendNetworkData(Config\Client,*FileBuffer,*BufferOffset-*FileBuffer+Len(Code$))
 FreeMemory(*Buffer)
EndProcedure

Procedure WindowCallback(WindowID,Message,wParam,lParam)
 Select Message
  Case Common\ExplorerMsg
   AddSysTrayIconEx(0,WindowID(0),ExtractIcon_(0,ProgramFilename(),0))
  Case #WM_QUERYENDSESSION
   Config\Quit=1
  Case #WM_NOTIFYICON
   Select lParam
    Case #WM_LBUTTONDBLCLK
     If MessageRequester(Language(2),Language(3),#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
      Config\Quit=1
     EndIf
   EndSelect
 EndSelect
 ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure TrayStatus(Status$)
SysTrayIconToolTipEx(0,WindowID(0),"GTA San Andreas ToolBox - WebServer"+Chr(13)+"Port: "+Str(Config\Port)+Chr(13)+"Status: "+Status$+Chr(13)+ReplaceString(Language(15),"%1",Str(ListSize(User())),1))
EndProcedure

Procedure.s GetRequestedFile(Buffer$)
 MaxPosition=FindString(Buffer$,Chr(13),5)
 Space1=FindString(Buffer$," ",0)
 Space2=FindString(Buffer$," ",Space1+1)
 RequestedFile$=Trim(Mid(Buffer$,Space1+1,Space2-Space1))
 Structure Temp
  a.b
 EndStructure
 *t.Temp=@RequestedFile$
  While *t\a<>0
   If *t\a='/'
    *t\a='\'
   EndIf
   *t+1
  Wend
 If Left(RequestedFile$,1)="\"
  RequestedFile$=Right(RequestedFile$,Len(RequestedFile$)-1)
 EndIf
 If RequestedFile$=""
  RequestedFile$="Home"
 EndIf
 ProcedureReturn RequestedFile$
EndProcedure

Procedure.s GetLocalFile(RequestedFile$)
 If OpenPreferences(Config\WebCfg)
  File$=RequestedFile$
  If ExaminePreferenceKeys()
   While NextPreferenceKey()
    HTTPFile$=PreferenceKeyName()
    LocalFile$=PreferenceKeyValue()
    If LCase(File$)=LCase(HTTPFile$) And Find=0
     Find=1
     File$=ReplaceString(File$,HTTPFile$,LocalFile$,1)
    EndIf
   Wend
  EndIf
  ClosePreferences()
 EndIf
 If ListIndex(User())<>-1
  Language=User()\Language
 Else
  Language=Config\Language
 EndIf
 Select Language
  Case #LANG_ENGLISH
   Lang$="English"
  Case #LANG_GERMAN
   Lang$="German"
 EndSelect
 File$=ReplaceString(File$,"[Language]",Lang$,1)
 ProcedureReturn File$
EndProcedure

Procedure IsCheatProcessorID(WindowID,Null)
 Title$=Space(#MAX_PATH)
 GetWindowText_(WindowID,@Title$,#MAX_PATH)
 If LCase(Left(Title$,Len(#CheatTransferWindow)))=LCase(#CheatTransferWindow)
  Config\CheatProcessorID=WindowID
  ProcedureReturn 0
 Else
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure SendCheat(Cheat$)
 If Config\CheatProcessorID
  Title$=Space(#MAX_PATH)
  GetWindowText_(Config\CheatProcessorID,@Title$,#MAX_PATH)
  If LCase(Left(Title$,Len(#CheatTransferWindow)))=LCase(#CheatTransferWindow)
   SysTrayIconBalloonEx(0,WindowID(1),Language(13),UCase(Cheat$),10000)
   SetWindowText_(Config\CheatProcessorID,#CheatTransferWindow+UCase(Cheat$))
  EndIf
 EndIf
EndProcedure

Procedure LoadCheatlist()
 ClearList(Cheats())
 File=ReadFile(#PB_Any,Common\InstallPath+"Cheats.clf")
  If IsFile(File)
   Repeat
    String$=Trim(ReadString(File))
     Select LCase(String$)
      Case "; cheatlist"
       Mode=1
      Case "; teleportlist"
       Mode=2
      Default
       If String$ And Left(String$,1)<>";" And Mode=1
        AddElement(Cheats())
        Cheats()\Cheat=UCase(Trim(StringField(String$,1,"|")))
        Cheats()\Description=Trim(StringField(String$,2,"|"))
       EndIf
     EndSelect
   Until Eof(File)
   CloseFile(File)
  EndIf
EndProcedure

Procedure LoadVehicles()
 ClearList(Vehicles())
 OpenPreferences(Common\InstallPath+"Vehicles.ini")
  For Vehicle=400 To 611
   AddElement(Vehicles())
   Vehicles()\ID=Vehicle
   Vehicles()\Name=ReadPreferenceString(Str(Vehicle),"N/A")
  Next
 ClosePreferences()
EndProcedure

Procedure LoadWeapons()
 ClearList(Weapons())
 File=ReadFile(#PB_Any,Common\InstallPath+"Weapons.cfg")
  If IsFile(File)
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>";" And Trim(StringField(String$,2,"|"))
      AddElement(Weapons())
      Weapons()\Num=Val(Trim(StringField(String$,1,"|")))
      Weapons()\Name=Trim(StringField(String$,2,"|"))
      Weapons()\ID=Val(Trim(StringField(String$,3,"|")))
      Weapons()\Slot=Val(Trim(StringField(String$,4,"|")))
      Weapons()\AmmoClip=Val(Trim(StringField(String$,5,"|")))
      Weapons()\TotalAmmo=Val(Trim(StringField(String$,6,"|")))
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
EndProcedure

Procedure.s OSVersionText()
 Win$="Windows "
 Select OSVersion()
  Case #PB_OS_Windows_NT3_51
   Win$+"NT 3"
  Case #PB_OS_Windows_95
   Win$+"95"
  Case #PB_OS_Windows_NT_4
   Win$+"NT 4"
  Case #PB_OS_Windows_98
   Win$+"98"
  Case #PB_OS_Windows_ME
   Win$+"ME"
  Case #PB_OS_Windows_2000
   Win$+"2000"
  Case #PB_OS_Windows_XP
   Win$+"XP"
  Case #PB_OS_Windows_Server_2003
   Win$+"Server 2003"
  Case #PB_OS_Windows_Vista
   Win$+"Vista"
  Case #PB_OS_Windows_Server_2008
   Win$+"Server 2008"
  Default
   Win$=""
 EndSelect
 ProcedureReturn Win$
EndProcedure

Procedure.s GetHtmlFile(File$)
 File=ReadFile(#PB_Any,GetLocalFile(File$))
  If IsFile(File)
   Repeat
    Code$+ReadString(File)+Chr(13)
   Until Eof(File)
   CloseFile(File)
  EndIf
 ProcedureReturn Code$
EndProcedure

Procedure.s GET(URL$,Name$)
 Get$=Trim(StringField(URL$,2,"?"))
  If Get$
   For Index=0 To CountString(Get$,"&")
    Par$=Trim(StringField(Get$,Index+1,"&"))
     If Par$
      If LCase(StringField(Par$,1,"="))=LCase(Name$)
       Value$=StringField(Par$,2,"=")
       Break
      EndIf
     EndIf
   Next
  EndIf
 ProcedureReturn Trim(Value$)
EndProcedure

Procedure RefreshGalleryPictures()
 ClearList(GalleryPicture())
 Dir=ExamineDirectory(#PB_Any,Config\GTAUserFiles+"Gallery\","*.*")
  If IsDirectory(Dir)
   While NextDirectoryEntry(Dir)
    If DirectoryEntryType(Dir)=#PB_DirectoryEntry_File
     Name$=DirectoryEntryName(Dir)
      If Name$<>"." And Name$<>".."
       Select LCase(GetExtensionPart(Name$))
        Case "bmp","jpg","jpeg","png","tga","tif","tiff"
         If IsFileEx(Config\GTAUserFiles+"Gallery\"+Name$)
          AddElement(GalleryPicture())
          GalleryPicture()=Name$
         EndIf
       EndSelect
      EndIf
    EndIf
   Wend
   FinishDirectory(Dir)
  EndIf
EndProcedure

Procedure SendWebFile(Url$)
 RequestedFile$=StringField(Url$,1,"?")
 File$=GetLocalFile(RequestedFile$)
 File=ReadFile(#PB_Any,Common\InstallPath+File$)
  If IsFile(File)
   Select LCase(GetExtensionPart(Common\InstallPath+File$))
    Case "gif"
     ContentType$="image/gif"
    Case "jpg","jpeg"
     ContentType$="image/jpeg"
    Case "png"
     ContentType$="image/png"
    Case "txt"
     ContentType$="text/plain"
    Default
     ContentType$="text/html"
   EndSelect
   If LCase(Trim(ReadString(File)))="#chtml"
    Repeat
     Code$+ReadString(File)+Chr(13)+Chr(10)
    Until Eof(File)
    If LCase(GET(Url$,"SortType"))="asc"
     SortType$="desc"
    Else
     SortType$="asc"
    EndIf
    Code$=ReplaceString(Code$,"%NextSortType%",SortType$,1)
    Code$=ReplaceString(Code$,"%Hostname%",Hostname(),1)
    Select LCase(GetFilePart(RequestedFile$))
     Case "cheats"
      ListStart=FindString(LCase(Code$),"<cheatlist>",0)
      ListEnd=FindString(LCase(Code$),"</cheatlist>",0)
       If ListStart And ListEnd
        LoadCheatlist()
        If ListIndex(User())<>-1
         If User()\Cheatlist_SortType
          SortStructuredList(Cheats(),User()\Cheatlist_SortType,User()\Cheatlist_Offset,#PB_Sort_String)
         EndIf
         User()\Cheatlist_SortType=0
        EndIf
        Replace$=Mid(Code$,ListStart+Len("<cheatlist>"),ListEnd-(ListStart+Len("<cheatlist>")))
        ReplaceOld$=Replace$
        Color1=$C0C0C0
        Color2=$FFFFFF
        ForEach Cheats()
         If RowColor=Color1
          RowColor=Color2
         Else
          RowColor=Color1
         EndIf
         Replace$=ReplaceString(Replace$,"%Color%","#"+Hex(RowColor),1)
         Replace$=ReplaceString(Replace$,"%Cheat%",Cheats()\Cheat,1)
         Replace$=ReplaceString(Replace$,"%Description%",Cheats()\Description,1)
         Add$+Replace$
         Replace$=ReplaceOld$
        Next
        Code$=ReplaceString(Code$,ReplaceOld$,Add$)
       EndIf
     Case "info"
      Select Config\Language
       Case #LANG_GERMAN
        Lang$="Deutsch"
       Case #LANG_ENGLISH
        Lang$="English"
      EndSelect
      Code$=ReplaceString(Code$,"%Version%",StrF(#Version,2),1)
      Code$=ReplaceString(Code$,"%Build%",Str(#Build),1)
      Code$=ReplaceString(Code$,"%Language%",Lang$,1)
      Code$=ReplaceString(Code$,"%OS%",OSVersionText(),1)
      Code$=ReplaceString(Code$,"%Cheats_Count%",Str(ListSize(Cheats())),1)
     Case "pictures"
      If ListIndex(User())<>-1
       Image=Val(GET(Url$,"ID"))
        If Image<=0
         Image=1
        EndIf
        If Image>1
         PreviousImage=Val(GET(Url$,"ID"))-1
        Else
         PreviousImage=1
        EndIf
        If Image<ListSize(GalleryPicture())
         NextImage=Val(GET(Url$,"ID"))+1
        Else
         NextImage=ListSize(GalleryPicture())
        EndIf
       Code$=ReplaceString(Code$,"%PreviousImage%",Str(PreviousImage),1)
       Code$=ReplaceString(Code$,"%NextImage%",Str(NextImage),1)
       Code$=ReplaceString(Code$,"%CurrentImage%",Str(Image),1)
      EndIf
      If GET(Url$,"Gallery")=""
       RefreshGalleryPictures()
      EndIf
     Case "vehicles"
      ListStart=FindString(LCase(Code$),"<vehiclelist>",0)
      ListEnd=FindString(LCase(Code$),"</vehiclelist>",0)
       If ListStart And ListEnd
        LoadVehicles()
        If ListIndex(User())<>-1
         If User()\Vehicles_SortType
          Select User()\Vehicles_Offset
           Case OffsetOf(Vehicles\Name),OffsetOf(Vehicles\Type)
            Type=#PB_Sort_String
           Default
            Type=#PB_Sort_Long
          EndSelect
          SortStructuredList(Vehicles(),User()\Vehicles_SortType,User()\Vehicles_Offset,Type)
         EndIf
         User()\Vehicles_SortType=0
        EndIf
        Replace$=Mid(Code$,ListStart+Len("<vehiclelist>"),ListEnd-(ListStart+Len("<vehiclelist>")))
        ReplaceOld$=Replace$
        Color1=$C0C0C0
        Color2=$FFFFFF
        RowColor=-1
        ForEach Vehicles()
         If RowColor=Color1
          RowColor=Color2
         Else
          RowColor=Color1
         EndIf
         Replace$=ReplaceString(Replace$,"%Color%","#"+Hex(RowColor),1)
         Replace$=ReplaceString(Replace$,"%ID%",Str(Vehicles()\ID),1)
         Replace$=ReplaceString(Replace$,"%Name%",Vehicles()\Name,1)
         Replace$=ReplaceString(Replace$,"%Type%",Vehicles()\Type,1)
         Add$+Replace$
         Replace$=ReplaceOld$
        Next
        Code$=ReplaceString(Code$,ReplaceOld$,Add$)
       EndIf
     Case "weapons"
      ListStart=FindString(LCase(Code$),"<weaponlist>",0)
      ListEnd=FindString(LCase(Code$),"</weaponlist>",0)
       If ListStart And ListEnd
        LoadWeapons()
        If ListIndex(User())<>-1
         If User()\Weapons_SortType
          Select User()\Weapons_Offset
           Case OffsetOf(Weapons\Name)
            Type=#PB_Sort_String
           Default
            Type=#PB_Sort_Long
          EndSelect
          SortStructuredList(Weapons(),User()\Weapons_SortType,User()\Weapons_Offset,Type)
         EndIf
         User()\Weapons_SortType=0
        EndIf
        Replace$=Mid(Code$,ListStart+Len("<weaponlist>"),ListEnd-(ListStart+Len("<weaponlist>")))
        ReplaceOld$=Replace$
        Color1=$C0C0C0
        Color2=$FFFFFF
        RowColor=-1
        Add$=""
        ForEach Weapons()
         If RowColor=Color1
          RowColor=Color2
         Else
          RowColor=Color1
         EndIf
         Replace$=ReplaceString(Replace$,"%Color%","#"+Hex(RowColor),1)
         Replace$=ReplaceString(Replace$,"%Num%",Str(Weapons()\Num),1)
         Replace$=ReplaceString(Replace$,"%ID%",Str(Weapons()\ID),1)
         Replace$=ReplaceString(Replace$,"%Name%",Weapons()\Name,1)
         Replace$=ReplaceString(Replace$,"%AmmoClip%",Str(Weapons()\AmmoClip),1)
         Replace$=ReplaceString(Replace$,"%TotalAmmo%",Str(Weapons()\TotalAmmo),1)
         Replace$=ReplaceString(Replace$,"%Slot%",Str(Weapons()\Slot),1)
         Add$+Replace$
         Replace$=ReplaceOld$
        Next
        Code$=ReplaceString(Code$,ReplaceOld$,Add$)
       EndIf
    EndSelect
    SendWebData(Code$,"text/html")
   Else
    FileSeek(File,0)
    *Buffer=AllocateMemory(Lof(File)+200)
    *FileBuffer=*Buffer
    *BufferOffset=BuildRequestHeader(*FileBuffer,Lof(File),ContentType$)
    ReadData(File,*BufferOffset,Lof(File))
    SendNetworkData(Config\Client,*FileBuffer,*BufferOffset-*FileBuffer+Lof(File))
    FreeMemory(*Buffer)
   EndIf
   CloseFile(File)
   ProcedureReturn 1
  EndIf
EndProcedure

Procedure.s ErrorPage(RequestedFile$,HTTPError)
 Select HTTPError
  Case 401
   Select Config\Language
    Case #LANG_ENGLISH
     Title$="Error: Unauthorized"
     Text$="You have no permission to access this page!"
    Case #LANG_GERMAN
     Title$="Fehler: Nicht Autentifiziert"
     Text$="Du hast nicht die Erlaubnis auf diese Seite zuzugreifen!"
   EndSelect
  Case 404
   Select Config\Language
    Case #LANG_ENGLISH
     Title$="Error: Page not found!"
     Text$="The requested page was not found or is not shared!"
    Case #LANG_GERMAN
     Title$="Fehler: Seite nicht gefunden!"
     Text$="Die aufgerufene Seite wurde nicht gefunden oder wurde nicht freigegeben!"
   EndSelect
 EndSelect
 Code$="<html><head><title>"+Title$+" ("+Str(HTTPError)+")</title></head>"
 Code$+"<body><h1 align=center>"+Title$+"</h1><br>"+Text$+"<br>"
 Select Config\Language
  Case #LANG_ENGLISH
   Code$+"Requested file: <b>"+RequestedFile$+"</b><br><br><a href=javascript:history.back();>Back to previous page</a><br><br><br>"
   Code$+"This page was created by <a href=http://www.selfcoders.de/?page=downloads&download=gta_sa_toolbox>GTA San Andreas ToolBox</a> - WebServer.<br>"
   Code$+"Servertime: "+FormatDate("%dd/%mm/%yyyy - %hh:%ii:%ss",Date())+"</body></html>"
  Case #LANG_GERMAN
   Code$+"Aufgerufene Datei: <b>"+RequestedFile$+"</b><br><br><a href=javascript:history.back();>Zurück zur vorherigen Seite</a><br><br><br>"
   Code$+"Diese Seite wurde vom <a href=http://www.selfcoders.de/?page=downloads&download=gta_sa_toolbox>GTA San Andreas ToolBox</a> - WebServer erstellt.<br>"
   Code$+"Serverzeit: "+FormatDate("%dd/%mm/%yyyy - %hh:%ii:%ss",Date())+"</body></html>"
 EndSelect
 SendWebData(Code$,"text/html")
EndProcedure

Procedure.s GetURLFile(URL$)
 ProcedureReturn Trim(StringField(URL$,1,"?"))
EndProcedure

Procedure DoGET(URL$)
 Do=1
 SortType=2
 Select LCase(GetURLFile(URL$))
  Case "cheats"
   Cheat$=GET(URL$,"Cheat")
    If Cheat$
     EnumWindows_(@IsCheatProcessorID(),0)
     If Config\CheatProcessorID
      If UpdateGTASAProcess()
       Text$=Language(5)+Chr(13)+Chr(10)+"Cheat: "+UCase(Cheat$)
       SendCheat(Cheat$)
      Else
       Text$=Language(7)
      EndIf
     Else
      Text$=Language(6)
     EndIf
     SendWebData(Text$,"text/html")
     Do=0
    Else
     If ListIndex(User())<>-1
      Select LCase(GET(URL$,"SortType"))
       Case "asc"
        User()\Cheatlist_SortType=2
       Case "desc"
        User()\Cheatlist_SortType=3
      EndSelect
      Select LCase(GET(URL$,"Sort"))
       Case "cheat"
        User()\Cheatlist_Offset=OffsetOf(Cheats\Cheat)
       Case "description"
        User()\Cheatlist_Offset=OffsetOf(Cheats\Description)
      EndSelect
     EndIf
    EndIf
  Case "home"
   If ListIndex(User())<>-1
    Select LCase(GET(URL$,"Lang"))
     Case "de"
      User()\Language=#LANG_GERMAN
     Case "en"
      User()\Language=#LANG_ENGLISH
    EndSelect
   EndIf
  Case "login"
   If ListIndex(User())<>-1
    Select LCase(GET(URL$,"Lang"))
     Case "de"
      User()\Language=#LANG_GERMAN
     Case "en"
      User()\Language=#LANG_ENGLISH
    EndSelect
   EndIf
  Case "pictures"
   ID=Val(GET(URL$,"Gallery"))
    If ID>0 And ID<=ListSize(GalleryPicture())
     SelectElement(GalleryPicture(),ID-1)
     File=ReadFile(#PB_Any,Config\GTAUserFiles+"Gallery\"+GalleryPicture())
      If IsFile(File)
       *Buffer=AllocateMemory(Lof(File)+200)
       *FileBuffer=*Buffer
       *BufferOffset=BuildRequestHeader(*FileBuffer,Lof(File),ContentType$)
       ReadData(File,*BufferOffset,Lof(File))
       SendNetworkData(Config\Client,*FileBuffer,*BufferOffset-*FileBuffer+Lof(File))
       FreeMemory(*Buffer)
       CloseFile(File)
       Do=0
      EndIf
    EndIf
  Case "vehicles"
   ID$=GET(URL$,"ID")
    If ID$
     EnumWindows_(@IsCheatProcessorID(),0)
     ID=Val(ID$)
     If Config\CheatProcessorID
      If UpdateGTASAProcess()
       If ID=>400 And ID<=611
        Text$=ReplaceString(ReplaceString(Language(9),"\n",Chr(13)+Chr(10),1),"%1",Str(ID),1)
        SendCheat("SPAWNVEHICLE"+Str(ID))
       Else
        Text$=ReplaceString(Language(10),"%1",Str(ID),1)
       EndIf
      Else
       Text$=Language(7)
      EndIf
     Else
      Text$=Language(6)
     EndIf
     SendWebData(Text$,"html/text")
     Do=0
    Else
     If ListIndex(User())<>-1
      Select LCase(GET(URL$,"SortType"))
       Case "asc"
        User()\Vehicles_SortType=2
       Case "desc"
        User()\Vehicles_SortType=3
      EndSelect
      Select LCase(GET(URL$,"Sort"))
       Case "id"
        User()\Vehicles_Offset=OffsetOf(Vehicles\ID)
       Case "name"
        User()\Vehicles_Offset=OffsetOf(Vehicles\Name)
       Case "type"
        User()\Vehicles_Offset=OffsetOf(Vehicles\Type)
      EndSelect
     EndIf
    EndIf
  Case "weapons"
   ID$=GET(URL$,"ID")
    If ID$
     EnumWindows_(@IsCheatProcessorID(),0)
     ID=Val(ID$)
     If Config\CheatProcessorID
      If UpdateGTASAProcess()
       If ID=>0 And ID<=46
        Text$=ReplaceString(ReplaceString(Language(11),"\n",Chr(13)+Chr(10),1),"%1",Str(ID),1)
        SendCheat("SPAWNWEAPON"+Str(ID))
       Else
        Text$=ReplaceString(Language(12),"%1",Str(ID),1)
       EndIf
      Else
       Text$=Language(7)
      EndIf
     Else
      Text$=Language(6)
     EndIf
     SendWebData(Text$,"html/text")
     Do=0
    Else
     If ListIndex(User())<>-1
      Select LCase(GET(URL$,"SortType"))
       Case "asc"
        User()\Weapons_SortType=2
       Case "desc"
        User()\Weapons_SortType=3
      EndSelect
      Select LCase(GET(URL$,"Sort"))
       Case "num"
        User()\Weapons_Offset=OffsetOf(Weapons\Num)
       Case "id"
        User()\Weapons_Offset=OffsetOf(Weapons\ID)
       Case "name"
        User()\Weapons_Offset=OffsetOf(Weapons\Name)
       Case "ammoclip"
        User()\Weapons_Offset=OffsetOf(Weapons\AmmoClip)
       Case "totalammo"
        User()\Weapons_Offset=OffsetOf(Weapons\TotalAmmo)
       Case "slot"
        User()\Weapons_Offset=OffsetOf(Weapons\Slot)
      EndSelect
     EndIf
    EndIf
 EndSelect
 ProcedureReturn Do
EndProcedure

Procedure LoadSettings()
 OpenPreferences(Common\InstallPath+"Settings.ini")
  PreferenceGroup("Global")
   Config\Language=ReadPreferenceLong("Language",#LANG_GERMAN)
  PreferenceGroup("HigherProcessPriority")
   Config\HigherProcessPriority=ReadPreferenceLong("WebServer",0)
  PreferenceGroup("Network")
   Config\Port=ReadPreferenceLong("WebPort",80)
   Config\AdminPassword=ReadPreferenceString("AdminPassword",MD5Fingerprint(@"admin",5))
   Config\UserPassword=ReadPreferenceString("UserPassword",MD5Fingerprint(@"user",4))
 ClosePreferences()
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
   If MessageRequester("GTA San Andreas ToolBox - WebServer",Info$,#MB_YESNO|#MB_ICONERROR)=#PB_MessageRequester_Yes
    RunProgram(Common\InstallPath+"GTA ToolBox.exe","",Common\InstallPath)
   EndIf
   End
 EndSelect
 For Lang=0 To #MaxLang
  Read.s Language(Lang)
 Next
 HigherProcessPriority(Config\HigherProcessPriority)
EndProcedure

;- Main
Config\GTAUserFiles=GetPath(5)+"GTA San Andreas User Files\"
Config\WebCfg=Common\InstallPath+"WebCfg.ini"
Config\Buffer=AllocateMemory(10000)

LoadSettings()

If IsModuleRunning(#Module_WebServer)
 MessageRequester(Language(0),Language(4),#MB_ICONERROR)
 End
EndIf
OpenWindow(1,0,0,0,0,#RunOnlyOnceTitle_WebServer,#PB_Window_Invisible)

InitNetwork()
LoadCheatlist()
LoadVehicles()
LoadWeapons()

UseJPEGImageEncoder()
UsePNGImageEncoder()

If IsFileEx(Config\WebCfg)=0
 SaveData(Config\WebCfg,?WebCfg,?EOF)
EndIf

If OpenWindow(0,0,0,0,0,"GTA San Andreas ToolBox - WebServer",#PB_Window_Invisible)
 If AddSysTrayIconEx(0,WindowID(0),ExtractIcon_(0,ProgramFilename(),0))
  TrayStatus("Initialising...")
 EndIf
 If CreatePopupMenu(0)
  MenuItem(0,Language(2))
 EndIf
 SetWindowCallback(@WindowCallback(),0)
EndIf

If CreateNetworkServer(1,Config\Port)
 TrayStatus(Language(14))
 Repeat
  UpdateGTASAProcess()
  WaitWindowEvent(10)
  Title$=GetWindowTitle(1)
  Title$=Trim(Right(Title$,Len(Title$)-Len(#RunOnlyOnceTitle_WebServer)))
   If Title$
    Select Title$
     Case #Module_CMD_ReloadAll
      LoadSettings()
      TrayStatus(Language(14))
     Case #Module_CMD_Quit
      Config\Quit=1
    EndSelect
    SetWindowTitle(1,#RunOnlyOnceTitle_WebServer)
   EndIf
  Select NetworkServerEvent()
   Case 0
   Case #PB_NetworkEvent_Connect,#PB_NetworkEvent_Disconnect
   Default
    Config\Client=EventClient()
    RequestLength=ReceiveNetworkData(Config\Client,Config\Buffer,2000)
    Config\Access=0
    User=-1
    ForEach User()
     If User()\IP=GetClientIP(Config\Client)
      Config\Access=User()\Type
      User=ListIndex(User())
     EndIf
    Next
    If User<>-1
     SelectElement(User(),User)
    EndIf
    Buffer$=PeekS(Config\Buffer)
    Url$=GetRequestedFile(Buffer$)
    RequestedFile$=GetURLFile(Url$)
    File$=GetLocalFile(RequestedFile$)
     If Left(UCase(Buffer$),3)="GET"
      If Config\Access
       Find=1
       If RequestedFile$ And DoGET(Url$)
        If FindString(LCase(File$),"[memory]",0)
         File$=LCase(Trim(RemoveString(File$,"[Memory]",1)))
          If Left(File$,1)="\" Or Left(File$,1)="/"
           File$=Right(File$,Len(File$)-1)
          EndIf
         Select LCase(Trim(RemoveString(File$,"[Memory]",1)))
          Case "liveview"
           Debug "Access..."
           ScreenDM.DEVMODE
           Width=GetSystemMetrics_(#SM_CXSCREEN)
           Height=GetSystemMetrics_(#SM_CYSCREEN)
           ScreenDC=CreateDC_("DISPLAY","","",ScreenDM)
           DC=CreateCompatibleDC_(ScreenDC)
           ImageID=CreateCompatibleBitmap_(ScreenDC,Width,Height)
            If ImageID
             SelectObject_(DC,ImageID)
             BitBlt_(DC,0,0,Width,Height,ScreenDC,0,0,#SRCCOPY)
             DeleteDC_(DC)
             ReleaseDC_(ImageID,ScreenDC)
             If CreateImage(#LiveViewImage,Width,Height,16)
              If StartDrawing(ImageOutput(#LiveViewImage))
                DrawImage(ImageID,0,0,Width,Height)
               StopDrawing()
              EndIf
              Debug "Save..."
              SaveImage(#LiveViewImage,Common\InstallPath+"LiveView.png",#PB_ImagePlugin_JPEG,2)
              FreeImage(#LiveViewImage)
             EndIf
            EndIf
           SendWebFile("LiveView.png")
           Debug "ready"
          Case "logout"
           ForEach User()
            If User()\IP=GetClientIP(Config\Client)
             DeleteElement(User())
            EndIf
           Next
           TrayStatus(Language(14))
           SendWebFile("Login")
          Case "position.info"
           PED=ReadProcessValue($B6F3B8,#PB_Long)
           Pool=ReadProcessValue(PED+20,#PB_Long)
           x.f=ReadProcessFloat(Pool+48)
           y.f=ReadProcessFloat(Pool+52)
           x+3000
           y=SwapMath(y)+3000
           SendWebData(Str(x-10)+" "+Str(y-10),"text/html")
          Case "shutdown"
           If Config\Access=#User_Admin
            Code$=GetHtmlFile("Shutdown")
            Code$=ReplaceString(Code$,"%Hostname%",Hostname(),1)
            SendWebData(Code$,"text/html")
            Config\Quit=1
           Else
            ErrorPage(RequestedFile$,401)
           EndIf
          Default
           Find=0
         EndSelect
        Else
         Find=SendWebFile(Url$)
        EndIf
        If Find=0
         ErrorPage(RequestedFile$,404)
        EndIf
       EndIf
      Else
       Password$=GET(Buffer$,"Password")
        If Password$
         MD5$=LCase(MD5Fingerprint(@Password$,Len(Password$)))
         If LCase(Config\UserPassword)=MD5$
          AddElement(User())
          User()\IP=GetClientIP(Config\Client)
          User()\Type=#User_Normal
          User()\Pictures_CurrentImage=1
          User()\Language=Config\Language
          SendWebFile(Url$)
         ElseIf LCase(Config\AdminPassword)=MD5$
          AddElement(User())
          User()\IP=GetClientIP(Config\Client)
          User()\Type=#User_Admin
          User()\Pictures_CurrentImage=1
          User()\Language=Config\Language
          TrayStatus(Language(14))
          SendWebFile(Url$)
         Else
          SendWebFile("LoginFailed")
         EndIf
         TrayStatus(Language(14))
        Else
         SendWebFile("Login")
        EndIf
      EndIf
     ElseIf Left(UCase(Buffer$),4)="POST"
      Debug "POST"
     EndIf
  EndSelect
 Until Config\Quit
 CloseNetworkServer(1)
Else
 MessageRequester(Language(0),ReplaceString(ReplaceString(Language(1),"%1",Str(Config\Port),1),"<br>",Chr(13),1),#MB_ICONERROR)
EndIf

RemoveSysTrayIconEx(0,WindowID(0))

DataSection
 Language_English:
  Data$ "Error"; 0
  Data$ "Couldn´t create the server on port %1!<br>Make sure there is no other serverapplication running with this port."; 1
  Data$ "Shutdown server"; 2
  Data$ "Are you sure to shutdown the server?"; 3
  Data$ "The GTA San Andreas ToolBox WebServer was allready started!"; 4
  Data$ "The cheat was send!"; 5
  Data$ "The CheatProcessor must be launched to send cheats!"; 6
  Data$ "GTA San Andreas is not running!"; 7
  Data$ "Unknown spawntype!"; 8
  Data$ "The vehicle was spawned!\nVehicle ID: %1"; 9
  Data$ "The vehicle ID '%1' is invalid!"; 10
  Data$ "The weapon was spawned!\nNummer: %1"; 11
  Data$ "The weapon ID '%1' is invalid!"; 12
  Data$ "Cheat sended"; 13
  Data$ "Ready"; 14
  Data$ "Connected users: %1"; 15
 Language_German:
  Data$ "Fehler"; 0
  Data$ "Der Server konnte auf Port %1 nicht erstellen werden!<br>Stelle sicher, dass keine andere Serveranwendung mit diesem Port läuft."; 1
  Data$ "Server beenden"; 2
  Data$ "Soll der Server wirklich beendet werden?"; 3
  Data$ "Der GTA San Andreas ToolBox WebServer wurde bereits gestartet!"; 4
  Data$ "Der Cheat wurde gesendet!"; 5
  Data$ "Der CheatProcessor muss gestartet sein, um Cheats zu senden!"; 6
  Data$ "GTA San Andreas ist nicht gestartet!"; 7
  Data$ "Unbekannter Spawnertyp!"; 8
  Data$ "Das Fahrzeug wurde gespawnt!\nFahrzeug ID: %1"; 9
  Data$ "Die Fahrzeugnummer '%1' ist ungültig!"; 10
  Data$ "Die Waffe wurde gespawnt!\nNummer: %1"; 11
  Data$ "Die Waffen ID '%1' ist ungültig!"; 12
  Data$ "Cheat gesendet"; 13
  Data$ "Bereit"; 14
  Data$ "Verbundene Benutzer: %1"; 15
 WebCfg:
  IncludeBinary "WebCfg.ini"
 EOF:
EndDataSection