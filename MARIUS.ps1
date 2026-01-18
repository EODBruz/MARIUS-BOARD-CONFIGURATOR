#requires -Version 5.1
<#
.SYNOPSIS
    MARIUS Board Configurator with Built-in USB Latency Analyzer V3

.DESCRIPTION
    All-in-one launcher for MARIUS tools including the built-in USB Latency Analyzer.
    No additional files needed - everything is contained in this single script.

.NOTES
    Created by: @mariusheier (Original Creator)
    Script by: @EODBruz (PowerShell Development)
    Version: 3.0
    
.CREDITS
    App Creator: @mariusheier
    Script Developer: @EODBruz
    
.INSTALLATION
    Quick Install (One-Liner):
    iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-Configurator/main/MARIUS.ps1 | iex
#>

param()

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
    $analyzerForm.BackColor = [System.Drawing.Color]::White
    $analyzerForm.Padding = New-Object System.Windows.Forms.Padding(2)

    $mainPanel = New-Object System.Windows.Forms.Panel
    $mainPanel.Location = New-Object System.Drawing.Point(2, 2)
    $mainPanel.Size = New-Object System.Drawing.Size(850, 650)
    $mainPanel.BackColor = [System.Drawing.Color]::Black

    $headerPanel = New-Object System.Windows.Forms.Panel
    $headerPanel.Location = New-Object System.Drawing.Point(0, 0)
    $headerPanel.Size = New-Object System.Drawing.Size(850, 100)
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

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Location = New-Object System.Drawing.Point(0, 35)
    $titleLabel.Size = New-Object System.Drawing.Size(850, 40)
    $titleLabel.Text = "USB LATENCY ANALYZER V3"
    $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::Yellow
    $titleLabel.TextAlign = "MiddleCenter"
    $titleLabel.BackColor = [System.Drawing.Color]::Transparent

    $titleLabel.Add_MouseDown({
        $script:dragging = $true
        $script:dragCursorX = [System.Windows.Forms.Cursor]::Position.X - $analyzerForm.Left
        $script:dragCursorY = [System.Windows.Forms.Cursor]::Position.Y - $analyzerForm.Top
    })

    $titleLabel.Add_MouseMove({
        if ($script:dragging) {
            $analyzerForm.Left = [System.Windows.Forms.Cursor]::Position.X - $script:dragCursorX
            $analyzerForm.Top = [System.Windows.Forms.Cursor]::Position.Y - $script:dragCursorY
        }
    })

    $titleLabel.Add_MouseUp({
        $script:dragging = $false
    })

    $headerPanel.Controls.Add($titleLabel)
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
    $scanBtn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
    $scanBtn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $scanBtn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)

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
    $exitBtn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
    $exitBtn.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $exitBtn.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)

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
# MAIN BROWSER WINDOW
# ============================================================================

$form = New-Object System.Windows.Forms.Form
$form.Text = "MARIUS BOARD CONFIGURATOR"
$form.Width = 854
$form.Height = 654
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::White
$form.Padding = New-Object System.Windows.Forms.Padding(2)

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
$mainPanel.Location = New-Object System.Drawing.Point(2, 2)
$mainPanel.Size = New-Object System.Drawing.Size(850, 650)
$mainPanel.BackColor = [System.Drawing.Color]::Black

$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.Size = New-Object System.Drawing.Size(850, 100)
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

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(0, 35)
$titleLabel.Size = New-Object System.Drawing.Size(854, 40)
$titleLabel.Text = "MARIUS BOARD CONFIGURATOR"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::Yellow
$titleLabel.TextAlign = "MiddleCenter"
$titleLabel.BackColor = [System.Drawing.Color]::Transparent

$titleLabel.Add_MouseDown({
    $script:dragging = $true
    $script:dragCursorX = [System.Windows.Forms.Cursor]::Position.X - $form.Left
    $script:dragCursorY = [System.Windows.Forms.Cursor]::Position.Y - $form.Top
})

$titleLabel.Add_MouseMove({
    if ($script:dragging) {
        $form.Left = [System.Windows.Forms.Cursor]::Position.X - $script:dragCursorX
        $form.Top = [System.Windows.Forms.Cursor]::Position.Y - $script:dragCursorY
    }
})

$titleLabel.Add_MouseUp({
    $script:dragging = $false
})

$headerPanel.Controls.Add($titleLabel)
$mainPanel.Controls.Add($headerPanel)

$websites = @(
    @{Name="Firmware Updater"; URL="https://update.mariusheier.com/"; Desc="Update Your Controller to Latest Versions Or Beta Versions"},
    @{Name="Setup Controller"; URL="https://devsetup.mariusheier.com/"; Desc="Calibrate and configure your controller settings and polling rate settings"},
    @{Name="Polling Rate Checker"; URL="https://tools.mariusheier.com/poll_checker.html"; Desc="Test and verify your controller's polling rate"},
    @{Name="USB Latency Analyzer"; URL="USB_ANALYZER"; Desc="Count chips between your device and CPU. More chips = more latency"},
    @{Name="Creator Twitter"; URL="https://x.com/mariusheier"; Desc="Follow for updates, tips, and support"},
    @{Name="Exit"; URL="EXIT"; Desc="Close this application"}
)

$tileWidth = 790
$tileHeight = 65
$spacing = 10
$startX = 30
$startY = 115

$index = 0
foreach ($site in $websites) {
    $xPos = $startX
    $yPos = $startY + ($index * ($tileHeight + $spacing))
    
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
    $tile.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
    $tile.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $tile.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $tile.Tag = $site.URL
    
    $siteName = $site.Name
    $siteDesc = $site.Desc
    
    $tile.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
        
        $titleFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
        $descFont = New-Object System.Drawing.Font("Segoe UI", 8)
        $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 160, 160))
        
        $g.DrawString($siteName, $titleFont, $whiteBrush, 20, 12)
        $g.DrawString($siteDesc, $descFont, $grayBrush, 20, 35)
        
        $whiteBrush.Dispose()
        $grayBrush.Dispose()
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

# Add Credits Label (Red text at bottom)
$creditsLabel = New-Object System.Windows.Forms.Label
$creditsLabel.Location = New-Object System.Drawing.Point(0, 625)
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
[void]$form.ShowDialog()
