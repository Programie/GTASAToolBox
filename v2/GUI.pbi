Procedure.s Language(ID)
 If ID=>0 And ID<=#MaxLang
  ProcedureReturn LanguageArray(ID)
 Else
  MessageRequester("Error","A language error occured!"+Chr(13)+Chr(13)+Str(ID)+" is not a valid language index!",#MB_ICONERROR)
  ProcedureReturn "LANGUAGEERROR"
 EndIf
EndProcedure

Procedure MenuItemEx(MenuItem,Text$,ImageID)
 MenuItem(MenuItem,Text$)
 If ImageID
  Image=CreateImage(#PB_Any,Config\IconSize,Config\IconSize)
   If IsImage(Image)
    If StartDrawing(ImageOutput(Image))
     Box(0,0,Config\IconSize,Config\IconSize,GetSysColor_(#COLOR_MENU))
     DrawImage(ImageID,0,0,Config\IconSize,Config\IconSize)
     StopDrawing()
    EndIf
   EndIf
  If IsImage(Image)
   SetMenuItemBitmaps_(MenuID(#Menu_Main),MenuItem,#MF_BYCOMMAND,ImageID(Image),ImageID(Image))
   AddElement(MenuImage())
   MenuImage()=Image
  EndIf
 EndIf
EndProcedure

Procedure AddMenuItem(MenuItem,LanguageItem,ShortcutText$,Shortcut,ImageID=0)
 MenuItemEx(MenuItem,Language(LanguageItem)+Chr(9)+ShortcutText$,ImageID)
 AddKeyboardShortcut(#Window_Main,Shortcut,MenuItem)
EndProcedure

Procedure RefreshWindowMenu()
 For Item=#Menu_Main_Cheats To #Menu_Main_Config
  Window=Item-#Menu_Main_Cheats+#Window_MDI_Cheats
  SetMenuItemState(#Menu_Main,Item,IsWindowVisible_(WindowID(Window)))
 Next
EndProcedure

Procedure CreateToolBarEx(ToolBar,WindowID)
 If CreateToolBar(ToolBar,WindowID)
  ID=ToolBarID(ToolBar)
  OldImageList=SendMessage_(ID,#TB_GETIMAGELIST,0,0)
  NewImageList=ImageList_Duplicate_(OldImageList)
  ImageList_Destroy_(OldImageList)
  ImageList_SetIconSize_(NewImageList,Config\IconSize,Config\IconSize)
  SendMessage_(ID, #TB_SETIMAGELIST,0,NewImageList)
  SendMessage_(ID,#TB_SETBITMAPSIZE,0,MakeLong(Config\IconSize,Config\IconSize))
  SendMessage_(ID,#TB_SETBUTTONSIZE,0,MakeLong(Config\IconSize,Config\IconSize))
  SendMessage_(ID,#TB_AUTOSIZE,0,0)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure ToolBarImageButtonEx(ButtonID,ImageID,Flags=0)
 Image=CreateImage(#PB_Any,Config\IconSize,Config\IconSize)
  If IsImage(Image)
   If StartDrawing(ImageOutput(Image))
    Box(0,0,Config\IconSize,Config\IconSize,GetSysColor_(#COLOR_MENU))
    DrawImage(ImageID,0,0,Config\IconSize,Config\IconSize)
    StopDrawing()
   EndIf
   ToolBarImageButton(ButtonID,ImageID(Image),Flags)
  EndIf
EndProcedure

Procedure ChangeVal(Value)
 If Value
  ProcedureReturn 0
 Else
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure CleoManagerListDisplay()
 For Item=#Menu_CleoManager_LargeIcon To #Menu_CleoManager_Detail
  SetMenuItemState(#Menu_CleoManager,Item,0)
 Next
 SetMenuItemState(#Menu_CleoManager,#Menu_CleoManager_LargeIcon+Config\CleoManager_ListDisplay,1)
 SetGadgetAttribute(#Gadget_CleoManager_List,#PB_ListIcon_DisplayMode,Config\CleoManager_ListDisplay)
EndProcedure

Procedure ReloadMenu()
 ForEach MenuImage()
  FreeImage(MenuImage())
 Next
 ClearList(MenuImage())
 If IsGadget(#Gadget_Tools_List)
  Tools=CountGadgetItems(#Gadget_Tools_List)
 EndIf
 If CreateMenu(#Menu_Main,WindowID(#Window_Main))
  MenuTitle(Language(7))
   If Config\CanUseNetwork
    If Config\SelfCodersAccount\LoggedIn
     MenuItemEx(#Menu_Main_Login,"Logout (Test)",ImageID(#Image_SelfCodersNetwork))
    Else
     MenuItemEx(#Menu_Main_Login,"Login (Test)",ImageID(#Image_SelfCodersNetwork))
    EndIf
   EndIf
    MenuBar()
   AddMenuItem(#Menu_Main_RunScript,143,Language(54)+"+Alt+S",#PB_Shortcut_Control|#PB_Shortcut_Alt|#PB_Shortcut_S,ExtractIcon_(0,Common\InstallPath+"Script.exe",0))
    MenuBar()
   AddMenuItem(#Menu_Main_Quit,8,"Alt+F4",#PB_Shortcut_Alt|#PB_Shortcut_F4,ImageID(#Image_Quit))
  MenuTitle(Language(9))
   MenuItemEx(#Menu_Main_Cheats,Language(0),ImageID(#Image_Cheats))
   MenuItemEx(#Menu_Main_Teleporter,"Teleporter",ImageID(#Image_Teleporter))
   MenuItemEx(#Menu_Main_SavegameManager,"SavegameManager",ImageID(#Image_SavegameManager))
   MenuItemEx(#Menu_Main_Models,Language(68),ImageID(#Image_Models))
   MenuItemEx(#Menu_Main_MemoryChanger,"MemoryChanger",ImageID(#Image_MemoryChanger))
   MenuItemEx(#Menu_Main_IMGEditor,"IMG Editor",ImageID(#Image_IMGEditor))
   MenuItemEx(#Menu_Main_CleoManager,"CleoManager",ImageID(#Image_CleoManager))
   MenuItemEx(#Menu_Main_IPLEditor,"IPL Editor",ImageID(#Image_IPLEditor))
   MenuItemEx(#Menu_Main_GameTweaks,"GameTweaks",ImageID(#Image_GameTweaks))
   MenuItemEx(#Menu_Main_Config,Language(24),ImageID(#Image_Config))
  MenuTitle(Language(10))
   MenuItemEx(#Menu_Main_Tools,Language(109),ImageID(#Image_Tools))
    MenuBar()
   MenuItemEx(#Menu_Main_RunCheatProcessor,"CheatProcessor",ExtractIcon_(0,Common\InstallPath+"CheatProcessor.exe",0))
   MenuItemEx(#Menu_Main_RunMemoryServer,"MemoryServer",ExtractIcon_(0,Common\InstallPath+"MemoryServer.exe",0))
   MenuItemEx(#Menu_Main_RunWebServer,"WebServer",ExtractIcon_(0,Common\InstallPath+"WebServer.exe",0))
   If Tools
    MenuBar()
    For Tool=0 To Tools-1
     Name$=GetGadgetItemText(#Gadget_Tools_List,Tool,0)
     File$=GetGadgetItemText(#Gadget_Tools_List,Tool,1)
     Select GetGadgetItemData(#Gadget_Tools_List,Tool)
      Case #Tools_DefaultItem
       MenuItemEx(#Menu_FirstExternTool+Tool,Name$,ExtractIcon_(0,File$,0))
      Case #Tools_Separator
       MenuBar()
      Case #Tools_OpenSubMenu
       OpenSubMenu(Name$)
      Case #Tools_CloseSubMenu
       CloseSubMenu()
     EndSelect
    Next
   EndIf
  MenuTitle(Language(77))
   AddMenuItem(#Menu_Main_Help,77,"F1",#PB_Shortcut_F1,ImageID(#Image_Help))
    MenuBar()
   MenuItemEx(#Menu_Main_SearchUpdates,Language(78),ImageID(#Image_Refresh))
   MenuItemEx(#Menu_Main_ReportBug,Language(253),ImageID(#Image_ReportBug))
    MenuBar()
   MenuItemEx(#Menu_Main_ChangeLog,"Change Log",ImageID(#Image_ChangeLog))
   AddMenuItem(#Menu_Main_About,79,"Alt+F1",#PB_Shortcut_Alt|#PB_Shortcut_F1,ImageID(#Image_About))
  CloseSubMenu()
  MenuItem(#Menu_Main_StartGTASA,Language(17))
 EndIf
 If CreatePopupMenu(#Menu_Panel)
  MenuItem(#Menu_Panel_UseTabs,Language(72))
  SetMenuItemState(#Menu_Panel,#Menu_Panel_UseTabs,Config\UseTabs)
 EndIf
 If CreatePopupMenu(#Menu_CleoManager)
  OpenSubMenu(Language(191))
   MenuItem(#Menu_CleoManager_LargeIcon,Language(192))
   MenuItem(#Menu_CleoManager_SmallIcon,Language(193))
   MenuItem(#Menu_CleoManager_List,Language(194))
   MenuItem(#Menu_CleoManager_Detail,"Details")
  CloseSubMenu()
 EndIf
 If CreatePopupMenu(#Menu_IPLEditor)
  OpenSubMenu(Language(195))
   MenuItem(#Menu_IPLEditor_EditID,"ID")
   MenuItem(#Menu_IPLEditor_EditModel,"Model")
   MenuItem(#Menu_IPLEditor_EditInterior,"Interior")
   MenuItem(#Menu_IPLEditor_EditX,"X")
   MenuItem(#Menu_IPLEditor_EditY,"Y")
   MenuItem(#Menu_IPLEditor_EditZ,"Z")
   MenuItem(#Menu_IPLEditor_EditUnknown1,"Unknown 1")
   MenuItem(#Menu_IPLEditor_EditUnknown2,"Unknown 2")
   MenuItem(#Menu_IPLEditor_EditUnknown3,"Unknown 3")
   MenuItem(#Menu_IPLEditor_EditUnknown4,"Unknown 4")
   MenuItem(#Menu_IPLEditor_EditLOD,"LOD")
  CloseSubMenu()
 EndIf
 If CreatePopupMenu(#Menu_Tray)
  MenuItem(#Menu_Tray_ShowWindow,Language(16))
   MenuBar()
  MenuItem(#Menu_Tray_StartGTASA,Language(17))
  If Tools
   MenuBar()
   OpenSubMenu(Language(10))
   For Tool=0 To Tools-1
    Name$=GetGadgetItemText(#Gadget_Tools_List,Tool,0)
    File$=GetGadgetItemText(#Gadget_Tools_List,Tool,1)
    Select GetGadgetItemData(#Gadget_Tools_List,Tool)
     Case #Tools_DefaultItem
      MenuItem(#Menu_FirstExternTool+Tool,Name$)
     Case #Tools_Separator
      MenuBar()
     Case #Tools_OpenSubMenu
      OpenSubMenu(Name$)
     Case #Tools_CloseSubMenu
      CloseSubMenu()
    EndSelect
   Next
   CloseSubMenu()
  EndIf
   MenuBar()
  MenuItem(#Menu_Main_Quit,Language(8))
 EndIf
 MENUITEMINFO.MENUITEMINFO
 MENUITEMINFO\cbSize=SizeOf(MENUITEMINFO)
 MENUITEMINFO\fMask=1
 MENUITEMINFO\fState=4096
 SetMenuItemInfo_(MenuID(#Menu_Tray),0,1,MENUITEMINFO)
 ForEach MDIWindow()
  If IsWindow(MDIWindow())
   If GetWindowState(MDIWindow())=#PB_Window_Maximize
    SetWindowState(MDIWindow(),#PB_Window_Normal)
    SetWindowState(MDIWindow(),#PB_Window_Maximize)
   EndIf
  EndIf
 Next
 CleoManagerListDisplay()
EndProcedure

Procedure UpdateVehicleList()
 File=ReadFile(#PB_Any,Common\InstallPath+"Vehicles.cfg")
  If IsFile(File)
   For Vehicle=0 To CountGadgetItems(#Gadget_Models_VehicleList)-1
    *Vehicles.Vehicles
    *Vehicles=GetGadgetItemData(#Gadget_Models_VehicleList,Vehicle)
    VehicleID=*Vehicles\ID
     If VehicleID=>400 And VehicleID<=611
      FileSeek(File,0)
      Repeat
       String$=Trim(StringField(ReadString(File),1,";"))
        If String$
         If Val(StringField(String$,1,Chr(9)))=VehicleID
          *Vehicles\Radio=Val(StringField(String$,2,Chr(9)))
          SetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,Trim(StringField(String$,3,Chr(9))),1)
         EndIf
        EndIf
      Until Eof(File)
      Select *Vehicles\Radio
       Case 0
        Radio$=Language(243)
       Case 1
        Radio$=Language(242)
       Default
        Radio$="N/A"
        *Vehicles\Radio=-1
      EndSelect
      SetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,Str(VehicleID),0)
      SetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,Radio$,3)
     EndIf
   Next
   CloseFile(File)
  EndIf
 File=ReadFile(#PB_Any,GetPathPart(Common\GTAFile)+"data\vehicles.ide")
  If IsFile(File)
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>"#"
      Select LCase(String$)
       Case "cars"
        Mode=1
       Case "end"
        Mode=0
       Default
        If Mode
         VehicleID=Val(Trim(StringField(String$,1,",")))
         Type$=Trim(RemoveString(StringField(String$,4,","),Chr(9),1))
         Select LCase(Type$)
          Case "bike"
           TypeName$=Language(218)
           Type=#Vehicle_Bike
          Case "bmx"
           TypeName$="BMX"
           Type=#Vehicle_BMX
          Case "boat"
           TypeName$=Language(219)
           Type=#Vehicle_Boat
          Case "car"
           TypeName$=Language(220)
           Type=#Vehicle_Car
          Case "heli"
           TypeName$=Language(221)
           Type=#Vehicle_Heli
          Case "mtruck"
           TypeName$="Monstertruck"
           Type=#Vehicle_Monstertruck
          Case "trailer"
           TypeName$=Language(222)
           Type=#Vehicle_Trailer
          Case "train"
           TypeName$=Language(223)
           Type=#Vehicle_Train
          Case "plane"
           TypeName$=Language(224)
           Type=#Vehicle_Plane
          Case "quad"
           TypeName$="Quad"
           Type=#Vehicle_Quad
          Default
           TypeName$=ReplaceString(Language(225),"%1",Type$,1)
           Type=#Vehicle_Unknown
         EndSelect
         For Vehicle=0 To CountGadgetItems(#Gadget_Models_VehicleList)-1
          *Vehicles.Vehicles
          *Vehicles=GetGadgetItemData(#Gadget_Models_VehicleList,Vehicle)
           If *Vehicles\ID=VehicleID
            *Vehicles\Type=Type
            SetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,TypeName$,2)
           EndIf
         Next
        EndIf
      EndSelect
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
EndProcedure

Procedure ListIcon_CreateImageList(ListIconGadget,Width,Height)
 ImageListID=SendMessage_(GadgetID(ListIconGadget),#LVM_GETIMAGELIST,#LVSIL_SMALL,0)
  If ImageListID=0
   ImageListID=ImageList_Create_(Width,Height,#ILC_MASK|#ILC_COLOR32,0,30)
    If ImageListID
     SendMessage_(GadgetID(ListIconGadget),#LVM_SETIMAGELIST,#LVSIL_SMALL,ImageListID)
      If IsImage(#Image_Empty)
       ImageList_AddIcon_(ImageListID,ImageID(#Image_Empty))
       FreeImage(#Image_Empty)
      EndIf
    EndIf
  EndIf
 ProcedureReturn ImageListID
EndProcedure

Procedure ListIcon_AddImage(ImageListID,Image)
 If IsImage(Image)
  ProcedureReturn ImageList_Add_(ImageListID,ImageID(Image),0)
 EndIf
EndProcedure

Procedure ListIcon_SetHeaderImage(ListIconGadget,Column,ImageIndex,Align)
 If ImageIndex<>-1
  ColumnText$=Space(255)
  Var.LVCOLUMN\Mask=4
  Var\pszText=@ColumnText$
  Var\cchTextMax=255
  SendMessage_(GadgetID(ListIconGadget),4121,Column,@Var)
  VarHeader.HDITEM\Mask=32|4|2
  VarHeader\fmt=2048|Align|16384
  VarHeader\iImage=ImageIndex
  VarHeader\pszText=@ColumnText$
  VarHeader\cchTextMax=Len(ColumnText$)
  HeaderID=SendMessage_(GadgetID(ListIconGadget),4127,0,0)
  SendMessage_(HeaderID,4612,Column,@VarHeader)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure ReloadKeyNames()
 KeyName(#VK_DELETE)=Language(49)
 KeyName(#VK_INSERT)=Language(51)
 KeyName(#VK_PAUSE)=Language(52)
 KeyName(#VK_PRINT)=Language(53)
 KeyName(#VK_CONTROL)=Language(54)
 KeyName(#VK_SHIFT)=Language(55)
 For Chr=#VK_A To #VK_Z
  KeyName(Chr)=Chr(Chr)
 Next
 For Chr=#VK_0 To #VK_9
  KeyName(Chr)=Chr(Chr)
 Next
 For Chr=#VK_NUMPAD0 To #VK_NUMPAD9
  KeyName(Chr)="Num "+Str(Chr-#VK_NUMPAD0)
 Next
 For Chr=#VK_F1 To #VK_F12
  KeyName(Chr)="F"+Str(Chr-#VK_F1+1)
 Next
EndProcedure

Procedure.s GetFileType(Extension$)
 For Item=0 To CountGadgetItems(#Gadget_Config_FileTypesList)-1
  If LCase(Trim(GetGadgetItemText(#Gadget_Config_FileTypesList,Item,0)))=LCase(Trim(Extension$))
   Name$=Trim(GetGadgetItemText(#Gadget_Config_FileTypesList,Item,1))
  EndIf
 Next
 If Name$=""
  Name$=Extension$+"-"+Language(7)
 EndIf
 ProcedureReturn Name$
EndProcedure

Procedure IMG_Open(FileName$)
 ClearList(IMGFiles())
 File=ReadFile(#PB_Any,FileName$)
  If IsFile(File)
   Version$=UCase(ReadStringEx(File,4))
    If Version$="VER2"
     Count=ReadLong(File)
     For Item=1 To Count
      AddElement(IMGFiles())
      IMGFiles()\Offset=ReadLong(File)*2048
      IMGFiles()\Size=ReadLong(File)*2048
      IMGFiles()\Name=ReadStringEx(File,24)
      Ext$=Left(GetExtensionPart(IMGFiles()\Name),3)
      IMGFiles()\Name=GetFileName(IMGFiles()\Name)+"."+Ext$
      IMGFiles()\Type=GetFileType(LCase(Ext$))
     Next
     Config\IMGEditor_ArchiveFile=FileName$
    EndIf
   CloseFile(File)
  EndIf
 ProcedureReturn ListSize(IMGFiles())
EndProcedure

Procedure IMG_ExportFile(File,SaveFileName$)
 If File=>0 And File<ListSize(IMGFiles()) And Config\IMGEditor_ArchiveFile
  SelectElement(IMGFiles(),File)
  IMG=ReadFile(#PB_Any,Config\IMGEditor_ArchiveFile)
   If IsFile(IMG)
    File=CreateFile(#PB_Any,SaveFileName$)
     If IsFile(File)
      FileSeekEx(IMG,IMGFiles()\Offset)
      For Byte=1 To IMGFiles()\Size
       WriteByte(File,ReadByte(IMG))
      Next
      CloseFile(File)
     EndIf
    CloseFile(IMG)
   EndIf
 EndIf
EndProcedure

Procedure IMG_OpenEx(File$)
 ClearGadgetItems(#Gadget_IMGEditor_List)
 DisableToolBarButton(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Open,1)
 DisableGadget(#Gadget_IMGEditor_List,1)
 Count=IMG_Open(File$)
  If Count
   SetWindowTitle(#Window_MDI_IMGEditor,"IMG Editor - "+GetFilePart(File$))
   SetGadgetAttribute(#Gadget_IMGEditor_Progress,#PB_ProgressBar_Maximum,Count)
   SetGadgetState(#Gadget_IMGEditor_Progress,0)
   ForEach IMGFiles()
    AddGadgetItem(#Gadget_IMGEditor_List,-1,IMGFiles()\Name+Chr(10)+RSet(Hex(IMGFiles()\Offset),8,"0")+Chr(10)+Str(IMGFiles()\Size)+" Bytes"+Chr(10)+IMGFiles()\Type)
    SetGadgetState(#Gadget_IMGEditor_Progress,GetGadgetState(#Gadget_IMGEditor_Progress)+1)
   Next
   DisableToolBarButton(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Open,0)
   DisableGadget(#Gadget_IMGEditor_List,0)
  EndIf
EndProcedure

Procedure Savegame_SelectBlock(File,Block,SeekBytes=0)
 FileSeek(File,0)
 Repeat
  Start=Loc(File)
  Find=0
  If ReadByte(File)='B'
   If ReadByte(File)='L'
    If ReadByte(File)='O'
     If ReadByte(File)='C'
      If ReadByte(File)='K'
       BlockID+1
       BlockStart=Start+5
       Find=1
      EndIf
     EndIf
    EndIf
   EndIf
  EndIf
  If Find=0
   FileSeek(File,Start+1)
  EndIf
  If BlockID-1=Block
   FileSeek(File,BlockStart+SeekBytes)
   Break
  EndIf
 Until Eof(File)
 ProcedureReturn Loc(File)
EndProcedure

Procedure Savegame_RewriteChecksum(File)
 FileSeek(File,0)
 CheckSum.q=0
 For Byte=1 To $317FC
  CheckSum+(ReadByte(File)&$FF)
 Next
 FileSeek(File,$317FC)
 CheckSum2.l=CheckSum
 WriteLong(File,CheckSum2)
EndProcedure

Procedure ReloadSavegames()
 ClearGadgetItems(#Gadget_SavegameManager_List)
 For Save=1 To 8
  File=ReadFile(#PB_Any,Config\GTAUserFiles+"GTASAsf"+Str(Save)+".b")
   If IsFile(File)
    FileSeekEx(File,9)
    Name$=Trim(ReadStringEx(File,100,0))
    FileSeekEx(File,139)
    Hour=ReadByte(File)
    Minute=ReadByte(File)
    FileSeekEx(File,141)
    WeekDay=ReadByte(File)
    CloseFile(File)
    Hour$=Str(Hour)
     If Len(Hour$)=1
      Hour$="0"+Hour$
     EndIf
    Minute$=Str(Minute)
     If Len(Minute$)=1
      Minute$="0"+Minute$
     EndIf
    If WeekDay=>1 And WeekDay<=7
     Day$=Trim(StringField(Language(172),WeekDay," "))
    Else
     Day$="N/A"
    EndIf
    AddGadgetItem(#Gadget_SavegameManager_List,-1,"GTASAsf"+Str(Save)+".b"+Chr(10)+Name$+Chr(10)+Hour$+":"+Minute$+Chr(10)+Day$)
   EndIf
 Next
EndProcedure

Procedure OpenMDIWindow(MDIGadget,Window,Width,Height,Title$,Flags=0,Image=-1)
 If Flags=0
  Flags=#PB_Window_SystemMenu
 EndIf
 If IsImage(Image)
  ImageID=ImageID(Image)
 EndIf
 If Window=#PB_Any
  Window=AddGadgetItem(MDIGadget,#PB_Any,Title$,ImageID,Flags)
 Else
  WindowID=AddGadgetItem(MDIGadget,Window,Title$,ImageID,Flags)
 EndIf
 If IsWindow(Window)
  AddElement(MDIWindow())
  MDIWindow()=Window
  SmartWindowRefresh(Window,Config\SmartWindowRefresh)
  ResizeWindow(Window,#PB_Ignore,#PB_Ignore,Width,Height)
  If WindowID=0
   WindowID=Window
  EndIf
 EndIf
 ProcedureReturn WindowID
EndProcedure

Procedure CloseMDIWindow(Window)
 ForEach MDIWindow()
  If MDIWindow()=Window
   If IsWindow(Window)
    CloseWindow(Window)
   EndIf
   DeleteElement(MDIWindow())
   Break
  EndIf
 Next
EndProcedure

Procedure SetMDIImage()
 If IsImage(#Image_MDIBackground)
  CopyImage(#Image_MDIBackground,#Image_MDIBackground2)
  ResizeImage(#Image_MDIBackground2,GadgetWidth(#Gadget_Main_MDI),GadgetHeight(#Gadget_Main_MDI))
  SetGadgetAttribute(#Gadget_Main_MDI,#PB_MDI_Image,ImageID(#Image_MDIBackground2))
 EndIf
EndProcedure

Procedure SaveCheatlist()
 File=CreateFile(#PB_Any,Common\InstallPath+"Cheats.clf")
  If IsFile(File)
   WriteStringN(File,"; Cheatlist")
    For Item=0 To CountGadgetItems(#Gadget_Cheats_List)-1
     String$=GetGadgetItemText(#Gadget_Cheats_List,Item,0)+"|"
     String$+GetGadgetItemText(#Gadget_Cheats_List,Item,1)+"|"
     HotkeyData=GetGadgetItemData(#Gadget_Cheats_List,Item)
      If HotkeyData
       *Hotkey.Hotkey
       *Hotkey=HotkeyData
       If *Hotkey\Ctrl
        String$+Str(#VK_CONTROL)+"+"
       EndIf
       If *Hotkey\Shift
        String$+Str(#VK_SHIFT)+"+"
       EndIf
       If *Hotkey\Alt
        String$+Str(#VK_MENU)+"+"
       EndIf
       If *Hotkey\Hotkey
        String$+Str(*Hotkey\Hotkey)
       EndIf
       If Right(String$,1)="+"
        String$=Left(String$,Len(String$)-1)
       EndIf
      EndIf
     String$+"|"
     String$+GetGadgetItemText(#Gadget_Cheats_List,Item,3)
     WriteStringN(File,String$)
    Next
   CloseFile(File)
  EndIf
 SendMessage(#Module_CheatProcessor,#Module_CMD_ReloadAll)
EndProcedure

Procedure SaveTeleportlist()
 File=CreateFile(#PB_Any,Common\InstallPath+"Teleporter.clf")
  If IsFile(File)
   WriteStringN(File,"; Teleportlist")
   For Item=0 To CountGadgetItems(#Gadget_Teleporter_List)-1
    Cheat$=Trim(GetGadgetItemText(#Gadget_Teleporter_List,Item,0))
    x$=Trim(GetGadgetItemText(#Gadget_Teleporter_List,Item,1))
    y$=Trim(GetGadgetItemText(#Gadget_Teleporter_List,Item,2))
    z$=Trim(GetGadgetItemText(#Gadget_Teleporter_List,Item,3))
    Interior=GetGadgetItemData(#Gadget_Teleporter_List,Item)
    WriteStringN(File,x$+";"+y$+";"+z$+"|"+Cheat$+"|"+Str(Interior))
   Next
   CloseFile(File)
  EndIf
 SendMessage(#Module_CheatProcessor,#Module_CMD_ReloadAll)
EndProcedure

Procedure AddCheat(Cheat$,Description$,Sound$,Hotkey_UseCtrl,Hotkey_UseShift,Hotkey_UseAlt,Hotkey_Key,Item)
 Add=1
 If Item=-1
  For Cheat=0 To CountGadgetItems(#Gadget_Cheats_List)-1
   If UCase(Trim(GetGadgetItemText(#Gadget_Cheats_List,Cheat,0)))=UCase(Trim(Cheat$))
    Add=0
   EndIf
  Next
 EndIf
 If Add
  If Item<>-1
   HotkeyData=GetGadgetItemData(#Gadget_Cheats_List,Item)
  EndIf
  If HotkeyData=0
   HotkeyData=AllocateMemory(SizeOf(Hotkey))
  EndIf
  If Hotkey_Key
   If Hotkey_UseCtrl
    Hotkey$+Language(54)+"+"
   EndIf
   If Hotkey_UseShift
    Hotkey$+Language(55)+"+"
   EndIf
   If Hotkey_UseAlt
    Hotkey$+"Alt+"
   EndIf
   For Key=0 To 255
    If Key(Key)=Hotkey_Key
     Hotkey$+KeyName(Key)
     AsciiKey=Key
     Break
    EndIf
   Next
  Else
   Hotkey$=Language(32)
   Hotkey_UseCtrl=0
   Hotkey_UseShift=0
   Hotkey_UseAlt=0
  EndIf
  If Hotkey_Key
   For Cheat=0 To CountGadgetItems(#Gadget_Cheats_List)-1
    If LCase(GetGadgetItemText(#Gadget_Cheats_List,Cheat,2))=LCase(Hotkey$)
     UsedBy$=UCase(GetGadgetItemText(#Gadget_Cheats_List,Cheat,0))
    EndIf
   Next
  EndIf
  If UsedBy$ And Item=-1
   MessageRequester(Language(19),ReplaceString(ReplaceString(Language(147),"%1",Hotkey$,1),"%2",UsedBy$,1),#MB_ICONERROR)
  Else
   *Hotkey.Hotkey
   *Hotkey=HotkeyData
   *Hotkey\Ctrl=Hotkey_UseCtrl
   *Hotkey\Shift=Hotkey_UseShift
   *Hotkey\Alt=Hotkey_UseAlt
   *Hotkey\Hotkey=AsciiKey
   If Item=-1
    AddGadgetItem(#Gadget_Cheats_List,-1,"")
    Item=CountGadgetItems(#Gadget_Cheats_List)-1
   EndIf
   SetGadgetItemText(#Gadget_Cheats_List,Item,Cheat$,0)
   SetGadgetItemText(#Gadget_Cheats_List,Item,Description$,1)
   SetGadgetItemText(#Gadget_Cheats_List,Item,Hotkey$,2)
   SetGadgetItemText(#Gadget_Cheats_List,Item,Sound$,3)
   SetGadgetItemData(#Gadget_Cheats_List,Item,*Hotkey)
   If Config\AutoSaveData
    SaveCheatlist()
   EndIf
   ProcedureReturn 1
  EndIf
 Else
  MessageRequester(Language(19),ReplaceString(Language(95),"%1",UCase(Cheat$),1),#MB_ICONERROR)
 EndIf
EndProcedure

Procedure TeleportMap_SetPoint(x=-1,y=-1)
 If x<0 Or y<0
  x=Config\TeleportMap_X
  y=Config\TeleportMap_Y
 Else
  Config\TeleportMap_X=x
  Config\TeleportMap_Y=y
 EndIf
 MapX=x-300
 MapY=SwapMath(y-300)
 If CreateImage(#Image_GTAMapPoint,600,600)
  If StartDrawing(ImageOutput(#Image_GTAMapPoint))
   DrawImage(ImageID(#Image_GTAMap),0,0)
   Box(0,y,ImageWidth(#Image_GTAMapPoint),2,$FF)
   Box(x,0,2,ImageHeight(#Image_GTAMapPoint),$FF)
   StopDrawing()
  EndIf
  SetGadgetState(#Gadget_TeleportMap_Image,ImageID(#Image_GTAMapPoint))
 EndIf
 If IsWindow(#Window_MDI_Teleporter)
  SetGadgetText(#Gadget_Teleporter_EditX,Str(MapX*10))
  SetGadgetText(#Gadget_Teleporter_EditY,Str(MapY*10))
 EndIf
 Title$=Language(33)
 If x=>0 And y=>0
  Title$+" ("+Str((x-300)*10)+" x "+Str(SwapMath(y-300)*10)+")"
 EndIf
 SetWindowTitle(#Window_MDI_TeleportMap,Title$)
EndProcedure

Procedure Teleporter_ShowMap(x,y)
 If IsWindow(#Window_MDI_TeleportMap)=0
  If OpenMDIWindow(#Gadget_Main_MDI,#Window_MDI_TeleportMap,600,600,Language(33),#PB_Window_All,#Image_ShowMap)
   ScrollAreaGadget(#Gadget_TeleportMap_ScrollArea,0,0,WindowWidth(#Window_MDI_TeleportMap),WindowHeight(#Window_MDI_TeleportMap),600,600,100,#PB_ScrollArea_Flat|#PB_ScrollArea_Center)
    ImageGadget(#Gadget_TeleportMap_Image,0,0,GetGadgetAttribute(#Gadget_TeleportMap_ScrollArea,#PB_ScrollArea_InnerWidth),GetGadgetAttribute(#Gadget_TeleportMap_ScrollArea,#PB_ScrollArea_InnerHeight),0)
   CloseGadgetList()
  EndIf
 EndIf
 TeleportMap_SetPoint(x,y)
EndProcedure

Procedure LoadLanguage()
 Select Config\Language
  Case #LANG_ENGLISH
   Restore Language_English
   Language=0
  Case #LANG_GERMAN
   Restore Language_German
   Language=1
  Default
   Info$+"Select the language you want to use to."+Chr(13)
   Info$+Chr(13)
   Info$+"Wähle die Sprache, die du verwenden möchtest."
   If OpenWindow(#Window_Language,100,100,270,110,"GTA San Andreas ToolBox",#PB_Window_ScreenCentered)
    TextGadget(#Gadget_Language_Text,10,10,WindowWidth(#Window_Language)-20,WindowHeight(#Window_Language)-60,Info$)
    ButtonGadget(#Gadget_Language_UseEnglish,10,GadgetHeight(#Gadget_Language_Text)+20,WindowWidth(#Window_Language)/2-15,30,"English")
    ButtonGadget(#Gadget_Language_UseGerman,GadgetWidth(#Gadget_Language_UseEnglish)+20,GadgetY(#Gadget_Language_UseEnglish),GadgetWidth(#Gadget_Language_UseEnglish),30,"Deutsch")
    LoadFont(#Font_Default,"Arial",8)
    LoadFont(#Font_Bold,"Arial Black",12)
    For Gadget=#Gadget_Language_Text To #Gadget_Language_UseGerman
     SetGadgetFont(Gadget,FontID(#Font_Default))
    Next
    SetGadgetFont(#Gadget_Language_UseEnglish,FontID(#Font_Bold))
    SetGadgetFont(#Gadget_Language_UseGerman,FontID(#Font_Bold))
    Repeat
     Select WaitWindowEvent()
      Case #PB_Event_Gadget
       Select EventGadget()
        Case #Gadget_Language_UseEnglish
         Config\Language=#LANG_ENGLISH
         Restore Language_English
         LanguageSet=1
        Case #Gadget_Language_UseGerman
         Config\Language=#LANG_GERMAN
         Restore Language_German
         LanguageSet=1
       EndSelect
     EndSelect
    Until LanguageSet
    CloseWindow(#Window_Language)
   EndIf
 EndSelect
 For String=0 To #MaxLang
  Read.s LanguageArray(String)
  If IsWindow(#Window_Splash) Or IsWindow(#Window_Main)
   WindowEvent()
  EndIf
 Next
 ProcedureReturn Language
EndProcedure

Procedure RefreshLanguage(ReloadLanguage=1)
 If ReloadLanguage=1
  LoadLanguage()
 EndIf
 Select Config\Language
  Case #LANG_ENGLISH
   Language=0
  Case #LANG_GERMAN
   Language=1
 EndSelect
 ReloadMenu()
 ReloadKeyNames()
 SetWindowTitle(#Window_MDI_Cheats,Language(0))
 SetWindowTitle(#Window_MDI_Models,Language(68))
 SetWindowTitle(#Window_MDI_Config,Language(24))
 SetWindowTitle(#Window_MDI_Tools,Language(109))
 SetGadgetItemText(#Gadget_Main_Panel,#Tab_Cheats,Language(0))
 SetGadgetItemText(#Gadget_Main_Panel,#Tab_Teleporter,"Teleporter")
 SetGadgetItemText(#Gadget_Main_Panel,#Tab_SavegameManager,"SavegameManager")
 SetGadgetItemText(#Gadget_Main_Panel,#Tab_Models,Language(68))
 SetGadgetItemText(#Gadget_Main_Panel,#Tab_MemoryChanger,"MemoryChanger")
 SetGadgetItemText(#Gadget_Main_Panel,#Tab_IMGEditor,"IMG Editor")
 SetGadgetItemText(#Gadget_Main_Panel,#Tab_Config,Language(24))
 ToolBarToolTip(#ToolBar_Cheats,#ToolBar_Cheats_Save,Language(11))
 ToolBarToolTip(#ToolBar_Cheats,#ToolBar_Cheats_Add,Language(1))
 ToolBarToolTip(#ToolBar_Cheats,#ToolBar_Cheats_Remove,Language(2))
 ToolBarToolTip(#ToolBar_Cheats,#ToolBar_Cheats_Edit,Language(12))
 ToolBarToolTip(#ToolBar_Cheats,#ToolBar_Cheats_Print,Language(167))
 ToolBarToolTip(#ToolBar_Cheats,#ToolBar_Cheats_Export,Language(103))
 SetGadgetItemText(#Gadget_Cheats_List,-1,Language(3),0)
 SetGadgetItemText(#Gadget_Cheats_List,-1,Language(4),1)
 SetGadgetItemText(#Gadget_Cheats_List,-1,Language(5),2)
 SetGadgetItemText(#Gadget_Cheats_List,-1,Language(6),3)
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_Save,Language(67))
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_Add,Language(28))
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_Remove,Language(29))
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_Edit,Language(66))
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_ReadMemory,Language(233))
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_ShowMap,Language(30))
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_Goto,Language(71))
 ToolBarToolTip(#ToolBar_Teleporter,#ToolBar_Teleporter_Savegame,Language(57))
 Item=GetGadgetState(#Gadget_Teleporter_EditInterior)
 SetGadgetItemText(#Gadget_Teleporter_EditInterior,0,Language(170))
 SetGadgetState(#Gadget_Teleporter_EditInterior,Item)
 ToolBarToolTip(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Save,Language(238))
 ToolBarToolTip(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Edit,Language(21))
 ToolBarToolTip(#ToolBar_SavegameManager,#ToolBar_SavegameManager_CreateBackup,Language(22))
 ToolBarToolTip(#ToolBar_SavegameManager,#ToolBar_SavegameManager_RestoreBackup,Language(23))
 ToolBarToolTip(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Refresh,Language(27))
 SetGadgetItemText(#Gadget_SavegameManager_List,-1,Language(7),0)
 SetGadgetItemText(#Gadget_SavegameManager_List,-1,Language(18),1)
 SetGadgetItemText(#Gadget_SavegameManager_List,-1,Language(169),2)
 SetGadgetItemText(#Gadget_SavegameManager_List,-1,Language(171),3)
 SetGadgetText(#Gadget_SavegameManager_Editor_Text2,Language(157))
 SetGadgetText(#Gadget_SavegameManager_Editor_Text3,Language(158))
 SetGadgetText(#Gadget_SavegameManager_Editor_Text4,Language(159))
 SetGadgetText(#Gadget_SavegameManager_Editor_Text5,Language(160))
 ToolBarToolTip(#ToolBar_Models,#ToolBar_Models_Save,Language(90))
 ToolBarToolTip(#ToolBar_Models,#ToolBar_Models_Edit,Language(92))
 ToolBarToolTip(#ToolBar_Models,#ToolBar_Models_AddAsCheat,Language(96))
 ToolBarToolTip(#ToolBar_Models,#ToolBar_Models_Spawn,Language(94))
 ToolBarToolTip(#ToolBar_Models,#ToolBar_Models_Refresh,Language(27))
 ToolBarToolTip(#ToolBar_MemoryChanger,#ToolBar_MemoryChanger_Add,Language(48))
 ToolBarToolTip(#ToolBar_MemoryChanger,#ToolBar_MemoryChanger_Set,Language(134))
 ToolBarToolTip(#ToolBar_MemoryChanger,#ToolBar_MemoryChanger_Remove,"Remove")
 ToolBarToolTip(#ToolBar_MemoryChanger,#ToolBar_MemoryChanger_Clear,"Clear")
 ToolBarToolTip(#ToolBar_MemoryChanger,#ToolBar_MemoryChanger_ReadMemory,Language(135))
 ToolBarToolTip(#ToolBar_MemoryChanger,#ToolBar_MemoryChanger_WriteMemory,Language(136))
 SetGadgetItemText(#Gadget_Models_Panel,0,Language(69))
 SetGadgetItemText(#Gadget_Models_Panel,1,Language(70))
 SetGadgetItemText(#Gadget_Models_VehicleList,-1,Language(73),0)
 SetGadgetItemText(#Gadget_Models_VehicleList,-1,Language(99),2)
 SetGadgetItemText(#Gadget_Models_WeaponList,-1,Language(74),0)
 SetGadgetItemText(#Gadget_Models_WeaponList,-1,Language(87),3)
 SetGadgetItemText(#Gadget_Models_WeaponList,-1,Language(88),4)
 SetGadgetItemText(#Gadget_Models_WeaponList,-1,Language(89),5)
 SetGadgetText(#Gadget_MemoryChanger_Text2,Language(137)+":")
 SetGadgetText(#Gadget_MemoryChanger_Text3,Language(138)+":")
 SetGadgetText(#Gadget_MemoryChanger_Text4,Language(139)+":")
 SetGadgetItemText(#Gadget_MemoryChanger_List,-1,Language(137),1)
 SetGadgetItemText(#Gadget_MemoryChanger_List,-1,Language(138),2)
 SetGadgetItemText(#Gadget_MemoryChanger_List,-1,Language(139),3)
 ToolBarToolTip(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Open,Language(25))
 ToolBarToolTip(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Export,Language(103))
 ToolBarToolTip(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Replace,Language(104))
 ToolBarToolTip(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Delete,Language(105))
 ToolBarToolTip(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Insert,Language(51))
 SetGadgetItemText(#Gadget_IMGEditor_List,-1,Language(98),2)
 SetGadgetItemText(#Gadget_IMGEditor_List,-1,Language(99),3)
 SetGadgetItemText(#Gadget_CleoManager_List,-1,Language(176),1)
 SetGadgetItemText(#Gadget_CleoManager_List,-1,Language(177),3)
 SetGadgetText(#Gadget_IPLEditor_Save,Language(179))
 ToolBarToolTip(#ToolBar_GameTweaks,#ToolBar_GameTweaks_Read,Language(121))
 ToolBarToolTip(#ToolBar_GameTweaks,#ToolBar_GameTweaks_Write,Language(122))
 SetGadgetItemText(#Gadget_GameTweaks_Panel,0,Language(123))
 SetGadgetItemText(#Gadget_GameTweaks_Panel,1,Language(173))
 SetGadgetText(#Gadget_GameTweaks_Text1,Language(207))
 SetGadgetText(#Gadget_GameTweaks_Text2,Language(208))
 SetGadgetText(#Gadget_GameTweaks_Text4,Language(209))
 SetGadgetText(#Gadget_GameTweaks_Text5,Language(210))
 SetGadgetText(#Gadget_GameTweaks_Text6,Language(211))
 SetGadgetText(#Gadget_GameTweaks_Text7,Language(212))
 SetGadgetText(#Gadget_GameTweaks_Text11,Language(213))
 SetGadgetText(#Gadget_GameTweaks_Text12,Language(214))
 SetGadgetText(#Gadget_GameTweaks_Text13,Language(215))
 SetGadgetText(#Gadget_GameTweaks_Text14,Language(216))
 SetGadgetText(#Gadget_GameTweaks_Text15,Language(217))
 ToolBarToolTip(#ToolBar_Config,#ToolBar_Config_Save,Language(35))
 SetGadgetText(#Gadget_Config_FrameGeneral,Language(44))
 SetGadgetText(#Gadget_Config_RememberMDI,Language(39))
 SetGadgetText(#Gadget_Config_MinimizeToTray,Language(38))
 SetGadgetText(#Gadget_Config_StartMinimized,Language(37))
 SetGadgetText(#Gadget_Config_DisplayMessages,Language(36))
 SetGadgetText(#Gadget_Config_QuitConfirm,Language(58))
 SetGadgetText(#Gadget_Config_UseTabs,Language(72))
 SetGadgetText(#Gadget_Config_DisableGTASplash,Language(148))
 SetGadgetText(#Gadget_Config_CloseModulesOnQuit,Language(178))
 SetGadgetText(#Gadget_Config_AutoCheckUpdates,Language(117))
 SetGadgetText(#Gadget_Config_AutoSaveData,Language(254))
 SetGadgetText(#Gadget_Config_UseCheatSound,Language(40))
 SetGadgetText(#Gadget_Config_OpenCheatSound,Language(25))
 SetGadgetText(#Gadget_Config_FrameBackground,Language(166))
 SetGadgetText(#Gadget_Config_OpenGTAFile,Language(25))
 SetGadgetText(#Gadget_Config_FrameLanguage,Language(41))
 SetGadgetItemText(#Gadget_Config_Language,0,Language(42))
 SetGadgetItemText(#Gadget_Config_Language,1,Language(43))
 SetGadgetText(#Gadget_Config_FrameCheatProcessor,Language(47))
 SetGadgetText(#Gadget_Config_CheatProcessorAdd,Language(48))
 SetGadgetText(#Gadget_Config_CheatProcessorRemove,Language(49))
 SetGadgetText(#Gadget_Config_CheatProcessorClear,Language(50))
 SetGadgetText(#Gadget_Config_FrameImageType,Language(114))
 SetGadgetText(#Gadget_Config_FrameMapType,Language(244))
 SetGadgetText(#Gadget_Config_MapType2D,Language(245))
 SetGadgetText(#Gadget_Config_MapType3D,Language(246))
 SetGadgetText(#Gadget_Config_FrameFileTypes,Language(115))
 SetGadgetItemText(#Gadget_Config_FileTypesList,-1,Language(116),0)
 SetGadgetText(#Gadget_Config_FrameStartup,Language(142))
 SetGadgetText(#Gadget_Config_UseBackground,Language(40))
 SetGadgetText(#Gadget_Config_OpenBackground,Language(25))
 SetGadgetState(#Gadget_Config_Language,Language)
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_Add,Language(111))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_Remove,Language(112))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_Edit,Language(113))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_AddBar,Language(118))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_OpenSubMenu,Language(203))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_CloseSubMenu,Language(204))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_MoveUp,Language(149))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_MoveDown,Language(150))
 ToolBarToolTip(#ToolBar_Tools,#ToolBar_Tools_RefreshMenu,Language(151))
 SetGadgetItemText(#Gadget_Tools_List,-1,Language(7),1)
 For Item=0 To CountGadgetItems(#Gadget_Cheats_List)-1
  Hotkey$=""
  *HotkeyData.Hotkey
  *HotkeyData=GetGadgetItemData(#Gadget_Cheats_List,Item)
  If *HotkeyData=0
   *HotkeyData=AllocateMemory(SizeOf(Hotkey))
  EndIf
  If *HotkeyData\Ctrl
   Hotkey$+Language(54)+"+"
  EndIf
  If *HotkeyData\Shift
   Hotkey$+Language(55)+"+"
  EndIf
  If *HotkeyData\Alt
   Hotkey$+"Alt+"
  EndIf
  If *HotkeyData\Hotkey
   For Key=0 To 255
    If Key(Key)=Key(*HotkeyData\Hotkey)
     Hotkey$+KeyName(Key)
     AsciiKey=Key
     Break
    EndIf
   Next
  Else
   Hotkey$=Language(32)
   *HotkeyData\Ctrl=0
   *HotkeyData\Shift=0
   *HotkeyData\Alt=0
  EndIf
  SetGadgetItemText(#Gadget_Cheats_List,Item,Hotkey$,2)
  SetGadgetItemData(#Gadget_Cheats_List,Item,*HotkeyData)
 Next
 For Item=0 To CountGadgetItems(#Gadget_Teleporter_List)-1
  Interior=GetGadgetItemData(#Gadget_Teleporter_List,Item)
  If Interior=-1
   Interior$=Language(170)
  Else
   Interior$=Interior(Interior)
  EndIf
  SetGadgetItemText(#Gadget_Teleporter_List,Item,Interior$,5)
 Next
 If IsWindow(#Window_MDI_TeleportMap)
  TeleportMap_SetPoint()
 EndIf
 UpdateVehicleList()
EndProcedure

Procedure RestoreWindow()
 SetWindowState(#Window_Main,Windows\Main\State)
 HideWindow(#Window_Main,0)
 SetForegroundWindow_(WindowID(#Window_Main))
EndProcedure

Procedure ReloadModuleConfig()
 SendMessage(#Module_CheatProcessor,#Module_CMD_ReloadAll)
 SendMessage(#Module_SpeedLauncher,#Module_CMD_ReloadAll)
 SendMessage(#Module_WebServer,#Module_CMD_ReloadAll)
EndProcedure

Procedure DefaultWindowSettings()
 Windows\Main\x=100
 Windows\Main\y=100
 Windows\Main\Width=500
 Windows\Main\Height=500
 Windows\Main\Show=1
 Windows\Main\State=#PB_Window_Normal
 Windows\Cheats\x=100
 Windows\Cheats\y=100
 Windows\Cheats\Width=500
 Windows\Cheats\Height=500
 Windows\Cheats\Show=1
 Windows\Cheats\State=#PB_Window_Normal
 Windows\Teleporter\x=100
 Windows\Teleporter\y=100
 Windows\Teleporter\Width=500
 Windows\Teleporter\Height=500
 Windows\Teleporter\Show=0
 Windows\Teleporter\State=#PB_Window_Normal
 Windows\SavegameManager\x=100
 Windows\SavegameManager\y=100
 Windows\SavegameManager\Width=500
 Windows\SavegameManager\Height=500
 Windows\SavegameManager\Show=0
 Windows\SavegameManager\State=#PB_Window_Normal
 Windows\Models\x=100
 Windows\Models\y=100
 Windows\Models\Width=500
 Windows\Models\Height=500
 Windows\Models\Show=0
 Windows\Models\State=#PB_Window_Normal
 Windows\MemoryChanger\x=100
 Windows\MemoryChanger\y=100
 Windows\MemoryChanger\Width=500
 Windows\MemoryChanger\Height=500
 Windows\MemoryChanger\Show=0
 Windows\MemoryChanger\State=#PB_Window_Normal
 Windows\IMGEditor\x=100
 Windows\IMGEditor\y=100
 Windows\IMGEditor\Width=500
 Windows\IMGEditor\Height=500
 Windows\IMGEditor\Show=0
 Windows\IMGEditor\State=#PB_Window_Normal
 Windows\CleoManager\x=100
 Windows\CleoManager\y=100
 Windows\CleoManager\Width=500
 Windows\CleoManager\Height=500
 Windows\CleoManager\Show=0
 Windows\CleoManager\State=#PB_Window_Normal
 Windows\IPLEditor\x=100
 Windows\IPLEditor\y=100
 Windows\IPLEditor\Width=500
 Windows\IPLEditor\Height=500
 Windows\IPLEditor\Show=0
 Windows\IPLEditor\State=#PB_Window_Normal
 Windows\Config\x=100
 Windows\Config\y=100
 Windows\Config\Width=500
 Windows\Config\Height=500
 Windows\Config\Show=1
 Windows\Config\State=#PB_Window_Normal
 File=CreateFile(#PB_Any,Config\WindowFile)
  If IsFile(File)
   WriteData(File,Windows,SizeOf(Windows))
   CloseFile(File)
  EndIf
EndProcedure

Procedure SaveSettings()
 If CreatePreferences(Common\PrefsFile)
  PreferenceGroup("Global")
   WritePreferenceLong("RememberMDI",Config\RememberMDI)
   WritePreferenceLong("MinimizeToTray",Config\MinimizeToTray)
   WritePreferenceLong("StartMinimized",Config\StartMinimized)
   WritePreferenceLong("DisplayMessages",Config\DisplayMessages)
   WritePreferenceLong("Language",Config\Language)
   WritePreferenceLong("QuitConfirm",Config\QuitConfirm)
   WritePreferenceLong("UseTabs",Config\UseTabs)
   WritePreferenceLong("DisableGTASplash",Config\DisableGTASplash)
   WritePreferenceString("ActivateCheat",Config\ActivateCheat)
   WritePreferenceLong("ImageType",Config\ImageType)
   WritePreferenceLong("MapType",Config\MapType)
   WritePreferenceLong("SmartWindowRefresh",Config\SmartWindowRefresh)
   WritePreferenceLong("IconSize",Config\IconSize)
   WritePreferenceLong("CleoManager_ListDisplay",Config\CleoManager_ListDisplay)
   WritePreferenceLong("CloseModulesOnQuit",Config\CloseModulesOnQuit)
   WritePreferenceLong("AutoCheckUpdates",Config\AutoCheckUpdates)
   WritePreferenceLong("AutoSaveData",Config\AutoSaveData)
   WritePreferenceLong("ShowBetaInfo",Config\ShowBetaInfo)
  PreferenceGroup("HigherProcessPriority")
   WritePreferenceLong("CheatProcessor",Config\HigherProcessPriority\CheatProcessor)
   WritePreferenceLong("GUI",Config\HigherProcessPriority\GUI)
   WritePreferenceLong("MemoryServer",Config\HigherProcessPriority\MemoryServer)
   WritePreferenceLong("WebServer",Config\HigherProcessPriority\WebServer)
  PreferenceGroup("IgnoreList")
   WritePreferenceString("Vehicles",Config\IgnoreList_Vehicles)
   WritePreferenceString("Cheats",Config\IgnoreList_Cheats)
  PreferenceGroup("ID3Tag")
   WritePreferenceLong("LoadID3Tag_Startup",Config\LoadID3Tag_Startup)
   WritePreferenceLong("LoadID3Tag_Refresh",Config\LoadID3Tag_Refresh)
  PreferenceGroup("TextZone")
   WritePreferenceFloat("VehicleDamageX",Config\TextZone\VehicleDamage\X)
   WritePreferenceFloat("VehicleDamageY",Config\TextZone\VehicleDamage\Y)
   WritePreferenceLong("VehicleDamageColor",Config\TextZone\VehicleDamage\Color)
   WritePreferenceFloat("VehicleSpeedX",Config\TextZone\VehicleSpeed\X)
   WritePreferenceFloat("VehicleSpeedY",Config\TextZone\VehicleSpeed\Y)
   WritePreferenceLong("VehicleSpeedColor",Config\TextZone\VehicleSpeed\Color)
   WritePreferenceFloat("TimerX",Config\TextZone\Timer\X)
   WritePreferenceFloat("TimerY",Config\TextZone\Timer\Y)
   WritePreferenceLong("TimerColor",Config\TextZone\Timer\Color)
   WritePreferenceFloat("SpawnVehicleX",Config\TextZone\SpawnVehicle\X)
   WritePreferenceFloat("SpawnVehicleY",Config\TextZone\SpawnVehicle\Y)
   WritePreferenceLong("SpawnVehicleColor",Config\TextZone\SpawnVehicle\Color)
  PreferenceGroup("CheatSound")
   WritePreferenceLong("UseCheatSound",Config\UseCheatSound)
   WritePreferenceString("CheatSound",Config\CheatSound)
  PreferenceGroup("Background")
   WritePreferenceLong("UseBackground",Config\UseBackground)
   WritePreferenceString("BackgroundFile",Config\BackgroundFile)
  PreferenceGroup("Startup")
   WritePreferenceLong("CheatProcessor",Config\Startup_CheatProcessor)
   WritePreferenceLong("MemoryServer",Config\Startup_MemoryServer)
   WritePreferenceLong("WebServer",Config\Startup_WebServer)
  PreferenceGroup("Network")
   WritePreferenceString("Server_AdminPassword",Config\Server_AdminPassword)
   WritePreferenceString("Server_UserPassword",Config\Server_UserPassword)
   WritePreferenceLong("WebPort",Config\Server_Port)
  PreferenceGroup("IMGEditor")
   WritePreferenceString("ArchiveFile",Config\IMGEditor_ArchiveFile)
  PreferenceGroup("FileTypes")
   For Item=0 To CountGadgetItems(#Gadget_Config_FileTypesList)-1
    WritePreferenceString(GetGadgetItemText(#Gadget_Config_FileTypesList,Item,0),GetGadgetItemText(#Gadget_Config_FileTypesList,Item,1))
   Next
  PreferenceGroup("Tools")
   Count=CountGadgetItems(#Gadget_Tools_List)
   WritePreferenceLong("Count",Count)
   For Tool=1 To Count
    WritePreferenceString("Name "+Str(Tool),Trim(GetGadgetItemText(#Gadget_Tools_List,Tool-1,0)))
    WritePreferenceString("File "+Str(Tool),Trim(GetGadgetItemText(#Gadget_Tools_List,Tool-1,1)))
    WritePreferenceString("Parameter "+Str(Tool),Trim(GetGadgetItemText(#Gadget_Tools_List,Tool-1,2)))
    WritePreferenceLong("Type "+Str(Tool),GetGadgetItemData(#Gadget_Tools_List,Tool-1))
   Next
  PreferenceGroup("CheatProcessorKeys")
   WritePreferenceLong("SpawnVehicleEx",Config\CheatProcessorKey\SpawnVehicleEx)
   WritePreferenceLong("ScrollVehicleUp",Config\CheatProcessorKey\ScrollVehicleUp)
   WritePreferenceLong("ScrollVehicleDown",Config\CheatProcessorKey\ScrollVehicleDown)
  ClosePreferences()
 EndIf
 File=CreateFile(#PB_Any,Config\WindowFile)
  If IsFile(File)
   WriteData(File,Windows,SizeOf(Windows))
   CloseFile(File)
  EndIf
 SetRegGTASAFile(Common\GTAFile)
 ReloadModuleConfig()
EndProcedure

Procedure SetConfig()
 ClearGadgetItems(#Gadget_Config_CheatProcessorList)
 Select Config\Language
  Case #LANG_ENGLISH
   Language=0
  Case #LANG_GERMAN
   Language=1
 EndSelect
 SetGadgetState(#Gadget_Config_RememberMDI,Config\RememberMDI)
 SetGadgetState(#Gadget_Config_MinimizeToTray,Config\MinimizeToTray)
 SetGadgetState(#Gadget_Config_StartMinimized,Config\StartMinimized)
 SetGadgetState(#Gadget_Config_DisplayMessages,Config\DisplayMessages)
 SetGadgetState(#Gadget_Config_QuitConfirm,Config\QuitConfirm)
 SetGadgetState(#Gadget_Config_UseTabs,Config\UseTabs)
 SetGadgetState(#Gadget_Config_DisableGTASplash,Config\DisableGTASplash)
 SetGadgetState(#Gadget_Config_CloseModulesOnQuit,Config\CloseModulesOnQuit)
 SetGadgetState(#Gadget_Config_AutoCheckUpdates,Config\AutoCheckUpdates)
 SetGadgetState(#Gadget_Config_AutoSaveData,Config\AutoSaveData)
 SetGadgetState(#Gadget_Config_UseCheatSound,Config\UseCheatSound)
 SetGadgetText(#Gadget_Config_CheatSound,Config\CheatSound)
 SetGadgetText(#Gadget_Config_GTAFile,Common\GTAFile)
 SetGadgetState(#Gadget_Config_Language,Language)
 SetGadgetText(#Gadget_Config_ServerPort,Str(Config\Server_Port))
 SetGadgetState(#Gadget_Config_StartupCheatProcessor,Config\Startup_CheatProcessor)
 SetGadgetState(#Gadget_Config_StartupMemoryServer,Config\Startup_MemoryServer)
 SetGadgetState(#Gadget_Config_StartupWebServer,Config\Startup_WebServer)
 SetGadgetState(#Gadget_Config_UseBackground,Config\UseBackground)
 SetGadgetText(#Gadget_Config_Background,Config\BackgroundFile)
 For Cheat=0 To CountString(Config\ActivateCheat,";")
  Cheat$=Trim(StringField(Config\ActivateCheat,Cheat+1,";"))
   If Cheat$
    AddGadgetItem(#Gadget_Config_CheatProcessorList,-1,Cheat$)
   EndIf
 Next
 For Gadget=#Gadget_Config_ImageTypeBMP To #Gadget_Config_ImageTypePNG
  SetGadgetState(Gadget,0)
 Next
 For Gadget=#Gadget_Config_MapType2D To #Gadget_Config_MapType3D
  SetGadgetState(Gadget,0)
 Next
 Select Config\ImageType
  Case #PB_ImagePlugin_BMP
   SetGadgetState(#Gadget_Config_ImageTypeBMP,1)
  Case #PB_ImagePlugin_JPEG
   SetGadgetState(#Gadget_Config_ImageTypeJPG,1)
  Case #PB_ImagePlugin_PNG
   SetGadgetState(#Gadget_Config_ImageTypePNG,1)
  Default
   SetGadgetState(#Gadget_Config_ImageTypeJPG,1)
 EndSelect
 Select Config\MapType
  Case 200
   SetGadgetState(#Gadget_Config_MapType2D,1)
  Case 300
   SetGadgetState(#Gadget_Config_MapType3D,1)
  Default
   SetGadgetState(#Gadget_Config_MapType2D,1)
 EndSelect
EndProcedure

Procedure LoadBackground()
 If Config\UseBackground
  If IsFileEx(Config\BackgroundFile)
   If LoadImage(#Image_MDIBackground,Config\BackgroundFile)
    SetMDIImage()
   Else
    Debug "ERROR"
   EndIf
  EndIf
 Else
  If IsImage(#Image_MDIBackground)
   FreeImage(#Image_MDIBackground)
  EndIf
  If IsImage(#Image_MDIBackground2)
   FreeImage(#Image_MDIBackground2)
  EndIf
  SetGadgetAttribute(#Gadget_Main_MDI,#PB_MDI_Image,0)
 EndIf
EndProcedure

Procedure AddFileType(Ext$,Name$)
 If Ext$
  Name$=Trim(ReadPreferenceString(Ext$,Name$))
   If Name$=""
    Name$=Ext$+"-"+Language(7)
   EndIf
  AddGadgetItem(#Gadget_Config_FileTypesList,-1,Ext$+Chr(10)+Name$)
 EndIf
EndProcedure

Procedure LoadSettings(ReloadLanguage=1)
 ClearGadgetItems(#Gadget_Tools_List)
 OpenPreferences(Common\PrefsFile)
  PreferenceGroup("Global")
   Config\RememberMDI=ReadPreferenceLong("RememberMDI",1)
   Config\MinimizeToTray=ReadPreferenceLong("MinimizeToTray",0)
   Config\StartMinimized=ReadPreferenceLong("StartMinimized",0)
   Config\DisplayMessages=ReadPreferenceLong("DisplayMessages",1)
   If ReloadLanguage
    Config\Language=ReadPreferenceLong("Language",0)
   EndIf
   Config\QuitConfirm=ReadPreferenceLong("QuitConfirm",1)
   Config\UseTabs=ReadPreferenceLong("UseTabs",1)
   Config\DisableGTASplash=ReadPreferenceLong("DisableGTASplash",0)
   Config\ActivateCheat=ReadPreferenceString("ActivateCheat","")
   Config\ImageType=ReadPreferenceLong("ImageType",#PB_ImagePlugin_JPEG)
   Config\MapType=ReadPreferenceLong("MapType",200)
   Config\SmartWindowRefresh=ReadPreferenceLong("SmartWindowRefresh",1)
   Config\IconSize=ReadPreferenceLong("IconSize",48)
   Config\CleoManager_ListDisplay=ReadPreferenceLong("CleoManager_ListDisplay",#PB_ListIcon_Report)
   Config\CloseModulesOnQuit=ReadPreferenceLong("CloseModulesOnQuit",1)
   Config\AutoCheckUpdates=ReadPreferenceLong("AutoCheckUpdates",1)
   Config\AutoSaveData=ReadPreferenceLong("AutoSaveData",0)
  PreferenceGroup("HigherProcessPriority")
   Config\HigherProcessPriority\CheatProcessor=ReadPreferenceLong("CheatProcessor",1)
   Config\HigherProcessPriority\GUI=ReadPreferenceLong("GUI",0)
   Config\HigherProcessPriority\MemoryServer=ReadPreferenceLong("MemoryServer",0)
   Config\HigherProcessPriority\WebServer=ReadPreferenceLong("WebServer",0)
  PreferenceGroup("IgnoreList")
   Config\IgnoreList_Vehicles=ReadPreferenceString("Vehicles","449;537;538;569;570;590")
   Config\IgnoreList_Cheats=ReadPreferenceString("Cheats","")
  PreferenceGroup("ID3Tag")
   Config\LoadID3Tag_Startup=ReadPreferenceLong("LoadID3Tag_Startup",0)
   Config\LoadID3tag_Refresh=ReadPreferenceLong("LoadID3Tag_Refresh",1)
  PreferenceGroup("TextZone")
   Config\TextZone\VehicleDamage\X=ReadPreferenceFloat("VehicleDamageX",10)
   Config\TextZone\VehicleDamage\Y=ReadPreferenceFloat("VehicleDamageY",50)
   Config\TextZone\VehicleDamage\Color=ReadPreferenceLong("VehicleDamageColor",4281537023)
   Config\TextZone\VehicleSpeed\X=ReadPreferenceFloat("VehicleSpeedX",10)
   Config\TextZone\VehicleSpeed\Y=ReadPreferenceFloat("VehicleSpeedY",10)
   Config\TextZone\VehicleSpeed\Color=ReadPreferenceLong("VehicleSpeedColor",4281537023)
   Config\TextZone\Timer\X=ReadPreferenceFloat("TimerX",10)
   Config\TextZone\Timer\Y=ReadPreferenceFloat("TimerY",130)
   Config\TextZone\Timer\Color=ReadPreferenceLong("TimerColor",4281537023)
   Config\TextZone\SpawnVehicle\X=ReadPreferenceFloat("SpawnVehicleX",10)
   Config\TextZone\SpawnVehicle\Y=ReadPreferenceFloat("SpawnVehicleY",90)
   Config\TextZone\SpawnVehicle\Color=ReadPreferenceLong("SpawnVehicleColor",4281537023)
  PreferenceGroup("CheatSound")
   Config\UseCheatSound=ReadPreferenceLong("UseCheatSound",1)
   Config\CheatSound=ReadPreferenceString("CheatSound",Common\InstallPath+"Cheat.wav")
  PreferenceGroup("Background")
   Config\UseBackground=ReadPreferenceLong("UseBackground",1)
   Config\BackgroundFile=ReadPreferenceString("BackgroundFile",Common\InstallPath+"Background.jpg")
  PreferenceGroup("Startup")
   Config\Startup_CheatProcessor=ReadPreferenceLong("CheatProcessor",0)
   Config\Startup_MemoryServer=ReadPreferenceLong("MemoryServer",0)
   Config\Startup_WebServer=ReadPreferenceLong("WebServer",0)
  PreferenceGroup("Network")
   Config\Server_AdminPassword=ReadPreferenceString("Server_AdminPassword",MD5Fingerprint(@"admin",5))
   Config\Server_UserPassword=ReadPreferenceString("Server_UserPassword",MD5Fingerprint(@"user",4))
   Config\Server_Port=ReadPreferenceLong("WebPort",80)
  PreferenceGroup("MemoryNetwork")
   Config\MemoryNetwork_Port=ReadPreferenceLong("Port",#MemoryNetwork_DefaultPort)
  PreferenceGroup("IMGEditor")
   Config\IMGEditor_ArchiveFile=ReadPreferenceString("ArchiveFile","gta3.img")
  PreferenceGroup("FileTypes")
   AddFileType("col","Collision")
   AddFileType("dat","Data")
   AddFileType("dff","Model")
   AddFileType("gxt","Text")
   AddFileType("ide","Item Definition")
   AddFileType("ifp","Animation")
   AddFileType("img","IMG Archive")
   AddFileType("ipl","Map")
   AddFileType("rrr","R3")
   AddFileType("scm","Mission Script")
   AddFileType("txd","Texture Archive")
   AddFileType("zon","Zone")
  PreferenceGroup("Tools")
   Count=ReadPreferenceLong("Count",0)
   For Tool=1 To Count
    Name$=Trim(ReadPreferenceString("Name "+Str(Tool),""))
    File$=Trim(ReadPreferenceString("File "+Str(Tool),""))
    Parameter$=Trim(ReadPreferenceString("Parameter "+Str(Tool),""))
    Type=ReadPreferenceLong("Type "+Str(Tool),#Tools_DefaultItem)
     If (Name$ And File$) Or Type=#Tools_Separator Or (Name$ And Type=#Tools_OpenSubMenu) Or Type=#Tools_CloseSubMenu
      AddGadgetItem(#Gadget_Tools_List,-1,Name$+Chr(10)+File$+Chr(10)+Parameter$,ExtractIcon_(0,File$,0))
      SetGadgetItemData(#Gadget_Tools_List,CountGadgetItems(#Gadget_Tools_List)-1,Type)
     EndIf
   Next
  PreferenceGroup("CheatProcessorKeys")
   Config\CheatProcessorKey\SpawnVehicleEx=ReadPreferenceLong("SpawnVehicleEx",#VK_CONTROL)
   Config\CheatProcessorKey\ScrollVehicleUp=ReadPreferenceLong("ScrollVehicleUp",#VK_NUMPAD9)
   Config\CheatProcessorKey\ScrollVehicleDown=ReadPreferenceLong("ScrollVehicleDown",#VK_NUMPAD3)
 ClosePreferences()
 SetConfig()
 File=ReadFile(#PB_Any,Config\WindowFile)
  If IsFile(File)
   ReadData(File,Windows,SizeOf(Windows))
   CloseFile(File)
  EndIf
 If Config\RememberMDI
  ResizeWindow(#Window_Main,Windows\Main\x,Windows\Main\y,Windows\Main\Width,Windows\Main\Height)
  ResizeWindow(#Window_MDI_Cheats,Windows\Cheats\x,Windows\Cheats\y,Windows\Cheats\Width,Windows\Cheats\Height)
  ResizeWindow(#Window_MDI_Teleporter,Windows\Teleporter\x,Windows\Teleporter\y,Windows\Teleporter\Width,Windows\Teleporter\Height)
  ResizeWindow(#Window_MDI_SavegameManager,Windows\SavegameManager\x,Windows\SavegameManager\y,Windows\SavegameManager\Width,Windows\SavegameManager\Height)
  ResizeWindow(#Window_MDI_Models,Windows\Models\x,Windows\Models\y,Windows\Models\Width,Windows\Models\Height)
  ResizeWindow(#Window_MDI_MemoryChanger,Windows\MemoryChanger\x,Windows\MemoryChanger\y,Windows\MemoryChanger\Width,Windows\MemoryChanger\Height)
  ResizeWindow(#Window_MDI_IMGEditor,Windows\IMGEditor\x,Windows\IMGEditor\y,Windows\IMGEditor\Width,Windows\IMGEditor\Height)
  ResizeWindow(#Window_MDI_CleoManager,Windows\CleoManager\x,Windows\CleoManager\y,Windows\CleoManager\Width,Windows\CleoManager\Height)
  ResizeWindow(#Window_MDI_IPLEditor,Windows\IPLEditor\x,Windows\IPLEditor\y,Windows\IPLEditor\Width,Windows\IPLEditor\Height)
  ResizeWindow(#Window_MDI_GameTweaks,Windows\GameTweaks\x,Windows\GameTweaks\y,Windows\GameTweaks\Width,Windows\GameTweaks\Height)
  ResizeWindow(#Window_MDI_Config,Windows\Config\x,Windows\Config\y,Windows\Config\Width,Windows\Config\Height)
  SetWindowState(#Window_MDI_Cheats,Windows\Cheats\State)
  SetWindowState(#Window_MDI_Teleporter,Windows\Teleporter\State)
  SetWindowState(#Window_MDI_SavegameManager,Windows\SavegameManager\State)
  SetWindowState(#Window_MDI_Models,Windows\Models\State)
  SetWindowState(#Window_MDI_MemoryChanger,Windows\MemoryChanger\State)
  SetWindowState(#Window_MDI_IMGEditor,Windows\IMGEditor\State)
  SetWindowState(#Window_MDI_CleoManager,Windows\CleoManager\State)
  SetWindowState(#Window_MDI_IPLEditor,Windows\IPLEditor\State)
  SetWindowState(#Window_MDI_GameTweaks,Windows\GameTweaks\State)
  SetWindowState(#Window_MDI_Config,Windows\Config\State)
  HideWindow(#Window_MDI_Cheats,ChangeVal(Windows\Cheats\Show))
  HideWindow(#Window_MDI_Teleporter,ChangeVal(Windows\Teleporter\Show))
  HideWindow(#Window_MDI_SavegameManager,ChangeVal(Windows\SavegameManager\Show))
  HideWindow(#Window_MDI_Models,ChangeVal(Windows\Models\Show))
  HideWindow(#Window_MDI_MemoryChanger,ChangeVal(Windows\MemoryChanger\Show))
  HideWindow(#Window_MDI_IMGEditor,ChangeVal(Windows\IMGEditor\Show))
  HideWindow(#Window_MDI_CleoManager,ChangeVal(Windows\CleoManager\Show))
  HideWindow(#Window_MDI_IPLEditor,ChangeVal(Windows\IPLEditor\Show))
  HideWindow(#Window_MDI_GameTweaks,ChangeVal(Windows\GameTweaks\Show))
  HideWindow(#Window_MDI_Config,ChangeVal(Windows\Config\Show))
 Else
  For Window=#Window_MDI_Cheats To #Window_MDI_Config
   SetWindowState(Window,#PB_Window_Normal)
   HideWindow(Window,1)
  Next
 EndIf
 If Config\UseTabs
  HideGadget(#Gadget_Main_Panel,0)
 Else
  HideGadget(#Gadget_Main_Panel,1)
 EndIf
 RefreshLanguage(ReloadLanguage)
 If IsGadget(#Gadget_Models_VehicleList)
  For Vehicle=0 To CountGadgetItems(#Gadget_Models_VehicleList)-1
   SetGadgetItemState(#Gadget_Models_VehicleList,Vehicle,#PB_ListIcon_Checked)
   For Block=0 To CountString(Config\IgnoreList_Vehicles,";")
    ID=Val(Trim(StringField(Config\IgnoreList_Vehicles,Block+1,";")))
     If ID=>400 And ID<=611
      *Vehicles.Vehicles
      *Vehicles=GetGadgetItemData(#Gadget_Models_VehicleList,Vehicle)
       If ID=*Vehicles\ID
        SetGadgetItemState(#Gadget_Models_VehicleList,Vehicle,0)
       EndIf
     EndIf
   Next
  Next
 EndIf
EndProcedure

Procedure AboutWindowCB(WindowID,Message,wParam,lParam)
 Select Message
  Case #WM_NOTIFY
   *el.ENLINK=lParam
    If *el\nmhdr\code=$70B
     If *el\msg=#WM_LBUTTONDOWN
      EditorLink.TEXTRANGE
      EditorLink\chrg\cpMin=*el\chrg\cpMin
      EditorLink\chrg\cpMax=*el\chrg\cpMax
      EditorLink\lpstrText=AllocateMemory(512)
       If EditorLink\lpstrText
        SendMessage_(GadgetID(#Gadget_About_Text),#EM_GETTEXTRANGE,0,EditorLink)
        Url$=Trim(PeekS(EditorLink\lpstrText))
        FreeMemory(EditorLink\lpstrText)
        If MessageRequester(Language(84),ReplaceString(Language(85),"%1",Url$,1),#MB_YESNO)=#PB_MessageRequester_Yes
         RunProgram(Url$)
        EndIf
       EndIf
     EndIf
    EndIf
 EndSelect
 ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure IPLEditor_Edit(ID)
 Value$=Trim(InputRequester(GetMenuItemText(#Menu_IPLEditor,#Menu_IPLEditor_EditID+ID),Language(180+ID),GetGadgetItemText(#Gadget_IPLEditor_List,GetGadgetState(#Gadget_IPLEditor_List),ID)))
  If Value$
   For Item=0 To CountGadgetItems(#Gadget_IPLEditor_List)-1
    If GetGadgetItemState(#Gadget_IPLEditor_List,Item)&#PB_ListIcon_Selected
     SetGadgetItemText(#Gadget_IPLEditor_List,Item,Value$,ID)
    EndIf
   Next
  EndIf
EndProcedure

Procedure ReloadMemoryChangerList()
 UpdateGTASAProcess()
 For Item=0 To CountGadgetItems(#Gadget_MemoryChanger_List)-1
  Value$=""
  Offset$=Trim(GetGadgetItemText(#Gadget_MemoryChanger_List,Item,1))
  DataType=GetGadgetItemData(#Gadget_MemoryChanger_List,Item)
   If Offset$
    Valid=IsAddressValid(Hex2Dec(Offset$))
    If Valid<>1 And GTASAWindowID()
     MessageRequester("Debugger - Invalid address!","Result: "+Str(Valid)+Chr(13)+"Offset: "+Offset$+Chr(13)+Chr(13)+"Please report to programmer (Programie) and tell, what you doing!"+Chr(13)+"The program will continue normaly.",#MB_ICONERROR)
    EndIf
    Select DataType
     Case #PB_Byte,#PB_Word,#PB_Character,#PB_Long
      Value$=Str(ReadProcessValue(Hex2Dec(Offset$),DataType))
     Case #PB_Float,#PB_Double,#PB_Quad
      Value$=StrF(ReadProcessFloat(Hex2Dec(Offset$)))
     Case #PB_String
      ;Value$=ReadProcessString(Hex2Dec(Offset$))
    EndSelect
   EndIf
  SetGadgetItemText(#Gadget_MemoryChanger_List,Item,Value$,3)
 Next
EndProcedure

Procedure SetModelsImage(Original,Resized)
 ResizeImageEx(Original,Resized,GadgetWidth(#Gadget_Models_ImageContainer),GadgetHeight(#Gadget_Models_ImageContainer))
 SetGadgetState(#Gadget_Models_Image,ImageID(Resized))
EndProcedure

Procedure DownloadUpdate(Url$,File$,FileSize)
 LFile$=ReplaceString(File$,"/","\",1)
 SetGadgetState(#Gadget_Updater_TotalStatus,GetGadgetState(#Gadget_Updater_TotalStatus)+1)
 SetGadgetText(#Gadget_Updater_File,LFile$)
 CreateDirectoryEx(GetPathPart(Common\InstallPath+LFile$))
 File=CreateFile(#PB_Any,Common\InstallPath+LFile$)
  If IsFile(File)
   CloseFile(File)
   LFile$=Common\InstallPath+LFile$
  Else
   LFile$=Common\InstallPath+"Update\"+LFile$
  EndIf
 ProcedureReturn DownloadFile(Url$+File$,LFile$,#Gadget_Updater_FileStatus,FileSize)
EndProcedure

Procedure Update(OnStartup)
 SetGadgetText(#Gadget_Updater_StatusText,Language(227))
 SetGadgetText(#Gadget_Updater_Close,Language(26))
 ForEach UpdateFile()
  File$=ReplaceString(UpdateFile()\File,"/","\",1)
  Result=-1
  For Item=0 To CountGadgetItems(#Gadget_Updater_FileList)-1
   If LCase(Trim(GetGadgetItemText(#Gadget_Updater_FileList,Item,0)))=LCase(Trim(File$))
    IsItem=Item
    Break
   EndIf
  Next
  If IsItem<>-1
   If GetGadgetItemState(#Gadget_Updater_FileList,IsItem)&#PB_ListIcon_Checked
    Download=1
   EndIf
  Else
   Download=1
  EndIf
  SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_FrontColor,$FFFFFF)
  SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_BackColor,$000000)
  If Download
   If IsFileEx(Common\InstallPath+File$)
    If LCase(UpdateFile()\MD5)<>LCase(MD5FileFingerprint(Common\InstallPath+File$))
     Result=DownloadUpdate(Config\Updater_Url,UpdateFile()\File,UpdateFile()\Size)
    EndIf
   Else
    Result=DownloadUpdate(Config\Updater_Url,UpdateFile()\File,UpdateFile()\Size)
   EndIf
  EndIf
  If IsItem<>-1
   Select Result
    Case -1
     SetGadgetItemText(#Gadget_Updater_FileList,IsItem,Language(232),2)
     SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_FrontColor,$000000)
     SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_BackColor,$00FFFF)
    Case 0
     SetGadgetItemText(#Gadget_Updater_FileList,IsItem,Language(19),2)
     SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_FrontColor,$000000)
     SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_BackColor,$0000FF)
    Case 1
     SetGadgetItemText(#Gadget_Updater_FileList,IsItem,"OK",2)
     SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_FrontColor,$000000)
     SetGadgetItemColor(#Gadget_Updater_FileList,IsItem,#PB_Gadget_BackColor,$00FF00)
   EndSelect
  EndIf
 Next
 SetGadgetText(#Gadget_Updater_StatusText,Language(120))
 SetGadgetText(#Gadget_Updater_Text1,"")
 SetGadgetText(#Gadget_Updater_Text2,"")
 SetGadgetText(#Gadget_Updater_Close,Language(64))
 If OnStartup
  MessageRequester("Information",ReplaceString(Language(237),"<br>",Chr(13),1),#MB_ICONINFORMATION)
  Config\Updater_Restart=1
 Else
  MessageRequester("Information",ReplaceString(Language(163),"<br>",Chr(13),1),#MB_ICONINFORMATION)
 EndIf
EndProcedure

Procedure Update_RefreshTotalSize()
 If ListSize(UpdateFile())
  ForEach UpdateFile()
   If GetGadgetItemState(#Gadget_Updater_FileList,ListIndex(UpdateFile()))&#PB_ListIcon_Checked
    Size+UpdateFile()\Size
   EndIf
  Next
  SetGadgetText(#Gadget_Updater_TotalSize,CalcSize(Size)+"/"+CalcSize(Config\Updater_TotalSize))
 Else
  SetGadgetText(#Gadget_Updater_TotalSize,"")
 EndIf
EndProcedure

Procedure CheckUpdates(OnStartup)
 If IsWindow(#Window_Main)
  DisableWindow(#Window_Main,1)
 EndIf
 ClearList(UpdateFile())
 Config\Updater_TotalSize=0
 DownloadFile("http://updates.selfcoders.com/gta_sa_toolbox.php",Common\InstallPath+"Update.tmp")
 File=ReadFile(#PB_Any,Common\InstallPath+"Update.tmp")
  If IsFile(File)
   Config\Updater_Url=Trim(StringField(ReadString(File),2,"="))
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>";"
      File$=Trim(StringField(String$,1,"|"))
      MD5$=Trim(StringField(String$,2,"|"))
      Size$=Trim(StringField(String$,3,"|"))
      ForceReplace$=Trim(StringField(String$,4,"|"))
      LFile$=Trim(ReplaceString(File$,"/","\",1))
      Type=-1
      Select GetFilePart(LCase(LFile$))
       Case "desktop.ini","thumbs.db"
       Default
        If IsFileEx(Common\InstallPath+LFile$)
         If LCase(MD5FileFingerprint(Common\InstallPath+LFile$))<>LCase(MD5$)
          Type=#UpdateType_Updated
          Updated+1
         EndIf
        Else
         Type=#UpdateType_New
         New+1
        EndIf
      EndSelect
      If Type<>-1
       AddElement(UpdateFile())
       UpdateFile()\File=ReplaceString(File$,"\","/",1)
       UpdateFile()\Type=Type
       UpdateFile()\MD5=MD5$
       UpdateFile()\Size=Val(Size$)
       UpdateFile()\ForceReplace=Val(ForceReplace$)
       Config\Updater_TotalSize+Val(Size$)
      EndIf
     EndIf
   Until Eof(File)
   CloseFile(File)
   DeleteFile(Common\InstallPath+"Update.tmp")
   If New Or Updated
    If IsWindow(#Window_Main)
     WindowID=WindowID(#Window_Main)
     SetForegroundWindow_(WindowID)
    EndIf
    If OpenWindow(#Window_Updater,100,100,500,240,"Updater",#PB_Window_WindowCentered,WindowID)
     TextGadget(#Gadget_Updater_StatusText,10,10,WindowWidth(#Window_Updater)-20,20,Language(80))
     TextGadget(#Gadget_Updater_Text1,10,40,100,20,"")
     StringGadget(#Gadget_Updater_File,120,40,WindowWidth(#Window_Updater)-130,20,"",#PB_String_BorderLess|#PB_String_ReadOnly)
     TextGadget(#Gadget_Updater_Text2,10,70,100,20,Language(161)+":")
     StringGadget(#Gadget_Updater_TotalSize,120,70,WindowWidth(#Window_Updater)-130,20,"",#PB_String_BorderLess|#PB_String_ReadOnly)
     ProgressBarGadget(#Gadget_Updater_FileStatus,10,120,WindowWidth(#Window_Updater)-20,30,0,0,#PB_ProgressBar_Smooth)
     ProgressBarGadget(#Gadget_Updater_TotalStatus,10,160,WindowWidth(#Window_Updater)-20,30,0,New+Updated,#PB_ProgressBar_Smooth)
     ButtonGadget(#Gadget_Updater_Start,10,WindowHeight(#Window_Updater)-40,WindowWidth(#Window_Updater)/3-40/3,30,"Start")
     ButtonGadget(#Gadget_Updater_ShowFileList,GadgetWidth(#Gadget_Updater_Start)+20,GadgetY(#Gadget_Updater_Start),GadgetWidth(#Gadget_Updater_Start),30,Language(162),#PB_Button_Toggle)
     ButtonGadget(#Gadget_Updater_Close,GadgetWidth(#Gadget_Updater_Start)*2+30,GadgetY(#Gadget_Updater_Start),GadgetWidth(#Gadget_Updater_Start),30,Language(64))
     ListIconGadget(#Gadget_Updater_FileList,10,WindowHeight(#Window_Updater),WindowWidth(#Window_Updater)-20,200,Language(7),200,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#PB_ListIcon_CheckBoxes)
      AddGadgetColumn(#Gadget_Updater_FileList,1,Language(98),150)
      AddGadgetColumn(#Gadget_Updater_FileList,2,Language(99),100)
     HideGadget(#Gadget_Updater_FileList,1)
     ForEach UpdateFile()
      Select UpdateFile()\Type
       Case #UpdateType_Updated
        UpdateType$=Language(174)
       Case #UpdateType_New
        UpdateType$=Language(175)
       Default
        UpdateType$="N/A"
      EndSelect
      File$=ReplaceString(UpdateFile()\File,"/","\",1)
      Download=0
      AddGadgetItem(#Gadget_Updater_FileList,-1,File$+Chr(10)+CalcSize(UpdateFile()\Size)+Chr(10)+UpdateType$)
      If IsFileEx(Common\InstallPath+File$)
       If LCase(MD5FileFingerprint(Common\InstallPath+File$))<>LCase(UpdateFile()\MD5) And UpdateFile()\ForceReplace
        Download=1
       EndIf
      Else
       Download=1
      EndIf
      If Download
       SetGadgetItemState(#Gadget_Updater_FileList,CountGadgetItems(#Gadget_Updater_FileList)-1,#PB_ListIcon_Checked)
      EndIf
     Next
     Update_RefreshTotalSize()
     Stop=0
     IsStarted=0
     Repeat
      Select WaitWindowEvent(5)
       Case #PB_Event_Gadget
        Select EventGadget()
         Case #Gadget_Updater_Start
          SetGadgetText(#Gadget_Updater_Text1,Language(7)+":")
          ClearList(Update_ListRedo())
          For Item=0 To CountGadgetItems(#Gadget_Updater_FileList)-1
           If GetGadgetItemState(#Gadget_Updater_FileList,Item)&#PB_ListIcon_Checked
            State=1
           Else
            State=0
           EndIf
           AddElement(Update_ListRedo())
           Update_ListRedo()=State
          Next
          Thread=CreateThread(@Update(),OnStartup)
          DisableGadget(#Gadget_Updater_Start,1)
          IsStarted=1
         Case #Gadget_Updater_ShowFileList
          Select GetGadgetState(#Gadget_Updater_ShowFileList)
           Case 0
            HideGadget(#Gadget_Updater_FileList,1)
            ResizeWindow(#Window_Updater,#PB_Ignore,#PB_Ignore,#PB_Ignore,GadgetY(#Gadget_Updater_Start)+GadgetHeight(#Gadget_Updater_Start)+10)
           Case 1
            HideGadget(#Gadget_Updater_FileList,0)
            ResizeWindow(#Window_Updater,#PB_Ignore,#PB_Ignore,#PB_Ignore,GadgetY(#Gadget_Updater_Start)+GadgetHeight(#Gadget_Updater_Start)+GadgetHeight(#Gadget_Updater_FileList)+20)
          EndSelect
         Case #Gadget_Updater_Close
          If IsThread(Thread)
           If MessageRequester(Language(164),Language(165),#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
            Stop=1
           EndIf
          Else
           Stop=1
          EndIf
         Case #Gadget_Updater_FileList
          If IsThread(Thread)
           ForEach Update_ListRedo()
            If Update_ListRedo()
             SetGadgetItemState(#Gadget_Updater_FileList,ListIndex(Update_ListRedo()),#PB_ListIcon_Checked)
            EndIf
           Next
          Else
           Update_RefreshTotalSize()
          EndIf
        EndSelect
      EndSelect
     Until Stop Or (IsThread(Thread)=0 And IsStarted)
     If IsThread(Thread)
      KillThread(Thread)
     EndIf
     CloseWindow(#Window_Updater)
    EndIf
   Else
    If OnStartup=0
     MessageRequester("Information",Language(81),#MB_ICONINFORMATION)
    EndIf
   EndIf
  Else
   If OnStartup=0
    MessageRequester(Language(19),Language(82),#MB_ICONERROR)
   EndIf
  EndIf
 If IsWindow(#Window_Main)
  DisableWindow(#Window_Main,0)
 EndIf
EndProcedure

Procedure Image404(Image,Width,Height)
 If Image=#PB_Any
  Image=CreateImage(#PB_Any,Width,Height)
  Mode=1
 Else
  CreateImage(Image,Width,Height)
  Mode=2
 EndIf
 Text$=Language(75)
 If IsImage(Image)
  If StartDrawing(ImageOutput(Image))
   DrawingFont(FontID(#Font_404Image))
    DrawText(Width/2-TextWidth(Text$)/2,Height/2-TextHeight(Text$)/2,Text$,$FF,0)
   StopDrawing()
  EndIf
  Select Mode
   Case 1
    ProcedureReturn Image
   Case 2
    ProcedureReturn ImageID(Image)
  EndSelect
 EndIf
EndProcedure

Procedure LoadImageEx(Image,FileName$,Width=0,Height=0,ShowError=0)
 If IsImage(Image)
  FreeImage(Image)
 EndIf
 If IsFileEx(FileName$)
  If Image=#PB_Any
   Image=LoadImage(#PB_Any,FileName$)
   Mode=1
  Else
   LoadImage(Image,FileName$)
   Mode=2
  EndIf
 Else
  If Image=#PB_Any
   Mode=1
  Else
   Mode=2
  EndIf
 EndIf
 If IsImage(Image)=0
  If ShowError
   Image404(Image,Width,Height)
  EndIf
 EndIf
 If IsImage(Image)
  If Width And Height
   ResizeImage(Image,Width,Height)
  EndIf
  Select Mode
   Case 1
    ProcedureReturn Image
   Case 2
    ProcedureReturn ImageID(Image)
  EndSelect
 EndIf
EndProcedure

Procedure RunGTA(File$="")
 If File$=""
  File$=Common\GTAFile
 EndIf
 If IsFileEx(File$)
  If UpdateGTASAProcess()
   If MessageRequester(Language(19),ReplaceString(Language(141),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONERROR)=#PB_MessageRequester_Yes
    ShowWindow_(GTASAWindowID(),#SW_SHOW)
    ShowWindow_(GTASAWindowID(),#SW_SHOWNORMAL)
    SetForegroundWindow_(GTASAWindowID())
   EndIf
  Else
   RunProgram(File$,"",GetPathPart(File$))
   If Config\DisableGTASplash
    DisableGTASplash()
   EndIf
  EndIf
 Else
  MessageRequester(Language(19),ReplaceString(Language(20),"%1",GetFilePart(File$),1),#MB_ICONERROR)
 EndIf
 ProcedureReturn GTASAWindowID()
EndProcedure

Procedure EditCheatWindow(Item)
 If Item=-1
  Title$=Language(1)
  Cheat$="CHEAT"
  Description$=Language(4)
 Else
  Title$=Language(12)
  Cheat$=GetGadgetItemText(#Gadget_Cheats_List,Item,0)
  Description$=GetGadgetItemText(#Gadget_Cheats_List,Item,1)
  Sound$=GetGadgetItemText(#Gadget_Cheats_List,Item,3)
 EndIf
 If OpenWindow(#Window_AddCheat,100,100,440,170,Title$,#PB_Window_WindowCentered,WindowID(#Window_MDI_Cheats))
  TextGadget(#Gadget_AddCheat_Text1,10,10,100,20,"Cheat:")
  TextGadget(#Gadget_AddCheat_Text2,10,40,100,20,Language(4)+":")
  TextGadget(#Gadget_AddCheat_Text3,10,70,100,20,Language(5)+":")
  TextGadget(#Gadget_AddCheat_Text4,10,100,100,20,"Sound:")
  StringGadget(#Gadget_AddCheat_Cheat,120,10,200,20,UCase(Cheat$),#PB_String_UpperCase)
  StringGadget(#Gadget_AddCheat_Description,120,40,200,20,Description$)
  CheckBoxGadget(#Gadget_AddCheat_HotkeyCtrl,120,70,50,20,Language(54))
  CheckBoxGadget(#Gadget_AddCheat_HotkeyShift,170,70,70,20,Language(55))
  CheckBoxGadget(#Gadget_AddCheat_HotkeyAlt,240,70,50,20,"Alt")
  ComboBoxGadget(#Gadget_AddCheat_Hotkey,290,70,100,20)
  StringGadget(#Gadget_AddCheat_Sound,120,100,200,20,Sound$,#PB_String_ReadOnly)
  ButtonGadget(#Gadget_AddCheat_CheatSelect,330,10,100,20,Language(31),#PB_Button_Toggle)
  ButtonGadget(#Gadget_AddCheat_SoundSelect,330,100,100,20,Language(25))
  ButtonGadget(#Gadget_AddCheat_OK,10,130,WindowWidth(#Window_AddCheat)/2-15,30,"OK")
  ButtonGadget(#Gadget_AddCheat_Cancel,GadgetWidth(#Gadget_AddCheat_OK)+20,130,GadgetWidth(#Gadget_AddCheat_OK),30,Language(26))
  ContainerGadget(#Gadget_AddCheat_CheatSelectBox,WindowWidth(#Window_AddCheat),10,400,WindowHeight(#Window_AddCheat)-20,#PB_Container_Flat)
  HideGadget(#Gadget_AddCheat_CheatSelectBox,1)
  DisableWindow(#Window_Main,1)
  AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,Language(32))
  For Chr=#VK_A To #VK_Z
   AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,Chr(Chr))
  Next
  For Chr=#VK_0 To #VK_9
   AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,Chr(Chr))
  Next
  For Chr=#VK_NUMPAD0 To #VK_NUMPAD9
   AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,"Num "+Str(Chr-#VK_NUMPAD0))
  Next
  For Chr=#VK_F1 To #VK_F12
   AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,"F"+Str(Chr-#VK_F1+1))
  Next
  AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,Language(49))
  AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,Language(51))
  AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,Language(52))
  AddGadgetItem(#Gadget_AddCheat_Hotkey,-1,Language(53))
  If Item<>-1
   HotkeyData=GetGadgetItemData(#Gadget_Cheats_List,Item)
   If HotkeyData
    *Hotkey.Hotkey
    *Hotkey=HotkeyData
    UseCtrl=*Hotkey\Ctrl
    UseShift=*Hotkey\Shift
    UseAlt=*Hotkey\Alt
    Hotkey=Key(*Hotkey\Hotkey)
   EndIf
  EndIf
  SetGadgetState(#Gadget_AddCheat_HotkeyCtrl,UseCtrl)
  SetGadgetState(#Gadget_AddCheat_HotkeyShift,UseShift)
  SetGadgetState(#Gadget_AddCheat_HotkeyAlt,UseAlt)
  SetGadgetState(#Gadget_AddCheat_Hotkey,Hotkey)
  SetGadgetData(#Gadget_AddCheat_Cheat,Item)
 EndIf
EndProcedure

Procedure SendCheatEx(WindowID,Cheat$)
 Title$=Space(#MAX_PATH)
 GetWindowText_(WindowID,@Title$,#MAX_PATH)
 If LCase(Left(Title$,Len(#CheatTransferWindow)))=LCase(#CheatTransferWindow)
  SetWindowText_(WindowID,#CheatTransferWindow+UCase(Cheat$))
  ProcedureReturn 0
 Else
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure SendCheat(Cheat$)
 If IsModuleRunning(#Module_CheatProcessor)=0
  RunProgram(Common\InstallPath+"CheatProcessor.exe","",Common\InstallPath)
  Delay(1000)
 EndIf
 EnumWindows_(@SendCheatEx(),Cheat$)
EndProcedure

Procedure Quit()
 If Config\QuitConfirm
  Config\Quit=MessageRequester("GTA San Andreas ToolBox GUI",ReplaceString(Language(34),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONQUESTION)
 Else
  Config\Quit=#PB_MessageRequester_Yes
 EndIf
EndProcedure

Procedure CreateArrowImage(Image,PointX)
 If CreateImage(Image,16,16)
  If StartDrawing(ImageOutput(Image))
   FrontColor(GetSysColor_(#COLOR_BTNFACE))
   Box(0,0,16,16)
   For PointY=6 To 10
    Line(PointX,PointY,13-PointX*2,0,0)
    PointX+1
   Next
   StopDrawing()
  EndIf
 EndIf
EndProcedure

Procedure CheckProtectedUpdates(Path$)
 Main$=Common\InstallPath+"Update\"
 Dir=ExamineDirectory(#PB_Any,Main$+Path$,"*.*")
  If IsDirectory(Dir)
   While NextDirectoryEntry(Dir)
    Name$=DirectoryEntryName(Dir)
     If Name$<>"." And Name$<>".."
      Select DirectoryEntryType(Dir)
       Case #PB_DirectoryEntry_File
        If CreateDirectoryEx(Common\InstallPath+Path$)
         If CopyFile(Main$+Path$+Name$,Common\InstallPath+Path$+Name$)
          DeleteFile(Main$+Path$+Name$)
         EndIf
        EndIf
       Case #PB_DirectoryEntry_Directory
        CheckProtectedUpdates(Path$+Name$+"\")
      EndSelect
     EndIf
   Wend
   FinishDirectory(Dir)
  EndIf
EndProcedure

Procedure IsParameter(String$)
 If FindString(LCase(Common\Parameter),LCase(String$),0)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure WindowCallback(WindowID,Message,wParam,lParam)
 *MM.MINMAXINFO
 Select Message
  Case #WM_QUERYENDSESSION
   Config\Quit=#PB_MessageRequester_Yes
  Case #WM_NOTIFY
   *Message.NMHDR=lParam
   Select *Message\Code
    Case #LVN_COLUMNCLICK
     Select *Message\hwndFrom
      Case GadgetID(#Gadget_Cheats_List)
       *Gadget.NM_LISTVIEW=lParam
       ClearList(CheatsSort())
       For Item=0 To CountGadgetItems(#Gadget_Cheats_List)-1
        AddElement(CheatsSort())
        CheatsSort()\Cheat=UCase(Trim(GetGadgetItemText(#Gadget_Cheats_List,Item,0)))
        CheatsSort()\Description=Trim(GetGadgetItemText(#Gadget_Cheats_List,Item,1))
        CheatsSort()\Shortcut=Trim(GetGadgetItemText(#Gadget_Cheats_List,Item,2))
        CheatsSort()\Sound=Trim(GetGadgetItemText(#Gadget_Cheats_List,Item,3))
        CheatsSort()\HotkeyData=GetGadgetItemData(#Gadget_Cheats_List,Item)
       Next
       *SortType.SortType=GetGadgetData(#Gadget_Cheats_List)
       Select *Gadget\iSubItem
        Case 0; Cheat
         Offset=OffsetOf(CheatsSort\Cheat)
        Case 1; Description
         Offset=OffsetOf(CheatsSort\Description)
        Case 2; Shortcut
         Offset=OffsetOf(CheatsSort\Shortcut)
        Case 3; Sound
         Offset=OffsetOf(CheatsSort\Sound)
       EndSelect
       If *SortType\Column=*Gadget\iSubItem
        If *SortType\Type=2
         Type=3
        Else
         Type=2
        EndIf
       Else
        Type=2
       EndIf
       *SortType\Column=*Gadget\iSubItem
       *SortType\Type=Type
       For Col=0 To 3
        ListIcon_SetHeaderImage(#Gadget_Cheats_List,Col,Config\Cheats_HeaderImage\Empty,4096)
       Next
       Select Type
        Case 2
         ListIcon_SetHeaderImage(#Gadget_Cheats_List,*SortType\Column,Config\Cheats_HeaderImage\ArrowUp,4096)
        Case 3
         ListIcon_SetHeaderImage(#Gadget_Cheats_List,*SortType\Column,Config\Cheats_HeaderImage\ArrowDown,4096)
       EndSelect
       SetGadgetData(#Gadget_Cheats_List,*SortType)
       SortStructuredList(CheatsSort(),Type,Offset,#PB_Sort_String)
       ClearGadgetItems(#Gadget_Cheats_List)
       ForEach CheatsSort()
        AddGadgetItem(#Gadget_Cheats_List,-1,CheatsSort()\Cheat+Chr(10)+CheatsSort()\Description+Chr(10)+CheatsSort()\Shortcut+Chr(10)+CheatsSort()\Sound)
        SetGadgetItemData(#Gadget_Cheats_List,CountGadgetItems(#Gadget_Cheats_List)-1,CheatsSort()\HotkeyData)
       Next
       ClearList(CheatsSort())
      Case GadgetID(#Gadget_Models_VehicleList)
       ClearList(VehiclesTemp())
       For Vehicle=0 To CountGadgetItems(#Gadget_Models_VehicleList)-1
        AddElement(VehiclesTemp())
        VehiclesTemp()\ID=Val(GetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,0))
        VehiclesTemp()\Name=Trim(GetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,1))
        VehiclesTemp()\Type=Trim(GetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,2))
        VehiclesTemp()\Radio=Trim(GetGadgetItemText(#Gadget_Models_VehicleList,Vehicle,3))
        VehiclesTemp()\DataStream=GetGadgetItemData(#Gadget_Models_VehicleList,Vehicle)
        VehiclesTemp()\Enabled=GetGadgetItemState(#Gadget_Models_VehicleList,Vehicle)
       Next
       *Gadget.NM_LISTVIEW=lParam
       Select *Gadget\iSubItem
        Case 0; VehicleID
         Offset=OffsetOf(VehiclesTemp\ID)
         SortType=#PB_Sort_Long
        Case 1; Name
         Offset=OffsetOf(VehiclesTemp\Name)
         SortType=#PB_Sort_String
        Case 2; Type
         Offset=OffsetOf(VehiclesTemp\Type)
         SortType=#PB_Sort_String
        Case 3; Radio
         Offset=OffsetOf(VehiclesTemp\Radio)
         SortType=#PB_Sort_String
       EndSelect
       SortStructuredList(VehiclesTemp(),0,Offset,SortType)
       ClearGadgetItems(#Gadget_Models_VehicleList)
       ForEach VehiclesTemp()
        AddGadgetItem(#Gadget_Models_VehicleList,-1,Str(VehiclesTemp()\ID)+Chr(10)+VehiclesTemp()\Name+Chr(10)+VehiclesTemp()\Type+Chr(10)+VehiclesTemp()\Radio)
        SetGadgetItemData(#Gadget_Models_VehicleList,ListIndex(VehiclesTemp()),VehiclesTemp()\DataStream)
        SetGadgetItemState(#Gadget_Models_VehicleList,ListIndex(VehiclesTemp()),VehiclesTemp()\Enabled)
       Next
      Case GadgetID(#Gadget_IMGEditor_List)
       DisableToolBarButton(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Open,1)
       DisableGadget(#Gadget_IMGEditor_List,1)
       *Gadget.NM_LISTVIEW=lParam
       *SortType.SortType=GetGadgetData(#Gadget_IMGEditor_List)
       Select *Gadget\iSubItem
        Case 0; Name
         Offset=OffsetOf(IMGFiles\Name)
         SortType=#PB_Sort_String
        Case 1; Offset
         Offset=OffsetOf(IMGFiles\Offset)
         SortType=#PB_Sort_Long
        Case 2; Size
         Offset=OffsetOf(IMGFiles\Size)
         SortType=#PB_Sort_Long
        Case 3; Type
         Offset=OffsetOf(IMGFiles\Type)
         SortType=#PB_Sort_String
       EndSelect
       If *SortType\Column=*Gadget\iSubItem
        If *SortType\Type=2
         Type=3
        Else
         Type=2
        EndIf
       Else
        Type=2
       EndIf
       *SortType\Column=*Gadget\iSubItem
       *SortType\Type=Type
       For Col=0 To 3
        ListIcon_SetHeaderImage(#Gadget_IMGEditor_List,Col,Config\IMGEditor_HeaderImage\Empty,4096)
       Next
       Select Type
        Case 2
         ListIcon_SetHeaderImage(#Gadget_IMGEditor_List,*SortType\Column,Config\IMGEditor_HeaderImage\ArrowUp,4096)
        Case 3
         ListIcon_SetHeaderImage(#Gadget_IMGEditor_List,*SortType\Column,Config\IMGEditor_HeaderImage\ArrowDown,4096)
       EndSelect
       SetGadgetData(#Gadget_IMGEditor_List,*SortType)
       SortStructuredList(IMGFiles(),Type,Offset,SortType)
       ClearGadgetItems(#Gadget_IMGEditor_List)
       SetGadgetAttribute(#Gadget_IMGEditor_Progress,#PB_ProgressBar_Maximum,ListSize(IMGFiles()))
       SetGadgetState(#Gadget_IMGEditor_Progress,0)
       ForEach IMGFiles()
        AddGadgetItem(#Gadget_IMGEditor_List,-1,IMGFiles()\Name+Chr(10)+RSet(Hex(IMGFiles()\Offset),8,"0")+Chr(10)+Str(IMGFiles()\Size)+" Bytes"+Chr(10)+IMGFiles()\Type)
        SetGadgetState(#Gadget_IMGEditor_Progress,GetGadgetState(#Gadget_IMGEditor_Progress)+1)
       Next
       DisableToolBarButton(#ToolBar_IMGEditor,#ToolBar_IMGEditor_Open,0)
       DisableGadget(#Gadget_IMGEditor_List,0)
     EndSelect
   EndSelect
  Case Common\ExplorerMsg
   If IsSysTrayIcon(#Tray)
    RemoveSysTrayIcon(#Tray)
   EndIf
   If AddSysTrayIcon(#Tray,WindowID(#Window_Main),ImageID(#Image_Tray))
    SysTrayIconToolTip(#Tray,"GTA San Andreas ToolBox")
   EndIf
 EndSelect
 ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure Help_NaviCB(Gadget,Url$)
 ForEach HelpPage()
  If HelpPage()\File=Right(Url$,Len(Url$)-Len(Config\HelpDir))
   SetGadgetState(#Gadget_Help_Files,ListIndex(HelpPage()))
   Valid=1
   Break
  EndIf
 Next
 If Valid
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure ReloadHelpFiles()
 Select Config\Language
  Case #LANG_ENGLISH
   Language$="English"
  Case #LANG_GERMAN
   Language$="German"
 EndSelect
 Config\HelpDir=Common\InstallPath+"Help\"+Language$+"\"
 ClearList(HelpPage())
 OpenPreferences(Config\HelpDir+"Structure.ini")
  If ExaminePreferenceGroups()
   While NextPreferenceGroup()
    AddElement(HelpPage())
    HelpPage()\File=PreferenceGroupName()
    HelpPage()\Name=ReadPreferenceString("Name","Untitled")
    HelpPage()\Level=ReadPreferenceLong("Level",0)
    HelpPage()\IsSubLevel=ReadPreferenceLong("IsSubLevel",0)
   Wend
  EndIf
 ClosePreferences()
 Item=GetGadgetState(#Gadget_Help_Files)
 ClearGadgetItems(#Gadget_Help_Files)
 ForEach HelpPage()
  If HelpPage()\IsSubLevel
   ImageID=ImageID(#Image_Help_SubLevel)
  Else
   ImageID=ImageID(#Image_Help_Item)
  EndIf
  AddGadgetItem(#Gadget_Help_Files,ListIndex(HelpPage()),HelpPage()\Name,ImageID,HelpPage()\Level)
 Next
 If Item=>0 And Item<=CountGadgetItems(#Gadget_Help_Files)-1
  SetGadgetState(#Gadget_Help_Files,Item)
 EndIf
EndProcedure

Procedure Help(Topic$)
 Select Config\Language
  Case #LANG_ENGLISH
   Language$="English"
  Case #LANG_GERMAN
   Language$="German"
 EndSelect
 Config\HelpDir=Common\InstallPath+"Help\"+Language$+"\"
 If Topic$=""
  Topic$="Introduction.htm"
 EndIf
 If IsFileEx(Config\HelpDir+"Structure.ini")
  If IsWindow(#Window_MDI_Help)
   SetWindowState(#Window_MDI_Help,#PB_Window_Normal)
   BringWindowToTop_(WindowID(#Window_MDI_Help))
   RefreshWindowMenu()
   ForEach HelpPage()
    If LCase(Topic$)=LCase(HelpPage()\File)
     SetGadgetState(#Gadget_Help_Files,ListIndex(HelpPage()))
     SetGadgetText(#Gadget_Help_Web,Config\HelpDir+HelpPage()\File)
     Config\HelpTopic=HelpPage()\File
     Break
    EndIf
   Next
  Else
   If OpenMDIWindow(#Gadget_Main_MDI,#Window_MDI_Help,500,300,"HelpViewer",#PB_Window_All,#Image_Help)
    If CreateToolBarEx(#ToolBar_Help,WindowID(#Window_MDI_Help))
     ToolBarImageButtonEx(#ToolBar_Help_Back,ImageID(#Image_Left))
     ToolBarImageButtonEx(#ToolBar_Help_Next,ImageID(#Image_Right))
      ToolBarSeparator()
     ToolBarImageButtonEx(#ToolBar_Help_Home,ImageID(#Image_Home))
    EndIf
    ContainerGadget(#Gadget_Help_Frame,0,ToolBarHeight(#ToolBar_Help),WindowWidth(#Window_MDI_Help),WindowHeight(#Window_MDI_Help)-ToolBarHeight(#ToolBar_Help),#PB_Container_Flat)
     TreeGadget(#Gadget_Help_Files,0,0,0,0,#PB_Tree_AlwaysShowSelection)
     WebGadget(#Gadget_Help_Web,0,0,0,0,Config\HelpDir+Topic$)
     SplitterGadget(#Gadget_Help_Splitter,0,0,GadgetWidth(#Gadget_Help_Frame),GadgetHeight(#Gadget_Help_Frame),#Gadget_Help_Files,#Gadget_Help_Web,#PB_Splitter_Vertical|#PB_Splitter_Separator)
    CloseGadgetList()
    Config\HelpTopic=Topic$
    ReloadHelpFiles()
    SetGadgetAttribute(#Gadget_Help_Web,#PB_Web_NavigationCallback,@Help_NaviCB())
   EndIf
  EndIf
 Else
  MessageRequester(Language(19),Language(226),#MB_ICONERROR)
  ForEach MDIWindow()
   If MDIWindow()=#Window_MDI_Help
    CloseWindow(#Window_MDI_Help)
    DeleteElement(MDIWindow())
    Break
   EndIf
  Next
 EndIf
EndProcedure

Procedure LoadMap()
 If IsImage(#Image_GTAMap)
  FreeImage(#Image_GTAMap)
 EndIf
 Select Config\MapType
  Case 200
   File$="Map2D.jpg"
  Case 300
   File$="Map3D.jpg"
  Default
   File$="Map2D.jpg"
   Config\MapType=200
 EndSelect
 If IsFileEx(Common\InstallPath+File$)
  If LoadImage(#Image_GTAMap,Common\InstallPath+File$)
   ResizeImage(#Image_GTAMap,600,600)
  EndIf
 EndIf
 If IsImage(#Image_GTAMap)=0
  Image404(#Image_GTAMap,600,600)
 EndIf
 If IsGadget(#Gadget_TeleportMap_Image)
  TeleportMap_SetPoint()
 EndIf
EndProcedure

Procedure Init()
 If IsFileEx(Config\WindowFile)=0
  DefaultWindowSettings()
 EndIf
 LoadFont(#Font_404Image,"Arial",22)
 LoadFont(#Font_Default,"Arial",8)
 LoadFont(#Font_Bold,"Arial Black",12)
 LoadFont(#Font_Printer,"Arial",70)
 For Chr=#VK_A To #VK_Z
  ID+1
  Key(Chr)=ID
 Next
 For Chr=#VK_0 To #VK_9
  ID+1
  Key(Chr)=ID
 Next
 For Chr=#VK_NUMPAD0 To #VK_NUMPAD9
  ID+1
  Key(Chr)=ID
 Next
 For Chr=#VK_F1 To #VK_F12
  ID+1
  Key(Chr)=ID
 Next
 ID+1
 Key(#VK_DELETE)=ID
 ID+1
 Key(#VK_INSERT)=ID
 ID+1
 Key(#VK_PAUSE)=ID
 ID+1
 Key(#VK_PRINT)=ID
 CreateArrowImage(#Image_ArrowUp,7)
 CreateArrowImage(#Image_ArrowDown,2)
 LoadLanguage()
 CheckProtectedUpdates("")
 DeleteEmptyDirs(Common\InstallPath+"Update\")
 If IsDirectoryEmpty(Common\InstallPath+"Update\")
  DeleteDirectory(Common\InstallPath+"Update\","*.*")
 EndIf
 OpenPreferences(Common\InstallPath+"Interiors.ini")
  For InteriorID=0 To 18
   Interior(InteriorID)=ReadPreferenceString(Str(InteriorID),"Interior "+Str(InteriorID))
  Next
 ClosePreferences()
EndProcedure

Procedure SavegameEditor_UpdateClock()
 Date=GetGadgetState(#Gadget_SavegameManager_Editor_Clock)
  If Date=0
   Date=1440
  ElseIf Date=1441
   Date=1
  EndIf
 SetGadgetState(#Gadget_SavegameManager_Editor_Clock,Date)
 If Date=1440
  Date=0
 EndIf
 SetGadgetText(#Gadget_SavegameManager_Editor_Clock,FormatDate("%ii:%ss",Date))
EndProcedure

Procedure SavegameEditor(State)
 If State
  Item=GetGadgetState(#Gadget_SavegameManager_List)
   If Item<>-1
    For Button=#ToolBar_SavegameManager_CreateBackup To #ToolBar_SavegameManager_Refresh
     DisableToolBarButton(#ToolBar_SavegameManager,Button,1)
    Next
    HideGadget(#Gadget_SavegameManager_List,1)
    HideGadget(#Gadget_SavegameManager_EditArea,0)
    DisableToolBarButton(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Save,0)
    SetToolBarButtonState(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Edit,1)
    File=ReadFile(#PB_Any,Config\GTAUserFiles+GetGadgetItemText(#Gadget_SavegameManager_List,Item,0))
     If IsFile(File)
      Savegame_SelectBlock(File,0)
      Block0=Loc(File)
      FileSeek(File,Block0+4)
      SetGadgetText(#Gadget_SavegameManager_Editor_Name,Trim(ReadStringEx(File,100,0)))
      FileSeek(File,Block0+$86)
      Hour=ReadByte(File)
      Minute=ReadByte(File)
      SetGadgetState(#Gadget_SavegameManager_Editor_Clock,Hour*60+Minute)
      Savegame_SelectBlock(File,15)
      Block15=Loc(File)
      FileSeek(File,Block15+4)
      SetGadgetText(#Gadget_SavegameManager_Editor_Money,Str(ReadLong(File)))
      FileSeek(File,Block15+$23)
      SetGadgetText(#Gadget_SavegameManager_Editor_MaxHealth,Str(ReadByte(File)&$FF))
      SetGadgetText(#Gadget_SavegameManager_Editor_MaxArmor,Str(ReadByte(File)&$FF))
      CloseFile(File)
      SavegameEditor_UpdateClock()
     EndIf
   Else
    SetToolBarButtonState(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Edit,0)
    MessageRequester(Language(19),Language(56),#MB_ICONERROR)
   EndIf
 Else
  If MessageRequester(Language(240),ReplaceString(Language(241),"<br>",Chr(13),1),#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
   For Button=#ToolBar_SavegameManager_CreateBackup To #ToolBar_SavegameManager_Refresh
    DisableToolBarButton(#ToolBar_SavegameManager,Button,0)
   Next
   HideGadget(#Gadget_SavegameManager_List,0)
   HideGadget(#Gadget_SavegameManager_EditArea,1)
   DisableToolBarButton(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Save,1)
   SetToolBarButtonState(#ToolBar_SavegameManager,#ToolBar_SavegameManager_Edit,0)
  EndIf
 EndIf
EndProcedure

Procedure ReloadCleoList()
 Path$=GetPathPart(Common\GTAFile)+"CLEO\"
EndProcedure

Procedure LoadGadgetData(Null)
 UpdateVehicleList()
 ReloadCleoList()
 File=ReadFile(#PB_Any,Common\InstallPath+"Weapons.cfg")
  If IsFile(File)
   Repeat
    String$=Trim(ReadString(File))
     If String$ And Left(String$,1)<>";"
      If Val(Trim(StringField(String$,1,"|"))) And Trim(StringField(String$,2,"|"))
       AddGadgetItem(#Gadget_Models_WeaponList,-1,ReplaceString(String$,"|",Chr(10),1))
      EndIf
     EndIf
   Until Eof(File)
   CloseFile(File)
  EndIf
 For DataType=#PB_Byte To #PB_Character
  Name$=DataType(DataType,1)
  Size=Val(DataType(DataType,2))
  If Size
   Name$+" ("+Str(Size)+" Byte)"
  EndIf
  AddGadgetItem(#Gadget_MemoryChanger_DataType,-1,Name$)
 Next
 File=ReadFile(#PB_Any,Common\InstallPath+"MemoryChanger.dat")
  If IsFile(File)
   Repeat
    Name$=Trim(ReadString(File))
    Address=ReadLong(File)
    DataType=ReadByte(File)
    AddGadgetItem(#Gadget_MemoryChanger_List,-1,Name$+Chr(10)+Hex(Address)+Chr(10)+DataType(DataType,1))
    SetGadgetItemData(#Gadget_MemoryChanger_List,CountGadgetItems(#Gadget_MemoryChanger_List)-1,DataType)
   Until Eof(File)
   CloseFile(File)
  EndIf
 If Common\GTAFile
  If IsFileEx(Common\GTAFile)
   File=ReadFile(#PB_Any,GetPathPart(Common\GTAFile)+"data\gta.dat")
    If IsFile(File)
     Scene=0
     Repeat
      String$=Trim(ReadString(File))
       If String$ And Left(String$,1)<>"#"And UCase(StringField(String$,1," "))="IPL"
        AddGadgetItem(#Gadget_IPLEditor_Files,-1,Trim(Right(String$,Len(String$)-4)))
       EndIf
     Until Eof(File)
     CloseFile(File)
    EndIf
  EndIf
 EndIf
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
        Hotkey$=StringField(String$,3,"|")
        *Hotkey.Hotkey=AllocateMemory(SizeOf(Hotkey))
        If Hotkey$
         For KeyIndex=0 To CountString(Hotkey$,"+")
          Key=Val(StringField(Hotkey$,KeyIndex+1,"+"))
           Select Key
            Case #VK_CONTROL
             *Hotkey\Ctrl=1
            Case #VK_SHIFT
             *Hotkey\Shift=1
            Case #VK_MENU
             *Hotkey\Alt=1
            Case #VK_DELETE
             *Hotkey\Hotkey=#VK_DELETE
            Case #VK_INSERT
             *Hotkey\Hotkey=#VK_INSERT
            Case #VK_PAUSE
             *Hotkey\Hotkey=#VK_PAUSE
            Case #VK_PRINT,#VK_SNAPSHOT
             *Hotkey\Hotkey=#VK_PRINT
            Default
             For Chr=#VK_A To #VK_Z
              If Key=Chr
               *Hotkey\Hotkey=Chr
              EndIf
             Next
             For Chr=#VK_0 To #VK_9
              If Key=Chr
               *Hotkey\Hotkey=Chr
              EndIf
             Next
             For Chr=#VK_NUMPAD0 To #VK_NUMPAD9
              If Key=Chr
               *Hotkey\Hotkey=Chr
              EndIf
             Next
             For Chr=#VK_F1 To #VK_F12
              If Key=Chr
               *Hotkey\Hotkey=Chr
              EndIf
             Next
           EndSelect
         Next
        EndIf
        AddCheat(UCase(Trim(StringField(String$,1,"|"))),StringField(String$,2,"|"),StringField(String$,4,"|"),*Hotkey\Ctrl,*Hotkey\Shift,*Hotkey\Alt,Key(*Hotkey\Hotkey),-1)
       EndIf
     EndSelect
   Until Eof(File)
   CloseFile(File)
  EndIf
 Mode=0
 File=ReadFile(#PB_Any,Common\InstallPath+"Teleporter.clf")
  If IsFile(File)
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
        Cheat$=Trim(StringField(String$,2,"|"))
        Interior$=Trim(StringField(String$,3,"|"))
        x$=StringField(Pos$,1,";")
        y$=StringField(Pos$,2,";")
        z$=StringField(Pos$,3,";")
        If Interior$
         Interior=Val(Interior$)
          If Interior<0 Or Interior>18
           Interior=-1
          EndIf
        Else
         Interior=-1
        EndIf
        If Interior=-1
         Interior$=Language(170)
        Else
         Interior$=Interior(Interior)
        EndIf
        AddGadgetItem(#Gadget_Teleporter_List,-1,Cheat$+Chr(10)+x$+Chr(10)+y$+Chr(10)+z$+Chr(10)+Interior$)
        SetGadgetItemData(#Gadget_Teleporter_List,CountGadgetItems(#Gadget_Teleporter_List)-1,Interior)
       EndIf
     EndSelect
   Until Eof(File)
   CloseFile(File)
  EndIf
EndProcedure

Procedure SelfCodersAccount_Login()
 Username$=Trim(GetGadgetText(#Gadget_Login_Username))
 Password$=Trim(GetGadgetText(#Gadget_Login_Password))
 If Username$
  If Password$
   Password$=MD5Fingerprint(@Password$,Len(Password$))
  Else
   File=ReadFile(#PB_Any,Common\InstallPath+"LoginUsers.cfg")
    If IsFile(File)
     Repeat
      String$=Trim(StringField(ReadString(File),1,";"))
       If String$
        If LCase(Trim(StringField(String$,1,Chr(9))))=LCase(Username$)
         Password$=Trim(StringField(String$,2,Chr(9)))
        EndIf
       EndIf
     Until Eof(File)
     CloseFile(File)
    EndIf
  EndIf
  If Password$
   ClientID=OpenNetworkConnection("selfcoders.com",80)
    If ClientID
     POST$="Username="+Username$+"&Password="+Password$
     Header$="POST http://www.selfcoders.com/network/index.php HTTP/1.1"+Chr(13)+Chr(10)
     Header$+"Host: selfcoders.com"+Chr(13)+Chr(10)
     Header$+"Content-Type: application/x-www-form-urlencoded"+Chr(13)+Chr(10)
     Header$+"Content-Length: "+Str(Len(POST$))+Chr(13)+Chr(10)
     Header$+Chr(13)+Chr(10)
     Header$+POST$+Chr(13)+Chr(10)
     Header$+Chr(13)+Chr(10)
     SendNetworkData(ClientID,@Header$,Len(Header$))
     Repeat
      Timeout+1
      If NetworkClientEvent(ClientID)=#PB_NetworkEvent_Data
       LoginData$=Space(10000)
       ReceiveNetworkData(ClientID,@LoginData$,10000)
       Received=1
      EndIf
      Delay(1)
     Until Timeout=>10000 Or Received
     CloseNetworkConnection(ClientID)
     If Received
      LoginData$=RemoveString(LoginData$,Chr(10))
      For Line=1 To CountString(LoginData$,Chr(13))+1
       Line$=Trim(StringField(LoginData$,Line,Chr(13)))
       Start=FindString(Line$,"=",0)
        If Start
         Value$=Trim(Right(Line$,Len(Line$)-Start))
        Else
         Value$=""
        EndIf
       Select LCase(Trim(StringField(Line$,1,"=")))
        Case "status"
         Status=Val(Value$)
        Case "username"
         Username$=Value$
       EndSelect
      Next
     Else
      MessageRequester(Language(19),"Request timed out!"+Chr(13)+"Please try again later.",#MB_ICONERROR)
      Error=1
     EndIf
    Else
     MessageRequester(Language(19),"Can´t connect to SelfCoders-Network!"+Chr(13)+"Check your internet connection.",#MB_ICONERROR)
     Error=1
    EndIf
   If Error=0
    If Status=1
     Config\SelfCodersAccount\LoggedIn=1
    Else
     Config\SelfCodersAccount\LoggedIn=0
    EndIf
    Debug Status
    If Config\SelfCodersAccount\LoggedIn
     Config\SelfCodersAccount\Username=Username$
     Add=1
     File2=CreateFile(#PB_Any,Common\InstallPath+"LoginUsers.tmp")
      If IsFile(File2)
       File=ReadFile(#PB_Any,Common\InstallPath+"LoginUsers.cfg")
        If IsFile(File)
         Repeat
          String$=Trim(StringField(ReadString(File),1,";"))
           If String$
            If LCase(Trim(StringField(String$,1,Chr(9))))=LCase(Username$)
             If GetGadgetState(#Gadget_Login_SavePassword)
              SavePW$=Password$
             Else
              SavePW$=""
             EndIf
             Add=0
            Else
             SavePW$=Trim(StringField(String$,2,Chr(9)))
            EndIf
            WriteStringN(File2,Trim(StringField(String$,1,Chr(9)))+Chr(9)+SavePW$)
           EndIf
         Until Eof(File)
         CloseFile(File)
        EndIf
        If Add
         If GetGadgetState(#Gadget_Login_SavePassword)
          SavePW$=Password$
         Else
          SavePW$=""
         EndIf
         WriteStringN(File2,Username$+Chr(9)+SavePW$)
        EndIf
       CloseFile(File2)
       DeleteFile(Common\InstallPath+"LoginUsers.cfg")
       RenameFile(Common\InstallPath+"LoginUsers.tmp",Common\InstallPath+"LoginUsers.cfg")
      EndIf
     ReloadMenu()
     CloseWindow(#Window_Login)
     MessageRequester("Login","Login successful!"+Chr(13)+Chr(13)+"Welcome, "+Username$+"!",#MB_ICONINFORMATION)
     DisableWindow(#Window_Main,0)
    Else
     MessageRequester(Language(19),ReplaceString(Language(250),"<br>",Chr(13),1),#MB_ICONERROR)
    EndIf
   EndIf
  Else
   MessageRequester(Language(19),Language(234),#MB_ICONERROR)
  EndIf
 Else
  MessageRequester(Language(19),Language(234),#MB_ICONERROR)
 EndIf
EndProcedure

Procedure SpawnModel()
 Select GetGadgetState(#Gadget_Models_Panel)
  Case 0
   Vehicle=GetGadgetState(#Gadget_Models_VehicleList)
    If Vehicle<>-1
     *Vehicles.Vehicles
     *Vehicles=GetGadgetItemData(#Gadget_Models_VehicleList,Vehicle)
      If *Vehicles\ID=>400 And *Vehicles\ID<=611
       If GetGadgetItemState(#Gadget_Models_VehicleList,Vehicle)&#PB_ListIcon_Checked
        If UpdateGTASAProcess()
         WriteProcessValue($01301000,*Vehicles\ID,#PB_Word)
         MessageRequester("Information",ReplaceString(Language(13),"%1",Name$,1),#MB_ICONINFORMATION)
        Else
         MessageRequester(Language(19),Language(156),#MB_ICONERROR)
        EndIf
       Else
        MessageRequester(Language(19),ReplaceString(Language(60),"%1",Name$,1),#MB_ICONERROR)
       EndIf
      EndIf
    EndIf
  Case 1
   Item=GetGadgetState(#Gadget_Models_WeaponList)
    If Item<>-1
     ID=Val(GetGadgetItemText(#Gadget_Models_WeaponList,Item,0))
      If ID
       Weapon=Val(Trim(GetGadgetItemText(#Gadget_Models_WeaponList,Item,0)))
       Name$=Trim(GetGadgetItemText(#Gadget_Models_WeaponList,Item,1))
       ID=Val(Trim(GetGadgetItemText(#Gadget_Models_WeaponList,Item,2)))
       Slot=Val(Trim(GetGadgetItemText(#Gadget_Models_WeaponList,Item,3)))
       AmmoClip=Val(Trim(GetGadgetItemText(#Gadget_Models_WeaponList,Item,4)))
       TotalAmmo=Val(Trim(GetGadgetItemText(#Gadget_Models_WeaponList,Item,5)))
       If UpdateGTASAProcess()
        PED=ReadProcessValue($B6F3B8,#PB_Long)
         If PED
          Offset=PED+$5A0+Slot*28
          WriteProcessValue(Offset,Weapon,#PB_Long)
          WriteProcessValue(Offset+4,0,#PB_Long)
          WriteProcessValue(Offset+8,ReadProcessValue(Offset+8,#PB_Long)+AmmoClip,#PB_Long)
          WriteProcessValue(Offset+12,ReadProcessValue(Offset+12,#PB_Long)+TotalAmmo,#PB_Long)
          WriteProcessValue($1301004+Slot*4,ID,#PB_Long)
          MessageRequester("Information",ReplaceString(Language(14),"%1",Name$,1),#MB_ICONINFORMATION)
         EndIf
       Else
        MessageRequester(Language(19),Language(156),#MB_ICONERROR)
       EndIf
      EndIf
    EndIf
 EndSelect
EndProcedure

Procedure ChangeLog()
 File$=Common\InstallPath+"Changes.log"
 Select Config\Language
  Case #LANG_ENGLISH
   Language$="en"
  Case #LANG_GERMAN
   Language$="de"
 EndSelect
 DownloadFile("http://www.selfcoders.com/?page=downloads&download=gta_sa_toolbox&showonly=changelog&lang="+Language$,File$)
 If IsFileEx(File$)
  If IsWindow(#Window_MDI_ChangeLog)
   BringWindowToTop_(WindowID(#Window_MDI_ChangeLog))
  Else
   If OpenMDIWindow(#Gadget_Main_MDI,#Window_MDI_ChangeLog,500,300,"Change Log",#PB_Window_All,#Image_ChangeLog)
    EditorGadget(#Gadget_ChangeLog_Text,0,0,WindowWidth(#Window_MDI_ChangeLog),WindowHeight(#Window_MDI_ChangeLog),#PB_Editor_ReadOnly)
   EndIf
  EndIf
  If IsWindow(#Window_MDI_ChangeLog)
   ClearGadgetItems(#Gadget_ChangeLog_Text)
   File=ReadFile(#PB_Any,File$)
    If IsFile(File)
     Repeat
      Text$+RemoveString(RemoveString(ReadString(File),"[h]",1),"[/h]",1)
      If Eof(File)=0
       Text$+Chr(13)
      EndIf
     Until Eof(File)
     FileSeek(File,0)
     SetGadgetText(#Gadget_ChangeLog_Text,Text$)
     Repeat
      String$=ReadString(File)
      HeaderStart=FindString(LCase(String$),"[h]",0)
       If HeaderStart
        EditorStyle_TextData\HeaderStart\Line=Line
        EditorStyle_TextData\HeaderStart\Char=HeaderStart
       EndIf
      HeaderEnd=FindString(LCase(String$),"[/h]",0)
       If HeaderEnd
        EditorStyle_TextData\HeaderEnd\Line=Line
        EditorStyle_TextData\HeaderEnd\Char=HeaderEnd-3
       EndIf
      If HeaderStart And HeaderEnd
       EditorStyle_Select(#Gadget_ChangeLog_Text,EditorStyle_TextData\HeaderStart\Line,EditorStyle_TextData\HeaderStart\Char,EditorStyle_TextData\HeaderEnd\Line,EditorStyle_TextData\HeaderEnd\Char)
       EditorStyle_FontSize(#Gadget_ChangeLog_Text,18)
      EndIf
      Line+1
     Until Eof(File)
     CloseFile(File)
     EditorStyle_Select(#Gadget_ChangeLog_Text,0,0,0,0)
    EndIf
  EndIf
 Else
  MessageRequester(Language(19),Language(247),#MB_ICONERROR)
 EndIf
EndProcedure