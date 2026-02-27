REM @echo off
cd D:\GIT\BenjaminKobjolke\release-tool

call uv run python -m release_tool "%~dp0..\FastKeyboardMouse.exe" "%~dp0publish_settings.ini" --previous-version 0.0.2 --verbose

cd "%~dp0"
