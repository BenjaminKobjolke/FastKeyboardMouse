; ==================== Config.ahk ====================
; Configuration loading, saving, and global variables

; INI file path
global IniFile := ""

; Settings
global DarkMode := 1
global BaseSpeed := 10
global ShiftMultiplier := 2
global TimerInterval := 16
global IndicatorSize := 10
global IndicatorColor := "00FF00"
global IndicatorOffsetX := 15
global IndicatorOffsetY := 15
global DoubleTapThreshold := 300
global StartWithWindows := 0

; Key bindings
global ToggleKey := "!q"
global MoveUp := "k"
global MoveDown := "j"
global MoveLeft := "h"
global MoveRight := "l"
global LeftClick := "a"
global RightClick := "d"
global MiddleClick := "s"
global ScrollUp := "i"
global ScrollDown := "u"
global SpeedModifier := "Shift"

; Runtime state
global ToolActive := false
global IconPath := ""
global IconIndex := 0
global ShowGuiOnStart := false

; Track registered hotkeys for cleanup
global RegisteredHotkeys := []

InitConfig() {
	global

	; Get script name without extension for INI file
	SplitPath, A_ScriptName,, , , ScriptNameNoExt
	IniFile := A_ScriptDir . "\" . ScriptNameNoExt . ".ini"

	; Read settings
	IniRead, tmp, %IniFile%, Settings, DarkMode, 1
	DarkMode := tmp
	IniRead, tmp, %IniFile%, Settings, BaseSpeed, 10
	BaseSpeed := tmp
	IniRead, tmp, %IniFile%, Settings, ShiftMultiplier, 2
	ShiftMultiplier := tmp
	IniRead, tmp, %IniFile%, Settings, TimerInterval, 16
	TimerInterval := tmp
	IniRead, tmp, %IniFile%, Settings, IndicatorSize, 10
	IndicatorSize := tmp
	IniRead, tmp, %IniFile%, Settings, IndicatorColor, 00FF00
	IndicatorColor := tmp
	IniRead, tmp, %IniFile%, Settings, IndicatorOffsetX, 15
	IndicatorOffsetX := tmp
	IniRead, tmp, %IniFile%, Settings, IndicatorOffsetY, 15
	IndicatorOffsetY := tmp
	IniRead, tmp, %IniFile%, Settings, DoubleTapThreshold, 300
	DoubleTapThreshold := tmp
	IniRead, tmp, %IniFile%, Settings, StartWithWindows, 0
	StartWithWindows := tmp

	; Read key bindings
	IniRead, tmp, %IniFile%, Keys, ToggleKey, !q
	ToggleKey := tmp
	IniRead, tmp, %IniFile%, Keys, MoveUp, k
	MoveUp := tmp
	IniRead, tmp, %IniFile%, Keys, MoveDown, j
	MoveDown := tmp
	IniRead, tmp, %IniFile%, Keys, MoveLeft, h
	MoveLeft := tmp
	IniRead, tmp, %IniFile%, Keys, MoveRight, l
	MoveRight := tmp
	IniRead, tmp, %IniFile%, Keys, LeftClick, a
	LeftClick := tmp
	IniRead, tmp, %IniFile%, Keys, RightClick, d
	RightClick := tmp
	IniRead, tmp, %IniFile%, Keys, MiddleClick, s
	MiddleClick := tmp
	IniRead, tmp, %IniFile%, Keys, ScrollUp, i
	ScrollUp := tmp
	IniRead, tmp, %IniFile%, Keys, ScrollDown, u
	ScrollDown := tmp
	IniRead, tmp, %IniFile%, Keys, SpeedModifier, Shift
	SpeedModifier := tmp

	; Set icon path based on theme
	if (A_IsCompiled)
	{
		IconPath := A_ScriptFullPath
		IconIndex := 1
	}
	else
	{
		IconDir := A_ScriptDir . "\data"
		if (DarkMode = 1)
			IconPath := IconDir . "\icon_light.ico"
		else
			IconPath := IconDir . "\icon_dark.ico"
		IconIndex := 0
	}

	; Check for command line arguments
	ShowGuiOnStart := false
	for n, arg in A_Args
	{
		if (arg = "--gui" || arg = "-g")
			ShowGuiOnStart := true
	}
}

SaveConfig() {
	global

	; Save settings
	IniWrite, %DarkMode%, %IniFile%, Settings, DarkMode
	IniWrite, %BaseSpeed%, %IniFile%, Settings, BaseSpeed
	IniWrite, %ShiftMultiplier%, %IniFile%, Settings, ShiftMultiplier
	IniWrite, %TimerInterval%, %IniFile%, Settings, TimerInterval
	IniWrite, %IndicatorSize%, %IniFile%, Settings, IndicatorSize
	IniWrite, %IndicatorColor%, %IniFile%, Settings, IndicatorColor
	IniWrite, %IndicatorOffsetX%, %IniFile%, Settings, IndicatorOffsetX
	IniWrite, %IndicatorOffsetY%, %IniFile%, Settings, IndicatorOffsetY
	IniWrite, %DoubleTapThreshold%, %IniFile%, Settings, DoubleTapThreshold
	IniWrite, %StartWithWindows%, %IniFile%, Settings, StartWithWindows

	; Save key bindings
	IniWrite, %ToggleKey%, %IniFile%, Keys, ToggleKey
	IniWrite, %MoveUp%, %IniFile%, Keys, MoveUp
	IniWrite, %MoveDown%, %IniFile%, Keys, MoveDown
	IniWrite, %MoveLeft%, %IniFile%, Keys, MoveLeft
	IniWrite, %MoveRight%, %IniFile%, Keys, MoveRight
	IniWrite, %LeftClick%, %IniFile%, Keys, LeftClick
	IniWrite, %RightClick%, %IniFile%, Keys, RightClick
	IniWrite, %MiddleClick%, %IniFile%, Keys, MiddleClick
	IniWrite, %ScrollUp%, %IniFile%, Keys, ScrollUp
	IniWrite, %ScrollDown%, %IniFile%, Keys, ScrollDown
	IniWrite, %SpeedModifier%, %IniFile%, Keys, SpeedModifier
}

RegisterToggleHotkey() {
	global ToggleKey
	Hotkey, %ToggleKey%, ToggleController, On
}

RegisterControllerHotkeys() {
	global

	RegisteredHotkeys := []

	; Movement keys - use * prefix (fires regardless of modifiers like Shift)
	; These just suppress the keypress; actual movement is driven by the timer
	hk := "*" . MoveUp
	Hotkey, %hk%, SuppressKey, On
	RegisteredHotkeys.Push(hk)

	hk := "*" . MoveDown
	Hotkey, %hk%, SuppressKey, On
	RegisteredHotkeys.Push(hk)

	hk := "*" . MoveLeft
	Hotkey, %hk%, SuppressKey, On
	RegisteredHotkeys.Push(hk)

	hk := "*" . MoveRight
	Hotkey, %hk%, SuppressKey, On
	RegisteredHotkeys.Push(hk)

	; Click keys - down and up variants for drag support
	hk := "*" . LeftClick
	Hotkey, %hk%, LeftClickDown, On
	RegisteredHotkeys.Push(hk)
	hk := "*" . LeftClick . " UP"
	Hotkey, %hk%, LeftClickUp, On
	RegisteredHotkeys.Push(hk)

	hk := "*" . RightClick
	Hotkey, %hk%, RightClickDown, On
	RegisteredHotkeys.Push(hk)
	hk := "*" . RightClick . " UP"
	Hotkey, %hk%, RightClickUp, On
	RegisteredHotkeys.Push(hk)

	hk := "*" . MiddleClick
	Hotkey, %hk%, MiddleClickDown, On
	RegisteredHotkeys.Push(hk)
	hk := "*" . MiddleClick . " UP"
	Hotkey, %hk%, MiddleClickUp, On
	RegisteredHotkeys.Push(hk)

	; Scroll keys
	hk := "*" . ScrollUp
	Hotkey, %hk%, ScrollUpAction, On
	RegisteredHotkeys.Push(hk)

	hk := "*" . ScrollDown
	Hotkey, %hk%, ScrollDownAction, On
	RegisteredHotkeys.Push(hk)
}

UnregisterControllerHotkeys() {
	global RegisteredHotkeys

	for index, hk in RegisteredHotkeys
	{
		Hotkey, %hk%, Off
	}
	RegisteredHotkeys := []
}
