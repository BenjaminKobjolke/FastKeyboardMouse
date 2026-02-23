; ==================== CursorIndicator.ahk ====================
; Green dot overlay that follows the cursor when tool is active

CreateIndicator() {
	global IndicatorSize, IndicatorColor

	; Create a small GUI window: no caption, tool window, click-through (WS_EX_TRANSPARENT)
	Gui, Indicator:New, -Caption +ToolWindow +AlwaysOnTop +E0x20
	Gui, Indicator:Color, %IndicatorColor%

	; Make it the right size
	Gui, Indicator:Show, w%IndicatorSize% h%IndicatorSize% NoActivate Hide, IndicatorDot

	; Get the HWND and apply circular region
	Gui, Indicator:+LastFound
	indicatorHwnd := WinExist()

	; Create elliptic region for circular shape
	hRgn := DllCall("CreateEllipticRgn", "Int", 0, "Int", 0, "Int", IndicatorSize, "Int", IndicatorSize, "Ptr")
	DllCall("SetWindowRgn", "Ptr", indicatorHwnd, "Ptr", hRgn, "Int", 1)
}

ShowIndicator() {
	global TimerInterval
	Gui, Indicator:Show, NoActivate
	SetTimer, UpdateIndicatorPosition, %TimerInterval%
}

HideIndicator() {
	SetTimer, UpdateIndicatorPosition, Off
	Gui, Indicator:Hide
}

DestroyIndicator() {
	SetTimer, UpdateIndicatorPosition, Off
	Gui, Indicator:Destroy
}

UpdateIndicatorPosition:
	CoordMode, Mouse, Screen
	MouseGetPos, mX, mY
	newX := mX + IndicatorOffsetX
	newY := mY + IndicatorOffsetY
	Gui, Indicator:Show, x%newX% y%newY% NoActivate
return
