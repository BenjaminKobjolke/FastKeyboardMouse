#NoEnv
SendMode Input
#SingleInstance force
#Persistent
CoordMode, Mouse, Screen

; Embed icons as resources (used by Ahk2Exe compiler)
;@Ahk2Exe-SetMainIcon data\icon_light.ico
;@Ahk2Exe-AddResource data\icon_dark.ico, 206

SetWorkingDir %A_ScriptDir%

; Include function libraries before auto-execute section
#Include lib/Utils.ahk
#Include lib/Config.ahk

; Initialize configuration
InitConfig()

; Create cursor indicator (hidden initially)
CreateIndicator()

; Register only the toggle hotkey at startup
RegisterToggleHotkey()

; Setup system tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, ShowSettings
if (!A_IsCompiled) {
	Menu, Tray, Add
	Menu, Tray, Add, Reload
}
Menu, Tray, Add
Menu, Tray, Add, Exit
if (A_IsCompiled)
	Menu, Tray, Icon, %IconPath%, %IconIndex%
else if (FileExist(IconPath))
	Menu, Tray, Icon, %IconPath%

; Show GUI on start if command line arg was passed
if (ShowGuiOnStart)
	Gosub, ShowSettings

; Register cleanup on exit
OnExit, CleanupExit

return  ; End of auto-execute section

; ==================== Toggle Controller ====================

ToggleController:
	ToolActive := !ToolActive

	if (ToolActive)
	{
		RegisterControllerHotkeys()
		StartMoveTimer()
		ShowIndicator()
	}
	else
	{
		; Release any held mouse buttons before deactivating
		if (LeftButtonHeld)
		{
			MouseClick, Left,,, 1, 0, U
			LeftButtonHeld := false
		}
		if (RightButtonHeld)
		{
			MouseClick, Right,,, 1, 0, U
			RightButtonHeld := false
		}
		if (MiddleButtonHeld)
		{
			MouseClick, Middle,,, 1, 0, U
			MiddleButtonHeld := false
		}

		UnregisterControllerHotkeys()
		StopMoveTimer()
		HideIndicator()
	}
return

; ==================== System Handlers ====================

CleanupExit:
	; Release any held mouse buttons
	if (LeftButtonHeld)
		MouseClick, Left,,, 1, 0, U
	if (RightButtonHeld)
		MouseClick, Right,,, 1, 0, U
	if (MiddleButtonHeld)
		MouseClick, Middle,,, 1, 0, U

	DestroyIndicator()
	ExitApp
return

Reload:
	Reload
return

Exit:
	Gosub, CleanupExit
return

; Include label-based modules after auto-execute section
#Include lib/HotkeyCapture.ahk
#Include lib/CursorIndicator.ahk
#Include lib/MouseController.ahk
#Include lib/SettingsGUI.ahk

; Debug hotkey (only when not compiled)
#If !A_IsCompiled
#y::
	Send ^s
	reload
return
#If
