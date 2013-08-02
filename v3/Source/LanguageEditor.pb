Enumeration
	#Window
	#Text1
	#Template
	#Load
	#Save
	#List
EndEnumeration

#Title="GTA San Andreas ToolBox LanguageEditor"

Global InstallPath$
Global Language$
Global LanguageName$

Procedure IsFileEx(FileName$)
	File=ReadFile(#PB_Any,FileName$)
	If IsFile(File)
		CloseFile(File)
		ProcedureReturn #True
	EndIf
EndProcedure

Procedure.s GetFileName(FileName$)
	Path$=GetPathPart(FileName$)
	File$=GetFilePart(FileName$)
	Name$=Left(File$,Len(File$)-Len(GetExtensionPart(File$)))
	If Right(Name$,#True)="."
		Name$=Left(Name$,Len(Name$)-1)
	EndIf
	ProcedureReturn Path$+Name$
EndProcedure

Procedure LoadLanguage()
	ClearGadgetItems(#List)
	Language$=StringField(GetGadgetText(#Template),1," ")
	If OpenPreferences(InstallPath$+"Languages\"+Language$+".lang")
		PreferenceGroup("Info")
			LanguageName$=ReadPreferenceString("Name","")
		PreferenceGroup("Translation")
			If ExaminePreferenceKeys()
				While NextPreferenceKey()
					AddGadgetItem(#List,-1,PreferenceKeyName()+Chr(10)+PreferenceKeyValue())
				Wend
			EndIf
		ClosePreferences()
		SetWindowTitle(#Window,#Title+" - "+GetGadgetText(#Template))
	EndIf
EndProcedure

Procedure ReloadLanguages()
	ClearGadgetItems(#Template)
	Dir=ExamineDirectory(#PB_Any,InstallPath$+"Languages","*.lang")
	If IsDirectory(Dir)
		While NextDirectoryEntry(Dir)
			If DirectoryEntryType(Dir)=#PB_DirectoryEntry_File
				File$=DirectoryEntryName(Dir)
				If File$<>"." And File$<>".."
					ShortName$=LCase(GetFileName(File$))
					OpenPreferences(InstallPath$+"Languages\"+File$)
						PreferenceGroup("Info")
							Name$=ReadPreferenceString("Name","Error in language file")
					ClosePreferences()
					AddGadgetItem(#Template,-1,ShortName$+" ("+Name$+")")
					If Language$=ShortName$
						SelectItem=ItemID
					EndIf
					ItemID+1
				EndIf
			EndIf
		Wend
		FinishDirectory(Dir)
	EndIf
	SetGadgetState(#Template,SelectItem)
EndProcedure

InstallPath$=GetPathPart(ProgramFilename())

If OpenWindow(#Window,100,100,500,300,#Title,#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered)
	TextGadget(#Text1,10,10,50,20,"Template:")
	ComboBoxGadget(#Template,70,10,WindowWidth(#Window)-300,20)
	ButtonGadget(#Load,WindowWidth(#Window)-220,10,100,20,"Load")
	ButtonGadget(#Save,WindowWidth(#Window)-110,10,100,20,"Save As...")
	ListIconGadget(#List,10,40,WindowWidth(#Window)-20,WindowHeight(#Window)-50,"English",200,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
		AddGadgetColumn(#List,1,"Translated",200)
	ReloadLanguages()
	LoadLanguage()
	Repeat
		Select WaitWindowEvent()
			Case #PB_Event_Gadget
				Select EventGadget()
					Case #Load
						If MessageRequester(#Title,"Load the selected template and discard all unsaved changes?",#MB_YESNO|#MB_ICONQUESTION)=#PB_MessageRequester_Yes
							LoadLanguage()
						EndIf
					Case #Save
						Name$=InputRequester(#Title,"Input the name for the language file.",Language$)
						If Name$
							File$=Path$+"Languages\"+Name$+".lang"
							If IsFileEx(File$)
								Write=MessageRequester(#Title,"The file already exists!"+Chr(13)+"Do you want to replace it?",#MB_YESNO|#MB_ICONQUESTION)
							Else
								Write=#PB_MessageRequester_Yes
							EndIf
							If Write=#PB_MessageRequester_Yes
								Name$=InputRequester(#Title,"Input the display name for the language.",LanguageName$)
								If Name$
									If CreatePreferences(File$)
										PreferenceGroup("Info")
											WritePreferenceString("Name",Name$)
										PreferenceGroup("Translation")
										For Item=0 To CountGadgetItems(#List)-1
											WritePreferenceString(GetGadgetItemText(#List,Item,0),GetGadgetItemText(#List,Item,1))
										Next
										ClosePreferences()
										ReloadLanguages()
										LoadLanguage()
									EndIf
								EndIf
							EndIf
						EndIf
					Case #List
						Select EventType()
							Case #PB_EventType_LeftDoubleClick
								Item=GetGadgetState(#List)
								If Item<>-1
									String$=InputRequester("Edit language string",GetGadgetItemText(#List,Item,0),GetGadgetItemText(#List,Item,1))
									If String$
										SetGadgetItemText(#List,Item,String$,1)
									EndIf
								EndIf
						EndSelect
				EndSelect
			Case #PB_Event_SizeWindow
				ResizeGadget(#Template,70,10,WindowWidth(#Window)-300,20)
				ResizeGadget(#Load,WindowWidth(#Window)-220,10,100,20)
				ResizeGadget(#Save,WindowWidth(#Window)-110,10,100,20)
				ResizeGadget(#List,10,40,WindowWidth(#Window)-20,WindowHeight(#Window)-50)
			Case #PB_Event_CloseWindow
				Quit=MessageRequester(#Title,"Are you sure you want to quit?"+Chr(13)+"You will lose all your unsaved changes!",#MB_YESNO|#MB_ICONQUESTION)
		EndSelect
	Until Quit=#PB_MessageRequester_Yes
EndIf
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 59
; FirstLine = 36
; Folding = -
; EnableXP