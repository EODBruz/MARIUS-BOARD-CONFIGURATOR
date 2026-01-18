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

## 🚀 Quick Install

### Method 1: One-Liner (Recommended!)

Open PowerShell and paste this:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

**Done!** No downloads, no security prompts, just runs instantly.

### Method 2: Manual Download

1. **Download:** [Launch_MARIUS.bat](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/raw/main/Launch_MARIUS.bat)
2. **Double-click** the file
3. **Done!** 

The launcher downloads and runs the latest version automatically.

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

## 📥 All Installation Methods

### Method 1: One-Liner (Fastest!)

Paste this into PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

**Benefits:**
- ✅ No files to download
- ✅ No security warnings
- ✅ Runs immediately
- ✅ Always gets latest version

### Method 2: BAT Launcher (Double-Click!)

1. Download `Launch_MARIUS.bat` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Double-click `Launch_MARIUS.bat`
3. Done!

**What it does:**
- Downloads and runs the latest version automatically
- Shows status in console window
- No PowerShell commands needed

### Method 3: Desktop Shortcut (Best for Repeat Use!)

Create a permanent desktop shortcut:
0. Coming Soon use Lanuch_MARIUS.bat
1. Download `Create_Desktop_Shortcut.ps1` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Right-click → **Run with PowerShell**
3. A shortcut appears on your desktop
4. Double-click "MARIUS Configurator" anytime!

**Benefits:**
- ✅ One-time setup
- ✅ Always launches latest version
- ✅ Clean desktop icon
- ✅ No files to manage

### Method 4: Direct Script Download

1. Download `MARIUS.ps1` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Right-click → **Run with PowerShell**
3. When you see: `[D] Do not run  [R] Run once...`
4. Press **R** and Enter

---

## 🎯 Usage

### Main Menu
1. Run the script (using any method above)
2. Choose from the menu:
   - **Firmware Updater** - Opens in browser
   - **Setup Controller** - Opens in browser
   - **Polling Rate Checker** - Opens in browser
   - **USB Latency Analyzer** - Opens built-in analyzer
   - **Creator Twitter** - Opens [@mariusheier](https://x.com/mariusheier)
   - **Exit** - Close application

### USB Latency Analyzer
1. Click **"USB Latency Analyzer"** from main menu
2. Click **"SCAN USB DEVICES"**
3. View results color-coded by latency:
   - 🟢 Green = 0 chips (Direct to CPU - Best!)
   - 🟠 Orange = 1 chip (Through chipset - Good)
   - 🔴 Red = 2+ chips (Through hub - Avoid for gaming)

---

## 📊 Understanding USB Latency

### What Does "Chip Count" Mean?

Each "chip" represents a hop in the USB chain:

```
0 CHIPS: Device → [CPU] ✅
         Lowest latency - Perfect for competitive gaming

1 CHIP:  Device → [CHIPSET] → [CPU] ⚠️
         Normal latency - Fine for most uses

2+ CHIPS: Device → [USB HUB] → [CHIPSET] → [CPU] ❌
          Highest latency - Avoid for gaming peripherals
```

### Example Results

```
● 0 CHIPS - DIRECT TO CPU (1 device)
   └─ Wireless Controller
      Raphael/Granite Ridge USB 3.1 | Ryzen 7000/9000 (AM5)

● 1 CHIP - THROUGH CHIPSET (4 devices)
   └─ G300s Optical Gaming Mouse
      600 Series USB 3.2 | X670/B650 (AM5)

● 2+ CHIPS - THROUGH HUB (1 device)
   └─ SteelSeries Keyboard
      2 chips | 1 hub(s)
```

### Optimization Tips

🎯 **For competitive gaming:**
- Move mouse/keyboard to **0 CHIP ports** (if available)
- Avoid USB hubs for gaming peripherals
- Use rear I/O ports (usually better than front panel)

📍 **Finding the best ports:**
- Check your motherboard manual for "CPU-connected" USB ports
- Try different rear panel USB ports and rescan
- USB 3.0/3.1/3.2 ports often have better paths

---

## 🖥️ Supported Hardware

### Intel Platforms
- 14th Gen (Meteor Lake, Lunar Lake)
- 13th Gen (Raptor Lake)
- 12th Gen (Alder Lake)
- 11th Gen (Tiger Lake)
- 10th Gen and older

### AMD Platforms
- Ryzen 9000 Series (Zen 5)
- Ryzen 7000 Series (Zen 4)
- Ryzen 5000/4000/3000 Series
- Ryzen 2000/1000 Series

### Third-Party Controllers
- ASMedia, VIA, Renesas
- Intel Thunderbolt 3/4/5

---

## 🙏 Credits

- **App Creator:** [@mariusheier](https://x.com/mariusheier)
- **Script Developer:** [@EODBruz](https://github.com/EODBruz)
- **Special Thanks:** FR33THY Allow Scripts! Bat File

---

## ❓ FAQ

### "Security warning - Do you want to run this script?"

This is normal for downloaded PowerShell scripts. Just press **"R"** to run once.

**Want to avoid this?** Use Method 1 (One-liner) or Method 2 (BAT launcher) instead - no warnings!

### "Is this script safe?"

Yes! The script is:
- ✅ **Open source** - You can read all the code on GitHub
- ✅ **No admin required** - Only reads USB info
- ✅ **No system changes** - Doesn't modify anything
- ✅ **Community trusted** - Made for [@mariusheier](https://x.com/mariusheier)'s MARIUS community

### "Which method should I use?"

**Most users:** Method 1 (One-liner) - easiest and fastest!
**Want double-click:** Method 2 (BAT launcher)
**Regular user:** Method 3 (Desktop shortcut) - set it and forget it!

### "The BAT file won't run!"

Make sure you downloaded `Launch_MARIUS.bat` (not `Launch_MARIUS_bat.bat` or similar). The file should be exactly 25 lines and start with `@echo off`.

---

## 🔧 Troubleshooting

### Execution Policy Error

If you get an execution policy error when running the .ps1 file directly:

**Quick Fix:** Use Method 1 (one-liner) or Method 2 (BAT launcher) instead - they bypass this automatically!

### Script Won't Run

Check your PowerShell version:
```powershell
$PSVersionTable.PSVersion
```

Must be **5.1 or higher**. Windows 10/11 include this by default.

### USB Analyzer Shows No Devices

- Make sure devices are **plugged in and working**
- Script only detects **input devices** (mouse, keyboard, controllers)
- Try running as administrator if issues persist

### Browser Doesn't Open

The script will try browsers in this order:
1. Your default browser
2. Chrome → Edge → Brave → Opera → Vivaldi → Arc

If none are found, it will use Windows default handler.

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues)
- **Creator:** [@mariusheier on Twitter/X](https://x.com/mariusheier)
- **Developer:** [@EODBruz on GitHub](https://github.com/EODBruz)

---

## 📝 Files in This Repo

- `MARIUS.ps1` - Main script (can run directly)
- `Launch_MARIUS.bat` - Double-click launcher (easiest!)
- `Create_Desktop_Shortcut.ps1` - Creates permanent desktop shortcut COMING SOON!!!!!
- `README.md` - This documentation

---

## 🎮 Made for Gamers

**Optimize your USB ports. Minimize your latency. Maximize your performance.**

Built with ❤️ for the competitive gaming community.

---

<div align="center">

**Made for gamers who care about latency.** 🎮⚡

[⭐ Star this repo](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR) | [🐛 Report Bug](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues) | [✨ Request Feature](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues)

</div>
