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

## 🚀 Quick Install (Easiest!)

Open PowerShell and paste this:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

Done! No downloads, no security prompts, just runs.

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

### Method 1: One-Liner (Recommended)

Paste this into PowerShell:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

**Why this is best:**
- ✅ No files to download
- ✅ No security warnings
- ✅ Runs immediately
- ✅ Always gets latest version

### Method 2: Download and Run

1. Download `MARIUS.ps1` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Right-click → **Run with PowerShell**
3. When you see: `[D] Do not run  [R] Run once...`
4. Press **R** and Enter

That's it!

---

## 🎯 Usage

### Main Menu
1. Run the script (using either method above)
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
- **Special Thanks:** FR33THY

---

## ❓ FAQ

### "Security warning - Do you want to run this script?"

This is normal for downloaded PowerShell scripts. Just press **"R"** to run.

**Want to avoid this?** Use the one-liner instead:
```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

### "Is this script safe?"

Yes! The script is:
- ✅ **Open source** - You can read all the code on GitHub
- ✅ **No admin required** - Only reads USB info
- ✅ **No system changes** - Doesn't modify anything
- ✅ **Community trusted** - Made for [@mariusheier](https://x.com/mariusheier)'s MARIUS community

### "Which method should I use?"

**Use the one-liner** (Method 1) - it's easier and has no prompts!

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues)
- **Creator:** [@mariusheier on Twitter/X](https://x.com/mariusheier)
- **Developer:** [@EODBruz on GitHub](https://github.com/EODBruz)

---

**Made for gamers who care about latency.** 🎮⚡
