#requires -Version 5.1
<#
.SYNOPSIS
    MARIUS Board Configurator V3.7.1

.DESCRIPTION
    All-in-one launcher for MARIUS tools including USB Latency Analyzer and HID Telemetry.
    No additional files needed - everything is contained in this single script.
    Features desktop shortcut installer and embedded MBC icon.

.NOTES
    Created by: @mariusheier (Original Creator)
    Script by: @EODBruz (PowerShell Development)
    Version: 3.7

.CREDITS
    App Creator: @mariusheier
    Script Developer: @EODBruz
    Optimization Scripts: FR33THY
    HID Telemetry Tool: @TheQuest818
    Script Version 3.7.1

.INSTALLATION
    Quick Install (One-Liner):
    iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex

.SECURITY WARNING
    If you downloaded this script and get a security warning when running:
    - Press "R" to Run once (safe - this is a trusted script)
    - OR right-click file -> Properties -> Check "Unblock" -> Apply
    - OR use the one-liner above (no warning!)
#>

# ============================================================================
# INSTALL PATHS
# ============================================================================
$script:CurrentVersion = "3.7.1"
$script:InstallDir     = "$env:APPDATA\MARIUS"
$script:InstallPath    = "$script:InstallDir\MARIUS.ps1"
$script:ScriptUrl      = "https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1"
$script:ReleasesApi    = "https://api.github.com/repos/EODBruz/MARIUS-BOARD-CONFIGURATOR/releases/latest"
$script:SettingsPath   = "$script:InstallDir\Settings.ini"
$script:MusicPath      = "$script:InstallDir\MMusic.mp3"
$script:MusicUrl       = "https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MMusic.mp3"


# ============================================================================
# EMBEDDED MBC ICON (Yellow + Black, Base64 encoded ICO)
# ============================================================================

$script:MbcIconBase64 = "AAABAAMAEBAAAAAAIAAHAgAANgAAACAgAAAAACAAEAQAAD0CAAAwMAAAAAAgAMUFAABNBgAAiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABzklEQVR4nKXTv0uVURgH8M9573tveg25oTdykX5omjgUtEXQkEstkdAiDUGLNAa1tNd/EBE0RUU0NDcEBZG1hIMYYgkmFCn5oyS86nsa3tcrtJh04MBznsPzfb7P+X5PCEGstZMEu1pZZGmFtNbOm6d01onrhB2AYiSUWZjn1CXSJNBVp3YADezEJKJCWc46hcY6sZHvf2JQ1EBCXhRjnmjGYbtgK6+4i7YbpVvISWtOL26SVItxUkKax7FBSCi1o5SDNBkkgZlplpYIFaY+srrK3Czvx/ixQKjmRa9eMjFOmuTnNIu0tHBmhIEebt+g7yyvH3PnHp37+DTLs/uM3mRvld5DXBkmSUgD1tY40s3cN67dYvAoaw1KJSpl2lp5N8bUDBMT+ajfx4lZ8QYh8HOVC0MsN2ibZGGRpWVODvL2A5uBcsqju9Q76D9YMBDyWS4Pc+40+4/x5AEnBhgd4fMXrl/l4nm6u3j4nN7DHO8jywgdNXHyBfUeLJJtkLQXKlQKnSKWUcWeXIWFafqHihFiZGORsJHT2ljJlcl+b8uVlsh+sblCUsm7N31QKZO2alp5yxzJXy4soVRYuVIuALLI13nW7f4zZZHwv9/5D99UofBpTIewAAAAAElFTkSuQmCCiVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAD10lEQVR4nO2XTWhcVRTHf/e9N5NOMvmYTBtbP6g0StOiEKgiXepC3EQskVCr1hRjWz9QN7px4cqF4MpFd0WKICI0FisaFS0qaS1tVRRCA20N1rZMwkxmTOcjM/PecXHua14maXQziYseeLx7zzn3nv89H/fDAMIakgdgDHS26381SAQKc/r3QI3/ehw6UyC15gERARODwiz0D0D+74gH0ilIdgM1oFmeECCmRsNFeqGsVtPVN90D1lZINwAYYw2b5uaCaZjfaZ6p/0a3ANwC4DUygsA2DLgReH4ACBgHHKN6EtnEjQGnYTkiVk+n0wpYEYCAmwDiQABSXCgZN4n6qwpUwEkAscjYOkjZGrAAHQ/cdmvFB4oreEDsLjU5AVcy0N4GD/bbgQ78dBJKZdh8O/RuhfMTcDVjPWbgztugr0+BB1VwklDOw6lxmPoLNvXAzh3Q1b3YcwCS6kRmziCSR0aGEEAcB5kYQ/wscvaY8gB57TlE6sjwoPY9FzFW9uwTyPxFRK4gJ0eRe+5WvnH0379dZblzSKrD2mkMQTyusQwCOPQROJ3w/hEVO47KEWhNaP+Lw+BPQ18vfHgMMpehUoLBA3BhCj54F7K/w/lv4MBuCCqLc2VJEvq+Gh94BD4+Di99B6Nfwa5H4dOvbTKiOkEAX/4AFzKQnYUH7odN98K3Y3BtBgYfg+GDQBZS22DrfcC8DYHNrSVlGKJ78WloicOug7AhDSNDyg8rI6yWI0fhrXdgJgcb14OJw3Re9XrvgloFyiWozkEt32htGQCuo5nftwX2DMDkJXj+Sdh8x+JS8zztHz0EuQK8uR8+PwFjo7Bjm3rq9G8QcyCxAeLrIZZcmoBLQlD3ValYhpf3wXQORp6BqSnl+766r17X/o9noJyAU7/o+OsV2P4Q7OyH70/D8H54aggu/wHjZ+Hwe7a0I0AWqiCHvPGC9n/+DJEMIlcRmUHGP1H+268iMo+8vk/7HUmkxUV60sgre5HiJOL/iWTOIXseRzxvoYJ2D+h82UgVGAuASyegKw3FAlRr0JEExwW/Dq6nK5+7DutaINEKpSLMV21IDLSug1gXUAKpay7QArPXNEFTHZDeCPiQz8GWh2G2sMxO2NYGba4qIhrrMOapNBCorLUNWtsjYwPwCwrIOPZ2VYVUN6R6dExQBif+LzkQ+GCCZW5FopOCysS3ICPkugvt8OYTAmm8Cd0UwM0UQ9ly7ZUoOl9jBcD/4DhecwCLTsPwaxaJLciojRsAYjF9tYTneTPI2CM/FrlHeCGy7CzUWb2nWegFA8haPk4bduXVp38As02itan5XJ0AAAAASUVORK5CYIKJUE5HDQoaCgAAAA1JSERSAAAAMAAAADAIBgAAAFcC+YcAAAWMSURBVHic7Zp/iFRVFMc/9703zuiy7o9xNdO21EpN21YN/JFoqa0aaooErVkEVmZBWlGQ/aSMrAgrspIotDRKMttSCwMTKiPQFTHWUFdqTQ33pzr7a+a9uf1x3jhvdmZ0pWBmYw48eO/dd879fs89995z3nsK0LiiFD1CtI6fKzwEeqJYsROloCA/+0dBazhzLj4KllJyUZAP1VVQWAw6kn1EtAblg5YmGHs7tJwVjAkj0K8Y8oNABAmubBIN+ASw17mW95lIRLyftSOAYPRKAgGlXOAq+wiAB59HjMxA+e8kRyDTkiOQackRyLTkCGRacgQyLVa6Bq3BicavTSM5D3GceDWkANNMrYvnGSOFnaQ+PUaVEp1LI6BBBcDq7bnXSkKarTWYhcTH0AFCrq6/i65rkyjQAdFOMMzEZscB0w9WH49NDdhAW2IZeWECGvDD0SPw017xquNAxWQYOBgIu1mhCVu3SHUE0D8It90C+OK6MW8bSuyUFEP5KAheDjoUH4loVJxRXwe79sDvx6C1DQb0gxvLYOJY8JlJSEWUQgO6qADdtA+ta9G6Hr3uJbkfO5ZWyv3OGnT0BPrAtsT20deg9TG0Pp2s6z36B9Eb3kDrk2j7MNo+Iudvv4AuCabWuXchWv8l9pv2CVZAK4VOG0J+P1gmWJYUEZ9vh1WPQbBYSrt3N4kHA35pLyxI1jUMmDYJJk2GE8dg41dwuhGWPQOzp0gFqPLgzXfg0VWi7u8FC2fDyGFwugW27YTfDpO2QrzgJLYdAREISA36yVZY8SScqoHPtsnENpQ85zjJujiwsALuWwlEoHk+fPEttLXDH3VQMgTqDsFTr7v9+KHqfZgxD4l9A15eDr/sB6cNTF8yzosuo1pD5RwBunYjKAc275DYnzkFrrvaNZTGQ3+ehOMHoXon1ByFqIaiArhiEGDCd7uho1PmwaK5MGM+hE+B3Qh2PeT3hYqK9EAvSiBiw9zpML4cauvg683w6TfS9vBd4It5JQUBy4RVa6G0DMbNkVDoHYD1r8FlVwFhOFoXn8w3jYNoh6xQliWHtsEJpcfXrY2suAAerJTzpc/B3oMwfCjMuBlazqXX0xoGDYAxZTDqWgEajsCaj+DvOsDvhpq7RJqp0KgLvyDpFoGzIbhjnrw7qm+U4V62CHyFYNvp9ZwoPL4EqnfBge/hrWdlruz+Fd77GMiD0oHxfau6Bgw/OLYQs2138+vzLwm0d0LvIXDnHAGV1wcWL5C1PKXXPBLwC1CzH0wcI/d8FtQeB9ph1hSxYRqw4Us4uAf8g8EqBKtEEO6vlj0wlaRdhQwlMQgSy7oVVi6T5W3YlRAsAd0hYCwrnkZ4dQ0FP1dD/noINcMHmwRoxIbykUJgxGh44n5YvQ6az8D0xbCkEkYOhYYW2LJd7PxYBYS7S0CJ12PhEY6AikDpIFi+Aoi4O6kBDc3yXFNLat1NVXJ4ZdZUeOBucUrUgVeeFg+v+RDqm2D12sTn59/KJewDCnQ7jL8Bnn9Ebl0/XNg7NugGmYwxj698SDotHYgEc0dc13CTMWVI/0V9oWwETJ4gujoCJqDD8OqLcM8C2PEDHKqFkJtKTCiHmVNltFWKcFVKobW7NtfugqKgGFQBIDZ5WoVASi/0RWaSA5zjfC5FqokXS85CcurNSqMOGHmubiyJiLW3uZh6QXMjDJsm4ZbwcrfrKEQ7Idoml6aZPgW2m6Wz86PSRberXaXc1LxLk2GKTrQ13hZbnUyDSwihmEEFRtpWj4EUWWJ3dZP0jPTLYrp0usdXZDkCmZYcgUxLjkCmJWG11jp+ZJtod3fuii2BgM8nBbuCrPvMqtzPrL4udfF5AlpDQ5OkKln7mdX90J3yX4me+qvB/+dnD8h+78fEG0L/APuCF1jFkKUEAAAAAElFTkSuQmCC"

function Install-MbcIcon {
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }
        $iconPath = "$script:InstallDir\MBC.ico"
        if (-not (Test-Path $iconPath)) {
            $iconBytes = [Convert]::FromBase64String($script:MbcIconBase64)
            [System.IO.File]::WriteAllBytes($iconPath, $iconBytes)
        }
        return $iconPath
    } catch {
        return $null
    }
}

# ============================================================================
# EMBEDDED CONTROLLER TELEMETRY HTML (Base64 encoded)
# ============================================================================


function Install-ControllerTelemetry {
    <#
    .SYNOPSIS
        Downloads controller-telemetry.html from GitHub and opens it in the user's browser.
    .NOTES
        Fetches the live file from your GitHub Pages so no base64 is needed.
    #>
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }

        $htmlPath = "$script:InstallDir\controller-telemetry.html"
        $htmlUrl  = "https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/controller-telemetry.html"

        # Always re-download so the user gets the latest version from GitHub
        try {
            $wc = New-Object System.Net.WebClient
            $wc.Headers.Add("Cache-Control", "no-cache")
            $wc.DownloadFile($htmlUrl, $htmlPath)
        } catch {
            # If download fails but a cached copy exists, fall back to it
            if (-not (Test-Path $htmlPath)) {
                [System.Windows.Forms.MessageBox]::Show(
                    "Could not download Controller Telemetry and no cached copy exists.`n$_",
                    "Network Error",
                    [System.Windows.Forms.MessageBoxButtons]::OK,
                    [System.Windows.Forms.MessageBoxIcon]::Warning
                )
                return
            }
        }

        # Open in default Chromium browser (WebHID requires Chrome/Edge/Opera)
        $defaultBrowser = Get-DefaultBrowser
        $browserPath    = Get-BrowserPath $defaultBrowser

        if (-not $browserPath) {
            foreach ($b in @("Chrome","Edge","Brave","Opera","Vivaldi","Arc")) {
                if ($b -ne $defaultBrowser) {
                    $browserPath = Get-BrowserPath $b
                    if ($browserPath) { break }
                }
            }
        }

        if ($browserPath) {
            $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
            $wW = 1400; $wH = 900
            $l   = [Math]::Floor(($screen.Width  - $wW) / 2)
            $t   = [Math]::Floor(($screen.Height - $wH) / 2)
            Start-Process -FilePath $browserPath -ArgumentList "--app=`"file:///$($htmlPath.Replace('\','/').TrimStart('/'))`" --window-size=$wW,$wH --window-position=$l,$t"
        } else {
            Start-Process $htmlPath   # OS default open
        }

    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Could not open Controller Telemetry:`n$_",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}


function Install-DesktopShortcut {
    param([string]$IconPath)
    try {
        $shortcutPath = [System.IO.Path]::Combine(
            [Environment]::GetFolderPath('Desktop'),
            'MARIUS Board Configurator.lnk'
        )
        if (Test-Path $shortcutPath) { return }  # Already exists - don't recreate

        $wsh = New-Object -ComObject WScript.Shell
        $sc  = $wsh.CreateShortcut($shortcutPath)
        $sc.TargetPath       = "powershell.exe"
        $sc.Arguments        = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script:InstallPath`""
        $sc.WorkingDirectory = $script:InstallDir
        $sc.Description      = "MARIUS Board Configurator v$script:CurrentVersion"
        if ($IconPath -and (Test-Path $IconPath)) {
            $sc.IconLocation = "$IconPath,0"
        }
        $sc.WindowStyle = 7  # Minimized - hides the PowerShell flash
        $sc.Save()
    } catch {}
}

function Install-StartMenuShortcut {
    param([string]$IconPath)
    try {
        $startMenuDir = [System.IO.Path]::Combine(
            [Environment]::GetFolderPath('StartMenu'),
            'Programs'
        )
        if (-not (Test-Path $startMenuDir)) {
            New-Item -ItemType Directory -Path $startMenuDir -Force | Out-Null
        }
        $shortcutPath = [System.IO.Path]::Combine($startMenuDir, 'MARIUS Board Configurator.lnk')
        if (Test-Path $shortcutPath) { return }  # Already exists - don't recreate

        $wsh = New-Object -ComObject WScript.Shell
        $sc  = $wsh.CreateShortcut($shortcutPath)
        $sc.TargetPath       = "powershell.exe"
        $sc.Arguments        = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script:InstallPath`""
        $sc.WorkingDirectory = $script:InstallDir
        $sc.Description      = "MARIUS Board Configurator v$script:CurrentVersion"
        if ($IconPath -and (Test-Path $IconPath)) {
            $sc.IconLocation = "$IconPath,0"
        }
        $sc.WindowStyle = 7  # Minimized - hides the PowerShell flash
        $sc.Save()
    } catch {}
}

function Invoke-SelfInstall {
    # Install script to %APPDATA%\MARIUS - uses temp file to prevent corruption
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }
        $runningPath = $MyInvocation.ScriptName
        # If running from a real file (not via | iex), copy it directly
        if ($runningPath -and ($runningPath -ne $script:InstallPath) -and (Test-Path $runningPath)) {
            $sourceSize = (Get-Item $runningPath).Length
            if ($sourceSize -gt 10000) {
                Copy-Item -Path $runningPath -Destination $script:InstallPath -Force -ErrorAction SilentlyContinue
            }
        }
        # If AppData file still does not exist, download a clean copy
        if (-not (Test-Path $script:InstallPath)) {
            $wc = New-Object System.Net.WebClient
            $wc.Headers.Add("Cache-Control", "no-cache")
            $tempPath = "$script:InstallPath.tmp"
            $wc.DownloadFile($script:ScriptUrl, $tempPath)
            $tempSize = (Get-Item $tempPath).Length
            if ($tempSize -gt 10000) {
                Move-Item -Path $tempPath -Destination $script:InstallPath -Force
            } else {
                Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
            }
        }
    } catch {}
}

# Hide PowerShell window
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
' -ErrorAction SilentlyContinue
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0) | Out-Null

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================================================================
# DEVICE DATABASES FOR USB ANALYZER
# ============================================================================

$script:IntelCpuIntegrated = @{
    '8a13' = @{ Name = "Ice Lake TB3"; Platform = "10th Gen"; USB = "USB 3.2/TB3" }
    '9a13' = @{ Name = "Tiger Lake-LP TB4"; Platform = "11th Gen"; USB = "USB4/TB4" }
    '9a17' = @{ Name = "Tiger Lake-H TB4"; Platform = "11th Gen"; USB = "USB4/TB4" }
    '461e' = @{ Name = "Alder Lake-P TB4"; Platform = "12th Gen"; USB = "USB4/TB4" }
    '464e' = @{ Name = "Alder Lake-N USB 3.2"; Platform = "Alder Lake-N"; USB = "USB 3.2" }
    'a71e' = @{ Name = "Raptor Lake-P TB4"; Platform = "13th Gen"; USB = "USB4/TB4" }
    '7ec0' = @{ Name = "Meteor Lake-P TB4"; Platform = "Core Ultra"; USB = "USB4/TB4" }
    'a831' = @{ Name = "Lunar Lake TB4"; Platform = "Lunar Lake"; USB = "USB4/TB4" }
}

$script:IntelPch = @{
    '7f6e' = @{ Name = "800 Series PCH USB 3.1"; Platform = "800 Series"; USB = "USB 3.1" }
    '7a60' = @{ Name = "Raptor Lake USB 3.2 Gen 2x2"; Platform = "700 Series"; USB = "20Gbps" }
    '7ae0' = @{ Name = "Alder Lake-S USB 3.2 Gen 2x2"; Platform = "600 Series"; USB = "20Gbps" }
    '51ed' = @{ Name = "Alder Lake USB 3.2"; Platform = "600 Series"; USB = "USB 3.2" }
    '54ed' = @{ Name = "Alder Lake-N USB 3.2 Gen 2"; Platform = "Alder Lake-N"; USB = "10Gbps" }
    '7e7d' = @{ Name = "Meteor Lake USB 3.2 Gen 2"; Platform = "Meteor Lake"; USB = "USB 3.2" }
    'a0ed' = @{ Name = "Tiger Lake-LP USB 3.2 Gen 2"; Platform = "500 Series"; USB = "10Gbps" }
    '43ed' = @{ Name = "Tiger Lake-H USB 3.2 Gen 2"; Platform = "500 Series"; USB = "USB 3.2" }
    '02ed' = @{ Name = "Comet Lake USB 3.1"; Platform = "400 Series"; USB = "USB 3.1" }
    '06ed' = @{ Name = "Comet Lake USB 3.1"; Platform = "400 Series"; USB = "USB 3.1" }
    'a36d' = @{ Name = "Cannon Lake USB 3.1"; Platform = "300 Series"; USB = "USB 3.1" }
    '9ded' = @{ Name = "Cannon Point-LP USB 3.1"; Platform = "300 Series"; USB = "USB 3.1" }
    'a2af' = @{ Name = "200/Z370 USB 3.0"; Platform = "200 Series"; USB = "USB 3.0" }
    'a12f' = @{ Name = "100/C230 USB 3.0"; Platform = "100 Series"; USB = "USB 3.0" }
    '9d2f' = @{ Name = "Sunrise Point-LP USB 3.0"; Platform = "100 Series"; USB = "USB 3.0" }
    '8cb1' = @{ Name = "9 Series USB"; Platform = "9 Series"; USB = "USB 3.0" }
    '8c31' = @{ Name = "8 Series USB"; Platform = "8 Series"; USB = "USB 3.0" }
    '1e31' = @{ Name = "7 Series USB"; Platform = "7 Series"; USB = "USB 3.0" }
}

$script:IntelThunderbolt = @{
    '5782' = @{ Name = "JHL9580 TB5 (80Gbps)"; Platform = "Barlow Ridge"; USB = "USB4/TB5" }
    '5785' = @{ Name = "JHL9540 TB4 (40Gbps)"; Platform = "Barlow Ridge"; USB = "USB4/TB4" }
    '1138' = @{ Name = "TB4 [Maple Ridge 4C]"; Platform = "Maple Ridge"; USB = "USB4/TB4" }
    '1135' = @{ Name = "TB4 [Maple Ridge 2C]"; Platform = "Maple Ridge"; USB = "USB4/TB4" }
    '0b27' = @{ Name = "TB4 [Goshen Ridge]"; Platform = "Goshen Ridge"; USB = "USB4/TB4" }
    '15e9' = @{ Name = "JHL7540 TB3 [Titan Ridge]"; Platform = "Titan Ridge"; USB = "USB 3.1/TB3" }
    '15b5' = @{ Name = "DSL6340 USB 3.1 [Alpine Ridge]"; Platform = "Alpine Ridge"; USB = "USB 3.1/TB3" }
}

$script:AmdCpuIntegrated = @{
    '15b6' = @{ Name = "Raphael/Granite Ridge USB 3.1"; Platform = "Ryzen 7000/9000 (AM5)"; USB = "USB 3.1" }
    '15b7' = @{ Name = "Raphael/Granite Ridge USB 3.1"; Platform = "Ryzen 7000/9000 (AM5)"; USB = "USB 3.1" }
    '1587' = @{ Name = "Strix Halo USB 3.1"; Platform = "Strix Halo (Zen 5)"; USB = "USB 3.1" }
    '158d' = @{ Name = "Strix Halo USB4"; Platform = "Strix Halo (Zen 5)"; USB = "USB4" }
    '161a' = @{ Name = "Rembrandt USB4"; Platform = "Ryzen 6000 Mobile"; USB = "USB4" }
    '161b' = @{ Name = "Rembrandt USB4"; Platform = "Ryzen 6000 Mobile"; USB = "USB4" }
    '15c4' = @{ Name = "Phoenix USB4/TB"; Platform = "Ryzen 7040 Mobile"; USB = "USB4/TB" }
    '1639' = @{ Name = "Renoir/Cezanne USB 3.1"; Platform = "Ryzen 4000/5000 APU"; USB = "USB 3.1" }
    '15e0' = @{ Name = "Raven USB 3.1"; Platform = "Ryzen 2000 APU"; USB = "USB 3.1" }
    '149c' = @{ Name = "Matisse USB 3.0"; Platform = "Ryzen 3000/5000 Desktop"; USB = "USB 3.0" }
    '145f' = @{ Name = "Zeppelin USB 3.0"; Platform = "Ryzen 1000 (Zen)"; USB = "USB 3.0" }
    '163a' = @{ Name = "VanGogh USB0"; Platform = "Steam Deck"; USB = "USB 3.1" }
}

$script:AmdChipset = @{
    '43fc' = @{ Name = "800 Series USB 3.x"; Platform = "X870/B850 (AM5)"; USB = "USB 3.2" }
    '43f7' = @{ Name = "600 Series USB 3.2"; Platform = "X670/B650 (AM5)"; USB = "USB 3.2" }
    '43ee' = @{ Name = "500 Series USB 3.1"; Platform = "X570/B550 (AM4)"; USB = "USB 3.1" }
    '43ec' = @{ Name = "A520 USB 3.1"; Platform = "A520 (AM4)"; USB = "USB 3.1" }
    '43d5' = @{ Name = "400 Series USB 3.1"; Platform = "X470/B450 (AM4)"; USB = "USB 3.1" }
    '43b9' = @{ Name = "X370 USB 3.1"; Platform = "X370 (AM4)"; USB = "USB 3.1" }
    '43ba' = @{ Name = "X399 USB 3.1"; Platform = "X399 (TR)"; USB = "USB 3.1" }
    '7814' = @{ Name = "FCH USB XHCI"; Platform = "Legacy FCH"; USB = "USB 3.0" }
}

$script:ThirdParty = @{
    '1b21_1042' = @{ Name = "ASM1042 USB 3.0"; Vendor = "ASMedia"; USB = "USB 3.0" }
    '1b21_1142' = @{ Name = "ASM1042A USB 3.0"; Vendor = "ASMedia"; USB = "USB 3.0" }
    '1b21_1242' = @{ Name = "ASM1142 USB 3.1"; Vendor = "ASMedia"; USB = "USB 3.1 Gen 2" }
    '1b21_3242' = @{ Name = "ASM3242 USB 3.2"; Vendor = "ASMedia"; USB = "USB 3.2 Gen 2x2" }
    '1106_3483' = @{ Name = "VL805/806 USB 3.0"; Vendor = "VIA"; USB = "USB 3.0" }
    '1912_0014' = @{ Name = "uPD720201 USB 3.0"; Vendor = "Renesas"; USB = "USB 3.0" }
    '1912_0015' = @{ Name = "uPD720202 USB 3.0"; Vendor = "Renesas"; USB = "USB 3.0" }
}

# ============================================================================
# USB ANALYZER HELPER FUNCTIONS
# ============================================================================

function Get-ControllerInfo {
    param([string]$Vid, [string]$Did)
    
    $vid = $Vid.ToLower()
    $did = $Did.ToLower()
    $key = "${vid}_${did}"
    
    if ($vid -eq '8086' -and $script:IntelCpuIntegrated.ContainsKey($did)) {
        $d = $script:IntelCpuIntegrated[$did]
        return @{ Type = "CPU"; ChipCount = 0; Name = $d.Name; Platform = $d.Platform; USB = $d.USB }
    }
    if ($vid -eq '8086' -and $script:IntelThunderbolt.ContainsKey($did)) {
        $d = $script:IntelThunderbolt[$did]
        return @{ Type = "TB"; ChipCount = 0; Name = $d.Name; Platform = $d.Platform; USB = $d.USB }
    }
    if ($vid -eq '8086' -and $script:IntelPch.ContainsKey($did)) {
        $d = $script:IntelPch[$did]
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = $d.Name; Platform = $d.Platform; USB = $d.USB }
    }
    if ($vid -eq '1022' -and $script:AmdCpuIntegrated.ContainsKey($did)) {
        $d = $script:AmdCpuIntegrated[$did]
        return @{ Type = "CPU"; ChipCount = 0; Name = $d.Name; Platform = $d.Platform; USB = $d.USB }
    }
    if ($vid -eq '1022' -and $script:AmdChipset.ContainsKey($did)) {
        $d = $script:AmdChipset[$did]
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = $d.Name; Platform = $d.Platform; USB = $d.USB }
    }
    if ($script:ThirdParty.ContainsKey($key)) {
        $d = $script:ThirdParty[$key]
        return @{ Type = "ADDON"; ChipCount = 1; Name = $d.Name; Platform = $d.Vendor; USB = $d.USB }
    }
    
    if ($vid -eq '8086') {
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = "Intel USB Controller"; Platform = "PCH"; USB = "USB 3.x" }
    }
    if ($vid -eq '1022') {
        return @{ Type = "CHIPSET"; ChipCount = 1; Name = "AMD USB Controller"; Platform = "Chipset"; USB = "USB 3.x" }
    }
    
    return @{ Type = "UNKNOWN"; ChipCount = 1; Name = "Unknown Controller"; Platform = "Unknown"; USB = "?" }
}

function Get-DeviceChain {
    param([string]$InstanceId)
    
    $result = @{ ControllerInfo = $null; HubCount = 0; ChipCount = 0 }
    $currentId = $InstanceId
    $count = 0
    
    while ($currentId -and $count -lt 15) {
        $count++
        
        try {
            $dev = Get-PnpDevice -InstanceId $currentId -ErrorAction SilentlyContinue
            
            if ($currentId -match "ROOT_HUB") {
                $parent = Get-PnpDeviceProperty -InstanceId $currentId -KeyName "DEVPKEY_Device_Parent" -ErrorAction Stop
                $ctrlId = $parent.Data
                
                if ($ctrlId -match "VEN_([0-9A-F]{4}).*DEV_([0-9A-F]{4})") {
                    $vid = $matches[1]
                    $did = $matches[2]
                    $info = Get-ControllerInfo -Vid $vid -Did $did
                    $result.ControllerInfo = $info
                    $result.ChipCount = $info.ChipCount + $result.HubCount
                    return $result
                }
            }
            
            if ($currentId -match "\\HUB\\") {
                $result.HubCount++
            }
            
            $parent = Get-PnpDeviceProperty -InstanceId $currentId -KeyName "DEVPKEY_Device_Parent" -ErrorAction Stop
            $currentId = $parent.Data
        } catch {
            break
        }
    }
    
    return $result
}

# ============================================================================
# BROWSER FUNCTIONS
# ============================================================================

function Get-DefaultBrowser {
    try {
        $userChoice = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" -ErrorAction SilentlyContinue
        $progId = $userChoice.ProgId
        
        if ($progId -match "Chrome") {
            return "Chrome"
        } elseif ($progId -match "Edge") {
            return "Edge"
        } elseif ($progId -match "Brave") {
            return "Brave"
        } elseif ($progId -match "Opera") {
            return "Opera"
        } elseif ($progId -match "Vivaldi") {
            return "Vivaldi"
        } elseif ($progId -match "Arc") {
            return "Arc"
        } else {
            return "Edge"
        }
    } catch {
        return "Edge"
    }
}

function Get-BrowserPath {
    param($browserName)
    
    switch ($browserName) {
        "Edge" {
            $paths = @(
                "$env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe",
                "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
                "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
            )
        }
        "Chrome" {
            $paths = @(
                "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
                "$env:ProgramFiles (x86)\Google\Chrome\Application\chrome.exe",
                "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
            )
        }
        "Brave" {
            $paths = @(
                "$env:ProgramFiles\BraveSoftware\Brave-Browser\Application\brave.exe",
                "$env:ProgramFiles (x86)\BraveSoftware\Brave-Browser\Application\brave.exe",
                "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\Application\brave.exe"
            )
        }
        "Opera" {
            $paths = @(
                "$env:ProgramFiles\Opera\opera.exe",
                "$env:ProgramFiles (x86)\Opera\opera.exe",
                "$env:LOCALAPPDATA\Programs\Opera\opera.exe"
            )
        }
        "Vivaldi" {
            $paths = @(
                "$env:ProgramFiles\Vivaldi\Application\vivaldi.exe",
                "$env:ProgramFiles (x86)\Vivaldi\Application\vivaldi.exe",
                "$env:LOCALAPPDATA\Vivaldi\Application\vivaldi.exe"
            )
        }
        "Arc" {
            $paths = @(
                "$env:LOCALAPPDATA\Arc\Application\arc.exe",
                "$env:ProgramFiles\Arc\Application\arc.exe"
            )
        }
        default {
            return $null
        }
    }
    
    return $paths | Where-Object { Test-Path $_ } | Select-Object -First 1
}

# ============================================================================
# USB ANALYZER WINDOW
# ============================================================================

function Show-UsbAnalyzer {
    $analyzerForm = New-Object System.Windows.Forms.Form
    $analyzerForm.Text = "USB LATENCY ANALYZER V3"
    $analyzerForm.Width = 854
    $analyzerForm.Height = 654
    $analyzerForm.StartPosition = "CenterScreen"
    $analyzerForm.FormBorderStyle = "None"
    $analyzerForm.BackColor = [System.Drawing.Color]::Yellow
    $analyzerForm.Padding = New-Object System.Windows.Forms.Padding(2)

    $mainPanel = New-Object System.Windows.Forms.Panel
    $mainPanel.Location = New-Object System.Drawing.Point(2, 2)
    $mainPanel.Size = New-Object System.Drawing.Size(850, 650)
    $mainPanel.BackColor = [System.Drawing.Color]::Black

    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size(850, 85)
    $headerPanel.BackColor = [System.Drawing.Color]::Black

    $headerPanel.Add_MouseDown({
        $script:dragging = $true
        $script:dragCursorX = [System.Windows.Forms.Cursor]::Position.X - $analyzerForm.Left
        $script:dragCursorY = [System.Windows.Forms.Cursor]::Position.Y - $analyzerForm.Top
    })

    $headerPanel.Add_MouseMove({
        if ($script:dragging) {
            $analyzerForm.Left = [System.Windows.Forms.Cursor]::Position.X - $script:dragCursorX
            $analyzerForm.Top = [System.Windows.Forms.Cursor]::Position.Y - $script:dragCursorY
        }
    })

    $headerPanel.Add_MouseUp({
        $script:dragging = $false
    })

    $analyzerTitlePicBox = New-Object System.Windows.Forms.PictureBox
    $analyzerTitlePicBox.Location = New-Object System.Drawing.Point(0, 0)
    $analyzerTitlePicBox.Size = New-Object System.Drawing.Size(850, 85)
    $analyzerTitlePicBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
    $analyzerTitlePicBox.BackColor = [System.Drawing.Color]::Black

    try {
        $wc2 = New-Object System.Net.WebClient
        $imgBytes2 = $wc2.DownloadData("https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/Title.png")
        $ms2 = New-Object System.IO.MemoryStream($imgBytes2, 0, $imgBytes2.Length)
        $analyzerTitlePicBox.Image = [System.Drawing.Image]::FromStream($ms2)
    } catch {
        $analyzerTitlePicBox.Add_Paint({
            param($sender, $e)
            $font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
            $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Yellow)
            $sf = New-Object System.Drawing.StringFormat
            $sf.Alignment = [System.Drawing.StringAlignment]::Center
            $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
            $rect = New-Object System.Drawing.RectangleF(0, 0, $sender.Width, $sender.Height)
            $e.Graphics.DrawString("USB LATENCY ANALYZER V3", $font, $brush, $rect, $sf)
            $font.Dispose()
            $brush.Dispose()
        })
    }

    $analyzerTitlePicBox.Add_MouseDown({
        $script:dragging = $true
        $script:dragCursorX = [System.Windows.Forms.Cursor]::Position.X - $analyzerForm.Left
        $script:dragCursorY = [System.Windows.Forms.Cursor]::Position.Y - $analyzerForm.Top
    })

    $analyzerTitlePicBox.Add_MouseMove({
        if ($script:dragging) {
            $analyzerForm.Left = [System.Windows.Forms.Cursor]::Position.X - $script:dragCursorX
            $analyzerForm.Top = [System.Windows.Forms.Cursor]::Position.Y - $script:dragCursorY
        }
    })

    $analyzerTitlePicBox.Add_MouseUp({
        $script:dragging = $false
    })

    $headerPanel.Controls.Add($analyzerTitlePicBox)
    $mainPanel.Controls.Add($headerPanel)

    $subtitle = New-Object System.Windows.Forms.Label
    $subtitle.Location = New-Object System.Drawing.Point(30, 105)
    $subtitle.Size = New-Object System.Drawing.Size(790, 25)
    $subtitle.Text = "Count chips between your device and CPU - More chips = more latency"
    $subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $subtitle.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
    $subtitle.TextAlign = "MiddleCenter"
    $subtitle.BackColor = [System.Drawing.Color]::Transparent
    $mainPanel.Controls.Add($subtitle)

    $legend = New-Object System.Windows.Forms.RichTextBox
    $legend.Location = New-Object System.Drawing.Point(30, 135)
    $legend.Size = New-Object System.Drawing.Size(790, 60)
    $legend.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $legend.BackColor = [System.Drawing.Color]::Black
    $legend.BorderStyle = "None"
    $legend.ReadOnly = $true
    $legend.Cursor = [System.Windows.Forms.Cursors]::Arrow

    $legend.SelectionColor = [System.Drawing.Color]::FromArgb(0, 255, 135)
    $legend.AppendText([char]0x25cf + " 0 CHIPS - Direct to CPU (BEST - Lowest Latency)`n")
    $legend.SelectionColor = [System.Drawing.Color]::FromArgb(255, 179, 71)
    $legend.AppendText([char]0x25cf + " 1 CHIP - Through Chipset (GOOD - Normal Latency)`n")
    $legend.SelectionColor = [System.Drawing.Color]::FromArgb(255, 107, 107)
    $legend.AppendText([char]0x25cf + " 2+ CHIPS - Through USB Hub (AVOID - Highest Latency)")

    $mainPanel.Controls.Add($legend)

    $resultsPanel = New-Object System.Windows.Forms.Panel
    $resultsPanel.Location = New-Object System.Drawing.Point(30, 200)
    $resultsPanel.Size = New-Object System.Drawing.Size(790, 350)
    $resultsPanel.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $resultsPanel.BorderStyle = "None"

    $results = New-Object System.Windows.Forms.RichTextBox
    $results.Location = New-Object System.Drawing.Point(1, 1)
    $results.Size = New-Object System.Drawing.Size(788, 348)
    $results.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $results.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
    $results.Font = New-Object System.Drawing.Font("Consolas", 10)
    $results.ReadOnly = $true
    $results.BorderStyle = "None"
    $results.ScrollBars = "Vertical"
    $resultsPanel.Controls.Add($results)
    $mainPanel.Controls.Add($resultsPanel)

    $scanBtn = New-Object System.Windows.Forms.Button
    $scanBtn.Location = New-Object System.Drawing.Point(30, 565)
    $scanBtn.Size = New-Object System.Drawing.Size(380, 50)
    $scanBtn.FlatStyle = "Flat"
    $scanBtn.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $scanBtn.ForeColor = [System.Drawing.Color]::White
    $scanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $scanBtn.Text = ""
    $scanBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $scanBtn.FlatAppearance.BorderSize = 1
    $scanBtn.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $scanBtn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $scanBtn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)

    # Add hover glow effect
    $scanBtn.Add_MouseEnter({
        $this.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 255, 0)
        $this.FlatAppearance.BorderSize = 2
    })
    
    $scanBtn.Add_MouseLeave({
        $this.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
        $this.FlatAppearance.BorderSize = 1
    })

    $scanBtn.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
        
        $titleFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $descFont = New-Object System.Drawing.Font("Segoe UI", 8)
        $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 160, 160))
        
        $g.DrawString("SCAN USB DEVICES", $titleFont, $whiteBrush, 20, 12)
        $g.DrawString("Analyze all connected USB input devices", $descFont, $grayBrush, 20, 32)
        
        $whiteBrush.Dispose()
        $grayBrush.Dispose()
        $titleFont.Dispose()
        $descFont.Dispose()
    })

    $exitBtn = New-Object System.Windows.Forms.Button
    $exitBtn.Location = New-Object System.Drawing.Point(440, 565)
    $exitBtn.Size = New-Object System.Drawing.Size(380, 50)
    $exitBtn.FlatStyle = "Flat"
    $exitBtn.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $exitBtn.ForeColor = [System.Drawing.Color]::White
    $exitBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $exitBtn.Text = ""
    $exitBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $exitBtn.FlatAppearance.BorderSize = 1
    $exitBtn.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $exitBtn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $exitBtn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)

    # Add hover glow effect
    $exitBtn.Add_MouseEnter({
        $this.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 255, 0)
        $this.FlatAppearance.BorderSize = 2
    })
    
    $exitBtn.Add_MouseLeave({
        $this.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
        $this.FlatAppearance.BorderSize = 1
    })

    $exitBtn.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
        
        $titleFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $descFont = New-Object System.Drawing.Font("Segoe UI", 8)
        $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 160, 160))
        
        $g.DrawString("EXIT", $titleFont, $whiteBrush, 20, 12)
        $g.DrawString("Close this application", $descFont, $grayBrush, 20, 32)
        
        $whiteBrush.Dispose()
        $grayBrush.Dispose()
        $titleFont.Dispose()
        $descFont.Dispose()
    })

    $exitBtn.Add_Click({
        $analyzerForm.Close()
    })

    $scanBtn.Add_Click({
        $results.Clear()
        $results.SelectionColor = [System.Drawing.Color]::Yellow
        $results.AppendText("Scanning USB devices...`n`n")
        $analyzerForm.Refresh()
        
        $allDevs = @(Get-PnpDevice -Status OK)
        $usbDevs = $allDevs | Where-Object { $_.InstanceId -match "^USB\\" }
        
        $inputDevs = @()
        foreach ($d in $usbDevs) {
            try {
                $cid = (Get-PnpDeviceProperty -InstanceId $d.InstanceId -KeyName "DEVPKEY_Device_CompatibleIds" -ErrorAction SilentlyContinue).Data
                if ($cid -match "Class_03") {
                    $inputDevs += $d
                }
            } catch {}
        }
        
        $xboxDevs = $allDevs | Where-Object { $_.Class -in @("XboxComposite", "XnaComposite", "XUSBClass") }
        if ($xboxDevs) {
            $inputDevs += $xboxDevs
        }
        
        $deviceData = @()
        $seen = @{}
        
        foreach ($d in $inputDevs) {
            $instId = $d.InstanceId
            $usbParent = $instId
            
            if ($instId -match "^HID\\") {
                try {
                    $parent = Get-PnpDeviceProperty -InstanceId $instId -KeyName "DEVPKEY_Device_Parent" -ErrorAction Stop
                    $usbParent = $parent.Data
                } catch { continue }
            }
            
            $vid = "????"
            $productId = "????"
            if ($usbParent -match "VID_([0-9A-F]{4})") { $vid = $matches[1] }
            if ($usbParent -match "PID_([0-9A-F]{4})") { $productId = $matches[1] }
            
            $key = "${vid}_${productId}"
            if ($seen.ContainsKey($key)) { continue }
            $seen[$key] = $true
            
            $chain = Get-DeviceChain -InstanceId $usbParent
            if (-not $chain.ControllerInfo) { continue }
            
            $devName = $d.FriendlyName
            try {
                $busDesc = (Get-PnpDeviceProperty -InstanceId $usbParent -KeyName "DEVPKEY_Device_BusReportedDeviceDesc" -ErrorAction SilentlyContinue).Data
                if ($busDesc -and $busDesc.Trim()) { $devName = $busDesc.Trim() }
            } catch {}
            
            $deviceData += @{
                Name = $devName
                ChipCount = $chain.ChipCount
                ControllerName = $chain.ControllerInfo.Name
                Platform = $chain.ControllerInfo.Platform
                HubCount = $chain.HubCount
            }
        }
        
        $chip0 = @($deviceData | Where-Object { $_.ChipCount -eq 0 })
        $chip1 = @($deviceData | Where-Object { $_.ChipCount -eq 1 })
        $chip2 = @($deviceData | Where-Object { $_.ChipCount -ge 2 })
        
        $results.SelectionColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
        $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
        $results.AppendText("FOUND $($deviceData.Count) INPUT DEVICES`n")
        $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 10)
        $results.AppendText(([string][char]0x2550) * 67 + "`n`n")
        
        if ($chip0.Count -gt 0) {
            $results.SelectionColor = [System.Drawing.Color]::FromArgb(0, 255, 135)
            $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
            $results.AppendText([char]0x25cf + " 0 CHIPS - DIRECT TO CPU ($($chip0.Count) devices)`n")
            $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 10)
            
            foreach ($dev in $chip0) {
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
                $results.AppendText("   " + [char]0x2514 + [char]0x2500 + " ")
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(0, 255, 135)
                $results.AppendText("$($dev.Name)`n")
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
                $results.AppendText("      $($dev.ControllerName) | $($dev.Platform)`n")
            }
            $results.AppendText("`n")
        }
        
        if ($chip1.Count -gt 0) {
            $results.SelectionColor = [System.Drawing.Color]::FromArgb(255, 179, 71)
            $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
            $results.AppendText([char]0x25cf + " 1 CHIP - THROUGH CHIPSET ($($chip1.Count) devices)`n")
            $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 10)
            
            foreach ($dev in $chip1) {
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
                $results.AppendText("   " + [char]0x2514 + [char]0x2500 + " ")
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(255, 179, 71)
                $results.AppendText("$($dev.Name)`n")
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
                $results.AppendText("      $($dev.ControllerName) | $($dev.Platform)`n")
            }
            $results.AppendText("`n")
        }
        
        if ($chip2.Count -gt 0) {
            $results.SelectionColor = [System.Drawing.Color]::FromArgb(255, 107, 107)
            $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
            $results.AppendText([char]0x25cf + " 2+ CHIPS - THROUGH HUB ($($chip2.Count) devices)`n")
            $results.SelectionFont = New-Object System.Drawing.Font("Consolas", 10)
            
            foreach ($dev in $chip2) {
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
                $results.AppendText("   " + [char]0x2514 + [char]0x2500 + " ")
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(255, 107, 107)
                $results.AppendText("$($dev.Name)`n")
                $results.SelectionColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
                $results.AppendText("      $($dev.ChipCount) chips | $($dev.HubCount) hub(s)`n")
            }
            $results.AppendText("`n")
        }
        
        $results.SelectionColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        $results.AppendText(([string][char]0x2550) * 67 + "`n")
        $results.SelectionColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
        $results.AppendText("TIP: Try different USB ports to find the best latency path!")
    })

    $mainPanel.Controls.Add($scanBtn)
    $mainPanel.Controls.Add($exitBtn)
    
    # Add Credits Label (Red text at bottom) for USB Analyzer
    $analyzerCredits = New-Object System.Windows.Forms.Label
    $analyzerCredits.Location = New-Object System.Drawing.Point(0, 625)
    $analyzerCredits.Size = New-Object System.Drawing.Size(850, 25)
    $analyzerCredits.Text = "Created by: @mariusheier | Script by: @EODBruz"
    $analyzerCredits.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $analyzerCredits.ForeColor = [System.Drawing.Color]::Red
    $analyzerCredits.TextAlign = "MiddleCenter"
    $analyzerCredits.BackColor = [System.Drawing.Color]::Black
    $mainPanel.Controls.Add($analyzerCredits)
    
    $analyzerForm.Controls.Add($mainPanel)

    # ============================================================================
    # RGB BORDER ANIMATION TIMER (USB Analyzer - synced to main window)
    # ============================================================================
    $script:analyzerRgbTimer = New-Object System.Windows.Forms.Timer
    $script:analyzerRgbTimer.Interval = 40

    $script:analyzerRgbTimer.Add_Tick({
        # Read the shared hue from the main window timer - no increment here
        $h = $script:rgbHue / 360.0
        $i = [Math]::Floor($h * 6)
        $f = $h * 6 - $i
        $q = 1 - $f
        $t = $f
        switch ($i % 6) {
            0 { $r = 255; $g = [int]($t * 255); $b = 0 }
            1 { $r = [int]($q * 255); $g = 255; $b = 0 }
            2 { $r = 0; $g = 255; $b = [int]($t * 255) }
            3 { $r = 0; $g = [int]($q * 255); $b = 255 }
            4 { $r = [int]($t * 255); $g = 0; $b = 255 }
            5 { $r = 255; $g = 0; $b = [int]($q * 255) }
        }
        $rgbColorA = [System.Drawing.Color]::FromArgb($r, $g, $b)
        $analyzerForm.BackColor = $rgbColorA
        foreach ($ctrl in $mainPanel.Controls) {
            if ($ctrl -is [System.Windows.Forms.Button]) {
                $ctrl.FlatAppearance.BorderColor = $rgbColorA
            }
        }
    })

    $script:analyzerRgbTimer.Start()

    $analyzerForm.Add_FormClosed({
        $script:analyzerRgbTimer.Stop()
        $script:analyzerRgbTimer.Dispose()
    })

    $analyzerForm.Add_KeyDown({
        param($sender, $e)
        if ($e.KeyCode -eq "Escape") {
            $analyzerForm.Close()
        }
    })

    $analyzerForm.Add_Shown({$analyzerForm.Activate()})
    [void]$analyzerForm.ShowDialog()
}

# ============================================================================
# GAMEBAR NOTIFICATION FIX FUNCTION
# ============================================================================

function Show-GameBarDialog {
    param(
        [string]$Title,
        [string]$Subtitle,
        [string[]]$Lines,
        [string]$ApplyLabel   = "",
        [string]$RestoreLabel = "",
        [string]$CancelLabel  = "CANCEL",
        [bool]$IsApplied      = $false,
        [bool]$ResultOnly     = $false
    )

    # Dimensions
    $W = 620
    $H = if ($ResultOnly) { 390 } else { 480 }

    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text            = ""
    $dlg.Width           = $W
    $dlg.Height          = $H
    $dlg.StartPosition   = "CenterScreen"
    $dlg.FormBorderStyle = "None"
    $dlg.BackColor       = [System.Drawing.Color]::Yellow   # RGB border will replace this
    $dlg.TopMost         = $true

    # Drag state
    $script:gbDrag = $false; $script:gbDX = 0; $script:gbDY = 0

    # Inner dark panel (3px inset for RGB border to show)
    $inner = New-Object System.Windows.Forms.Panel
    $inner.Location  = New-Object System.Drawing.Point(3, 3)
    $inner.Size      = New-Object System.Drawing.Size(($W - 6), ($H - 6))
    $inner.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $dlg.Controls.Add($inner)

    # ── RGB border timer (synced to main window hue) ──────────────────────────
    $script:gbHue = if ($script:rgbHue) { $script:rgbHue } else { 0 }
    $gbRgbTimer = New-Object System.Windows.Forms.Timer
    $gbRgbTimer.Interval = 40
    $gbRgbTimer.Add_Tick({
        $script:gbHue = ($script:gbHue + 2) % 360
        $h = $script:gbHue / 360.0
        $i = [Math]::Floor($h * 6)
        $f = $h * 6 - $i
        $q = 1 - $f; $t = $f
        switch ($i % 6) {
            0 { $r = 255; $g = [int]($t*255); $b = 0 }
            1 { $r = [int]($q*255); $g = 255; $b = 0 }
            2 { $r = 0; $g = 255; $b = [int]($t*255) }
            3 { $r = 0; $g = [int]($q*255); $b = 255 }
            4 { $r = [int]($t*255); $g = 0; $b = 255 }
            5 { $r = 255; $g = 0; $b = [int]($q*255) }
        }
        $dlg.BackColor = [System.Drawing.Color]::FromArgb($r, $g, $b)
    })
    $gbRgbTimer.Start()
    $dlg.Add_FormClosed({ $gbRgbTimer.Stop(); $gbRgbTimer.Dispose() })

    # ── Title bar (GDI+ painted header - matches MARIUS style) ──────────────
    $titleBar = New-Object System.Windows.Forms.Panel
    $titleBar.Location  = New-Object System.Drawing.Point(0, 0)
    $titleBar.Size      = New-Object System.Drawing.Size(($W - 6), 70)
    $titleBar.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $inner.Controls.Add($titleBar)

    $titleBar.Add_MouseDown({ $script:gbDrag=$true; $script:gbDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:gbDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $titleBar.Add_MouseMove({ if($script:gbDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:gbDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:gbDY } })
    $titleBar.Add_MouseUp({ $script:gbDrag=$false })

    # PictureBox paints the title as Impact italic yellow - same as MARIUS header
    $picTitle = New-Object System.Windows.Forms.PictureBox
    $picTitle.Location  = New-Object System.Drawing.Point(0, 0)
    $picTitle.Size      = New-Object System.Drawing.Size(($W - 50), 70)
    $picTitle.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $dlgTitle = $Title
    $picTitle.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
        $shadowFont  = New-Object System.Drawing.Font("Impact", 22, [System.Drawing.FontStyle]::Italic)
        $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80, 0, 0, 0))
        $titleFont   = New-Object System.Drawing.Font("Impact", 22, [System.Drawing.FontStyle]::Italic)
        $titleBrush  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Yellow)
        $g.DrawString($dlgTitle, $shadowFont, $shadowBrush, 22, 17)
        $g.DrawString($dlgTitle, $titleFont,  $titleBrush,  20, 15)
        $shadowFont.Dispose(); $shadowBrush.Dispose()
        $titleFont.Dispose();  $titleBrush.Dispose()
    }.GetNewClosure())
    $picTitle.Add_MouseDown({ $script:gbDrag=$true; $script:gbDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:gbDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $picTitle.Add_MouseMove({ if($script:gbDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:gbDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:gbDY } })
    $picTitle.Add_MouseUp({ $script:gbDrag=$false })
    $titleBar.Controls.Add($picTitle)

    # X button - plain ASCII X, no unicode issues
    $btnX = New-Object System.Windows.Forms.Button
    $btnX.Location  = New-Object System.Drawing.Point(($W - 52), 18)
    $btnX.Size      = New-Object System.Drawing.Size(32, 32)
    $btnX.Text      = "X"
    $btnX.FlatStyle = "Flat"
    $btnX.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $btnX.ForeColor = [System.Drawing.Color]::FromArgb(140, 140, 140)
    $btnX.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnX.FlatAppearance.BorderSize = 0
    $btnX.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnX.Add_Click({ $dlg.Tag = "cancel"; $dlg.Close() })
    $btnX.Add_MouseEnter({ $btnX.ForeColor = [System.Drawing.Color]::White })
    $btnX.Add_MouseLeave({ $btnX.ForeColor = [System.Drawing.Color]::FromArgb(140,140,140) })
    $titleBar.Controls.Add($btnX)

    # Divider line
    $div = New-Object System.Windows.Forms.Panel
    $div.Location  = New-Object System.Drawing.Point(0, 70)
    $div.Size      = New-Object System.Drawing.Size(($W - 6), 2)
    $div.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $inner.Controls.Add($div)

    # Subtitle
    $lblSub = New-Object System.Windows.Forms.Label
    $lblSub.Location  = New-Object System.Drawing.Point(20, 82)
    $lblSub.Size      = New-Object System.Drawing.Size(($W - 46), 26)
    $lblSub.Text      = $Subtitle
    $lblSub.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
    $lblSub.ForeColor = [System.Drawing.Color]::FromArgb(160, 160, 160)
    $lblSub.BackColor = [System.Drawing.Color]::Transparent
    $inner.Controls.Add($lblSub)

    # Detail lines
    $yPos = 116
    foreach ($line in $Lines) {
        if ($line -eq "") { $yPos += 10; continue }
        $isHeader = $line.StartsWith("##")
        $text = $line.TrimStart("#").Trim()
        $lbl = New-Object System.Windows.Forms.Label
        $lbl.Location  = New-Object System.Drawing.Point(20, $yPos)
        $lbl.Size      = New-Object System.Drawing.Size(($W - 46), 24)
        $lbl.Text      = $text
        $lbl.BackColor = [System.Drawing.Color]::Transparent
        if ($isHeader) {
            $lbl.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
            $lbl.ForeColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
        } else {
            $lbl.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
            $lbl.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
        }
        $inner.Controls.Add($lbl)
        $yPos += 24
    }

    if (-not $ResultOnly) {
        # Status badge
        $statusBg = New-Object System.Windows.Forms.Panel
        $statusBg.Location  = New-Object System.Drawing.Point(20, ($H - 122))
        $statusBg.Size      = New-Object System.Drawing.Size(($W - 46), 28)
        $statusBg.BackColor = [System.Drawing.Color]::FromArgb(22, 22, 22)
        $inner.Controls.Add($statusBg)

        $badge = New-Object System.Windows.Forms.Label
        $badge.Location  = New-Object System.Drawing.Point(0, 0)
        $badge.Size      = New-Object System.Drawing.Size(($W - 46), 28)
        $badge.Text      = if ($IsApplied) { "  >> STATUS: CURRENTLY APPLIED" } else { "  >> STATUS: NOT APPLIED" }
        $badge.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $badge.ForeColor = if ($IsApplied) { [System.Drawing.Color]::FromArgb(80,210,80) } else { [System.Drawing.Color]::FromArgb(210,70,70) }
        $badge.BackColor = [System.Drawing.Color]::Transparent
        $badge.TextAlign = "MiddleLeft"
        $statusBg.Controls.Add($badge)

        # Two buttons centred, with RGB border panels behind them
        $btnW   = 220
        $btnH   = 50
        $btnGap = 24
        $btnY   = $H - 88
        $totalW = ($btnW * 2) + $btnGap
        $startX = [int](($W - 6 - $totalW) / 2)

        # RGB wrapper panels (2px border, button sits 2px inset)
        $rgbApplyPanel = New-Object System.Windows.Forms.Panel
        $rgbApplyPanel.Location  = New-Object System.Drawing.Point($startX, $btnY)
        $rgbApplyPanel.Size      = New-Object System.Drawing.Size(($btnW + 4), ($btnH + 4))
        $rgbApplyPanel.BackColor = [System.Drawing.Color]::Yellow
        $inner.Controls.Add($rgbApplyPanel)

        $rgbRestorePanel = New-Object System.Windows.Forms.Panel
        $rgbRestorePanel.Location  = New-Object System.Drawing.Point(($startX + $btnW + 4 + $btnGap), $btnY)
        $rgbRestorePanel.Size      = New-Object System.Drawing.Size(($btnW + 4), ($btnH + 4))
        $rgbRestorePanel.BackColor = [System.Drawing.Color]::Yellow
        $inner.Controls.Add($rgbRestorePanel)

        # Hook the existing RGB timer to also update the button border panels
        $gbRgbTimer.Add_Tick({
            $c = $dlg.BackColor
            $rgbApplyPanel.BackColor   = $c
            $rgbRestorePanel.BackColor = $c
        })

        $btnApply = New-Object System.Windows.Forms.Button
        $btnApply.Location  = New-Object System.Drawing.Point(2, 2)
        $btnApply.Size      = New-Object System.Drawing.Size($btnW, $btnH)
        $btnApply.Text      = $ApplyLabel
        $btnApply.FlatStyle = "Flat"
        $btnApply.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
        $btnApply.ForeColor = [System.Drawing.Color]::Yellow
        $btnApply.Font      = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $btnApply.FlatAppearance.BorderSize  = 0
        $btnApply.Cursor    = [System.Windows.Forms.Cursors]::Hand
        $btnApply.Add_Click({ $dlg.Tag = "apply"; $dlg.Close() })
        $btnApply.Add_MouseEnter({ $btnApply.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 12) })
        $btnApply.Add_MouseLeave({ $btnApply.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20) })
        $rgbApplyPanel.Controls.Add($btnApply)

        $btnRestore = New-Object System.Windows.Forms.Button
        $btnRestore.Location  = New-Object System.Drawing.Point(2, 2)
        $btnRestore.Size      = New-Object System.Drawing.Size($btnW, $btnH)
        $btnRestore.Text      = $RestoreLabel
        $btnRestore.FlatStyle = "Flat"
        $btnRestore.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
        $btnRestore.ForeColor = [System.Drawing.Color]::FromArgb(220, 50, 50)
        $btnRestore.Font      = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $btnRestore.FlatAppearance.BorderSize  = 0
        $btnRestore.Cursor    = [System.Windows.Forms.Cursors]::Hand
        $btnRestore.Add_Click({ $dlg.Tag = "restore"; $dlg.Close() })
        $btnRestore.Add_MouseEnter({ $btnRestore.BackColor = [System.Drawing.Color]::FromArgb(40, 15, 15) })
        $btnRestore.Add_MouseLeave({ $btnRestore.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20) })
        $rgbRestorePanel.Controls.Add($btnRestore)

        # Credits
        $lblCredits = New-Object System.Windows.Forms.Label
        $lblCredits.Location  = New-Object System.Drawing.Point(0, ($H - 30))
        $lblCredits.Size      = New-Object System.Drawing.Size(($W - 6), 20)
        $lblCredits.Text      = "GameBar fix by: @FR33THY  |  Script by: @EODBruz"
        $lblCredits.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
        $lblCredits.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
        $lblCredits.BackColor = [System.Drawing.Color]::Transparent
        $lblCredits.TextAlign = "MiddleCenter"
        $inner.Controls.Add($lblCredits)

    } else {
        # Single OK button centred with RGB border
        $okBtnW = 220; $okBtnH = 50
        $okX = [int](($W - 6 - $okBtnW - 4) / 2)
        $okY = $H - 84

        $rgbOkPanel = New-Object System.Windows.Forms.Panel
        $rgbOkPanel.Location  = New-Object System.Drawing.Point($okX, $okY)
        $rgbOkPanel.Size      = New-Object System.Drawing.Size(($okBtnW + 4), ($okBtnH + 4))
        $rgbOkPanel.BackColor = [System.Drawing.Color]::Yellow
        $inner.Controls.Add($rgbOkPanel)

        $gbRgbTimer.Add_Tick({ $rgbOkPanel.BackColor = $dlg.BackColor })

        $btnOk = New-Object System.Windows.Forms.Button
        $btnOk.Location  = New-Object System.Drawing.Point(2, 2)
        $btnOk.Size      = New-Object System.Drawing.Size($okBtnW, $okBtnH)
        $btnOk.Text      = "OK"
        $btnOk.FlatStyle = "Flat"
        $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
        $btnOk.ForeColor = [System.Drawing.Color]::Yellow
        $btnOk.Font      = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $btnOk.FlatAppearance.BorderSize = 0
        $btnOk.Cursor    = [System.Windows.Forms.Cursors]::Hand
        $btnOk.Add_Click({ $dlg.Tag = "ok"; $dlg.Close() })
        $btnOk.Add_MouseEnter({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(40,40,12) })
        $btnOk.Add_MouseLeave({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20,20,20) })
        $rgbOkPanel.Controls.Add($btnOk)
    }

    $dlg.Add_KeyDown({ param($s,$e); if($e.KeyCode -eq "Escape"){ $dlg.Tag="cancel"; $dlg.Close() } })
    [void]$dlg.ShowDialog()
    return $dlg.Tag
}

function Invoke-GameBarNotificationFix {
    # Check current state
    $isApplied = (Get-ItemProperty "Registry::HKCR\ms-gamebar" -Name "NoOpenWith" -ErrorAction SilentlyContinue) -ne $null

    # ── Styled confirm dialog ─────────────────────────────────────────────────
    $choice = Show-GameBarDialog `
        -Title        "GAMEBAR NOTIFICATION FIX" `
        -Subtitle     "Select an action below:" `
        -Lines        @(
            "## What this fix does:",
            "  [+]  Disables GameDVR and AppCapture",
            "  [+]  Blocks controller GameBar hotkeys",
            "  [+]  Hijacks ms-gamebar URI handlers",
            "  [+]  Deactivates PresenceWriter service",
            "  [+]  Kills running GameBar process",
            "",
            "  Recommended for 8K polling rate controllers."
        ) `
        -ApplyLabel   "APPLY" `
        -RestoreLabel "RESTORE" `
        -CancelLabel  "CANCEL" `
        -IsApplied    $isApplied

    if ($choice -eq "cancel" -or $choice -eq $null) { return }
    $cl     = if ($choice -eq "apply") { 'apply' } else { 'restore' }
    $toggle = if ($cl -eq 'apply') { 0 } else { 1 }

    # ── HKCU tweaks (no admin needed) ────────────────────────────────────────
    sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled"       $toggle -type dword -force -ea 0
    sp "HKCU:\System\GameConfigStore"                            "GameDVR_Enabled"          $toggle -type dword -force -ea 0
    sp "HKCU:\SOFTWARE\Microsoft\GameBar" "UseNexusForGameBarEnabled" $toggle -type dword -force -ea 0
    sp "HKCU:\SOFTWARE\Microsoft\GameBar" "GamepadNexusChordEnabled"  $toggle -type dword -force -ea 0

    # ── Admin block (HKCR + HKLM changes) ────────────────────────────────────
    $psBlock = [scriptblock]::Create(@"
        `$toggle = $toggle
        `$cl     = '$cl'

        "ms-gamebar","ms-gamebarservices","ms-gamingoverlay" | ForEach-Object {
            if (!(Test-Path "Registry::HKCR\`$_\shell"))              { New-Item "Registry::HKCR\`$_\shell"              -Force | Out-Null }
            if (!(Test-Path "Registry::HKCR\`$_\shell\open"))         { New-Item "Registry::HKCR\`$_\shell\open"         -Force | Out-Null }
            if (!(Test-Path "Registry::HKCR\`$_\shell\open\command")) { New-Item "Registry::HKCR\`$_\shell\open\command" -Force | Out-Null }
            Set-ItemProperty "Registry::HKCR\`$_" "(Default)"    "URL:`$_" -Force
            Set-ItemProperty "Registry::HKCR\`$_" "URL Protocol" ""        -Force
            if (`$toggle -eq 0) {
                Set-ItemProperty "Registry::HKCR\`$_"                    "NoOpenWith" ""                                              -Force
                Set-ItemProperty "Registry::HKCR\`$_\shell\open\command" "(Default)"  "`"`$env:SystemRoot\System32\systray.exe`"" -Force
            } else {
                Remove-ItemProperty "Registry::HKCR\`$_" "NoOpenWith" -Force -ErrorAction SilentlyContinue
                Remove-Item         "Registry::HKCR\`$_\shell" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        `$presencePath = "HKLM:\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter"
        if (Test-Path `$presencePath) {
            Set-ItemProperty `$presencePath "ActivationType" (if (`$toggle -eq 0) { 0 } else { 1 }) -Force -ErrorAction SilentlyContinue
        }

        if (`$toggle -eq 0) {
            Stop-Process -Force -Name GameBar -ErrorAction SilentlyContinue
            cmd /c "sc stop GameInputSvc >nul 2>&1"
            "gamingservices","gamingservicesnet","GameInputRedistService" | ForEach-Object {
                Stop-Process -Name `$_ -Force -ErrorAction SilentlyContinue
            }
        }
"@)

    $isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups.Value -contains 'S-1-5-32-544'
    if ($isAdmin) { . $psBlock }
    else {
        $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($psBlock.ToString()))
        Start-Process powershell -ArgumentList "-nop -enc $encoded" -Verb RunAs -Wait -ErrorAction SilentlyContinue
    }

    # ── Styled result dialog ──────────────────────────────────────────────────
    if ($cl -eq 'apply') {
        Show-GameBarDialog `
            -Title      "GAMEBAR REMOVED" `
            -Subtitle   "All changes applied successfully." `
            -Lines      @(
                "## Changes applied:",
                "  [+]  GameDVR / AppCapture disabled",
                "  [+]  Controller GameBar hotkeys disabled",
                "  [+]  ms-gamebar URI handlers blocked",
                "  [+]  PresenceWriter service deactivated",
                "  [+]  GameBar process stopped"
            ) `
            -ResultOnly $true | Out-Null
    } else {
        Show-GameBarDialog `
            -Title      "GAMEBAR RESTORED" `
            -Subtitle   "All changes reverted to Windows defaults." `
            -Lines      @(
                "## Changes restored:",
                "  [-]  GameDVR / AppCapture re-enabled",
                "  [-]  Controller GameBar hotkeys re-enabled",
                "  [-]  ms-gamebar URI handlers restored",
                "  [-]  PresenceWriter service re-activated"
            ) `
            -ResultOnly $true | Out-Null
    }
}

# ============================================================================
# SETTINGS HELPERS (Settings.ini in %APPDATA%\MARIUS)
# ============================================================================

function Read-Settings {
    $script:MusicEnabled = $false   # Muted by default
    $script:MusicVolume  = 38       # 38% volume by default
    try {
        if (Test-Path $script:SettingsPath) {
            Get-Content $script:SettingsPath | ForEach-Object {
                if ($_ -match '^\s*MusicEnabled\s*=\s*(.+)') {
                    $script:MusicEnabled = ($matches[1].Trim() -eq "True")
                }
                if ($_ -match '^\s*MusicVolume\s*=\s*(\d+)') {
                    $v = [int]$matches[1]
                    $script:MusicVolume = [Math]::Max(0, [Math]::Min(100, $v))
                }
            }
        }
    } catch {}
}

function Save-Settings {
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }
        $val = if ($script:MusicEnabled) { "True" } else { "False" }
        $vol = if ($null -ne $script:MusicVolume) { $script:MusicVolume } else { 38 }

        if (-not (Test-Path $script:SettingsPath)) {
            # File doesn't exist yet — create it fresh with defaults + comments
            $lines = @(
                "MusicEnabled=$val",
                "MusicVolume=$vol",
                "",
                "# MusicEnabled: True or False",
                "# MusicVolume:  0 to 100"
            )
            Set-Content -Path $script:SettingsPath -Value $lines -Encoding UTF8
        } else {
            # File exists — surgically update only MusicEnabled and MusicVolume lines.
            # All other content (comments, custom keys, whitespace) is preserved.
            $raw = Get-Content $script:SettingsPath
            $updatedEnabled = $false
            $updatedVolume  = $false
            $out = $raw | ForEach-Object {
                if ($_ -match '^\s*MusicEnabled\s*=') { $updatedEnabled = $true; "MusicEnabled=$val" }
                elseif ($_ -match '^\s*MusicVolume\s*=') { $updatedVolume = $true; "MusicVolume=$vol" }
                else { $_ }
            }
            # Append any keys that were missing entirely
            if (-not $updatedEnabled) { $out += "MusicEnabled=$val" }
            if (-not $updatedVolume)  { $out += "MusicVolume=$vol"  }
            Set-Content -Path $script:SettingsPath -Value $out -Encoding UTF8
        }
    } catch {}
}

function Open-Settings {
    try {
        if (-not (Test-Path $script:SettingsPath)) { Save-Settings }
        Start-Process "notepad.exe" -ArgumentList "`"$script:SettingsPath`""
    } catch {}
}

# ============================================================================
# MUSIC via mciSendString (winmm.dll) - reliable MP3 looping
# ============================================================================

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class MciAudio {
    [DllImport("winmm.dll", CharSet = CharSet.Auto)]
    public static extern int mciSendString(string command, string returnString, int returnLength, IntPtr hwndCallback);
    [DllImport("winmm.dll")]
    public static extern int waveOutSetVolume(IntPtr hwo, uint dwVolume);
    public static void SendCommand(string cmd) {
        mciSendString(cmd, null, 0, IntPtr.Zero);
    }
    public static void SetVolume(int percent) {
        // percent 0-100, maps to 0-0xFFFF on each channel
        uint vol = (uint)(percent * 0xFFFF / 100);
        uint stereo = (vol & 0xFFFF) | ((vol & 0xFFFF) << 16);
        waveOutSetVolume(IntPtr.Zero, stereo);
    }
}
"@ -ErrorAction SilentlyContinue

function Get-MusicFile {
    try {
        if (-not (Test-Path $script:MusicPath)) {
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($script:MusicUrl, $script:MusicPath)
        }
    } catch {}
}

function Start-Music {
    if (-not $script:MusicEnabled) { return }
    try {
        if (-not (Test-Path $script:MusicPath)) { return }
        [MciAudio]::SendCommand("close MariusMusic")
        [MciAudio]::SendCommand("open `"$($script:MusicPath)`" type mpegvideo alias MariusMusic")
        $vol = if ($null -ne $script:MusicVolume) { $script:MusicVolume } else { 38 }
        [MciAudio]::SetVolume($vol)
        [MciAudio]::SendCommand("play MariusMusic repeat")
    } catch {}
}

function Stop-Music {
    try {
        [MciAudio]::SendCommand("stop MariusMusic")
        [MciAudio]::SendCommand("close MariusMusic")
    } catch {}
}

function Toggle-Music {
    $script:MusicEnabled = -not $script:MusicEnabled
    Save-Settings
    if ($script:MusicEnabled) {
        Start-Music
    } else {
        Stop-Music
    }
}

# ============================================================================
# STARTUP: INSTALL, ICON, SHORTCUT, UPDATE CHECK
# ============================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 1. Install script to %APPDATA%\MARIUS if needed
Invoke-SelfInstall

# 2. Read saved settings
Read-Settings

# 3. Download music file if not cached, then start playback
Get-MusicFile
Start-Music

# 2. Extract MBC icon and create Desktop shortcut (first run only)
$script:IconPath = Install-MbcIcon
Install-DesktopShortcut -IconPath $script:IconPath
Install-StartMenuShortcut -IconPath $script:IconPath

# ============================================================================
# MAIN BROWSER WINDOW
# ============================================================================

$script:form = New-Object System.Windows.Forms.Form
$form = $script:form
$form.Text = "MARIUS BOARD CONFIGURATOR"
$form.Width = 854
$form.Height = 834
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::Yellow
$form.Padding = New-Object System.Windows.Forms.Padding(2)

# Apply MBC icon to taskbar/window
try {
    if ($script:IconPath -and (Test-Path $script:IconPath)) {
        $form.Icon = New-Object System.Drawing.Icon($script:IconPath)
    }
} catch {}

$form.Add_Shown({
    $DWM_BB_ENABLE = 1
    $DWM_BB_BLURREGION = 2
    $dwmApi = Add-Type -MemberDefinition @"
        [DllImport("dwmapi.dll")]
        public static extern int DwmExtendFrameIntoClientArea(IntPtr hWnd, ref MARGINS pMarInset);
        [StructLayout(LayoutKind.Sequential)]
        public struct MARGINS { public int Left, Right, Top, Bottom; }
"@ -Name "DwmApi" -Namespace "Win32" -PassThru -ErrorAction SilentlyContinue
})

$mainPanel = New-Object System.Windows.Forms.Panel
$script:mainPanel = $mainPanel
$mainPanel.Location = New-Object System.Drawing.Point(2, 2)
$mainPanel.Size = New-Object System.Drawing.Size(850, 830)
$mainPanel.BackColor = [System.Drawing.Color]::Black

$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.Size = New-Object System.Drawing.Size(850, 85)
$headerPanel.BackColor = [System.Drawing.Color]::Black

$headerPanel.Add_MouseDown({
    $script:dragging = $true
    $script:dragCursorX = [System.Windows.Forms.Cursor]::Position.X - $form.Left
    $script:dragCursorY = [System.Windows.Forms.Cursor]::Position.Y - $form.Top
})

$headerPanel.Add_MouseMove({
    if ($script:dragging) {
        $form.Left = [System.Windows.Forms.Cursor]::Position.X - $script:dragCursorX
        $form.Top = [System.Windows.Forms.Cursor]::Position.Y - $script:dragCursorY
    }
})

$headerPanel.Add_MouseUp({
    $script:dragging = $false
})

# --- TITLE IMAGE (replaces text label) ---
$titlePicBox = New-Object System.Windows.Forms.PictureBox
$titlePicBox.Location = New-Object System.Drawing.Point(0, 0)
$titlePicBox.Size = New-Object System.Drawing.Size(850, 85)
$titlePicBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$titlePicBox.BackColor = [System.Drawing.Color]::Black

try {
    $wc = New-Object System.Net.WebClient
    $imgBytes = $wc.DownloadData("https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/Title.png")
    $ms = New-Object System.IO.MemoryStream($imgBytes, 0, $imgBytes.Length)
    $titlePicBox.Image = [System.Drawing.Image]::FromStream($ms)
} catch {
    # Fallback: draw text if image fails to load
    $titlePicBox.Add_Paint({
        param($sender, $e)
        $font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
        $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Yellow)
        $sf = New-Object System.Drawing.StringFormat
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rect = New-Object System.Drawing.RectangleF(0, 0, $sender.Width, $sender.Height)
        $e.Graphics.DrawString("MARIUS BOARD CONFIGURATOR", $font, $brush, $rect, $sf)
        $font.Dispose()
        $brush.Dispose()
    })
}

$titlePicBox.Add_MouseDown({
    $script:dragging = $true
    $script:dragCursorX = [System.Windows.Forms.Cursor]::Position.X - $form.Left
    $script:dragCursorY = [System.Windows.Forms.Cursor]::Position.Y - $form.Top
})

$titlePicBox.Add_MouseMove({
    if ($script:dragging) {
        $form.Left = [System.Windows.Forms.Cursor]::Position.X - $script:dragCursorX
        $form.Top = [System.Windows.Forms.Cursor]::Position.Y - $script:dragCursorY
    }
})

$titlePicBox.Add_MouseUp({
    $script:dragging = $false
})

$headerPanel.Controls.Add($titlePicBox)
$mainPanel.Controls.Add($headerPanel)

# ============================================================================
# PAGE NAVIGATION HELPERS — swap tiles in-place on the MAIN window
# ============================================================================

# Collect main-menu tile buttons after they are built (populated below)
$script:mainTiles    = [System.Collections.Generic.List[System.Windows.Forms.Control]]::new()
$script:toolboxTiles = [System.Collections.Generic.List[System.Windows.Forms.Control]]::new()

function Show-AppInfoDialog {
    $W = 660; $H = 720
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text            = ""
    $dlg.Width           = $W
    $dlg.Height          = $H
    $dlg.StartPosition   = "CenterScreen"
    $dlg.FormBorderStyle = "None"
    $dlg.BackColor       = [System.Drawing.Color]::Yellow
    $dlg.TopMost         = $true

    $script:aiDrag = $false; $script:aiDX = 0; $script:aiDY = 0

    $inner = New-Object System.Windows.Forms.Panel
    $inner.Location  = New-Object System.Drawing.Point(3, 3)
    $inner.Size      = New-Object System.Drawing.Size(($W - 6), ($H - 6))
    $inner.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $dlg.Controls.Add($inner)

    # ── RGB border timer ─────────────────────────────────────────────────────
    $aiRgbTimer = New-Object System.Windows.Forms.Timer
    $aiRgbTimer.Interval = 40
    $aiRgbTimer.Add_Tick({
        $script:rgbHue = ($script:rgbHue + 2) % 360
        $h = $script:rgbHue / 360.0; $i = [Math]::Floor($h * 6); $f = $h * 6 - $i; $q = 1 - $f; $t = $f
        switch ($i % 6) {
            0 { $r=255; $g=[int]($t*255); $b=0 }
            1 { $r=[int]($q*255); $g=255; $b=0 }
            2 { $r=0; $g=255; $b=[int]($t*255) }
            3 { $r=0; $g=[int]($q*255); $b=255 }
            4 { $r=[int]($t*255); $g=0; $b=255 }
            5 { $r=255; $g=0; $b=[int]($q*255) }
        }
        $dlg.BackColor = [System.Drawing.Color]::FromArgb($r, $g, $b)
    })
    $aiRgbTimer.Start()
    $dlg.Add_FormClosed({ $aiRgbTimer.Stop(); $aiRgbTimer.Dispose() })

    # ── Title bar ────────────────────────────────────────────────────────────
    $titleBar = New-Object System.Windows.Forms.Panel
    $titleBar.Location  = New-Object System.Drawing.Point(0, 0)
    $titleBar.Size      = New-Object System.Drawing.Size(($W - 6), 70)
    $titleBar.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $inner.Controls.Add($titleBar)
    $titleBar.Add_MouseDown({ $script:aiDrag=$true; $script:aiDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:aiDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $titleBar.Add_MouseMove({ if($script:aiDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:aiDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:aiDY } })
    $titleBar.Add_MouseUp({ $script:aiDrag=$false })

    $picTitle = New-Object System.Windows.Forms.PictureBox
    $picTitle.Location  = New-Object System.Drawing.Point(0, 0)
    $picTitle.Size      = New-Object System.Drawing.Size(($W - 50), 70)
    $picTitle.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $picTitle.Add_Paint({
        param($sender, $e); $g=$e.Graphics
        $g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
        $sf=New-Object System.Drawing.Font("Impact",22,[System.Drawing.FontStyle]::Italic)
        $sb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80,0,0,0))
        $tf=New-Object System.Drawing.Font("Impact",22,[System.Drawing.FontStyle]::Italic)
        $tb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Yellow)
        $g.DrawString("APP INFORMATION",$sf,$sb,22,17)
        $g.DrawString("APP INFORMATION",$tf,$tb,20,15)
        $sf.Dispose();$sb.Dispose();$tf.Dispose();$tb.Dispose()
    })
    $picTitle.Add_MouseDown({ $script:aiDrag=$true; $script:aiDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:aiDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $picTitle.Add_MouseMove({ if($script:aiDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:aiDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:aiDY } })
    $picTitle.Add_MouseUp({ $script:aiDrag=$false })
    $titleBar.Controls.Add($picTitle)

    # ── Divider ──────────────────────────────────────────────────────────────
    $div = New-Object System.Windows.Forms.Panel
    $div.Location  = New-Object System.Drawing.Point(0, 70)
    $div.Size      = New-Object System.Drawing.Size(($W - 6), 2)
    $div.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $inner.Controls.Add($div)

    # ── OFFICIAL APP BADGE ───────────────────────────────────────────────────
    $badgePanel = New-Object System.Windows.Forms.Panel
    $badgePanel.Location  = New-Object System.Drawing.Point(20, 82)
    $badgePanel.Size      = New-Object System.Drawing.Size(($W - 46), 36)
    $badgePanel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 0)
    $inner.Controls.Add($badgePanel)

    $badgeLabel = New-Object System.Windows.Forms.Label
    $badgeLabel.Location  = New-Object System.Drawing.Point(0, 0)
    $badgeLabel.Size      = New-Object System.Drawing.Size(($W - 46), 36)
    $badgeLabel.Text      = "  OFFICIAL APPLICATION  |  Developed & Maintained by @EODBruz"
    $badgeLabel.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $badgeLabel.ForeColor = [System.Drawing.Color]::Yellow
    $badgeLabel.BackColor = [System.Drawing.Color]::Transparent
    $badgeLabel.TextAlign = "MiddleLeft"
    $badgePanel.Controls.Add($badgeLabel)

    # ── App info grid ────────────────────────────────────────────────────────
    $infoLines = @(
        @{Text="Application:";   Value="MARIUS Board Configurator"},
        @{Text="Version:";       Value="v$script:CurrentVersion"},
        @{Text="Developer:";     Value="@EODBruz"},
        @{Text="Platform:";      Value="Windows (PowerShell 5.1+)"},
        @{Text="Repository:";    Value="github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR"}
    )
    $yPos = 130
    foreach ($line in $infoLines) {
        $lblKey = New-Object System.Windows.Forms.Label
        $lblKey.Location  = New-Object System.Drawing.Point(30, $yPos)
        $lblKey.Size      = New-Object System.Drawing.Size(160, 22)
        $lblKey.Text      = $line.Text
        $lblKey.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $lblKey.ForeColor = [System.Drawing.Color]::Yellow
        $lblKey.BackColor = [System.Drawing.Color]::Transparent
        $inner.Controls.Add($lblKey)

        $lblVal = New-Object System.Windows.Forms.Label
        $lblVal.Location  = New-Object System.Drawing.Point(200, $yPos)
        $lblVal.Size      = New-Object System.Drawing.Size(($W - 226), 22)
        $lblVal.Text      = $line.Value
        $lblVal.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
        $lblVal.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        $lblVal.BackColor = [System.Drawing.Color]::Transparent
        $inner.Controls.Add($lblVal)
        $yPos += 26
    }

    # ── Divider before license ───────────────────────────────────────────────
    $div2 = New-Object System.Windows.Forms.Panel
    $div2.Location  = New-Object System.Drawing.Point(20, ($yPos + 6))
    $div2.Size      = New-Object System.Drawing.Size(($W - 46), 1)
    $div2.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $inner.Controls.Add($div2)

    # ── License Agreement header ─────────────────────────────────────────────
    $licHeader = New-Object System.Windows.Forms.Label
    $licHeader.Location  = New-Object System.Drawing.Point(30, ($yPos + 14))
    $licHeader.Size      = New-Object System.Drawing.Size(($W - 60), 22)
    $licHeader.Text      = "LICENSE AGREEMENT"
    $licHeader.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $licHeader.ForeColor = [System.Drawing.Color]::Yellow
    $licHeader.BackColor = [System.Drawing.Color]::Transparent
    $inner.Controls.Add($licHeader)

    # ── Scrollable license text box ──────────────────────────────────────────
    $licBoxTop  = $yPos + 40
    $licBoxH    = $H - $licBoxTop - 100
    $licBox = New-Object System.Windows.Forms.RichTextBox
    $licBox.Location   = New-Object System.Drawing.Point(20, $licBoxTop)
    $licBox.Size       = New-Object System.Drawing.Size(($W - 46), $licBoxH)
    $licBox.BackColor  = [System.Drawing.Color]::FromArgb(18, 18, 18)
    $licBox.ForeColor  = [System.Drawing.Color]::FromArgb(190, 190, 190)
    $licBox.Font       = New-Object System.Drawing.Font("Segoe UI", 8)
    $licBox.ReadOnly   = $true
    $licBox.BorderStyle = "None"
    $licBox.ScrollBars = "Vertical"
    $licBox.Text = @"
MARIUS BOARD CONFIGURATOR -- END USER LICENSE AGREEMENT
=======================================================
Copyright (c) $((Get-Date).Year) @EODBruz. All rights reserved.

This is an official application developed and maintained by @EODBruz.

By using this software you agree to the following terms:

1. GRANT OF LICENSE
   This software is provided free of charge for personal, non-commercial use.
   You are granted a non-exclusive, non-transferable licence to run this script
   on any Windows machine you own or control.

2. RESTRICTIONS
   You may NOT:
   - Redistribute, resell, or sublicence this software or any modified version
     without prior written permission from @EODBruz.
   - Remove or alter any copyright notices or credits contained within the script.
   - Claim authorship or ownership of this software or any portion thereof.
   - Use this software to develop a competing product without explicit consent.

3. MODIFICATIONS
   You may modify this script for personal use only. Any publicly distributed
   fork or derivative must clearly credit @EODBruz and must not be presented
   as an official release.

4. OFFICIAL STATUS
   Only versions distributed via the official repository at
   github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR are considered official.
   @EODBruz accepts no responsibility for modified or unofficial copies.

5. NO WARRANTY
   This software is provided "AS IS" without warranty of any kind. @EODBruz
   shall not be liable for any damages arising from the use or inability to
   use this software.

6. TERMINATION
   This licence is effective until terminated. Your rights under this licence
   will terminate automatically if you fail to comply with any of its terms.

7. GOVERNING LAW
   This agreement shall be governed by applicable international software
   licensing standards. Any disputes shall be resolved in good faith between
   the parties involved.

By continuing to use this software, you confirm that you have read,
understood, and accept all terms of this agreement.
"@
    $inner.Controls.Add($licBox)

    # ── Single OK button centred ─────────────────────────────────────────────
    $okBtnW = 220; $okBtnH = 46
    $okX = [int](($W - 6 - $okBtnW - 4) / 2)
    $okY = $H - 76

    $rgbOkPanel = New-Object System.Windows.Forms.Panel
    $rgbOkPanel.Location  = New-Object System.Drawing.Point($okX, $okY)
    $rgbOkPanel.Size      = New-Object System.Drawing.Size(($okBtnW + 4), ($okBtnH + 4))
    $rgbOkPanel.BackColor = [System.Drawing.Color]::Yellow
    $inner.Controls.Add($rgbOkPanel)
    $aiRgbTimer.Add_Tick({ $rgbOkPanel.BackColor = $dlg.BackColor })

    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Location  = New-Object System.Drawing.Point(2, 2)
    $btnOk.Size      = New-Object System.Drawing.Size($okBtnW, $okBtnH)
    $btnOk.Text      = "OK"
    $btnOk.FlatStyle = "Flat"
    $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
    $btnOk.ForeColor = [System.Drawing.Color]::Yellow
    $btnOk.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnOk.FlatAppearance.BorderSize = 0
    $btnOk.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnOk.Add_Click({ $dlg.Close() })
    $btnOk.Add_MouseEnter({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(40,40,12) })
    $btnOk.Add_MouseLeave({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20,20,20) })
    $rgbOkPanel.Controls.Add($btnOk)

    $dlg.Add_KeyDown({ param($s,$e); if($e.KeyCode -eq "Escape"){ $dlg.Close() } })
    [void]$dlg.ShowDialog()
}

function Show-TroubleshootingDialog {
    $W = 660; $H = 780
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text            = ""
    $dlg.Width           = $W
    $dlg.Height          = $H
    $dlg.StartPosition   = "CenterScreen"
    $dlg.FormBorderStyle = "None"
    $dlg.BackColor       = [System.Drawing.Color]::Yellow
    $dlg.TopMost         = $true

    $script:tsDrag = $false; $script:tsDX = 0; $script:tsDY = 0

    $inner = New-Object System.Windows.Forms.Panel
    $inner.Location  = New-Object System.Drawing.Point(3, 3)
    $inner.Size      = New-Object System.Drawing.Size(($W - 6), ($H - 6))
    $inner.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $dlg.Controls.Add($inner)

    # ── RGB border timer (matches Gamebar pattern with script-scoped hue) ──────
    $script:tsHue = if ($script:rgbHue) { $script:rgbHue } else { 0 }
    $tsRgbTimer = New-Object System.Windows.Forms.Timer
    $tsRgbTimer.Interval = 40
    $tsRgbTimer.Add_Tick({
        $script:tsHue = ($script:tsHue + 2) % 360
        $h = $script:tsHue / 360.0
        $i = [Math]::Floor($h * 6)
        $f = $h * 6 - $i
        $q = 1 - $f; $t = $f
        switch ($i % 6) {
            0 { $r = 255; $g = [int]($t*255); $b = 0 }
            1 { $r = [int]($q*255); $g = 255; $b = 0 }
            2 { $r = 0; $g = 255; $b = [int]($t*255) }
            3 { $r = 0; $g = [int]($q*255); $b = 255 }
            4 { $r = [int]($t*255); $g = 0; $b = 255 }
            5 { $r = 255; $g = 0; $b = [int]($q*255) }
        }
        $dlg.BackColor = [System.Drawing.Color]::FromArgb($r, $g, $b)
    })
    $tsRgbTimer.Start()
    $dlg.Add_FormClosed({ $tsRgbTimer.Stop(); $tsRgbTimer.Dispose() })

    # Title bar
    $titleBar = New-Object System.Windows.Forms.Panel
    $titleBar.Location  = New-Object System.Drawing.Point(0, 0)
    $titleBar.Size      = New-Object System.Drawing.Size(($W - 6), 70)
    $titleBar.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $inner.Controls.Add($titleBar)
    $titleBar.Add_MouseDown({ $script:tsDrag=$true; $script:tsDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:tsDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $titleBar.Add_MouseMove({ if($script:tsDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:tsDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:tsDY } })
    $titleBar.Add_MouseUp({ $script:tsDrag=$false })

    $picTitle = New-Object System.Windows.Forms.PictureBox
    $picTitle.Location  = New-Object System.Drawing.Point(0, 0)
    $picTitle.Size      = New-Object System.Drawing.Size(($W - 6), 70)
    $picTitle.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $picTitle.Add_Paint({
        param($sender, $e); $g=$e.Graphics
        $g.SmoothingMode=[System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
        $sf=New-Object System.Drawing.Font("Impact",22,[System.Drawing.FontStyle]::Italic)
        $sb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(80,0,0,0))
        $tf=New-Object System.Drawing.Font("Impact",22,[System.Drawing.FontStyle]::Italic)
        $tb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Yellow)
        $g.DrawString("TROUBLESHOOTING",$sf,$sb,22,17)
        $g.DrawString("TROUBLESHOOTING",$tf,$tb,20,15)
        $sf.Dispose();$sb.Dispose();$tf.Dispose();$tb.Dispose()
    })
    $picTitle.Add_MouseDown({ $script:tsDrag=$true; $script:tsDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:tsDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $picTitle.Add_MouseMove({ if($script:tsDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:tsDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:tsDY } })
    $picTitle.Add_MouseUp({ $script:tsDrag=$false })
    $titleBar.Controls.Add($picTitle)

    # Divider
    $div = New-Object System.Windows.Forms.Panel
    $div.Location  = New-Object System.Drawing.Point(0, 70)
    $div.Size      = New-Object System.Drawing.Size(($W - 6), 2)
    $div.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $inner.Controls.Add($div)

    # Badge
    $badgePanel = New-Object System.Windows.Forms.Panel
    $badgePanel.Location  = New-Object System.Drawing.Point(20, 82)
    $badgePanel.Size      = New-Object System.Drawing.Size(($W - 46), 36)
    $badgePanel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 0)
    $inner.Controls.Add($badgePanel)

    $badgeLabel = New-Object System.Windows.Forms.Label
    $badgeLabel.Location  = New-Object System.Drawing.Point(0, 0)
    $badgeLabel.Size      = New-Object System.Drawing.Size(($W - 46), 36)
    $badgeLabel.Text      = "  TROUBLESHOOTING GUIDE  |  Common Issues & Solutions"
    $badgeLabel.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $badgeLabel.ForeColor = [System.Drawing.Color]::Yellow
    $badgeLabel.BackColor = [System.Drawing.Color]::Transparent
    $badgeLabel.TextAlign = "MiddleLeft"
    $badgePanel.Controls.Add($badgeLabel)

    # Scrollable content box
    $contentBox = New-Object System.Windows.Forms.RichTextBox
    $contentBox.Location   = New-Object System.Drawing.Point(20, 130)
    $contentBox.Size       = New-Object System.Drawing.Size(($W - 46), ($H - 220))
    $contentBox.BackColor  = [System.Drawing.Color]::FromArgb(18, 18, 18)
    $contentBox.ForeColor  = [System.Drawing.Color]::FromArgb(190, 190, 190)
    $contentBox.Font       = New-Object System.Drawing.Font("Segoe UI", 9)
    $contentBox.ReadOnly   = $true
    $contentBox.BorderStyle = "None"
    $contentBox.ScrollBars = "Vertical"

    # Section helper: heading yellow, body gray
    function Add-TsSection {
        param($rtb, [string]$Heading, [string[]]$Lines)
        $rtb.SelectionFont  = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $rtb.SelectionColor = [System.Drawing.Color]::Yellow
        $rtb.AppendText("$Heading`n")
        foreach ($ln in $Lines) {
            $rtb.SelectionFont  = New-Object System.Drawing.Font("Segoe UI", 9)
            $rtb.SelectionColor = [System.Drawing.Color]::FromArgb(190, 190, 190)
            $rtb.AppendText("$ln`n")
        }
        $rtb.AppendText("`n")
    }

    Add-TsSection $contentBox "PREVIOUSLY OVERCLOCKED ANOTHER CONTROLLER?" @(
        "Have you installed an overclock (HIDUSBF) for another controller on the",
        "same USB port? (e.g. PS5 at 8000Hz, Xbox with HIDUSBF, any non-Marius",
        "controller using HIDUSBF).",
        "",
        "If YES, the Marius board may have trouble connecting to Marius Tools",
        "because HIDUSBF is forcing the USB polling rate for the previous controller.",
        "",
        "HOW TO REMOVE THE OVERCLOCK:",
        "  1. Open HIDUSBF.",
        "  2. Select your non-Marius controller.",
        "  3. Untick Filter On Device.",
        "  4. Right-click Install Service (or Uninstall Service if available).",
        "  5. Click Uninstall Service.",
        "  6. Restart your PC.",
        "",
        "Download HIDUSBF from the FR33THY GitHub if needed."
    )

    Add-TsSection $contentBox "MY MARIUS CONTROLLER KEEPS DISCONNECTING" @(
        "USB-C cables have a limited lifespan. Frequent plugging and unplugging can",
        "weaken the connection over time, especially during firmware updates or testing.",
        "",
        "THINGS TO CHECK:",
        "  - Try a different USB-C cable.",
        "  - Try a different USB port.",
        "  - Avoid USB hubs where possible.",
        "  - Keep a spare USB-C cable available for troubleshooting.",
        "",
        "Even if the cable is new, testing another cable is recommended."
    )

    Add-TsSection $contentBox "MY CONTROLLER IS NOT CONNECTING" @(
        "This issue has largely been resolved through firmware updates.",
        "Older firmware versions, particularly on some AMD systems, could cause",
        "connection issues.",
        "",
        "RECOMMENDED SOLUTION:",
        "  - Update to Firmware 1.22B or newer.",
        "  - Install and use Marius XInput.",
        "",
        "These updates resolve the vast majority of connection-related problems."
    )

    Add-TsSection $contentBox "MY BUTTONS ARE NOT WORKING CORRECTLY" @(
        "Button issues are typically caused by:",
        "  - A bug in the controller manufacturer's firmware.",
        "  - A bug in the Marius firmware.",
        "  - Corrupted controller settings or configuration.",
        "",
        "TROUBLESHOOTING STEPS:",
        "  1. Update to the latest Marius firmware.",
        "  2. Restart the controller and reconnect it.",
        "  3. Test the controller in a gamepad tester.",
        "  4. Report the issue with details about:",
        "       - Controller model",
        "       - Firmware version",
        "       - Which buttons are affected",
        "       - Whether the issue occurs in all or specific games",
        "",
        "Providing this information helps identify and fix bugs much faster."
    )

    $inner.Controls.Add($contentBox)

    # OK button with RGB border
    $okBtnW = 220; $okBtnH = 46
    $okX = [int](($W - 6 - $okBtnW - 4) / 2)
    $okY = $H - 76

    $rgbOkPanel = New-Object System.Windows.Forms.Panel
    $rgbOkPanel.Location  = New-Object System.Drawing.Point($okX, $okY)
    $rgbOkPanel.Size      = New-Object System.Drawing.Size(($okBtnW + 4), ($okBtnH + 4))
    $rgbOkPanel.BackColor = [System.Drawing.Color]::Yellow
    $inner.Controls.Add($rgbOkPanel)
    $tsRgbTimer.Add_Tick({ $rgbOkPanel.BackColor = $dlg.BackColor })

    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Location  = New-Object System.Drawing.Point(2, 2)
    $btnOk.Size      = New-Object System.Drawing.Size($okBtnW, $okBtnH)
    $btnOk.Text      = "OK"
    $btnOk.FlatStyle = "Flat"
    $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
    $btnOk.ForeColor = [System.Drawing.Color]::Yellow
    $btnOk.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnOk.FlatAppearance.BorderSize = 0
    $btnOk.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnOk.Add_Click({ $dlg.Close() })
    $btnOk.Add_MouseEnter({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(40,40,12) })
    $btnOk.Add_MouseLeave({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20,20,20) })
    $rgbOkPanel.Controls.Add($btnOk)

    $dlg.Add_KeyDown({ param($s,$e); if($e.KeyCode -eq "Escape"){ $dlg.Close() } })
    [void]$dlg.ShowDialog()
}

function Show-ToolboxPage {
    # Hide every main-menu tile
    foreach ($c in $script:mainTiles) { $c.Visible = $false }

    # Build toolbox tiles only once; reuse on subsequent visits
    if ($script:toolboxTiles.Count -eq 0) {
        $tbItems = @(
            @{Name="Troubleshooting";                     URL="TROUBLESHOOTING";       Desc="Common issues and solutions for Marius controllers"},
            @{Name="DeepPoll";                            URL="DEEPPOLL";              Desc="Measures USB polling rate with microsecond precision using kernel-level ETW tracing"},
            @{Name="Beta Portal";                         URL="BETA_PORTAL";           Desc="Enroll your board in the beta program and receive early firmware updates"},
            @{Name="HID Telemetry Diagnostic Tool";       URL="CONTROLLER_TELEMETRY";  Desc="Advanced HID Telemetry Diagnostic Tool By @TheQuest818"},
            @{Name="Join Marius Discord";                 URL="DISCORD";               Desc="Join the Marius community on Discord"},
            @{Name="FR33THY Ultimate Optimization Guide"; URL="FR33THY_GUIDE";         Desc="Optimise and Debloat Windows"},
            @{Name="Gamebar Notification Removal";        URL="GAMEBAR_FIX";           Desc="Removes GameBar Notification with 8K Polling Affected Controllers"},
            @{Name="Back";                                URL="BACK";                  Desc="Return to main menu"}
        )
        $tbTW=790; $tbTH=60; $tbSP=4; $tbSX=30; $tbSY=90; $tbIdx=0
        foreach ($tbItem in $tbItems) {
            $tbTile = New-Object System.Windows.Forms.Button
            $tbTile.Location  = New-Object System.Drawing.Point($tbSX, ($tbSY + $tbIdx*($tbTH+$tbSP)))
            $tbTile.Size      = New-Object System.Drawing.Size($tbTW,$tbTH)
            $tbTile.FlatStyle = "Flat"
            $tbTile.BackColor = [System.Drawing.Color]::FromArgb(15,15,15)
            $tbTile.ForeColor = [System.Drawing.Color]::White
            $tbTile.Font      = New-Object System.Drawing.Font("Segoe UI",11)
            $tbTile.Text      = ""
            $tbTile.Cursor    = [System.Windows.Forms.Cursors]::Hand
            $tbTile.FlatAppearance.BorderSize  = 1
            $tbTile.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
            $tbTile.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30,30,30)
            $tbTile.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50,50,50)
            $tbTile.Tag = $tbItem.URL
            $tbTile.Add_MouseEnter({ $this.BackColor=[System.Drawing.Color]::FromArgb(25,25,25); $this.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(255,255,0); $this.FlatAppearance.BorderSize=2 })
            $tbTile.Add_MouseLeave({ $this.BackColor=[System.Drawing.Color]::FromArgb(15,15,15); $this.FlatAppearance.BorderColor=[System.Drawing.Color]::Yellow; $this.FlatAppearance.BorderSize=1 })
            $tbN=$tbItem.Name; $tbD=$tbItem.Desc
            $tbTile.Add_Paint({
                param($s,$e); $g=$e.Graphics
                $g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
                $tf=New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
                $df=New-Object System.Drawing.Font("Segoe UI",8)
                $wb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
                $rb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Red)
                $g.DrawString($tbN,$tf,$wb,20,12); $g.DrawString($tbD,$df,$rb,20,35)
                $wb.Dispose();$rb.Dispose();$tf.Dispose();$df.Dispose()
            }.GetNewClosure())
            $tbTile.Add_Click({
                $tu=$this.Tag
                if ($tu -eq "BACK")                { Show-MainPage; return }
                if ($tu -eq "USB_ANALYZER")        { Show-UsbAnalyzer; return }
                if ($tu -eq "GAMEBAR_FIX")         { Invoke-GameBarNotificationFix; return }
                if ($tu -eq "CONTROLLER_TELEMETRY") { Install-ControllerTelemetry; return }
                if ($tu -eq "TROUBLESHOOTING")     { Show-TroubleshootingDialog; return }
                if ($tu -eq "DEEPPOLL") {
                    $targetUrl = "https://tools.mariusheier.com/deeppoll"
                    $defaultBrowser = Get-DefaultBrowser
                    $browserPath = Get-BrowserPath $defaultBrowser
                    if (-not $browserPath) {
                        foreach ($browser in @("Chrome","Edge","Brave","Opera","Vivaldi","Arc")) {
                            if ($browser -ne $defaultBrowser) {
                                $browserPath = Get-BrowserPath $browser
                                if ($browserPath) { break }
                            }
                        }
                    }
                    if ($browserPath) {
                        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
                        $wW=1200; $wH=800
                        $l=[Math]::Floor(($screen.Width-$wW)/2); $t=[Math]::Floor(($screen.Height-$wH)/2)
                        Start-Process -FilePath $browserPath -ArgumentList "--app=`"$targetUrl`" --window-size=$wW,$wH --window-position=$l,$t"
                    } else { Start-Process $targetUrl }
                    return
                }
                if ($tu -eq "BETA_PORTAL") {
                    $targetUrl = "https://beta.mariusheier.com/"
                    $defaultBrowser = Get-DefaultBrowser
                    $browserPath = Get-BrowserPath $defaultBrowser
                    if (-not $browserPath) {
                        foreach ($browser in @("Chrome","Edge","Brave","Opera","Vivaldi","Arc")) {
                            if ($browser -ne $defaultBrowser) {
                                $browserPath = Get-BrowserPath $browser
                                if ($browserPath) { break }
                            }
                        }
                    }
                    if ($browserPath) {
                        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
                        $wW=1200; $wH=800
                        $l=[Math]::Floor(($screen.Width-$wW)/2); $t=[Math]::Floor(($screen.Height-$wH)/2)
                        Start-Process -FilePath $browserPath -ArgumentList "--app=`"$targetUrl`" --window-size=$wW,$wH --window-position=$l,$t"
                    } else { Start-Process $targetUrl }
                    return
                }
                if ($tu -eq "APP_INFO")      { Show-AppInfoDialog; return }
                if ($tu -eq "DISCORD") {
                    Start-Process "https://discord.com/invite/9MZXjbrB6P"
                    return
                }
                if ($tu -eq "FR33THY_GUIDE") {
                    $targetUrl = "https://github.com/FR33THYFR33THY/Ultimate"
                    $defaultBrowser = Get-DefaultBrowser
                    $browserPath = Get-BrowserPath $defaultBrowser
                    if (-not $browserPath) {
                        foreach ($browser in @("Chrome","Edge","Brave","Opera","Vivaldi","Arc")) {
                            if ($browser -ne $defaultBrowser) {
                                $browserPath = Get-BrowserPath $browser
                                if ($browserPath) { break }
                            }
                        }
                    }
                    if ($browserPath) {
                        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
                        $wW=1200; $wH=800
                        $l=[Math]::Floor(($screen.Width-$wW)/2); $t=[Math]::Floor(($screen.Height-$wH)/2)
                        Start-Process -FilePath $browserPath -ArgumentList "--app=`"$targetUrl`" --window-size=$wW,$wH --window-position=$l,$t"
                    } else { Start-Process $targetUrl }
                    return
                }
            }.GetNewClosure())
            $script:mainPanel.Controls.Add($tbTile)
            $script:toolboxTiles.Add($tbTile)
            $tbIdx++
        }
    }

    # Show toolbox tiles
    foreach ($c in $script:toolboxTiles) { $c.Visible = $true }
    $script:mainPanel.Refresh()
}

function Show-MainPage {
    foreach ($c in $script:toolboxTiles) { $c.Visible = $false }
    foreach ($c in $script:mainTiles)    { $c.Visible = $true  }
    $script:mainPanel.Refresh()
}

# ============================================================================
# MAIN MENU TILES
# (Setup Controller, Joystick Tester, Polling Rate Checker, Firmware Updater,
#  Setup Guide By Parasite, Beta Portal, Creator Twitter, Update Script,
#  Marius Toolbox, Exit)
# ============================================================================
$websites = @(
    @{Name="Setup Controller";         URL="https://devsetup.mariusheier.com/";                          Desc="Calibrate and configure your controller settings and polling rate settings"},
    @{Name="Joystick Tester";          URL="https://hardwaretester.com/gamepad";                         Desc="Test your joystick inputs, buttons, and analog stick precision"},
    @{Name="Polling Rate Checker";     URL="https://tools.mariusheier.com/poll_checker.html";            Desc="Test and verify your controller's polling rate"},
    @{Name="Firmware Updater";         URL="https://update.mariusheier.com/";                            Desc="Update Your Controller to Latest Versions Or Beta Versions"},
    @{Name="USB Latency Analyzer";     URL="USB_ANALYZER";                                                Desc="Count chips between your device and CPU. More chips = more latency"},
    @{Name="Setup Guide By Parasite";  URL="https://x.com/Parasite/status/2033329474922549297";          Desc="Explains How to setup sticks/controller"},
    @{Name="Creator Twitter";          URL="https://x.com/mariusheier";                                  Desc="Follow for updates, tips, and support"},
    @{Name="Marius Toolbox";           URL="TOOLBOX";                                                    Desc="HID Telemetry Diagnostic, Gamebar Notification Removal, FR33THY Ultimate Guide"},
    @{Name="Update Script";            URL="UPDATE";                                                     Desc="Download and install the latest version automatically"},
    @{Name="App Information";          URL="APP_INFO";                                                   Desc="View information about this application"},
    @{Name="Exit";                     URL="EXIT";                                                       Desc="Close this application"}
)

$tileWidth = 790
$tileHeight = 60
$spacing = 4
$startX = 30
$startY = 90

$index = 0
foreach ($site in $websites) {
    $xPos = $startX
    $effectiveStartY = if ($script:dynamicStartY) { $script:dynamicStartY } else { $startY }
    $yPos = $effectiveStartY + ($index * ($tileHeight + $spacing))
    
    $tile = New-Object System.Windows.Forms.Button
    $tile.Location = New-Object System.Drawing.Point($xPos, $yPos)
    $tile.Size = New-Object System.Drawing.Size($tileWidth, $tileHeight)
    $tile.FlatStyle = "Flat"
    $tile.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $tile.ForeColor = [System.Drawing.Color]::White
    $tile.Font = New-Object System.Drawing.Font("Segoe UI", 11)
    $tile.Text = ""
    $tile.TextAlign = "MiddleCenter"
    $tile.Cursor = [System.Windows.Forms.Cursors]::Hand
    $tile.FlatAppearance.BorderSize = 1
    $tile.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $tile.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $tile.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $tile.Tag = $site.URL
    
    # Add hover glow effect
    $tile.Add_MouseEnter({
        $this.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 255, 0)
        $this.FlatAppearance.BorderSize = 2
    })
    
    $tile.Add_MouseLeave({
        $this.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
        $this.FlatAppearance.BorderSize = 1
    })
    
    $siteName = $site.Name
    $siteDesc = $site.Desc
    
    $tile.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
        
        $titleFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $descFont = New-Object System.Drawing.Font("Segoe UI", 8)
        $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $redBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Red)
        
        $g.DrawString($siteName, $titleFont, $whiteBrush, 20, 12)
        $g.DrawString($siteDesc, $descFont, $redBrush, 20, 35)
        
        $whiteBrush.Dispose()
        $redBrush.Dispose()
        $titleFont.Dispose()
        $descFont.Dispose()
    }.GetNewClosure())
    
    $tile.Add_Click({
        $targetUrl = $this.Tag
        
        if ($targetUrl -eq "EXIT") {
            $form.Close()
            return
        }
        
        if ($targetUrl -eq "TOOLBOX") {
            Show-ToolboxPage
            return
        }
        
        if ($targetUrl -eq "USB_ANALYZER") {
            Show-UsbAnalyzer
            return
        }
        
        if ($targetUrl -eq "GAMEBAR_FIX") {
            Invoke-GameBarNotificationFix
            return
        }
        
        if ($targetUrl -eq "APP_INFO") {
            Show-AppInfoDialog
            return
        }
        
        if ($targetUrl -eq "UPDATE") {
            # Capture variables locally before running
            $releasesApi = $script:ReleasesApi
            $installPath = $script:InstallPath
            $logFile     = "$script:InstallDir\update.log"
            try {
                $wc = New-Object System.Net.WebClient
                $wc.Headers.Add("User-Agent", "MARIUS-Updater")

                $json        = $wc.DownloadString($releasesApi)
                $tagLine     = (($json -split '"tag_name"\s*:\s*"')[1] -split '"')[0].TrimStart('vV')
                $assetBlock  = ($json -split '"browser_download_url"\s*:\s*"')[1]
                $downloadUrl = ($assetBlock -split '"')[0]

                if (-not $downloadUrl -or $downloadUrl -notlike "*.ps1") {
                    Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - No .ps1 asset in release v$tagLine - falling back to main branch" -ErrorAction SilentlyContinue
                    $downloadUrl = $script:ScriptUrl

                    try {
                        $mainScript = $wc.DownloadString($script:ScriptUrl)
                        $mainVerLine = ($mainScript -split "`n" | Where-Object { $_ -match '^\$script:CurrentVersion\s*=' } | Select-Object -First 1)
                        $tagLine = ($mainVerLine -replace '.*=\s*"([^"]+)".*', '$1').Trim()
                        Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - Main branch reports version: $tagLine" -ErrorAction SilentlyContinue
                    } catch {
                        Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - Could not read version from main branch - skipping" -ErrorAction SilentlyContinue
                        return
                    }
                }

                Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - Forcing install of v$tagLine from $downloadUrl" -ErrorAction SilentlyContinue

                $tempFile = "$env:TEMP\MARIUS_update_$tagLine.ps1"
                $wc.DownloadFile($downloadUrl, $tempFile)

                if (-not (Test-Path $tempFile)) {
                    Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - FAILED temp file missing" -ErrorAction SilentlyContinue
                    return
                }
                $dlSize = (Get-Item $tempFile).Length
                if ($dlSize -lt 10000) {
                    Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - FAILED file too small ($dlSize bytes)" -ErrorAction SilentlyContinue
                    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
                    return
                }

                Remove-Item -Path $installPath -Force -ErrorAction SilentlyContinue
                Copy-Item   -Path $tempFile -Destination $installPath -Force
                Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue

                if (-not (Test-Path $installPath)) {
                    Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - FAILED new file not at install path" -ErrorAction SilentlyContinue
                    return
                }
                $instSize = (Get-Item $installPath).Length
                Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - SUCCESS v$tagLine installed ($instSize bytes) - relaunching" -ErrorAction SilentlyContinue

                $args = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$installPath`""
                [System.Diagnostics.Process]::Start("cmd.exe", "/c start powershell.exe $args") | Out-Null
                Start-Sleep -Milliseconds 3000
                [System.Diagnostics.Process]::GetCurrentProcess().Kill()
            } catch {
                Add-Content -Path $logFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] UPDATE - ERROR $($_.Exception.Message)" -ErrorAction SilentlyContinue
            }
            return
        }
        
        $defaultBrowser = Get-DefaultBrowser
        $browserPath = Get-BrowserPath $defaultBrowser
        
        if (-not $browserPath) {
            # Try all Chromium browsers in order of preference
            $browsersToTry = @("Chrome", "Edge", "Brave", "Opera", "Vivaldi", "Arc")
            foreach ($browser in $browsersToTry) {
                if ($browser -ne $defaultBrowser) {
                    $browserPath = Get-BrowserPath $browser
                    if ($browserPath) { break }
                }
            }
        }
        
        if ($browserPath) {
            $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
            $windowWidth = 1200
            $windowHeight = 800
            $left = [Math]::Floor(($screen.Width - $windowWidth) / 2)
            $top = [Math]::Floor(($screen.Height - $windowHeight) / 2)
            
            $arguments = "--app=`"$targetUrl`" --window-size=$windowWidth,$windowHeight --window-position=$left,$top"
            
            Start-Process -FilePath $browserPath -ArgumentList $arguments
        } else {
            Start-Process $targetUrl
        }
    })
    
    $mainPanel.Controls.Add($tile)
    $script:mainTiles.Add($tile)
    $index++
}

# ============================================================================
# RGB BORDER ANIMATION TIMER
# ============================================================================

$script:rgbHue = 0
$script:rgbTimer = New-Object System.Windows.Forms.Timer
$script:rgbTimer.Interval = 40

$script:rgbTimer.Add_Tick({
    $script:rgbHue = ($script:rgbHue + 2) % 360
    $h = $script:rgbHue / 360.0
    $i = [Math]::Floor($h * 6)
    $f = $h * 6 - $i
    $q = 1 - $f
    $t = $f
    switch ($i % 6) {
        0 { $r = 255; $g = [int]($t * 255); $b = 0 }
        1 { $r = [int]($q * 255); $g = 255; $b = 0 }
        2 { $r = 0; $g = 255; $b = [int]($t * 255) }
        3 { $r = 0; $g = [int]($q * 255); $b = 255 }
        4 { $r = [int]($t * 255); $g = 0; $b = 255 }
        5 { $r = 255; $g = 0; $b = [int]($q * 255) }
    }
    $rgbColor = [System.Drawing.Color]::FromArgb($r, $g, $b)
    $script:form.BackColor = $rgbColor
    foreach ($ctrl in $script:mainPanel.Controls) {
        if ($ctrl -is [System.Windows.Forms.Button]) {
            $ctrl.FlatAppearance.BorderColor = $rgbColor
        }
    }
})

$script:rgbTimer.Start()

# ── SETTINGS FILE WATCHER — hot-reload when Settings.ini is edited externally ─
$script:settingsWatcher = $null
try {
    $script:settingsWatcher = New-Object System.IO.FileSystemWatcher
    $script:settingsWatcher.Path   = $script:InstallDir
    $script:settingsWatcher.Filter = "Settings.ini"
    $script:settingsWatcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite
    $script:settingsWatcher.EnableRaisingEvents = $true

    # Use a short debounce timer so rapid saves don't retrigger multiple times
    $script:watchDebounce = New-Object System.Windows.Forms.Timer
    $script:watchDebounce.Interval = 600

    $script:watchDebounce.Add_Tick({
        $script:watchDebounce.Stop()
        # Read new settings
        Read-Settings
        # Apply volume change immediately if music is playing
        if ($script:MusicEnabled) {
            [MciAudio]::SetVolume($script:MusicVolume)
        } else {
            Stop-Music
        }
        # Refresh volume UI on the UI thread
        if ($muteBtn -and $muteBtn.IsHandleCreated) {
            $muteBtn.Invoke([Action]{
                $muteBtn.Invalidate()
                $volPctLabel.Text = "$($script:MusicVolume)%"
                $script:volSliderPanel.Invalidate()
            })
        }
    })

    Register-ObjectEvent -InputObject $script:settingsWatcher -EventName Changed -Action {
        $script:watchDebounce.Stop()
        $script:watchDebounce.Start()
    } | Out-Null
} catch {}

$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Location = New-Object System.Drawing.Point(5, 800)
$versionLabel.Size = New-Object System.Drawing.Size(70, 28)
$versionLabel.Text = "v$script:CurrentVersion"
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$versionLabel.ForeColor = [System.Drawing.Color]::Red
$versionLabel.TextAlign = "MiddleLeft"
$versionLabel.BackColor = [System.Drawing.Color]::Black
$mainPanel.Controls.Add($versionLabel)

# Credits — full panel width, MiddleCenter, sent to back so controls above it get clicks
$creditsLabel = New-Object System.Windows.Forms.Label
$creditsLabel.Location = New-Object System.Drawing.Point(14, 800)
$creditsLabel.Size = New-Object System.Drawing.Size(766, 28)
$creditsLabel.Text = "Created by: @mariusheier  |  Script by: @EODBruz"
$creditsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$creditsLabel.ForeColor = [System.Drawing.Color]::Red
$creditsLabel.TextAlign = "MiddleCenter"
$creditsLabel.BackColor = [System.Drawing.Color]::Black
$mainPanel.Controls.Add($creditsLabel)
$creditsLabel.SendToBack()
$versionLabel.BringToFront()

# ── VOLUME CONTROL STRIP ─────────────────────────────────────────────────────
# Right-aligned: [speaker 24px][4][slider 100px][4][pct 34px] = 166px, X=678..844
$script:volSliderDragging = $false

# ── Speaker toggle — GDI+ painted, no Unicode dependency ────────────────────
$muteBtn = New-Object System.Windows.Forms.Button
$muteBtn.Location  = New-Object System.Drawing.Point(678, 800)
$muteBtn.Size      = New-Object System.Drawing.Size(24, 24)
$muteBtn.FlatStyle = "Flat"
$muteBtn.BackColor = [System.Drawing.Color]::Black
$muteBtn.Text      = ""
$muteBtn.Cursor    = [System.Windows.Forms.Cursors]::Hand
$muteBtn.FlatAppearance.BorderSize         = 0
$muteBtn.FlatAppearance.BorderColor        = [System.Drawing.Color]::Black
$muteBtn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
$muteBtn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::Black
$muteBtn.TabStop = $false

$muteBtn.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $on  = $script:MusicEnabled
    $col = if ($on) { [System.Drawing.Color]::Yellow } else { [System.Drawing.Color]::FromArgb(80,80,80) }
    $b   = New-Object System.Drawing.SolidBrush($col)
    $p   = New-Object System.Drawing.Pen($col, 1.5)

    # Speaker body: filled trapezoid
    $pts = @(
        [System.Drawing.Point]::new(3,8),
        [System.Drawing.Point]::new(7,8),
        [System.Drawing.Point]::new(11,4),
        [System.Drawing.Point]::new(11,18),
        [System.Drawing.Point]::new(7,14),
        [System.Drawing.Point]::new(3,14)
    )
    $g.FillPolygon($b, $pts)

    if ($on) {
        # Two sound arcs
        $g.DrawArc($p, 12, 7,  5,  8, -50, 100)
        $g.DrawArc($p, 13, 4,  8, 14, -50, 100)
    } else {
        # Red X
        $px = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(210,50,50), 2.0)
        $g.DrawLine($px, 13, 7, 20, 14)
        $g.DrawLine($px, 20, 7, 13, 14)
        $px.Dispose()
    }
    $b.Dispose(); $p.Dispose()
})

$muteBtn.Add_Click({
    Toggle-Music
    $muteBtn.Invalidate()
    $script:volSliderPanel.Invalidate()
})
$mainPanel.Controls.Add($muteBtn)
$muteBtn.BringToFront()

# ── Slim volume slider panel ─────────────────────────────────────────────────
$script:volSliderPanel = New-Object System.Windows.Forms.Panel
$script:volSliderPanel.Location  = New-Object System.Drawing.Point(706, 805)
$script:volSliderPanel.Size      = New-Object System.Drawing.Size(100, 16)
$script:volSliderPanel.BackColor = [System.Drawing.Color]::Black
$script:volSliderPanel.Cursor    = [System.Windows.Forms.Cursors]::Hand

function Get-ThumbX {
    $trackW = $script:volSliderPanel.Width - 10
    return 5 + [int]($script:MusicVolume / 100.0 * $trackW)
}

$script:volSliderPanel.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $on      = $script:MusicEnabled
    $cy      = 7
    $trackW  = $sender.Width - 10
    $thumbX  = Get-ThumbX
    $thumbR  = 5

    # Track bg
    $bgB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(55,55,55))
    $g.FillRectangle($bgB, 5, ($cy-1), $trackW, 3)
    $bgB.Dispose()

    # Fill + thumb color
    $fc = if ($on) { [System.Drawing.Color]::Yellow } else { [System.Drawing.Color]::FromArgb(75,75,75) }
    $fb = New-Object System.Drawing.SolidBrush($fc)
    $fw = [Math]::Max(0, $thumbX - 5)
    if ($fw -gt 0) { $g.FillRectangle($fb, 5, ($cy-1), $fw, 3) }
    $g.FillEllipse($fb, ($thumbX - $thumbR), ($cy - $thumbR + 1), $thumbR*2, $thumbR*2)
    $fb.Dispose()
})

$script:volSliderPanel.Add_MouseDown({
    param($s, $e)
    $script:volSliderDragging = $true
    $raw = [int](([Math]::Max(5,[Math]::Min($s.Width-5,$e.X))-5)/($s.Width-10)*100)
    $script:MusicVolume = [Math]::Max(0,[Math]::Min(100,$raw))
    [MciAudio]::SetVolume($script:MusicVolume)
    $volPctLabel.Text = "$($script:MusicVolume)%"
    $s.Invalidate()
})
$script:volSliderPanel.Add_MouseMove({
    param($s, $e)
    if (-not $script:volSliderDragging) { return }
    $raw = [int](([Math]::Max(5,[Math]::Min($s.Width-5,$e.X))-5)/($s.Width-10)*100)
    $script:MusicVolume = [Math]::Max(0,[Math]::Min(100,$raw))
    [MciAudio]::SetVolume($script:MusicVolume)
    $volPctLabel.Text = "$($script:MusicVolume)%"
    $s.Invalidate()
})
$script:volSliderPanel.Add_MouseUp({
    param($s, $e)
    if (-not $script:volSliderDragging) { return }
    $script:volSliderDragging = $false
    Save-Settings
    $s.Invalidate()
})

$mainPanel.Controls.Add($script:volSliderPanel)
$script:volSliderPanel.BringToFront()

# ── Volume % label ────────────────────────────────────────────────────────────
$volPctLabel = New-Object System.Windows.Forms.Label
$volPctLabel.Location  = New-Object System.Drawing.Point(810, 800)
$volPctLabel.Size      = New-Object System.Drawing.Size(34, 24)
$volPctLabel.Text      = "$($script:MusicVolume)%"
$volPctLabel.Font      = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$volPctLabel.ForeColor = [System.Drawing.Color]::FromArgb(160,160,160)
$volPctLabel.BackColor = [System.Drawing.Color]::Black
$volPctLabel.TextAlign = "MiddleLeft"
$mainPanel.Controls.Add($volPctLabel)
$volPctLabel.BringToFront()

$form.Controls.Add($mainPanel)

$form.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq "Escape") {
        $form.Close()
    }
})

$form.Add_Shown({
    $form.Activate()
    # Sync volume controls to actual loaded settings
    $muteBtn.Invalidate()
    $volPctLabel.Text = "$($script:MusicVolume)%"
    $script:volSliderPanel.Invalidate()
    # Retry music in case mp3 downloaded after initial Start-Music
    if ($script:MusicEnabled) { Start-Music }
})
$form.Add_FormClosing({
    $script:rgbTimer.Stop()
    $script:rgbTimer.Dispose()
    if ($script:settingsWatcher) {
        $script:settingsWatcher.EnableRaisingEvents = $false
        $script:settingsWatcher.Dispose()
    }
    if ($script:watchDebounce) { $script:watchDebounce.Stop(); $script:watchDebounce.Dispose() }
    Stop-Music
})
$form.Add_FormClosed({
    [System.Diagnostics.Process]::GetCurrentProcess().Kill()
})
[void]$form.ShowDialog()
