# Platform Support Guide

Phantom Terminal v3.6.0+ supports multiple platforms with optimized implementations for each.

## Supported Platforms

| Platform | Status | Script | Installer | Notes |
|----------|--------|--------|-----------|-------|
| **Windows 10/11** | ✅ Full Support | `PhantomStartup.ps1` | `install.ps1` | PowerShell 5.1+ required |
| **Linux** | ✅ Full Support | `PhantomStartup.sh` | `install.sh` | Bash 4.0+ recommended |
| **macOS** | ✅ Full Support | `PhantomStartup.sh` | `install.sh` | Works on Catalina+ |
| **Termux (Android)** | ✅ Full Support | `PhantomStartup.sh` | `install.sh` | Optimized for mobile |

---

## Installation by Platform

### Windows (PowerShell)

**Requirements:**
- Windows 10 or 11
- PowerShell 5.1 or higher
- Internet connection

**One-line install:**
```powershell
irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
```

**Features:**
- Full animation support
- PSReadLine integration for smart suggestions
- Auto-update via GitHub API
- Windows Terminal integration

---

### Linux

**Requirements:**
- Bash 4.0 or higher
- `curl` or `wget`
- Terminal with ANSI color support
- Optional: `jq` for better config parsing

**One-line install:**
```bash
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
```

**Tested distributions:**
- Ubuntu 20.04+
- Debian 10+
- Fedora 34+
- Arch Linux
- CentOS 8+

**Package managers supported:**
- apt (Debian/Ubuntu)
- yum (CentOS/RHEL)
- dnf (Fedora)
- pacman (Arch)

---

### macOS

**Requirements:**
- macOS 10.15 (Catalina) or higher
- Bash 4.0+ or Zsh
- `curl` (pre-installed)
- Terminal.app or iTerm2

**One-line install:**
```bash
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
```

**Notes:**
- Works with default macOS Terminal
- Enhanced experience with iTerm2
- Automatically detects Zsh vs Bash
- Handles `.bash_profile` vs `.bashrc` correctly

**Homebrew dependencies (optional):**
```bash
brew install jq git
```

---

### Termux (Android)

**Requirements:**
- Termux app from F-Droid (recommended) or Play Store
- Storage access (for config files)
- `curl` or `wget`

**One-line install:**
```bash
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
```

**Termux-specific optimizations:**
- ASCII fallback for better compatibility
- Adjusted animation timings for mobile CPUs
- Touch-friendly display layout
- Reduced terminal width handling
- **Performance optimizations for small screens:**
  - Matrix animation duration reduced by 50%
  - Column skipping (every other column) for smoother rendering
  - Increased frame delay to reduce CPU load
  - Auto-detection of screen size (<80 columns)

**Recommended setup:**
```bash
# Update packages
pkg update && pkg upgrade

# Install dependencies
pkg install curl git jq

# Install Phantom Terminal
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
```

**Tips:**
- Use Hacker's Keyboard for better terminal experience
- Enable "Acquire wakelock" in Termux settings to prevent sleep
- Increase font size for better visibility on small screens

---

## Feature Comparison

| Feature | Windows | Linux | macOS | Termux |
|---------|---------|-------|-------|--------|
| Matrix Animation | ✅ | ✅ | ✅ | ✅ (Optimized) |
| Binary Mode | ✅ | ✅ | ✅ | ✅ |
| Glitch Effects | ✅ | ✅ | ✅ | ✅ |
| Themes | ✅ | ✅ | ✅ | ✅ |
| Gradient Colors | ✅ | ✅ | ✅ | ✅ |
| Unicode Symbols | ✅ | ✅ | ✅ | ⚠️ ASCII fallback |
| Git Branch Detection | ✅ | ✅ | ✅ | ✅ |
| Auto-Update | ✅ | ✅ | ✅ | ✅ |
| Config Persistence | ✅ | ✅ | ✅ | ✅ |
| System Info | ✅ | ✅ | ✅ | ✅ |
| CPU/RAM Stats | ✅ | ✅ | ✅ | ✅ |
| Update Caching | ✅ | ✅ | ✅ | ✅ |
| Easter Eggs | ✅ | ✅ | ✅ | ✅ |
| Mobile Optimization | N/A | N/A | N/A | ✅ |
| Smart Suggestions | ✅ (PSReadLine) | ⚠️ Manual | ⚠️ Manual | ⚠️ Manual |

---

## Platform-Specific Notes

### Windows

**Terminal recommendations:**
1. **Windows Terminal** (best experience)
2. PowerShell 7+
3. PowerShell 5.1 (default)

**Known issues:**
- Legacy `cmd.exe` not supported (use PowerShell)
- Some Unicode symbols may not render in older terminals

### Linux

**Shell compatibility:**
- ✅ Bash 4.0+
- ✅ Bash 5.0+
- ⚠️ Bash 3.x (limited support)
- ✅ Zsh (via Bash compatibility)

**Terminal emulators tested:**
- GNOME Terminal
- Konsole
- xterm
- Alacritty
- Kitty
- Terminator

### macOS

**Shell notes:**
- macOS Catalina+ uses Zsh by default
- Installer auto-detects and configures correct shell
- Works with both `.bash_profile` and `.zshrc`

**Terminal recommendations:**
1. **iTerm2** (best experience)
2. Terminal.app (default, works well)
3. Alacritty
4. Kitty

### Termux

**Termux app sources:**
- ✅ **F-Droid** (recommended - always updated)
- ⚠️ Google Play Store (deprecated, may have issues)

**Storage setup:**
```bash
termux-setup-storage  # Grant storage permissions
```

**Performance tips:**
- Reduce `MatrixDuration` in config for faster startup
- Use Binary mode (lighter than Letters mode)
- Disable gradient text on very old devices

---

## Troubleshooting

### All Platforms

**Installation fails:**
```bash
# Try manual installation
mkdir -p ~/.phantom-terminal
curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/PhantomStartup.sh -o ~/.phantom-terminal/PhantomStartup.sh
chmod +x ~/.phantom-terminal/PhantomStartup.sh
```

**Config not persisting:**
```bash
# Check config file
cat ~/.phantom-terminal/config.json

# Reset to defaults
rm ~/.phantom-terminal/config.json
phantom-reload
```

**Animations not working:**
1. Check terminal supports ANSI colors
2. Try disabling animations: `phantom-config --edit` and set `AnimationEnabled: false`
3. Verify terminal size: `echo $COLUMNS x $LINES`

### Linux/macOS/Termux Specific

**Colors not displaying:**
```bash
# Check TERM variable
echo $TERM  # Should be xterm-256color or similar

# Set if needed
export TERM=xterm-256color
```

**Command not found:**
```bash
# Ensure script is sourced
source ~/.bashrc  # or ~/.zshrc

# Check if functions are loaded
type phantom-help
```

**sed compatibility issues:**
```bash
# For Linux/Termux - use sed -i.bak
sed -i.bak 's/old/new/' file

# For macOS - use sed -i '.bak'
sed -i '.bak' 's/old/new/' file
```

**jq not available:**
- Config will still work but uses basic parsing
- Install jq for better experience:
  - Linux: `sudo apt install jq` or `sudo yum install jq`
  - macOS: `brew install jq`
  - Termux: `pkg install jq`

### Windows Specific

**PSReadLine warnings:**
- Install PSReadLine 2.2+: `Install-Module PSReadLine -Force`
- Or disable smart suggestions in config

**Execution policy error:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## Configuration Files

All platforms use the same config format stored at:

- **Windows**: `%USERPROFILE%\.phantom-terminal\config.json`
- **Linux/macOS/Termux**: `~/.phantom-terminal/config.json`

Config is cross-platform compatible - you can copy it between systems!

---

## Contributing

Found a platform-specific issue? Please report it with:
1. Platform and version (e.g., "Ubuntu 22.04", "macOS Ventura", "Termux on Android 12")
2. Shell and version (e.g., "Bash 5.1", "Zsh 5.8")
3. Terminal emulator (e.g., "GNOME Terminal", "iTerm2")
4. Error message or unexpected behavior

---

## Future Platform Support

Under consideration:
- ⏳ FreeBSD
- ⏳ WSL2 hybrid mode (PowerShell + Bash)
- ⏳ Chrome OS (via Linux container)
- ⏳ Raspberry Pi optimizations

---

**Questions?** Open an issue on GitHub or contact [@unknownlll2829](https://t.me/unknownlll2829) on Telegram.
