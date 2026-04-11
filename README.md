<div align="center">

![MARIUS Logo](logo.png)

</div>

---

# MARIUS Board Configurator

<div align="center">

![Version](https://img.shields.io/badge/version-3.1-yellow)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**All-in-one configurator for MARIUS controllers with built-in USB Latency Analyzer**

Created by [@mariusheier](https://x.com/mariusheier) | Script by [@EODBruz](https://github.com/EODBruz)

</div>

---

## 🗑️ Uninstall First (Existing Users)

> **If you already have MARIUS installed, run the uninstaller FIRST before reinstalling.** This ensures a completely clean install with no leftover files or broken shortcuts.

**Step 1 — Uninstall:**

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS_Uninstall.ps1 | iex
```

**Step 2 — Reinstall:**

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

**What the uninstaller removes:**
- `%APPDATA%\MARIUS` folder (script, icon, update log)
- Desktop shortcut
- Start Menu shortcut and folder
- Any leftover temp update files in `%TEMP%`

---

## 🚀 Quick Install (New Users)

### Method 1: One-Liner (Recommended)

Open PowerShell and paste:

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

No downloads, no security prompts — runs instantly and installs itself automatically.

### Method 2: Manual Download

1. Download [Launch_MARIUS.bat](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/raw/main/Launch_MARIUS.bat)
2. Double-click the file

The launcher downloads and runs the latest version automatically.

---

## ✨ Features

### 🎮 Main Menu

The app launches a dark-themed GUI with RGB border animation. Each menu tile shows a name and description. The full list of options:

| Tile | Action |
|------|--------|
| **Setup Controller** | Opens [devsetup.mariusheier.com](https://devsetup.mariusheier.com/) — calibrate and configure controller settings and polling rate |
| **Joystick Tester** | Opens [hardwaretester.com/gamepad](https://hardwaretester.com/gamepad) — test inputs, buttons, and analog stick precision |
| **Polling Rate Checker** | Opens the polling rate checker at tools.mariusheier.com |
| **USB Latency Analyzer** | Runs the built-in USB chip counter (no browser needed) |
| **Firmware Updater** | Opens [update.mariusheier.com](https://update.mariusheier.com/) — update to latest or beta firmware |
| **Setup Guide By Parasite** | Opens the stick/controller setup guide on X |
| **GameBar Notification Removal** | Removes the GameBar popup that affects 8K polling rate controllers |
| **Creator Twitter** | Opens [@mariusheier](https://x.com/mariusheier) on X |
| **Update Script** | Manually triggers a download and install of the latest version |
| **Exit** | Closes the application |

All browser-based tiles open in a centered 1200×800 app window using your default Chromium browser.

### 🔄 Auto-Updater

The updater runs silently every time the app launches. It queries the **GitHub Releases API** for the latest release tag, compares it to the currently installed version, and — if a newer version is available — downloads it, validates the file size (must be >10 KB), swaps the old script out, and relaunches automatically. All update activity is logged to `%APPDATA%\MARIUS\update.log`.

If no `.ps1` asset is attached to the GitHub release, the updater falls back to downloading from the `main` branch and reads the version number directly from the script source.

### 🖥️ Auto Install & Shortcuts

On first run the script:
1. Copies itself to `%APPDATA%\MARIUS\MARIUS.ps1`
2. Extracts the embedded MBC icon (`MBC.ico`) to the same folder
3. Creates a **Desktop shortcut** — launches silently with no PowerShell window
4. Creates a **Start Menu shortcut** under Programs

Shortcuts are only created once and are not recreated on subsequent runs unless missing.

### 📊 USB Latency Analyzer V3

The built-in analyzer walks the Windows PnP device tree to count how many USB controller chips sit between each connected input device and the CPU.

**Chip count ratings:**

```
🟢  0 CHIPS — Direct to CPU        (BEST — lowest latency)
🟠  1 CHIP  — Through chipset      (GOOD — normal latency)
🔴  2+ CHIPS — Through USB hub     (AVOID — highest latency)
```

Click **SCAN USB DEVICES** to scan. Results are colour-coded. The analyzer window is borderless and draggable.

---

## 🔌 Supported Hardware (USB Analyzer)

The analyzer contains an embedded database of known USB controller IDs. Recognized hardware includes:

**Intel CPU-integrated** — Ice Lake (10th Gen) through Lunar Lake, with Thunderbolt 3/4/5 (Alpine Ridge through Barlow Ridge)

**Intel PCH/Chipset** — 100 Series through 800 Series, including Alder Lake, Raptor Lake, and Meteor Lake variants

**AMD CPU-integrated** — Ryzen 1000 (Zen) through Ryzen 9000/Strix Halo (Zen 5), Ryzen 6000/7040 mobile, Steam Deck (VanGogh)

**AMD Chipset** — X370/X399 through X870/B850 (AM5), X570/B550/A520/X470/B450 (AM4)

**Third-party controllers** — ASMedia ASM1042/1042A/1142/3242, VIA VL805/806, Renesas uPD720201/202

Unknown Intel or AMD controllers fall back to a generic chipset classification (1 chip).

---

## 🌐 Browser Support

Browser tiles open in app mode (no address bar) using the first detected Chromium browser in this order:

Your default browser → Chrome → Edge → Brave → Opera → Vivaldi → Arc

If no Chromium browser is found, Windows' default URL handler is used instead.

---

## 📋 Requirements

- Windows 10 or Windows 11 (PowerShell 5.1 is included by default)
- Windows 8/8.1/7 require a manual PowerShell 5.1 upgrade
- No administrator rights required
- No additional software needed

---

## 📥 All Installation Methods

### Method 1: One-Liner

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS.ps1 | iex
```

No files to download, no security warnings, always gets the latest version, auto-installs to `%APPDATA%\MARIUS` and creates Desktop and Start Menu shortcuts.

### Method 2: BAT Launcher

1. Download `Launch_MARIUS.bat` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Double-click it

Downloads and runs the latest version automatically. No PowerShell commands needed.

### Method 3: Desktop Shortcut

Created automatically on first run. The shortcut launches the installed script at `%APPDATA%\MARIUS\MARIUS.ps1` silently with no PowerShell window.

### Method 4: Direct Script Download

1. Download `MARIUS.ps1` from [GitHub](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR)
2. Right-click → **Run with PowerShell**
3. When prompted press **R** then Enter to run once

---

## 🔄 Updating

Updates are fully automatic. The app checks the GitHub Releases API on every launch. If a new version is found you can also trigger a manual update at any time from the **Update Script** tile in the menu — it downloads the latest release, validates it, swaps it in, and relaunches.

---


## 🎯 Usage

### Main Menu

Launch the app using any method above. The GUI opens with a dark background and animated RGB border. Click any tile to use that feature. Press **Escape** to exit.

### USB Latency Analyzer

1. Click **USB Latency Analyzer** from the main menu
2. Click **SCAN USB DEVICES**
3. Results appear colour-coded by chip count — green for direct CPU connection, orange for chipset, red for hub

### GameBar Notification Removal

Click **GameBar Notification Removal** to suppress the Windows GameBar popup that appears with high polling rate controllers. No restart required.

### Manual Update

Click **Update Script** to force an immediate check and install of the latest version from GitHub. The app will relaunch automatically if a new version is installed.

---

## 📊 Understanding USB Latency

Each "chip" is a hop in the USB chain between your device and the CPU:

```
0 CHIPS:  Device → [CPU]                        ✅ Lowest latency
1 CHIP:   Device → [CHIPSET] → [CPU]            ⚠️  Normal latency
2+ CHIPS: Device → [HUB] → [CHIPSET] → [CPU]   ❌ Highest latency
```

### Example Results

```
● 0 CHIPS — DIRECT TO CPU (1 device)
   └─ Wireless Controller
      Raphael/Granite Ridge USB 3.1 | Ryzen 7000/9000 (AM5)

● 1 CHIP — THROUGH CHIPSET (4 devices)
   └─ G300s Optical Gaming Mouse
      600 Series USB 3.2 | X670/B650 (AM5)

● 2+ CHIPS — THROUGH HUB (1 device)
   └─ SteelSeries Keyboard
      2 chips | 1 hub(s)
```

### Optimization Tips

For competitive gaming, move your mouse and keyboard to 0-chip ports where possible. Avoid USB hubs for gaming peripherals. Rear I/O ports are usually better than front panel ports — check your motherboard manual for "CPU-connected" USB ports. Try different rear panel ports and rescan to compare.

---

## 🔧 Troubleshooting

### Execution Policy Error

Use Method 1 (one-liner) or Method 2 (BAT launcher) — they bypass execution policy automatically. If you must run the `.ps1` directly, press **R** at the security prompt.

### Script Won't Run

Check your PowerShell version:

```powershell
$PSVersionTable.PSVersion
```

Must be 5.1 or higher. Windows 10 and 11 include this by default.

### USB Analyzer Shows No Devices

Make sure devices are plugged in and working. The analyzer only detects input devices (mice, keyboards, controllers). Try running as administrator if devices are still missing.

### Browser Doesn't Open

The script searches for Chromium browsers in the order listed under Browser Support. If none are found it falls back to the Windows default URL handler. Install any Chromium browser if you want app-mode windows.

### Update Not Appearing

Check your internet connection. The updater queries the GitHub Releases API — if no `.ps1` asset is attached to the release it falls back to reading the version from the `main` branch directly. If you are on a pre-BUILD1 install the updater itself may be broken; run the uninstaller and reinstall cleanly using the one-liners above. Never use letters in version numbers.

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues)
- **Creator:** [@mariusheier on X](https://x.com/mariusheier)
- **Developer:** [@EODBruz on GitHub](https://github.com/EODBruz)

---

## 📝 Files in This Repo

- `MARIUS.ps1` — Main script (v3.1). Auto-installs, auto-updates, creates shortcuts, contains embedded MBC icon and full USB device database
- `MARIUS_Uninstall.ps1` — Removes all files, shortcuts, and folders cleanly
- `Launch_MARIUS.bat` — Double-click launcher, no PowerShell commands needed
- `README.md` — This file
- `logo.png` — MARIUS logo
- `Title.png` — Title banner displayed inside the app

---

## ❓ FAQ

**"Security warning — Do you want to run this script?"**
Normal for downloaded PowerShell scripts. Press **R** to run once. Use the one-liner or BAT launcher to avoid this entirely.

**"Is this safe?"**
Yes. The script is open source — read every line on GitHub. It requires no admin rights, makes no system changes beyond creating a shortcut and copying itself to `%APPDATA%\MARIUS`, and only reads USB device information from the Windows PnP device tree.

**"Where is the script installed?"**
`%APPDATA%\MARIUS\MARIUS.ps1`. The Desktop and Start Menu shortcuts point here.

**"How do I completely uninstall?"**

```powershell
iwr -useb https://raw.githubusercontent.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/main/MARIUS_Uninstall.ps1 | iex
```

Nothing is left behind.

**"My device isn't recognised by the USB analyzer."**
The database covers all major Intel, AMD, and common third-party USB controllers. Unrecognised Intel or AMD controllers are classified as chipset (1 chip) by default. Open a GitHub issue with your controller's Vendor ID and Device ID if you'd like it added.

---

## 🙏 Credits

- **App Creator:** [@mariusheier](https://x.com/mariusheier)
- **Script Developer:** [@EODBruz](https://github.com/EODBruz)
- **Special Thanks:** [FR33THY](https://github.com/FR33THYFR33THY/Ultimate) — Files from Ultimate Guide

---

<div align="center">

**Optimize your USB ports. Minimize your latency. Maximize your performance.** 🎮⚡

[⭐ Star this repo](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR) | [🐛 Report Bug](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues) | [✨ Request Feature](https://github.com/EODBruz/MARIUS-BOARD-CONFIGURATOR/issues)

</div>
