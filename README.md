# 🔮 Phantom Terminal

<p align="center">
  <img src="https://img.shields.io/badge/version-3.6.1-purple?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge&logo=powershell" alt="PowerShell">
  <img src="https://img.shields.io/badge/Bash-4.0%2B-green?style=for-the-badge&logo=gnu-bash" alt="Bash">
  <img src="https://img.shields.io/badge/Windows-10%2F11-0078D6?style=for-the-badge&logo=windows" alt="Windows">
  <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux">
  <img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/Termux-Android-32DE84?style=for-the-badge&logo=android" alt="Termux">
  <img src="https://img.shields.io/github/license/Unknown-2829/Phanton-terminal?style=for-the-badge" alt="License">
</p>

<p align="center">
  <b>A cinematic startup animation for your terminal</b><br>
  Multi-color matrix rain • Two themes • Glitch effects • Custom dashboard<br>
  <i>Cross-platform: Windows, Linux, macOS, Termux (Android)</i>
</p>

---

## ⚡ One-Line Install

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
```

### Linux / macOS / Termux
```bash
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
```

or with wget:
```bash
wget -qO- https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
```

**Interactive installer lets you choose:**
- **Theme** - Phantom (purple/cyan) or Unknown (green/blue)
- **Matrix Mode** - Letters or Binary (0101...)
- **Path Display** - Full path or folder only
- **Options** - Gradient logo, auto-update, system info display

---

## 🎨 Themes

### Phantom Theme (Purple/Cyan)
```
 ____  _   _    _    _   _ _____ ___  __  __ 
|  _ \| | | |  / \  | \ | |_   _/ _ \|  \/  |
|  __/|  _  |/ ___ \| |\  | | || |_| | |  | |
|_|   |_| |_/_/   \_\_| \_| |_| \___/|_|  |_|
```

### Unknown Theme (Green/Blue)
```
 _   _ _   _ _  ___   _  _____        ___   _ 
| | | | \ | | |/ / \ | |/ _ \ \      / / \ | |
| | | |  \| | ' /|  \| | | | \ \ /\ / /|  \| |
| |_| | |\  | . \| |\  | |_| |\ V  V / | |\  |
 \___/|_| \_|_|\_\_| \_|\___/  \_/\_/  |_| \_|
```

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎬 **Cinematic Startup** | Multi-stage animation sequence |
| 🌧️ **Matrix Rain** | Letters or Binary mode with theme colors |
| 🔐 **Security Loading** | Animated progress bars with glitch effects |
| 💀 **Glitch Reveal** | Logo appears with glitch animation |
| 📊 **Dashboard** | User, host, uptime, CPU/RAM stats, and quotes |
| 🎨 **Gradient Logo** | Multi-color gradient for logo display |
| 🔄 **Auto-Update** | Smart caching, checks updates periodically |
| ⚙️ **Persistent Config** | Settings preserved on reinstall |
| 📱 **Mobile Optimized** | Termux-specific performance tweaks |
| 🥚 **Easter Eggs** | Hidden commands with achievement tracking |

---

## 🛠️ Commands

| Command | Description |
|---------|-------------|
| `phantom-help` | Show all commands |
| `phantom-theme` | Switch theme (Phantom/Unknown) |
| `phantom-config` | View configuration |
| `phantom-config -Edit` | Edit config in notepad |
| `phantom-reload` | Replay startup animation |
| `phantom-matrix` | Run matrix animation |
| `phantom-dash` | Show dashboard with system stats |
| `phantom-update` | Check for updates (with caching) |

**Hidden Commands** (Easter Eggs 🥚):
- `phantom-chosen` - Unlock "The Chosen One"
- `phantom-2829` - Reveal the Creator's Mark
- `phantom-secrets` - Secret hunter achievement tracker

---

## ⚙️ Configuration

Config file: `~\.phantom-terminal\config.json`

```json
{
  "AnimationEnabled": true,
  "SecurityLoadSteps": 8,
  "GlitchIntensity": 3,
  "MatrixDuration": 2,
  "MatrixMode": "Letters",
  "Theme": "Phantom",
  "ShowSystemInfo": true,
  "ShowFullPath": true,
  "GradientText": true,
  "SmartSuggestions": true,
  "AutoCheckUpdates": true,
  "SilentUpdate": true,
  "UpdateCheckDays": 1
}
```

| Setting | Options | Description |
|---------|---------|-------------|
| `Theme` | Phantom, Unknown | Color theme |
| `MatrixMode` | Letters, Binary | Matrix rain style |
| `SecurityLoadSteps` | 1-12 | Loading bar segments for the security sequence |
| `GlitchIntensity` | 0-5 | Glitch effect strength |
| `ShowSystemInfo` | true/false | Show system details in the dashboard |
| `ShowFullPath` | true/false | Full path in prompt |
| `GradientText` | true/false | Gradient colors for logo |
| `SmartSuggestions` | true/false | History-based command predictions (local only) |
| `MatrixDuration` | 1-5 | Matrix rain duration (seconds) |
| `AnimationEnabled` | true/false | Enable all animations |
| `UpdateCheckDays` | 1+ | Days between update checks |

---

## 📦 Manual Installation

### Windows (PowerShell)
```powershell
# Download
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/PhantomStartup.ps1" -OutFile "$HOME\PhantomStartup.ps1"

# Add to profile
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Force }
Add-Content $PROFILE "`n. `"$HOME\PhantomStartup.ps1`""

# Restart terminal
```

### Linux / macOS / Termux
```bash
# Download
mkdir -p ~/.phantom-terminal
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/PhantomStartup.sh -o ~/.phantom-terminal/PhantomStartup.sh
chmod +x ~/.phantom-terminal/PhantomStartup.sh

# Add to shell profile (choose based on your shell)
# For Bash:
echo -e '\n# Phantom Terminal\nif [ -f "$HOME/.phantom-terminal/PhantomStartup.sh" ]; then\n    source "$HOME/.phantom-terminal/PhantomStartup.sh"\nfi' >> ~/.bashrc

# For Zsh:
echo -e '\n# Phantom Terminal\nif [ -f "$HOME/.phantom-terminal/PhantomStartup.sh" ]; then\n    source "$HOME/.phantom-terminal/PhantomStartup.sh"\nfi' >> ~/.zshrc

# Restart terminal or run:
source ~/.bashrc  # or ~/.zshrc
```

---

## 🗑️ Uninstall

### Windows (PowerShell)
```powershell
# Remove from profile
(Get-Content $PROFILE) -notmatch 'PhantomStartup' | Set-Content $PROFILE

# Delete files
Remove-Item "$HOME\PhantomStartup.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item "$HOME\.phantom-terminal" -Recurse -Force -ErrorAction SilentlyContinue
```

### Linux / macOS / Termux
```bash
# Remove from profile (Linux/Termux)
sed -i.bak '/PhantomStartup\|Phantom Terminal/d' ~/.bashrc
sed -i.bak '/PhantomStartup\|Phantom Terminal/d' ~/.zshrc

# Remove from profile (macOS)
sed -i '.bak' '/PhantomStartup\|Phantom Terminal/d' ~/.bashrc
sed -i '.bak' '/PhantomStartup\|Phantom Terminal/d' ~/.zshrc
sed -i '.bak' '/PhantomStartup\|Phantom Terminal/d' ~/.bash_profile

# Delete files
rm -rf ~/.phantom-terminal
```

---

## 🌍 Platform Support

Phantom Terminal supports:
- ✅ **Windows** 10/11 (PowerShell 5.1+)
- ✅ **Linux** (Bash 4.0+, various distributions)
- ✅ **macOS** (Catalina+, both Bash and Zsh)
- ✅ **Termux** (Android, optimized for mobile)

📖 **[View detailed platform support guide](PLATFORM_SUPPORT.md)** - Installation notes, requirements, and troubleshooting for each platform.

---

## 📄 License

MIT License - feel free to modify and share!

---

## 👤 Author

**@unknownlll2829** (Telegram)

GitHub: [@Unknown-2829](https://github.com/Unknown-2829)
