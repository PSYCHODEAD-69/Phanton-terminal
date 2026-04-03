#!/usr/bin/env bash
#
# Phantom Terminal - Universal Installer v3.6.1
# Cross-platform installer with automatic platform detection
# Supports: Linux, macOS, Termux (Android)
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
#   wget -qO- https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.sh | bash
#

# Don't use set -e to allow better error handling
set -u

# ═══════════════════════════════════════════════════════════════════════════
# ERROR HANDLING
# ═══════════════════════════════════════════════════════════════════════════

# Global error flag
INSTALL_ERRORS=0

# Error handler
handle_error() {
    local msg="$1"
    echo "  ${RED}[ERROR]${R} $msg" >&2
    INSTALL_ERRORS=$((INSTALL_ERRORS + 1))
}

# Cleanup function
cleanup_on_error() {
    if [[ $INSTALL_ERRORS -gt 0 ]]; then
        echo ""
        echo "  ${RED}Installation encountered $INSTALL_ERRORS error(s).${R}"
        echo "  ${GOLD}Please check the messages above and try again.${R}"
        exit 1
    fi
}

trap cleanup_on_error EXIT

# ═══════════════════════════════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════════════════════════════

E=$'\e'
PURPLE="${E}[38;5;129m"
CYAN="${E}[38;5;87m"
GREEN="${E}[38;5;118m"
BLUE="${E}[38;5;39m"
GOLD="${E}[38;5;220m"
RED="${E}[38;5;196m"
WHITE="${E}[1;37m"
GRAY="${E}[38;5;244m"
DGRAY="${E}[38;5;240m"
R="${E}[0m"

# ═══════════════════════════════════════════════════════════════════════════
# PLATFORM DETECTION
# ═══════════════════════════════════════════════════════════════════════════

detect_platform() {
    if [[ "$OSTYPE" == "linux-android"* ]] || [[ -n "${TERMUX_VERSION:-}" ]]; then
        echo "termux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

PLATFORM=$(detect_platform)

# ═══════════════════════════════════════════════════════════════════════════
# VARIABLES
# ═══════════════════════════════════════════════════════════════════════════

REPO_URL="https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main"
CONFIG_DIR="$HOME/.phantom-terminal"
CONFIG_FILE="$CONFIG_DIR/config.json"
INSTALL_PATH="$CONFIG_DIR/PhantomStartup.sh"

# Detect shell and profile
detect_shell_profile() {
    if [[ -n "${ZSH_VERSION:-}" ]]; then
        SHELL_TYPE="zsh"
        PROFILE="$HOME/.zshrc"
    elif [[ -n "${BASH_VERSION:-}" ]]; then
        SHELL_TYPE="bash"
        if [[ "$PLATFORM" == "macos" ]]; then
            # macOS prefers .bash_profile
            [[ -f "$HOME/.bash_profile" ]] && PROFILE="$HOME/.bash_profile" || PROFILE="$HOME/.bashrc"
        else
            PROFILE="$HOME/.bashrc"
        fi
    else
        SHELL_TYPE="sh"
        PROFILE="$HOME/.profile"
    fi
}

detect_shell_profile

# ═══════════════════════════════════════════════════════════════════════════
# HEADER
# ═══════════════════════════════════════════════════════════════════════════

clear
echo ""
echo "${PURPLE}  ╔══════════════════════════════════════════════════════╗${R}"
echo "${PURPLE}  ║${CYAN}        PHANTOM TERMINAL INSTALLER v3.6.1          ${PURPLE}║${R}"
echo "${PURPLE}  ╚══════════════════════════════════════════════════════╝${R}"
echo ""

# Show detected platform
case "$PLATFORM" in
    termux)
        echo "  ${GREEN}[+]${WHITE} Platform: Termux (Android)${R}"
        ;;
    macos)
        echo "  ${GREEN}[+]${WHITE} Platform: macOS${R}"
        ;;
    linux)
        echo "  ${GREEN}[+]${WHITE} Platform: Linux${R}"
        ;;
    *)
        echo "  ${GOLD}[!]${WHITE} Platform: Unknown (trying generic install)${R}"
        ;;
esac

echo "  ${GREEN}[+]${WHITE} Shell: $SHELL_TYPE${R}"
echo "  ${GREEN}[+]${WHITE} Profile: $PROFILE${R}"

# Verify we can write to necessary locations
if [[ ! -w "$HOME" ]]; then
    handle_error "Cannot write to home directory: $HOME"
    exit 1
fi

echo ""

# Confirmation
if [[ -t 0 ]]; then
    # Interactive mode
    read -p "  ${GOLD}Continue installation? [Y/n]:${R} " confirm
    confirm=${confirm:-Y}
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "  ${RED}Installation cancelled.${R}"
        exit 0
    fi
else
    # Non-interactive mode (piped input)
    echo "  ${GOLD}Running in non-interactive mode (auto-confirming)${R}"
    confirm="Y"
fi
echo ""

# ═══════════════════════════════════════════════════════════════════════════
# LOAD EXISTING CONFIG
# ═══════════════════════════════════════════════════════════════════════════

THEME="Phantom"
MATRIX_MODE="Letters"
SHOW_FULL_PATH=true
GRADIENT_TEXT=true
AUTO_UPDATE=true
SHOW_SYSTEM_INFO=true
SMART_SUGGESTIONS=true

if [[ -f "$CONFIG_FILE" ]]; then
    echo "  ${GOLD}[*]${GRAY} Reinstalling (your settings are preserved)...${R}"

    # Try to load existing config with jq if available
    if command -v jq &> /dev/null; then
        THEME=$(jq -r '.Theme // "Phantom"' "$CONFIG_FILE" 2>/dev/null || echo "Phantom")
        MATRIX_MODE=$(jq -r '.MatrixMode // "Letters"' "$CONFIG_FILE" 2>/dev/null || echo "Letters")
        SHOW_FULL_PATH=$(jq -r '.ShowFullPath // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        GRADIENT_TEXT=$(jq -r '.GradientText // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        AUTO_UPDATE=$(jq -r '.AutoCheckUpdates // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        SHOW_SYSTEM_INFO=$(jq -r '.ShowSystemInfo // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
        SMART_SUGGESTIONS=$(jq -r '.SmartSuggestions // true' "$CONFIG_FILE" 2>/dev/null || echo "true")
    else
        # Parse manually if jq not available
        THEME=$(grep -o '"Theme"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "Phantom")
        MATRIX_MODE=$(grep -o '"MatrixMode"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" 2>/dev/null | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "Letters")
    fi

    # Clean previous profile entries
    if [[ -f "$PROFILE" ]]; then
        # Use platform-compatible sed syntax
        if [[ "$PLATFORM" == "macos" ]]; then
            sed -i '.bak' '/PhantomStartup\|Phantom Terminal/d' "$PROFILE" 2>/dev/null || true
        else
            sed -i.bak '/PhantomStartup\|Phantom Terminal/d' "$PROFILE" 2>/dev/null || true
        fi
    fi

    echo "  ${GREEN}[+]${WHITE} Ready${R}"
    echo ""
fi

# ═══════════════════════════════════════════════════════════════════════════
# INSTALLATION WIZARD
# ═══════════════════════════════════════════════════════════════════════════

# Detect if running in non-interactive mode
NON_INTERACTIVE=false
if [[ ! -t 0 ]]; then
    NON_INTERACTIVE=true
    echo "  ${GOLD}[i] Non-interactive mode: using defaults${R}"
    echo ""
fi

# Theme
echo "  ${GOLD}[1] THEME${R}"
d1="1"
[[ "$THEME" == "Unknown" ]] && d1="2"
echo "  ${PURPLE}[1] Phantom${R}  ${GREEN}[2] Unknown${R}  ${DGRAY}(current: $THEME)${R}"
if [[ "$NON_INTERACTIVE" == "false" ]]; then
    read -p "  Choice [Enter=$d1]: " choice
    choice=${choice:-$d1}
else
    choice=$d1
fi
[[ "$choice" == "2" ]] && THEME="Unknown" || THEME="Phantom"
echo "  ${GREEN}→ $THEME${R}"
echo ""

# Matrix Mode
echo "  ${GOLD}[2] MATRIX RAIN${R}"
d2="1"
[[ "$MATRIX_MODE" == "Binary" ]] && d2="2"
echo "  ${CYAN}[1] Letters${R}  ${GREEN}[2] Binary${R}  ${DGRAY}(current: $MATRIX_MODE)${R}"
if [[ "$NON_INTERACTIVE" == "false" ]]; then
    read -p "  Choice [Enter=$d2]: " choice
    choice=${choice:-$d2}
else
    choice=$d2
fi
[[ "$choice" == "2" ]] && MATRIX_MODE="Binary" || MATRIX_MODE="Letters"
echo "  ${GREEN}→ $MATRIX_MODE${R}"
echo ""

# Prompt Path
echo "  ${GOLD}[3] PROMPT PATH${R}"
d3="1"
[[ "$SHOW_FULL_PATH" == "false" ]] && d3="2"
echo "  ${CYAN}[1] Full path${R}  ${BLUE}[2] Folder only${R}  ${DGRAY}(current: $([ "$SHOW_FULL_PATH" == "true" ] && echo "Full" || echo "Folder"))${R}"
if [[ "$NON_INTERACTIVE" == "false" ]]; then
    read -p "  Choice [Enter=$d3]: " choice
    choice=${choice:-$d3}
else
    choice=$d3
fi
[[ "$choice" == "2" ]] && SHOW_FULL_PATH=false || SHOW_FULL_PATH=true
echo "  ${GREEN}→ $([ "$SHOW_FULL_PATH" == "true" ] && echo "Full path" || echo "Folder only")${R}"
echo ""

# Options
echo "  ${GOLD}[4] OPTIONS${R}"

dS="Y"
[[ "$SHOW_SYSTEM_INFO" == "false" ]] && dS="n"
if [[ "$NON_INTERACTIVE" == "false" ]]; then
    read -p "  Show system info? [Y/n, Enter=$dS]: " choice
    choice=${choice:-$dS}
else
    choice=$dS
fi
[[ "$choice" =~ ^[Nn]$ ]] && SHOW_SYSTEM_INFO=false || SHOW_SYSTEM_INFO=true

dG="Y"
[[ "$GRADIENT_TEXT" == "false" ]] && dG="n"
if [[ "$NON_INTERACTIVE" == "false" ]]; then
    read -p "  Gradient logo? [Y/n, Enter=$dG]: " choice
    choice=${choice:-$dG}
else
    choice=$dG
fi
[[ "$choice" =~ ^[Nn]$ ]] && GRADIENT_TEXT=false || GRADIENT_TEXT=true

dA="Y"
[[ "$AUTO_UPDATE" == "false" ]] && dA="n"
if [[ "$NON_INTERACTIVE" == "false" ]]; then
    read -p "  Auto-update? [Y/n, Enter=$dA]: " choice
    choice=${choice:-$dA}
else
    choice=$dA
fi
[[ "$choice" =~ ^[Nn]$ ]] && AUTO_UPDATE=false || AUTO_UPDATE=true

echo ""

# ═══════════════════════════════════════════════════════════════════════════
# INSTALL
# ═══════════════════════════════════════════════════════════════════════════

echo "  ${GOLD}═══ INSTALLING ═══${R}"
echo ""

# Check dependencies
echo "  ${CYAN}[1/4]${WHITE} Checking dependencies...${R}"

missing_deps=()
command -v curl &> /dev/null || missing_deps+=("curl")
command -v git &> /dev/null || missing_deps+=("git")

if [[ ${#missing_deps[@]} -gt 0 ]]; then
    echo "  ${GOLD}[!]${WHITE} Missing dependencies: ${missing_deps[*]}${R}"

    if [[ "$PLATFORM" == "termux" ]]; then
        echo "  ${GRAY}Installing with pkg...${R}"
        if pkg install -y "${missing_deps[@]}" 2>&1 | grep -v "^$"; then
            echo "  ${GREEN}[+]${WHITE} Dependencies installed${R}"
        else
            echo "  ${RED}[!]${WHITE} Failed to install some dependencies${R}"
            echo "  ${GOLD}[!]${WHITE} Please run manually: pkg install ${missing_deps[*]}${R}"
        fi
    elif [[ "$PLATFORM" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            echo "  ${GRAY}Installing with Homebrew...${R}"
            if brew install "${missing_deps[@]}" 2>&1 | tail -3; then
                echo "  ${GREEN}[+]${WHITE} Dependencies installed${R}"
            else
                echo "  ${RED}[!]${WHITE} Failed to install some dependencies${R}"
                echo "  ${GOLD}[!]${WHITE} Please run manually: brew install ${missing_deps[*]}${R}"
            fi
        else
            echo "  ${GOLD}[!] Please install Homebrew and run: brew install ${missing_deps[*]}${R}"
        fi
    elif [[ "$PLATFORM" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            echo "  ${GRAY}Installing with apt-get...${R}"
            if sudo apt-get update -qq 2>&1 && sudo apt-get install -y "${missing_deps[@]}" 2>&1 | tail -3; then
                echo "  ${GREEN}[+]${WHITE} Dependencies installed${R}"
            else
                echo "  ${RED}[!]${WHITE} Failed to install some dependencies${R}"
                echo "  ${GOLD}[!]${WHITE} Please run manually: sudo apt-get install ${missing_deps[*]}${R}"
            fi
        elif command -v yum &> /dev/null; then
            echo "  ${GRAY}Installing with yum...${R}"
            if sudo yum install -y "${missing_deps[@]}" 2>&1 | tail -3; then
                echo "  ${GREEN}[+]${WHITE} Dependencies installed${R}"
            else
                echo "  ${RED}[!]${WHITE} Failed to install some dependencies${R}"
                echo "  ${GOLD}[!]${WHITE} Please run manually: sudo yum install ${missing_deps[*]}${R}"
            fi
        else
            echo "  ${GOLD}[!] Please install: ${missing_deps[*]}${R}"
        fi
    fi

    # Verify dependencies are now available
    still_missing=()
    for dep in "${missing_deps[@]}"; do
        command -v "$dep" &> /dev/null || still_missing+=("$dep")
    done

    if [[ ${#still_missing[@]} -gt 0 ]]; then
        handle_error "Still missing required dependencies: ${still_missing[*]}"
        echo "  ${GOLD}Installation cannot continue without: ${still_missing[*]}${R}"
        exit 1
    fi
fi

# Install jq if not present (optional, for better config parsing)
if ! command -v jq &> /dev/null; then
    echo "  ${GRAY}[i] jq not found (optional, but recommended)${R}"
    if [[ "$PLATFORM" == "termux" ]]; then
        pkg install -y jq 2>/dev/null || true
    fi
fi

echo "  ${GREEN}[+] Dependencies checked${R}"

# Download
echo "  ${CYAN}[2/4]${WHITE} Downloading...${R}"

# Create config directory with error checking
if ! mkdir -p "$CONFIG_DIR" 2>/dev/null; then
    handle_error "Failed to create config directory: $CONFIG_DIR"
    exit 1
fi

# Download with retry logic
MAX_RETRIES=3
RETRY_COUNT=0
DOWNLOAD_SUCCESS=false

while [[ $RETRY_COUNT -lt $MAX_RETRIES ]]; do
    if curl -fsSL --connect-timeout 10 --max-time 30 "$REPO_URL/PhantomStartup.sh" -o "$INSTALL_PATH" 2>/dev/null; then
        DOWNLOAD_SUCCESS=true
        break
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [[ $RETRY_COUNT -lt $MAX_RETRIES ]]; then
            echo "  ${GOLD}[!]${WHITE} Download failed, retrying ($RETRY_COUNT/$MAX_RETRIES)...${R}"
            sleep 2
        fi
    fi
done

if [[ "$DOWNLOAD_SUCCESS" != "true" ]]; then
    handle_error "Failed to download PhantomStartup.sh after $MAX_RETRIES attempts"
    echo "  ${GOLD}[!]${WHITE} Please check your internet connection and try again${R}"
    echo "  ${GOLD}[!]${WHITE} Or download manually from: $REPO_URL/PhantomStartup.sh${R}"
    exit 1
fi

# Verify downloaded file
if [[ ! -f "$INSTALL_PATH" ]] || [[ ! -s "$INSTALL_PATH" ]]; then
    handle_error "Downloaded file is missing or empty"
    exit 1
fi

# Verify it's a valid shell script
if ! head -1 "$INSTALL_PATH" | grep -q "^#!.*bash"; then
    handle_error "Downloaded file is not a valid bash script"
    rm -f "$INSTALL_PATH"
    exit 1
fi

if ! chmod +x "$INSTALL_PATH" 2>/dev/null; then
    handle_error "Failed to make script executable"
    exit 1
fi

echo "  ${GREEN}[+] Downloaded and verified${R}"

# Profile
echo "  ${CYAN}[3/4]${WHITE} Updating profile ($PROFILE)...${R}"

# Create profile if it doesn't exist
if ! touch "$PROFILE" 2>/dev/null; then
    handle_error "Cannot write to profile: $PROFILE"
    exit 1
fi

# Check if already added to avoid duplicates
if grep -q "Phantom Terminal" "$PROFILE" 2>/dev/null; then
    echo "  ${GRAY}[i] Phantom Terminal already in profile, skipping${R}"
else
    # Create backup before modifying
    if [[ -f "$PROFILE" ]]; then
        cp "$PROFILE" "${PROFILE}.phantom-backup" 2>/dev/null || true
    fi

    # Add to profile with error checking
    if cat >> "$PROFILE" <<EOF

# Phantom Terminal
if [ -f "$INSTALL_PATH" ]; then
    source "$INSTALL_PATH"
fi
EOF
    then
        echo "  ${GREEN}[+] Profile updated${R}"
    else
        handle_error "Failed to update profile"
        # Restore backup if available
        if [[ -f "${PROFILE}.phantom-backup" ]]; then
            mv "${PROFILE}.phantom-backup" "$PROFILE" 2>/dev/null || true
        fi
        exit 1
    fi
fi

# Config
echo "  ${CYAN}[4/4]${WHITE} Saving config...${R}"

# Save config with error checking
if cat > "$CONFIG_FILE" <<EOF
{
  "AnimationEnabled": true,
  "MatrixDuration": 2,
  "MatrixMode": "$MATRIX_MODE",
  "SecurityLoadSteps": 8,
  "GlitchIntensity": 3,
  "ShowSystemInfo": $SHOW_SYSTEM_INFO,
  "ShowFullPath": $SHOW_FULL_PATH,
  "GradientText": $GRADIENT_TEXT,
  "SmartSuggestions": $SMART_SUGGESTIONS,
  "Theme": "$THEME",
  "AutoCheckUpdates": $AUTO_UPDATE,
  "SilentUpdate": true,
  "UpdateCheckDays": 1
}
EOF
then
    # Verify config is valid JSON (if jq available)
    if command -v jq &> /dev/null; then
        if ! jq . "$CONFIG_FILE" > /dev/null 2>&1; then
            handle_error "Generated invalid config JSON"
            exit 1
        fi
    fi
    echo "  ${GREEN}[+] Config saved${R}"
else
    handle_error "Failed to save config file"
    exit 1
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════════
# SUCCESS
# ═══════════════════════════════════════════════════════════════════════════

# Clear error trap for successful completion
trap - EXIT
INSTALL_ERRORS=0

echo "  ${GREEN}╔════════════════════════════════════════════════╗${R}"
echo "  ${GREEN}║${WHITE}         INSTALLATION COMPLETE!              ${GREEN}║${R}"
echo "  ${GREEN}╚════════════════════════════════════════════════╝${R}"
echo ""
echo "  ${CYAN}Restart your terminal or run:${R}"
echo "  ${WHITE}source $PROFILE${R}"
echo ""
echo "  ${GOLD}Settings:${WHITE} $THEME | $MATRIX_MODE | $([ "$SHOW_FULL_PATH" == "true" ] && echo "Full" || echo "Folder")${R}"
echo "  ${GOLD}Commands:${WHITE} ${GOLD}phantom-help${GRAY} | ${GOLD}phantom-theme${GRAY} | ${GOLD}phantom-config${R}"
echo ""

# Platform-specific notes
case "$PLATFORM" in
    termux)
        echo "  ${CYAN}[Termux] Optimized for mobile display${R}"
        echo "  ${GRAY}Consider using Hacker's Keyboard for better experience${R}"
        echo "  ${GRAY}Tip: Grant storage permission with 'termux-setup-storage'${R}"
        echo ""
        ;;
    macos)
        echo "  ${CYAN}[macOS] Works best with iTerm2 or Terminal.app${R}"
        echo ""
        ;;
esac

# Final verification
echo "  ${GRAY}Installation verified:${R}"
echo "  ${GRAY}  - Script: $INSTALL_PATH${R}"
echo "  ${GRAY}  - Config: $CONFIG_FILE${R}"
echo "  ${GRAY}  - Profile: $PROFILE${R}"
echo ""
