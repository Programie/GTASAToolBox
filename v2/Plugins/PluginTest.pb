; 1. Compile this program as a DLL (library)
; 2. Load it with PluginLoader

Enumeration; Values for sending with SendMessage()
 #Plugin_Message_StopLoop; Stop the main loop
 #Plugin_Message_IDLE; Nothing to do
EndEnumeration

Global WinID,ThreadID,Message; We want to remember some values

; Threads

Procedure Window(WindowID); A thread...
 If OpenWindow(1,100,100,500,300,"Plugin Window",#PB_Window_MinimizeGadget); Open a window at 100 x 100
  TextGadget(1,10,10,480,20,"This is a window opened though a plugin."); Create a text gadget
  ButtonGadget(2,10,50,100,30,"A button"); A button ;)
  ButtonGadget(3,120,50,150,30,"Control PluginLoader"); The button to open the window "Control PluginLoader"
  Repeat; Loop
   Select WaitWindowEvent(10); Wait for windowevents
    Case #PB_Event_Gadget; Event is a gadget event
     Select EventGadget(); Get the gadget
      Case 2; Gadget 2 has an event... it's the button "A button"
       MessageRequester("Plugin Test","You clicked the button!"); Show a nice message
      Case 3; Gadget 3 has an event... it's the button "Control PluginLoader"
       If OpenWindow(2,100,100,500,300,GetGadgetText(3)); Open a window
        ButtonGadget(4,10,10,100,30,"Get window title"); Button to get the window title of the PluginLoader
        ButtonGadget(5,120,10,100,30,"Close window"); Button to close the Plugin Loader window
        ButtonGadget(6,230,10,100,30,"Kill"); Button to kill the own thread
        ButtonGadget(7,340,10,100,30,"Send message"); Button to send a user defined message to PluginLoader
       EndIf
      Case 4; Gadget 4 has an event... it's the "Get window title" button
       Title$=Space(#MAX_PATH); Allocate space for the title (260 bytes + 1 byte for the closing zero)
       GetWindowText_(WindowID,@Title$,#MAX_PATH); Get the title of the window with the given ID and save it into Title$
       MessageRequester("Plugin Test","Title: "+Title$); Show the title
      Case 5; Gadget 5 has an event... it's the button "Close window"
       CloseWindow_(WindowID); Close the PluginLoader window (However it only minimize the window)
      Case 6; Gadget 6 has an event... it's the button "Kill"
       KillThread(ThreadID); Kill it self
      Case 7; Gadget 7 has an event... it's the button "Send message"
       Message=Val(InputRequester("Plugin Test","Input a number to send.","0")); Let the user input the value
       MessageRequester("Plugin Test","Now we will send the message with ID "+Str(Message)+".")
     EndSelect
    Case #PB_Event_CloseWindow; A window has closed
     Quit=1; Write 1 into the variable "Quit"
   EndSelect
  Until Quit; Repeat until Quit is not zero (less than zero and greater than zero)
 EndIf
EndProcedure


; Required functions

ProcedureDLL GetPluginVersion();- Get the needed PluginLoader version for this plugin
 ProcedureReturn 1; Version 1
EndProcedure

ProcedureDLL InitPlugin(WindowID);- We will get the window id from the program's main window or zero if there is no window
 MessageRequester("Test Plugin","Welcome to this little plugin demo!"); Show a nice message
 MessageRequester("Test Plugin","We've got a window ID"+Chr(13)+Chr(13)+"ID: "+Str(WindowID)); Show the ID
 ThreadID=CreateThread(@Window(),WindowID); We want to do something without hold on the program
 WinID=WindowID; Save the value in a global variable
 Message=#Plugin_Message_IDLE; We want to use the loop
EndProcedure

ProcedureDLL QuitPlugin();- Quit the plugin (Program quit, plugin stop, ...)
 ; We have to do this as fast as possible because the program waits for it...
 MessageRequester("Test Plugin","The plugin will quit"+Chr(13)+Chr(13)+"I've remembered the window ID: "+Str(WinID)); But we can show a test message (Not recommended)
 KillThread(ThreadID); You have to stop all processes running in this plugin (e.g. threads) else PluginLoader will crash!
EndProcedure

ProcedureDLL Error(ErrorCode,Value);- A error occured... Let's receive it ;)
 MessageRequester("Test Plugin","The program sent an error code!"+Chr(13)+Chr(13)+"Code: "+Str(ErrorCode)+Chr(13)+"Optional value: "+Str(Value),#MB_ICONERROR); Show the damn error ;)
EndProcedure

ProcedureDLL Loop();- Send a message to PluginLoader. This function will called very often (every loop). Do things very fast (The program will wait)!
 If IsThread(ThreadID)=0; Check if the thread is not running
  Message=#Plugin_Message_StopLoop; Stop the plugin
 EndIf
 ProcedureReturn Message; Send the value of Message
EndProcedure