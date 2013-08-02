Structure Common_Settings
	File.s
	XML.l
	MainNode.l
EndStructure

Structure Common
	MainPath.s
	ConfigPath.s
	DataPath.s
	IconPath.s
	ModulesPath.s
	Settings.Common_Settings
	MainWindowID.l
	WindowID.l
	Quit.b
EndStructure

Structure Config_IconSize
	Menu.l
	ToolBar.l
	Window.l
EndStructure

Structure Config
	Language.s
	PreviewInfoSeen.b
	IconSize.Config_IconSize
EndStructure

Structure Keys
	Value.l
	String.s
EndStructure

Global Common.Common
Global Config.Config
Global NewList Keys.Keys()

CompilerIf Defined(ENM_LINK,#PB_Constant)
CompilerElse
	#ENM_LINK=$04000000
CompilerEndIf
CompilerIf Defined(CFM_LINK,#PB_Constant)
CompilerElse
	#CFM_LINK=$00000020
CompilerEndIf
CompilerIf Defined(CFE_LINK,#PB_Constant)
CompilerElse
	#CFE_LINK=$0020
CompilerEndIf
CompilerIf Defined(CFE_SUBSCRIPT,#PB_Constant)
CompilerElse
	#CFE_SUBSCRIPT=$00010000
CompilerEndIf
CompilerIf Defined(CFE_SUPERSCRIPT,#PB_Constant)
CompilerElse
	#CFE_SUPERSCRIPT=$00020000
CompilerEndIf
CompilerIf Defined(CFM_SUBSCRIPT,#PB_Constant)
CompilerElse
	#CFM_SUBSCRIPT=#CFE_SUBSCRIPT|#CFE_SUPERSCRIPT
	#CFM_SUPERSCRIPT=#CFM_SUBSCRIPT
CompilerEndIf
CompilerIf Defined(CFM_BACKCOLOR,#PB_Constant)
CompilerElse
	#CFM_BACKCOLOR=$4000000
CompilerEndIf

Procedure IsFileEx(Filename$)
	File=ReadFile(#PB_Any,Filename$)
	If IsFile(File)
		CloseFile(File)
		ProcedureReturn #True
	EndIf
EndProcedure

Procedure.s GetFileName(Filename$)
	Filename$=GetFilePart(Filename$)
	Extension$=GetExtensionPart(Filename$)
	If Extension$
		ProcedureReturn Left(Filename$,Len(Filename$)-Len(Extension$)-1)
	Else
		ProcedureReturn Filename$
	EndIf
EndProcedure

Procedure WriteLog(String$)
	File=OpenFile(#PB_Any,Common\MainPath+"Debug.log")
	If IsFile(File)
		FileSeek(File,Lof(File))
		WriteStringN(File,"["+FormatDate("%hh:%ii:%ss",Date())+"] "+GetFilePart(ProgramFilename())+" - "+String$)
		CloseFile(File)
	EndIf
EndProcedure

Procedure LoadRTF_Callback(Cookie,Buffer,Length,*Length.LONG)
	Shared LoadRTF_File
	If IsFile(LoadRTF_File)
		ReadData(LoadRTF_File,Buffer,Length)
	EndIf
	*Length\l=Length
EndProcedure

Procedure LoadRTF(Gadget,Filename$)
	Shared LoadRTF_File
	If IsGadget(Gadget)
		LoadRTF_File=ReadFile(#PB_Any,Filename$)
		If IsFile(LoadRTF_File)
			Stream.EDITSTREAM\pfnCallback=@LoadRTF_Callback()
			SendMessage_(GadgetID(Gadget),#EM_STREAMIN,#SF_RTF,@Stream)
		EndIf
	EndIf
EndProcedure

Procedure LoadXMLEx(XML,Filename$)
	ID=LoadXML(XML,Filename$)
	If XML=#PB_Any
		XML=ID
	EndIf
	If IsXML(XML)
		If XMLStatus(XML)=#PB_XML_Success
			ProcedureReturn XML
		Else
			MessageRequester("XML Error","An error occured while parsing "+GetFilePart(Filename$)+"!"+Chr(13)+Chr(13)+"Error: "+XMLError(XML)+Chr(13)+"Line: "+Str(XMLErrorLine(XML))+Chr(13)+"Character: "+Str(XMLErrorPosition(XML)),#MB_ICONERROR)
		EndIf
	EndIf
EndProcedure

Procedure.s GetSettingsValue(Path$,DefaultValue$="")
	If Common\Settings\MainNode
		Node=XMLNodeFromPath(Common\Settings\MainNode,LCase(Path$))
		If Node
			ProcedureReturn Trim(GetXMLNodeText(Node))
		Else
			ProcedureReturn DefaultValue$
		EndIf
	EndIf
EndProcedure

Procedure SetSettingsValue(Path$,Value$)
	If Common\Settings\MainNode
		Path$=LCase(Path$)
		Node=XMLNodeFromPath(Common\Settings\MainNode,Path$)
		If Not Node
			Node=Common\Settings\MainNode
			For Part=1 To CountString(Path$,"/")+1
				Part$=StringField(Path$,Part,"/")
				If Part$
					CheckNode=XMLNodeFromPath(Node,Part$)
					If CheckNode
						Node=CheckNode
					Else
						Node=CreateXMLNode(Node)
						SetXMLNodeName(Node,Part$)
					EndIf
				EndIf
			Next
		EndIf
		If Node
			SetXMLNodeText(Node,Value$)
			ProcedureReturn #True
		EndIf
	EndIf
EndProcedure

Procedure LoadSettings()
	Common\Settings\XML=LoadXMLEx(#PB_Any,Common\Settings\File)
	If IsXML(Common\Settings\XML)
		Common\Settings\MainNode=MainXMLNode(Common\Settings\XML)
	Else
		Common\Settings\XML=CreateXML(#PB_Any)
		If IsXML(Common\Settings\XML)
			Common\Settings\MainNode=CreateXMLNode(RootXMLNode(Common\Settings\XML))
		EndIf
	EndIf
	FormatXML(Common\Settings\XML,#PB_XML_CutNewline|#PB_XML_ReduceSpace)
	SetXMLNodeName(Common\Settings\MainNode,"settings")
	Config\Language=GetSettingsValue("general/language","en")
	Config\PreviewInfoSeen=Val(GetSettingsValue("general/previewinfoseen","0"))
	Config\IconSize\Menu=Val(GetSettingsValue("iconsize/menu","32"))
	Config\IconSize\ToolBar=Val(GetSettingsValue("iconsize/toolbar","32"))
	Config\IconSize\Window=Val(GetSettingsValue("iconsize/window","16"))
EndProcedure

Procedure SaveSettings()
	If IsXML(Common\Settings\XML)
		FormatXML(Common\Settings\XML,#PB_XML_WindowsNewline|#PB_XML_ReFormat,2)
		ProcedureReturn SaveXML(Common\Settings\XML,Common\Settings\File)
	EndIf
EndProcedure

Procedure.s Language(String$)
	String$=ReplaceString(String$,Chr(13),"\n",#PB_String_NoCase)
	If Not Config\Language
		Config\Language="en"
		SetSettingsValue("general/language",Config\Language)
		SaveSettings()
	EndIf
	OpenPreferences(Common\MainPath+"Languages\"+Config\Language+".lng")
		PreferenceGroup("Translation")
			TranslatedString$=ReadPreferenceString(String$,String$)
			CompilerIf #PB_Editor_CreateExecutable
				; Do not write in language files
			CompilerElse
				If Not TranslatedString$ Or TranslatedString$=String$
					WritePreferenceString(String$,String$)
				EndIf
			CompilerEndIf
		;EndPreferenceGroup
	ClosePreferences()
	ProcedureReturn ReplaceString(TranslatedString$,"\n",Chr(13),#PB_String_NoCase)
EndProcedure

;- Character formatting
Procedure Editor_BackColor(Gadget, Color.l)
  format.CHARFORMAT2
  format\cbSize = SizeOf(CHARFORMAT2)
  format\dwMask = $4000000
  format\crBackColor = Color
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format)
EndProcedure

; Set the Text color for the Selection
; in RGB format
Procedure Editor_Color(Gadget, Color.l)
  format.CHARFORMAT2
  format\cbSize = SizeOf(CHARFORMAT2)
  format\dwMask = #CFM_COLOR
  format\crTextColor = Color
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format)
EndProcedure

; Set Font for the Selection
; You must specify a font name, the font doesn't need
; to be loaded
Procedure Editor_Font(Gadget, FontName.s)
  format.CHARFORMAT2
  format\cbSize = SizeOf(CHARFORMAT2)
  format\dwMask = #CFM_FACE
  PokeS(@format\szFaceName, FontName)
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format)
EndProcedure

; Set Font Size for the Selection
; in pt
Procedure Editor_FontSize(Gadget, Fontsize.l)
  format.CHARFORMAT2
  format\cbSize = SizeOf(CHARFORMAT2)
  format\dwMask = #CFM_SIZE
  format\yHeight = FontSize*20
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format)
EndProcedure

Procedure Editor_Format(Gadget,Flags,Alternate=#False)
	Format.CHARFORMAT2
	Format\cbSize=SizeOf(CHARFORMAT2)
	If Alternate
		SendMessage_(GadgetID(Gadget),#EM_GETCHARFORMAT,1,@Format)
		flags=Format\dwEffects!flags
	EndIf
	Format\dwMask=#CFM_ITALIC|#CFM_BOLD|#CFM_STRIKEOUT|#CFM_UNDERLINE|#CFM_LINK|#CFM_SUBSCRIPT|#CFM_SUPERSCRIPT
	Format\dwEffects=Flags
	SendMessage_(GadgetID(Gadget),#EM_SETCHARFORMAT,#SCF_SELECTION,@Format)
EndProcedure

Procedure Editor_Select(Gadget,LineStart,LineEnd,CharStart,CharEnd)
	Selection.CHARRANGE
	Selection\cpMin=SendMessage_(GadgetID(Gadget),#EM_LINEINDEX,LineStart,0)+CharStart
	If LineEnd=-1
		LineEnd=SendMessage_(GadgetID(Gadget),#EM_GETLINECOUNT,0,0)-1
	EndIf
	Selection\cpMax=SendMessage_(GadgetID(Gadget),#EM_LINEINDEX,LineEnd,0)
	If CharEnd=-1
		Selection\cpMax+SendMessage_(GadgetID(Gadget),#EM_LINELENGTH,Selection\cpMax,0)
	Else
		Selection\cpMax+CharEnd
	EndIf
	SendMessage_(GadgetID(Gadget),#EM_EXSETSEL,0,@Selection)
EndProcedure

Procedure Editor_Bulleted(Gadget)
	Format.PARAFORMAT
	Format\cbSize=SizeOf(PARAFORMAT)
	Format\dwMask=#PFM_NUMBERING
	Format\wnumbering=#PFN_BULLET
	SendMessage_(GadgetID(Gadget),#EM_SETPARAFORMAT,0,@Format)
EndProcedure

Procedure FormatEditorGadget(Gadget,LineStart,LineEnd,CharStart,CharEnd,FontName$,FontSize,Flags)
	Editor_Select(Gadget,LineStart,LineEnd,CharStart,CharEnd)
	If FontName$
		Editor_Font(Gadget,FontName$)
	EndIf
	If FontSize
		Editor_FontSize(Gadget,FontSize)
	EndIf
	If Flags
		Editor_Format(Gadget,Flags)
	EndIf
EndProcedure

Procedure FormatEditorGadgetLine(Gadget,Line,FontName$,FontSize,Flags)
	FormatEditorGadget(Gadget,Line,Line,0,-1,FontName$,FontSize,Flags)
EndProcedure

Procedure SendModuleMessage(Module$,Type$,Message$)
	DataString$=Module$+":"+GetFileName(ProgramFilename())+":"+Type$+":"+Message$
	DataString.COPYDATASTRUCT
  DataString\dwData=0
  DataString\cbData=(Len(DataString$)+1)*SizeOf(Character)
  DataString\lpData=@DataString$
  SendMessage_(Common\MainWindowID,#WM_COPYDATA,Common\WindowID,DataString)
EndProcedure

Procedure ShowMenu(ClassName$)
	SendModuleMessage("Main","displaymenu",ClassName$)
EndProcedure

Procedure.s HumanReadableShortcut(Shortcut)
	If Not Shortcut-Shortcut|#PB_Shortcut_Control
		Shortcut=Shortcut!#PB_Shortcut_Control
		Shortcut$+"Ctrl+"
	EndIf
	If Not Shortcut-Shortcut|#PB_Shortcut_Alt
		Shortcut=Shortcut!#PB_Shortcut_Alt
		Shortcut$+"Alt+"
	EndIf
	If Not Shortcut-Shortcut|#PB_Shortcut_Shift
		Shortcut=Shortcut!#PB_Shortcut_Shift
		Shortcut$+"Shift+"
	EndIf
	ForEach Keys()
		If Shortcut=Keys()\Value
			Shortcut$+Keys()\String
			Break
		EndIf
	Next
	ProcedureReturn Shortcut$
EndProcedure

Procedure ReloadKeys()
	ClearList(Keys())
	If OpenPreferences(Common\DataPath+"Keys.ini")
		If ExaminePreferenceKeys()
			While NextPreferenceKey()
				AddElement(Keys())
				Keys()\Value=Val(PreferenceKeyName())
				Keys()\String=PreferenceKeyValue()
			Wend
		EndIf
		ClosePreferences()
	EndIf
EndProcedure

Procedure InitCommonValues(MainPath$="")
	If MainPath$
		Common\MainPath=MainPath$
	Else
		CompilerIf #PB_Editor_CreateExecutable
			Common\MainPath=GetPathPart(ProgramFilename())
		CompilerElse
			Common\MainPath="D:\Projects\gta_sa_toolbox\"
		CompilerEndIf
	EndIf
	Common\ConfigPath=Common\MainPath+"Config\"
	Common\DataPath=Common\MainPath+"Data\"
	Common\IconPath=Common\MainPath+"Icons\"
	Common\ModulesPath=Common\MainPath+"Modules\"
	Common\Settings\File=Common\ConfigPath+"Settings.xml"
	CreateDirectory(Common\ConfigPath)
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 186
; FirstLine = 168
; Folding = -----
; EnableXP
; EnableCompileCount = 2
; EnableBuildCount = 0
; EnableExeConstant