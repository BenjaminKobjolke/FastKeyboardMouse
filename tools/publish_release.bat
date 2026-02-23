REM @echo off
cd D:\GIT\BenjaminKobjolke\release-tool

call uv run python -m release_tool "%~dp0..\FastKeyboardMouse.exe" "%~dp0publish_settings.ini" --previous-version 1.0.1 --verbose

cd "%~dp0"
