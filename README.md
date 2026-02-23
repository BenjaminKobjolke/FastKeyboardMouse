# FastKeyboardMouse

Control your mouse cursor entirely from the keyboard using vim-style keys. Toggle on with a hotkey, move the cursor with HJKL, click and scroll with letter keys, and toggle off to type normally.

## Default Keys

| Key | Action |
|-----|--------|
| Alt+Q | Toggle tool on/off |
| H/J/K/L | Move cursor left/down/up/right |
| Shift + move | Faster movement |
| A | Left click (hold to drag, double-tap for double-click) |
| D | Right click (hold to drag) |
| S | Middle click (hold to drag) |
| I | Scroll up |
| U | Scroll down |

When inactive, all letter keys pass through normally for typing.

## Visual Indicator

A small green dot follows the cursor when the tool is active, so you always know the current mode.

## Settings

Right-click the tray icon and select **Settings** to open the configuration GUI.

### Keys Tab
Rebind any key: toggle hotkey (with modifier checkboxes), movement keys, click keys, scroll keys, and speed modifier.

### Speed Tab
- **Base Speed** - cursor movement speed (1-20)
- **Shift Multiplier** - speed multiplier when holding Shift (2-10)
- **Timer Interval** - movement update rate in ms (8-50, lower = smoother)
- **Double-Tap Threshold** - max ms between taps for double-click (100-500)
- **Indicator Size** - green dot size in pixels (4-20)
- **Indicator Color** - hex color for the indicator dot
- **Start with Windows** - auto-launch on login

### Theme Tab
Switch between dark and light mode.

## Requirements

- Windows 10 or later
- [AutoHotkey v1.1](https://www.autohotkey.com/)

## Usage

Run `FastKeyboardMouse.ahk` with AutoHotkey, or launch `FastKeyboardMouse-GUI.bat` to open settings on startup.

## License

See [LICENSE](LICENSE).
