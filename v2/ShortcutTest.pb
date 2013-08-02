Enumeration
 #Window
 #Input
 #Font
EndEnumeration

IncludeFile "Common.pbi"

LoadFont(#Font,"Arial",15)

If IsModuleRunning(#Module_CheatProcessor)
 If OpenWindow(#Window,100,100,500,30,#Title_ShortcutTest,#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  StringGadget(#Input,0,0,WindowWidth(#Window),WindowHeight(#Window),"",#PB_String_UpperCase)
  SetGadgetFont(#Input,FontID(#Font))
  SetActiveGadget(#Input)
  Repeat
   Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
     Quit=1
   EndSelect
  Until Quit
 EndIf
Else
 MessageRequester("Error","The GTA San Andreas ToolBox CheatProcessor is not running!"+Chr(13)+"You need it for this Program."+Chr(13)+Chr(13)+"Run it and try again.",#MB_ICONERROR)
EndIf