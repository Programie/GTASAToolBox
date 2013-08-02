Enumeration
 #Module_CheatProcessor
 #Module_Setup
 #Module_Updater
EndEnumeration

Enumeration
 #ShellLinkInfo_FileName
 #ShellLinkInfo_Description
 #ShellLinkInfo_WorkingDirectory
 #ShellLinkInfo_Parameter
 #ShellLinkInfo_IconFile
 #ShellLinkInfo_IconIndex
EndEnumeration

Enumeration
 #Network_GetPID
 #Network_ReadAddress
 #Network_WriteAddress
 #Network_GetMemoryListFile
 #Network_Error_GTASANotFound
EndEnumeration

Structure ShellLinkInfo
 IconIndex.l
 ShowCmd.l
 Hotkey_VK.l
 Hotkey_MOD.l
 FileName.s
 Description.s
 WorkingDirectory.s
 Parameter.s
 IconFile.s
EndStructure

Structure Common
 GTASA_PID.l
 GTASA_WindowID.l
 GTASA_OldWindowID.l
 IsModuleWindow.l
 InstallPath.s
 ConfigPath.s
 UserPath.s
 TempPath.s
 SettingsFile.s
 GTAFile.s
 GTASASet.s
 Parameter.s
 ExplorerMsg.l
EndStructure

Structure GTA_TextZone
 TextWidth.f
 TextHeight.f
 TextColor.l
 Unknown1.b
 Center.b
 Boxed.b
 Unknown2.b
 BoxLeft.f
 BoxWidth.f
 BackgroundColor.l
 Proportional.b
 ShadeColor.l
 ShadeType.b
 LineType.b
 Unknown4.b
 BoxRight.b
 Unknown5.b
 Unknown6.b
 Unknown7.b
 Font.l
 X.f
 Y.f
 GXT1.l
 GXT2.l
 Num1.l
 Num2.l
EndStructure

Structure RadarMarker
 ColorID.l
 Entity.l
 PosX.f
 PosY.f
 PosZ.f
 Flag.w
 Align1.w
 Unknown.f
 IconSize.l
 EnterExit.l
 Icon.b
 Flags.b
 Type.b
 Align2.b
EndStructure

Structure NotifyIconData_95
 cbSize.l
 hwnd.l
 uID.l
 uFlags.l
 uCallbackMessage.l
 hIcon.l
 szTip.b[64]
EndStructure

Structure NotifyIconData_2K Extends NotifyIconData_95
 szTipEx.b[64]
 dwState.l
 dwStateMask.l
 szInfo.b[256]
 StructureUnion 
  uTimeout.l 
  uVersion.l 
 EndStructureUnion 
 szInfoTitle.b[64]
 dwInfoFlags.l
EndStructure

Structure NotifyIconData_XP Extends NotifyIconData_2K
 GUID.GUID
EndStructure

Structure EditorStyle
 cbSize.l
 dwMask.l
 dwEffects.l
 yHeight.l
 yOffset.l
 crTextColor.l
 bCharSet.b
 bPitchAndFamily.b
 szFaceName.b[#LF_FACESIZE]
 _wPad2.w
 wWeight.w
 sSpacing.w
 crBackColor.l
 lcid.l
 dwReserved.l
 sStyle.w
 wKerning.w
 bUnderlineType.b
 bAnimation.b
 bRevAuthor.b
 bReserved1.b
EndStructure

Structure LanguageStrings
	English.s
	Translation.s
EndStructure

Structure Config
	DisplayMessages.l
	Language.s
	DisableSplashScreens.b
	ImageType.s
	CheatServerPort.l
	CheatProcessor_HigherProcessPriority.b
	TextZone_VehicleDamageX.l
	TextZone_VehicleDamageY.l
	TextZone_VehicleDamageColor.l
	TextZone_VehicleSpeedX.l
	TextZone_VehicleSpeedY.l
	TextZone_VehicleSpeedColor.l
	TextZone_SpawnVehicleX.l
	TextZone_SpawnVehicleY.l
	TextZone_SpawnVehicleColor.l
	UseCheatSound.b
	CheatSound.s
	Key_SpawnVehicleEx.l
	Key_ScrollVehicleUp.l
	Key_ScrollVehicleDown.l
EndStructure

Global Common.Common
Global Config.Config
Global NewList LanguageStrings.LanguageStrings()

Procedure EditorStyle_BackColor(Gadget,Color)
 If IsGadget(Gadget)
  Format.EditorStyle
  Format\cbSize=SizeOf(EditorStyle)
  Format\dwMask=$4000000
  Format\crBackColor=Color
  SendMessage_(GadgetID(Gadget),#EM_SETCHARFORMAT,#SCF_SELECTION,@Format)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure EditorStyle_Select(Gadget,LineStart,CharStart,LineEnd,CharEnd)
 If IsGadget(Gadget)
  Selection.CharRange
  Selection\cpMin=SendMessage_(GadgetID(Gadget),#EM_LINEINDEX,LineStart,0)+CharStart-1
  If LineEnd=-1
   LineEnd=SendMessage_(GadgetID(Gadget),#EM_GETLINECOUNT,0,0)-1
  EndIf
  Selection\cpMax=SendMessage_(GadgetID(Gadget),#EM_LINEINDEX,LineEnd,0)
  If CharEnd=-1
   Selection\cpMax+SendMessage_(GadgetID(Gadget),#EM_LINELENGTH,Selection\cpMax,0)
  Else
   Selection\cpMax+CharEnd-1
  EndIf
  SendMessage_(GadgetID(Gadget),#EM_EXSETSEL,0,@Selection)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure EditorStyle_Color(Gadget,Color)
 If IsGadget(Gadget)
  Format.CharFormat
  Format\cbSize=SizeOf(CharFormat)
  Format\dwMask=#CFM_COLOR
  Format\crTextColor=Color
  SendMessage_(GadgetID(Gadget),#EM_SETCHARFORMAT,#SCF_SELECTION,@Format)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure EditorStyle_FontSize(Gadget,Size)
 If IsGadget(Gadget)
  Format.CharFormat
  Format\cbSize=SizeOf(CharFormat)
  Format\dwMask=#CFM_SIZE
  Format\yHeight=Size*20
  SendMessage_(GadgetID(Gadget),#EM_SETCHARFORMAT,#SCF_SELECTION,@Format)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure EditorStyle_Font(Gadget,FontName$)
 If IsGadget(Gadget)
  Format.CharFormat
  Format\cbSize=SizeOf(CharFormat)
  Format\dwMask=#CFM_FACE
  PokeS(@format\szFaceName,FontName$)
  SendMessage_(GadgetID(Gadget),#EM_SETCHARFORMAT,#SCF_SELECTION,@Format)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure EditorStyle_Format(Gadget,Flags)
 If IsGadget(Gadget)
  Format.CharFormat
  Format\cbSize=SizeOf(CharFormat)
  Format\dwMask=#CFM_ITALIC|#CFM_BOLD|#CFM_STRIKEOUT|#CFM_UNDERLINE
  Format\dwEffects=Flags
  SendMessage_(GadgetID(Gadget),#EM_SETCHARFORMAT,#SCF_SELECTION,@Format)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure DeleteRegValue(HKey,Key$,Value$)
 If RegOpenKeyEx_(HKey,Key$,0,#KEY_ALL_ACCESS,@hKey)=#ERROR_SUCCESS
  If RegDeleteValue_(hKey,Value$)=#ERROR_SUCCESS
   Deleted=1
  EndIf
  RegCloseKey_(hKey)
 EndIf
 ProcedureReturn Deleted
EndProcedure

Procedure.s GetRegValue(HKey,Path$,Name$,DefaultValue$="")
 DataCB=255
 DataLP$=Space(DataCB)
 If RegOpenKeyEx_(HKey,Path$,0,#KEY_ALL_ACCESS,@hKey)=#ERROR_SUCCESS
  If RegQueryValueEx_(HKey,Name$,0,@Type,@DataLP$,@DataCB)=#ERROR_SUCCESS
   Select Type
    Case #REG_SZ
     If RegQueryValueEx_(HKey,Name$,0,@Type,@DataLP$,@DataCB)=#ERROR_SUCCESS
      ProcedureReturn Trim(Left(DataLP$,DataCB-1))
     EndIf
    Case #REG_DWORD
     If RegQueryValueEx_(HKey,Name$,0,@Type,@DataLP2,@CBData)=#ERROR_SUCCESS
      ProcedureReturn Trim(Str(DataLP2))
     EndIf
   EndSelect
  EndIf
 EndIf
 ProcedureReturn DefaultValue$
EndProcedure

Procedure SetRegValue(HKey,Path$,Name$,Value$)
 If RegCreateKeyEx_(HKey,Path$,0,0,#REG_OPTION_NON_VOLATILE,#KEY_ALL_ACCESS,0,@NewKey,@KeyInfo)=#ERROR_SUCCESS
  RegSetValueEx_(NewKey,Name$,0,#REG_SZ,Value$,Len(Value$)+1)
  RegCloseKey_(NewKey)
  ProcedureReturn 1
 EndIf
EndProcedure

Procedure.s GetRegGTASAFile()
 ProcedureReturn Trim(RemoveString(GetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Rockstar Games\GTA San Andreas\Installation","ExePath"),Chr(34),1))
EndProcedure

Procedure SetRegGTASAFile(File$)
 ProcedureReturn SetRegValue(#HKEY_LOCAL_MACHINE,"SOFTWARE\Rockstar Games\GTA San Andreas\Installation","ExePath",Chr(34)+Trim(File$)+Chr(34))
EndProcedure

Procedure.w MouseWheelDelta()
 Protected x.w
 x=(EventwParam()>>16)&$FFFF
 ProcedureReturn -(x/120)
EndProcedure

Procedure IsAddressValid(Offset)
 Define.MEMORY_BASIC_INFORMATION MemoryInfo
 If VirtualQueryEx_(Common\GTASA_PID,Offset,MemoryInfo,SizeOf(MEMORY_BASIC_INFORMATION))>0
  If MemoryInfo\State=#MEM_COMMIT
   ProcedureReturn 1
  EndIf
 EndIf
 ProcedureReturn 0
EndProcedure

Procedure MakeLong(Lo.w,Hi.w)
 ProcedureReturn (Hi*$10000)|(Lo&$FFFF)
EndProcedure

Procedure Hex2Dec(Hex$)
 Structure Hex2Dec
  Dec.b
 EndStructure
 *Hex2Dec.Hex2Dec=@Hex$
  While *Hex2Dec\Dec
   If *Hex2Dec\Dec>='0' And *Hex2Dec\Dec<='9'
    Result=(Result<<4)+(*Hex2Dec\Dec-48)
   ElseIf *Hex2Dec\Dec>='A' And *Hex2Dec\Dec<='F'
    Result=(Result<<4)+(*Hex2Dec\Dec-55)
   ElseIf *Hex2Dec\Dec>='a' And *Hex2Dec\Dec<='f'
    Result=(Result<<4)+(*Hex2Dec\Dec-87)
   Else
    Result=(Result<<4)+(*Hex2Dec\Dec-55)
   EndIf
   *Hex2Dec+1
  Wend
 ProcedureReturn Result
EndProcedure

Procedure CreateDirectoryEx(Path$)
	Path$=ReplaceString(Path$,"/","\")
	If Right(Path$,1)<>"\"
		Path$+"\"
	EndIf
	Directory=ExamineDirectory(#PB_Any,Path$,"*.*")
	If IsDirectory(Directory)
		FinishDirectory(Directory)
		ProcedureReturn #True
	Else
		Dir$=StringField(Path$,1,"\")+"\"
		For Index=2 To CountString(Path$,"\")
			Dir$+StringField(Path$,Index,"\")+"\"
			Debug "Create Dir: "+Dir$
			CreateDirectory(Dir$)
		Next
		Directory=ExamineDirectory(#PB_Any,Path$,"*.*")
		If IsDirectory(Directory)
			FinishDirectory(Directory)
			ProcedureReturn #True
		EndIf
	EndIf
EndProcedure

Procedure LoadLanguage()
	ClearList(LanguageStrings())
	OpenPreferences(Common\InstallPath+"Languages\"+Config\Language+".lang")
		PreferenceGroup("Translation")
			If ExaminePreferenceKeys()
				While NextPreferenceKey()
					AddElement(LanguageStrings())
					LanguageStrings()\English=PreferenceKeyName()
					String$=PreferenceKeyValue()
					For Char=$00 To $FF
						String$=ReplaceString(String$,"%"+RSet(Hex(Char),2,"0"),Chr(Char),#PB_String_NoCase)
					Next
					LanguageStrings()\Translation=String$
				Wend
			EndIf
	ClosePreferences()
EndProcedure

Procedure.s Language(String$)
	If ListSize(LanguageStrings())
		ForEach LanguageStrings()
			If LanguageStrings()\English=String$
				String$=LanguageStrings()\Translation
				String$=ReplaceString(String$,"&auml;",Chr($E4))
				String$=ReplaceString(String$,"&ouml;",Chr($F6))
				String$=ReplaceString(String$,"&uuml;",Chr($FC))
				String$=ReplaceString(String$,"&Auml;",Chr($C4))
				String$=ReplaceString(String$,"&Ouml;",Chr($D6))
				String$=ReplaceString(String$,"&Uuml;",Chr($DC))
				String$=ReplaceString(String$,"&szlig;",Chr($DF))
				Break
			EndIf
		Next
	EndIf
	ProcedureReturn String$
EndProcedure

Procedure.s GetFullProgramparameter()
 Repeat
  String$=ProgramParameter()
   If String$
    Parameter$+String$+" "
   EndIf
 Until String$=""
 ProcedureReturn Left(Parameter$,Len(Parameter$)-1)
EndProcedure

Procedure IsFileEx(FileName$)
 File=ReadFile(#PB_Any,FileName$)
  If IsFile(File)
   CloseFile(File)
   ProcedureReturn 1
  EndIf
EndProcedure

Procedure.s GetPath(PathID)
 Path$=Space(#MAX_PATH)
 If SHGetSpecialFolderLocation_(0,PathID,@PID)=#NOERROR
  SHGetPathFromIDList_(PID,@Path$)
  Path$=Trim(Path$)
   If Path$
    If Right(Path$,1)<>"\"
     Path$+"\"
    EndIf
    ProcedureReturn Path$
   EndIf
  CoTaskMemFree_(PID)
 EndIf
EndProcedure

Procedure WriteProcessMemory(Offset,Buffer,Size)
 If Common\GTASA_PID
  VirtualProtectEx_(Common\GTASA_PID,Offset,Size,#PAGE_EXECUTE_READWRITE,@OldProtect)
  WriteProcessMemory_(Common\GTASA_PID,Offset,Buffer,Size,0)
  VirtualProtectEx_(Common\GTASA_PID,Offset,Size,@OldProtect,@Protect)
 EndIf
EndProcedure

Procedure ReadProcessValue(Offset,Type)
 Select Type
  Case #PB_Byte
   Size=1
  Case #PB_Character
   Size=1
  Case #PB_Word
   Size=2
  Case #PB_Long
   Size=4
 EndSelect
 If Common\GTASA_PID And Size
  VirtualProtectEx_(Common\GTASA_PID,Offset,Size,#PAGE_EXECUTE_READWRITE,@OldProtect)
  Result=ReadProcessMemory_(Common\GTASA_PID,Offset,@Value,Size,0)
  If Result=0
   ErrorCode=GetLastError_()
  EndIf
  VirtualProtectEx_(Common\GTASA_PID,Offset,Size,@OldProtect,@Protect)
  If DebugThisApp And Result=0
   MessageRequester("DEBUGGER","ReadProcessMemory_(): "+Str(ErrorCode)+Chr(13)+"Offset: "+Hex(Offset)+Chr(13)+"Value: "+Str(Value))
  EndIf
  ProcedureReturn Value
 EndIf
EndProcedure

Procedure.s ReadProcessArray(Offset,Size=0)
	If Common\GTASA_PID
		If Size<=0
			Byte=1
			While Byte<>0 And Bytes<=65000
				Byte=ReadProcessValue(Offset+Bytes,#PB_Byte)
				If Byte
					Bytes+1
					Array$+Hex(Byte)+" "
				EndIf
			Wend
		Else
			For Byte=0 To Size-1
				Array$+Hex(ReadProcessValue(Offset+Byte,#PB_Byte))+" "
			Next
		EndIf
		ProcedureReturn Trim(Array$)
	EndIf
EndProcedure

Procedure.f ReadProcessFloat(Offset)
 Value.f
 If Common\GTASA_PID
  VirtualProtectEx_(Common\GTASA_PID,Offset,4,#PAGE_EXECUTE_READWRITE,@OldProtect)
  ReadProcessMemory_(Common\GTASA_PID,Offset,@Value,4,0)
  VirtualProtectEx_(Common\GTASA_PID,Offset,4,@OldProtect,@Protect)
  ProcedureReturn Value
 EndIf
EndProcedure

Procedure.s ReadProcessString(Offset,Size=0)
	If Common\GTASA_PID
		If Size<=0
			Char=1
			While Char<>0 And Bytes<=65000
				ReadProcessMemory_(Common\GTASA_PID,Offset+Bytes,@Char,1,0)
				If Char
					Bytes+1
					String$+Chr(Char)
				EndIf
			Wend
		Else
			String$=Space(Size)
			ReadProcessMemory_(Common\GTASA_PID,Offset,@String$,Size,0)
		EndIf
		ProcedureReturn String$
	EndIf
EndProcedure

Procedure WriteProcessValue(Offset,Value,Type)
 Select Type
  Case #PB_Byte
   Size=1
  Case #PB_Character
   Size=1
  Case #PB_Word
   Size=2
  Case #PB_Long
   Size=4
 EndSelect
 If Size
  WriteProcessMemory(Offset,@Value,Size)
 EndIf
EndProcedure

Procedure WriteProcessArray(Offset,Array$)
 Array$=Trim(Array$)
 For Byte=0 To CountString(Array$," ")
  WriteProcessValue(Offset+Byte,Hex2Dec(StringField(Array$,Byte+1," ")),#PB_Byte)
 Next
EndProcedure

Procedure WriteProcessFloat(Offset,Value.f)
 If Common\GTASA_PID
  WriteProcessMemory(Offset,@Value,4)
 EndIf
EndProcedure

Procedure WriteProcessString(Offset,String$)
 If Common\GTASA_PID
  String$+Chr(0)
  WriteProcessMemory(Offset,@String$,Len(String$)+1)
 EndIf
EndProcedure

Procedure NOP(Offset,Size)
 For Byte=1 To Size
  WriteProcessValue(Offset+Byte-1,$90,#PB_Byte)
 Next
EndProcedure

Procedure CallProcessFunction(Offset,Parameter=0)
 CreateRemoteThread_(Common\GTASA_PID,0,0,Offset,Parameter,0,@ThreadID)
 ProcedureReturn ThreadID
EndProcedure

Procedure UpdateGTASAProcess()
 Common\GTASA_WindowID=FindWindow_(0,"GTA: San Andreas")
  If Common\GTASA_WindowID<>Common\GTASA_OldWindowID
   If Common\GTASA_PID
    CloseHandle_(Common\GTASA_PID)
    Common\GTASA_PID=0
    Common\GTASA_WindowID=0
    Common\GTASA_OldWindowID=0
   Else
    Common\GTASA_OldWindowID=Common\GTASA_WindowID
    GetWindowThreadProcessId_(Common\GTASA_WindowID,@PID)
    Common\GTASA_PID=OpenProcess_(#PROCESS_ALL_ACCESS,0,PID)
    If ReadProcessValue($53BF9C,#PB_Long)=3083552928
     WriteProcessMemory($856CE0,?ASM_Start,?ASM_End-?ASM_Start)
     WriteProcessValue($53BF9C,833437673,#PB_Long)
    EndIf
   EndIf
  EndIf
 ProcedureReturn Common\GTASA_WindowID
EndProcedure

Procedure SaveData(FileName$,StartMemory,EndMemory)
 If CreateDirectoryEx(GetPathPart(FileName$))
  File=CreateFile(#PB_Any,FileName$)
   If IsFile(File)
    WriteData(File,StartMemory,EndMemory-StartMemory)
    CloseFile(File)
    ProcedureReturn 1
   EndIf
 EndIf
EndProcedure

Procedure UnpackFile(FileName$)
 If CreateDirectoryEx(GetPathPart(FileName$))
  Pack=NextPackFile()
   If Pack
    Size=PackFileSize()
    File=CreateFile(#PB_Any,FileName$)
     If IsFile(File)
      WriteData(File,Pack,Size)
      CloseFile(File)
      ProcedureReturn Size
     EndIf
   EndIf
 EndIf
 ProcedureReturn -1
EndProcedure

Procedure SendKey(VK_Key)
 keybd_event_(VK_Key,1,0,0)
 Delay(100)
 keybd_event_(VK_Key,1,#KEYEVENTF_KEYUP,0)
EndProcedure

Procedure LoadInterior(ID)
 If ID=>0 And ID<=18
  PED=ReadProcessValue($B6F3B8,#PB_Long)
  WriteProcessValue($B72914,ID,#PB_Long)
  If ID=0
   WriteProcessValue(PED+$2F,0,#PB_Byte)
  Else
   WriteProcessValue(PED+$2F,3,#PB_Byte)
  EndIf
 EndIf
EndProcedure

Procedure.s ReadStringEx(File,Size,EndChar=-1)
 If Size=0 And EndChar<>-1
  Repeat
   Chr=ReadByte(File)
    If Chr=EndChar
     Break
    Else
     String$+Chr(Chr)
    EndIf
  ForEver
 ElseIf Size
  For Byte=1 To Size
   Chr=ReadByte(File)
    If Chr=EndChar
     Break
    Else
     String$+Chr(Chr)
    EndIf
  Next
 EndIf
 ProcedureReturn String$
EndProcedure

Procedure.s IsValidString(String$,Allow$,NoCase=0)
 If NoCase
  CheckString$=LCase(String$)
  Allow$=LCase(Allow$)
 Else
  CheckString$=String$
 EndIf
 For Chr=1 To Len(CheckString$)
  IsValid=0
  For Allow=1 To Len(Allow$)
   If Mid(CheckString$,Chr,1)=Mid(Allow$,Allow,1)
    IsValid=1
   EndIf
  Next
  If IsValid
   Valid$+Mid(String$,Chr,1)
  EndIf
 Next
 ProcedureReturn Valid$
EndProcedure

Procedure.s StringFieldEx(String$,Index,Separator$)
 If Index=1
  Result$=Mid(String$,0,FindString(LCase(String$),LCase(Separator$),0)-1)
 ElseIf Index>1
  For Part=1 To Index-1
   Start=FindString(LCase(String$),LCase(Separator$),Start+1)
  Next
  Find1=FindString(LCase(String$),LCase(Separator$),Start)
  Find2=FindString(LCase(String$),LCase(Separator$),Start+1)
  If Find2=0
   Find2=Len(String$)+1
  EndIf
  Result$=Mid(String$,Start+Len(Separator$),Find2-Find1-Len(Separator$))
 EndIf
 ProcedureReturn Result$
EndProcedure

Procedure FileSeekEx(File,NewPosition)
 If IsFile(File)
  If NewPosition<=Lof(File)
   FileSeek(File,NewPosition)
   ProcedureReturn 1
  EndIf
 EndIf
EndProcedure

Procedure AddSysTrayIconEx(ID,WindowID,Icon)
 Protected NID.NotifyIconData_95
 NID\cbSize=#NOTIFYICONDATA_V1_SIZE
 NID\uID=ID
 NID\hwnd=WindowID
 NID\hIcon=Icon
 NID\uFlags=#NIF_MESSAGE|#NIF_ICON
 NID\uCallbackMessage=#WM_NOTIFYICON
 ProcedureReturn Shell_NotifyIcon_(#NIM_ADD,@NID)
EndProcedure

Procedure AddSysTrayIconEx2(ID,WindowID,Icon,ToolTip$)
 Protected NID.NotifyIconData_2K
 NID\uID=ID
 NID\hwnd=WindowID
 NID\hIcon=Icon
 NID\uFlags=#NIF_MESSAGE|#NIF_ICON|#NIF_TIP
 NID\uCallbackMessage=#WM_NOTIFYICON
 If OSVersion()>=#PB_OS_Windows_2000
  PokeS(@NID\szTip,ToolTip$,128)
  NID\cbSize=#NOTIFYICONDATA_V2_SIZE
 Else
  PokeS(@NID\szTip,ToolTip$,64)
  NID\cbSize=#NOTIFYICONDATA_V1_SIZE
 EndIf
 ProcedureReturn Shell_NotifyIcon_(#NIM_ADD,@NID)
EndProcedure

Procedure RemoveSysTrayIconEx(ID,WindowID)
 Protected NID.NotifyIconData_95
 NID\cbSize=#NOTIFYICONDATA_V1_SIZE
 NID\uID=ID
 NID\hwnd=WindowID
 ProcedureReturn Shell_NotifyIcon_(#NIM_DELETE,@NID)
EndProcedure

Procedure SysTrayIconToolTipEx(ID,WindowID,ToolTip$)
 Protected NID.NotifyIconData_2K
 NID\uID=ID
 NID\hwnd=WindowID
 NID\uFlags=#NIF_TIP
 If OSVersion()>=#PB_OS_Windows_2000
  PokeS(@NID\szTip,ToolTip$,128)
  NID\cbSize=#NOTIFYICONDATA_V2_SIZE
 Else
  PokeS(@NID\szTip,ToolTip$,64)
  NID\cbSize=#NOTIFYICONDATA_V1_SIZE
 EndIf
 ProcedureReturn Shell_NotifyIcon_(#NIM_MODIFY,@NID)
EndProcedure

Procedure HideSysTrayIconEx(ID,WindowID,State)
 Protected NID.NotifyIconData_2K
 If OSVersion()>=#PB_OS_Windows_2000
  NID\cbSize=#NOTIFYICONDATA_V2_SIZE
  NID\uID=ID
  NID\hwnd=WindowID
  NID\uFlags=#NIF_STATE
  NID\dwStateMask=#NIS_HIDDEN
  If State
   NID\dwState=#NIS_HIDDEN
  EndIf
  ProcedureReturn Shell_NotifyIcon_(#NIM_MODIFY,@NID)
 EndIf
EndProcedure

Procedure SetActiveSysTrayIconEx(ID,WindowID)
 Protected NID.NotifyIconData_2K
 If OSVersion()>=#PB_OS_Windows_2000
  NID\cbSize=#NOTIFYICONDATA_V2_SIZE
  NID\uID=ID
  NID\hwnd=WindowID
  ProcedureReturn Shell_NotifyIcon_(#NIM_SETFOCUS,@NID)
 EndIf
EndProcedure

Procedure SysTrayIconBalloonEx(ID,WindowID,Title$,Message$,TimeOut)
 Protected NID.NotifyIconData_2K
 If OSVersion()>=#PB_OS_Windows_XP
  NID\cbSize=#NOTIFYICONDATA_V3_SIZE
 ElseIf OSVersion()>=#PB_OS_Windows_2000
  NID\cbSize=#NOTIFYICONDATA_V2_SIZE
 Else
  ProcedureReturn 0
 EndIf
 NID\uVersion=#NOTIFYICON_VERSION
 Shell_NotifyIcon_(#NIM_SETVERSION,@NID)
 NID\uID=ID
 NID\hwnd=WindowID
 NID\dwInfoFlags=#NIIF_INFO
 NID\uFlags=#NIF_INFO
 NID\uTimeout=TimeOut
 PokeS(@NID\szInfo,Message$,256) 
 PokeS(@NID\szInfoTitle,Title$,64)
 ProcedureReturn Shell_NotifyIcon_(#NIM_MODIFY,@NID)
EndProcedure

Procedure SysTrayIconBalloonEx2(ID,WindowID,Title$,Message$,TimeOut,Flags)
 Protected NID.NotifyIconData_2K
 If OSVersion()>=#PB_OS_Windows_XP
  NID\cbSize = #NOTIFYICONDATA_V3_SIZE
 ElseIf OSVersion()>=#PB_OS_Windows_2000
  NID\cbSize=#NOTIFYICONDATA_V2_SIZE
 Else
  ProcedureReturn 0
 EndIf
 NID\uVersion=#NOTIFYICON_VERSION 
 Shell_NotifyIcon_(#NIM_SETVERSION, @nid)
 NID\uID=ID
 NID\hwnd=WindowID
 NID\dwInfoFlags=Flags
 NID\uFlags=#NIF_INFO
 NID\uTimeout=TimeOut
 PokeS(@NID\szInfo,Message$,256) 
 PokeS(@NID\szInfoTitle,Title$,64)
 ProcedureReturn Shell_NotifyIcon_(#NIM_MODIFY,@NID)
EndProcedure

Procedure GetShellThumbnail(FileName$,Image,Width,Height,Depth=#PB_Image_DisplayFormat)
 Desktop.IShellFolder
 Folder.IShellFolder
 Extract.IExtractImage
 *pidlFolder.ITEMIDLIST
 *pidlFile.ITEMIDLIST
 size.SIZE
 Result=-1
 If SHGetDesktopFolder_(@Desktop)=> 0
  If Desktop\ParseDisplayName(0,0,GetPathPart(FileName$),0,@*pidlFolder,0)=#S_OK
   If Desktop\BindToObject(*pidlFolder,0,?IID_IShellFolder,@Folder)=#S_OK
    If Folder\ParseDisplayName(0,0,GetFilePart(FileName$),0,@*pidlFile,0)=#S_OK
     If Folder\GetUIObjectOf(0,1,@*pidlFile,?IID_IExtractImage,0,@Extract)=#S_OK
      ImageResult=CreateImage(Image,Width,Height,Depth)
       If ImageResult
        If Image=#PB_Any
         Image=ImageResult
        EndIf
        If Depth=#PB_Image_DisplayFormat
         Depth=ImageDepth(Image)
        EndIf
        size\cx=Width
        size\cy=Height
        If Extract\GetLocation(Space(#MAX_PATH),#MAX_PATH,@Priority,@size,Depth,@Flags)=>0
         If Extract\Extract(@Bitmap)=>0 And Bitmap
          If StartDrawing(ImageOutput(Image))
           DrawImage(Bitmap,0,0)
           StopDrawing()
           Result=ImageResult
          EndIf
          DeleteObject_(Bitmap)
         EndIf
        EndIf
        Extract\Release()
       EndIf
       If Result=-1
        FreeImage(Image)
       EndIf
     EndIf
     CoTaskMemFree_(*pidlFile)
    EndIf
    Folder\Release()
   EndIf
   CoTaskMemFree_(*pidlFolder)
  EndIf
  Desktop\Release()
 EndIf
 ProcedureReturn Result
 DataSection
  IID_IShellFolder:
   Data.l $000214E6
   Data.w $0000,$0000
   Data.b $C0,$00,$00,$00,$00,$00,$00,$46
  IID_IExtractImage:
   Data.l $BB2E617C
   Data.w $0920,$11D1
   Data.b $9A,$0B,$00,$C0,$4F,$C2,$D6,$C1
 EndDataSection
EndProcedure

; Procedure.s GetShellLinkInfo(FileName$,InfoMode)
; 	ShellLinkInfo.ShellLinkInfo
; 	Dim LinkFile.w(Len(FileName$))
; 	MultiByteToWideChar_(#CP_ACP,0,FileName$,-1,LinkFile(),Len(FileName$))
; 	Memory=AllocateMemory(1024)
; 	If Memory
; 		CoInitialize_(0)
; 		If CoCreateInstance_(?CLSID_ShellLink,0,1,?IID_IShellLink,@psl.IShellLinkA)=>0
; 			If psl\QueryInterface(?IID_IPersistFile,@ppf.IPersistFile)=>0
; 				If ppf\Load(@LinkFile(),1)=>0
; 					psl\GetPath(Memory,1024,0,0)
; 					ShellLinkInfo\FileName=PeekS(Memory)
; 					RtlFillMemory_(Memory,1024,0)
; 					psl\GetDescription(Memory,1024)
; 					ShellLinkInfo\Description=PeekS(Memory)
; 					RtlFillMemory_(Memory,1024,0)
; 					psl\GetWorkingDirectory(Memory,1024)
; 					ShellLinkInfo\WorkingDirectory = PeekS(Memory)
; 					RtlFillMemory_(Memory,1024,0)
; 					psl\GetArguments(Memory, 1024)
; 					ShellLinkInfo\Parameter=PeekS(Memory)
; 					RtlFillMemory_(Memory,1024,0)
; 					psl\GetHotkey(@Hotkey)
; 					ShellLinkInfo\Hotkey_VK=PeekB(@Hotkey)
; 					ShellLinkInfo\Hotkey_MOD=PeekB(@Hotkey+1)
; 					psl\GetShowCmd(ShellLinkInfo+4)
; 					psl\GetIconLocation(Memory,1024,ShellLinkInfo)
; 					ShellLinkInfo\IconFile=PeekS(Memory)
; 					Result=#True
; 				EndIf
; 				ppf\Release()
; 			EndIf
; 			psl\Release()
; 		EndIf
; 		CoUninitialize_()
; 		FreeMemory(Memory)
; 	EndIf
; 	If Result
; 		Select InfoMode
; 			Case #ShellLinkInfo_FileName
; 				ProcedureReturn ShellLinkInfo\FileName
; 			Case #ShellLinkInfo_Description
; 				ProcedureReturn ShellLinkInfo\Description
; 			Case #ShellLinkInfo_WorkingDirectory
; 				ProcedureReturn ShellLinkInfo\WorkingDirectory
; 			Case #ShellLinkInfo_Parameter
; 				ProcedureReturn ShellLinkInfo\Parameter
; 			Case #ShellLinkInfo_IconFile
; 				ProcedureReturn ShellLinkInfo\IconFile
; 			Case #ShellLinkInfo_IconIndex
; 				ProcedureReturn Str(ShellLinkInfo\IconIndex)
; 		EndSelect
; 	EndIf
; 	DataSection
; 		CLSID_ShellLink:
; 			Data.l $00021401
; 			Data.w $0000,$0000
; 			Data.b $C0,$00,$00,$00,$00,$00,$00,$46
; 		IID_IShellLink:
; 			Data.l $000214EE
; 			Data.w $0000,$0000
; 			Data.b $C0,$00,$00,$00,$00,$00,$00,$46
; 		IID_IPersistFile:
; 			Data.l $0000010b
; 			Data.w $0000,$0000
; 			Data.b $C0,$00,$00,$00,$00,$00,$00,$46
; 	EndDataSection
; EndProcedure

Procedure.s GetFileName(FileName$)
 Path$=GetPathPart(FileName$)
 File$=GetFilePart(FileName$)
 Name$=Left(File$,Len(File$)-Len(GetExtensionPart(File$)))
  If Right(Name$,#True)="."
   Name$=Left(Name$,Len(Name$)-1)
  EndIf
 ProcedureReturn Path$+Name$
EndProcedure

Procedure RegisterModule(ModuleName$)
	ModuleName$="GTASATB_RunOnlyOnce_CheckWindow_"+ModuleName$
	If FindWindow_(0,ModuleName$)
		ProcedureReturn #False
	Else
		OpenWindow(#RunOnlyOnceCheckWindow,0,0,0,0,ModuleName$,#PB_Window_Invisible)
		ProcedureReturn #True
	EndIf
EndProcedure

Procedure.s ReadStringOffset(File,Offset,Size)
 If IsFile(File)
  FileSeekEx(File,Offset)
  ProcedureReturn ReadStringEx(File,Size)
 EndIf
EndProcedure

Procedure GadgetMouse(Gadget,Mode)
 GetCursorPos_(Mouse.POINT)
 MapWindowPoints_(0,GadgetID(Gadget),Mouse,1)
 Select Mode
  Case 0
   ProcedureReturn Mouse\x
  Case 1
   ProcedureReturn Mouse\y
 EndSelect
EndProcedure

Procedure ResizeImageEx(Image1,Image2,Width,Height)
 If Width And Height And IsImage(Image1)
  If Image1<>Image2
   CopyImage(Image1,Image2)
  EndIf
  ImgWidth=ImageWidth(Image1)
  ImgHeight=ImageHeight(Image1)
   If ImgWidth>Width Or ImgHeight>Height
    Factor.f=ImgWidth/ImgHeight
    If ImgWidth>Width
     NewWidth=Width
     NewHeight=NewWidth/Factor
    EndIf
    If ImgHeight>Height
     NewHeight=Height
     NewWidth=NewHeight*Factor
    EndIf
   Else
    NewWidth=Width
    NewHeight=Height
   EndIf
  ResizeImage(Image2,NewWidth,NewHeight)
  If Width>NewWidth
   x=Width-NewWidth
   x-x/2
  EndIf
  If Height>NewHeight
   y=Height-NewHeight
   y-y/2
  EndIf
  If Width>0 And Height>0
   Img=CreateImage(#PB_Any,Width,Height)
    If IsImage(Img) And IsImage(Image2)
     If StartDrawing(ImageOutput(Img))
       Box(0,0,Width,Height,BackColor)
       DrawImage(ImageID(Image2),x,y)
      StopDrawing()
     EndIf
     FreeImage(Image2)
     CopyImage(Img,Image2)
     FreeImage(Img)
    EndIf
  EndIf
 EndIf
EndProcedure

Procedure.s DataType(Type,Mode)
 Select Type
  Case #PB_Byte
   Type$="Byte"
   Size=1
  Case #PB_Word
   Type$="Word"
   Size=2
  Case #PB_Long
   Type$="Long"
   Size=4
  Case #PB_Float
   Type$="Float"
   Size=4
  Case #PB_Quad
   Type$="Quad"
   Size=8
  Case #PB_String
   Type$="String"
  Case #PB_Double
   Type$="Double"
   Size=8
  Case #PB_Character
   Type$="Character"
   Size=1
 EndSelect
 Select Mode
  Case 1
   ProcedureReturn Type$
  Case 2
   ProcedureReturn Str(Size)
 EndSelect
EndProcedure

Procedure SwapMath(Value)
 If Value<0
  Value=Val(Right(Str(Value),Len(Str(Value))-1))
 ElseIf Value>0
  Value=Val("-"+Str(Value))
 EndIf
 ProcedureReturn Value
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
		CreateShortcut\SetPath(FileName$)
		CreateShortcut\SetArguments(Parameter$)
		CreateShortcut\SetWorkingDirectory(WorkingDir$)
		CreateShortcut\SetDescription(Description$)
		CreateShortcut\SetShowCmd(ShowCommand)
		CreateShortcut\SetHotkey(0)
		CreateShortcut\SetIconLocation(IconFile$,IconIndex)
		If CreateShortcut\QueryInterface(?CreateShortcut_PersistFile,@PersistFile.IPersistFile)=0
			Size=1000
			Buffer$=Space(Size)
			MultiByteToWideChar_(#CP_ACP,0,LinkFile$,#PB_Any,Buffer$,Size)
			Result=#True
			PersistFile\Save(Buffer$,1)
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

Procedure CreateInternetShortcut(FileName$,Url$)
	If CreatePreferences(FileName$)
		PreferenceGroup("InternetShortcut")
			WritePreferenceString("Url",Url$)
		ClosePreferences()
		ProcedureReturn #True
	EndIf
EndProcedure

Procedure SetPosition(x.f,y.f,z.f,LastPosBuffer=0)
 PED=ReadProcessValue($B6F3B8,#PB_Long)
 Pool=ReadProcessValue(PED+20,#PB_Long)
 If LastPosBuffer
  PokeF(LastPosBuffer,ReadProcessFloat(Pool+48))
  PokeF(LastPosBuffer+4,ReadProcessFloat(Pool+52))
  PokeF(LastPosBuffer+8,ReadProcessFloat(Pool+56))
 EndIf
 WriteProcessFloat(Pool+48,x)
 WriteProcessFloat(Pool+52,y)
 WriteProcessFloat(Pool+56,z)
EndProcedure

Procedure.s GetQueryInfo(HTTPRequest,InfoLevel)
 Size=1024
 Buffer$=Space(Size)
 HttpQueryInfo_(HTTPRequest,InfoLevel,Buffer$,@Size,0)
 ProcedureReturn Left(Buffer$,Size)
EndProcedure

Procedure DownloadFile(Url$,FileName$,ProgressBarGadget=-1)
 IsLoop=1
 Size=102400; 100 KB
 Url$=ReplaceString(Url$,"\","/")
 Memory=AllocateMemory(Size)
  If Memory
   CreateDirectoryEx(GetPathPart(FileName$))
   File=CreateFile(#PB_Any,FileName$)
    If IsFile(File)
     InternetID=InternetOpen_("",1,#Null,#Null,0)
     UrlID=InternetOpenUrl_(InternetID,URL$,#Null,0,$80000000,0)
     Domain$=ReplaceString(Left(Url$,(FindString(Url$,"/",8)-1)),"http://","")
     ConnectionID=InternetConnect_(InternetID,Domain$,80,#Null,#Null,3,0,0)
      If ConnectionID>0
       HttpOpenRequest=HttpOpenRequest_(ConnectionID,"HEAD",ReplaceString(URL$,"http://"+Domain$+"/",""),"http/1.1",#Null,0,$80000000,0)
        If HttpOpenRequest>0
         If HttpSendRequest_(HttpOpenRequest,#Null,0,0,0)>0
          QueryInfo$=Trim(GetQueryInfo(HttpOpenRequest,19))
          Tmp$=GetQueryInfo(HttpOpenRequest,22)
          LengthStart=FindString(Tmp$,"Content-Length:",1)
          If LengthStart>0
          	FileSize=Val(Mid(Tmp$,LengthStart+15,FindString(Tmp$,Chr(13),LengthStart)))
          	Result=#True
          EndIf
         EndIf
        EndIf
      EndIf
     If IsGadget(ProgressBarGadget)
      SetGadgetAttribute(ProgressBarGadget,#PB_ProgressBar_Maximum,FileSize)
     EndIf
     Repeat
      InternetReadFile_(UrlID,Memory,Size,@Bytes)
      If Bytes=0
       IsLoop=0
      Else
       TotalBytes+Bytes
       WriteData(File,Memory,Bytes)
      EndIf
      Delay(5)
      If IsGadget(ProgressBarGadget)
       SetGadgetState(ProgressBarGadget,TotalBytes)
      EndIf
      If DownloadFile_StopProcedure
      	IsLoop=#False
      EndIf
     Until Not IsLoop
     If IsGadget(ProgressBarGadget)
      SetGadgetState(ProgressBarGadget,0)
     EndIf
     InternetCloseHandle_(UrlID)
     InternetCloseHandle_(InternetID)
     CloseFile(File)
    EndIf
   FreeMemory(Memory)
  EndIf
  DownloadFile_StopProcedure=#False
 ProcedureReturn Result
EndProcedure

Procedure.s FormatPath(Path$,AddSlash)
	If Right(Path$,1)="\"
		Path$=Left(Path$,Len(Path$)-1)
	EndIf
	If AddSlash
		Path$+"\"
	EndIf
	ProcedureReturn Path$
EndProcedure

Procedure DeleteEmptyDirs(Path$)
 Dir=ExamineDirectory(#PB_Any,Path$,"*.*")
  If IsDirectory(Dir)
   Empty=1
   While NextDirectoryEntry(Dir)
    Name$=DirectoryEntryName(Dir)
     If Name$<>"." And Name$<>".."
      Select DirectoryEntryType(Dir)
       Case #PB_DirectoryEntry_File
        Empty=0
       Case #PB_DirectoryEntry_Directory
        If DeleteEmptyDirs(Path$+Name$+"\")
         DeleteDirectory(Path$+Name$+"\","*.*")
        Else
         Empty=0
        EndIf
      EndSelect
     EndIf
   Wend
   FinishDirectory(Dir)
  EndIf
 ProcedureReturn Empty
EndProcedure

Procedure IsDirectoryEmpty(Path$)
 IsEmpty=1
 Dir=ExamineDirectory(#PB_Any,Path$,"*.*")
  If IsDirectory(Dir)
   While NextDirectoryEntry(Dir)
    Name$=DirectoryEntryName(Dir)
     If Name$<>"." And Name$<>".."
      IsEmpty=0
     EndIf
   Wend
   FinishDirectory(Dir)
  Else
   IsEmpty=-1
  EndIf
 ProcedureReturn IsEmpty
EndProcedure

Procedure CenterWindow(Window,Width=#PB_Ignore,Height=#PB_Ignore)
	If IsWindow(Window)
		x=GetSystemMetrics_(#SM_CXSCREEN)/2-WindowWidth(Window)/2
		y=GetSystemMetrics_(#SM_CYSCREEN)/2-WindowHeight(Window)/2
		If Width=#PB_Ignore
			Width=WindowWidth(Window)
		EndIf
		If Height=#PB_Ignore
			Height=WindowHeight(Window)
		EndIf
		ResizeWindow(Window,x,y,Width,Height)
	EndIf
EndProcedure

Procedure MakeToolWindowEx(Window,State)
 If IsWindow(Window)
  If State
   Flags=#WS_EX_TOOLWINDOW
  Else
   Flags=0
  EndIf
  SetWindowLong_(WindowID(Window),#GWL_EXSTYLE,Flags)
  ShowWindow_(WindowID(Window),#SW_SHOW)
 EndIf
EndProcedure

Procedure CreateTextZone()
 ProcedureReturn AllocateMemory(SizeOf(GTA_TextZone))
EndProcedure

Procedure DisplayTextZone(*TextZone,Num)
 WriteProcessMemory($A913E8+Num*SizeOf(GTA_TextZone),*TextZone,SizeOf(GTA_TextZone))
EndProcedure

Procedure FreeTextZone(*TextZone,Num)
 If *TextZone
  FreeMemory(*TextZone)
 EndIf
 *Space.GTA_TextZone=CreateTextZone()
 DisplayTextZone(*Space,Num)
 FreeMemory(*Space)
EndProcedure

Procedure DisableGTASplash()
	Repeat
		UpdateGTASAProcess()
		WriteProcessArray($7474D3,"90 90 90 90 90 90")
		WriteProcessValue($C8D4C0,5,#PB_Long)
		Timeout+1
		Delay(1)
	Until ReadProcessValue($C8D4C0,#PB_Long)=>5 Or Timeout=>10000
	WriteProcessArray($7474D3,"FF 15 44 81 85 0")
EndProcedure

Procedure.s CalcSize(Size.f)
 If Size<1024
  Type$="B"
 ElseIf Size<1024*1024
  Type$="KB"
  Size/1024
 ElseIf Size<1024*1024*1024
  Type$="MB"
  Size/1024/1024
 ElseIf Size<1024*1024*1024*1024
  Type$="GB"
  Size/1024/1024/1024
 ElseIf Size<1024*1024*1024*1024*1024
  Type$="TB"
  Size/1024/1024/1024/1024
 Else
  Type$="B"
 EndIf
 Size$=StrF(Size,2)
 If Right(Size$,2)="00"
  Size$=Left(Size$,Len(Size$)-3)
 EndIf
 ProcedureReturn Size$+" "+Type$
EndProcedure

Procedure HigherProcessPriority(State)
	If State
		SetPriorityClass_(GetCurrentProcess_(),#HIGH_PRIORITY_CLASS)
	Else
		SetPriorityClass_(GetCurrentProcess_(),#NORMAL_PRIORITY_CLASS)
	EndIf
EndProcedure

Procedure GetParameter(Parameter$)
	For Index=1 To CountProgramParameters()
		If LCase(Trim(ProgramParameter(Index-1)))=LCase(Trim(Parameter$))
			ProcedureReturn Index
		EndIf
	Next
EndProcedure

Procedure.s MD5FingerprintEx(String$)
	ProcedureReturn MD5Fingerprint(@String$,StringByteLength(String$))
EndProcedure

Procedure.s MD5FileFingerprintEx(FileName$)
	If IsFileEx(FileName$)
		ProcedureReturn MD5FileFingerprint(FileName$)
	EndIf
EndProcedure

Procedure LoadSettings()
	OpenPreferences(Common\SettingsFile)
		PreferenceGroup("General")
			Config\DisplayMessages=ReadPreferenceLong("DisplayMessages",#True)
			Config\Language=ReadPreferenceString("Language","en")
			Config\DisableSplashScreens=ReadPreferenceLong("DisableSplashScreens",#False)
			Config\ImageType=ReadPreferenceString("ImageType","jpg")
			Config\CheatServerPort=ReadPreferenceLong("CheatServerPort",8476)
			Config\CheatProcessor_HigherProcessPriority=ReadPreferenceLong("CheatProcessor_HigherProcessPriority",#True)
		PreferenceGroup("CheatProcessor_TextZone")
			Config\TextZone_VehicleDamageX=ReadPreferenceFloat("VehicleDamageX",10)
			Config\TextZone_VehicleDamageY=ReadPreferenceFloat("VehicleDamageY",50)
			Config\TextZone_VehicleDamageColor=ReadPreferenceLong("VehicleDamageColor",4281537023)
			Config\TextZone_VehicleSpeedX=ReadPreferenceFloat("VehicleSpeedX",10)
			Config\TextZone_VehicleSpeedY=ReadPreferenceFloat("VehicleSpeedY",10)
			Config\TextZone_VehicleSpeedColor=ReadPreferenceLong("VehicleSpeedColor",4281537023)
			Config\TextZone_SpawnVehicleX=ReadPreferenceFloat("SpawnVehicleX",10)
			Config\TextZone_SpawnVehicleY=ReadPreferenceFloat("SpawnVehicleY",90)
			Config\TextZone_SpawnVehicleColor=ReadPreferenceLong("SpawnVehicleColor",4281537023)
		PreferenceGroup("CheatSound")
			Config\UseCheatSound=ReadPreferenceLong("Use",#True)
			Config\CheatSound=ReadPreferenceString("Sound","Sounds\Cheat1.wav")
		PreferenceGroup("CheatProcessor_SpecialKeys")
			Config\Key_SpawnVehicleEx=ReadPreferenceLong("SpawnVehicleEx",#VK_CONTROL)
			Config\Key_ScrollVehicleUp=ReadPreferenceLong("ScrollVehicleUp",#VK_NUMPAD9)
			Config\Key_ScrollVehicleDown=ReadPreferenceLong("ScrollVehicleDown",#VK_NUMPAD3)
	ClosePreferences()
EndProcedure

Common\InstallPath=FormatPath(GetRegValue(#HKEY_LOCAL_MACHINE,"Software\SelfCoders","GTA San Andreas ToolBox",""),#True)
Common\ConfigPath=Common\InstallPath+"Config\"
Common\UserPath=GetPath(5)+"GTA San Andreas User Files\"
Common\SettingsFile=Common\ConfigPath+"Settings.ini"
Common\GTASASet=Common\UserPath+"gta_sa.set"
Common\Parameter=GetFullProgramparameter()
Common\ExplorerMsg=RegisterWindowMessage_("TaskbarCreated")
Common\GTAFile=GetRegGTASAFile()

CompilerIf Defined(IsDLL,#PB_Constant)=#False And Defined(IsSetup,#PB_Constant)=#False
	If Not Common\InstallPath
		MessageRequester(#Title,"Installation error!",#MB_ICONERROR)
		End
	EndIf
CompilerEndIf

Debug "Path: "+Common\InstallPath

DataSection
	ASM_Start:
		Data.b $53,$A1,$00,$10,$30,$01,$85,$C0,$74,$11,$50,$E8,$C0,$33,$BE,$FF
		Data.b $58,$C7,$05,$00,$10,$30,$01,$00,$00,$00,$00,$BB,$04,$10,$30,$01
		Data.b $8B,$03,$85,$C0,$74,$10,$6A,$02,$50,$E8,$D2,$1A,$BB,$FF,$58,$58
		Data.b $C7,$03,$00,$00,$00,$00,$83,$C3,$04,$81,$FB,$34,$10,$30,$01,$75
		Data.b $DF,$8B,$1D,$80,$F9,$B6,$00,$85,$DB,$74,$6F,$3B,$1D,$98,$CD,$B7
		Data.b $00,$74,$67,$C7,$05,$C0,$1E,$A9,$00,$45,$52,$00,$00,$DD,$C7,$DD
		Data.b $C6,$D9,$83,$C0,$04,$00,$00,$D9,$05,$B9,$6D,$85,$00,$DE,$E9,$D9
		Data.b $05,$BD,$6D,$85,$00,$DE,$F9,$D9,$EE,$DF,$F1,$DB,$1D,$C4,$1E,$A9
		Data.b $00,$76,$0A,$C7,$05,$C4,$1E,$A9,$00,$00,$00,$00,$00,$C7,$05,$04
		Data.b $1F,$A9,$00,$45,$52,$00,$00,$D9,$43,$44,$D8,$C8,$D9,$43,$48,$D8
		Data.b $C8,$DE,$C1,$D9,$43,$4C,$D8,$C8,$DE,$C1,$D9,$FA,$DA,$0D,$C1,$6D
		Data.b $85,$00,$DB,$1D,$08,$1F,$A9,$00,$EB,$14,$C7,$05,$C0,$1E,$A9,$00
		Data.b $00,$00,$00,$00,$C7,$05,$04,$1F,$A9,$00,$00,$00,$00,$00,$5B,$A0
		Data.b $48,$CB,$B7,$00,$E9,$E8,$51,$CE,$FF,$33,$B3,$76,$43,$71,$3D,$F2
		Data.b $40,$B4,$00
	ASM_End:
EndDataSection
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 347
; FirstLine = 334
; Folding = -------------
; EnableXP