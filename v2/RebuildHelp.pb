Path$=GetPathPart(ProgramFilename())+"Help\German\"

Input=ReadFile(#PB_Any,Path$+"ToolBox_Cheats.info")
 If IsFile(Input)
  Output=CreateFile(#PB_Any,Path$+"ToolBox_Cheats.htm")
   If IsFile(Output)
    WriteStringN(Output,"<html>")
    WriteStringN(Output," <body>")
    WriteStringN(Output,"  <table width=100% border=3>")
    WriteStringN(Output,"   <tr><td><b>&nbsp;Cheat&nbsp;</b></td><td><b>&nbsp;Name&nbsp;</b></td></tr>")
    Repeat
     String$=Trim(ReadString(Input))
      If String$ And Left(String$,1)<>";"
       WriteStringN(Output,"   <tr><td>&nbsp;"+Trim(StringField(String$,1,"|"))+"&nbsp;</td><td>&nbsp;"+Trim(StringField(String$,2,"|"))+"&nbsp;</td></tr>")
      EndIf
    Until Eof(Input)
    WriteStringN(Output,"  </table>")
    WriteStringN(Output," </body>")
    WriteStringN(Output,"</html>")
    CloseFile(Output)
    MessageRequester("HelpCompiler","Help compiled!",#MB_ICONINFORMATION)
   Else
    MessageRequester("Error","Can´t create outputfile!",#MB_ICONERROR)
   EndIf
  CloseFile(Input)
 Else
  MessageRequester("Error","No inputfile found!",#MB_ICONERROR)
 EndIf