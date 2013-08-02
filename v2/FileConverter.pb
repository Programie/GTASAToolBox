Path$=GetPathPart(ProgramFilename())

File=ReadFile(#PB_Any,Path$+"MemoryChanger.bak")
 If IsFile(File)
  CloseFile(File)
  Select MessageRequester("FileConverter","The MemoryChanger file has already been converted!"+Chr(13)+"Skip it?",#MB_YESNOCANCEL|#MB_ICONWARNING)
   Case #PB_MessageRequester_Yes
    ConvertMemoryChanger=#False
   Case #PB_MessageRequester_No
    ConvertMemoryChanger=#True
   Case #PB_MessageRequester_Cancel
    End
  EndSelect
 Else
  ConvertMemoryChanger=#True
 EndIf
If ConvertMemoryChanger
 RenameFile(Path$+"MemoryChanger.dat",Path$+"MemoryChanger.bak")
 File=ReadFile(#PB_Any,Path$+"MemoryChanger.bak")
  If IsFile(File)
   File2=CreateFile(#PB_Any,Path$+"MemoryChanger.dat")
    If IsFile(File2)
     Repeat
      Name$=Trim(ReadString(File))
      Address=ReadLong(File)
      DataType=ReadByte(File)
      WriteStringN(File2,Name$+Chr(9)+Str(Address)+Chr(9)+Str(DataType))
     Until Eof(File)
     CloseFile(File2)
    EndIf
   CloseFile(File)
  EndIf
EndIf

RenameFile(Path$+"Cheats.clf",Path$+"Cheats.bak")
File=ReadFile(#PB_Any,Path$+"Cheats.bak")
 If IsFile(File)
  File2=CreateFile(#PB_Any,Path$+"Cheats.dat")
   If IsFile(File2)
    Repeat
     Line$=Trim(ReadString(File))
      If Line$
       Select LCase(Line$)
        Case "; cheatlist"
         IsCheatlist=#True
        Case "; teleportlist"
         IsCheatlist=#False
        Default
         If Left(Line$,1)<>";" And IsCheatlist
          WriteStringN(File2,StringField(Line$,1,"|")+Chr(9)+StringField(Line$,2,"|")+Chr(9)+StringField(Line$,3,"|"))
         EndIf
       EndSelect
      EndIf
     Until Eof(File)
     CloseFile(File2)
    EndIf
   CloseFile(File)
  EndIf

RenameFile(Path$+"Teleporter.clf",Path$+"Teleporter.bak")
File=ReadFile(#PB_Any,Path$+"Teleporter.bak")
 If IsFile(File)
  File2=CreateFile(#PB_Any,Path$+"Teleporter.dat")
   If IsFile(File2)
    ID=0
    Repeat
     Line$=Trim(ReadString(File))
      If Line$
       Select LCase(Line$)
        Case "; cheatlist"
         IsTeleportlist=#False
        Case "; teleportlist"
         IsTeleportlist=#True
        Default
         If Left(Line$,1)<>";" And IsTeleportlist
          Pos$=StringField(Line$,1,"|")
          PosX$=StringField(Pos$,1,";")
          PosY$=StringField(Pos$,2,";")
          PosZ$=StringField(Pos$,3,";")
          ID+1
          WriteStringN(File2,Str(ID)+Chr(9)+StringField(Line$,2,"|")+Chr(9)+PosX$+Chr(9)+PosY$+Chr(9)+PosZ$+Chr(9)+StringField(Line$,3,"|"))
         EndIf
       EndSelect
      EndIf
     Until Eof(File)
     CloseFile(File2)
    EndIf
   CloseFile(File)
  EndIf