IncludeFile "ResourceDll.pbi"

ProcedureDLL GetImage(Image)
 Select Image
  Case #Image_Splash
   Start=?Image_Splash
  Case #Image_Tray
   Start=?Image_Tray
  Case #Image_Add
   Start=?Image_Add
  Case #Image_Remove
   Start=?Image_Remove
  Case #Image_Refresh
   Start=?Image_Refresh
  Case #Image_Config
   Start=?Image_Config
  Case #Image_CreateBackup
   Start=?Image_CreateBackup
  Case #Image_RestoreBackup
   Start=?Image_RestoreBackup
  Case #Image_ShowMap
   Start=?Image_ShowMap
  Case #Image_Teleport
   Start=?Image_Teleport
  Case #Image_Cheats
   Start=?Image_Cheats
  Case #Image_Teleporter
   Start=?Image_Teleporter
  Case #Image_SavegameManager
   Start=?Image_SavegameManager
  Case #Image_Models
   Start=?Image_Models
  Case #Image_MemoryChanger
   Start=?Image_MemoryChanger
  Case #Image_IMGEditor
   Start=?Image_IMGEditor
  Case #Image_CleoManager
   Start=?Image_CleoManager
  Case #Image_IPLEditor
   Start=?Image_IPLEditor
  Case #Image_GameTweaks
   Start=?Image_GameTweaks
  Case #Image_ReportBug
   Start=?Image_ReportBug
  Case #Image_ChangeLog
   Start=?Image_ChangeLog
  Case #Image_About
   Start=?Image_About
  Case #Image_Display
   Start=?Image_Display
  Case #Image_Spawn
   Start=?Image_Spawn
  Case #Image_SelfCodersNetwork
   Start=?Image_SelfCodersNetwork
  Case #Image_Quit
   Start=?Image_Quit
  Case #Image_Help
   Start=?Image_Help
  Case #Image_Tools
   Start=?Image_Tools
  Case #Image_Left
   Start=?Image_Left
  Case #Image_Right
   Start=?Image_Right
  Case #Image_Up
   Start=?Image_Up
  Case #Image_Down
   Start=?Image_Down
  Case #Image_MenuBar
   Start=?Image_MenuBar
  Case #Image_OpenSubMenu
   Start=?Image_OpenSubMenu
  Case #Image_CloseSubMenu
   Start=?Image_CloseSubMenu
  Case #Image_Replace
   Start=?Image_Replace
  Case #Image_Insert
   Start=?Image_Insert
  Case #Image_Export
   Start=?Image_Export
  Case #Image_Print
   Start=?Image_Print
  Case #Image_Save
   Start=?Image_Save
  Case #Image_Open
   Start=?Image_Open
  Case #Image_Dir
   Start=?Image_Dir
  Case #Image_Comment
   Start=?Image_Comment
  Case #Image_Set
   Start=?Image_Set
  Case #Image_EditSavegame
   Start=?Image_EditSavegame
  Case #Image_Server
   Start=?Image_Server
  Case #Image_Home
   Start=?Image_Home
  Case #Image_Help_SubLevel
   Start=?Image_Help_SubLevel
  Case #Image_Help_Item
   Start=?Image_Help_Item
  Case #Image_AboutBanner
   Start=?Image_AboutBanner
  Case #Image_Empty
   Start=?Image_Empty
 EndSelect
 ProcedureReturn Start
 DataSection
  Image_Splash:
   IncludeBinary "Splash.png"
  Image_Tray:
   IncludeBinary "GTATB.ico"
  Image_Add:
   IncludeBinary "Add.ico"
  Image_Remove:
   IncludeBinary "Remove.ico"
  Image_Refresh:
   IncludeBinary "Refresh.ico"
  Image_Config:
   IncludeBinary "Config.ico"
  Image_CreateBackup:
   IncludeBinary "CreateBackup.ico"
  Image_RestoreBackup:
   IncludeBinary "RestoreBackup.ico"
  Image_ShowMap:
   IncludeBinary "ShowMap.ico"
  Image_Teleport:
   IncludeBinary "Teleport.ico"
  Image_Cheats:
   IncludeBinary "Cheats.ico"
  Image_Teleporter:
   IncludeBinary "Teleporter.ico"
  Image_SavegameManager:
   IncludeBinary "SavegameManager.ico"
  Image_Models:
   IncludeBinary "Models.ico"
  Image_MemoryChanger:
   IncludeBinary "MemoryChanger.ico"
  Image_IMGEditor:
   IncludeBinary "IMGEditor.ico"
  Image_CleoManager:
   IncludeBinary "CleoManager.ico"
  Image_IPLEditor:
   IncludeBinary "IPLEditor.ico"
  Image_GameTweaks:
   IncludeBinary "GameTweaks.ico"
  Image_ReportBug:
   IncludeBinary "ReportBug.ico"
  Image_ChangeLog:
   IncludeBinary "ChangeLog.ico"
  Image_About:
   IncludeBinary "About.ico"
  Image_Display:
   IncludeBinary "Display.ico"
  Image_Spawn:
   IncludeBinary "Spawn.ico"
  Image_SelfCodersNetwork:
   IncludeBinary "SelfCodersNetwork.ico"
  Image_Quit:
   IncludeBinary "Quit.ico"
  Image_Help:
   IncludeBinary "Help.ico"
  Image_Tools:
   IncludeBinary "Tools.ico"
  Image_Left:
   IncludeBinary "Left.ico"
  Image_Right:
   IncludeBinary "Right.ico"
  Image_Up:
   IncludeBinary "Up.ico"
  Image_Down:
   IncludeBinary "Down.ico"
  Image_MenuBar:
   IncludeBinary "MenuBar.ico"
  Image_OpenSubMenu:
   IncludeBinary "OpenSubMenu.ico"
  Image_CloseSubMenu:
   IncludeBinary "CloseSubMenu.ico"
  Image_Replace:
   IncludeBinary "Replace.ico"
  Image_Insert:
   IncludeBinary "Insert.ico"
  Image_Export:
   IncludeBinary "Export.ico"
  Image_Print:
   IncludeBinary "Print.ico"
  Image_Save:
   IncludeBinary "Save.ico"
  Image_Open:
   IncludeBinary "Open.ico"
  Image_Dir:
   IncludeBinary "Dir.ico"
  Image_Comment:
   IncludeBinary "Comment.ico"
  Image_Set:
   IncludeBinary "Set.ico"
  Image_Editsavegame:
   IncludeBinary "EditSavegame.ico"
  Image_Server:
   IncludeBinary "Server.ico"
  Image_Home:
   IncludeBinary "Home.ico"
  Image_Help_SubLevel:
   IncludeBinary "Help_SubLevel.ico"
  Image_Help_Item:
   IncludeBinary "Help_Item.ico"
  Image_AboutBanner:
   IncludeBinary "Banner.png"
  Image_Empty:
   Data.l $00010000,$10100001,$00010000,$05680008,$00160000,$00280000
   Data.l $00100000,$00200000,$00010000,$00000008,$01400000,$00000000
   Data.l $00000000,$00000000,$00000000,$EA000000,$454500FF,$00000045
   Data.l $CE000000,$C90000FF,$9D0000FF,$B40000FE,$FE9300FF,$FD1300FF
   Data.l $FFC700FF,$E50000FF,$FFEB00FF,$000000FF,$FFFF0000,$000000FF
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000
   Data.l $00000000,$02020000,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$02020202
   Data.l $02020202,$02020202,$02020202,$02020202,$02020202,$FFFF0202
   Data.l $FFFF0202,$FFFF0202,$FFFF0202,$FFFF0202,$FFFF0202,$FFFF0202
   Data.l $FFFF0202,$FFFF0202,$FFFF0202,$FFFF0202,$FFFF0202,$FFFF0202
   Data.b 2,2,-1,-1,2,2,-1,-1,2,2,-1,-1,2,2
 EndDataSection
EndProcedure