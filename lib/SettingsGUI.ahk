; ==================== SettingsGUI.ahk ====================
; Settings window with tabs: Keys, Speed, Theme

ShowSettings:
	; Deactivate tool before opening settings (avoids hotkey conflicts)
	if (ToolActive)
		Gosub, ToggleController

	Suspend, On
	if (A_IsCompiled)
		Menu, Tray, Icon, %IconPath%, %IconIndex%
	else
		Menu, Tray, Icon, %IconPath%

	; Destroy existing GUI if any
	Gui, Settings:Destroy

	; Create settings window
	Gui, Settings:New, , Keyboard Mouse Settings

	; Apply theme
	if (DarkMode = 1)
	{
		Gui, Settings:Color, 0x1E1E1E, 0x2D2D2D
		Gui, Settings:Font, s12 cWhite
	}
	else
	{
		Gui, Settings:Font, s12 cBlack
	}

	Gui, Settings:Add, Tab3, x10 y10 w520 h510 vSettingsTab, Keys|Speed|Theme

	; ==================== Keys Tab ====================
	Gui, Settings:Tab, Keys

	yPos := 50

	; --- Toggle Key ---
	Gui, Settings:Add, Text, x20 y%yPos%, Toggle Key:

	parsedTgl := ParseHotkey(ToggleKey)
	tglCtrl := parsedTgl.ctrl
	tglShift := parsedTgl.shift
	tglAlt := parsedTgl.alt
	tglWin := parsedTgl.win
	tglKey := parsedTgl.key

	yPos += 30
	Gui, Settings:Add, Checkbox, x20 y%yPos% vChkTglCtrl Checked%tglCtrl%, Ctrl
	Gui, Settings:Add, Checkbox, x80 y%yPos% vChkTglShift Checked%tglShift%, Shift
	Gui, Settings:Add, Checkbox, x150 y%yPos% vChkTglAlt Checked%tglAlt%, Alt
	Gui, Settings:Add, Checkbox, x205 y%yPos% vChkTglWin Checked%tglWin%, Win
	Gui, Settings:Add, Text, x260 y%yPos%, Key:
	editY := yPos - 3
	btnY := yPos - 4
	Gui, Settings:Add, Edit, x300 y%editY% w80 vEditToggleKey ReadOnly, %tglKey%
	Gui, Settings:Add, Button, x385 y%btnY% w45 gSetToggleKey, Set

	; --- Movement Keys ---
	yPos += 45
	Gui, Settings:Add, Text, x20 y%yPos% w480 0x10  ; horizontal line
	yPos += 10
	Gui, Settings:Add, Text, x20 y%yPos%, Movement Keys

	yPos += 30
	Gui, Settings:Add, Text, x20 y%yPos% w60, Up:
	editY := yPos - 3
	btnY := yPos - 4
	Gui, Settings:Add, Edit, x80 y%editY% w60 vEditMoveUp ReadOnly, %MoveUp%
	Gui, Settings:Add, Button, x145 y%btnY% w45 gSetMoveUp, Set
	Gui, Settings:Add, Text, x210 y%yPos% w60, Down:
	Gui, Settings:Add, Edit, x270 y%editY% w60 vEditMoveDown ReadOnly, %MoveDown%
	Gui, Settings:Add, Button, x335 y%btnY% w45 gSetMoveDown, Set

	yPos += 35
	Gui, Settings:Add, Text, x20 y%yPos% w60, Left:
	editY := yPos - 3
	btnY := yPos - 4
	Gui, Settings:Add, Edit, x80 y%editY% w60 vEditMoveLeft ReadOnly, %MoveLeft%
	Gui, Settings:Add, Button, x145 y%btnY% w45 gSetMoveLeft, Set
	Gui, Settings:Add, Text, x210 y%yPos% w60, Right:
	Gui, Settings:Add, Edit, x270 y%editY% w60 vEditMoveRight ReadOnly, %MoveRight%
	Gui, Settings:Add, Button, x335 y%btnY% w45 gSetMoveRight, Set

	; --- Click Keys ---
	yPos += 45
	Gui, Settings:Add, Text, x20 y%yPos% w480 0x10  ; horizontal line
	yPos += 10
	Gui, Settings:Add, Text, x20 y%yPos%, Click Keys

	yPos += 30
	Gui, Settings:Add, Text, x20 y%yPos% w60, Left:
	editY := yPos - 3
	btnY := yPos - 4
	Gui, Settings:Add, Edit, x80 y%editY% w60 vEditLeftClick ReadOnly, %LeftClick%
	Gui, Settings:Add, Button, x145 y%btnY% w45 gSetLeftClick, Set
	Gui, Settings:Add, Text, x210 y%yPos% w60, Right:
	Gui, Settings:Add, Edit, x270 y%editY% w60 vEditRightClick ReadOnly, %RightClick%
	Gui, Settings:Add, Button, x335 y%btnY% w45 gSetRightClick, Set

	yPos += 35
	Gui, Settings:Add, Text, x20 y%yPos% w60, Middle:
	editY := yPos - 3
	btnY := yPos - 4
	Gui, Settings:Add, Edit, x80 y%editY% w60 vEditMiddleClick ReadOnly, %MiddleClick%
	Gui, Settings:Add, Button, x145 y%btnY% w45 gSetMiddleClick, Set

	; --- Scroll Keys ---
	yPos += 45
	Gui, Settings:Add, Text, x20 y%yPos% w480 0x10  ; horizontal line
	yPos += 10
	Gui, Settings:Add, Text, x20 y%yPos%, Scroll Keys

	yPos += 30
	Gui, Settings:Add, Text, x20 y%yPos% w60, Up:
	editY := yPos - 3
	btnY := yPos - 4
	Gui, Settings:Add, Edit, x80 y%editY% w60 vEditScrollUp ReadOnly, %ScrollUp%
	Gui, Settings:Add, Button, x145 y%btnY% w45 gSetScrollUp, Set
	Gui, Settings:Add, Text, x210 y%yPos% w60, Down:
	Gui, Settings:Add, Edit, x270 y%editY% w60 vEditScrollDown ReadOnly, %ScrollDown%
	Gui, Settings:Add, Button, x335 y%btnY% w45 gSetScrollDown, Set

	; --- Speed Modifier ---
	yPos += 45
	Gui, Settings:Add, Text, x20 y%yPos% w480 0x10  ; horizontal line
	yPos += 10
	Gui, Settings:Add, Text, x20 y%yPos% w120, Speed Modifier:
	editY := yPos - 3
	Gui, Settings:Add, DropDownList, x140 y%editY% w100 vDDLSpeedModifier, Shift|Ctrl|Alt
	GuiControl, Settings:ChooseString, DDLSpeedModifier, %SpeedModifier%

	; ==================== Speed Tab ====================
	Gui, Settings:Tab, Speed

	yPos := 50

	Gui, Settings:Add, Text, x20 y%yPos%, Base Speed (1-20):
	yPos += 30
	Gui, Settings:Add, Slider, x20 y%yPos% w300 Range1-20 ToolTip vSliderBaseSpeed, %BaseSpeed%

	yPos += 50
	Gui, Settings:Add, Text, x20 y%yPos%, Shift Multiplier (2-10):
	yPos += 30
	Gui, Settings:Add, Slider, x20 y%yPos% w300 Range2-10 ToolTip vSliderShiftMultiplier, %ShiftMultiplier%

	yPos += 50
	Gui, Settings:Add, Text, x20 y%yPos%, Timer Interval ms (8-50):
	yPos += 30
	Gui, Settings:Add, Slider, x20 y%yPos% w300 Range8-50 ToolTip vSliderTimerInterval, %TimerInterval%

	yPos += 50
	Gui, Settings:Add, Text, x20 y%yPos%, Double-Tap Threshold ms (100-500):
	yPos += 30
	Gui, Settings:Add, Slider, x20 y%yPos% w300 Range100-500 ToolTip vSliderDoubleTapThreshold, %DoubleTapThreshold%

	yPos += 50
	Gui, Settings:Add, Text, x20 y%yPos%, Indicator Size (4-20):
	yPos += 30
	Gui, Settings:Add, Slider, x20 y%yPos% w300 Range4-20 ToolTip vSliderIndicatorSize, %IndicatorSize%

	yPos += 50
	Gui, Settings:Add, Text, x20 y%yPos%, Indicator Color (hex):
	editY := yPos - 3
	Gui, Settings:Add, Edit, x200 y%editY% w100 vEditIndicatorColor, %IndicatorColor%

	yPos += 40
	Gui, Settings:Add, Checkbox, x20 y%yPos% vChkStartWithWindows Checked%StartWithWindows%, Start with Windows

	; ==================== Theme Tab ====================
	Gui, Settings:Tab, Theme

	Gui, Settings:Add, Text, x20 y50, Theme:
	darkModeChecked := (DarkMode = 1) ? 1 : 0
	lightModeChecked := (DarkMode = 1) ? 0 : 1
	Gui, Settings:Add, Radio, x20 y85 vRadioDarkMode Checked%darkModeChecked% gThemePreview, Dark Mode
	Gui, Settings:Add, Radio, x20 y120 Checked%lightModeChecked% gThemePreview, Light Mode

	; ==================== Bottom buttons (outside tabs) ====================
	Gui, Settings:Tab
	Gui, Settings:Add, Button, x350 y530 w90 gSaveSettings Default, Save
	Gui, Settings:Add, Button, x450 y530 w90 gSettingsGuiClose, Cancel

	Gui, Settings:Show, w550 h560

	; Apply dark mode to window after showing
	if (DarkMode = 1)
	{
		Gui, Settings:+LastFound
		settingsHwnd := WinExist()
		ApplyDarkMode(settingsHwnd)
	}
return

; ==================== Key Capture Handlers ====================

SetToggleKey:
	CaptureKeyToControl("Settings", "EditToggleKey")
return

SetMoveUp:
	CaptureKeyToControl("Settings", "EditMoveUp")
return

SetMoveDown:
	CaptureKeyToControl("Settings", "EditMoveDown")
return

SetMoveLeft:
	CaptureKeyToControl("Settings", "EditMoveLeft")
return

SetMoveRight:
	CaptureKeyToControl("Settings", "EditMoveRight")
return

SetLeftClick:
	CaptureKeyToControl("Settings", "EditLeftClick")
return

SetRightClick:
	CaptureKeyToControl("Settings", "EditRightClick")
return

SetMiddleClick:
	CaptureKeyToControl("Settings", "EditMiddleClick")
return

SetScrollUp:
	CaptureKeyToControl("Settings", "EditScrollUp")
return

SetScrollDown:
	CaptureKeyToControl("Settings", "EditScrollDown")
return

; ==================== Theme Preview ====================

ThemePreview:
	Gui, Settings:Submit, NoHide
	DarkMode := RadioDarkMode
	Gui, Settings:Destroy
	Gosub, ShowSettings
	; Switch back to Theme tab
	GuiControl, Settings:Choose, SettingsTab, 3
return

; ==================== Close/Escape ====================

SettingsGuiClose:
SettingsGuiEscape:
	Suspend, Off
	Gui, Settings:Destroy
return

; ==================== Save ====================

SaveSettings:
	Gui, Settings:Submit, NoHide

	; Validate indicator color
	if (!RegExMatch(EditIndicatorColor, "^[0-9A-Fa-f]{6}$"))
	{
		MsgBox, 48, Keyboard Mouse, Indicator color must be a 6-digit hex value (e.g., 00FF00).
		return
	}

	; Build toggle hotkey from checkboxes + key
	builtToggleKey := BuildHotkey(ChkTglCtrl, ChkTglShift, ChkTglAlt, ChkTglWin, EditToggleKey)

	; Update globals
	ToggleKey := builtToggleKey
	MoveUp := EditMoveUp
	MoveDown := EditMoveDown
	MoveLeft := EditMoveLeft
	MoveRight := EditMoveRight
	LeftClick := EditLeftClick
	RightClick := EditRightClick
	MiddleClick := EditMiddleClick
	ScrollUp := EditScrollUp
	ScrollDown := EditScrollDown
	SpeedModifier := DDLSpeedModifier

	BaseSpeed := SliderBaseSpeed
	ShiftMultiplier := SliderShiftMultiplier
	TimerInterval := SliderTimerInterval
	DoubleTapThreshold := SliderDoubleTapThreshold
	IndicatorSize := SliderIndicatorSize
	IndicatorColor := EditIndicatorColor

	DarkMode := RadioDarkMode
	StartWithWindows := ChkStartWithWindows

	; Save to INI
	SaveConfig()

	; Handle Windows startup registry
	RegKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
	if (StartWithWindows = 1)
	{
		if (A_IsCompiled)
			StartupPath := """" . A_ScriptFullPath . """"
		else
			StartupPath := """" . A_AhkPath . """ """ . A_ScriptFullPath . """"
		RegWrite, REG_SZ, %RegKey%, FastKeyboardMouse, %StartupPath%
	}
	else
	{
		RegDelete, %RegKey%, FastKeyboardMouse
	}

	Suspend, Off
	Gui, Settings:Destroy
	Reload
return
