# MARIUS Board Configurator

<div align="center">

![Version](https://img.shields.io/badge/version-3.0-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**All-in-one configurator for MARIUS controllers with built-in USB Latency Analyzer**

Created by [@mariusheier](https://x.com/mariusheier) | Script by [@EODBruz](https://github.com/EODBruz)

</div>

---

## 🚀 Quick Install (One-Liner)

Open PowerShell and run:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

That's it! The script will download and run automatically.

---

## ✨ Features

### 🎮 **MARIUS Board Configurator**
- **Firmware Updater** - Update your controller to the latest versions
- **Setup Controller** - Calibrate and configure controller settings
- **Polling Rate Checker** - Test and verify your controller's polling rate
- **USB Latency Analyzer** - Analyze USB chip latency (Built-in!)
- **Creator Twitter** - Follow [@mariusheier](https://x.com/mariusheier) for updates

### 📊 **USB Latency Analyzer V3**
- 🟢 **0 CHIPS** - Direct to CPU (BEST - Lowest Latency)
- 🟠 **1 CHIP** - Through Chipset (GOOD - Normal Latency)
- 🔴 **2+ CHIPS** - Through USB Hub (AVOID - Highest Latency)

### 🌐 **Browser Support**
Supports all major Chromium-based browsers:
- ✅ Microsoft Edge
- ✅ Google Chrome
- ✅ Brave
- ✅ Opera
- ✅ Vivaldi
- ✅ Arc

---

## 📋 Requirements

- **Windows 10** or **Windows 11** (PowerShell 5.1+ included)
- **Windows 8/8.1/7** require PowerShell 5.1 upgrade
- No administrator rights required
- No installation needed

---

## 📥 Installation

### One-Liner (Recommended - No Security Warning!)

The easiest way to run the script **without security warnings**:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

This downloads and runs directly without saving to disk, so Windows doesn't flag it.

### Download and Run

If you download the file manually, you'll see a security warning. Here's how to handle it:

#### Quick Fix: Use Allow_Scripts.cmd ⭐ NEW!

1. Download both `MARIUS.ps1` AND `Allow_Scripts.cmd` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Right-click **Allow_Scripts.cmd** → **Run as Administrator**
3. Choose option **1** (Scripts: On)
4. Now **MARIUS.ps1** runs with no warnings!

**What it does:**
- ✅ Enables PowerShell scripts permanently
- ✅ Unblocks all files in the folder
- ✅ Allows double-click to run .ps1 files
- ✅ One-time setup, works for all future scripts

#### Option 1: Right-click → "Run with PowerShell" → Press "R"
1. Download `MARIUS.ps1` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Right-click → **Run with PowerShell**
3. When prompted: `[D] Do not run  [R] Run once  [S] Suspend`
4. **Press "R"** (Run once)

#### Option 2: Unblock the File (No warning next time)
1. Download `MARIUS.ps1`
2. Right-click → **Properties**
3. Check **"Unblock"** at the bottom
4. Click **Apply** → **OK**
5. Now run normally

#### Option 3: Unblock via PowerShell
```powershell
Unblock-File -Path ".\MARIUS.ps1"
.\MARIUS.ps1
```

#### Option 4: Bypass Execution Policy (One-time)
```powershell
powershell -ExecutionPolicy Bypass -File ".\MARIUS.ps1"
```

---

## 🙏 Credits

- **App Creator:** [@mariusheier](https://x.com/mariusheier)
- **Script Developer:** [@EODBruz](https://github.com/EODBruz)
- **Special Thanks:** FR33THY

---

## ❓ Common Questions

### "Security warning - Do you want to run this script?"

This is normal for downloaded PowerShell scripts. You have 3 options:

**Option 1:** Press **"R"** to run once (safest for first time)

**Option 2:** Unblock the file before running:
- Right-click MARIUS.ps1 → Properties → Check "Unblock" → Apply

**Option 3:** Use the one-liner instead (no warning):
```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

### "Is this script safe?"

Yes! The script is:
- ✅ **Open source** - You can read all the code on GitHub
- ✅ **No admin required** - Only reads USB info
- ✅ **No malware** - Just PowerShell and Windows Forms
- ✅ **Trusted creator** - Made for [@mariusheier](https://x.com/mariusheier)'s MARIUS community

---

**Made for gamers who care about latency.** 🎮⚡

