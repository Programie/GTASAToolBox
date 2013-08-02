Enumeration
 #Window
 #Font1
 #Font2
 #Frame1
 #Text1
 #IconSize
 #SmartWindowRefresh
 #CreateStartmenu
 #InstallSplashMod
 #Frame2
 #Preview_IconSize
 #Save
 #Close
EndEnumeration

IncludeFile "Common.pbi"

Procedure IconPreview()
 Size=GetGadgetState(#IconSize)
 If CreateImage(#Preview_IconSize,Size,Size)
  If StartDrawing(ImageOutput(#Preview_iconSize))
   DrawImage(ImageID(#IconSize),0,0,Size,Size)
   StopDrawing()
  EndIf
  SetGadgetState(#Preview_IconSize,ImageID(#Preview_IconSize))
 EndIf
EndProcedure

LoadFont(#Font1,"Arial",10)
LoadFont(#Font2,"Arial Black",10)
CatchImage(#IconSize,?Icon)

If OpenWindow(#Window,100,100,800,600,"GTA San Andreas ToolBox Extras",#PB_Window_ScreenCentered)
 Frame3DGadget(#Frame1,10,10,WindowWidth(#Window)/2,WindowHeight(#Window)-60,"Settings")
  TextGadget(#Text1,20,30,50,20,"Iconsize:")
  SpinGadget(#IconSize,80,30,100,20,8,1024)
  CheckBoxGadget(#SmartWindowRefresh,20,60,GadgetWidth(#Frame1)-20,20,"SmartWindowRefresh")
  ButtonGadget(#CreateStartmenu,20,100,150,20,"Create startmenu")
  ButtonGadget(#InstallSplashMod,20,130,250,20,"Install splashmod")
 Frame3DGadget(#Frame2,GadgetWidth(#Frame1)+20,10,WindowWidth(#Window)-GadgetWidth(#Frame1)-30,WindowHeight(#Window)-60,"Preview")
  ButtonImageGadget(#Preview_IconSize,GadgetX(#Frame2)+10,30,GadgetWidth(#Frame2)-20,GadgetWidth(#Frame2)-20,0)
 ButtonGadget(#Save,WindowWidth(#Window)-320,WindowHeight(#Window)-40,150,30,"Save")
 ButtonGadget(#Close,GadgetX(#Save)+160,GadgetY(#Save),150,30,"Close")
 For Gadget=#Text1 To #Close
  If IsGadget(Gadget)
   SetGadgetFont(Gadget,FontID(#Font1))
  EndIf
 Next
 SetGadgetFont(#Save,FontID(#Font2))
 SetGadgetFont(#Close,FontID(#Font2))
 OpenPreferences(Common\PrefsFile)
  PreferenceGroup("Global")
   SetGadgetState(#SmartWindowRefresh,ReadPreferenceLong("SmartWindowRefresh",1))
   SetGadgetState(#IconSize,ReadPreferenceLong("IconSize",32))
 ClosePreferences()
 SetGadgetText(#IconSize,Str(GetGadgetState(#IconSize))+" px")
 IconPreview()
 Repeat
  Select WaitWindowEvent()
   Case #PB_Event_Gadget
    Select EventGadget()
     Case #IconSize
      SetGadgetText(#IconSize,Str(GetGadgetState(#IconSize))+" px")
      IconPreview()
     Case #CreateStartmenu
      If IsFileEx(Common\InstallPath+"GTA ToolBox.exe")
       RunProgram(Common\InstallPath+"GTA ToolBox.exe","/createstartmenu",Common\InstallPath)
      Else
       MessageRequester("Error","GUI not found!",#MB_ICONERROR)
      EndIf
     Case #InstallSplashMod
      If IsFileEx(Common\GTAFile)=0
       MessageRequester("Error","GTA San Andreas was not found!",#MB_ICONERROR)
       Path$=PathRequester("Select your GTA San Andreas folder.",GetPathPart(Common\GTAFile))
        If Path$
         If IsFileEx(Path$+"gta_sa.exe")
          Common\GTAFile=Path$+"gta_sa.exe"
          SetRegGTASAFile(Common\GTAFile)
         Else
          MessageRequester("Error","gta_sa.exe was not found!",#MB_ICONERROR)
         EndIf
        EndIf
      EndIf
      If IsFileEx(Common\GTAFile)
       Path$=GetPathPart(Common\GTAFile)
       If MessageRequester("Install splashmod","Install splashmod to '"+Path$+"'?",#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
        CopyFile(Common\InstallPath+"SplashMod\LOADSCS.txd",Path$+"models\txd\LOADSCS.txd")
       EndIf
      EndIf
     Case #Preview_IconSize
      MessageRequester("Test","This is only a testbutton.",#MB_ICONINFORMATION)
     Case #Save
      If OpenPreferences(Common\PrefsFile)
       PreferenceGroup("Global")
        WritePreferenceLong("SmartWindowRefresh",GetGadgetState(#SmartWindowRefresh))
        WritePreferenceLong("IconSize",GetGadgetState(#IconSize))
       ClosePreferences()
       MessageRequester("Information","Saving successful!",#MB_ICONINFORMATION)
      Else
       MessageRequester("Error","Can not save!",#MB_ICONERROR)
      EndIf
     Case #Close
      If MessageRequester("Quit","Quit program?",#MB_YESNO|#MB_ICONWARNING)=#PB_MessageRequester_Yes
       Quit=1
      EndIf
    EndSelect
  EndSelect
 Until Quit
EndIf

DataSection
 Icon:
  IncludeBinary "Config.ico"
EndDataSection