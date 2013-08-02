Enumeration
	#RunOnlyOnceCheckWindow
	#Window
	#ConfigList
	#New
	#Remove
	#Details
	#Save
	#SaveStart
	#DetailsList
	#XML
EndEnumeration

Structure DetailsValues
	Input.l
	Output.s
EndStructure

Structure Details
	ItemID.l
	Offset.l
	Type.b
	Name.s
	List Values.DetailsValues()
EndStructure

#Title="GTA San Andreas ConfigManager"

Global NewList Details.Details()

IncludeFile "Includes\Common.pbi"

Procedure SaveConfig(Name$="")
	If Not Name$
		Name$=GetGadgetText(#ConfigList)
	EndIf
	If Name$
		CopyFile(Common\ConfigPath+Name$+".set",Common\GTASASet)
	EndIf
EndProcedure

Procedure LoadXMLNode(*CurrentNode,CurrentSublevel)
	If XMLNodeType(*CurrentNode)=#PB_XML_Normal
		Select GetXMLNodeName(*CurrentNode)
			Case "category"
				AddGadgetItem(#DetailsList,-1,GetXMLAttribute(*CurrentNode,"name"),0,CurrentSublevel)
			Case "option"
				AddElement(Details())
				Details()\ItemID=CountGadgetItems(#DetailsList)
				Details()\Name=GetXMLAttribute(*CurrentNode,"name")
				Select UCase(GetXMLAttribute(*CurrentNode,"type"))
					Case "BYTE"
						Details()\Type=#PB_Byte
					Case "WORD"
						Details()\Type=#PB_Word
					Case "LONG"
						Details()\Type=#PB_Long
				EndSelect
				Details()\Offset=Hex2Dec(GetXMLAttribute(*CurrentNode,"offset"))
				*Node=XMLNodeFromPath(*CurrentNode,"value")
				If *Node
					While *Node
						AddElement(Details()\Values())
						Details()\Values()\Input=Val(GetXMLAttribute(*Node,"value"))
						Details()\Values()\Output=GetXMLNodeText(*Node)
						*Node=NextXMLNode(*Node)
					Wend
				EndIf
				AddGadgetItem(#DetailsList,-1,Details()\Name,0,CurrentSublevel)
			Case "root"
				CurrentSublevel=-1
		EndSelect
		*ChildNode=ChildXMLNode(*CurrentNode)
		While *ChildNode
			LoadXMLNode(*ChildNode,CurrentSublevel+1)
			*ChildNode=NextXMLNode(*ChildNode)
		Wend
	EndIf
EndProcedure

Procedure LoadDetails()
	If GetGadgetState(#Details)
		If GetGadgetText(#ConfigList)
			File=ReadFile(#PB_Any,Common\ConfigPath+GetGadgetText(#ConfigList)+".set")
			If IsFile(File)
				For Detail=0 To ListSize(Details())-1
					SelectElement(Details(),Detail)
					FileSeek(File,Details()\Offset)
					Select Details()\Type
						Case #PB_Byte
							Value=ReadByte(File)
						Case #PB_Word
							Value=ReadWord(File)
						Case #PB_Long
							Value=ReadLong(File)
						Default
							Value=0
					EndSelect
					ValueChanged=#False
					ForEach Details()\Values()
						If Value=Details()\Values()\Input
							Value$=Details()\Values()\Output
							ValueChanged=#True
							Break
						EndIf
					Next
					If Not ValueChanged
						Value$=Str(Value)
					EndIf
					SetGadgetItemText(#DetailsList,Details()\ItemID,Details()\Name+": "+Value$)
				Next
				CloseFile(File)
			EndIf
		Else
			For Detail=0 To ListSize(Details())-1
				SelectElement(Details(),Detail)
				SetGadgetItemText(#DetailsList,Details()\ItemID,Details()\Name)
			Next
		EndIf
	EndIf
EndProcedure

Procedure ListConfigs()
	ClearGadgetItems(#ConfigList)
	CurrentMD5$=MD5FileFingerprint(Common\GTASASet)
	Dir=ExamineDirectory(#PB_Any,Common\ConfigPath,"*.set")
	If IsDirectory(Dir)
		While NextDirectoryEntry(Dir)
			Name$=DirectoryEntryName(Dir)
			If DirectoryEntryType(Dir)=#PB_DirectoryEntry_File And Name$<>"." And Name$<>".."
				AddGadgetItem(#ConfigList,-1,GetFileName(Name$))
				If CurrentMD5$=MD5FileFingerprint(Common\ConfigPath+Name$)
					SetGadgetState(#ConfigList,CountGadgetItems(#ConfigList)-1)
				EndIf
			EndIf
		Wend
		FinishDirectory(Dir)
	EndIf
	LoadDetails()
	ProcedureReturn CountGadgetItems(#ConfigList)
EndProcedure

Procedure SaveStart(Name$="")
	SaveConfig(Name$)
	RunProgram(Common\GTAFile,"",GetPathPart(Common\GTAFile))
	If Config\DisableSplashScreens
		DisableGTASplash()
	EndIf
EndProcedure

Common\GTASASet=GetPath(5)+"GTA San Andreas User Files\gta_sa.set"
OpenPreferences(Common\SettingsFile)
	PreferenceGroup("General")
		Config\DisableSplashScreens=ReadPreferenceLong("DisableSplashScreens",#False)
ClosePreferences()

If Not RegisterModule("ConfigManager")
	MessageRequester(#Title,Language("The GTA San Andreas ToolBox ConfigManager has been already started!"),#MB_ICONERROR)
	End
EndIf

Index=GetParameter("UseConfig")
If Index
	Name$=Trim(ProgramParameter(Index))
	If Name$
		SaveStart(Name$)
	EndIf
	End
EndIf

If OpenWindow(#Window,100,100,360,80,#Title,#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
	ComboBoxGadget(#ConfigList,10,10,WindowWidth(#Window)-20,20)
	ButtonGadget(#New,10,40,50,30,"New...")
	ButtonGadget(#Remove,70,40,50,30,"Remove")
	ButtonGadget(#Details,130,40,50,30,"Details...",#PB_Button_Toggle)
	ButtonGadget(#Save,190,40,50,30,"Save")
	ButtonGadget(#SaveStart,250,40,100,30,"Save and Launch")
	;ListIconGadget(#DetailsList,10,90,WindowWidth(#Window)-20,250,"Name",150,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
	TreeGadget(#DetailsList,10,90,WindowWidth(#Window)-20,250)
	;AddGadgetColumn(#DetailsList,1,"Value",180)
	If LoadXML(#XML,Common\ConfigPath+"GTASAConfigs.xml")
		If XMLStatus(#XML)=#PB_XML_Success
			LoadXMLNode(MainXMLNode(#XML),0)
		Else
			MessageRequester("XML Error","Error: "+XMLError(#XML)+Chr(13)+Chr(13)+"Line: "+Str(XMLErrorLine(#XML))+Chr(13)+"Character:"+Str(XMLErrorPosition(#XML)))
			Quit=#True
		EndIf
		FreeXML(#XML)
	EndIf
	If Not ListConfigs()
		MessageRequester(#Title,"You have not created any configuration."+Chr(13)+"Click 'New' to create one.",#MB_ICONINFORMATION)
	EndIf
	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #ConfigList
						LoadDetails()
					Case #New
						Exists=#False
						CurrentMD5$=MD5FileFingerprint(Common\GTASASet)
						Dir=ExamineDirectory(#PB_Any,Common\ConfigPath,"*.set")
						If IsDirectory(Dir)
							While NextDirectoryEntry(Dir)
								Name$=DirectoryEntryName(Dir)
								If DirectoryEntryType(Dir)=#PB_DirectoryEntry_File And Name$<>"." And Name$<>".."
									If CurrentMD5$=MD5FileFingerprint(Common\ConfigPath+Name$)
										ExistsName$=GetFileName(Name$)
										Exists=#True
										Break
									EndIf
								EndIf
							Wend
							FinishDirectory(Dir)
						EndIf
						If Exists
							MessageRequester(#Title,"There already exists a configuration '"+ExistsName$+"' with the same content!",#MB_ICONERROR)
						Else
							Name$=InputRequester("Create config from current","Input the name for the new configuration.","New configuration")
							If Name$
								File$=Common\ConfigPath+Name$+".set"
								If IsFileEx(File$)
									Write=MessageRequester(GetWindowTitle(#Window),"The configuration already exists!"+Chr(13)+"Do you want to replace it?",#MB_YESNO|#MB_ICONWARNING)
								Else
									Write=#PB_MessageRequester_Yes
								EndIf
								If Write=#PB_MessageRequester_Yes
									CopyFile(Common\GTASASet,File$)
								EndIf
							EndIf
							ListConfigs()
						EndIf
					Case #Remove
						Name$=GetGadgetText(#ConfigList)
						If Name$
							If MessageRequester(#Title,"Are you sure you want to remove the configuration '"+Name$+"'?",#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
								DeleteFile(Common\ConfigPath+Name$+".set")
								ListConfigs()
							EndIf
						EndIf
					Case #Details
						If GetGadgetState(#Details)
							ResizeWindow(#Window,#PB_Ignore,#PB_Ignore,#PB_Ignore,350)
							LoadDetails()
						Else
							ResizeWindow(#Window,#PB_Ignore,#PB_Ignore,#PB_Ignore,80)
						EndIf
					Case #Save
						SaveConfig()
					Case #SaveStart
						SaveStart()
						Quit=#True
				EndSelect
			Case #PB_Event_CloseWindow
				Quit=#True
		EndSelect
	Until Quit
EndIf
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 161
; FirstLine = 155
; Folding = -
; EnableXP