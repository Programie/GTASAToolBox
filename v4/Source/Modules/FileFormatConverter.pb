Structure Objects
	Gadget_Cheatlist_20To31.l
	Gadget_Cheatlist_30To31.l
	Gadget_Teleportlist_20To31.l
	Gadget_Teleportlist_30To31.l
EndStructure

Global Objects.Objects

#Title="File Format Converter"

IncludeFile "..\Common.pbi"

ProcedureDLL.s GetModuleInfo(MainPath$)
	InitCommonValues(MainPath$)
	LoadSettings()
	ProcedureReturn "Title="+#Title+Chr(13)+"Version=3.1"+Chr(13)+"Build="+Str(#PB_Editor_BuildCount)+Chr(13)+"Author=SelfCoders"+Chr(13)+"WindowSize=250x170"
EndProcedure

ProcedureDLL OnModuleLoad(MainWindowID,WindowID,MainPath$)
	Common\MainWindowID=MainWindowID
	Common\WindowID=WindowID
	Rect.RECT
	InitCommonValues(MainPath$)
	GetClientRect_(WindowID,Rect)
	WindowWidth=Rect\right
	WindowHeight=Rect\bottom
	UseGadgetList(WindowID)
	Frame3DGadget(#PB_Any,10,10,WindowWidth-20,60,"Cheat list")
	Objects\Gadget_Cheatlist_20To31=ButtonGadget(#PB_Any,130,30,100,30,"v2.0 >> v3.1")
	Objects\Gadget_Cheatlist_30To31=ButtonGadget(#PB_Any,20,30,100,30,"v3.0 >> v3.1")
	Frame3DGadget(#PB_Any,10,100,WindowWidth-20,60,"Teleport list")
	Objects\Gadget_Teleportlist_20To31=ButtonGadget(#PB_Any,130,120,100,30,"v2.0 >> v3.1")
	Objects\Gadget_Teleportlist_30To31=ButtonGadget(#PB_Any,20,120,100,30,"v3.0 >> v3.1")
EndProcedure

ProcedureDLL OnEvent(EventID,ObjectID)
	Select EventID
		Case #PB_Event_Gadget
			Select ObjectID
				Case Objects\Gadget_Cheatlist_20To31
					InputFile$=OpenFileRequester("Open v2.0 Cheat list file","Cheats.clf","Cheat list|*.clf|All files|*.*",0)
					If InputFile$
						InputFile=ReadFile(#PB_Any,InputFile$)
						If IsFile(InputFile)
							OutputFile$=Common\ConfigPath+"Cheats.xml"
							If IsFileEx(OutputFile$)
								Write=MessageRequester(#Title,"Are you sure to overwrite your current cheat list with the converted one?",#MB_YESNO|#MB_ICONQUESTION)
							Else
								Write=#PB_MessageRequester_Yes
							EndIf
							If Write=#PB_MessageRequester_Yes
								XML=CreateXML(#PB_Any)
								If IsXML(XML)
									MainNode=CreateXMLNode(RootXMLNode(XML))
									SetXMLNodeName(MainNode,"cheatlist")
									Lines=0
									DoRead=#False
									Repeat
										Line$=Trim(ReadString(InputFile))
										If Line$
											Select LCase(Line$)
												Case "; cheatlist"
													DoRead=#True
												Case "; teleportlist"
													DoRead=#False
												Default
													If DoRead
														Shortcut=0
														Shortcut$=StringField(Line$,3,"|")
														For ShortcutIndex=1 To CountString(Shortcut$,"+")+1
															ShortcutValue=Val(StringField(Shortcut$,ShortcutIndex,"+"))
															Select ShortcutValue
																Case 0
																Case #VK_CONTROL,#VK_LCONTROL,#VK_RCONTROL
																	Shortcut|#PB_Shortcut_Control
																Case #VK_SHIFT,#VK_LSHIFT,#VK_RSHIFT
																	Shortcut|#PB_Shortcut_Shift
																Case #VK_MENU,#VK_LMENU,#VK_RMENU
																	Shortcut|#PB_Shortcut_Alt
																Default
																	Shortcut|ShortcutValue
															EndSelect
														Next
														Cheat$=StringField(Line$,1,"|")
														OldCheat$=Cheat$
														Finish=Len(Cheat$)
														For Char=1 To Len(Cheat$)
															Char$=Mid(Cheat$,Char,1)
															If Asc(Char$)>=48 And Asc(Char$)<=57
																Finish=Char-1
																Break
															EndIf
														Next
														Cheat$=Mid(Cheat$,1,Finish)
														Parameters$=Trim(Right(OldCheat$,Len(OldCheat$)-Len(Cheat$)))
														Node=CreateXMLNode(MainNode)
														If Node
															SetXMLNodeName(Node,"cheat")
															SetXMLAttribute(Node,"name",StringField(Cheat$,1," "))
															SetXMLAttribute(Node,"shortcut",Str(Shortcut))
															For Parameter=1 To CountString(Parameters$," ")+1
																ParameterNode=CreateXMLNode(Node)
																If ParameterNode
																	SetXMLNodeName(ParameterNode,"parameter")
																	SetXMLNodeText(ParameterNode,StringField(Parameters$,Parameter," "))
																EndIf
															Next
															DescriptionNode=CreateXMLNode(Node)
															If DescriptionNode
																SetXMLNodeName(DescriptionNode,"description")
																SetXMLNodeText(DescriptionNode,StringField(Line$,2,"|"))
															EndIf
														EndIf
														Lines+1
													EndIf
											EndSelect
										EndIf
									Until Eof(InputFile)
									FormatXML(XML,#PB_XML_WindowsNewline|#PB_XML_ReFormat,2)
									SaveXML(XML,OutputFile$)
									FreeXML(XML)
									SendModuleMessage("Cheatlist","ReloadCheatlist","NULL")
									MessageRequester(#Title,"Conversion complete!"+Chr(13)+Chr(13)+"Converted cheats: "+Str(Lines),#MB_ICONINFORMATION)
								Else
									MessageRequester(#Title,"Conversion failed!"+Chr(13)+Chr(13)+"Can not create destination file.",#MB_ICONERROR)
								EndIf
							EndIf
							CloseFile(InputFile)
						Else
							MessageRequester(#Title,"Conversion failed!"+Chr(13)+Chr(13)+"Can not open source file.",#MB_ICONERROR)
						EndIf
					EndIf
				Case Objects\Gadget_Cheatlist_30To31
					InputFile$=OpenFileRequester("Open v3.0 Cheat list file","Cheats.dat","Cheat list|*.dat|All files|*.*",0)
					If InputFile$
						InputFile=ReadFile(#PB_Any,InputFile$)
						If IsFile(InputFile)
							OutputFile$=Common\ConfigPath+"Cheats.xml"
							If IsFileEx(OutputFile$)
								Write=MessageRequester(#Title,"Are you sure to overwrite your current cheat list with the converted one?",#MB_YESNO|#MB_ICONQUESTION)
							Else
								Write=#PB_MessageRequester_Yes
							EndIf
							If Write=#PB_MessageRequester_Yes
								XML=CreateXML(#PB_Any)
								If IsXML(XML)
									MainNode=CreateXMLNode(RootXMLNode(XML))
									SetXMLNodeName(MainNode,"cheatlist")
									Lines=0
									DoRead=#False
									Repeat
										Line$=Trim(ReadString(InputFile))
										If Line$
											Shortcut=0
											Shortcut$=StringField(Line$,3,Chr(9))
											For ShortcutIndex=1 To CountString(Shortcut$,"+")+1
												ShortcutValue=Val(StringField(Shortcut$,ShortcutIndex,"+"))
												Select ShortcutValue
													Case 0
													Case #VK_CONTROL,#VK_LCONTROL,#VK_RCONTROL
														Shortcut|#PB_Shortcut_Control
													Case #VK_SHIFT,#VK_LSHIFT,#VK_RSHIFT
														Shortcut|#PB_Shortcut_Shift
													Case #VK_MENU,#VK_LMENU,#VK_RMENU
														Shortcut|#PB_Shortcut_Alt
													Default
														Shortcut|ShortcutValue
												EndSelect
											Next
											Cheat$=StringField(Line$,1,Chr(9))
											OldCheat$=Cheat$
											Finish=Len(Cheat$)
											For Char=1 To Len(Cheat$)
												Char$=Mid(Cheat$,Char,1)
												If Asc(Char$)>=48 And Asc(Char$)<=57
													Finish=Char-1
													Break
												EndIf
											Next
											Cheat$=Mid(Cheat$,1,Finish)
											Parameters$=Trim(Right(OldCheat$,Len(OldCheat$)-Len(Cheat$)))
											Node=CreateXMLNode(MainNode)
											If Node
												SetXMLNodeName(Node,"cheat")
												SetXMLAttribute(Node,"name",StringField(Cheat$,1," "))
												SetXMLAttribute(Node,"shortcut",Str(Shortcut))
												For Parameter=1 To CountString(Parameters$," ")+1
													ParameterNode=CreateXMLNode(Node)
													If ParameterNode
														SetXMLNodeName(ParameterNode,"parameter")
														SetXMLNodeText(ParameterNode,StringField(Parameters$,Parameter," "))
													EndIf
												Next
												DescriptionNode=CreateXMLNode(Node)
												If DescriptionNode
													SetXMLNodeName(DescriptionNode,"description")
													SetXMLNodeText(DescriptionNode,StringField(Line$,2,Chr(9)))
												EndIf
											EndIf
											Lines+1
										EndIf
									Until Eof(InputFile)
									FormatXML(XML,#PB_XML_WindowsNewline|#PB_XML_ReFormat,2)
									SaveXML(XML,OutputFile$)
									FreeXML(XML)
									SendModuleMessage("Cheatlist","ReloadCheatlist","NULL")
									MessageRequester(#Title,"Conversion complete!"+Chr(13)+Chr(13)+"Converted cheats: "+Str(Lines),#MB_ICONINFORMATION)
								Else
									MessageRequester(#Title,"Conversion failed!"+Chr(13)+Chr(13)+"Can not create destination file.",#MB_ICONERROR)
								EndIf
							EndIf
							CloseFile(InputFile)
						Else
							MessageRequester(#Title,"Conversion failed!"+Chr(13)+Chr(13)+"Can not open source file.",#MB_ICONERROR)
						EndIf
					EndIf
			EndSelect
	EndSelect
EndProcedure

ProcedureDLL OnModuleMessage(SenderModule$,Type$,Message$)
	Select LCase(Type$)
		Case "changelanguage"
			Config\Language=Message$
	EndSelect
EndProcedure

ProcedureDLL OnModuleUnload()
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 15
; FirstLine = 6
; Folding = -
; EnableXP
; Executable = ..\..\Modules\FileFormatConverter.dll
; EnableCompileCount = 71
; EnableBuildCount = 69
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField1 = 1,0,0,0
; VersionField2 = SelfCoders
; VersionField3 = GTA San Andreas ToolBox
; VersionField4 = 3.1
; VersionField5 = 1.0
; VersionField6 = GTA San Andreas ToolBox File Format Converter Module
; VersionField7 = File Format Converter
; VersionField8 = %EXECUTABLE
; VersionField9 = © 2011 SelfCoders
; VersionField13 = gtasatb@selfcoders.com
; VersionField14 = http://www.selfcoders.com
; VersionField15 = VOS_NT_WINDOWS32
; VersionField16 = VFT_DLL
; VersionField18 = Build
; VersionField21 = %BUILDCOUNT