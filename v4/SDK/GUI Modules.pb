; -----------------------------------
; |                                 |
; |                                 |
; |     GTA San Andreas ToolBox     |
; |         GUI Modules SDK         |
; |                                 |
; |                                 |
; |     Create your own module.     |
; |                                 |
; |                                 |
; |     Last Update: 01/16/2011     |
; |                                 |
; |                                 |
; -----------------------------------


; How to start

; Add some Gadgets, a ToolBar, etc. to your module window.
; Compile the code as Shared DLL and put the DLL into the Modules directory of your GTA San Andreas ToolBox.


; Note: Create threads if parts of your module takes long time to process! Else the complete program won't respond to anything.


ProcedureDLL.s GetModuleInfo()
	; Return a string to configure your module
	; Each setting must be separated by the new line character (ASCII Code 13)
	; The following variables can be used:
	; Title = The title of your module (Required)
	; WindowPosition = Position of the window (PosX x PosY)
	; WindowSize = Size of the window (Width x Height)
	; WindowFlags = The same as the flags in OpenWindow
	ProcedureReturn "Title=My application"+Chr(13)+"WindowFlags="+Str(#PB_Window_MinimizeGadget|#PB_Window_SizeGadget)
EndProcedure

ProcedureDLL OnModuleLoad(WindowID,CommunicationGadgetID,MainPath$)
	UseGadgetList(WindowID)
	; Do everything what is needed on loading the module (Initialize gadgets like buttons or create toolbars).
EndProcedure

ProcedureDLL OnEvent(EventID,ObjectID)
	; Progress window events (Click on button, window resizing, etc.)
	; Note: #PB_Event_CloseWindow will be handled by the main application and not passed thru the module.
EndProcedure

ProcedureDLL OnModuleMessage(Message$)
	; Do something with the received message.
EndProcedure

ProcedureDLL OnModuleUnload()
	; Do everything what is needed before unloading the module.
EndProcedure