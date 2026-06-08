#requires -Version 5.1
<#
.SYNOPSIS
    MARIUS Board Configurator Lite Edition

.DESCRIPTION
    Streamlined launcher for core MARIUS tools including USB Latency Analyzer.
    No additional files needed - everything is contained in this single script.
    Features desktop shortcut installer and embedded MBC icon.

.NOTES
    Created by: @mariusheier (Original Creator)
    Script by: @EODBruz (PowerShell Development)
    Version: 1.0.0 Lite

.CREDITS
    App Creator: @mariusheier
    Script Developer: @EODBruz
    Script Version 1.0.0 Lite

.SECURITY WARNING
    If you downloaded this script and get a security warning when running:
    - Press "R" to Run once (safe - this is a trusted script)
    - OR right-click file -> Properties -> Check "Unblock" -> Apply
#>

# ============================================================================
# INSTALL PATHS
# ============================================================================
$script:CurrentVersion = "Lite Edition"
$script:InstallDir     = "$env:APPDATA\MARIUS"
$script:InstallPath    = "$script:InstallDir\MARIUSLite.ps1"


# ============================================================================
# EMBEDDED MBC LITE ICON (Red + Black, Base64 encoded ICO)
# ============================================================================

$script:MbcIconBase64 = "AAABAAMAEBAAAAEAIADmAAAANgAAACAgAAABACAAugEAABwBAAAwMAAAAQAgAKECAADWAgAAiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAArUlEQVR4nNXTPYoCQRCG4acHkRUMzRVvsMnGhsZ6CTMPYigewNhATPcMi2dQMDA1MZJpkwqGQZBxE/2g6O+toKr6L6Uk9zOFZipxTBiQ84sxIBdNO1dVaD75wyKfXqAMM8U6fIp1gS3mwStscAluRYAR/nDCJHJtdNEL/sWu0v1W3cIZS8wwjtwBP9gHf9XGb8HwyWO51nhf8UPy00Ps1Pi7xm90ja+oRPrvd74DEDhVItXWHRwAAAAASUVORK5CYIKJUE5HDQoaCgAAAA1JSERSAAAAIAAAACAIBgAAAHN6evQAAAGBSURBVHic7ZctTwQxEIafdhcQXFAoEo5znCBB4TEIQoJCgUEeEsOPQCBPoBEYAuQknhAQkMOQywWDxYEgB+wgOs2V3odjF7GTNJ132s68bTc7UwMIBUoKYAzMC9icgmbAiwHRrUvV6bm2qjt5sZDfzkOxUV+YlARKAiWBksD/I3AFGCCJRoy2e8UtxROJc2KAs8jXmtqtdf1OMJZpn8YEKrogy+AOWAHOPVsLFV05q/jz2+ENYIt+bl8G2h77aENk4AR6uOBHwLbaGkBT7T21fSl+VNwFdgM/beB4dNzRycgfyT4wA6wDdWBP7ZMBAYBNYAHoAEuBn8TC6hgCoUgtyNM3IMY4/Ulz9ruOGYM8q34dzBOQrs71GJCDMfVALawHQunRr1QWgQtg2jOV/hV8KH5T3Iz8NIBD4DKwtQI9/Cx+nUAnwjHrV9UfFM+BTCVIHeQ2mn8KkqZup4CcDKmIBgjk1UZeQd5SEigJlAQsjE1WfyY+psH90wt7nBoo9nn+A+aiH3bA5GExAAAAAElFTkSuQmCCiVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAACaElEQVR4nO2aO2tUQRTHfzP37sMuxJQ+FgQloCCCnSA2IggSBUutrIKP0m8Q/ADaioWIIFgo9uYLREsxFpoIQoxYaBF1c4/FzN2d3Z2d3btRZhfmD4c9O+cx53/m3rkPrgIEC6WYCYh0dYVDYBaRl4pScFBAx6xmDBTApuquglIKEYFDwKeYlVXAYWAD0/ROw6e98y70EH0mkQjERiIQG4lAbCQCsZEIxEYiEBuJQGxMJYHvwPqYvkECypHVEfbLAZsri4H5Fq3PPHDUiXk5KYE8g2YDMg3X+2yrmEe6OevX8sTWa7ACtIHXwALwDtjvmUtZW6MOT4GfwBpwBngeKlIpBJCWeU7uEUDqNWTB6q7tAEiedW3Lntj+mEcgWg2ONxuI1si8pwaftGxupZCR54AIPAG0gnPO+Gfg3i5csv+HJfri6C+AQgZXa+cXFIXpfGWMWgHLQZYd/Yaj37T6bU9snnVzlDLX5/fedhLP/P9kBUo8sL8ngIcaLtj/G4EYETiFOX+WTLP4kcFdx2cH9vZqbdwVKI/7TPeOnQ+sAIGcW56xt/9zBQAeA7uF2U1K1CdoWi03u1KJTBtZmiBXeBvNjZQ4i6H+1fFpWr9+InluttFnztg1W+yfNlx1xtcL05iPwDFg07HdAu6EiqxyCPnkpPW5MiTWJyuePB9Aarnf/37gEMoJYDtktHgDfGPw4rSNeXOsHdkXyHME+N02+itgCzgOnB4xf5CA74o5rt+4sT5crOA7lTdzVZAIxEYiEBuJQGwkArGRCMRGh0ARs4qKcGvtfCsxs58asLcn0ujouZ2exc9t/gK6pH34fO7XcQAAAABJRU5ErkJggg=="

function Install-MbcIcon {
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }
        $iconPath = "$script:InstallDir\MBCLite.ico"
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
            'MARIUS Board Configurator Lite.lnk'
        )
        if ((Test-Path $shortcutPath) -and (Test-Path $script:InstallPath)) { return }  # Valid - don't recreate

        $wsh = New-Object -ComObject WScript.Shell
        $sc  = $wsh.CreateShortcut($shortcutPath)
        $sc.TargetPath       = "powershell.exe"
        $sc.Arguments        = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script:InstallPath`""
        $sc.WorkingDirectory = $script:InstallDir
        $sc.Description      = "MARIUS Board Configurator Lite v$script:CurrentVersion"
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
        $shortcutPath = [System.IO.Path]::Combine($startMenuDir, 'MARIUS Board Configurator Lite.lnk')
        if ((Test-Path $shortcutPath) -and (Test-Path $script:InstallPath)) { return }  # Valid - don't recreate

        $wsh = New-Object -ComObject WScript.Shell
        $sc  = $wsh.CreateShortcut($shortcutPath)
        $sc.TargetPath       = "powershell.exe"
        $sc.Arguments        = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script:InstallPath`""
        $sc.WorkingDirectory = $script:InstallDir
        $sc.Description      = "MARIUS Board Configurator Lite v$script:CurrentVersion"
        if ($IconPath -and (Test-Path $IconPath)) {
            $sc.IconLocation = "$IconPath,0"
        }
        $sc.WindowStyle = 7  # Minimized - hides the PowerShell flash
        $sc.Save()
    } catch {}
}

function Invoke-SelfInstall {
    # Install script to %APPDATA%\MARIUS if needed
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }
        $runningPath = $MyInvocation.ScriptName
        if ($runningPath -and ($runningPath -ne $script:InstallPath) -and (Test-Path $runningPath)) {
            # Running from a downloaded file - copy it directly
            $sourceSize = (Get-Item $runningPath).Length
            if ($sourceSize -gt 10000) {
                Copy-Item -Path $runningPath -Destination $script:InstallPath -Force -ErrorAction SilentlyContinue
            }
        } elseif (-not (Test-Path $script:InstallPath)) {
            # Running via iex pipe - download from GitHub so the shortcut has a real file to point to
            try {
                $wc = New-Object System.Net.WebClient
                $wc.DownloadFile("https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUSLite.ps1", $script:InstallPath)
            } catch {}
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
    # Layout constants matching main window
    $aW = 620; $aStartX = 28; $aTileW = 556; $aTileH = 42; $aSpacing = 3

    $analyzerForm = New-Object System.Windows.Forms.Form
    $analyzerForm.Text = "USB LATENCY ANALYZER"
    $analyzerForm.Width = $aW
    $analyzerForm.StartPosition = "CenterScreen"
    $analyzerForm.FormBorderStyle = "None"
    $analyzerForm.BackColor = [System.Drawing.Color]::Red
    $analyzerForm.Padding = New-Object System.Windows.Forms.Padding(2)

    $mainPanel = New-Object System.Windows.Forms.Panel
    $mainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $mainPanel.BackColor = [System.Drawing.Color]::Black

    # --- Banner (same as main window) ---
    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size($aW, 36)
    $headerPanel.BackColor = [System.Drawing.Color]::Black
    $headerPanel.Add_MouseDown({ $script:dragging=$true; $script:dragCursorX=[System.Windows.Forms.Cursor]::Position.X-$analyzerForm.Left; $script:dragCursorY=[System.Windows.Forms.Cursor]::Position.Y-$analyzerForm.Top })
    $headerPanel.Add_MouseMove({ if($script:dragging){ $analyzerForm.Left=[System.Windows.Forms.Cursor]::Position.X-$script:dragCursorX; $analyzerForm.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:dragCursorY } })
    $headerPanel.Add_MouseUp({ $script:dragging=$false })

    $aTitlePicBox = New-Object System.Windows.Forms.PictureBox
    $aTitlePicBox.Location = New-Object System.Drawing.Point(0, 0)
    $aTitlePicBox.Size = New-Object System.Drawing.Size($aW, 36)
    $aTitlePicBox.BackColor = [System.Drawing.Color]::Black
    $aTitlePicBox.Add_MouseDown({ $script:dragging=$true; $script:dragCursorX=[System.Windows.Forms.Cursor]::Position.X-$analyzerForm.Left; $script:dragCursorY=[System.Windows.Forms.Cursor]::Position.Y-$analyzerForm.Top })
    $aTitlePicBox.Add_MouseMove({ if($script:dragging){ $analyzerForm.Left=[System.Windows.Forms.Cursor]::Position.X-$script:dragCursorX; $analyzerForm.Top=[System.Windows.Forms.Cursor]::Position.Y-$script:dragCursorY } })
    $aTitlePicBox.Add_MouseUp({ $script:dragging=$false })

    # Reuse cached banner if already downloaded, else paint fallback
    if ($script:BannerImg -ne $null) {
        $aTitlePicBox.Add_Paint({
            param($sender, $e)
            $g = $e.Graphics
            $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $g.Clear([System.Drawing.Color]::Black)
            $srcRatio = $script:BannerImg.Width / $script:BannerImg.Height
            $destH = $sender.Height; $destW = [int]($destH * $srcRatio)
            if ($destW -gt $sender.Width) { $destW = $sender.Width; $destH = [int]($destW / $srcRatio) }
            $x = [int](($sender.Width - $destW) / 2); $y = [int](($sender.Height - $destH) / 2)
            $g.DrawImage($script:BannerImg, (New-Object System.Drawing.Rectangle($x, $y, $destW, $destH)))
        })
    } else {
        $aTitlePicBox.Add_Paint({
            param($sender, $e)
            $g = $e.Graphics; $g.Clear([System.Drawing.Color]::Black)
            $f = New-Object System.Drawing.Font("Impact", 14, [System.Drawing.FontStyle]::Italic)
            $b = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Red)
            $sf = New-Object System.Drawing.StringFormat
            $sf.Alignment = [System.Drawing.StringAlignment]::Center
            $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
            $g.DrawString("MARIUS-BOARD-CONFIGURATOR", $f, $b, (New-Object System.Drawing.RectangleF(0,0,$sender.Width,$sender.Height)), $sf)
            $f.Dispose(); $b.Dispose()
        })
    }
    $headerPanel.Controls.Add($aTitlePicBox)
    $mainPanel.Controls.Add($headerPanel)

    # --- Legend tile (same style as menu tiles) ---
    $legendY = 44
    $legendTile = New-Object System.Windows.Forms.Panel
    $legendTile.Location = New-Object System.Drawing.Point($aStartX, $legendY)
    $legendTile.Size = New-Object System.Drawing.Size($aTileW, 68)
    $legendTile.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $legendTile.BorderStyle = "None"

    $legendBox = New-Object System.Windows.Forms.RichTextBox
    $legendBox.Location = New-Object System.Drawing.Point(0, 0)
    $legendBox.Size = New-Object System.Drawing.Size($aTileW, 68)
    $legendBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $legendBox.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $legendBox.BorderStyle = "None"
    $legendBox.ReadOnly = $true
    $legendBox.Cursor = [System.Windows.Forms.Cursors]::Arrow
    $legendBox.SelectionColor = [System.Drawing.Color]::FromArgb(0, 255, 135)
    $legendBox.AppendText([char]0x25cf + " 0 CHIPS - Direct to CPU (BEST - Lowest Latency)`n")
    $legendBox.SelectionColor = [System.Drawing.Color]::FromArgb(255, 179, 71)
    $legendBox.AppendText([char]0x25cf + " 1 CHIP - Through Chipset (GOOD - Normal Latency)`n")
    $legendBox.SelectionColor = [System.Drawing.Color]::FromArgb(255, 107, 107)
    $legendBox.AppendText([char]0x25cf + " 2+ CHIPS - Through USB Hub (AVOID - Highest Latency)")
    $legendTile.Controls.Add($legendBox)
    $mainPanel.Controls.Add($legendTile)

    # --- Results box (tile-bordered) ---
    $resultsY = $legendY + 68 + $aSpacing
    $resultsH = 280
    $resultsTile = New-Object System.Windows.Forms.Panel
    $resultsTile.Location = New-Object System.Drawing.Point($aStartX, $resultsY)
    $resultsTile.Size = New-Object System.Drawing.Size($aTileW, $resultsH)
    $resultsTile.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $resultsTile.BorderStyle = "None"

    $results = New-Object System.Windows.Forms.RichTextBox
    $results.Location = New-Object System.Drawing.Point(1, 1)
    $results.Size = New-Object System.Drawing.Size(($aTileW - 2), ($resultsH - 2))
    $results.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $results.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
    $results.Font = New-Object System.Drawing.Font("Consolas", 9)
    $results.ReadOnly = $true
    $results.BorderStyle = "None"
    $results.ScrollBars = "Vertical"
    $resultsTile.Controls.Add($results)
    $mainPanel.Controls.Add($resultsTile)

    # --- Scan button (full tile width) ---
    $scanY = $resultsY + $resultsH + $aSpacing
    $scanBtn = New-Object System.Windows.Forms.Button
    $scanBtn.Location = New-Object System.Drawing.Point($aStartX, $scanY)
    $scanBtn.Size = New-Object System.Drawing.Size($aTileW, $aTileH)
    $scanBtn.FlatStyle = "Flat"
    $scanBtn.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $scanBtn.ForeColor = [System.Drawing.Color]::White
    $scanBtn.Text = ""
    $scanBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $scanBtn.FlatAppearance.BorderSize = 1
    $scanBtn.FlatAppearance.BorderColor = [System.Drawing.Color]::Red
    $scanBtn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $scanBtn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $scanBtn.Add_MouseEnter({ $this.BackColor=[System.Drawing.Color]::FromArgb(25,25,25); $this.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(220,30,30); $this.FlatAppearance.BorderSize=2 })
    $scanBtn.Add_MouseLeave({ $this.BackColor=[System.Drawing.Color]::FromArgb(15,15,15); $this.FlatAppearance.BorderColor=[System.Drawing.Color]::Red; $this.FlatAppearance.BorderSize=1 })
    $scanBtn.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics; $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
        $tf = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $df = New-Object System.Drawing.Font("Segoe UI", 8)
        $wb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $rb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Red)
        $g.DrawString("Scan USB Devices", $tf, $wb, 20, 6)
        $g.DrawString("Analyze all connected USB input devices", $df, $rb, 20, 26)
        $wb.Dispose(); $rb.Dispose(); $tf.Dispose(); $df.Dispose()
    })

    # --- Exit button (full tile width) ---
    $exitY = $scanY + $aTileH + $aSpacing
    $exitBtn = New-Object System.Windows.Forms.Button
    $exitBtn.Location = New-Object System.Drawing.Point($aStartX, $exitY)
    $exitBtn.Size = New-Object System.Drawing.Size($aTileW, $aTileH)
    $exitBtn.FlatStyle = "Flat"
    $exitBtn.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    $exitBtn.ForeColor = [System.Drawing.Color]::White
    $exitBtn.Text = ""
    $exitBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $exitBtn.FlatAppearance.BorderSize = 1
    $exitBtn.FlatAppearance.BorderColor = [System.Drawing.Color]::Red
    $exitBtn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $exitBtn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $exitBtn.Add_MouseEnter({ $this.BackColor=[System.Drawing.Color]::FromArgb(25,25,25); $this.FlatAppearance.BorderColor=[System.Drawing.Color]::FromArgb(220,30,30); $this.FlatAppearance.BorderSize=2 })
    $exitBtn.Add_MouseLeave({ $this.BackColor=[System.Drawing.Color]::FromArgb(15,15,15); $this.FlatAppearance.BorderColor=[System.Drawing.Color]::Red; $this.FlatAppearance.BorderSize=1 })
    $exitBtn.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics; $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
        $tf = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $df = New-Object System.Drawing.Font("Segoe UI", 8)
        $wb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $rb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Red)
        $g.DrawString("Exit", $tf, $wb, 20, 6)
        $g.DrawString("Close this application", $df, $rb, 20, 26)
        $wb.Dispose(); $rb.Dispose(); $tf.Dispose(); $df.Dispose()
    })
    $exitBtn.Add_Click({ $analyzerForm.Close() })

    $scanBtn.Add_Click({
        $results.Clear()
        $results.SelectionColor = [System.Drawing.Color]::Red
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

    # Credits tight below exit button
    $creditsY = $exitY + $aTileH + $aSpacing
    $aCredits = New-Object System.Windows.Forms.Label
    $aCredits.Location = New-Object System.Drawing.Point(5, $creditsY)
    $aCredits.Size = New-Object System.Drawing.Size(($aW - 10), 26)
    $aCredits.Text = "Created by: @mariusheier  |  Script by: @EODBruz"
    $aCredits.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $aCredits.ForeColor = [System.Drawing.Color]::Red
    $aCredits.TextAlign = "MiddleCenter"
    $aCredits.BackColor = [System.Drawing.Color]::Black
    $mainPanel.Controls.Add($aCredits)

    # Size form to fit content exactly
    $analyzerForm.Height = $creditsY + 26 + 4  # content + 2px border top/bottom

    $analyzerForm.Controls.Add($mainPanel)

    $analyzerForm.Add_KeyDown({
        param($sender, $e)
        if ($e.KeyCode -eq "Escape") { $analyzerForm.Close() }
    })
    $analyzerForm.Add_Shown({ $analyzerForm.Activate() })
    $analyzerForm.Add_FormClosed({})
    [void]$analyzerForm.ShowDialog()
}

# ============================================================================
# STARTUP: INSTALL, ICON, SHORTCUT
# ============================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 1. Install script to %APPDATA%\MARIUS if needed
Invoke-SelfInstall

# 2. Extract MBC Lite icon and create Desktop shortcut (first run only)
$script:IconPath = Install-MbcIcon
Install-DesktopShortcut -IconPath $script:IconPath
Install-StartMenuShortcut -IconPath $script:IconPath

# ============================================================================
# MAIN BROWSER WINDOW
# ============================================================================

$script:form = New-Object System.Windows.Forms.Form
$form = $script:form
$form.Text = "MARIUS BOARD CONFIGURATOR LITE"
$form.Width = 620
$form.Height = 504
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::Red
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
$mainPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
$mainPanel.BackColor = [System.Drawing.Color]::Black

$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.Size = New-Object System.Drawing.Size(616, 36)
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
$titlePicBox.Size = New-Object System.Drawing.Size(616, 36)
$titlePicBox.BackColor = [System.Drawing.Color]::Black

$script:BannerImg = $null
try {
    $wc = New-Object System.Net.WebClient
    $imgBytes = $wc.DownloadData("https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/lite.png")
    $ms = New-Object System.IO.MemoryStream($imgBytes, 0, $imgBytes.Length)
    $script:BannerImg = [System.Drawing.Image]::FromStream($ms)
} catch {}

$titlePicBox.Add_Paint({
    param($sender, $e)
    $g = $e.Graphics
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.Clear([System.Drawing.Color]::Black)
    if ($script:BannerImg -ne $null) {
        # Maintain aspect ratio, fit within panel
        $srcRatio = $script:BannerImg.Width / $script:BannerImg.Height
        $destH = $sender.Height
        $destW = [int]($destH * $srcRatio)
        if ($destW -gt $sender.Width) {
            $destW = $sender.Width
            $destH = [int]($destW / $srcRatio)
        }
        $x = [int](($sender.Width  - $destW) / 2)
        $y = [int](($sender.Height - $destH) / 2)
        $destRect = New-Object System.Drawing.Rectangle($x, $y, $destW, $destH)
        $g.DrawImage($script:BannerImg, $destRect)
    }
})

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
# MAIN MENU TILE COLLECTION
# ============================================================================

# Collect main-menu tile buttons after they are built (populated below)
$script:mainTiles = [System.Collections.Generic.List[System.Windows.Forms.Control]]::new()

function Show-AppInfoDialog {
    $W = 660; $H = 720
    $dlg = New-Object System.Windows.Forms.Form
    $dlg.Text            = ""
    $dlg.Width           = $W
    $dlg.Height          = $H
    $dlg.StartPosition   = "CenterScreen"
    $dlg.FormBorderStyle = "None"
    $dlg.BackColor       = [System.Drawing.Color]::Red
    $dlg.TopMost         = $true

    $script:aiDrag = $false; $script:aiDX = 0; $script:aiDY = 0

    $inner = New-Object System.Windows.Forms.Panel
    $inner.Location  = New-Object System.Drawing.Point(3, 3)
    $inner.Size      = New-Object System.Drawing.Size(($W - 6), ($H - 6))
    $inner.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
    $dlg.Controls.Add($inner)

    # ── Static red border ─────────────────────────────────────────────────
    $dlg.BackColor = [System.Drawing.Color]::Red
    $dlg.Add_FormClosed({})

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
        $tb=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Red)
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
    $badgePanel.BackColor = [System.Drawing.Color]::FromArgb(20, 0, 0)
    $inner.Controls.Add($badgePanel)

    $badgeLabel = New-Object System.Windows.Forms.Label
    $badgeLabel.Location  = New-Object System.Drawing.Point(0, 0)
    $badgeLabel.Size      = New-Object System.Drawing.Size(($W - 46), 36)
    $badgeLabel.Text      = "  OFFICIAL APPLICATION  |  Lite Edition by @EODBruz"
    $badgeLabel.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $badgeLabel.ForeColor = [System.Drawing.Color]::Red
    $badgeLabel.BackColor = [System.Drawing.Color]::Transparent
    $badgeLabel.TextAlign = "MiddleLeft"
    $badgePanel.Controls.Add($badgeLabel)

    # ── App info grid ────────────────────────────────────────────────────────
    $infoLines = @(
        @{Text="Application:";   Value="MARIUS Board Configurator Lite Edition"},
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
        $lblKey.ForeColor = [System.Drawing.Color]::Red
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
    $licHeader.ForeColor = [System.Drawing.Color]::Red
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
MARIUS BOARD CONFIGURATOR LITE EDITION -- END USER LICENSE AGREEMENT
=====================================================================
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
    $rgbOkPanel.BackColor = [System.Drawing.Color]::Red
    $inner.Controls.Add($rgbOkPanel)

    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Location  = New-Object System.Drawing.Point(2, 2)
    $btnOk.Size      = New-Object System.Drawing.Size($okBtnW, $okBtnH)
    $btnOk.Text      = "OK"
    $btnOk.FlatStyle = "Flat"
    $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
    $btnOk.ForeColor = [System.Drawing.Color]::Red
    $btnOk.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btnOk.FlatAppearance.BorderSize = 0
    $btnOk.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btnOk.Add_Click({ $dlg.Close() })
    $btnOk.Add_MouseEnter({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(40,10,10) })
    $btnOk.Add_MouseLeave({ $btnOk.BackColor = [System.Drawing.Color]::FromArgb(20,20,20) })
    $rgbOkPanel.Controls.Add($btnOk)

    $dlg.Add_KeyDown({ param($s,$e); if($e.KeyCode -eq "Escape"){ $dlg.Close() } })
    [void]$dlg.ShowDialog()
}


# ============================================================================
# MAIN MENU TILES
# (Setup Controller, Joystick Tester, Polling Rate Checker, Firmware Updater,
#  USB Latency Analyzer, App Information, Exit)
# ============================================================================
$websites = @(
    @{Name="Setup Controller";         URL="https://devsetup.mariusheier.com/";                          Desc="Calibrate and configure your controller settings and polling rate settings"},
    @{Name="Joystick Tester";          URL="https://hardwaretester.com/gamepad";                         Desc="Test your joystick inputs, buttons, and analog stick precision"},
    @{Name="Polling Rate Checker";     URL="https://tools.mariusheier.com/poll_checker.html";            Desc="Test and verify your controller's polling rate"},
    @{Name="Firmware Updater";         URL="https://update.mariusheier.com/";                            Desc="Update Your Controller to Latest Versions Or Beta Versions"},
    @{Name="USB Latency Analyzer";     URL="USB_ANALYZER";                                                Desc="Count chips between your device and CPU. More chips = more latency"},
    @{Name="App Information";          URL="APP_INFO";                                                   Desc="View information about this application"},
    @{Name="Exit";                     URL="EXIT";                                                       Desc="Close this application"}
)

$tileWidth = 556
$tileHeight = 58
$spacing = 3
$startX = 28
$startY = 44

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
    $tile.FlatAppearance.BorderColor = [System.Drawing.Color]::Red
    $tile.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $tile.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $tile.Tag = $site.URL
    
    # Add hover glow effect
    $tile.Add_MouseEnter({
        $this.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(220, 30, 30)
        $this.FlatAppearance.BorderSize = 2
    })
    
    $tile.Add_MouseLeave({
        $this.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::Red
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
        
        if ($targetUrl -eq "USB_ANALYZER") {
            Show-UsbAnalyzer
            return
        }
        
        if ($targetUrl -eq "APP_INFO") {
            Show-AppInfoDialog
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
# STATIC YELLOW BORDER (main window)
# ============================================================================

$script:rgbHue = 0  # kept for compatibility with any sub-dialog references
$script:form.BackColor = [System.Drawing.Color]::Red
foreach ($ctrl in $script:mainPanel.Controls) {
    if ($ctrl -is [System.Windows.Forms.Button]) {
        $ctrl.FlatAppearance.BorderColor = [System.Drawing.Color]::Red
    }
}

$versionLabel = New-Object System.Windows.Forms.Label
$versionLabel.Location = New-Object System.Drawing.Point(5, 474)
$versionLabel.Size = New-Object System.Drawing.Size(90, 26)
$versionLabel.Text = "Lite Edition"
$versionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$versionLabel.ForeColor = [System.Drawing.Color]::Red
$versionLabel.TextAlign = "MiddleLeft"
$versionLabel.BackColor = [System.Drawing.Color]::Black
$mainPanel.Controls.Add($versionLabel)

# Credits — full panel width, MiddleCenter, sent to back so controls above it get clicks
$creditsLabel = New-Object System.Windows.Forms.Label
$creditsLabel.Location = New-Object System.Drawing.Point(14, 474)
$creditsLabel.Size = New-Object System.Drawing.Size(580, 26)
$creditsLabel.Text = "Created by: @mariusheier  |  Script by: @EODBruz"
$creditsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$creditsLabel.ForeColor = [System.Drawing.Color]::Red
$creditsLabel.TextAlign = "MiddleCenter"
$creditsLabel.BackColor = [System.Drawing.Color]::Black
$mainPanel.Controls.Add($creditsLabel)
$creditsLabel.SendToBack()
$versionLabel.BringToFront()

$form.Controls.Add($mainPanel)

$form.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq "Escape") {
        $form.Close()
    }
})

$form.Add_Shown({
    $form.Activate()
})
$form.Add_FormClosing({})
$form.Add_FormClosed({
    [System.Diagnostics.Process]::GetCurrentProcess().Kill()
})
[void]$form.ShowDialog()
