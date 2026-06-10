#requires -Version 5.1
<#
.SYNOPSIS
    MARIUS Board Configurator - Uninstaller / Cleanup Script
.DESCRIPTION
    Removes all files, shortcuts, and folders created by the MARIUS Board Configurator installer.
    Safe to run on old installs before migrating users to the new version.
#>

Write-Host ""
Write-Host "  MARIUS Board Configurator - Uninstaller" -ForegroundColor Magenta
Write-Host "  ========================================" -ForegroundColor DarkMagenta
Write-Host ""

$removed = @()
$skipped = @()

function Remove-IfExists {
    param([string]$Path, [string]$Label)
    if (Test-Path $Path) {
        try {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "  [REMOVED] $Label" -ForegroundColor Green
            $script:removed += $Label
        } catch {
            Write-Host "  [FAILED]  $Label - $_" -ForegroundColor Red
        }
    } else {
        Write-Host "  [SKIP]    $Label (not found)" -ForegroundColor DarkGray
        $script:skipped += $Label
    }
}

# ── 1. AppData install folder (script + icon + update log) ──────────────────
#   %APPDATA%\MARIUS\MARIUS.ps1
#   %APPDATA%\MARIUS\MBC.ico
#   %APPDATA%\MARIUS\update.log
Remove-IfExists "$env:APPDATA\MARIUS" "AppData folder (%APPDATA%\MARIUS)"

# ── 2. Desktop shortcuts ─────────────────────────────────────────────────────
$desktopShortcut = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('Desktop'),
    'MARIUS Board Configurator.lnk'
)
Remove-IfExists $desktopShortcut "Desktop shortcut (Main)"

$desktopShortcutLite = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('Desktop'),
    'MARIUS Board Configurator Lite.lnk'
)
Remove-IfExists $desktopShortcutLite "Desktop shortcut (Lite)"

# ── 3. Start Menu shortcuts ──────────────────────────────────────────────────

# Main - flat .lnk directly under Programs\
$startMenuShortcutMain = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('StartMenu'),
    'Programs',
    'MARIUS Board Configurator.lnk'
)
Remove-IfExists $startMenuShortcutMain "Start Menu shortcut (Main)"

# Main - also catch if it was ever installed into its own subfolder
$startMenuDirMain = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('StartMenu'),
    'Programs',
    'MARIUS Board Configurator'
)
Remove-IfExists $startMenuDirMain "Start Menu folder (Main, if exists)"

# Lite - flat .lnk directly under Programs\
$startMenuShortcutLite = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('StartMenu'),
    'Programs',
    'MARIUS Board Configurator Lite.lnk'
)
Remove-IfExists $startMenuShortcutLite "Start Menu shortcut (Lite)"

# Lite - also catch if it was ever installed into its own subfolder
$startMenuDirLite = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('StartMenu'),
    'Programs',
    'MARIUS Board Configurator Lite'
)
Remove-IfExists $startMenuDirLite "Start Menu folder (Lite, if exists)"

# ── 4. Temp update files (leftover from failed updates) ──────────────────────
$tempFiles = Get-ChildItem -Path $env:TEMP -Filter "MARIUS_update_*.ps1" -ErrorAction SilentlyContinue
if ($tempFiles) {
    foreach ($f in $tempFiles) {
        Remove-IfExists $f.FullName "Temp update file ($($f.Name))"
    }
} else {
    Write-Host "  [SKIP]    No temp update files found in %TEMP%" -ForegroundColor DarkGray
}

# ── Summary ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ----------------------------------------" -ForegroundColor DarkMagenta
Write-Host "  Done! $($removed.Count) item(s) removed, $($skipped.Count) already absent." -ForegroundColor Cyan
Write-Host ""

if ($removed.Count -eq 0) {
    Write-Host "  Nothing was found - MARIUS may not have been installed on this machine." -ForegroundColor Yellow
}

Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
