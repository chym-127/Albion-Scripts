albionTitle := "Albion Online Client"

APP_X := 0
APP_Y := 0
APP_W := 0
APP_H := 0

targetX := 0
targetY := 0
targetX1 := 0
targetY1 := 0

start_sec := 0
is_loging := false
; 1024 768
; 612 545
; 循环采集木材
LoopFunc()
{
    if WinExist(albionTitle)
        WinActivate ;
    Sleep(100)
    Click targetX, targetY
    Sleep(3000)
    Click targetX1, targetY1
    Sleep(3000)
    Send "{Up}"
    Sleep(150)
    Send "{Down}"
    Sleep(150)
    Sleep(Random(500, 1000))

    global start_sec
    If (A_TickCount - start_sec >= 30 * 60 * 1000) {
        If (CheckIsLogout()) {
            LoginGame()
            start_sec := A_TickCount
        }
    }

}

; 登入游戏
LoginGame() {
    global is_loging, APP_X, APP_Y, APP_W, APP_H
    If (is_loging) {
        ToolTip
        (
            "正在登录..."
        )
        return
    }
    if WinExist(albionTitle)
        WinActivate ;
    Sleep(500)
    is_loging := true
    WinGetPos &APP_X, &APP_Y, &APP_W, &APP_H, albionTitle
    Click 10, 10
    Sleep(200)
    Click 612, 545
    Sleep(4000)
    Click 10, 10
    Sleep(200)
    Click 685, 628
    Sleep(4000)
    is_loging := false
}

; 检测是否被登出
CheckIsLogout() {
    WinGetPos &APP_X, &APP_Y, &APP_W, &APP_H, albionTitle
    current := ""
    x := 10
    y := 60
    pre := PixelGetColor(x, y)
    found := True
    Loop 20
    {
        x := 10 + A_Index * 2
        current := PixelGetColor(x, y)
        If (current != pre) {
            found := False
            Break
        }
        pre := current
    }
    Return found
}

F4::
{
    SetTimer LoopFunc, 0
}

F2::
{
    Global targetX, targetY, targetX1, targetY1
    if WinExist(albionTitle)
        WinActivate ;
    Sleep(200)

    ToolTip
    (
        "请选择第一颗树"
    )
    KeyWait "LButton", "D"
    MouseGetPos &targetX, &targetY
    Sleep(200)

    ToolTip
    (
        "请选择第二颗树"
    )
    KeyWait "LButton", "D"
    MouseGetPos &targetX1, &targetY1
    Sleep(200)

    ToolTip()

    global start_sec
    start_sec := A_TickCount
    SetTimer LoopFunc, 1000
}

F3::
{

    LoginGame()
}


F5::
{
    MouseGetPos &x, &y
    ToolTip
    (
        Format("{1},{2}", x, y)
    )
}

^ESC:: ExitApp