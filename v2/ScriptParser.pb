Structure Config
 Line.l
 Opcode.l
 Stop.b
 CurrentWindow.l
EndStructure

Structure Value
 Name.s
 Val.s
EndStructure

Structure Window
 ID.l
 HasGadgetList.b
EndStructure

Global Config.Config
Global NewList Code.s()
Global NewList Value.Value()
Global NewList Window.Window()
Global Dim Parameter.s(100)

IncludeFile "Common.pbi"

Procedure RandomEx(Min,Max)
 Repeat
  Value=Random(Max)
   If Value=>Min
    If Min<0
     If Random(1)
      Value=Val("-"+Str(Value))
     EndIf
    EndIf
    ProcedureReturn Value
   EndIf
 ForEver
EndProcedure

Procedure Calc(String$)
 If FindString(String$,"+",0) Or FindString(String$,"-",0) Or FindString(String$,"*",0) Or FindString(String$,"/",0)
  For Char=1 To Len(String$)
   Select Mid(String$,Char,1)
    Case "0","1","2","3","4","5","6","7","8","9"
     Number$+Mid(String$,Char,1)
    Case "+","-","*","/"
     If SetVal=0
      SetVal=1
      Result=Val(Number$)
     Else
      Select Op$
       Case "+"
        Result+Val(Number$)
       Case "-"
        Result-Val(Number$)
       Case "*"
        Result*Val(Number$)
       Case "/"
        Result/Val(Number$)
      EndSelect
     EndIf
     Op$=Mid(String$,Char,1)
     Number$=""
   EndSelect
  Next
  If Op$
   Select Op$
    Case "+"
     Result+Val(Number$)
    Case "-"
     Result-Val(Number$)
    Case "*"
     Result*Val(Number$)
    Case "/"
     Result/Val(Number$)
   EndSelect
  EndIf
 Else
  Result=Val(String$)
 EndIf
 ProcedureReturn Result
EndProcedure

Procedure SelectLine(Line)
 Config\Line=Line
 SelectElement(Code(),Config\Line-1)
EndProcedure

Procedure SetVal(Name$,Value$)
 Name$=Trim(Name$)
  If Name$
   ForEach Value()
    If LCase(Value()\Name)=LCase(Name$)
     Value()\Val=Value$
     IsSet=1
    EndIf
   Next
   If IsSet=0
    AddElement(Value())
    Value()\Name=Name$
    Value()\Val=Value$
   EndIf
  EndIf
EndProcedure

Procedure.s GetVal(Name$)
 Name$=Trim(Name$)
  If Name$
   ForEach Value()
    If LCase(Value()\Name)=LCase(Name$)
     Value$=Value()\Val
     Break
    EndIf
   Next
  EndIf
 ProcedureReturn Value$
EndProcedure

Procedure.s ReplaceValues(Code$)
 ForEach Value()
  Code$=ReplaceString(Code$,Value()\Name,Value()\Val,1)
 Next
 ProcedureReturn Code$
EndProcedure

Procedure Error(Info$)
 MessageRequester("Error - ScriptParser",ReplaceString(Info$,"\n",Chr(13),1)+Chr(13)+Chr(13)+"Line: "+Str(Config\Line)+Chr(13)+"Opcode: "+Hex(Config\Opcode),#MB_ICONERROR)
 Config\Stop=1
EndProcedure

UseJPEGImageDecoder()
UseTGAImageDecoder()
UsePNGImageDecoder()
UseTIFFImageDecoder()

File$=Trim(StringField(Common\Parameter,1,"|"))
 If File$
  File=ReadFile(#PB_Any,File$)
   If IsFile(File)
    SetCurrentDirectory(GetPathPart(File$))
    Repeat
     AddElement(Code())
     Code()=Trim(ReadString(File))
    Until Eof(File)
    CloseFile(File)
    Repeat
     Config\Line+1
     If Config\Line>ListSize(Code())
      Config\Stop=1
     Else
      SelectLine(Config\Line)
      String$=Code()
       If String$ And Left(String$,1)<>";"
        Opcode$=StringField(String$,1,":")
        Pars$=Trim(Right(String$,Len(String$)-Len(Opcode$)-1))
        For Index=1 To 100
         Parameter(Index)=""
        Next
        For Index=1 To CountString(Pars$,Chr(9))+1
         Parameter(Index-1)=Trim(StringField(Pars$,Index,Chr(9)))
        Next
        Config\Opcode=Hex2Dec(Opcode$)
         Select Config\Opcode
          Case $0000; Stop script
           Config\Stop=1
          Case $0001; MessageRequester
           Flags=0
           For Index=1 To CountString(Parameter(3),"|")+1
            Select UCase(Trim(StringField(Parameter(3),Index,"|")))
             Case "MB_ABORTRETRYIGNORE"
              Flags|#MB_ABORTRETRYIGNORE
             Case "MB_DEFAULT_DESKTOP_ONLY"
              Flags|#MB_DEFAULT_DESKTOP_ONLY
             Case "MB_ICONASTERISK"
              Flags|#MB_ICONASTERISK
             Case "MB_ICONERROR"
              Flags|#MB_ICONERROR
             Case "MB_ICONEXCLAMATION"
              Flags|#MB_ICONEXCLAMATION
             Case "MB_ICONINFORMATION"
              Flags|#MB_ICONINFORMATION
             Case "MB_ICONQUESTION"
              Flags|#MB_ICONQUESTION
             Case "MB_ICONWARNING"
              Flags|#MB_ICONWARNING
             Case "MB_OK"
              Flags|#MB_OK
             Case "MB_OKCANCEL"
              Flags|#MB_OKCANCEL
             Case "MB_YESNO"
              Flags|#MB_YESNO
            EndSelect
           Next
           Text$=ReplaceString(Parameter(2),"\n",Chr(13))
           Text$=ReplaceValues(Text$)
           SetVal(Parameter(0),Str(MessageRequester(Parameter(1),Text$,Flags)))
          Case $0002; InputRequester
           Text$=ReplaceValues(Parameter(2))
           DefaultText$=ReplaceValues(Parameter(3))
           SetVal(Parameter(0),InputRequester(Parameter(1),Text$,DefaultText$))
          Case $0003; If
           Go$=""
           Select UCase(ReplaceValues(Parameter(1)))
            Case "EQUAL"
             If ReplaceValues(Parameter(0))=ReplaceValues(Parameter(2))
              Go$=Trim(Parameter(3))
             EndIf
            Case "NOT"
             If ReplaceValues(Parameter(0))<>ReplaceValues(Parameter(2))
              Go$=Trim(Parameter(3))
             EndIf
            Default
             Error("Invalid if-selection!")
           EndSelect
           If Go$ And Stop=0
            NewPos=-1
            ForEach Code()
             String$=Code()
              If String$ And Left(String$,1)<>";"
               Opcode$=StringField(String$,1,":")
               If Trim(Opcode$)="0004"
                If LCase(Trim(Right(String$,Len(String$)-Len(Opcode$)-1)))=LCase(Go$)
                 NewPos=ListIndex(Code())+1
                 Break
                EndIf
               EndIf
              EndIf
            Next
            If NewPos=-1
             Error("Label not found ("+Go$+")!")
            Else
             Config\Line=NewPos-1
            EndIf
           EndIf
          Case $0004; Goto
          Case $0005; Teleport
           ; teleport to x,y,z,Angle,Interior
          Case $0006; SetVal
           SetVal(Parameter(0),Str(Calc(ReplaceValues(Parameter(1)))))
          Case $0007; Spawn vehicle
           VehicleID=Val(ReplaceValues(Parameter(0)))
            If VehicleID=>400 And VehicleID<=611
             WriteProcessValue($01301000,VehicleID,#PB_Word)
            Else
             Error("Invalid VehicleID ("+Str(VehicleID)+")!")
            EndIf
          Case $0008; WriteProcessValue
           Address$=ReplaceValues(Parameter(0))
            If LCase(Left(Address$,2))="0x"
             Address=Hex2Dec(Right(Address$,Len(Address$)-2))
            Else
             Address=Val(Address$)
            EndIf
           Select UCase(Parameter(1))
            Case "BYTE"
             WriteProcessValue(Address,Val(ReplaceValues(Parameter(2))),#PB_Byte)
            Case "CHAR"
             WriteProcessValue(Address,Val(ReplaceValues(Parameter(2))),#PB_Character)
            Case "WORD"
             WriteProcessValue(Address,Val(ReplaceValues(Parameter(2))),#PB_Word)
            Case "LONG","DWORD"
             WriteProcessValue(Address,Val(ReplaceValues(Parameter(2))),#PB_Long)
            Case "FLOAT"
             WriteProcessFloat(Address,ValF(ReplaceValues(Parameter(2))))
            Case "STRING"
             Free$=Left(ReplaceValues(Parameter(4)),1)
              If Free$=""
               Free$=Chr(0)
              EndIf
             WriteProcessString(Address,LSet(ReplaceValues(Parameter(2)),Val(Parameter(3)),Free$))
            Default
             If Str(Val(Parameter(1)))=Parameter(1)
              Size=Val(Parameter(1))
               If Size>0
                Value=Val(Parameter(2))
                WriteProcessMemory(Offset,@Value,Size)
               Else
                Error("Size is zero or negative!")
               EndIf
             Else
              Error("Invalid datatype!")
             EndIf
           EndSelect
          Case $0009; Goto label
           NewPos=-1
           ForEach Code()
            String$=Code()
             If String$ And Left(String$,1)<>";"
              Opcode$=StringField(String$,1,":")
              If Trim(Opcode$)="0004"
               If LCase(Trim(Right(String$,Len(String$)-Len(Opcode$)-1)))=LCase(Parameter(0))
                NewPos=ListIndex(Code())+1
                Break
               EndIf
              EndIf
             EndIf
           Next
           If NewPos=-1
            Error("Label not found ("+Parameter(0)+")!")
           Else
            Config\Line=NewPos-1
           EndIf
          Case $000A; Run file
           RunProgram(ReplaceValues(Parameter(0)),ReplaceValues(Parameter(1)),GetPathPart(ReplaceValues(Parameter(0))))
          Case $000B; ReadProcessValue
           Address$=Parameter(1)
            If LCase(Left(Address$,2))="0x"
             Address=Hex2Dec(Right(Address$,Len(Address$)-2))
            Else
             Address=Val(Address$)
            EndIf
           Select UCase(Parameter(2))
            Case "BYTE"
             SetVal(Parameter(0),Str(ReadProcessValue(Address,#PB_Byte)))
            Case "CHAR"
             SetVal(Parameter(0),Str(ReadProcessValue(Address,#PB_Character)))
            Case "WORD"
             SetVal(Parameter(0),Str(ReadProcessValue(Address,#PB_Word)))
            Case "LONG","DWORD"
             SetVal(Parameter(0),Str(ReadProcessValue(Address,#PB_Long)))
            Case "FLOAT"
             SetVal(Parameter(0),StrF(ReadProcessFloat(Address)))
            Case "STRING"
             SetVal(Parameter(0),ReadProcessString(Address,Val(Parameter(3))))
           EndSelect
          Case $000C; Set string
           Name$=Parameter(0)
            If Name$
             Val$=Trim(Parameter(1))
              If Val$=""
               Val$=GetVal(Name$)
              EndIf
             SetVal(Name$,Val$)
            Else
             Error("Valuename not given!")
            EndIf
          Case $000D; ReplaceString
           SetVal(Parameter(0),ReplaceString(ReplaceValues(Parameter(1)),ReplaceValues(Parameter(2)),ReplaceValues(Parameter(3)),1))
          Case $000E; CallProcessFunction
           Address$=Parameter(1)
            If LCase(Left(Address$,2))="0x"
             Address=Hex2Dec(Right(Address$,Len(Address$)-2))
            Else
             Address=Val(Address$)
            EndIf
           SetVal(Parameter(0),Str(CallProcessFunction(Address,Val(Parameter(2)))))
          Case $000F; Read file to string
           String$=""
           File=ReadFile(#PB_Any,ReplaceValues(Parameter(1)))
            If IsFile(File)
             Repeat
              String$+ReadString(File)
              If Eof(File)=0
               String$+Chr(13)+Chr(10)
              EndIf
             Until Eof(File)
             CloseFile(File)
            EndIf
           SetVal(Parameter(0),String$)
          Case $0010; Read file to data
           Buffer=0
           File=ReadFile(#PB_Any,ReplaceValues(Parameter(1)))
            If IsFile(File)
             Buffer=AllocateMemory(Lof(File))
              If Buffer
               ReadData(File,Buffer,Lof(File))
              EndIf
             CloseFile(File)
            EndIf
           SetVal(Parameter(0),Str(Buffer))
          Case $0011; FreeMemory
           Buffer=Val(Parameter(0))
            If Buffer
             FreeMemory(Buffer)
            EndIf
          Case $0012; FileRequester
           Select UCase(ReplaceValues(Parameter(1)))
            Case "OPEN"
             File$=OpenFileRequester(ReplaceValues(Parameter(2)),ReplaceValues(Parameter(3)),ReplaceValues(Parameter(4)),Val(ReplaceValues(Parameter(5))))
            Case "SAVE"
             File$=SaveFileRequester(ReplaceValues(Parameter(2)),ReplaceValues(Parameter(3)),ReplaceValues(Parameter(4)),Val(ReplaceValues(Parameter(5))))
            Default
             File$=""
           EndSelect
           SetVal(Parameter(0),File$)
          Case $0013; Save file
           Result=0
           File=CreateFile(#PB_Any,ReplaceValues(Parameter(1)))
            If IsFile(File)
             Select UCase(Parameter(2))
              Case "DATA"
               Buffer=Val(ReplaceValues(Parameter(3)))
                If Buffer
                 WriteData(File,Buffer,Val(ReplaceValues(Parameter(4))))
                 Result=1
                EndIf
              Case "STRING"
               WriteString(File,ReplaceValues(Parameter(3)))
               Result=1
              Case "STRINGN"
               WriteStringN(File,ReplaceValues(Parameter(3)))
               Result=1
             EndSelect
             CloseFile(File)
            EndIf
           SetVal(Parameter(0),Str(Result))
          Case $0014; IsFile
           If IsFileEx(ReplaceValues(Parameter(1)))
            Result=1
           Else
            Result=0
           EndIf
           SetVal(Parameter(0),Str(Result))
          Case $0015; GetKeyState
           If GetAsyncKeyState_(Val(ReplaceValues(Parameter(1))))
            Pressed=1
           Else
            Pressed=0
           EndIf
           If Parameter(0)
            SetVal(Parameter(0),Str(Pressed))
           EndIf
           If Parameter(2) And Pressed
            NewPos=-1
            ForEach Code()
             String$=Code()
              If String$ And Left(String$,1)<>";"
               Opcode$=StringField(String$,1,":")
               If Trim(Opcode$)="0004"
                If LCase(Trim(Right(String$,Len(String$)-Len(Opcode$)-1)))=LCase(Parameter(2))
                 NewPos=ListIndex(Code())+1
                 Break
                EndIf
               EndIf
              EndIf
            Next
            If NewPos=-1
             Error("Label not found ("+Parameter(2)+")!")
            Else
             Config\Line=NewPos-1
            EndIf
           EndIf
          Case $0016; Delay
           Delay(Val(ReplaceValues(Parameter(0))))
          Case $0017; Goto line
           Line=Val(ReplaceValues(Parameter(0)))
           If Line=>1 And Line<=ListSize(Code())
            Config\Line=Line-1
           Else
            Error("Invalid line (#"+Str(Line)+")")
           EndIf
          Case $0018; OpenWindow
           Flags=0
           ParentWindow=-1
           ID$=ReplaceValues(Parameter(7))
            If ID$
             If IsWindow(Val(ID$))
              ParentWindow=Val(ID$)
              ParentID=WindowID(ParentWindow)
              Error("Window not found!")
             EndIf
            EndIf
           For Flag=1 To CountString(Parameter(6),"|")+1
            Select UCase(StringField(Parameter(6),Flag,"|"))
             Case "SYSTEMMENU"
              Flags|#PB_Window_SystemMenu
             Case "TITLEBAR"
              Flags|#PB_Window_TitleBar
             Case "MINIMIZEGADGET"
              Flags|#PB_Window_MinimizeGadget
             Case "MAXIMIZEGADGET"
              Flags|#PB_Window_MaximizeGadget
             Case "SIZEGADGET"
              Flags|#PB_Window_SizeGadget
             Case "SCREENCENTERED"
              Flags|#PB_Window_ScreenCentered
             Case "PARENTCENTERED"
              Flags|#PB_Window_WindowCentered
             Case "INVISIBLE"
              Flags|#PB_Window_Invisible
             Case "DISABLEPARENT"
              If ParentWindow<>-1
               DisableWindow(Val(ID$),1)
              EndIf
            EndSelect
           Next
           Window=OpenWindow(#PB_Any,Val(ReplaceValues(Parameter(1))),Val(ReplaceValues(Parameter(2))),Val(ReplaceValues(Parameter(3))),Val(ReplaceValues(Parameter(4))),ReplaceValues(Parameter(5)),Flags,ParentID)
           SetVal(Parameter(0),Str(Window))
           AddElement(Window())
           Window()\ID=Window
           Config\CurrentWindow=Window
          Case $0019; DisableWindow
           ID$=ReplaceValues(Parameter(0))
            If ID$
             If IsWindow(Val(ID$))
              DisableWindow(Val(ID$),Val(ReplaceValues(Parameter(1))))
             Else
              Error("Window not found!")
             EndIf
            EndIf
          Case $001A; WindowEvent
           SetVal(Parameter(0),Str(WindowEvent()))
          Case $001B; Create gadget
           If Config\CurrentWindow=-1
            Error("No current window!")
           Else
            Found=0
            ForEach Window()
             If Window()\ID=Config\CurrentWindow
              If IsWindow(Window()\ID)
               If Window()\HasGadgetList
                Found=1
               Else
                If UseGadgetList(WindowID(Window()\ID))
                 Window()\HasGadgetList=1
                 Found=1
                EndIf
               EndIf
              EndIf
             EndIf
            Next
            If Found
             Gadget=Val(ReplaceValues(Parameter(1)))
             x=Val(ReplaceValues(Parameter(2)))
             y=Val(ReplaceValues(Parameter(3)))
             Width=Val(ReplaceValues(Parameter(4)))
             Height=Val(ReplaceValues(Parameter(5)))
             Select LCase(Trim(ReplaceValues(Parameter(0))))
              Case "button"
               ButtonGadget(Gadget,x,y,Width,Height,ReplaceValues(Parameter(6)))
              Case "buttonimage"
               Image=Val(ReplaceValues(Parameter(6)))
                If IsImage(Image)
                 ButtonImageGadget(Gadget,x,y,Width,Height,ImageID(Image))
                Else
                 Error("Image not found!")
                EndIf
              Case "calendar"
               CalendarGadget(Gadget,x,y,Width,Height)
              Case "text"
               TextGadget(Gadget,x,y,Width,Height,ReplaceValues(Parameter(6)))
              Default
               Error("Invalid gadget!")
             EndSelect
            Else
             Error("Window not found!")
            EndIf
           EndIf
          Case $001C; Use window
           Window=Val(Replacevalues(Parameter(0)))
            If IsWindow(Window)
             Config\CurrentWindow=Window
            EndIf
          Case $001D; Get current line
           SetVal(Parameter(0),Str(Config\Line))
          Case $001E; Event
           Select UCase(ReplaceValues(Parameter(1)))
            Case "GADGET"
             SetVal(Parameter(0),Str(EventGadget()))
            Case "MENU"
             SetVal(Parameter(0),Str(EventMenu()))
            Case "WINDOW"
             SetVal(Parameter(0),Str(EventWindow()))
            Case "TYPE"
             SetVal(Parameter(0),Str(EventType()))
            Default
             Error("Unknown eventtype!")
           EndSelect
          Case $001F; ResizeGadget
           Gadget=Val(ReplaceValues(Parameter(0)))
            If IsGadget(Gadget)
             ResizeGadget(Gadget,Val(ReplaceValues(Parameter(1))),Val(ReplaceValues(Parameter(2))),Val(ReplaceValues(Parameter(3))),Val(ReplaceValues(Parameter(4))))
            Else
             Error("Gadget not found!")
            EndIf
          Case $0020; Window position and size
           Window=Val(ReplaceValues(Parameter(1)))
            If IsWindow(Window)
             Select UCase(ReplaceValues(Parameter(2)))
              Case "X"
               Result=WindowX(Window)
              Case "Y"
               Result=WindowY(Window)
              Case "WIDTH"
               Result=WindowWidth(Window)
              Case "HEIGHT"
               Result=WindowHeight(Window)
              Default
               Error("Invalid sizetype!")
             EndSelect
             SetVal(Parameter(0),Str(Result))
            Else
             Error("Window not found!")
            EndIf
          Case $0021; Random
           SetVal(Parameter(0),Str(RandomEx(Val(ReplaceValues(Parameter(1))),Val(ReplaceValues(Parameter(2))))))
          Case $0022; UpdateGTASAProcess
           UpdateGTASAProcess()
          Case $0023; SetGadgetText
           Gadget=Val(Parameter(0))
            If IsGadget(Gadget)
             SetGadgetText(Gadget,ReplaceValues(Parameter(1)))
            Else
             Error("Gadget not found!")
            EndIf
          Case $0024; GetGadgetText
           Gadget=Val(Parameter(1))
            If IsGadget(Gadget)
             SetVal(Parameter(0),GetGadgetText(Gadget))
            Else
             Error("Gadget not found!")
            EndIf
          Case $0025; Custom error
           Error(ReplaceValues(Parameter(0)))
          Case $0026; Parameter
           File$=StringField(Common\Parameter,1,"|")
           SetVal(Parameter(0),Mid(Common\Parameter,Len(File$)+2))
          Case $0027; Load library
           File$=ReplaceValues(Parameter(1))
            If IsFileEx(File$)
             Dll=OpenLibrary(#PB_Any,File$)
              If IsLibrary(Dll)=0
               Dll=-1
              EndIf
            Else
             Dll=-1
            EndIf
           SetVal(ReplaceValues(Parameter(0)),Str(Dll))
          Case $0028; Call library function
           Dll=Val(ReplaceValues(Parameter(1)))
            If IsLibrary(Dll)
             SetVal(Parameter(0),Str(CallFunction(Dll,ReplaceValues(Parameter(2)),ReplaceValues(Parameter(3)))))
            Else
             SetVal(Parameter(0),"")
            EndIf
          Case $0029; Close library
           Dll=Val(ReplaceValues(Parameter(0)))
            If IsLibrary(Dll)
             CloseLibrary(Dll)
            EndIf
          Case $002A; Add systrayicon
           Window=Val(ReplaceValues(Parameter(1)))
           Image=Val(ReplaceValues(Parameter(2)))
           If IsWindow(Window)
            If IsImage(Image)
             SetVal(Parameter(0),Str(AddSysTrayIcon(#PB_Any,WindowID(Window),ImageID(Image))))
            Else
             Error("Image not found!")
            EndIf
           Else
            Error("Window not found!")
           EndIf
          Case $002B; Load image
           File$=Trim(ReplaceValues(Parameter(1)))
            If IsFileEx(File$)
             SetVal(Parameter(0),Str(LoadImage(#PB_Any,File$)))
            EndIf
          Case $002C; Check image
           SetVal(Parameter(0),Str(IsImage(Val(ReplaceValues(Parameter(1))))))
          Case $002D; Create menu
           Select UCase(Trim(ReplaceValues(Parameter(1))))
            Case "DEFAULT"
             Window=Val(ReplaceValues(Parameter(2)))
              If IsWindow(Window)
               SetVal(Parameter(0),Str(CreateMenu(#PB_Any,WindowID(Window))))
              Else
               Error("Window not found!")
              EndIf
            Case "POPUP"
             SetVal(Parameter(0),Str(CreatePopupMenu(#PB_Any)))
            Default
             Error("Invalid menutype!")
           EndSelect
          Case $002E; Check menu
           SetVal(Parameter(0),Str(IsMenu(Val(ReplaceValues(Parameter(1))))))
          Case $002F; display popup menu
           Menu=Val(ReplaceValues(Parameter(0)))
           Window=Val(ReplaceValues(Parameter(1)))
            If IsMenu(Menu)
             If IsWindow(Window)
              DisplayPopupMenu(Menu,WindowID(Window))
             Else
              Error("Window not found!")
             EndIf
            Else
             Error("Menu not found!")
            EndIf
          Case $0030; Menu item
           MenuItem(Val(ReplaceValues(Parameter(0))),ReplaceValues(Parameter(1)))
          Case $0031; Open submenu
           OpenSubMenu(ReplaceValues(Parameter(0)))
          Case $0032; Close submenu
           CloseSubMenu()
          Case $0034; Play sound
           PlaySound_(Replacevalues(Parameter(0)),Val(ReplaceValues(Parameter(1))),Val(Replacevalues(Parameter(2))))
          Default
           Error("Unknown opcode!")
         EndSelect
       EndIf
     EndIf
    Until Config\Line=>ListSize(Code()) Or Config\Stop
   Else
    MessageRequester("Error","Scriptfile not found!"+Chr(13)+Chr(13)+"File: "+File$,#MB_ICONERROR)
   EndIf
 EndIf