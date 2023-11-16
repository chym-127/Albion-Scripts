collecting := False
current := 0
actions := Array()
LoopFunc()
{
    For action in actions
    {
        Send(
        Format("{{1} down}", action["KEY_CODE"])
        )
        Sleep(action["TIME"]*1)
        Send(
        Format("{{1} up}", action["KEY_CODE"])
        )
    }
}
F2::
    {
        global collecting,current,actions
        If (collecting)
        {
            Return
        } Else {
            collecting := True
        }
        actions := Array()
        Loop
        {

            ToolTip(
            "按下方向键"
            )
            ih := InputHook("L1", "{Left}{Right}{Up}{Down}{Space}")
            ih.Start()
            ih.Wait()
            start_sec := A_TickCount
            If (ih.EndKey == GetKeyName("Space"))
            {
                FileDelete("actions.txt")
                For action in actions
                {
                    FileAppend(Format("{1},{2}`n", action["KEY_CODE"],action["TIME"]), "actions.txt")
                }
                collecting := False
                ToolTip()
                Break
            }
            KeyWait ih.EndKey,"U"
            end_sec := A_TickCount

            actions.Push(
            Map("KEY_CODE", ih.EndKey, "TIME", end_sec-start_sec)
            )
            ToolTip(
            "按下鼠标左键"
            )
            KeyWait "LButton","D"
            start_sec := A_TickCount
            KeyWait "LButton","U"
            end_sec := A_TickCount

            actions.Push(
            Map("KEY_CODE", "LButton", "TIME", end_sec-start_sec)
            )
        }

    }

F3::
    {
        SetTimer(LoopFunc,200)
    }

F4::
    {
        SetTimer(LoopFunc,0)
    }

F5::
    {
        MouseGetPos &x, &y
        ToolTip
        (
        Format("{1},{2}", x, y)
        )
    }

Esc::
    {
        ExitApp
    }