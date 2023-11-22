#NoEnv
SendMode Input
; SetWorkingDir %A_ScriptDir%

#Include Lib\VA.ahk

#SingleInstance, Force

audioMeter := VA_GetAudioMeter()

greenBarColor = 0x437922
redBarColor = 0xd3420d
blueBarColor = 0x2a5790

mode = 1
pulling = 1

spot1X = 0
spot1Y = 0
spot2X = 0
spot2Y = 0
spot3X = 0
spot3Y = 0

moveCount = 1
collecting := False
current := 0
start_sec := 0
end_sec := 0
actions := Array()
steps := []
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
        ToolTip, End Collect
        FileDelete, actions.txt
        If (actions[actions.Length()][1] = "Click")
        {
            actions[actions.Length()][2] := 200
        }
        For i,val in actions
        {
            Str := ""
            For j,item in val
            {
                Str .= "-" . item
            }
            Str := LTrim(Str, "-")
            Str .= "`n"
            FileAppend, % Str , actions.txt
        }
        collecting := False
    }
    Else
    {
        ToolTip, Start Collect
        moveCount = 1
        actions := Array()
        collecting := True
        start_sec := A_TickCount
    }
Return

F2::
    global start_sec,end_sec,actions,moveCount
    If !collecting
    {
        ToolTip, "Pree F1"
        Return
    }

    ToolTip, "Move Action"
    MouseGetPos, xpos, ypos
    sec := A_TickCount
    temp := ["Click",sec,xpos,ypos]
    actions.Push(temp)
    If (moveCount>1){
        ; MsgBox, % moveCount
        ; MsgBox, % actions[moveCount-1][1]
        If (actions[moveCount-1][1] = "Click")
        {
            s := actions[moveCount-1][2]
            actions[moveCount-1][2] := sec - s
        }else{
            actions[moveCount][2] := A_TickCount
        }
    }
    moveCount++
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
    temp := ["Fishing",spot1X,spot1Y,spot2X,spot2Y]
    actions.Push(temp)

    If (actions[moveCount-1][1] = "Click")
    {
        actions[moveCount-1][2] := 200
    }
    moveCount++
Return

F4::
    steps := []
    step := []
    Loop, read, actions.txt
    {
        Loop, Parse, A_LoopReadLine, `-
        {
            str := A_LoopField
            step.Push(str)
        }
        steps.Push(step)
        step := []
    }
    currentStepIndex = 1
    Loop
    {
        currentStep := steps[currentStepIndex]
        cmd := currentStep[1]
        If (cmd = "Click")
        {
            sec := currentStep[2]
            xpos := currentStep[3]
            ypos := currentStep[4]
            ToolTip, Click,xpos,ypos
            Sleep sec
        }else{
            spot1X := currentStep[2]
            spot1Y := currentStep[3]
            spot2X := currentStep[4]
            spot2Y := currentStep[5]
            ToolTip, Fishing
            Sleep 1000
            ; Fishing()
        }

        currentStepIndex++
        If (currentStepIndex > steps.Length())
        {
            Return
        }
    }
Return

RemoveToolTip:
    ToolTip
return

checkIfPulling:
    PixelSearch Px, Py, 840, 588, 840, 588, %blueBarColor%, 30, RGB
    if ErrorLevel
        pulling = 0
return

Fishing()
{
    maxLoop = 0
    loopCount = 0
    modeCount = 0

    currentSpotX = %spot1X%
    currentSpotY = %spot1Y%

    Loop
    { 
        Random, rand, -20, 20
        thisX := currentSpotX + rand
        thisY := currentSpotY + rand

        Click %thisX%, %thisY%, down
        Random, rand, 850, 1050
        Sleep %rand%
        Click up

        Sleep 2000

        k = 0
        Loop
        { 
            k++
            if k > 300000
                break
            VA_IAudioMeterInformation_GetPeakValue(audioMeter, peakValue)
            if peakValue > 0.011
            {
                Random, rand, 0, 450
                Sleep %rand%
                break
            }
        }

        Click

        ;Sleep required for the correct behave of the exit loop checker, keep over 0.4s
        Sleep 300

        pulling = 1
        SetTimer, checkIfPulling, -1
        SetTimer, checkIfPulling, 100

        Sleep 200

        while pulling
        {
            if !pulling
                break

            Click down

            Loop
            {
                if !pulling
                    break

                PixelSearch Px, Py, 990, 554, 990, 554, %greenBarColor%, 50, RGB
                if ErrorLevel
                    break
            }

            Click up
            Sleep 100
        }

        SetTimer, checkIfPulling, Delete

        ; if loopCount = 12
        ; {
        ;     useFishBait()
        ;     loopCount = 0
        ; }
        ; else
        ;     loopCount++

        if (modeCount = 4)
        {
            currentSpotX = %spot2X%
            currentSpotY = %spot2Y%
        }
        if (modeCount = 8)
        {
            currentSpotX = %spot1X%
            currentSpotY = %spot1Y%
            modeCount = 0
        }

        modeCount++
        maxLoop++

        Random, rand, 4500, 6000
        Sleep %rand%

        If (maxLoop>=15)
        {
            Return
        }
    }
}

useFishBait()
{

    Sleep 200
    MouseGetPos, xpos, ypos
    Send {1}
    Sleep 1400
    Send {i}
    Sleep 200
    Click 1590, 555, Right
    Sleep 200
    Send {i}
    Sleep 200
    MouseMove %xpos%, %ypos%
}

F7::
    {
        ExitApp
    }