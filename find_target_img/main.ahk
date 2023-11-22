collecting := False
current := 0
start_sec := 0
end_sec := 0
actions := []
; LoopFunc()
; {
;     For action in actions
;     {
;         Send(
;         Format("{{1} down}", action["KEY_CODE"])
;         )
;         Sleep(action["TIME"]*1)
;         Send(
;         Format("{{1} up}", action["KEY_CODE"])
;         )
;     }
; }
F1::
    global start_sec,end_sec,action
    If collecting
    {
        FileDelete, actions.txt
        For action,val in actions
        {
            str := Format("{1}`n", val)
            MsgBox, % str
            FileAppend, % str, actions.txt
        }
        collecting := False
    }
    Else
    {
        ToolTip, Start Collect
        collecting := True
        start_sec := A_TickCount
    }
Return

F2::
    global start_sec,end_sec,actions
    If !collecting
    {
        ToolTip, "Pree F1"
        Return
    }
    ToolTip, "Move Action"
    MouseGetPos, xpos, ypos
    end_sec := A_TickCount
    sec := end_sec-start_sec
    str := Format("{1}-{2}-{3}-{4}", "Click",sec,xpos,ypos)
    actions.Push(str)
    start_sec := A_TickCount
Return

F3::
    global start_sec,end_sec,actions
    If !collecting
    {
        ToolTip, "Pree F1"
        Return
    }
    ToolTip, "Fishing Action"
    Sleep, 200
    mode = 2
    ToolTip , Click on the first spot...
    KeyWait, LButton, D
    MouseGetPos, spot1X, spot1Y
    Sleep 200
    Send {s}
    ToolTip , Click on the second spot...
    KeyWait, LButton, D
    MouseGetPos, spot2X, spot2Y
    Sleep 200
    Send {s}
    SetTimer, RemoveToolTip, -2500
    actions.Push(Format("{1}-{2}-{3}-{4}-{5}", "Fishing",spot1X,spot1Y,spot2X,spot2Y))
Return

RemoveToolTip:
    ToolTip
return

Esc::
    {
        ExitApp
    }