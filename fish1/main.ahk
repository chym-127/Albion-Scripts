#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

F8::
    Run, FishbotKEKW.exe
    ToolTip, Open FishbotKEKW
    Sleep, 1000
    ToolTip
Return

F12::
ExitApp
Return