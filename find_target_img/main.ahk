; F2::
;     {
;         CoordMode "Pixel" ; Interprets the coordinates below as relative to the screen rather than the active window's client area.
;         try
;         {
;             if ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "image.png")
;                 MsgBox "The icon was found at " FoundX "x" FoundY
;             else
;                 MsgBox "Icon could not be found on the screen."
;         }
;         catch as exc
;             MsgBox "Could not conduct the search due to the following error:`n" exc.Message
;     }
collecting := False
current := 0
actions := Array()
F2::
    {
        global collecting,current
        If (collecting)
        {
            Return
        } Else {
            collecting := True
        }
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
                ToolTip
                (
                actions
                )
                collecting := False
                Break
            }
            KeyWait ih.EndKey,"U"
            end_sec := A_TickCount

            actions.Push(
            Map("KEY_CODE", ih.EndKey, "TIME", end_sec-start_sec)
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
        global collecting
        collecting := False
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