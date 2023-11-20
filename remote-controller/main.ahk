#NoEnv
SetBatchLines, -1

#Include ./lib/WebSocket.ahk

x := new Example("ws://150.158.13.8:8080/ws")
return

class Example extends WebSocket
{
    OnOpen(Event)
    {
        ; InputBox, Data, WebSocket, Enter some text to send through the websocket.
        ; this.Send(Data)
    }

    OnMessage(Event)
    {
        CoordMode, Mouse,Screen
        str := Event.data
        StringSplit, arr, str, -
        switch arr1
        {
        case "ClickDown": 
            Click, Down
        case "ClickUp": 
            Click, Up
        case "MouseMove":
            MouseMove, arr2, arr3
			ToolTip, .
        }
        this.Close()
    }

    OnClose(Event)
    {
        ; MsgBox, Websocket Closed
        this.Disconnect()
    }

    OnError(Event)
    {
        ; MsgBox, Websocket Error
    }

    __Delete()
    {
        ; MsgBox, Exiting
        ExitApp
    }
}

Esc::
ExitApp
Return