#requires -Version 5.1
<#
.SYNOPSIS
    MARIUS Board Configurator with Built-in USB Latency Analyzer V3.1

.DESCRIPTION
    All-in-one launcher for MARIUS tools including the built-in USB Latency Analyzer.
    No additional files needed - everything is contained in this single script.
    Features auto-updater, desktop shortcut installer, and embedded MBC icon.

.NOTES
    Created by: @mariusheier (Original Creator)
    Script by: @EODBruz (PowerShell Development)
    Version: 4.0
    
.CREDITS
    App Creator: @mariusheier
    Script Developer: @EODBruz
    
.INSTALLATION
    Quick Install (One-Liner):
    iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
    
.SECURITY WARNING
    If you downloaded this script and get a security warning when running:
    - Press "R" to Run once (safe - this is a trusted script)
    - OR right-click file -> Properties -> Check "Unblock" -> Apply
    - OR use the one-liner above (no warning!)
#>

param(
    [switch]$NoUpdate  # Used internally after auto-update to prevent recheck loop
)

# ============================================================================
# VERSION & AUTO-UPDATE SYSTEM
# ============================================================================
$script:CurrentVersion = "4.0"
$script:InstallDir     = "$env:APPDATA\MARIUS"
$script:InstallPath    = "$script:InstallDir\MARIUS.ps1"
$script:VersionUrl     = "https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/version.txt"
$script:ScriptUrl      = "https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1"

# ============================================================================
# EMBEDDED MBC ICON (Yellow + Black, Base64 encoded ICO)
# ============================================================================

$script:MbcIconBase64 = "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"

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
    # Copy script to %APPDATA%\MARIUS if not already running from there
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }
        $runningPath = $MyInvocation.ScriptName
        if ($runningPath -and ($runningPath -ne $script:InstallPath) -and (Test-Path $runningPath)) {
            Copy-Item -Path $runningPath -Destination $script:InstallPath -Force -ErrorAction SilentlyContinue
        } elseif (-not (Test-Path $script:InstallPath)) {
            $content = (New-Object System.Net.WebClient).DownloadString($script:ScriptUrl)
            [System.IO.File]::WriteAllText($script:InstallPath, $content, [System.Text.Encoding]::UTF8)
        }
    } catch {}
}

function Check-ForUpdates {
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Cache-Control", "no-cache")
        $latestVersion = $wc.DownloadString($script:VersionUrl).Trim()

        if ([version]$latestVersion -gt [version]$script:CurrentVersion) {

            $updateForm = New-Object System.Windows.Forms.Form
            $updateForm.Text            = "Update Available"
            $updateForm.Width           = 460
            $updateForm.Height          = 220
            $updateForm.StartPosition   = "CenterScreen"
            $updateForm.FormBorderStyle = "None"
            $updateForm.BackColor       = [System.Drawing.Color]::Yellow
            $updateForm.Padding         = New-Object System.Windows.Forms.Padding(2)
            $updateForm.TopMost         = $true

            $upanel = New-Object System.Windows.Forms.Panel
            $upanel.Location  = New-Object System.Drawing.Point(2, 2)
            $upanel.Size      = New-Object System.Drawing.Size(456, 216)
            $upanel.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

            # Title label
            $lblTitle = New-Object System.Windows.Forms.Label
            $lblTitle.Location  = New-Object System.Drawing.Point(0, 18)
            $lblTitle.Size      = New-Object System.Drawing.Size(456, 30)
            $lblTitle.Text      = "Update Available!"
            $lblTitle.Font      = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
            $lblTitle.ForeColor = [System.Drawing.Color]::Yellow
            $lblTitle.TextAlign = "MiddleCenter"

            # Version arrow label
            $lblVersion = New-Object System.Windows.Forms.Label
            $lblVersion.Location  = New-Object System.Drawing.Point(0, 52)
            $lblVersion.Size      = New-Object System.Drawing.Size(456, 28)
            $lblVersion.Text      = "v$script:CurrentVersion   >>>   v$latestVersion"
            $lblVersion.Font      = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
            $lblVersion.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
            $lblVersion.TextAlign = "MiddleCenter"

            # Subtitle label
            $subLbl = New-Object System.Windows.Forms.Label
            $subLbl.Location  = New-Object System.Drawing.Point(0, 86)
            $subLbl.Size      = New-Object System.Drawing.Size(456, 22)
            $subLbl.Text      = "Would you like to update now?"
            $subLbl.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
            $subLbl.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
            $subLbl.TextAlign = "MiddleCenter"

            # Update Now button
            $btnUpdate = New-Object System.Windows.Forms.Button
            $btnUpdate.Location  = New-Object System.Drawing.Point(48, 128)
            $btnUpdate.Size      = New-Object System.Drawing.Size(165, 46)
            $btnUpdate.Text      = "Update Now"
            $btnUpdate.FlatStyle = "Flat"
            $btnUpdate.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
            $btnUpdate.ForeColor = [System.Drawing.Color]::Yellow
            $btnUpdate.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
            $btnUpdate.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
            $btnUpdate.FlatAppearance.BorderSize  = 1
            $btnUpdate.Cursor       = [System.Windows.Forms.Cursors]::Hand
            $btnUpdate.DialogResult = [System.Windows.Forms.DialogResult]::Yes

            # Skip button
            $btnSkip = New-Object System.Windows.Forms.Button
            $btnSkip.Location  = New-Object System.Drawing.Point(243, 128)
            $btnSkip.Size      = New-Object System.Drawing.Size(165, 46)
            $btnSkip.Text      = "Skip"
            $btnSkip.FlatStyle = "Flat"
            $btnSkip.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
            $btnSkip.ForeColor = [System.Drawing.Color]::Red
            $btnSkip.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
            $btnSkip.FlatAppearance.BorderColor = [System.Drawing.Color]::Red
            $btnSkip.FlatAppearance.BorderSize  = 1
            $btnSkip.Cursor       = [System.Windows.Forms.Cursors]::Hand
            $btnSkip.DialogResult = [System.Windows.Forms.DialogResult]::No

            $upanel.Controls.AddRange(@($lblTitle, $lblVersion, $subLbl, $btnUpdate, $btnSkip))
            $updateForm.Controls.Add($upanel)
            $updateForm.AcceptButton = $btnUpdate
            $updateForm.CancelButton = $btnSkip

            # RGB animation timer - .GetNewClosure() captures all local controls
            $script:updateRgbHue = 0
            $updateRgbTimer = New-Object System.Windows.Forms.Timer
            $updateRgbTimer.Interval = 20
            $updateRgbTimer.Add_Tick({
                $script:updateRgbHue = ($script:updateRgbHue + 2) % 360
                $h = $script:updateRgbHue / 360.0
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
                $updateForm.BackColor                 = $rgbColor
                $lblTitle.ForeColor                   = $rgbColor
                $lblVersion.ForeColor                 = $rgbColor
                $subLbl.ForeColor                     = $rgbColor
                $btnUpdate.ForeColor                  = $rgbColor
                $btnUpdate.FlatAppearance.BorderColor = $rgbColor
                $btnSkip.ForeColor                    = $rgbColor
                $btnSkip.FlatAppearance.BorderColor   = $rgbColor
            }.GetNewClosure())

            $updateForm.Add_Shown({ $updateRgbTimer.Start() })
            $updateForm.Add_FormClosing({ $updateRgbTimer.Stop(); $updateRgbTimer.Dispose() })

            $result = $updateForm.ShowDialog()
            $updateForm.Dispose()

            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                try {
                    if (-not (Test-Path $script:InstallDir)) {
                        New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
                    }
                    $wc2 = New-Object System.Net.WebClient
                    $newScript = $wc2.DownloadString($script:ScriptUrl)
                    [System.IO.File]::WriteAllText($script:InstallPath, $newScript, [System.Text.Encoding]::UTF8)
                    Start-Sleep -Milliseconds 500
                    Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script:InstallPath`" -NoUpdate"
                    exit
                } catch {
                    [System.Windows.Forms.MessageBox]::Show(
                        "Update failed. Please re-run the one-liner install command.",
                        "Update Error",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    ) | Out-Null
                }
            }
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Update check failed: $_`n`nPlease check your internet connection or re-run the one-liner install command.",
            "Update Check Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        ) | Out-Null
    }
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
    $script:analyzerRgbTimer.Interval = 20

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
    $gbRgbTimer.Interval = 20
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
# STARTUP: INSTALL, ICON, SHORTCUT, UPDATE CHECK
# ============================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 1. Install script to %APPDATA%\MARIUS if needed
Invoke-SelfInstall

# 2. Extract MBC icon and create Desktop shortcut (first run only)
$script:IconPath = Install-MbcIcon
Install-DesktopShortcut -IconPath $script:IconPath
Install-StartMenuShortcut -IconPath $script:IconPath

# 3. Check for updates (skipped if just updated to prevent loop)
if (-not $NoUpdate) {
    Check-ForUpdates
}

# ============================================================================
# MAIN BROWSER WINDOW
# ============================================================================

$script:form = New-Object System.Windows.Forms.Form
$form = $script:form
$form.Text = "MARIUS BOARD CONFIGURATOR"
$form.Width = 854
$form.Height = 793
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
$mainPanel.Size = New-Object System.Drawing.Size(850, 789)
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

$websites = @(
    @{Name="Setup Controller"; URL="https://devsetup.mariusheier.com/"; Desc="Calibrate and configure your controller settings and polling rate settings"},
    @{Name="Joystick Tester"; URL="https://hardwaretester.com/gamepad"; Desc="Test your joystick inputs, buttons, and analog stick precision"},
    @{Name="Polling Rate Checker"; URL="https://tools.mariusheier.com/poll_checker.html"; Desc="Test and verify your controller's polling rate"},
    @{Name="USB Latency Analyzer"; URL="USB_ANALYZER"; Desc="Count chips between your device and CPU. More chips = more latency"},
    @{Name="Firmware Updater"; URL="https://update.mariusheier.com/"; Desc="Update Your Controller to Latest Versions Or Beta Versions"},
    @{Name="Setup Guide By Parasite"; URL="https://x.com/Parasite/status/2033329474922549297"; Desc="Explains How to setup sticks/controller"},
    @{Name="Gamebar Notification Removal"; URL="GAMEBAR_FIX"; Desc="Removes GameBar Notification with 8K Polling Affected Controllers"},
    @{Name="Creator Twitter"; URL="https://x.com/mariusheier"; Desc="Follow for updates, tips, and support"},
    @{Name="Exit"; URL="EXIT"; Desc="Close this application"}
)

$tileWidth = 790
$tileHeight = 65
$spacing = 10
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
        
        if ($targetUrl -eq "USB_ANALYZER") {
            Show-UsbAnalyzer
            return
        }
        
        if ($targetUrl -eq "GAMEBAR_FIX") {
            Invoke-GameBarNotificationFix
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
    $index++
}

# ============================================================================
# RGB BORDER ANIMATION TIMER
# ============================================================================

$script:rgbHue = 0
$script:rgbTimer = New-Object System.Windows.Forms.Timer
$script:rgbTimer.Interval = 20

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

# Add Credits Label (Red text at bottom)
$creditsLabel = New-Object System.Windows.Forms.Label
$creditsLabel.Location = New-Object System.Drawing.Point(0, 760)
$creditsLabel.Size = New-Object System.Drawing.Size(850, 25)
$creditsLabel.Text = "Created by: @mariusheier | Script by: @EODBruz"
$creditsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$creditsLabel.ForeColor = [System.Drawing.Color]::Red
$creditsLabel.TextAlign = "MiddleCenter"
$creditsLabel.BackColor = [System.Drawing.Color]::Black
$mainPanel.Controls.Add($creditsLabel)

$form.Controls.Add($mainPanel)

$form.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq "Escape") {
        $form.Close()
    }
})

$form.Add_Shown({$form.Activate()})
$form.Add_FormClosing({
    $script:rgbTimer.Stop()
    $script:rgbTimer.Dispose()
})
$form.Add_FormClosed({
    [System.Diagnostics.Process]::GetCurrentProcess().Kill()
})
[void]$form.ShowDialog()
#requires -Version 5.1
<#
.SYNOPSIS
    MARIUS Board Configurator with Built-in USB Latency Analyzer V3.1

.DESCRIPTION
    All-in-one launcher for MARIUS tools including the built-in USB Latency Analyzer.
    No additional files needed - everything is contained in this single script.
    Features auto-updater, desktop shortcut installer, and embedded MBC icon.

.NOTES
    Created by: @mariusheier (Original Creator)
    Script by: @EODBruz (PowerShell Development)
    Version: 5.0
    
.CREDITS
    App Creator: @mariusheier
    Script Developer: @EODBruz
    
.INSTALLATION
    Quick Install (One-Liner):
    iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
    
.SECURITY WARNING
    If you downloaded this script and get a security warning when running:
    - Press "R" to Run once (safe - this is a trusted script)
    - OR right-click file -> Properties -> Check "Unblock" -> Apply
    - OR use the one-liner above (no warning!)
#>

param(
    [switch]$NoUpdate  # Used internally after auto-update to prevent recheck loop
)

# ============================================================================
# VERSION & AUTO-UPDATE SYSTEM
# ============================================================================
$script:CurrentVersion = "5.0"
$script:InstallDir     = "$env:APPDATA\MARIUS"
$script:InstallPath    = "$script:InstallDir\MARIUS.ps1"
$script:VersionUrl     = "https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/version.txt"
$script:ScriptUrl      = "https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1"

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
    # Copy script to %APPDATA%\MARIUS if not already running from there
    try {
        if (-not (Test-Path $script:InstallDir)) {
            New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
        }
        $runningPath = $MyInvocation.ScriptName
        if ($runningPath -and ($runningPath -ne $script:InstallPath) -and (Test-Path $runningPath)) {
            Copy-Item -Path $runningPath -Destination $script:InstallPath -Force -ErrorAction SilentlyContinue
        } elseif (-not (Test-Path $script:InstallPath)) {
            $content = (New-Object System.Net.WebClient).DownloadString($script:ScriptUrl)
            [System.IO.File]::WriteAllText($script:InstallPath, $content, [System.Text.Encoding]::UTF8)
        }
    } catch {}
}

function Check-ForUpdates {
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("Cache-Control", "no-cache")
        $latestVersion = $wc.DownloadString($script:VersionUrl).Trim()

        if ([version]$latestVersion -gt [version]$script:CurrentVersion) {

            $updateForm = New-Object System.Windows.Forms.Form
            $updateForm.Text            = "Update Available"
            $updateForm.Width           = 460
            $updateForm.Height          = 220
            $updateForm.StartPosition   = "CenterScreen"
            $updateForm.FormBorderStyle = "None"
            $updateForm.BackColor       = [System.Drawing.Color]::Yellow
            $updateForm.Padding         = New-Object System.Windows.Forms.Padding(2)
            $updateForm.TopMost         = $true

            $upanel = New-Object System.Windows.Forms.Panel
            $upanel.Location  = New-Object System.Drawing.Point(2, 2)
            $upanel.Size      = New-Object System.Drawing.Size(456, 216)
            $upanel.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

            # Title label
            $lblTitle = New-Object System.Windows.Forms.Label
            $lblTitle.Location  = New-Object System.Drawing.Point(0, 18)
            $lblTitle.Size      = New-Object System.Drawing.Size(456, 30)
            $lblTitle.Text      = "Update Available!"
            $lblTitle.Font      = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
            $lblTitle.ForeColor = [System.Drawing.Color]::Yellow
            $lblTitle.TextAlign = "MiddleCenter"

            # Version arrow label
            $lblVersion = New-Object System.Windows.Forms.Label
            $lblVersion.Location  = New-Object System.Drawing.Point(0, 52)
            $lblVersion.Size      = New-Object System.Drawing.Size(456, 28)
            $lblVersion.Text      = "v$script:CurrentVersion   >>>   v$latestVersion"
            $lblVersion.Font      = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
            $lblVersion.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
            $lblVersion.TextAlign = "MiddleCenter"

            # Subtitle label
            $subLbl = New-Object System.Windows.Forms.Label
            $subLbl.Location  = New-Object System.Drawing.Point(0, 86)
            $subLbl.Size      = New-Object System.Drawing.Size(456, 22)
            $subLbl.Text      = "Would you like to update now?"
            $subLbl.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
            $subLbl.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
            $subLbl.TextAlign = "MiddleCenter"

            # Update Now button
            $btnUpdate = New-Object System.Windows.Forms.Button
            $btnUpdate.Location  = New-Object System.Drawing.Point(48, 128)
            $btnUpdate.Size      = New-Object System.Drawing.Size(165, 46)
            $btnUpdate.Text      = "Update Now"
            $btnUpdate.FlatStyle = "Flat"
            $btnUpdate.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
            $btnUpdate.ForeColor = [System.Drawing.Color]::Yellow
            $btnUpdate.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
            $btnUpdate.FlatAppearance.BorderColor = [System.Drawing.Color]::Yellow
            $btnUpdate.FlatAppearance.BorderSize  = 1
            $btnUpdate.Cursor       = [System.Windows.Forms.Cursors]::Hand
            $btnUpdate.DialogResult = [System.Windows.Forms.DialogResult]::Yes

            # Skip button
            $btnSkip = New-Object System.Windows.Forms.Button
            $btnSkip.Location  = New-Object System.Drawing.Point(243, 128)
            $btnSkip.Size      = New-Object System.Drawing.Size(165, 46)
            $btnSkip.Text      = "Skip"
            $btnSkip.FlatStyle = "Flat"
            $btnSkip.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
            $btnSkip.ForeColor = [System.Drawing.Color]::Red
            $btnSkip.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
            $btnSkip.FlatAppearance.BorderColor = [System.Drawing.Color]::Red
            $btnSkip.FlatAppearance.BorderSize  = 1
            $btnSkip.Cursor       = [System.Windows.Forms.Cursors]::Hand
            $btnSkip.DialogResult = [System.Windows.Forms.DialogResult]::No

            $upanel.Controls.AddRange(@($lblTitle, $lblVersion, $subLbl, $btnUpdate, $btnSkip))
            $updateForm.Controls.Add($upanel)
            $updateForm.AcceptButton = $btnUpdate
            $updateForm.CancelButton = $btnSkip

            # RGB animation timer - .GetNewClosure() captures all local controls
            $script:updateRgbHue = 0
            $updateRgbTimer = New-Object System.Windows.Forms.Timer
            $updateRgbTimer.Interval = 20
            $updateRgbTimer.Add_Tick({
                $script:updateRgbHue = ($script:updateRgbHue + 2) % 360
                $h = $script:updateRgbHue / 360.0
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
                $updateForm.BackColor                 = $rgbColor
                $lblTitle.ForeColor                   = $rgbColor
                $lblVersion.ForeColor                 = $rgbColor
                $subLbl.ForeColor                     = $rgbColor
                $btnUpdate.ForeColor                  = $rgbColor
                $btnUpdate.FlatAppearance.BorderColor = $rgbColor
                $btnSkip.ForeColor                    = $rgbColor
                $btnSkip.FlatAppearance.BorderColor   = $rgbColor
            }.GetNewClosure())

            $updateForm.Add_Shown({ $updateRgbTimer.Start() })
            $updateForm.Add_FormClosing({ $updateRgbTimer.Stop(); $updateRgbTimer.Dispose() })

            $result = $updateForm.ShowDialog()
            $updateForm.Dispose()

            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                try {
                    if (-not (Test-Path $script:InstallDir)) {
                        New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
                    }
                    $wc2 = New-Object System.Net.WebClient
                    $newScript = $wc2.DownloadString($script:ScriptUrl)
                    [System.IO.File]::WriteAllText($script:InstallPath, $newScript, [System.Text.Encoding]::UTF8)
                    Start-Sleep -Milliseconds 500
                    Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$script:InstallPath`" -NoUpdate"
                    exit
                } catch {
                    [System.Windows.Forms.MessageBox]::Show(
                        "Update failed. Please re-run the one-liner install command.",
                        "Update Error",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    ) | Out-Null
                }
            }
        }
    } catch {
        # No internet or version check failed - launch normally
    }
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
    $script:analyzerRgbTimer.Interval = 20

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
    $gbRgbTimer.Interval = 20
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
# STARTUP: INSTALL, ICON, SHORTCUT, UPDATE CHECK
# ============================================================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 1. Install script to %APPDATA%\MARIUS if needed
Invoke-SelfInstall

# 2. Extract MBC icon and create Desktop shortcut (first run only)
$script:IconPath = Install-MbcIcon
Install-DesktopShortcut -IconPath $script:IconPath
Install-StartMenuShortcut -IconPath $script:IconPath

# 3. Check for updates (skipped if just updated to prevent loop)
if (-not $NoUpdate) {
    Check-ForUpdates
}

# ============================================================================
# MAIN BROWSER WINDOW
# ============================================================================

$script:form = New-Object System.Windows.Forms.Form
$form = $script:form
$form.Text = "MARIUS BOARD CONFIGURATOR"
$form.Width = 854
$form.Height = 793
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
$mainPanel.Size = New-Object System.Drawing.Size(850, 789)
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

$websites = @(
    @{Name="Setup Controller"; URL="https://devsetup.mariusheier.com/"; Desc="Calibrate and configure your controller settings and polling rate settings"},
    @{Name="Joystick Tester"; URL="https://hardwaretester.com/gamepad"; Desc="Test your joystick inputs, buttons, and analog stick precision"},
    @{Name="Polling Rate Checker"; URL="https://tools.mariusheier.com/poll_checker.html"; Desc="Test and verify your controller's polling rate"},
    @{Name="USB Latency Analyzer"; URL="USB_ANALYZER"; Desc="Count chips between your device and CPU. More chips = more latency"},
    @{Name="Firmware Updater"; URL="https://update.mariusheier.com/"; Desc="Update Your Controller to Latest Versions Or Beta Versions"},
    @{Name="Setup Guide By Parasite"; URL="https://x.com/Parasite/status/2033329474922549297"; Desc="Explains How to setup sticks/controller"},
    @{Name="Gamebar Notification Removal"; URL="GAMEBAR_FIX"; Desc="Removes GameBar Notification with 8K Polling Affected Controllers"},
    @{Name="Creator Twitter"; URL="https://x.com/mariusheier"; Desc="Follow for updates, tips, and support"},
    @{Name="Exit"; URL="EXIT"; Desc="Close this application"}
)

$tileWidth = 790
$tileHeight = 65
$spacing = 10
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
        
        if ($targetUrl -eq "USB_ANALYZER") {
            Show-UsbAnalyzer
            return
        }
        
        if ($targetUrl -eq "GAMEBAR_FIX") {
            Invoke-GameBarNotificationFix
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
    $index++
}

# ============================================================================
# RGB BORDER ANIMATION TIMER
# ============================================================================

$script:rgbHue = 0
$script:rgbTimer = New-Object System.Windows.Forms.Timer
$script:rgbTimer.Interval = 20

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

# Add Credits Label (Red text at bottom)
$creditsLabel = New-Object System.Windows.Forms.Label
$creditsLabel.Location = New-Object System.Drawing.Point(0, 760)
$creditsLabel.Size = New-Object System.Drawing.Size(850, 25)
$creditsLabel.Text = "Created by: @mariusheier | Script by: @EODBruz"
$creditsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$creditsLabel.ForeColor = [System.Drawing.Color]::Red
$creditsLabel.TextAlign = "MiddleCenter"
$creditsLabel.BackColor = [System.Drawing.Color]::Black
$mainPanel.Controls.Add($creditsLabel)

$form.Controls.Add($mainPanel)

$form.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq "Escape") {
        $form.Close()
    }
})

$form.Add_Shown({$form.Activate()})
$form.Add_FormClosing({
    $script:rgbTimer.Stop()
    $script:rgbTimer.Dispose()
})
$form.Add_FormClosed({
    [System.Diagnostics.Process]::GetCurrentProcess().Kill()
})
[void]$form.ShowDialog()
