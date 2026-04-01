#!/usr/bin/env bash
#
# Phantom Terminal - Linux Fixed v3.6.1
# Fully working on Linux (Ubuntu/Debian/Arch/Fedora)
# Creator: @unknownlll2829 (Telegram)
# GitHub: https://github.com/Unknown-2829/Phanton-terminal
# Linux Fix: Claude (Anthropic)
#

SCRIPT_VERSION="3.6.1"
REPO_OWNER="Unknown-2829"
REPO_NAME="Phanton-terminal"
CONFIG_DIR="$HOME/.phantom-terminal"
CONFIG_FILE="$CONFIG_DIR/config.json"
CACHE_FILE="$CONFIG_DIR/cache.json"

mkdir -p "$CONFIG_DIR"

# ═══════════════════════════════════════════════════
# PLATFORM DETECTION
# ═══════════════════════════════════════════════════

detect_platform() {
    if [[ "$OSTYPE" == "linux-android"* ]] || [[ -n "${TERMUX_VERSION:-}" ]]; then
        echo "termux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
        echo "linux"
    else
        echo "linux"  # Default to linux instead of unknown
    fi
}

PLATFORM=$(detect_platform)

# ═══════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════

ESC=$'\e'
RESET="${ESC}[0m"
BOLD="${ESC}[1m"
NEON_GREEN="${ESC}[38;5;118m"
NEON_PURPLE="${ESC}[38;5;129m"
NEON_CYAN="${ESC}[38;5;87m"
ELECTRIC_BLUE="${ESC}[38;5;39m"
HOT_PINK="${ESC}[38;5;205m"
GOLD="${ESC}[38;5;220m"
BLOOD_RED="${ESC}[38;5;196m"
BRIGHT_RED="${ESC}[1;91m"
WHITE="${ESC}[1;37m"
GRAY="${ESC}[38;5;244m"
DARK_GRAY="${ESC}[38;5;240m"
SHADOW="${ESC}[38;5;235m"
YELLOW="${ESC}[38;5;226m"
ORANGE="${ESC}[38;5;208m"

# ═══════════════════════════════════════════════════
# SYMBOLS - FIX: Better terminal detection for Linux
# ═══════════════════════════════════════════════════

_supports_unicode() {
    local term_ok=false
    local locale_ok=false
    # Check TERM
    case "$TERM" in
        xterm*|rxvt*|screen*|tmux*|vte*|alacritty*|foot*|kitty*)
            term_ok=true ;;
    esac
    # Check COLORTERM
    [[ "$COLORTERM" == "truecolor" || "$COLORTERM" == "24bit" ]] && term_ok=true
    # Check locale for UTF-8
    local lc="${LC_ALL:-${LC_CTYPE:-${LANG:-}}}"
    [[ "$lc" == *UTF-8* || "$lc" == *utf8* ]] && locale_ok=true
    # If either is good, support unicode
    $term_ok || $locale_ok
}

if [[ "$PLATFORM" == "termux" ]]; then
    USE_ASCII=true
elif _supports_unicode; then
    USE_ASCII=false
else
    USE_ASCII=true
fi

if $USE_ASCII; then
    SKULL="[X]"; SHIELD="[#]"; LOCK="[=]"; KEY="[-]"
    HIGH_VOLTAGE="[!]"; BOMB="[O]"; SUCCESS="[+]"; FAILURE="[x]"
    WARNING="[!]"; PROMPT=">"; BRANCH="~"; UPDATE="[U]"
    CPU="[C]"; RAM="[R]"; HDD="[D]"
    HLINE="="; VLINE="|"; TOP_LEFT="+"; TOP_RIGHT="+"
    BOTTOM_LEFT="+"; BOTTOM_RIGHT="+"; T_LEFT="+"; T_RIGHT="+"
    BLOCK="#"; BLOCK_EMPTY="-"
else
    SKULL="☠"; SHIELD="░"; LOCK="■"; KEY="●"
    HIGH_VOLTAGE="⚡"; BOMB="◆"; SUCCESS="✔"; FAILURE="✘"
    WARNING="⚠"; PROMPT="»"; BRANCH="→"; UPDATE="↻"
    CPU="⚙"; RAM="☰"; HDD="■"
    HLINE="═"; VLINE="║"; TOP_LEFT="╔"; TOP_RIGHT="╗"
    BOTTOM_LEFT="╚"; BOTTOM_RIGHT="╝"; T_LEFT="╠"; T_RIGHT="╣"
    BLOCK="█"; BLOCK_EMPTY="░"
fi

# ═══════════════════════════════════════════════════
# CONFIG
# ═══════════════════════════════════════════════════

load_config() {
    ANIMATION_ENABLED=true
    MATRIX_DURATION=2
    MATRIX_MODE="Letters"
    SECURITY_LOAD_STEPS=8
    GLITCH_INTENSITY=3
    SHOW_SYSTEM_INFO=true
    SHOW_FULL_PATH=true
    GRADIENT_TEXT=true
    SMART_SUGGESTIONS=true
    THEME="Phantom"
    AUTO_CHECK_UPDATES=true
    SILENT_UPDATE=true
    UPDATE_CHECK_DAYS=1

    if [[ -f "$CONFIG_FILE" ]]; then
        if command -v jq &>/dev/null; then
            ANIMATION_ENABLED=$(jq -r '.AnimationEnabled // true' "$CONFIG_FILE" 2>/dev/null || echo true)
            MATRIX_DURATION=$(jq -r '.MatrixDuration // 2' "$CONFIG_FILE" 2>/dev/null || echo 2)
            MATRIX_MODE=$(jq -r '.MatrixMode // "Letters"' "$CONFIG_FILE" 2>/dev/null || echo "Letters")
            SECURITY_LOAD_STEPS=$(jq -r '.SecurityLoadSteps // 8' "$CONFIG_FILE" 2>/dev/null || echo 8)
            GLITCH_INTENSITY=$(jq -r '.GlitchIntensity // 3' "$CONFIG_FILE" 2>/dev/null || echo 3)
            SHOW_SYSTEM_INFO=$(jq -r '.ShowSystemInfo // true' "$CONFIG_FILE" 2>/dev/null || echo true)
            SHOW_FULL_PATH=$(jq -r '.ShowFullPath // true' "$CONFIG_FILE" 2>/dev/null || echo true)
            GRADIENT_TEXT=$(jq -r '.GradientText // true' "$CONFIG_FILE" 2>/dev/null || echo true)
            SMART_SUGGESTIONS=$(jq -r '.SmartSuggestions // true' "$CONFIG_FILE" 2>/dev/null || echo true)
            THEME=$(jq -r '.Theme // "Phantom"' "$CONFIG_FILE" 2>/dev/null || echo "Phantom")
            AUTO_CHECK_UPDATES=$(jq -r '.AutoCheckUpdates // true' "$CONFIG_FILE" 2>/dev/null || echo true)
            SILENT_UPDATE=$(jq -r '.SilentUpdate // true' "$CONFIG_FILE" 2>/dev/null || echo true)
            UPDATE_CHECK_DAYS=$(jq -r '.UpdateCheckDays // 1' "$CONFIG_FILE" 2>/dev/null || echo 1)
        else
            # FIX: jq-less config parsing using pure bash
            _cfg_get() { grep -o "\"$1\"[[:space:]]*:[[:space:]]*[^,}]*" "$CONFIG_FILE" 2>/dev/null | sed 's/.*:[[:space:]]*//' | tr -d '"' | tr -d ' '; }
            local v
            v=$(_cfg_get AnimationEnabled);   [[ -n "$v" ]] && ANIMATION_ENABLED="$v"
            v=$(_cfg_get MatrixDuration);      [[ -n "$v" ]] && MATRIX_DURATION="$v"
            v=$(_cfg_get MatrixMode);          [[ -n "$v" ]] && MATRIX_MODE="$v"
            v=$(_cfg_get SecurityLoadSteps);   [[ -n "$v" ]] && SECURITY_LOAD_STEPS="$v"
            v=$(_cfg_get GlitchIntensity);     [[ -n "$v" ]] && GLITCH_INTENSITY="$v"
            v=$(_cfg_get ShowSystemInfo);      [[ -n "$v" ]] && SHOW_SYSTEM_INFO="$v"
            v=$(_cfg_get ShowFullPath);        [[ -n "$v" ]] && SHOW_FULL_PATH="$v"
            v=$(_cfg_get GradientText);        [[ -n "$v" ]] && GRADIENT_TEXT="$v"
            v=$(_cfg_get Theme);               [[ -n "$v" ]] && THEME="$v"
            v=$(_cfg_get AutoCheckUpdates);    [[ -n "$v" ]] && AUTO_CHECK_UPDATES="$v"
        fi
    fi
}

save_config() {
    cat > "$CONFIG_FILE" <<EOF
{
  "AnimationEnabled": $ANIMATION_ENABLED,
  "MatrixDuration": $MATRIX_DURATION,
  "MatrixMode": "$MATRIX_MODE",
  "SecurityLoadSteps": $SECURITY_LOAD_STEPS,
  "GlitchIntensity": $GLITCH_INTENSITY,
  "ShowSystemInfo": $SHOW_SYSTEM_INFO,
  "ShowFullPath": $SHOW_FULL_PATH,
  "GradientText": $GRADIENT_TEXT,
  "SmartSuggestions": $SMART_SUGGESTIONS,
  "Theme": "$THEME",
  "AutoCheckUpdates": $AUTO_CHECK_UPDATES,
  "SilentUpdate": $SILENT_UPDATE,
  "UpdateCheckDays": $UPDATE_CHECK_DAYS
}
EOF
}

# ═══════════════════════════════════════════════════
# CACHE
# ═══════════════════════════════════════════════════

get_cache() {
    LAST_UPDATE_CHECK=""
    LATEST_VERSION=""
    UPDATE_AVAILABLE=false
    if [[ -f "$CACHE_FILE" ]]; then
        if command -v jq &>/dev/null; then
            LAST_UPDATE_CHECK=$(jq -r '.LastUpdateCheck // ""' "$CACHE_FILE" 2>/dev/null || echo "")
            LATEST_VERSION=$(jq -r '.LatestVersion // ""' "$CACHE_FILE" 2>/dev/null || echo "")
            UPDATE_AVAILABLE=$(jq -r '.UpdateAvailable // false' "$CACHE_FILE" 2>/dev/null || echo false)
        fi
    fi
}

save_cache() {
    cat > "$CACHE_FILE" <<EOF
{
  "LastUpdateCheck": "$1",
  "LatestVersion": "$2",
  "UpdateAvailable": ${3:-false}
}
EOF
}

# ═══════════════════════════════════════════════════
# THEMES
# ═══════════════════════════════════════════════════

get_phantom_logo() {
    cat << 'EOF'
 ____  _   _    _    _   _ _____ ___  __  __
|  _ \| | | |  / \  | \ | |_   _/ _ \|  \/  |
| |_) | |_| | / _ \ |  \| | | || | | | |\/| |
|  __/|  _  |/ ___ \| |\  | | || |_| | |  | |
|_|   |_| |_/_/   \_\_| \_| |_| \___/|_|  |_|
EOF
}

get_unknown_logo() {
    cat << 'EOF'
 _   _ _   _ _  ___   _  _____        ___   _
| | | | \ | | |/ / \ | |/ _ \ \      / / \ | |
| | | |  \| | ' /|  \| | | | \ \ /\ / /|  \| |
| |_| | |\  | . \| |\  | |_| |\ V  V / | |\  |
 \___/|_| \_|_|\_\_| \_|\___/  \_/\_/  |_| \_|
EOF
}

get_theme_colors() {
    case "$THEME" in
        "Unknown")
            PRIMARY="$NEON_GREEN"
            SECONDARY="$ELECTRIC_BLUE"
            ACCENT="$GOLD"
            GRADIENT_COLORS=("$NEON_GREEN" "$ELECTRIC_BLUE" "$GOLD")
            MATRIX_CHARS='UNKNOWN01?_-=+[]{}|;:,./'
            QUOTES=(
                'Hidden in plain sight...'
                'Anonymous by design.'
                'The unknown cannot be traced.'
                'Identity: NULL'
                'No name. No trace. No limits.'
                'In anonymity, we trust.'
                'The best hackers are never known.'
                'Lost in the noise, found in the code.'
            )
            TITLE="UNKNOWN TERMINAL"
            TAGLINE="Anonymous by Design"
            ;;
        *)
            PRIMARY="$NEON_PURPLE"
            SECONDARY="$NEON_CYAN"
            ACCENT="$HOT_PINK"
            GRADIENT_COLORS=("$NEON_PURPLE" "$NEON_CYAN" "$HOT_PINK")
            MATRIX_CHARS='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*'
            QUOTES=(
                'In the shadows, we code...'
                'Access denied. Until now.'
                'The system fears what it cannot control.'
                'We are the ghosts in the machine.'
                'Invisible. Untraceable. Unstoppable.'
                'Haunting the digital realm...'
                'Where others see darkness, we see opportunity.'
                'The phantom never sleeps.'
            )
            TITLE="PHANTOM TERMINAL"
            TAGLINE="Ghost in the Machine"
            ;;
    esac
}

# ═══════════════════════════════════════════════════
# TERMINAL HELPERS
# ═══════════════════════════════════════════════════

hide_cursor()   { printf '\e[?25l'; }
show_cursor()   { printf '\e[?25h'; }
clear_screen()  { clear; printf '\e[H'; }

get_terminal_size() {
    TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
    TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
    IS_SMALL_SCREEN=false
    [[ $TERM_WIDTH -lt 80 || "$PLATFORM" == "termux" ]] && IS_SMALL_SCREEN=true
}

move_cursor() { printf '\e[%d;%dH' "$1" "$2"; }

write_centered() {
    local text="$1" color="${2:-$WHITE}"
    get_terminal_size
    local clean=$(printf '%s' "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local pad=$(( (TERM_WIDTH - ${#clean}) / 2 ))
    [[ $pad -lt 0 ]] && pad=0
    printf "%${pad}s%b%s%b\n" "" "$color" "$text" "$RESET"
}

# ═══════════════════════════════════════════════════
# ANIMATIONS
# ═══════════════════════════════════════════════════

show_security_loading_bar() {
    local desc="$1" steps="${2:-8}" color="${3:-$PRIMARY}"
    for ((i=1; i<=steps; i++)); do
        local filled=$(printf "%${i}s" | tr ' ' "$BLOCK")
        local empty=$(printf "%$((steps-i))s" | tr ' ' "$BLOCK_EMPTY")
        local pct=$((i*100/steps))
        printf "\r  %b%s %b[%b%s%b%s] %b%3d%%%b" \
            "$GRAY" "$desc" "$DARK_GRAY" "$color" "$filled" \
            "$DARK_GRAY" "$empty" "$WHITE" "$pct" "$RESET"
        sleep 0.025
    done
    printf " %b%s%b\n" "$NEON_GREEN" "$SUCCESS" "$RESET"
}

show_multicolor_matrix() {
    local duration="${1:-2}"
    clear_screen
    get_terminal_size

    [[ "$IS_SMALL_SCREEN" == "true" ]] && duration=$(( duration/2 < 1 ? 1 : duration/2 ))

    local chars
    [[ "$MATRIX_MODE" == "Binary" ]] && chars="01" || chars="$MATRIX_CHARS"

    local colors=("$PRIMARY" "$SECONDARY" "$NEON_CYAN" "$ELECTRIC_BLUE")

    declare -A drops
    local col_step=1
    [[ "$IS_SMALL_SCREEN" == "true" ]] && col_step=2

    for ((i=0; i<TERM_WIDTH; i+=col_step)); do
        drops[$i]=$(( RANDOM % TERM_HEIGHT ))
    done

    local end_time=$(( SECONDS + duration ))
    local sleep_time=0.012
    [[ "$IS_SMALL_SCREEN" == "true" ]] && sleep_time=0.02

    while [[ $SECONDS -lt $end_time ]]; do
        for ((col=0; col<TERM_WIDTH; col+=col_step)); do
            local char="${chars:$(( RANDOM % ${#chars} )):1}"
            local cidx=$(( col % ${#colors[@]} ))
            local color="${colors[$cidx]}"
            local row=${drops[$col]:-1}

            if [[ $row -ge 1 && $row -lt $TERM_HEIGHT ]]; then
                move_cursor "$row" "$col"
                printf "%b%s" "$color" "$char"
                local lead=$(( row+1 ))
                if [[ $lead -lt $TERM_HEIGHT ]]; then
                    move_cursor "$lead" "$col"
                    printf "%b%s" "$WHITE" "$char"
                fi
            fi

            drops[$col]=$(( row+1 ))
            if [[ ${drops[$col]} -ge $TERM_HEIGHT && $(( RANDOM%5 )) -eq 0 ]]; then
                drops[$col]=1
            fi
        done
        sleep "$sleep_time"
    done
    printf "%b" "$RESET"
}

show_core_ignition() {
    clear_screen
    get_terminal_size
    local y=$(( TERM_HEIGHT/2 - 3 ))
    local statuses=("[CORE_INIT]" "[ENCRYPTION_KEYS]" "[FIREWALL_MATRIX]" "[AUTH_BYPASS]" "[SYSTEM_ARMED]")
    for s in "${statuses[@]}"; do
        local pad=$(( (TERM_WIDTH - ${#s} - 4) / 2 ))
        [[ $pad -lt 0 ]] && pad=0
        move_cursor "$y" 1
        printf "%${pad}s%b%s %s" "" "$BLOOD_RED" "$HIGH_VOLTAGE" "$s"
        sleep 0.05
        move_cursor "$y" 1
        printf "%${pad}s%b%s %s%b\n" "" "$PRIMARY" "$HIGH_VOLTAGE" "$s" "$RESET"
        y=$(( y+1 ))
        sleep 0.025
    done
    sleep 0.1
}

show_glitch_reveal() {
    local art="$1" color="${2:-$PRIMARY}"
    clear_screen
    get_terminal_size

    mapfile -t lines <<< "$art"

    local max_w=0
    for line in "${lines[@]}"; do [[ ${#line} -gt $max_w ]] && max_w=${#line}; done

    local sc=$(( (TERM_WIDTH - max_w) / 2 ))
    [[ $sc -lt 1 ]] && sc=1
    local sr=$(( (TERM_HEIGHT - ${#lines[@]}) / 2 ))
    [[ $sr -lt 2 ]] && sr=2

    local glitch_chars='!@#$%_+-=:;,.?/'

    for ((g=0; g<GLITCH_INTENSITY; g++)); do
        local row=$sr
        for line in "${lines[@]}"; do
            move_cursor "$row" "$sc"
            local glitched=""
            for ((i=0; i<${#line}; i++)); do
                local ch="${line:$i:1}"
                if [[ "$ch" != " " && $(( RANDOM%10 )) -lt 3 ]]; then
                    glitched+="${glitch_chars:$(( RANDOM % ${#glitch_chars} )):1}"
                else
                    glitched+="$ch"
                fi
            done
            printf "%b%s%b" "$BRIGHT_RED" "$glitched" "$RESET"
            row=$(( row+1 ))
        done
        sleep 0.035
    done

    clear_screen
    echo ""
    write_gradient_logo "$art"
    sleep 0.2
}

write_gradient_logo() {
    local art="$1"
    mapfile -t lines <<< "$art"
    get_terminal_size
    local max_w=0
    for line in "${lines[@]}"; do [[ ${#line} -gt $max_w ]] && max_w=${#line}; done
    local sc=$(( (TERM_WIDTH - max_w) / 2 ))
    [[ $sc -lt 0 ]] && sc=0
    local n=0
    for line in "${lines[@]}"; do
        local c
        if [[ "$GRADIENT_TEXT" == "true" ]]; then
            c="${GRADIENT_COLORS[$(( n % ${#GRADIENT_COLORS[@]} ))]}"
        else
            c="$PRIMARY"
        fi
        printf "%${sc}s%b%s%b\n" "" "$c" "$line" "$RESET"
        n=$(( n+1 ))
    done
}

show_security_sequence() {
    clear_screen
    echo ""; echo ""
    write_centered "$SHIELD INITIALIZING SECURITY PROTOCOLS $SHIELD" "$PRIMARY"
    echo ""
    show_security_loading_bar "$LOCK Initializing AES-256 Encryption" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Generating SHA-512 Hashes" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Activating Firewall Matrix" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Establishing Secure Channel" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    sleep 0.1
}

# ═══════════════════════════════════════════════════
# SYSTEM STATS - FIX: Reliable CPU on Linux
# ═══════════════════════════════════════════════════

get_cpu_usage_linux() {
    # Method: Read /proc/stat twice with small delay for accuracy
    if [[ ! -r /proc/stat ]]; then echo "N/A"; return; fi

    local line1 line2
    read -r line1 < /proc/stat
    sleep 0.15
    read -r line2 < /proc/stat

    local -a s1=($line1) s2=($line2)
    # s: user nice system idle iowait irq softirq (indices 1-7)
    local idle1=${s1[4]} idle2=${s2[4]}
    local total1=0 total2=0
    for ((i=1; i<=7; i++)); do
        total1=$(( total1 + ${s1[$i]:-0} ))
        total2=$(( total2 + ${s2[$i]:-0} ))
    done

    local dtotal=$(( total2 - total1 ))
    local didle=$(( idle2 - idle1 ))

    if [[ $dtotal -gt 0 ]]; then
        echo $(( (dtotal - didle) * 100 / dtotal ))
    else
        echo "N/A"
    fi
}

get_system_stats() {
    local cpu_usage="N/A" ram_usage="N/A"

    case "$PLATFORM" in
        macos)
            local idle=$(top -l 1 -n 0 2>/dev/null | grep "CPU usage" | awk '{print $7}' | sed 's/%//')
            [[ -n "$idle" ]] && cpu_usage=$(( 100 - idle ))
            if command -v vm_stat &>/dev/null; then
                local pf=$(vm_stat | awk '/Pages free/{print $3}' | sed 's/\.//')
                local pa=$(vm_stat | awk '/Pages active/{print $3}' | sed 's/\.//')
                local pi=$(vm_stat | awk '/Pages inactive/{print $3}' | sed 's/\.//')
                local pw=$(vm_stat | awk '/Pages wired/{print $4}' | sed 's/\.//')
                local tot=$(( pf+pa+pi+pw ))
                [[ $tot -gt 0 ]] && ram_usage=$(( (pa+pw)*100/tot ))
            fi
            ;;
        linux)
            cpu_usage=$(get_cpu_usage_linux)
            if [[ -r /proc/meminfo ]]; then
                local mt=$(awk '/MemTotal/{print $2}' /proc/meminfo)
                local ma=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
                [[ -n "$mt" && -n "$ma" && $mt -gt 0 ]] && ram_usage=$(( (mt-ma)*100/mt ))
            fi
            ;;
        termux)
            if [[ -r /proc/stat ]]; then
                local d=($(awk 'NR==1{print $2,$3,$4,$5}' /proc/stat))
                local tot=$(( d[0]+d[1]+d[2]+d[3] ))
                [[ $tot -gt 0 ]] && cpu_usage=$(( (tot-d[3])*100/tot ))
            fi
            if [[ -r /proc/meminfo ]]; then
                local mt=$(awk '/MemTotal/{print $2}' /proc/meminfo)
                local ma=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
                [[ -n "$mt" && -n "$ma" && $mt -gt 0 ]] && ram_usage=$(( (mt-ma)*100/mt ))
            fi
            ;;
    esac
    echo "$cpu_usage $ram_usage"
}

write_usage_bar() {
    local indent="$1" label="$2" usage="$3" width="${4:-30}"
    [[ "$usage" == "N/A" ]] && return

    local bar_color="$NEON_GREEN"
    [[ $usage -gt 80 ]] && bar_color="$BLOOD_RED"
    [[ $usage -gt 60 && $usage -le 80 ]] && bar_color="$ORANGE"

    local filled=$(( usage*width/100 ))
    [[ $filled -gt $width ]] && filled=$width
    [[ $filled -lt 0 ]] && filled=0
    local empty=$(( width-filled ))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="$BLOCK"; done
    for ((i=0; i<empty; i++)); do bar+="$BLOCK_EMPTY"; done

    printf "%s%b%s%b  %-8s%b %b%s%b %b%3d%%%b\n" \
        "$indent" "$PRIMARY" "$VLINE" \
        "$WHITE" "$label" "$RESET" \
        "$bar_color" "$bar" "$RESET" \
        "$WHITE" "$usage" "$RESET"
}

# ═══════════════════════════════════════════════════
# DASHBOARD
# ═══════════════════════════════════════════════════

show_dashboard() {
    clear_screen
    get_terminal_size

    local user="${USER:-$(whoami 2>/dev/null || echo 'user')}"
    local computer
    computer="${HOSTNAME:-$(hostname 2>/dev/null || echo 'localhost')}"
    local os
    case "$PLATFORM" in
        termux) os="Termux (Android)" ;;
        macos)  os="macOS $(sw_vers -productVersion 2>/dev/null || echo '')" ;;
        linux)  os="$(uname -s) $(uname -r 2>/dev/null | cut -d- -f1)" ;;
        *)      os="$(uname -s 2>/dev/null || echo 'Linux')" ;;
    esac
    local datetime; datetime=$(date '+%Y-%m-%d %H:%M:%S')

    local uptime_str="N/A"
    if command -v uptime &>/dev/null; then
        # FIX: uptime output varies by distro — normalize it
        local raw; raw=$(uptime 2>/dev/null)
        if echo "$raw" | grep -q 'up'; then
            uptime_str=$(echo "$raw" | sed 's/.*up[[:space:]]*//' | sed 's/,[[:space:]]*[0-9]* user.*//' | xargs)
        fi
    fi

    echo ""
    if [[ "$THEME" == "Unknown" ]]; then
        write_gradient_logo "$(get_unknown_logo)"
    else
        write_gradient_logo "$(get_phantom_logo)"
    fi
    echo ""

    local box_width=65
    [[ $TERM_WIDTH -lt 69 ]] && box_width=$(( TERM_WIDTH-4 ))
    local padding=$(( (TERM_WIDTH-box_width)/2 ))
    [[ $padding -lt 0 ]] && padding=0
    local indent; indent=$(printf "%${padding}s" "")
    local hline; hline=$(printf "%$(( box_width-2 ))s" "" | tr ' ' "$HLINE")

    echo "${indent}${PRIMARY}${TOP_LEFT}${hline}${TOP_RIGHT}${RESET}"

    local title="$SKULL $TITLE v$SCRIPT_VERSION $SKULL"
    local tpad=$(( box_width - ${#title} - 4 ))
    [[ $tpad -lt 0 ]] && tpad=0
    printf "%s%b%s %b%s%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
        "$SECONDARY" "$title" "$tpad" "" "$PRIMARY" "$VLINE" "$RESET"
    echo "${indent}${PRIMARY}${T_LEFT}${hline}${T_RIGHT}${RESET}"

    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        _info_row() {
            local lbl="$1" val="$2" valcol="$3"
            local rpad=$(( box_width - ${#lbl} - ${#val} - 5 ))
            [[ $rpad -lt 0 ]] && rpad=0
            printf "%s%b%s%b  %s%b%s%b%*s%b%s%b\n" \
                "$indent" "$PRIMARY" "$VLINE" \
                "$WHITE" "$lbl" "$valcol" "$val" "$WHITE" \
                "$rpad" "" "$PRIMARY" "$VLINE" "$RESET"
        }
        _info_row "Operator: " "$user"     "$NEON_GREEN"
        _info_row "Host:     " "$computer" "$GOLD"
        _info_row "System:   " "$os"       "$GOLD"
        _info_row "Uptime:   " "$uptime_str" "$NEON_CYAN"
        _info_row "Time:     " "$datetime" "$NEON_CYAN"
        echo "${indent}${PRIMARY}${T_LEFT}${hline}${T_RIGHT}${RESET}"

        local stats=($( get_system_stats ))
        local cpu_u="${stats[0]:-N/A}" ram_u="${stats[1]:-N/A}"
        if [[ "$cpu_u" != "N/A" || "$ram_u" != "N/A" ]]; then
            write_usage_bar "$indent" "$CPU CPU" "$cpu_u" 30
            write_usage_bar "$indent" "$RAM RAM" "$ram_u" 30
            echo "${indent}${PRIMARY}${T_LEFT}${hline}${T_RIGHT}${RESET}"
        fi
    fi

    local qi=$(( RANDOM % ${#QUOTES[@]} ))
    local quote="${QUOTES[$qi]}"
    local qpad=$(( box_width - ${#quote} - 4 ))
    [[ $qpad -lt 0 ]] && qpad=0
    printf "%s%b%s %b%s%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
        "$GRAY" "$quote" "$qpad" "" "$PRIMARY" "$VLINE" "$RESET"
    echo "${indent}${PRIMARY}${BOTTOM_LEFT}${hline}${BOTTOM_RIGHT}${RESET}"
    echo ""

    local help_cmd="phantom-help"
    [[ "$THEME" == "Unknown" ]] && help_cmd="unknown-help"
    echo "${indent}${DARK_GRAY}Type '${GOLD}${help_cmd}${DARK_GRAY}' for commands.${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════
# STARTUP
# ═══════════════════════════════════════════════════

start_phantom_terminal() {
    load_config
    get_theme_colors

    if [[ "$ANIMATION_ENABLED" != "true" ]]; then
        show_dashboard; return
    fi

    hide_cursor
    show_core_ignition
    show_security_sequence
    show_multicolor_matrix "$MATRIX_DURATION"
    if [[ "$THEME" == "Unknown" ]]; then
        show_glitch_reveal "$(get_unknown_logo)" "$PRIMARY"
    else
        show_glitch_reveal "$(get_phantom_logo)" "$PRIMARY"
    fi
    show_dashboard
    show_cursor
}

# ═══════════════════════════════════════════════════
# COMMANDS
# ═══════════════════════════════════════════════════

phantom-reload() { start_phantom_terminal; }

phantom-matrix() {
    load_config; get_theme_colors
    hide_cursor; show_multicolor_matrix 5; show_cursor
}

phantom-dash() { load_config; get_theme_colors; show_dashboard; }

phantom-help() {
    load_config; get_theme_colors
    local p="phantom"; [[ "$THEME" == "Unknown" ]] && p="unknown"
    echo ""
    echo "${NEON_CYAN}=== $TITLE v$SCRIPT_VERSION ===${RESET}"
    echo ""
    echo "  ${GOLD}${p}-reload${WHITE}   - Replay animation${RESET}"
    echo "  ${GOLD}${p}-theme${WHITE}    - Switch theme${RESET}"
    echo "  ${GOLD}${p}-config${WHITE}   - Show/edit config${RESET}"
    echo "  ${GOLD}${p}-matrix${WHITE}   - Matrix animation${RESET}"
    echo "  ${GOLD}${p}-dash${WHITE}     - Show dashboard${RESET}"
    echo "  ${GOLD}${p}-update${WHITE}   - Check updates${RESET}"
    echo ""
}

phantom-config() {
    load_config
    if [[ "$1" == "-edit" || "$1" == "--edit" ]]; then
        ${EDITOR:-nano} "$CONFIG_FILE"
    else
        echo ""
        echo "${NEON_CYAN}Config: $CONFIG_FILE${RESET}"
        echo ""
        for key in AnimationEnabled MatrixDuration MatrixMode SecurityLoadSteps GlitchIntensity ShowSystemInfo ShowFullPath GradientText Theme AutoCheckUpdates; do
            local val="${!key:-}"
            # map variable names
            case "$key" in
                AnimationEnabled) val="$ANIMATION_ENABLED" ;;
                MatrixDuration)   val="$MATRIX_DURATION" ;;
                MatrixMode)       val="$MATRIX_MODE" ;;
                SecurityLoadSteps) val="$SECURITY_LOAD_STEPS" ;;
                GlitchIntensity)  val="$GLITCH_INTENSITY" ;;
                ShowSystemInfo)   val="$SHOW_SYSTEM_INFO" ;;
                ShowFullPath)     val="$SHOW_FULL_PATH" ;;
                GradientText)     val="$GRADIENT_TEXT" ;;
                Theme)            val="$THEME" ;;
                AutoCheckUpdates) val="$AUTO_CHECK_UPDATES" ;;
            esac
            echo "  ${GOLD}$key${WHITE}: $val${RESET}"
        done
        echo ""
        echo "${DARK_GRAY}Run: phantom-config --edit${RESET}"
        echo ""
    fi
}

phantom-theme() {
    local new_theme="$1"; load_config
    if [[ -z "$new_theme" ]]; then
        echo ""; echo "${NEON_CYAN}Available themes: Phantom, Unknown${RESET}"
        echo "${GOLD}Current: $THEME${RESET}"
        echo "${DARK_GRAY}Usage: phantom-theme Unknown${RESET}"; echo ""; return
    fi
    case "${new_theme,,}" in
        unknown) THEME="Unknown"; save_config; echo "${NEON_GREEN}Theme: Unknown${RESET}" ;;
        phantom) THEME="Phantom"; save_config; echo "${NEON_GREEN}Theme: Phantom${RESET}" ;;
        *) echo "${BLOOD_RED}Unknown theme. Available: Phantom, Unknown${RESET}" ;;
    esac
    echo "${DARK_GRAY}Run 'phantom-reload' to see changes${RESET}"
}

phantom-update() {
    load_config; get_cache
    echo "${NEON_CYAN}Checking for updates...${RESET}"
    if ! command -v curl &>/dev/null; then
        echo "${BLOOD_RED}curl not found.${RESET}"; return 1
    fi

    # FIX: date -d is Linux only, date -j is macOS — handle both
    local now; now=$(date +%s)
    local cache_valid=false
    if [[ -n "$LAST_UPDATE_CHECK" ]]; then
        local lts
        if [[ "$PLATFORM" == "macos" ]]; then
            lts=$(date -j -f "%Y-%m-%d %H:%M:%S" "$LAST_UPDATE_CHECK" +%s 2>/dev/null || echo 0)
        else
            lts=$(date -d "$LAST_UPDATE_CHECK" +%s 2>/dev/null || echo 0)
        fi
        local days=$(( (now-lts)/86400 ))
        [[ $days -lt $UPDATE_CHECK_DAYS ]] && cache_valid=true
    fi

    local latest_version
    if [[ "$cache_valid" == "true" && -n "$LATEST_VERSION" ]]; then
        echo "${DARK_GRAY}Using cached result${RESET}"
        latest_version="$LATEST_VERSION"
    else
        latest_version=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" \
            | grep -o '"tag_name"[[:space:]]*:[[:space:]]*"[^"]*"' \
            | sed 's/.*"v\?\([^"]*\)".*/\1/')
        if [[ -z "$latest_version" ]]; then
            echo "${BLOOD_RED}Failed to check updates.${RESET}"; return 1
        fi
        local ct; ct=$(date '+%Y-%m-%d %H:%M:%S')
        local ua=false
        [[ "$latest_version" > "$SCRIPT_VERSION" ]] && ua=true
        save_cache "$ct" "$latest_version" "$ua"
    fi

    if [[ "$latest_version" > "$SCRIPT_VERSION" ]]; then
        echo "${GOLD}Updating to v$latest_version...${RESET}"
        local sp="$HOME/.phantom-terminal/PhantomStartup.sh"
        curl -fsSL "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/PhantomStartup.sh" -o "$sp" \
            && chmod +x "$sp" \
            && echo "${NEON_GREEN}Updated! Restart terminal.${RESET}" \
            || echo "${BLOOD_RED}Update failed.${RESET}"
    else
        echo "${NEON_GREEN}Already latest (v$SCRIPT_VERSION)${RESET}"
    fi
}

# ═══════════════════════════════════════════════════
# EASTER EGGS
# ═══════════════════════════════════════════════════

declare -a SECRETS_FOUND=()
SECRETS_FILE="$CONFIG_DIR/.secrets"
[[ -f "$SECRETS_FILE" ]] && mapfile -t SECRETS_FOUND < "$SECRETS_FILE"

save_secret() {
    local s="$1"
    if [[ ! " ${SECRETS_FOUND[*]} " =~ " ${s} " ]]; then
        SECRETS_FOUND+=("$s")
        printf "%s\n" "${SECRETS_FOUND[@]}" > "$SECRETS_FILE"
    fi
}

phantom-chosen() {
    load_config; get_theme_colors; clear_screen; echo ""; echo ""
    write_centered "╔════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║                                        ║" "$PRIMARY"
    write_centered "║     ${GOLD}✦ THE CHOSEN ONE ✦${PRIMARY}          ║" "$PRIMARY"
    write_centered "║                                        ║" "$PRIMARY"
    write_centered "╚════════════════════════════════════════╝" "$PRIMARY"
    echo ""
    write_centered "You have been granted access." "$SECONDARY"
    write_centered "Power. Knowledge. Control." "$ACCENT"
    echo ""; write_centered "The path is now open." "$GRAY"; echo ""
    save_secret "chosen"
}

phantom-2829() {
    load_config; get_theme_colors; clear_screen; hide_cursor
    echo ""; echo ""; sleep 0.3
    write_centered "Initializing..." "$DARK_GRAY"; sleep 0.5
    clear_screen; echo ""; echo ""
    write_centered "╔══════════════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║                                                  ║" "$PRIMARY"
    write_centered "║          ${NEON_PURPLE}⚡ CREATOR'S MARK ⚡${PRIMARY}                 ║" "$PRIMARY"
    write_centered "║                                                  ║" "$PRIMARY"
    write_centered "╚══════════════════════════════════════════════════╝" "$PRIMARY"
    echo ""; sleep 0.5
    write_centered "${NEON_CYAN}@unknownlll2829${RESET}" "$WHITE"; sleep 0.3
    write_centered "Master of Terminals, Architect of Code" "$GRAY"; sleep 0.3; echo ""
    write_centered "${HOT_PINK}⟨ The Phantom That Never Sleeps ⟩${RESET}" "$HOT_PINK"; sleep 0.5; echo ""
    write_centered "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$DARK_GRAY"; echo ""
    write_centered "${GOLD}\"In the shadows, we code...\"${RESET}" "$GOLD"; echo ""
    write_centered "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$DARK_GRAY"; sleep 0.5; echo ""; echo ""
    write_centered "${NEON_GREEN}✓ Secret Unlocked${RESET}" "$NEON_GREEN"; echo ""
    show_cursor; save_secret "2829"
}

phantom-secrets() {
    load_config; get_theme_colors; clear_screen; echo ""; echo ""
    write_centered "╔════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║     ${GOLD}🔍 SECRET HUNTER 🔍${PRIMARY}          ║" "$PRIMARY"
    write_centered "╚════════════════════════════════════════╝" "$PRIMARY"
    echo ""
    local total=3 found=${#SECRETS_FOUND[@]}
    write_centered "Secrets Found: ${NEON_GREEN}$found${RESET} / ${GOLD}$total${RESET}" "$WHITE"
    echo ""; echo ""
    if [[ $found -gt 0 ]]; then
        write_centered "${NEON_CYAN}━━━ Discovered ━━━${RESET}" "$NEON_CYAN"; echo ""
        for s in "${SECRETS_FOUND[@]}"; do
            case "$s" in
                chosen)  write_centered "${NEON_GREEN}✓${RESET} phantom-chosen  - The Chosen One" "$WHITE" ;;
                2829)    write_centered "${NEON_GREEN}✓${RESET} phantom-2829    - Creator's Mark"  "$WHITE" ;;
                secrets) write_centered "${NEON_GREEN}✓${RESET} phantom-secrets - You found me!"   "$WHITE" ;;
            esac
        done; echo ""
    fi
    if [[ $found -eq $total ]]; then
        write_centered "${GOLD}⚡ ACHIEVEMENT UNLOCKED ⚡${RESET}" "$GOLD"
        write_centered "Master Secret Hunter" "$ACCENT"; echo ""
        write_centered "You've discovered all hidden commands!" "$GRAY"; echo ""
    else
        write_centered "${DARK_GRAY}Hint: Hidden commands start with 'phantom-'${RESET}" "$DARK_GRAY"; echo ""
    fi
    save_secret "secrets"
}

# Unknown aliases
unknown-help()   { phantom-help;      }
unknown-reload() { phantom-reload;    }
unknown-theme()  { phantom-theme "$@";}
unknown-matrix() { phantom-matrix;    }
unknown-dash()   { phantom-dash;      }
unknown-update() { phantom-update;    }
unknown-config() { phantom-config "$@";}

# ═══════════════════════════════════════════════════
# PROMPT
# ═══════════════════════════════════════════════════

set_phantom_prompt() {
    load_config; get_theme_colors
    if [[ "$PROMPT_COMMAND" != *"phantom_prompt"* ]]; then
        phantom_prompt() {
            local last=$?
            local path_disp
            if [[ "$SHOW_FULL_PATH" == "true" ]]; then
                path_disp="$PWD"
            else
                path_disp="${PWD##*/}"; [[ -z "$path_disp" ]] && path_disp="$PWD"
            fi
            local git_branch=""
            if git rev-parse --git-dir &>/dev/null 2>&1; then
                local br; br=$(git branch --show-current 2>/dev/null)
                [[ -n "$br" ]] && git_branch=" ${DARK_GRAY}on ${HOT_PINK}${br}"
            fi
            local status_sym
            [[ $last -eq 0 ]] && status_sym="${NEON_GREEN}${SUCCESS}" || status_sym="${BLOOD_RED}${FAILURE}"
            local u="${USER:-user}"
            PS1="${PRIMARY}${u}${DARK_GRAY}@${NEON_CYAN}${path_disp}${git_branch}${RESET}\n${status_sym} ${PRIMARY}${PROMPT}${RESET} "
        }
        PROMPT_COMMAND="phantom_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
    fi
}

# ═══════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════

if [[ $- == *i* ]]; then
    set_phantom_prompt
    start_phantom_terminal
fi
