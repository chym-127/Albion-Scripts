/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include Lib\VA.ahk

#SingleInstance, Force

audioMeter := VA_GetAudioMeter()

greenBarColor = 0x437922
redBarColor = 0xd3420d
blueBarColor = 0x2a5790
albionTitle = "Albion Online Client"

mode = 1
pulling = 1

spot1X = 0
spot1Y = 0

X = 0
Y = 0
W = 0
H = 0

blueBarX = 0
blueBarY = 0
greenBarX = 0
greenBarY = 0

Esc::ExitApp

F4::
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

                PixelSearch Px, Py, greenBarX, greenBarY, greenBarX, greenBarY, %greenBarColor%, 50, RGB
                if ErrorLevel
                    break
            }

            Click up
            Sleep 100
        }

        SetTimer, checkIfPulling, Delete

        if loopCount = 12
        {
            ; useFishBait()
            loopCount = 0
        }
        else
            loopCount++

        Random, rand, 4500, 6000
        Sleep %rand%
    }
return

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

; 选择钓鱼点
F3::
    mode = 1
    if WinExist(Albion Online Client)
    {
        WinGetPos, X, Y, W, H
        blueBarX = 840/1920*W
        blueBarY = 588/1080*H
        greenBarX = 990/1920*W
        greenBarY = 554/1080*H
    }
    MouseGetPos, spot1X, spot1Y
    Sleep 200
    Send {s}
    ToolTip , press F4 to start fishing!
    SetTimer, RemoveToolTip, -2500
return

F6::
    WinGetPos, X, Y, W, H, Albion Online Client
    ToolTip , %X%x%Y%`n%W%x%H%`n
return

F7::
    MouseGetPos, MouseX, MouseY
    PixelGetColor, color, %MouseX%, %MouseY%
    MsgBox The color at the current cursor position is %color%.
return

F2::
    Reload
return

RemoveToolTip:
    ToolTip
return

checkIfPulling:

    PixelSearch Px, Py, blueBarX, blueBarY, blueBarX, blueBarY, %blueBarColor%, 30, RGB
    if ErrorLevel
        pulling = 0

return