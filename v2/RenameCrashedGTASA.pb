#Old="GTA: San Andreas"
#New=#Old+" (Renamed)"
ID=FindWindow_(0,#Old)
 If ID
  SetWindowText_(ID,#New)
 EndIf