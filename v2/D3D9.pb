; Compile this file as Shared Dll

Global Dll

Procedure Load(Instance,Type)
 Select Type
  Case 1
   Type$="process"
  Case 2
   Type$="thread"
  Default
   Type$="unknown"
 EndSelect
 ;MessageRequester("Load","Attached by "+Str(Instance)+" as "+Type$)
 Dll=OpenLibrary(#PB_Any,"C:\Windows\System32\d3d9.dll")
EndProcedure

Procedure Unload(Instance,Type)
 Select Type
  Case 1
   Type$="process"
  Case 2
   Type$="thread"
  Default
   Type$="unknown"
 EndSelect
 ;MessageRequester("Unload","Detached by "+Str(Instance)+" as "+Type$)
 If IsLibrary(Dll)
  CloseLibrary(Dll)
 EndIf
EndProcedure

ProcedureDLL AttachProcess(Instance)
 Load(Instance,1)
EndProcedure

ProcedureDLL AttachThread(Instance)
 Load(Instance,2)
EndProcedure

ProcedureDLL DetachProcess(Instance)
 Unload(Instance,1)
EndProcedure

ProcedureDLL DetachThread(Instance)
 Unload(Instance,2)
EndProcedure

ProcedureDLL D3DPERF_BeginEvent(Par1,Par2)
 ;MessageRequester("D3DPERF_BeginEvent","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"D3DPERF_BeginEvent",Par1,Par2)
 EndIf
EndProcedure

ProcedureDLL D3DPERF_EndEvent()
 ;MessageRequester("D3DPERF_EndEvent","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"D3DPERF_EndEvent")
 EndIf
EndProcedure

ProcedureDLL D3DPERF_GetStatus()
 ;MessageRequester("D3DPERF_GetStatus","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"D3DPERF_GetStatus")
 EndIf
EndProcedure

ProcedureDLL D3DPERF_QueryRepeatFrame()
 ;MessageRequester("D3DPERF_QueryRepeatFrame","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"D3DPERF_QueryRepeatFrame")
 EndIf
EndProcedure

ProcedureDLL D3DPERF_SetMarker(Par1,Par2)
 ;MessageRequester("D3DPERF_SetMarker","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"D3DPERF_SetMarker",Par1,Par2)
 EndIf
EndProcedure

ProcedureDLL D3DPERF_SetOptions(Par)
 ;MessageRequester("D3DPERF_SetOptions","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"D3DPERF_SetOptions",Par)
 EndIf
EndProcedure

ProcedureDLL D3DPERF_SetRegion(Par1,Par2)
 ;MessageRequester("D3DPERF_SetRegion","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"D3DPERF_SetRegion",Par1,Par2)
 EndIf
EndProcedure

ProcedureDLL DebugSetLevel()
 ;MessageRequester("DebugSetLevel","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"DebugSetLevel")
 EndIf
EndProcedure

ProcedureDLL DebugSetMute()
 ;MessageRequester("DebugSetMute","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"DebugSetMute")
 EndIf
EndProcedure

ProcedureDLL Direct3DCreate9(Par)
 ;MessageRequester("Direct3DCreate9","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"Direct3DCreate9",Par)
 EndIf
EndProcedure

ProcedureDLL Direct3DCreate9Ex()
 ;MessageRequester("Direct3DCreate9Ex","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"Direct3DCreate9Ex")
 EndIf
EndProcedure

ProcedureDLL Direct3DShaderValidatorCreate9()
 ;MessageRequester("Direct3DShaderValidatorCreate9","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"Direct3DShaderValidatorCreate9")
 EndIf
EndProcedure

ProcedureDLL PSGPError()
 ;MessageRequester("PSGPError","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"PSGPError")
 EndIf
EndProcedure

ProcedureDLL PSGPSampleTexture()
 ;MessageRequester("PSGPSampleTexture","Function called!")
 If IsLibrary(Dll)
  ProcedureReturn CallFunction(Dll,"PSGPSampleTexture")
 EndIf
EndProcedure