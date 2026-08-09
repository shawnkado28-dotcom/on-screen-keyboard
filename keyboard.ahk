#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; =========================================================
; SETTINGS
; =========================================================

normalColor := 0x252525
pressedColor := 0x00AFFF
textColor := 0xFFFFFF

keyW := 42
keyH := 35
gap := 3

overlayVisible := true

; =========================================================
; KEYBOARD LAYOUT
; =========================================================

rows := [
    ["Esc","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"],
    ["``","1","2","3","4","5","6","7","8","9","0","-","=","Backspace"],
    ["Tab","Q","W","E","R","T","Y","U","I","O","P","[","]","\"],
    ["Caps","A","S","D","F","G","H","J","K","L",";","'","Enter"],
    ["Shift","Z","X","C","V","B","N","M",",",".","/","Shift"],
    ["Ctrl","Win","Alt","Space","Alt","Ctrl"]
]

; =========================================================
; KEY DETECTION
; =========================================================

keyStates := Map(
    "Esc", "Escape",

    "F1", "F1",
    "F2", "F2",
    "F3", "F3",
    "F4", "F4",
    "F5", "F5",
    "F6", "F6",
    "F7", "F7",
    "F8", "F8",
    "F9", "F9",
    "F10", "F10",
    "F11", "F11",
    "F12", "F12",

    "``", "``",

    "1", "1",
    "2", "2",
    "3", "3",
    "4", "4",
    "5", "5",
    "6", "6",
    "7", "7",
    "8", "8",
    "9", "9",
    "0", "0",

    "-", "-",
    "=", "=",
    "Backspace", "Backspace",

    "Tab", "Tab",

    "Q", "q",
    "W", "w",
    "E", "e",
    "R", "r",
    "T", "t",
    "Y", "y",
    "U", "u",
    "I", "i",
    "O", "o",
    "P", "p",

    "[", "[",
    "]", "]",
    "\", "\",

    "Caps", "CapsLock",

    "A", "a",
    "S", "s",
    "D", "d",
    "F", "f",
    "G", "g",
    "H", "h",
    "J", "j",
    "K", "k",
    "L", "l",

    ";", ";",
    "'", "'",
    "Enter", "Enter",

    "Shift", "Shift",

    "Z", "z",
    "X", "x",
    "C", "c",
    "V", "v",
    "B", "b",
    "N", "n",
    "M", "m",

    ",", ",",
    ".", ".",
    "/", "/",

    "Ctrl", "Ctrl",
    "Win", "LWin",
    "Alt", "Alt",
    "Space", "Space"
)

; =========================================================
; BUILD KEY POSITIONS
; =========================================================

keyInfo := []

y := 8

for row in rows
{
    x := 8

    for keyName in row
    {
        width := keyW

        if (keyName = "Space")
            width := 210
        else if (keyName = "Backspace" || keyName = "Enter")
            width := 75
        else if (keyName = "Shift" || keyName = "Caps" || keyName = "Tab")
            width := 65
        else if (keyName = "Ctrl" || keyName = "Alt" || keyName = "Win")
            width := 50

        keyInfo.Push({
            name: keyName,
            x: x,
            y: y,
            w: width,
            h: keyH
        })

        x += width + gap
    }

    y += keyH + gap
}

; =========================================================
; MOUSE INPUT POSITIONS
; =========================================================

mouseInfo := [
    {name: "M1",       x: 8,   y: y + 8, w: 55, h: keyH},
    {name: "M2",       x: 66,  y: y + 8, w: 55, h: keyH},
    {name: "M3",       x: 124, y: y + 8, w: 55, h: keyH},
    {name: "M5",       x: 182, y: y + 8, w: 55, h: keyH},
    {name: "Scroll ↑", x: 240, y: y + 8, w: 85, h: keyH},
    {name: "Scroll ↓", x: 328, y: y + 8, w: 85, h: keyH}
]

guiHeight := y + keyH + 18

; =========================================================
; CREATE GUI
; =========================================================

myGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x08000000")
myGui.BackColor := "000000"

myGui.Show(
    "x10 y" (A_ScreenHeight - guiHeight - 35)
    " w720 h" guiHeight
)

hwnd := myGui.Hwnd

; Make black transparent
WinSetTransColor("000000", hwnd)

; =========================================================
; INITIAL DRAW
; =========================================================

RedrawEverything()

; =========================================================
; KEYBOARD UPDATE TIMER
; =========================================================

SetTimer(UpdateKeyboard, 10)

UpdateKeyboard()
{
    global keyInfo
    global keyStates
    global overlayVisible

    if !overlayVisible
        return

    static lastStates := Map()

    for key in keyInfo
    {
        name := key.name

        if !keyStates.Has(name)
            continue

        pressed := GetKeyState(keyStates[name], "P")

        if (!lastStates.Has(name) || lastStates[name] != pressed)
        {
            lastStates[name] := pressed

            if pressed
                DrawKey(key, 0x00AFFF)
            else
                DrawKey(key, 0x252525)
        }
    }
}

; =========================================================
; M1
; =========================================================

~LButton::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[1], 0x00AFFF)
}

~LButton Up::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[1], 0x252525)
}

; =========================================================
; M2
; =========================================================

~RButton::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[2], 0x00AFFF)
}

~RButton Up::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[2], 0x252525)
}

; =========================================================
; M3
; =========================================================

~MButton::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[3], 0x00AFFF)
}

~MButton Up::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[3], 0x252525)
}

; =========================================================
; M5
; =========================================================

~XButton2::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[4], 0x00AFFF)
}

~XButton2 Up::
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[4], 0x252525)
}

; =========================================================
; M4 TOGGLE
; =========================================================

XButton1::
{
    global myGui
    global overlayVisible

    overlayVisible := !overlayVisible

    if overlayVisible
    {
        myGui.Show()

        ; Give Windows a moment to restore the window
        Sleep(20)

        ; Completely redraw once after showing
        RedrawEverything()
    }
    else
    {
        ; Stop drawing before hiding
        myGui.Hide()
    }
}

; =========================================================
; SCROLL UP
; =========================================================

~WheelUp::
{
    global mouseInfo
    global overlayVisible

    if !overlayVisible
        return

    DrawKey(mouseInfo[5], 0x00AFFF)
    SetTimer(ScrollUpOff, -100)
}

ScrollUpOff()
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[5], 0x252525)
}

; =========================================================
; SCROLL DOWN
; =========================================================

~WheelDown::
{
    global mouseInfo
    global overlayVisible

    if !overlayVisible
        return

    DrawKey(mouseInfo[6], 0x00AFFF)
    SetTimer(ScrollDownOff, -100)
}

ScrollDownOff()
{
    global mouseInfo
    global overlayVisible

    if overlayVisible
        DrawKey(mouseInfo[6], 0x252525)
}

; =========================================================
; REDRAW EVERYTHING
; ONLY USED WHEN OVERLAY IS SHOWN
; =========================================================

RedrawEverything()
{
    global keyInfo
    global keyStates
    global mouseInfo
    global normalColor
    global pressedColor
    global overlayVisible

    if !overlayVisible
        return

    ; Keyboard
    for key in keyInfo
    {
        name := key.name

        if GetKeyState(keyStates[name], "P")
            DrawKey(key, pressedColor)
        else
            DrawKey(key, normalColor)
    }

    ; Mouse buttons
    for mouse in mouseInfo
        DrawKey(mouse, normalColor)
}

; =========================================================
; DRAW / REPLACE ONE KEY
; =========================================================

DrawKey(key, color)
{
    global hwnd
    global textColor
    global overlayVisible

    if !overlayVisible
        return

    hdc := DllCall(
        "GetDC",
        "Ptr", hwnd,
        "Ptr"
    )

    if !hdc
        return

    ; -----------------------------------------
    ; Draw key background
    ; -----------------------------------------

    brush := DllCall(
        "CreateSolidBrush",
        "UInt", color,
        "Ptr"
    )

    rect := Buffer(16, 0)

    NumPut("Int", key.x, rect, 0)
    NumPut("Int", key.y, rect, 4)
    NumPut("Int", key.x + key.w, rect, 8)
    NumPut("Int", key.y + key.h, rect, 12)

    DllCall(
        "FillRect",
        "Ptr", hdc,
        "Ptr", rect,
        "Ptr", brush
    )

    DllCall(
        "DeleteObject",
        "Ptr", brush
    )

    ; -----------------------------------------
    ; Draw text
    ; -----------------------------------------

    DllCall(
        "SetTextColor",
        "Ptr", hdc,
        "UInt", textColor
    )

    DllCall(
        "SetBkMode",
        "Ptr", hdc,
        "Int", 1
    )

    DllCall(
        "DrawText",
        "Ptr", hdc,
        "Str", key.name,
        "Int", StrLen(key.name),
        "Ptr", rect,
        "UInt", 0x25
    )

    DllCall(
        "ReleaseDC",
        "Ptr", hwnd,
        "Ptr", hdc
    )
}