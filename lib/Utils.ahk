; ==================== Utils.ahk ====================
; Dark Mode Helper Functions

ApplyDarkMode(hwnd) {
	; Dark title bar (Windows 10 1809+)
	DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", hwnd, "Int", 20, "Int*", 1, "Int", 4)
}


