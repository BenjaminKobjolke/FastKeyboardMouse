; ==================== MouseController.ahk ====================
; Timer-based mouse movement, click/drag handlers, scroll, double-click

; Track state for click/drag and double-click
global LeftButtonHeld := false
global RightButtonHeld := false
global MiddleButtonHeld := false
global LastLeftClickTime := 0

StartMoveTimer() {
	global TimerInterval
	SetTimer, MoveTimerTick, %TimerInterval%
}

StopMoveTimer() {
	SetTimer, MoveTimerTick, Off
}

; ==================== Movement Timer ====================

MoveTimerTick:
	; Poll direction keys using GetKeyState
	dx := 0
	dy := 0

	if (GetKeyState(MoveLeft, "P"))
		dx -= 1
	if (GetKeyState(MoveRight, "P"))
		dx += 1
	if (GetKeyState(MoveUp, "P"))
		dy -= 1
	if (GetKeyState(MoveDown, "P"))
		dy += 1

	; Nothing to move
	if (dx = 0 && dy = 0)
		return

	; Normalize diagonal speed (multiply by ~0.707)
	if (dx != 0 && dy != 0)
	{
		dx := dx * 0.707
		dy := dy * 0.707
	}

	; Apply base speed
	speed := BaseSpeed

	; Apply shift multiplier if speed modifier is held
	if (GetKeyState(SpeedModifier, "P"))
		speed := speed * ShiftMultiplier

	dx := dx * speed
	dy := dy * speed

	; Get current mouse position
	CoordMode, Mouse, Screen
	MouseGetPos, curX, curY

	; Calculate new position
	newX := Round(curX + dx)
	newY := Round(curY + dy)

	; Clamp to virtual screen bounds (multi-monitor safe)
	SysGet, vsLeft, 76
	SysGet, vsTop, 77
	SysGet, vsWidth, 78
	SysGet, vsHeight, 79
	vsRight := vsLeft + vsWidth - 1
	vsBottom := vsTop + vsHeight - 1

	if (newX < vsLeft)
		newX := vsLeft
	if (newX > vsRight)
		newX := vsRight
	if (newY < vsTop)
		newY := vsTop
	if (newY > vsBottom)
		newY := vsBottom

	; Move the mouse
	MouseMove, %newX%, %newY%, 0
return

; ==================== Click Handlers ====================

LeftClickDown:
	now := A_TickCount
	elapsed := now - LastLeftClickTime
	LastLeftClickTime := now

	; Double-click detection: if second press within threshold
	if (elapsed < DoubleTapThreshold && elapsed > 0)
	{
		; Release any held click first
		if (LeftButtonHeld)
		{
			MouseClick, Left,,, 1, 0, U
			LeftButtonHeld := false
		}
		; Fire double-click
		MouseClick, Left,,, 2
		; Reset to prevent triple-click
		LastLeftClickTime := 0
		return
	}

	; Normal press-down (for click or drag)
	MouseClick, Left,,, 1, 0, D
	LeftButtonHeld := true
return

LeftClickUp:
	if (LeftButtonHeld)
	{
		MouseClick, Left,,, 1, 0, U
		LeftButtonHeld := false
	}
return

RightClickDown:
	MouseClick, Right,,, 1, 0, D
	RightButtonHeld := true
return

RightClickUp:
	if (RightButtonHeld)
	{
		MouseClick, Right,,, 1, 0, U
		RightButtonHeld := false
	}
return

MiddleClickDown:
	MouseClick, Middle,,, 1, 0, D
	MiddleButtonHeld := true
return

MiddleClickUp:
	if (MiddleButtonHeld)
	{
		MouseClick, Middle,,, 1, 0, U
		MiddleButtonHeld := false
	}
return

; ==================== Scroll Handlers ====================

ScrollUpAction:
	MouseClick, WheelUp,,, 3
return

ScrollDownAction:
	MouseClick, WheelDown,,, 3
return

; ==================== Center Cursor Handler ====================

CenterCursorAction:
	WinGetPos, winX, winY, winW, winH, A
	if (winW > 0 && winH > 0)
	{
		centerX := Round(winX + winW / 2)
		centerY := Round(winY + winH / 2)
		CoordMode, Mouse, Screen
		MouseMove, %centerX%, %centerY%, 0
	}
return

; ==================== Key Suppression ====================

SuppressKey:
	; Empty handler - exists only to consume movement keypresses
	; so they don't reach the active application
return
