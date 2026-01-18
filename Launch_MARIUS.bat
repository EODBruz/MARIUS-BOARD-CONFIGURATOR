@echo off
REM MARIUS Board Configurator Launcher
REM Created by: @mariusheier | Script by: @EODBruz

title MARIUS Board Configurator Launcher

echo.
echo ============================================
echo   MARIUS BOARD CONFIGURATOR LAUNCHER
echo ============================================
echo.
echo   Downloading and launching...
echo.

REM Download and run the script directly
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex"

REM If that fails, show error
if errorlevel 1 (
    echo.
    echo ERROR: Failed to download or run the script.
    echo.
    echo Please check your internet connection and try again.
    echo.
    pause
)
