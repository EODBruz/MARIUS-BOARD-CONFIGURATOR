<div align="center">

![MARIUS Logo](logo.png)

</div>

---

# MARIUS Board Configurator

<div align="center">

![Version](https://img.shields.io/badge/version-1.0-yellow)
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
- **Joystick Tester** - Test your joystick inputs, buttons, and analog stick precision
- **GameBar Noti Removed** - Removes GameBar annoying message with 8K Polling Rates Affected Controllers
- **Creator Twitter** - Follow [@mariusheier](https://x.com/mariusheier) for updates

### 🔄 **Auto-Updater**
- Automatically checks for updates on every launch
- Shows a prompt when a new version is available — **Update Now** or **Skip**
- Downloads and relaunches the new version instantly
- No manual re-downloading ever needed
- **BUILD system** — supports full resets and forced updates across all users
- Wipes and reinstalls cleanly on major updates — no leftover files

### 🖥️ **Auto Desktop Shortcut**
- On first run, automatically installs to `%APPDATA%\MARIUS\MARIUS.ps1`
- Creates a Desktop shortcut with the **MBC yellow icon** automatically
- Shortcut launches silently — no PowerShell window, no security warnings
- One-time setup, works forever

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
- ✅ Auto-installs to `%APPDATA%\MARIUS` and creates Desktop shortcut

### Method 2: BAT Launcher (Double-Click!)

1. Download `Launch_MARIUS.bat` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Double-click `Launch_MARIUS.bat`
3. Done!

**What it does:**
- Downloads and runs the latest version automatically
- Shows status in console window
- No PowerShell commands needed

### Method 3: Desktop Shortcut (Best for Repeat Use!)

The Desktop shortcut is now **created automatically** on first run — no extra steps needed!

- ✅ Created on first launch automatically
- ✅ Yellow MBC icon on your Desktop
- ✅ Launches silently with no PowerShell window
- ✅ Always points to the installed version at `%APPDATA%\MARIUS\MARIUS.ps1`

### Method 4: Direct Script Download

1. Download `MARIUS.ps1` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Right-click → **Run with PowerShell**
3. When you see: `[D] Do not run  [R] Run once...`
4. Press **R** and Enter

---

## 🔄 Updating

Updating is fully automatic. When a new version is released:

1. Launch the app as normal
2. A prompt will appear: **"Update Available! vX.X → vX.X"**
3. Press **Update Now**
4. The app **wipes the old installation completely**, downloads fresh, and relaunches itself instantly

You never need to manually download a new version again.

---

## ⚠️ Known Updater Issues & History

### Why you may need to run the one-liner once

The auto-updater has gone through several fixes since early versions. If you installed the app a while ago, your copy may be missing one or more of these fixes:

**Issue 1 — GitHub CDN Caching**
Early versions downloaded updates without a cache-busting parameter, meaning GitHub could serve a stale cached file instead of the latest version. Users would click **Update Now** but get the same old script back. **Fixed in BUILD1.**

**Issue 2 — Version comparison with letters**
Version numbers containing letters (e.g. `3.1Beta`) caused PowerShell's `[version]` cast to fail silently, so the update check never triggered. **Always use numbers only** e.g. `1.0`, `1.1`.

**Issue 3 — Downgrading not possible**
The updater only triggered when `version.txt` was *higher* than the local version. Going from `10.0` back to `3.0` would never prompt because `3.0 < 10.0`. **Fixed with the BUILD system in BUILD1.**

**Issue 4 — Stale shortcuts after update**
Old shortcuts pointed to the previous script path. After an update the shortcut still launched the old cached version. **Fixed in BUILD1** — shortcuts are now deleted and recreated on every update.

**Issue 5 — Old installs missing all fixes**
Users who installed before BUILD1 had none of the above fixes. There was no way to push a remote fix to them since the old script couldn't understand FORCE or BUILD tags. **Solution: run the one-liner once** to get the fully patched version.

---

### 🔁 If your updater seems broken or stuck

Run this one-liner in PowerShell to get a clean fresh install with all fixes:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

This completely replaces your old installation. You only need to do this once — after that all future updates are fully automatic forever.

---

## 🎯 Usage

### Main Menu
1. Run the script (using any method above)
2. Choose from the menu:
   - **Firmware Updater** - Opens in browser
   - **Setup Controller** - Opens in browser
   - **Polling Rate Checker** - Opens in browser
   - **USB Latency Analyzer** - Opens built-in analyzer
   - **Joystick Tester** - Opens joystick testing tool
   - **GameBar Notification Removal** - Disables GameBar popups
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
- ✅ **No system changes** - Only creates a Desktop shortcut and installs to `%APPDATA%\MARIUS`
- ✅ **Community trusted** - Made for [@mariusheier](https://x.com/mariusheier)'s MARIUS community

### "Which method should I use?"

**Most users:** Method 1 (One-liner) - easiest and fastest!
**Want double-click:** Method 2 (BAT launcher)
**After first run:** Use the Desktop shortcut that was automatically created!

### "The BAT file won't run!"

Make sure you downloaded `Launch_MARIUS.bat` (not `Launch_MARIUS_bat.bat` or similar). The file should start with `@echo off`.

### "Where is the script installed?"

After first run, the script lives at `%APPDATA%\MARIUS\MARIUS.ps1`. The Desktop shortcut points here automatically.

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

### Update Not Appearing

- Make sure you have an internet connection
- Check that `version.txt` on GitHub has been updated to the latest version number
- If the app was just updated, the update check is skipped on the first launch to prevent loops
- If you are on an old install (before BUILD1), the updater may be broken — run the one-liner above to fix it once and for all
- **Never use letters in version numbers** (e.g. `3.1Beta` will break the version check) — use numbers only like `1.0`, `1.1`

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues)
- **Creator:** [@mariusheier on Twitter/X](https://x.com/mariusheier)
- **Developer:** [@EODBruz on GitHub](https://github.com/EODBruz)

---

## 📝 Files in This Repo

- `MARIUS.ps1` - Main script (auto-installs, auto-updates, creates Desktop shortcut)
- `Launch_MARIUS.bat` - Double-click launcher (easiest!)
- `version.txt` - Current version number (used by auto-updater)
- `README.md` - This documentation
- `logo.png` - MARIUS logo
- `Title.png` - Title banner used in the app

---

## 🎮 Made for Gamers

**Optimize your USB ports. Minimize your latency. Maximize your performance.**

Built with ❤️ for the competitive gaming community.

---

<div align="center">

**Made for gamers who care about latency.** 🎮⚡

[⭐ Star this repo](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR) | [🐛 Report Bug](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues) | [✨ Request Feature](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues)

</div>
