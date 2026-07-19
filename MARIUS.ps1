#requires -Version 5.1
<#
.SYNOPSIS
    MARIUS Board Configurator V3.7.6

.DESCRIPTION
    All-in-one launcher for MARIUS tools including USB Latency Analyzer and HID Telemetry.
    No additional files needed - everything is contained in this single script.
    Features desktop shortcut installer and embedded MBC icon.

.NOTES
    Created by: @mariusheier (Original Creator)
    Script by: @EODBruz (PowerShell Development)
    Version: 3.7.6

.CREDITS
    App Creator: @mariusheier
    Script Developer: @EODBruz
    Optimization Scripts: FR33THY
    HID Telemetry Tool: @TheQuest818
    Script Version 3.7.6

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
$script:CurrentVersion = "3.7.6"
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
            
            if ($dev -and $dev.FriendlyName -match "Hub" -and $dev.FriendlyName -notmatch "Root") {
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

function Show-DeepPoll {
    $script:dpExe = "$script:InstallDir\DeepPoll.exe"
    $dpUrl        = "https://github.com/MariusHeier/deeppoll/releases/latest/download/DeepPoll.exe"
    $dpApiUrl     = "https://api.github.com/repos/MariusHeier/deeppoll/releases/latest"

    # ── Check if an update is available ───────────────────────────────────
    $needDownload = $false
    if (-not (Test-Path $script:dpExe)) {
        $needDownload = $true
    } else {
        $cached = Get-IniToolVer "DeepPoll"
        $actualSize = (Get-Item $script:dpExe).Length

        if ($cached.Size -ge 0 -and $actualSize -ne $cached.Size) {
            # Exe size doesn't match what we recorded — force re-download
            $needDownload = $true
        } else {
            # Size matches (or no record yet) — check GitHub for a newer tag
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $wcVer = New-Object System.Net.WebClient
                $wcVer.Headers.Add("User-Agent", "MARIUS-Updater")
                $json      = $wcVer.DownloadString($dpApiUrl)
                $latestTag = (($json -split '"tag_name"\s*:\s*"')[1] -split '"')[0]
                if ($latestTag.Trim() -ne $cached.Tag.Trim()) {
                    $needDownload = $true
                }
            } catch {
                # If version check fails, keep existing exe
            }
        }
    }

    # ── Download / update if needed ────────────────────────────────────────
    if ($needDownload) {

        $script:dlProgress = -1   # -1 = indeterminate, 0-100 = determinate

        # ── Outer form: frameless, yellow 2px border via BackColor ─────────
        $dlForm = New-Object System.Windows.Forms.Form
        $dlForm.Text            = ""
        $dlForm.Size            = New-Object System.Drawing.Size(360, 140)
        $dlForm.StartPosition   = "CenterScreen"
        $dlForm.FormBorderStyle = "None"
        $dlForm.BackColor       = [System.Drawing.Color]::FromArgb(255, 220, 0)
        $dlForm.TopMost         = $false

        # ── Inner dark panel ───────────────────────────────────────────────
        $dlInner = New-Object System.Windows.Forms.Panel
        $dlInner.Location  = New-Object System.Drawing.Point(2, 2)
        $dlInner.Size      = New-Object System.Drawing.Size(356, 136)
        $dlInner.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

        # ── Title ──────────────────────────────────────────────────────────
        $dlTitle = New-Object System.Windows.Forms.Label
        $dlTitle.Text      = "DEEPPOLL"
        $dlTitle.ForeColor = [System.Drawing.Color]::FromArgb(255, 220, 0)
        $dlTitle.Font      = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $dlTitle.AutoSize  = $false
        $dlTitle.Size      = New-Object System.Drawing.Size(316, 28)
        $dlTitle.Location  = New-Object System.Drawing.Point(20, 16)
        $dlTitle.TextAlign = "MiddleLeft"

        # ── Subtitle / status line ─────────────────────────────────────────
        $dlSub = New-Object System.Windows.Forms.Label
        $dlSub.Text      = if (Test-Path $script:dpExe) { "Updating DeepPoll.exe..." } else { "Downloading DeepPoll.exe..." }
        $dlSub.ForeColor = [System.Drawing.Color]::FromArgb(160, 160, 160)
        $dlSub.Font      = New-Object System.Drawing.Font("Segoe UI", 7)
        $dlSub.AutoSize  = $false
        $dlSub.Size      = New-Object System.Drawing.Size(316, 16)
        $dlSub.Location  = New-Object System.Drawing.Point(20, 50)
        $dlSub.TextAlign = "MiddleLeft"

        # ── Custom-painted progress track ──────────────────────────────────
        $dlTrack = New-Object System.Windows.Forms.Panel
        $dlTrack.Location  = New-Object System.Drawing.Point(20, 76)
        $dlTrack.Size      = New-Object System.Drawing.Size(268, 6)
        $dlTrack.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

        $dlTrack.Add_Paint({
            param($s, $ev)
            $g   = $ev.Graphics
            $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
            $w   = $s.Width
            $h   = $s.Height
            $pct = $script:dlProgress

            # Track background
            $bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(38, 38, 38))
            $g.FillRectangle($bg, 0, 0, $w, $h)
            $bg.Dispose()

            if ($pct -lt 0) {
                # Indeterminate: animated yellow pulse
                $blockW = [int]($w * 0.35)
                $tick   = [int]([System.Environment]::TickCount / 8) % ($w + $blockW)
                $x0     = $tick - $blockW
                $rect   = New-Object System.Drawing.Rectangle($x0, 0, $blockW, $h)
                try {
                    $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
                        $rect,
                        [System.Drawing.Color]::FromArgb(60, 200, 160, 0),
                        [System.Drawing.Color]::FromArgb(255, 220, 0),
                        [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
                    )
                    $g.FillRectangle($grad, $rect)
                    $grad.Dispose()
                } catch {
                    $fb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 0))
                    $g.FillRectangle($fb, $rect)
                    $fb.Dispose()
                }
            } else {
                # Determinate fill
                $fillW = [int]($w * $pct / 100.0)
                if ($fillW -gt 0) {
                    $fillRect = New-Object System.Drawing.Rectangle(0, 0, $fillW, $h)
                    try {
                        $fillGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
                            $fillRect,
                            [System.Drawing.Color]::FromArgb(255, 235, 30),
                            [System.Drawing.Color]::FromArgb(200, 170, 0),
                            [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
                        )
                        $g.FillRectangle($fillGrad, $fillRect)
                        $fillGrad.Dispose()
                    } catch {
                        $fb2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 0))
                        $g.FillRectangle($fb2, $fillRect)
                        $fb2.Dispose()
                    }
                }
            }
        })

        # ── Percent label (right of bar) ───────────────────────────────────
        $dlPct = New-Object System.Windows.Forms.Label
        $dlPct.Text      = ""
        $dlPct.ForeColor = [System.Drawing.Color]::FromArgb(255, 220, 0)
        $dlPct.Font      = New-Object System.Drawing.Font("Segoe UI", 7, [System.Drawing.FontStyle]::Bold)
        $dlPct.AutoSize  = $false
        $dlPct.Size      = New-Object System.Drawing.Size(48, 14)
        $dlPct.Location  = New-Object System.Drawing.Point(296, 71)
        $dlPct.TextAlign = "MiddleRight"

        # ── KB transferred label ───────────────────────────────────────────
        $dlStatus = New-Object System.Windows.Forms.Label
        $dlStatus.Text      = "Connecting..."
        $dlStatus.ForeColor = [System.Drawing.Color]::FromArgb(75, 75, 75)
        $dlStatus.Font      = New-Object System.Drawing.Font("Segoe UI", 7)
        $dlStatus.AutoSize  = $false
        $dlStatus.Size      = New-Object System.Drawing.Size(316, 14)
        $dlStatus.Location  = New-Object System.Drawing.Point(20, 96)
        $dlStatus.TextAlign = "MiddleLeft"

        # ── Marquee timer (~60 fps repaint) ───────────────────────────────
        $dlTimer = New-Object System.Windows.Forms.Timer
        $dlTimer.Interval = 16
        $dlTimer.Add_Tick({ $dlTrack.Invalidate() })

        $dlInner.Controls.AddRange(@($dlTitle, $dlSub, $dlTrack, $dlPct, $dlStatus))
        $dlForm.Controls.Add($dlInner)
        $dlForm.Show()
        $dlForm.Refresh()

        $script:dlProgress = -1
        $dlTimer.Start()

        # ── Download ───────────────────────────────────────────────────────
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $wc = New-Object System.Net.WebClient
            $wc.Headers.Add("Cache-Control", "no-cache")

            $wc.add_DownloadProgressChanged({
                param($s, $e)
                if ($e.TotalBytesToReceive -gt 0) {
                    $script:dlProgress = $e.ProgressPercentage
                    $dlTimer.Stop()
                    $recv  = [Math]::Round($e.BytesReceived       / 1KB)
                    $total = [Math]::Round($e.TotalBytesToReceive / 1KB)
                    $dlStatus.Text = "$recv KB  /  $total KB"
                    $dlPct.Text    = "$($e.ProgressPercentage)%"
                } else {
                    $recv          = [Math]::Round($e.BytesReceived / 1KB)
                    $dlStatus.Text = "$recv KB downloaded"
                }
                $dlTrack.Invalidate()
                $dlForm.Refresh()
            })

            $wc.DownloadFile($dpUrl, $script:dpExe)

            # Save version tag + file size into Settings.ini
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $wcTag = New-Object System.Net.WebClient
                $wcTag.Headers.Add("User-Agent", "MARIUS-Updater")
                $jsonTag  = $wcTag.DownloadString($dpApiUrl)
                $savedTag = (($jsonTag -split '"tag_name"\s*:\s*"')[1] -split '"')[0]
                $exeSize  = (Get-Item $script:dpExe).Length
                Save-IniToolVer "DeepPoll" $savedTag $exeSize
            } catch {}

            # ── Complete flash ─────────────────────────────────────────────
            $dlTimer.Stop()
            $script:dlProgress = 100
            $dlStatus.Text     = "Complete."
            $dlPct.Text        = "100%"
            $dlSub.Text        = "DeepPoll.exe ready."
            $dlSub.ForeColor   = [System.Drawing.Color]::FromArgb(255, 220, 0)
            $dlTrack.Invalidate()
            $dlForm.Refresh()
            Start-Sleep -Milliseconds 500

        } catch {
            $dlTimer.Stop()
            $dlForm.Close()
            [System.Windows.Forms.MessageBox]::Show(
                "Could not download DeepPoll.`n`nCheck your connection or grab it manually:`nhttps://github.com/MariusHeier/deeppoll/releases`n`n$_",
                "Download Failed",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            return
        }
        $dlForm.Close()
    }

    # ── Launch directly, elevated ──────────────────────────────────────────
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName        = "cmd.exe"
    $psi.Arguments       = "/k `"$script:dpExe`""
    $psi.WindowStyle     = [System.Diagnostics.ProcessWindowStyle]::Normal
    $psi.UseShellExecute = $true
    $psi.Verb            = "runas"
    [System.Diagnostics.Process]::Start($psi) | Out-Null
}


function Show-DeepLog {
    $script:dlgExe = "$script:InstallDir\DeepLog.exe"
    $dlgUrl        = "https://github.com/MariusHeier/deeplog/releases/latest/download/DeepLog.exe"
    $dlgApiUrl     = "https://api.github.com/repos/MariusHeier/deeplog/releases/latest"

    # ── Check if an update is available ───────────────────────────────────
    $needDownload = $false
    if (-not (Test-Path $script:dlgExe)) {
        $needDownload = $true
    } else {
        $cached = Get-IniToolVer "DeepLog"
        $actualSize = (Get-Item $script:dlgExe).Length

        if ($cached.Size -ge 0 -and $actualSize -ne $cached.Size) {
            # Exe size doesn't match what we recorded — force re-download
            $needDownload = $true
        } else {
            # Size matches (or no record yet) — check GitHub for a newer tag
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $wcVer = New-Object System.Net.WebClient
                $wcVer.Headers.Add("User-Agent", "MARIUS-Updater")
                $json      = $wcVer.DownloadString($dlgApiUrl)
                $latestTag = (($json -split '"tag_name"\s*:\s*"')[1] -split '"')[0]
                if ($latestTag.Trim() -ne $cached.Tag.Trim()) {
                    $needDownload = $true
                }
            } catch {
                # If version check fails, keep existing exe
            }
        }
    }

    # ── Download / update if needed ────────────────────────────────────────
    if ($needDownload) {

        $script:dlProgress = -1   # -1 = indeterminate, 0-100 = determinate

        # ── Outer form: frameless, yellow 2px border via BackColor ─────────
        $dlForm = New-Object System.Windows.Forms.Form
        $dlForm.Text            = ""
        $dlForm.Size            = New-Object System.Drawing.Size(360, 140)
        $dlForm.StartPosition   = "CenterScreen"
        $dlForm.FormBorderStyle = "None"
        $dlForm.BackColor       = [System.Drawing.Color]::FromArgb(255, 220, 0)
        $dlForm.TopMost         = $false

        # ── Inner dark panel ───────────────────────────────────────────────
        $dlInner = New-Object System.Windows.Forms.Panel
        $dlInner.Location  = New-Object System.Drawing.Point(2, 2)
        $dlInner.Size      = New-Object System.Drawing.Size(356, 136)
        $dlInner.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

        # ── Title ──────────────────────────────────────────────────────────
        $dlTitle = New-Object System.Windows.Forms.Label
        $dlTitle.Text      = "DEEPLOG"
        $dlTitle.ForeColor = [System.Drawing.Color]::FromArgb(255, 220, 0)
        $dlTitle.Font      = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $dlTitle.AutoSize  = $false
        $dlTitle.Size      = New-Object System.Drawing.Size(316, 28)
        $dlTitle.Location  = New-Object System.Drawing.Point(20, 16)
        $dlTitle.TextAlign = "MiddleLeft"

        # ── Subtitle / status line ─────────────────────────────────────────
        $dlSub = New-Object System.Windows.Forms.Label
        $dlSub.Text      = if (Test-Path $script:dlgExe) { "Updating DeepLog.exe..." } else { "Downloading DeepLog.exe..." }
        $dlSub.ForeColor = [System.Drawing.Color]::FromArgb(160, 160, 160)
        $dlSub.Font      = New-Object System.Drawing.Font("Segoe UI", 7)
        $dlSub.AutoSize  = $false
        $dlSub.Size      = New-Object System.Drawing.Size(316, 16)
        $dlSub.Location  = New-Object System.Drawing.Point(20, 50)
        $dlSub.TextAlign = "MiddleLeft"

        # ── Custom-painted progress track ──────────────────────────────────
        $dlTrack = New-Object System.Windows.Forms.Panel
        $dlTrack.Location  = New-Object System.Drawing.Point(20, 76)
        $dlTrack.Size      = New-Object System.Drawing.Size(268, 6)
        $dlTrack.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

        $dlTrack.Add_Paint({
            param($s, $ev)
            $g   = $ev.Graphics
            $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
            $w   = $s.Width
            $h   = $s.Height
            $pct = $script:dlProgress

            # Track background
            $bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(38, 38, 38))
            $g.FillRectangle($bg, 0, 0, $w, $h)
            $bg.Dispose()

            if ($pct -lt 0) {
                # Indeterminate: animated yellow pulse
                $blockW = [int]($w * 0.35)
                $tick   = [int]([System.Environment]::TickCount / 8) % ($w + $blockW)
                $x0     = $tick - $blockW
                $rect   = New-Object System.Drawing.Rectangle($x0, 0, $blockW, $h)
                try {
                    $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
                        $rect,
                        [System.Drawing.Color]::FromArgb(60, 200, 160, 0),
                        [System.Drawing.Color]::FromArgb(255, 220, 0),
                        [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
                    )
                    $g.FillRectangle($grad, $rect)
                    $grad.Dispose()
                } catch {
                    $fb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 0))
                    $g.FillRectangle($fb, $rect)
                    $fb.Dispose()
                }
            } else {
                # Determinate fill
                $fillW = [int]($w * $pct / 100.0)
                if ($fillW -gt 0) {
                    $fillRect = New-Object System.Drawing.Rectangle(0, 0, $fillW, $h)
                    try {
                        $fillGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
                            $fillRect,
                            [System.Drawing.Color]::FromArgb(255, 235, 30),
                            [System.Drawing.Color]::FromArgb(200, 170, 0),
                            [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
                        )
                        $g.FillRectangle($fillGrad, $fillRect)
                        $fillGrad.Dispose()
                    } catch {
                        $fb2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 0))
                        $g.FillRectangle($fb2, $fillRect)
                        $fb2.Dispose()
                    }
                }
            }
        })

        # ── Percent label (right of bar) ───────────────────────────────────
        $dlPct = New-Object System.Windows.Forms.Label
        $dlPct.Text      = ""
        $dlPct.ForeColor = [System.Drawing.Color]::FromArgb(255, 220, 0)
        $dlPct.Font      = New-Object System.Drawing.Font("Segoe UI", 7, [System.Drawing.FontStyle]::Bold)
        $dlPct.AutoSize  = $false
        $dlPct.Size      = New-Object System.Drawing.Size(48, 14)
        $dlPct.Location  = New-Object System.Drawing.Point(296, 71)
        $dlPct.TextAlign = "MiddleRight"

        # ── KB transferred label ───────────────────────────────────────────
        $dlStatus = New-Object System.Windows.Forms.Label
        $dlStatus.Text      = "Connecting..."
        $dlStatus.ForeColor = [System.Drawing.Color]::FromArgb(75, 75, 75)
        $dlStatus.Font      = New-Object System.Drawing.Font("Segoe UI", 7)
        $dlStatus.AutoSize  = $false
        $dlStatus.Size      = New-Object System.Drawing.Size(316, 14)
        $dlStatus.Location  = New-Object System.Drawing.Point(20, 96)
        $dlStatus.TextAlign = "MiddleLeft"

        # ── Marquee timer (~60 fps repaint) ───────────────────────────────
        $dlTimer = New-Object System.Windows.Forms.Timer
        $dlTimer.Interval = 16
        $dlTimer.Add_Tick({ $dlTrack.Invalidate() })

        $dlInner.Controls.AddRange(@($dlTitle, $dlSub, $dlTrack, $dlPct, $dlStatus))
        $dlForm.Controls.Add($dlInner)
        $dlForm.Show()
        $dlForm.Refresh()

        $script:dlProgress = -1
        $dlTimer.Start()

        # ── Download ───────────────────────────────────────────────────────
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $wc = New-Object System.Net.WebClient
            $wc.Headers.Add("Cache-Control", "no-cache")

            $wc.add_DownloadProgressChanged({
                param($s, $e)
                if ($e.TotalBytesToReceive -gt 0) {
                    $script:dlProgress = $e.ProgressPercentage
                    $dlTimer.Stop()
                    $recv  = [Math]::Round($e.BytesReceived       / 1KB)
                    $total = [Math]::Round($e.TotalBytesToReceive / 1KB)
                    $dlStatus.Text = "$recv KB  /  $total KB"
                    $dlPct.Text    = "$($e.ProgressPercentage)%"
                } else {
                    $recv          = [Math]::Round($e.BytesReceived / 1KB)
                    $dlStatus.Text = "$recv KB downloaded"
                }
                $dlTrack.Invalidate()
                $dlForm.Refresh()
            })

            $wc.DownloadFile($dlgUrl, $script:dlgExe)

            # Save version tag + file size into Settings.ini
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $wcTag = New-Object System.Net.WebClient
                $wcTag.Headers.Add("User-Agent", "MARIUS-Updater")
                $jsonTag  = $wcTag.DownloadString($dlgApiUrl)
                $savedTag = (($jsonTag -split '"tag_name"\s*:\s*"')[1] -split '"')[0]
                $exeSize  = (Get-Item $script:dlgExe).Length
                Save-IniToolVer "DeepLog" $savedTag $exeSize
            } catch {}

            # ── Complete flash ─────────────────────────────────────────────
            $dlTimer.Stop()
            $script:dlProgress = 100
            $dlStatus.Text     = "Complete."
            $dlPct.Text        = "100%"
            $dlSub.Text        = "DeepLog.exe ready."
            $dlSub.ForeColor   = [System.Drawing.Color]::FromArgb(255, 220, 0)
            $dlTrack.Invalidate()
            $dlForm.Refresh()
            Start-Sleep -Milliseconds 500

        } catch {
            $dlTimer.Stop()
            $dlForm.Close()
            [System.Windows.Forms.MessageBox]::Show(
                "Could not download DeepLog.`n`nCheck your connection or grab it manually:`nhttps://github.com/MariusHeier/deeplog/releases`n`n$_",
                "Download Failed",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            return
        }
        $dlForm.Close()
    }

    # ── Launch directly, elevated ──────────────────────────────────────────
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName        = "cmd.exe"
    $psi.Arguments       = "/k `"$script:dlgExe`""
    $psi.WindowStyle     = [System.Diagnostics.ProcessWindowStyle]::Normal
    $psi.UseShellExecute = $true
    $psi.Verb            = "runas"
    [System.Diagnostics.Process]::Start($psi) | Out-Null
}


function Show-AutoCalibrate {
    # ── State ────────────────────────────────────────────────────────────
    $script:acFilePath = $null
    $script:acRawText  = $null
    # Each match: @{ Key='xMin'|'yMin'|'xMax'|'yMax'; Value=int; Start=int; Length=int; Stick='LEFT'|'RIGHT' }
    $script:acMatches  = New-Object System.Collections.Generic.List[object]

    $W = 720; $H = 940
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text            = ""
    $dlg.Width           = $W
    $dlg.Height          = $H
    $dlg.StartPosition   = "CenterScreen"
    $dlg.FormBorderStyle = "None"
    $dlg.BackColor       = [System.Drawing.Color]::Yellow
    $dlg.TopMost         = $false

    $script:acDrag = $false; $script:acDX = 0; $script:acDY = 0

    $inner = New-Object System.Windows.Forms.Panel
    $inner.Location  = New-Object System.Drawing.Point(3, 3)
    $inner.Size      = New-Object System.Drawing.Size(($W - 6), ($H - 6))
    $inner.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $dlg.Controls.Add($inner)

    # ── RGB border timer (matches Troubleshooting/DeepPoll pattern) ─────────
    $script:acHue = if ($script:rgbHue) { $script:rgbHue } else { 0 }
    $acRgbTimer = New-Object System.Windows.Forms.Timer
    $acRgbTimer.Interval = 40
    $acRgbTimer.Add_Tick({
        $script:acHue = ($script:acHue + 2) % 360
        $h = $script:acHue / 360.0
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
    $acRgbTimer.Start()
    $dlg.Add_FormClosed({ $acRgbTimer.Stop(); $acRgbTimer.Dispose() })

    # ── Title bar ─────────────────────────────────────────────────────────
    $titleBar = New-Object System.Windows.Forms.Panel
    $titleBar.Location  = New-Object System.Drawing.Point(0, 0)
    $titleBar.Size      = New-Object System.Drawing.Size(($W - 6), 70)
    $titleBar.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $inner.Controls.Add($titleBar)
    $titleBar.Add_MouseDown({ $script:acDrag=$true; $script:acDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:acDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $titleBar.Add_MouseMove({ if($script:acDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:acDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:acDY } })
    $titleBar.Add_MouseUp({ $script:acDrag=$false })

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
        $g.DrawString("AUTO CALIBRATION",$sf,$sb,22,17)
        $g.DrawString("AUTO CALIBRATION",$tf,$tb,20,15)
        $sf.Dispose();$sb.Dispose();$tf.Dispose();$tb.Dispose()
    })
    $picTitle.Add_MouseDown({ $script:acDrag=$true; $script:acDX=[System.Windows.Forms.Cursor]::Position.X-$dlg.Left; $script:acDY=[System.Windows.Forms.Cursor]::Position.Y-$dlg.Top })
    $picTitle.Add_MouseMove({ if($script:acDrag){ $dlg.Left=[System.Windows.Forms.Cursor]::Position.X-$script:acDX; $dlg.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:acDY } })
    $picTitle.Add_MouseUp({ $script:acDrag=$false })
    $titleBar.Controls.Add($picTitle)

    # Close (X) button
    $btnClose = New-Object System.Windows.Forms.Button
    $btnClose.Location  = New-Object System.Drawing.Point(($W - 6 - 36), 8)
    $btnClose.Size      = New-Object System.Drawing.Size(28, 28)
    $btnClose.Text      = "X"
    $btnClose.FlatStyle = "Flat"
    $btnClose.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btnClose.ForeColor = [System.Drawing.Color]::Yellow
    $btnClose.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $btnClose.FlatAppearance.BorderSize = 1
    $btnClose.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $btnClose.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnClose.Add_Click({ $dlg.Close() })
    $titleBar.Controls.Add($btnClose)

    # Divider
    $div = New-Object System.Windows.Forms.Panel
    $div.Location  = New-Object System.Drawing.Point(0, 70)
    $div.Size      = New-Object System.Drawing.Size(($W - 6), 2)
    $div.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
    $inner.Controls.Add($div)

    # ── ALPHA info panel (three rows) ────────────────────────────────────
    $badgePanel = New-Object System.Windows.Forms.Panel
    $badgePanel.Location  = New-Object System.Drawing.Point(20, 80)
    $badgePanel.Size      = New-Object System.Drawing.Size(($W - 46), 96)
    $badgePanel.BackColor = [System.Drawing.Color]::FromArgb(22, 22, 0)
    $inner.Controls.Add($badgePanel)

    # Row 1: alpha warning
    $lblStatus = New-Object System.Windows.Forms.Label
    $lblStatus.Location  = New-Object System.Drawing.Point(8, 4)
    $lblStatus.Size      = New-Object System.Drawing.Size(($W - 62), 24)
    $lblStatus.Text      = "[INFO]  Edit stick calibration values directly. Use with care!"
    $lblStatus.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $lblStatus.ForeColor = [System.Drawing.Color]::Yellow
    $lblStatus.BackColor = [System.Drawing.Color]::Transparent
    $lblStatus.TextAlign = "MiddleLeft"
    $badgePanel.Controls.Add($lblStatus)

    # Row 2: backup reminder
    $lblBackupNote = New-Object System.Windows.Forms.Label
    $lblBackupNote.Location  = New-Object System.Drawing.Point(8, 30)
    $lblBackupNote.Size      = New-Object System.Drawing.Size(($W - 62), 20)
    $lblBackupNote.Text      = "Load reads your file directly. Save writes your edits back to that same file."
    $lblBackupNote.Font      = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
    $lblBackupNote.ForeColor = [System.Drawing.Color]::FromArgb(175, 175, 90)
    $lblBackupNote.BackColor = [System.Drawing.Color]::Transparent
    $lblBackupNote.TextAlign = "MiddleLeft"
    $badgePanel.Controls.Add($lblBackupNote)

    # Row 3: red manual backup warning - tells user exactly how to do it
    $lblBackupWarn = New-Object System.Windows.Forms.Label
    $lblBackupWarn.Location  = New-Object System.Drawing.Point(8, 52)
    $lblBackupWarn.Size      = New-Object System.Drawing.Size(($W - 62), 20)
    $lblBackupWarn.Text      = "MAKE SURE TO BACK UP YOUR ORIGINAL FILE - this works best on a fresh, known-good calibration!"
    $lblBackupWarn.Font      = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
    $lblBackupWarn.ForeColor = [System.Drawing.Color]::FromArgb(220, 50, 50)
    $lblBackupWarn.BackColor = [System.Drawing.Color]::Transparent
    $lblBackupWarn.TextAlign = "MiddleLeft"
    $badgePanel.Controls.Add($lblBackupWarn)

    # Row 4: extra red line - tell them to keep a copy OUTSIDE the tool too
    $lblBackupWarn2 = New-Object System.Windows.Forms.Label
    $lblBackupWarn2.Location  = New-Object System.Drawing.Point(8, 72)
    $lblBackupWarn2.Size      = New-Object System.Drawing.Size(($W - 62), 20)
    $lblBackupWarn2.Text      = "KEEP YOUR ORIGINAL FILE SAFE - copy it to another folder or USB drive as your own backup!"
    $lblBackupWarn2.Font      = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
    $lblBackupWarn2.ForeColor = [System.Drawing.Color]::FromArgb(220, 50, 50)
    $lblBackupWarn2.BackColor = [System.Drawing.Color]::Transparent
    $lblBackupWarn2.TextAlign = "MiddleLeft"
    $badgePanel.Controls.Add($lblBackupWarn2)

    # ── Load / Save / Exit buttons ───────────────────────────────────────
    $btnLoad = New-Object System.Windows.Forms.Button
    $btnLoad.Location  = New-Object System.Drawing.Point(20, 188)
    $btnLoad.Size      = New-Object System.Drawing.Size(155, 36)
    $btnLoad.Text      = "LOAD CONFIG"
    $btnLoad.FlatStyle = "Flat"
    $btnLoad.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btnLoad.ForeColor = [System.Drawing.Color]::Yellow
    $btnLoad.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnLoad.FlatAppearance.BorderSize = 1
    $btnLoad.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $btnLoad.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $inner.Controls.Add($btnLoad)

    $btnSave = New-Object System.Windows.Forms.Button
    $btnSave.Location  = New-Object System.Drawing.Point(185, 188)
    $btnSave.Size      = New-Object System.Drawing.Size(155, 36)
    $btnSave.Text      = "SAVE CONFIG"
    $btnSave.FlatStyle = "Flat"
    $btnSave.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btnSave.ForeColor = [System.Drawing.Color]::FromArgb(120,120,120)
    $btnSave.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnSave.FlatAppearance.BorderSize = 1
    $btnSave.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(80,80,80)
    $btnSave.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnSave.Enabled   = $false
    $inner.Controls.Add($btnSave)

    # EXIT button - always enabled, closes the calibration dialog
    $btnExit = New-Object System.Windows.Forms.Button
    $btnExit.Location  = New-Object System.Drawing.Point(350, 188)
    $btnExit.Size      = New-Object System.Drawing.Size(100, 36)
    $btnExit.Text      = "EXIT"
    $btnExit.FlatStyle = "Flat"
    $btnExit.BackColor = [System.Drawing.Color]::FromArgb(28, 8, 8)
    $btnExit.ForeColor = [System.Drawing.Color]::FromArgb(220, 60, 60)
    $btnExit.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnExit.FlatAppearance.BorderSize = 1
    $btnExit.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(180, 40, 40)
    $btnExit.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(50, 10, 10)
    $btnExit.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(70, 10, 10)
    $btnExit.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnExit.Add_Click({ $dlg.Close() })
    $inner.Controls.Add($btnExit)

    $lblPath = New-Object System.Windows.Forms.Label
    $lblPath.Location  = New-Object System.Drawing.Point(460, 154)
    $lblPath.Size      = New-Object System.Drawing.Size(($W - 6 - 460 - 20), 24)
    $lblPath.Text      = "No file loaded"
    $lblPath.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
    $lblPath.ForeColor = [System.Drawing.Color]::FromArgb(150,150,150)
    $lblPath.TextAlign = "MiddleLeft"
    $lblPath.AutoEllipsis = $true
    $inner.Controls.Add($lblPath)

    # ── Stick group panels (LEFT STICK / RIGHT STICK) ───────────────────
    function New-AcGroup {
        param([string]$Title, [int]$X, [int]$Y, [int]$GW, [int]$GH)
        $grp = New-Object System.Windows.Forms.Panel
        $grp.Location  = New-Object System.Drawing.Point($X, $Y)
        $grp.Size      = New-Object System.Drawing.Size($GW, $GH)
        $grp.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)

        $hdr = New-Object System.Windows.Forms.Label
        $hdr.Location  = New-Object System.Drawing.Point(10, 8)
        $hdr.Size      = New-Object System.Drawing.Size(($GW - 20), 24)
        $hdr.Text      = $Title
        $hdr.Font      = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $hdr.ForeColor = [System.Drawing.Color]::Yellow
        $grp.Controls.Add($hdr)

        return $grp
    }

    # 4 rows per stick: UP (yMin), LEFT (xMin), RIGHT (xMax), DOWN (yMax)
    function Add-AcRow {
        param($Parent, [string]$LabelText, [int]$RowY)
        $lbl = New-Object System.Windows.Forms.Label
        $lbl.Location  = New-Object System.Drawing.Point(10, $RowY)
        $lbl.Size      = New-Object System.Drawing.Size(130, 28)
        $lbl.Text      = $LabelText
        $lbl.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $lbl.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
        $lbl.BackColor = [System.Drawing.Color]::Transparent
        $lbl.TextAlign = "MiddleLeft"
        $Parent.Controls.Add($lbl)

        $num = New-Object System.Windows.Forms.NumericUpDown
        $num.Location  = New-Object System.Drawing.Point(150, $RowY)
        $num.Size      = New-Object System.Drawing.Size(110, 28)
        $num.Minimum   = -100000
        $num.Maximum   = 100000
        $num.Increment = 10
        $num.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        # Keep Enabled=true so WinForms respects our colors; ReadOnly prevents editing until loaded
        $num.ReadOnly  = $true
        $num.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
        $num.ForeColor = [System.Drawing.Color]::FromArgb(90, 90, 90)
        $num.BorderStyle = "FixedSingle"
        $num.TextAlign = "Center"
        $num.Enabled   = $true
        $Parent.Controls.Add($num)

        $lblKey = New-Object System.Windows.Forms.Label
        $lblKey.Location  = New-Object System.Drawing.Point(270, $RowY)
        $lblKey.Size      = New-Object System.Drawing.Size(70, 28)
        $lblKey.Text      = ""
        $lblKey.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
        $lblKey.ForeColor = [System.Drawing.Color]::FromArgb(110, 110, 110)
        $lblKey.BackColor = [System.Drawing.Color]::Transparent
        $lblKey.TextAlign = "MiddleLeft"
        $Parent.Controls.Add($lblKey)

        return $num, $lblKey
    }

    $groupW = ($W - 6 - 60) / 2
    $groupH = 220

    $grpLeft  = New-AcGroup -Title "LEFT STICK"  -X 20 -Y 240 -GW $groupW -GH $groupH
    $grpRight = New-AcGroup -Title "RIGHT STICK" -X (20 + $groupW + 20) -Y 240 -GW $groupW -GH $groupH
    $inner.Controls.Add($grpLeft)
    $inner.Controls.Add($grpRight)

    $L_up,    $L_upKey    = Add-AcRow -Parent $grpLeft  -LabelText "UP (yMin)"    -RowY 50
    $L_left,  $L_leftKey  = Add-AcRow -Parent $grpLeft  -LabelText "LEFT (xMin)"  -RowY 90
    $L_right, $L_rightKey = Add-AcRow -Parent $grpLeft  -LabelText "RIGHT (xMax)" -RowY 130
    $L_down,  $L_downKey  = Add-AcRow -Parent $grpLeft  -LabelText "DOWN (yMax)"  -RowY 170

    $R_up,    $R_upKey    = Add-AcRow -Parent $grpRight -LabelText "UP (yMin)"    -RowY 50
    $R_left,  $R_leftKey  = Add-AcRow -Parent $grpRight -LabelText "LEFT (xMin)"  -RowY 90
    $R_right, $R_rightKey = Add-AcRow -Parent $grpRight -LabelText "RIGHT (xMax)" -RowY 130
    $R_down,  $R_downKey  = Add-AcRow -Parent $grpRight -LabelText "DOWN (yMax)"  -RowY 170

    # ── Per-stick adjust buttons — directly under each group ─────────────
    # Groups bottom: Y=200 + groupH=220 = 420; leave 8px gap
    $stickLblH   = 20
    $stickBtnY   = 240 + $groupH + 8 + $stickLblH + 4
    $stickBtnH   = 36
    $stickBtnGap = 6
    # Each group is $groupW wide starting at X=20 (left) and X=20+groupW+20 (right)
    $stickBtnW   = [int](($groupW - 30) / 4)   # 4 buttons per side with gaps
    $rightGrpX   = 20 + $groupW + 20

    # Red "LEFT STICK" label above left buttons
    $lblLeftStick = New-Object System.Windows.Forms.Label
    $lblLeftStick.Location  = New-Object System.Drawing.Point(20, (240 + $groupH + 8))
    $lblLeftStick.Size      = New-Object System.Drawing.Size($groupW, $stickLblH)
    $lblLeftStick.Text      = "LEFT STICK"
    $lblLeftStick.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $lblLeftStick.ForeColor = [System.Drawing.Color]::FromArgb(210, 50, 50)
    $lblLeftStick.BackColor = [System.Drawing.Color]::Transparent
    $lblLeftStick.TextAlign = "MiddleLeft"
    $inner.Controls.Add($lblLeftStick)

    # Red "RIGHT STICK" label above right buttons
    $lblRightStick = New-Object System.Windows.Forms.Label
    $lblRightStick.Location  = New-Object System.Drawing.Point($rightGrpX, (240 + $groupH + 8))
    $lblRightStick.Size      = New-Object System.Drawing.Size($groupW, $stickLblH)
    $lblRightStick.Text      = "RIGHT STICK"
    $lblRightStick.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $lblRightStick.ForeColor = [System.Drawing.Color]::FromArgb(210, 50, 50)
    $lblRightStick.BackColor = [System.Drawing.Color]::Transparent
    $lblRightStick.TextAlign = "MiddleLeft"
    $inner.Controls.Add($lblRightStick)

    function New-StickBtn {
        param([string]$Text, [int]$X, [int]$Y, [int]$W2, [int]$H2)
        $b = New-Object System.Windows.Forms.Button
        $b.Location  = New-Object System.Drawing.Point($X, $Y)
        $b.Size      = New-Object System.Drawing.Size($W2, $H2)
        $b.Text      = $Text
        $b.FlatStyle = "Flat"
        $b.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
        $b.ForeColor = [System.Drawing.Color]::Yellow
        $b.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $b.FlatAppearance.BorderSize  = 1
        $b.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
        $b.Cursor    = [System.Windows.Forms.Cursors]::Hand
        $b.Enabled   = $false
        return $b
    }

    # LEFT stick buttons (row 1: +2 | +5 | +10 | +20 / row 2: -2 | -5 | -10 | -20)
    $btnL2   = New-StickBtn "+2"   (20)                                              ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnL5   = New-StickBtn "+5"   (20 + $stickBtnW + $stickBtnGap)                 ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnL10  = New-StickBtn "+10"  (20 + ($stickBtnW + $stickBtnGap)*2)             ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnL20  = New-StickBtn "+20"  (20 + ($stickBtnW + $stickBtnGap)*3)             ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnLm2  = New-StickBtn "-2"   (20)                                              ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH
    $btnLm5  = New-StickBtn "-5"   (20 + $stickBtnW + $stickBtnGap)                 ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH
    $btnLm10 = New-StickBtn "-10"  (20 + ($stickBtnW + $stickBtnGap)*2)             ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH
    $btnLm20 = New-StickBtn "-20"  (20 + ($stickBtnW + $stickBtnGap)*3)             ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH

    # RIGHT stick buttons — same layout shifted to right group X
    $btnR2   = New-StickBtn "+2"   ($rightGrpX)                                              ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnR5   = New-StickBtn "+5"   ($rightGrpX + $stickBtnW + $stickBtnGap)                 ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnR10  = New-StickBtn "+10"  ($rightGrpX + ($stickBtnW + $stickBtnGap)*2)             ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnR20  = New-StickBtn "+20"  ($rightGrpX + ($stickBtnW + $stickBtnGap)*3)             ($stickBtnY)                  $stickBtnW $stickBtnH
    $btnRm2  = New-StickBtn "-2"   ($rightGrpX)                                              ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH
    $btnRm5  = New-StickBtn "-5"   ($rightGrpX + $stickBtnW + $stickBtnGap)                 ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH
    $btnRm10 = New-StickBtn "-10"  ($rightGrpX + ($stickBtnW + $stickBtnGap)*2)             ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH
    $btnRm20 = New-StickBtn "-20"  ($rightGrpX + ($stickBtnW + $stickBtnGap)*3)             ($stickBtnY + $stickBtnH + 4) $stickBtnW $stickBtnH

    foreach ($b in @($btnL2,$btnL5,$btnL10,$btnL20,$btnLm2,$btnLm5,$btnLm10,$btnLm20,$btnR2,$btnR5,$btnR10,$btnR20,$btnRm2,$btnRm5,$btnRm10,$btnRm20)) {
        $inner.Controls.Add($b)
    }

    # ── AUTO ADJUST ALL buttons — below per-stick rows ───────────────────
    $adjY = $stickBtnY + $stickBtnH*2 + 4 + 18   # below both per-stick rows + gap

    $lblAdj = New-Object System.Windows.Forms.Label
    $lblAdj.Location  = New-Object System.Drawing.Point(20, $adjY)
    $lblAdj.Size      = New-Object System.Drawing.Size(($W - 46), 24)
    $lblAdj.Text      = "AUTO ADJUST  (both sticks: yMin/xMin +delta, xMax/yMax -delta)"
    $lblAdj.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $lblAdj.ForeColor = [System.Drawing.Color]::FromArgb(210, 50, 50)
    $inner.Controls.Add($lblAdj)

    $btnY = $adjY + 28
    $btnAdjW = [int](($W - 6 - 40 - 40) / 5)

    $btn2all = New-Object System.Windows.Forms.Button
    $btn2all.Location  = New-Object System.Drawing.Point(20, $btnY)
    $btn2all.Size      = New-Object System.Drawing.Size($btnAdjW, 40)
    $btn2all.Text      = "+/-2 ALL"
    $btn2all.FlatStyle = "Flat"
    $btn2all.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btn2all.ForeColor = [System.Drawing.Color]::Yellow
    $btn2all.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn2all.FlatAppearance.BorderSize = 1
    $btn2all.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $btn2all.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btn2all.Enabled   = $false
    $inner.Controls.Add($btn2all)

    $btn5all = New-Object System.Windows.Forms.Button
    $btn5all.Location  = New-Object System.Drawing.Point((20 + $btnAdjW + 10), $btnY)
    $btn5all.Size      = New-Object System.Drawing.Size($btnAdjW, 40)
    $btn5all.Text      = "+/-5 ALL"
    $btn5all.FlatStyle = "Flat"
    $btn5all.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btn5all.ForeColor = [System.Drawing.Color]::Yellow
    $btn5all.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn5all.FlatAppearance.BorderSize = 1
    $btn5all.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $btn5all.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btn5all.Enabled   = $false
    $inner.Controls.Add($btn5all)

    $btn10all = New-Object System.Windows.Forms.Button
    $btn10all.Location  = New-Object System.Drawing.Point((20 + 2*($btnAdjW + 10)), $btnY)
    $btn10all.Size      = New-Object System.Drawing.Size($btnAdjW, 40)
    $btn10all.Text      = "+/-10 ALL"
    $btn10all.FlatStyle = "Flat"
    $btn10all.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btn10all.ForeColor = [System.Drawing.Color]::Yellow
    $btn10all.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn10all.FlatAppearance.BorderSize = 1
    $btn10all.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $btn10all.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btn10all.Enabled   = $false
    $inner.Controls.Add($btn10all)

    $btn20all = New-Object System.Windows.Forms.Button
    $btn20all.Location  = New-Object System.Drawing.Point((20 + 3*($btnAdjW + 10)), $btnY)
    $btn20all.Size      = New-Object System.Drawing.Size($btnAdjW, 40)
    $btn20all.Text      = "+/-20 ALL"
    $btn20all.FlatStyle = "Flat"
    $btn20all.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btn20all.ForeColor = [System.Drawing.Color]::Yellow
    $btn20all.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn20all.FlatAppearance.BorderSize = 1
    $btn20all.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $btn20all.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btn20all.Enabled   = $false
    $inner.Controls.Add($btn20all)

    $btnReset = New-Object System.Windows.Forms.Button
    $btnReset.Location  = New-Object System.Drawing.Point((20 + 4*($btnAdjW + 10)), $btnY)
    $btnReset.Size      = New-Object System.Drawing.Size($btnAdjW, 40)
    $btnReset.Text      = "RESET TO LOADED"
    $btnReset.FlatStyle = "Flat"
    $btnReset.BackColor = [System.Drawing.Color]::FromArgb(20,20,20)
    $btnReset.ForeColor = [System.Drawing.Color]::Yellow
    $btnReset.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnReset.FlatAppearance.BorderSize = 1
    $btnReset.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
    $btnReset.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnReset.Enabled   = $false
    $inner.Controls.Add($btnReset)

    foreach ($b in @($btnLoad,$btnSave,$btn2all,$btn5all,$btn10all,$btn20all,$btnReset,
                     $btnL2,$btnL5,$btnL10,$btnL20,$btnLm2,$btnLm5,$btnLm10,$btnLm20,$btnR2,$btnR5,$btnR10,$btnR20,$btnRm2,$btnRm5,$btnRm10,$btnRm20)) {
        $b.Add_MouseEnter({ if($this.Enabled){ $this.BackColor=[System.Drawing.Color]::FromArgb(40,40,12) } })
        $b.Add_MouseLeave({ if($this.Enabled){ $this.BackColor=[System.Drawing.Color]::FromArgb(20,20,20) } })
    }
    # EXIT uses its own FlatAppearance colours; just reset background on leave
    $btnExit.Add_MouseLeave({ $btnExit.BackColor=[System.Drawing.Color]::FromArgb(28,8,8) })

    # ── Log box (shows what was found / changed) ────────────────────────
    $logY = $btnY + 48
    $logBox = New-Object System.Windows.Forms.RichTextBox
    $logBox.Location   = New-Object System.Drawing.Point(20, $logY)
    $logBox.Size       = New-Object System.Drawing.Size(($W - 46), ($H - $logY - 30))
    $logBox.BackColor  = [System.Drawing.Color]::FromArgb(18, 18, 18)
    $logBox.ForeColor  = [System.Drawing.Color]::FromArgb(190, 190, 190)
    $logBox.Font       = New-Object System.Drawing.Font("Consolas", 9)
    $logBox.ReadOnly   = $true
    $logBox.BorderStyle = "None"
    $logBox.ScrollBars = "Vertical"
    $inner.Controls.Add($logBox)

    function Write-AcLog {
        param([string]$Text, [string]$ColorName = "Gray")
        $logBox.SelectionStart = $logBox.TextLength
        $logBox.SelectionLength = 0
        $logBox.SelectionColor = [System.Drawing.Color]::$ColorName
        $logBox.AppendText("$Text`n")
        $logBox.ScrollToCaret()
    }

    Write-AcLog "Auto Calibration Tool" "Yellow"
    Write-AcLog "Load a JSON file containing xMin/yMin/xMax/yMax values." "Gray"
    Write-AcLog "First complete set found = LEFT STICK. Last complete set found = RIGHT STICK." "Gray"
    Write-AcLog "Load reads directly from the file you pick. Save writes back to that same file." "Cyan"
    Write-AcLog "Pick any JSON file - Load and Save both operate on it directly." "Gray"

    # ── Core: find xMin/yMin/xMax/yMax occurrences in raw text ──────────
    function Find-AcMatches {
        param([string]$Text)

        $pattern = '("(?<key>xMin|yMin|xMax|yMax)"\s*:\s*)(?<val>-?\d+)'
        $regexMatches = [regex]::Matches($Text, $pattern)

        $found = New-Object System.Collections.Generic.List[object]
        foreach ($m in $regexMatches) {
            $valGroup = $m.Groups['val']
            $found.Add([PSCustomObject]@{
                Key    = $m.Groups['key'].Value
                Value  = [int]$valGroup.Value
                Start  = $valGroup.Index
                Length = $valGroup.Length
            })
        }
        return $found
    }

    function Group-AcSticks {
        param($Found)

        # Walk through matches, grouping into consecutive sets of the 4 keys.
        $sets = New-Object System.Collections.Generic.List[object]
        $current = @{}
        foreach ($m in $Found) {
            if ($current.ContainsKey($m.Key)) {
                # Starting a new set (key repeats) -- flush current if it has anything
                if ($current.Count -gt 0) {
                    $sets.Add($current)
                    $current = @{}
                }
            }
            $current[$m.Key] = $m
            if ($current.Count -eq 4) {
                $sets.Add($current)
                $current = @{}
            }
        }
        if ($current.Count -gt 0) { $sets.Add($current) }
        return $sets
    }

    # ── Helper to populate a row — defined at function scope so it works on every load ──
    # FIX: was defined inside $btnLoad.Add_Click which caused scoping issues on 2nd+ load
    function Set-AcRow {
        param($Num, $KeyLbl, $Set, [string]$Key)
        if ($Set.ContainsKey($Key)) {
            $Num.Value     = [decimal]$Set[$Key].Value
            $Num.ReadOnly  = $false
            $Num.BackColor = [System.Drawing.Color]::FromArgb(22, 22, 22)
            $Num.ForeColor = [System.Drawing.Color]::Yellow
            $KeyLbl.Text   = $Key
            $KeyLbl.ForeColor = [System.Drawing.Color]::FromArgb(130, 130, 130)
        } else {
            $Num.Value     = 0
            $Num.ReadOnly  = $true
            $Num.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
            $Num.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
            $KeyLbl.Text   = "(missing)"
            $KeyLbl.ForeColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
        }
        $Num.Refresh()  # force repaint so new value shows immediately
    }

    # ── LOAD JSON ─────────────────────────────────────────────────────────
    $btnLoad.Add_Click({
        $ofd = New-Object System.Windows.Forms.OpenFileDialog
        $ofd.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
        $ofd.Title  = "Select calibration JSON file"
        if ($ofd.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return }

        try {
            $text = [System.IO.File]::ReadAllText($ofd.FileName)
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Could not read file:`n$_","Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }

        $found = Find-AcMatches -Text $text
        if ($found.Count -eq 0) {
            Write-AcLog "No xMin/yMin/xMax/yMax values found in this file." "Red"
            [System.Windows.Forms.MessageBox]::Show("No xMin/yMin/xMax/yMax keys were found in this JSON file.","Nothing Found",
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }

        $sets = Group-AcSticks -Found $found
        if ($sets.Count -eq 0) {
            Write-AcLog "Could not group values into complete sets." "Red"
            return
        }

        # Load reads source into memory. Save writes to LoadThisFileIntoMarius.json.
        $fileDir           = [System.IO.Path]::GetDirectoryName($ofd.FileName)
        $script:acRawText  = $text
        $script:acFilePath = [System.IO.Path]::Combine($fileDir, "LoadThisFileIntoMarius.json")

        $lblPath.Text      = "LoadThisFileIntoMarius.json  (source: $($ofd.SafeFileName))"
        $lblStatus.Text    = "  LOADED  |  $($sets.Count) set(s) found - edit values then SAVE CONFIG"

        $leftSet  = $sets[0]
        $rightSet = $sets[$sets.Count - 1]

        # FIX: reset all spinners to 0 before populating — prevents stale values
        # from a previously loaded file sticking around if a key is missing in the new one
        foreach ($ctrl in @($L_up,$L_left,$L_right,$L_down,$R_up,$R_left,$R_right,$R_down)) {
            $ctrl.Value = 0
        }

        Set-AcRow $L_up    $L_upKey    $leftSet  "yMin"
        Set-AcRow $L_left  $L_leftKey  $leftSet  "xMin"
        Set-AcRow $L_right $L_rightKey $leftSet  "xMax"
        Set-AcRow $L_down  $L_downKey  $leftSet  "yMax"

        Set-AcRow $R_up    $R_upKey    $rightSet "yMin"
        Set-AcRow $R_left  $R_leftKey  $rightSet "xMin"
        Set-AcRow $R_right $R_rightKey $rightSet "xMax"
        Set-AcRow $R_down  $R_downKey  $rightSet "yMax"

        # Store matches for save (use object refs so live edits via NumericUpDown are picked up later)
        $script:acLeftSet  = $leftSet
        $script:acRightSet = $rightSet
        $script:acAllFound = $found

        # FIX: snapshot AFTER Set-AcRow calls so RESET restores the actual new file's values
        $script:acLoadedValues = @{
            L_up    = $L_up.Value;    L_left  = $L_left.Value;  L_right = $L_right.Value;  L_down  = $L_down.Value
            R_up    = $R_up.Value;    R_left  = $R_left.Value;  R_right = $R_right.Value;  R_down  = $R_down.Value
        }

        $btnSave.Enabled = $true
        $btnSave.ForeColor = [System.Drawing.Color]::Yellow
        $btnSave.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
        $btn2all.Enabled = $true
        $btn2all.ForeColor = [System.Drawing.Color]::Yellow
        $btn5all.Enabled = $true
        $btn5all.ForeColor = [System.Drawing.Color]::Yellow
        $btn10all.Enabled = $true
        $btn10all.ForeColor = [System.Drawing.Color]::Yellow
        $btn20all.Enabled = $true
        $btn20all.ForeColor = [System.Drawing.Color]::Yellow
        $btnReset.Enabled = $true
        $btnReset.ForeColor = [System.Drawing.Color]::Yellow
        foreach ($b in @($btnL2,$btnL5,$btnL10,$btnL20,$btnLm2,$btnLm5,$btnLm10,$btnLm20,$btnR2,$btnR5,$btnR10,$btnR20,$btnRm2,$btnRm5,$btnRm10,$btnRm20)) {
            $b.Enabled   = $true
            $b.ForeColor = [System.Drawing.Color]::Yellow
        }

        Write-AcLog "Loaded: $($ofd.FileName)" "Yellow"
        Write-AcLog "Found $($found.Count) value(s) across $($sets.Count) set(s)." "Gray"
        if ($leftSet.Count -lt 4) { Write-AcLog "WARNING: LEFT STICK set is incomplete (missing keys)." "Orange" }
        if ($rightSet.Count -lt 4 -and $sets.Count -gt 1) { Write-AcLog "WARNING: RIGHT STICK set is incomplete (missing keys)." "Orange" }
        if ($sets.Count -eq 1) { Write-AcLog "Only one set found - LEFT and RIGHT show the same values. Saving will update that single set." "Orange" }
        Write-AcLog "  LEFT  -> yMin=$($leftSet['yMin'].Value)  xMin=$($leftSet['xMin'].Value)  xMax=$($leftSet['xMax'].Value)  yMax=$($leftSet['yMax'].Value)" "Gray"
        Write-AcLog "  RIGHT -> yMin=$($rightSet['yMin'].Value)  xMin=$($rightSet['xMin'].Value)  xMax=$($rightSet['xMax'].Value)  yMax=$($rightSet['yMax'].Value)" "Gray"
    })

    # ── Auto-adjust: apply delta to mins (+delta) and maxes (-delta) ────────
    function Apply-AcDelta {
        param([int]$Delta)
        if (-not $script:acFilePath) { return }

        # Snapshot "before" values for the log
        $before = @{
            L_up=$L_up.Value; L_left=$L_left.Value; L_right=$L_right.Value; L_down=$L_down.Value
            R_up=$R_up.Value; R_left=$R_left.Value; R_right=$R_right.Value; R_down=$R_down.Value
        }

        # yMin/xMin increase by Delta; xMax/yMax decrease by Delta
        $L_up.Value    = [decimal][Math]::Min([Math]::Max(($L_up.Value    + $Delta), $L_up.Minimum),    $L_up.Maximum)
        $L_left.Value  = [decimal][Math]::Min([Math]::Max(($L_left.Value  + $Delta), $L_left.Minimum),  $L_left.Maximum)
        $L_right.Value = [decimal][Math]::Min([Math]::Max(($L_right.Value - $Delta), $L_right.Minimum), $L_right.Maximum)
        $L_down.Value  = [decimal][Math]::Min([Math]::Max(($L_down.Value  - $Delta), $L_down.Minimum),  $L_down.Maximum)

        $R_up.Value    = [decimal][Math]::Min([Math]::Max(($R_up.Value    + $Delta), $R_up.Minimum),    $R_up.Maximum)
        $R_left.Value  = [decimal][Math]::Min([Math]::Max(($R_left.Value  + $Delta), $R_left.Minimum),  $R_left.Maximum)
        $R_right.Value = [decimal][Math]::Min([Math]::Max(($R_right.Value - $Delta), $R_right.Minimum), $R_right.Maximum)
        $R_down.Value  = [decimal][Math]::Min([Math]::Max(($R_down.Value  - $Delta), $R_down.Minimum),  $R_down.Maximum)

        Write-AcLog "Applied delta $Delta (yMin/xMin +, xMax/yMax -) to both sticks:" "Yellow"
        Write-AcLog "  LEFT  UP $($before.L_up)->$($L_up.Value)  LEFT $($before.L_left)->$($L_left.Value)  RIGHT $($before.L_right)->$($L_right.Value)  DOWN $($before.L_down)->$($L_down.Value)" "Gray"
        Write-AcLog "  RIGHT UP $($before.R_up)->$($R_up.Value)  LEFT $($before.R_left)->$($R_left.Value)  RIGHT $($before.R_right)->$($R_right.Value)  DOWN $($before.R_down)->$($R_down.Value)" "Gray"
    }

    $btn2all.Add_Click({  Apply-AcDelta -Delta 2  })
    $btn5all.Add_Click({  Apply-AcDelta -Delta 5  })
    $btn10all.Add_Click({ Apply-AcDelta -Delta 10 })
    $btn20all.Add_Click({ Apply-AcDelta -Delta 20 })

    # ── Per-stick delta (only touches one stick) ─────────────────────────
    function Apply-AcDeltaStick {
        param([int]$Delta, [string]$Stick)
        if (-not $script:acFilePath) { return }

        if ($Stick -eq 'LEFT') {
            $before = @{ up=$L_up.Value; left=$L_left.Value; right=$L_right.Value; down=$L_down.Value }
            $L_up.Value    = [decimal][Math]::Min([Math]::Max(($L_up.Value    + $Delta), $L_up.Minimum),    $L_up.Maximum)
            $L_left.Value  = [decimal][Math]::Min([Math]::Max(($L_left.Value  + $Delta), $L_left.Minimum),  $L_left.Maximum)
            $L_right.Value = [decimal][Math]::Min([Math]::Max(($L_right.Value - $Delta), $L_right.Minimum), $L_right.Maximum)
            $L_down.Value  = [decimal][Math]::Min([Math]::Max(($L_down.Value  - $Delta), $L_down.Minimum),  $L_down.Maximum)
            Write-AcLog "Applied delta $Delta to LEFT stick only (yMin/xMin +, xMax/yMax -):" "Yellow"
            Write-AcLog "  UP $($before.up)->$($L_up.Value)  LEFT $($before.left)->$($L_left.Value)  RIGHT $($before.right)->$($L_right.Value)  DOWN $($before.down)->$($L_down.Value)" "Gray"
        } elseif ($Stick -eq 'RIGHT') {
            $before = @{ up=$R_up.Value; left=$R_left.Value; right=$R_right.Value; down=$R_down.Value }
            $R_up.Value    = [decimal][Math]::Min([Math]::Max(($R_up.Value    + $Delta), $R_up.Minimum),    $R_up.Maximum)
            $R_left.Value  = [decimal][Math]::Min([Math]::Max(($R_left.Value  + $Delta), $R_left.Minimum),  $R_left.Maximum)
            $R_right.Value = [decimal][Math]::Min([Math]::Max(($R_right.Value - $Delta), $R_right.Minimum), $R_right.Maximum)
            $R_down.Value  = [decimal][Math]::Min([Math]::Max(($R_down.Value  - $Delta), $R_down.Minimum),  $R_down.Maximum)
            Write-AcLog "Applied delta $Delta to RIGHT stick only (yMin/xMin +, xMax/yMax -):" "Yellow"
            Write-AcLog "  UP $($before.up)->$($R_up.Value)  LEFT $($before.left)->$($R_left.Value)  RIGHT $($before.right)->$($R_right.Value)  DOWN $($before.down)->$($R_down.Value)" "Gray"
        }
    }

    $btnL2.Add_Click({   Apply-AcDeltaStick -Delta   2 -Stick 'LEFT'  })
    $btnL5.Add_Click({   Apply-AcDeltaStick -Delta   5 -Stick 'LEFT'  })
    $btnL10.Add_Click({  Apply-AcDeltaStick -Delta  10 -Stick 'LEFT'  })
    $btnL20.Add_Click({  Apply-AcDeltaStick -Delta  20 -Stick 'LEFT'  })
    $btnLm2.Add_Click({  Apply-AcDeltaStick -Delta  -2 -Stick 'LEFT'  })
    $btnLm5.Add_Click({  Apply-AcDeltaStick -Delta  -5 -Stick 'LEFT'  })
    $btnLm10.Add_Click({ Apply-AcDeltaStick -Delta -10 -Stick 'LEFT'  })
    $btnLm20.Add_Click({ Apply-AcDeltaStick -Delta -20 -Stick 'LEFT'  })
    $btnR2.Add_Click({   Apply-AcDeltaStick -Delta   2 -Stick 'RIGHT' })
    $btnR5.Add_Click({   Apply-AcDeltaStick -Delta   5 -Stick 'RIGHT' })
    $btnR10.Add_Click({  Apply-AcDeltaStick -Delta  10 -Stick 'RIGHT' })
    $btnR20.Add_Click({  Apply-AcDeltaStick -Delta  20 -Stick 'RIGHT' })
    $btnRm2.Add_Click({  Apply-AcDeltaStick -Delta  -2 -Stick 'RIGHT' })
    $btnRm5.Add_Click({  Apply-AcDeltaStick -Delta  -5 -Stick 'RIGHT' })
    $btnRm10.Add_Click({ Apply-AcDeltaStick -Delta -10 -Stick 'RIGHT' })
    $btnRm20.Add_Click({ Apply-AcDeltaStick -Delta -20 -Stick 'RIGHT' })

    # ── RESET TO LOADED: restore the values as they were when the file was loaded ──
    $btnReset.Add_Click({
        if (-not $script:acLoadedValues) { return }
        $v = $script:acLoadedValues
        $L_up.Value    = $v.L_up;    $L_left.Value  = $v.L_left;  $L_right.Value = $v.L_right;  $L_down.Value  = $v.L_down
        $R_up.Value    = $v.R_up;    $R_left.Value  = $v.R_left;  $R_right.Value = $v.R_right;  $R_down.Value  = $v.R_down
        Write-AcLog "Reset all 8 values back to as-loaded." "Yellow"
    })

    # ── SAVE JSON ─────────────────────────────────────────────────────────
    $btnSave.Add_Click({
        if (-not $script:acFilePath -or -not $script:acRawText) { return }

        # Read spinner values directly
        $leftVals  = @{ yMin=[int]$L_up.Value; xMin=[int]$L_left.Value; xMax=[int]$L_right.Value; yMax=[int]$L_down.Value }
        $rightVals = @{ yMin=[int]$R_up.Value; xMin=[int]$R_left.Value; xMax=[int]$R_right.Value; yMax=[int]$R_down.Value }

        # FIX: always re-scan fresh offsets from the current working text instead of
        # using $script:acAllFound which holds stale positions from load time.
        # Offsets drift whenever a number changes digit length (e.g. 480->1000),
        # causing subsequent saves to corrupt the file or write to the wrong position.
        $freshFound = Find-AcMatches -Text $script:acRawText
        $sets = Group-AcSticks -Found $freshFound
        if ($sets.Count -eq 0) {
            Write-AcLog "ERROR: Could not find calibration keys in working text." "Red"
            return
        }
        $leftSet  = $sets[0]
        $rightSet = $sets[$sets.Count - 1]

        # Apply replacements back-to-front by offset so earlier positions stay valid
        $ops = New-Object System.Collections.Generic.List[object]
        foreach ($key in @("yMin","xMin","xMax","yMax")) {
            if ($leftSet.ContainsKey($key)) {
                $m = $leftSet[$key]
                $ops.Add([PSCustomObject]@{ Start=$m.Start; Length=$m.Length; NewText=[string]$leftVals[$key] })
            }
            if ($sets.Count -gt 1 -and $rightSet.ContainsKey($key)) {
                $m = $rightSet[$key]
                $ops.Add([PSCustomObject]@{ Start=$m.Start; Length=$m.Length; NewText=[string]$rightVals[$key] })
            }
        }

        $sortedOps = $ops | Sort-Object -Property Start -Descending
        $newText = $script:acRawText
        foreach ($op in $sortedOps) {
            $newText = $newText.Substring(0, $op.Start) + $op.NewText + $newText.Substring($op.Start + $op.Length)
        }

        try {
            [System.IO.File]::WriteAllText($script:acFilePath, $newText, [System.Text.Encoding]::UTF8)  # exact bytes, no BOM/newline drift
            $script:acRawText  = $newText
            $script:acAllFound = Find-AcMatches -Text $newText
            # Verify: re-read the file we just wrote and confirm values match spinners
            $verify = [System.IO.File]::ReadAllText($script:acFilePath)
            $vFound = Find-AcMatches -Text $verify
            $vSets  = Group-AcSticks -Found $vFound
            $vL = $vSets[0]; $vR = $vSets[$vSets.Count - 1]
            Write-AcLog "Saved to: $($script:acFilePath)" "Yellow"
            Write-AcLog "  WRITTEN LEFT  -> yMin=$($vL['yMin'].Value)  xMin=$($vL['xMin'].Value)  xMax=$($vL['xMax'].Value)  yMax=$($vL['yMax'].Value)" "Gray"
            Write-AcLog "  WRITTEN RIGHT -> yMin=$($vR['yMin'].Value)  xMin=$($vR['xMin'].Value)  xMax=$($vR['xMax'].Value)  yMax=$($vR['yMax'].Value)" "Gray"
            Write-AcLog "  SPINNER LEFT  -> yMin=$([int]$L_up.Value)  xMin=$([int]$L_left.Value)  xMax=$([int]$L_right.Value)  yMax=$([int]$L_down.Value)" "Cyan"
            Write-AcLog "  SPINNER RIGHT -> yMin=$([int]$R_up.Value)  xMin=$([int]$R_left.Value)  xMax=$([int]$R_right.Value)  yMax=$([int]$R_down.Value)" "Cyan"
            Write-AcLog "  Your original source file is still untouched." "Cyan"
            $lblStatus.Text = "  SAVED  |  $($ops.Count) value(s) written"
        } catch {
            Write-AcLog "ERROR saving file: $_" "Red"
            [System.Windows.Forms.MessageBox]::Show("Could not save file:`n$_","Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    $dlg.Add_KeyDown({ param($s,$e); if($e.KeyCode -eq "Escape"){ $dlg.Close() } })
    [void]$dlg.ShowDialog()
}

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
        [bool]$ResultOnly     = $false,
        [string]$Credits      = "Script by: @EODBruz",
        [bool]$ShowStatusBadge = $true
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
    $dlg.TopMost         = $false

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
        if ($ShowStatusBadge) {
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
        }

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
        $lblCredits.Text      = $Credits
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
        -IsApplied    $isApplied `
        -Credits      "GameBar fix by: @FR33THY  |  Script by: @EODBruz"

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

function Invoke-UninstallHIDUSBF {
    # ── Styled confirm dialog ─────────────────────────────────────────────────
    $choice = Show-GameBarDialog `
        -Title        "UNINSTALL HIDUSBF" `
        -Subtitle     "This will completely remove HIDUSBF from your system." `
        -Lines        @(
            "## Steps that will be performed:",
            "  [+]  Remove hidusbf.sys from System32\drivers",
            "  [+]  Remove hidusbf.dll files if present",
            "  [+]  Remove common HIDUSBF folders",
            "  [+]  Verify removal",
            "",
            "  A restart may be needed to finish removal.",
            "  Downloaded ZIP files will NOT be removed."
        ) `
        -ApplyLabel     "UNINSTALL" `
        -RestoreLabel   "CANCEL" `
        -ShowStatusBadge $false

    if ($choice -ne "apply") { return }

    # ── Admin block (mirrors Uninstall_HIDUSBF_Complete.bat) ─────────────────
    $psBlock = [scriptblock]::Create(@'
        $result = @{ SysRemoved = $false; SysStillPresent = $false; FoldersRemoved = 0 }

        # Step 1: driver + dll files
        $sysPath = "C:\Windows\System32\drivers\hidusbf.sys"
        if (Test-Path $sysPath) {
            Remove-Item -Path $sysPath -Force -ErrorAction SilentlyContinue
        }
        "C:\Windows\System32\hidusbf.dll","C:\Windows\SysWOW64\hidusbf.dll" | ForEach-Object {
            if (Test-Path $_) { Remove-Item -Path $_ -Force -ErrorAction SilentlyContinue }
        }

        # Step 2: verify driver removal
        $result.SysStillPresent = Test-Path $sysPath
        $result.SysRemoved = -not $result.SysStillPresent

        # Step 3: common folders (downloaded ZIPs are left alone)
        $folders = @(
            "C:\Tools\HIDUSBF",
            "C:\Program Files\HIDUSBF",
            "C:\Program Files (x86)\HIDUSBF",
            "$env:USERPROFILE\Downloads\HIDUSBF",
            "$env:USERPROFILE\Desktop\HIDUSBF"
        )
        foreach ($f in $folders) {
            if (Test-Path $f) {
                Remove-Item -Path $f -Recurse -Force -ErrorAction SilentlyContinue
                $result.FoldersRemoved++
            }
        }

        $resultPath = "$env:TEMP\marius_hidusbf_uninstall_result.json"
        ($result | ConvertTo-Json -Compress) | Out-File -FilePath $resultPath -Encoding utf8 -Force
'@)

    $resultPath = "$env:TEMP\marius_hidusbf_uninstall_result.json"
    Remove-Item -Path $resultPath -Force -ErrorAction SilentlyContinue

    $isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups.Value -contains 'S-1-5-32-544'
    if ($isAdmin) {
        . $psBlock
    } else {
        $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($psBlock.ToString()))
        Start-Process powershell -ArgumentList "-nop -enc $encoded" -Verb RunAs -Wait -ErrorAction SilentlyContinue
    }

    $uninstallResult = if (Test-Path $resultPath) {
        Get-Content $resultPath -Raw | ConvertFrom-Json
    } else { $null }
    Remove-Item -Path $resultPath -Force -ErrorAction SilentlyContinue

    # ── Styled result dialog ──────────────────────────────────────────────────
    $sysRemoved = if ($uninstallResult) { $uninstallResult.SysRemoved } else { -not (Test-Path "C:\Windows\System32\drivers\hidusbf.sys") }
    $foldersRemoved = if ($uninstallResult) { $uninstallResult.FoldersRemoved } else { 0 }

    $resultLines = @(
        "## Uninstall summary:",
        "  [+]  Driver files removed",
        "  [+]  hidusbf.dll removed (System32 / SysWOW64)",
        "  [+]  $foldersRemoved HIDUSBF folder(s) removed",
        ""
    )
    if ($sysRemoved) {
        $resultLines += "  hidusbf.sys: REMOVED"
    } else {
        $resultLines += "  hidusbf.sys: STILL PRESENT (restart required)"
    }
    $resultLines += @("", "  Restart your computer whenever you're ready", "  to finish removing HIDUSBF.")

    Show-GameBarDialog `
        -Title      "HIDUSBF UNINSTALLED" `
        -Subtitle   "Restart when convenient to finish removal." `
        -Lines      $resultLines `
        -ResultOnly $true | Out-Null
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
            # File doesn't exist yet - create it fresh with defaults + comments
            $lines = @(
                "MusicEnabled=$val",
                "MusicVolume=$vol",
                "",
                "# MusicEnabled: True or False",
                "# MusicVolume:  0 to 100"
            )
            Set-Content -Path $script:SettingsPath -Value $lines -Encoding UTF8
        } else {
            # File exists - surgically update only MusicEnabled and MusicVolume lines.
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

function Get-IniToolVer {
    # Returns @{ Tag = "v1.2.0"; Size = 512000 } for a given key prefix (e.g. "DeepPoll")
    param([string]$Prefix)
    $tag = ""; $size = -1L
    try {
        if (Test-Path $script:SettingsPath) {
            Get-Content $script:SettingsPath | ForEach-Object {
                if ($_ -match "^\s*${Prefix}Ver\s*=\s*(.+)")   { $tag  = $Matches[1].Trim() }
                if ($_ -match "^\s*${Prefix}Size\s*=\s*(\d+)") { $size = [long]$Matches[1] }
            }
        }
    } catch {}
    return @{ Tag = $tag; Size = $size }
}

function Save-IniToolVer {
    # Surgically writes <Prefix>Ver and <Prefix>Size into Settings.ini
    param([string]$Prefix, [string]$Tag, [long]$Size)
    try {
        if (-not (Test-Path $script:SettingsPath)) { Save-Settings }
        $raw       = Get-Content $script:SettingsPath
        $wroteTag  = $false
        $wroteSize = $false
        $out = $raw | ForEach-Object {
            if ($_ -match "^\s*${Prefix}Ver\s*=")  { $wroteTag  = $true; "${Prefix}Ver=$Tag"   }
            elseif ($_ -match "^\s*${Prefix}Size\s*=") { $wroteSize = $true; "${Prefix}Size=$Size" }
            else { $_ }
        }
        if (-not $wroteTag)  { $out += "${Prefix}Ver=$Tag"   }
        if (-not $wroteSize) { $out += "${Prefix}Size=$Size" }
        Set-Content -Path $script:SettingsPath -Value $out -Encoding UTF8
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

# 3. Download music file if not cached
Get-MusicFile

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
# PAGE NAVIGATION HELPERS - swap tiles in-place on the MAIN window
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
    $dlg.TopMost         = $false

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
    $dlg.TopMost         = $false

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
            @{Name="Auto Calibration";                    URL="AUTO_CALIBRATE";        Desc="Edit stick calibration JSON values (xMin/yMin/xMax/yMax)"},
            @{Name="Beta Portal";                         URL="BETA_PORTAL";           Desc="Enroll your board in the beta program and receive early firmware updates"},
            @{Name="DeepPoll";                            URL="DEEPPOLL";              Desc="Measures USB polling rate with microsecond precision using kernel-level ETW tracing"; Admin="Requires Admin Permissions"},
            @{Name="DeepLog";                             URL="DEEPLOG";               Desc="Logs USB input events with microsecond timestamps for latency analysis"; Admin="Requires Admin Permissions"},
            @{Name="HID Telemetry Diagnostic Tool";       URL="CONTROLLER_TELEMETRY";  Desc="Advanced HID Telemetry Diagnostic Tool By @TheQuest818"},
            @{Name="Gamebar Notification Removal";        URL="GAMEBAR_FIX";           Desc="Removes GameBar Notification with 8K Polling Affected Controllers"; Admin="Requires Admin Permissions"},
            @{Name="Uninstall HIDUSBF";                   URL="UNINSTALL_HIDUSBF";     Desc="Completely removes the HIDUSBF driver and related files from your system"; Admin="Requires Admin Permissions"},
            @{Name="Join Marius Discord";                 URL="DISCORD";               Desc="Join the Marius community on Discord"},
            @{Name="Troubleshooting";                     URL="TROUBLESHOOTING";       Desc="Common issues and solutions for Marius controllers"},
            @{Name="FR33THY Ultimate Optimization Guide"; URL="FR33THY_GUIDE";         Desc="Optimise and Debloat Windows"},
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
            $tbN=$tbItem.Name; $tbD=$tbItem.Desc; $tbU=$tbItem.URL; $tbA=if($tbItem.Admin){$tbItem.Admin}else{""}
            $tbTile.Add_Paint({
                param($s,$e); $g=$e.Graphics
                $g.TextRenderingHint=[System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
                $tf=New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)
                $df=New-Object System.Drawing.Font("Segoe UI",8)
                $wb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
                $rb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Red)
                $yb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Yellow)
                $g.DrawString($tbN,$tf,$wb,20,12)
                $g.DrawString($tbD,$df,$rb,20,35)
                if ($tbA -ne "") {
                    $descW = [int]$g.MeasureString($tbD,$df).Width
                    $g.DrawString("  |  $tbA",$df,$yb,(20+$descW),35)
                }
                $wb.Dispose();$rb.Dispose();$yb.Dispose();$tf.Dispose();$df.Dispose()
            }.GetNewClosure())
            $tbTile.Add_Click({
                $tu=$this.Tag
                if ($tu -eq "BACK")                { Show-MainPage; return }
                if ($tu -eq "USB_ANALYZER")        { Show-UsbAnalyzer; return }
                if ($tu -eq "GAMEBAR_FIX")         { Invoke-GameBarNotificationFix; return }
                if ($tu -eq "UNINSTALL_HIDUSBF")   { Invoke-UninstallHIDUSBF; return }
                if ($tu -eq "CONTROLLER_TELEMETRY") { Install-ControllerTelemetry; return }
                if ($tu -eq "TROUBLESHOOTING")     { Show-TroubleshootingDialog; return }
                if ($tu -eq "DEEPPOLL") { Show-DeepPoll; return }
                if ($tu -eq "DEEPLOG")  { Show-DeepLog; return }
                if ($tu -eq "AUTO_CALIBRATE") { Show-AutoCalibrate; return }
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
    @{Name="USB Latency Analyzer"; URL="USB_ANALYZER";                                                Desc="Count chips between your device and CPU. More chips = more latency"},
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

# ── SETTINGS FILE WATCHER - hot-reload when Settings.ini is edited externally ─
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

# Credits - full panel width, MiddleCenter, sent to back so controls above it get clicks
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

# ── Speaker toggle - GDI+ painted, no Unicode dependency ────────────────────
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
