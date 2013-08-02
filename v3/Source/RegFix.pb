Enumeration
	#RunOnlyOnceCheckWindow
EndEnumeration

#Title="RegFix"

IncludeFile "Includes\Common.pbi"

SetRegGTASAFile(GetRegGTASAFile())

MessageRequester(#Title,"RegFix OK")
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 10
; EnableXP