#!/usr/bin/env bash
#
# Phantom Terminal - Advanced Bash Startup Animation v3.6.1
# Cinematic startup animation with multiple themes, effects, and customization.
# Features: Matrix/Binary rain, gradients, themes.
#
# Creator: @unknownlll2829 (Telegram)
# GitHub: https://github.com/Unknown-2829/Phanton-terminal
# Version: 3.6.1
#
# Platforms: Linux (Ubuntu/Debian/Arch/Fedora), macOS, Termux (Android)
# Requires: bash 4.0+, standard coreutils
#
# ═══════════════════════════════════════════════════════════════════════════
# VERSION & PATHS
# ═══════════════════════════════════════════════════════════════════════════
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
    else
        echo "linux"
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
YELLOW="${ESC}[38;5;226m"
ORANGE="${ESC}[38;5;208m"

# ═══════════════════════════════════════════════════
# UNICODE DETECTION — Works on all Linux terminals
# ═══════════════════════════════════════════════════

_supports_unicode() {
    # Check TERM type
    case "${TERM:-}" in
        xterm*|rxvt*|screen*|tmux*|vte*|alacritty*|foot*|kitty*|linux) return 0 ;;
    esac
    # Check COLORTERM
    [[ "${COLORTERM:-}" == "truecolor" || "${COLORTERM:-}" == "24bit" ]] && return 0
    # Check locale
    local lc="${LC_ALL:-${LC_CTYPE:-${LANG:-}}}"
    [[ "$lc" == *UTF-8* || "$lc" == *utf8* ]] && return 0
    # Termux always supports unicode
    [[ "$PLATFORM" == "termux" ]] && return 0
    return 1
}

if _supports_unicode; then
    SKULL="☠";  SHIELD="░";  LOCK="■";   KEY="●"
    HIGH_VOLTAGE="⚡"; SUCCESS="✔"; FAILURE="✘"; WARNING="⚠"
    PROMPT="»"; BRANCH="→"
    CPU="⚙"; RAM="☰"; HDD="■"
    HLINE="═"; VLINE="║"; TOP_LEFT="╔"; TOP_RIGHT="╗"
    BOTTOM_LEFT="╚"; BOTTOM_RIGHT="╝"; T_LEFT="╠"; T_RIGHT="╣"
    BLOCK="█"; BLOCK_EMPTY="░"
else
    # ASCII fallback — same as Windows PowerShell rendering
    SKULL="[X]"; SHIELD="[#]"; LOCK="[=]"; KEY="[-]"
    HIGH_VOLTAGE="[!]"; SUCCESS="[+]"; FAILURE="[x]"; WARNING="[!]"
    PROMPT=">"; BRANCH="~"
    CPU="[C]"; RAM="[R]"; HDD="[D]"
    HLINE="="; VLINE="|"; TOP_LEFT="+"; TOP_RIGHT="+"
    BOTTOM_LEFT="+"; BOTTOM_RIGHT="+"; T_LEFT="+"; T_RIGHT="+"
    BLOCK="#"; BLOCK_EMPTY="-"
fi

# ═══════════════════════════════════════════════════
# CONFIG
# ═══════════════════════════════════════════════════

load_config() {
    ANIMATION_ENABLED=true; MATRIX_DURATION=2; MATRIX_MODE="Letters"
    SECURITY_LOAD_STEPS=8; GLITCH_INTENSITY=3; SHOW_SYSTEM_INFO=true
    SHOW_FULL_PATH=true; GRADIENT_TEXT=true; SMART_SUGGESTIONS=true
    THEME="Phantom"; AUTO_CHECK_UPDATES=true; SILENT_UPDATE=true; UPDATE_CHECK_DAYS=1

    if [[ -f "$CONFIG_FILE" ]]; then
        if command -v jq &>/dev/null; then
            ANIMATION_ENABLED=$(jq -r '.AnimationEnabled // true'  "$CONFIG_FILE" 2>/dev/null || echo true)
            MATRIX_DURATION=$(jq -r '.MatrixDuration // 2'         "$CONFIG_FILE" 2>/dev/null || echo 2)
            MATRIX_MODE=$(jq -r '.MatrixMode // "Letters"'         "$CONFIG_FILE" 2>/dev/null || echo "Letters")
            SECURITY_LOAD_STEPS=$(jq -r '.SecurityLoadSteps // 8'  "$CONFIG_FILE" 2>/dev/null || echo 8)
            GLITCH_INTENSITY=$(jq -r '.GlitchIntensity // 3'       "$CONFIG_FILE" 2>/dev/null || echo 3)
            SHOW_SYSTEM_INFO=$(jq -r '.ShowSystemInfo // true'      "$CONFIG_FILE" 2>/dev/null || echo true)
            SHOW_FULL_PATH=$(jq -r '.ShowFullPath // true'          "$CONFIG_FILE" 2>/dev/null || echo true)
            GRADIENT_TEXT=$(jq -r '.GradientText // true'           "$CONFIG_FILE" 2>/dev/null || echo true)
            SMART_SUGGESTIONS=$(jq -r '.SmartSuggestions // true'   "$CONFIG_FILE" 2>/dev/null || echo true)
            THEME=$(jq -r '.Theme // "Phantom"'                     "$CONFIG_FILE" 2>/dev/null || echo "Phantom")
            AUTO_CHECK_UPDATES=$(jq -r '.AutoCheckUpdates // true'  "$CONFIG_FILE" 2>/dev/null || echo true)
            SILENT_UPDATE=$(jq -r '.SilentUpdate // true'           "$CONFIG_FILE" 2>/dev/null || echo true)
            UPDATE_CHECK_DAYS=$(jq -r '.UpdateCheckDays // 1'       "$CONFIG_FILE" 2>/dev/null || echo 1)
        else
            # Pure bash fallback (no jq needed)
            _cfg() { grep -o "\"$1\"[[:space:]]*:[[:space:]]*[^,}]*" "$CONFIG_FILE" 2>/dev/null | sed 's/.*:[[:space:]]*//' | tr -d '" ' | head -1; }
            local v
            v=$(_cfg AnimationEnabled);  [[ -n "$v" ]] && ANIMATION_ENABLED="$v"
            v=$(_cfg MatrixDuration);    [[ -n "$v" ]] && MATRIX_DURATION="$v"
            v=$(_cfg MatrixMode);        [[ -n "$v" ]] && MATRIX_MODE="$v"
            v=$(_cfg SecurityLoadSteps); [[ -n "$v" ]] && SECURITY_LOAD_STEPS="$v"
            v=$(_cfg GlitchIntensity);   [[ -n "$v" ]] && GLITCH_INTENSITY="$v"
            v=$(_cfg ShowSystemInfo);    [[ -n "$v" ]] && SHOW_SYSTEM_INFO="$v"
            v=$(_cfg ShowFullPath);      [[ -n "$v" ]] && SHOW_FULL_PATH="$v"
            v=$(_cfg GradientText);      [[ -n "$v" ]] && GRADIENT_TEXT="$v"
            v=$(_cfg SmartSuggestions);  [[ -n "$v" ]] && SMART_SUGGESTIONS="$v"
            v=$(_cfg Theme);             [[ -n "$v" ]] && THEME="$v"
            v=$(_cfg AutoCheckUpdates);  [[ -n "$v" ]] && AUTO_CHECK_UPDATES="$v"
            v=$(_cfg SilentUpdate);      [[ -n "$v" ]] && SILENT_UPDATE="$v"
            v=$(_cfg UpdateCheckDays);   [[ -n "$v" ]] && UPDATE_CHECK_DAYS="$v"
        fi
    fi
}

save_config() {
    cat > "$CONFIG_FILE" << EOF
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
    LAST_UPDATE_CHECK=""; LATEST_VERSION=""; UPDATE_AVAILABLE=false
    if [[ -f "$CACHE_FILE" ]] && command -v jq &>/dev/null; then
        LAST_UPDATE_CHECK=$(jq -r '.LastUpdateCheck // ""' "$CACHE_FILE" 2>/dev/null || echo "")
        LATEST_VERSION=$(jq -r '.LatestVersion // ""'     "$CACHE_FILE" 2>/dev/null || echo "")
        UPDATE_AVAILABLE=$(jq -r '.UpdateAvailable // false' "$CACHE_FILE" 2>/dev/null || echo false)
    fi
}

save_cache() {
    cat > "$CACHE_FILE" << EOF
{"LastUpdateCheck":"$1","LatestVersion":"$2","UpdateAvailable":${3:-false}}
EOF
}

# ═══════════════════════════════════════════════════
# THEMES — Matching Windows version exactly
# ═══════════════════════════════════════════════════

get_phantom_logo() { cat << 'EOF'
 ____  _   _    _    _   _ _____ ___  __  __
|  _ \| | | |  / \  | \ | |_   _/ _ \|  \/  |
| |_) | |_| | / _ \ |  \| | | || | | | |\/| |
|  __/|  _  |/ ___ \| |\  | | || |_| | |  | |
|_|   |_| |_/_/   \_\_| \_| |_| \___/|_|  |_|
EOF
}

get_unknown_logo() { cat << 'EOF'
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
            PRIMARY="$NEON_GREEN"; SECONDARY="$ELECTRIC_BLUE"; ACCENT="$GOLD"
            GRADIENT_COLORS=("$GOLD" "$ELECTRIC_BLUE" "$NEON_GREEN" "$GOLD" "$ELECTRIC_BLUE")
            MATRIX_CHARS='UNKNOWN01?_-=+[]{}|;:,./'
            MATRIX_COLORS=("$ELECTRIC_BLUE" "$NEON_GREEN" "$HOT_PINK" "$NEON_CYAN" "$GOLD")
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
            TITLE="UNKNOWN TERMINAL"; TAGLINE="Anonymous by Design"
            ;;
        *)
            PRIMARY="$NEON_PURPLE"; SECONDARY="$NEON_CYAN"; ACCENT="$HOT_PINK"
            GRADIENT_COLORS=("$NEON_PURPLE" "$NEON_CYAN" "$HOT_PINK" "$NEON_PURPLE" "$NEON_CYAN")
            MATRIX_CHARS='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*'
            MATRIX_COLORS=("$NEON_PURPLE" "$NEON_CYAN" "$HOT_PINK" "$ELECTRIC_BLUE" "$NEON_GREEN")
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
            TITLE="PHANTOM TERMINAL"; TAGLINE="Ghost in the Machine"
            ;;
    esac
}

# ═══════════════════════════════════════════════════
# TERMINAL HELPERS
# ═══════════════════════════════════════════════════

hide_cursor()  { printf '\e[?25l'; }
show_cursor()  { printf '\e[?25h'; }
clear_screen() { clear; printf '\e[H'; }
move_cursor()  { printf '\e[%d;%dH' "$1" "$2"; }

get_terminal_size() {
    TERM_WIDTH=$(tput cols  2>/dev/null || echo 80)
    TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
    IS_SMALL_SCREEN=false
    [[ $TERM_WIDTH -lt 60 ]] && IS_SMALL_SCREEN=true
    # Termux: clamp minimum
    [[ "$PLATFORM" == "termux" && $TERM_WIDTH -lt 50 ]] && TERM_WIDTH=50
}

write_centered() {
    local text="$1" color="${2:-$WHITE}"
    get_terminal_size
    local clean; clean=$(printf '%s' "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local pad=$(( (TERM_WIDTH - ${#clean}) / 2 ))
    [[ $pad -lt 0 ]] && pad=0
    printf "%${pad}s%b%s%b\n" "" "$color" "$text" "$RESET"
}

# ═══════════════════════════════════════════════════
# ANIMATION: CORE IGNITION
# Windows-matching: centered red flash → primary color
# ═══════════════════════════════════════════════════

show_core_ignition() {
    clear_screen
    get_terminal_size
    local y=$(( TERM_HEIGHT / 2 - 3 ))
    [[ $y -lt 1 ]] && y=1
    local statuses=("[CORE_INIT]" "[ENCRYPTION_KEYS]" "[FIREWALL_MATRIX]" "[AUTH_BYPASS]" "[SYSTEM_ARMED]")
    for s in "${statuses[@]}"; do
        local pad=$(( (TERM_WIDTH - ${#s} - 4) / 2 ))
        [[ $pad -lt 0 ]] && pad=0
        move_cursor "$y" 1
        printf "%${pad}s%b%s %s%b" "" "$BLOOD_RED" "$HIGH_VOLTAGE" "$s" "$RESET"
        sleep 0.06
        move_cursor "$y" 1
        printf "%${pad}s%b%s %s%b\n" "" "$PRIMARY" "$HIGH_VOLTAGE" "$s" "$RESET"
        y=$(( y + 1 ))
        sleep 0.04
    done
    sleep 0.15
}

# ═══════════════════════════════════════════════════
# ANIMATION: SECURITY LOADING BARS
# Windows-matching: animated fill blocks with %
# ═══════════════════════════════════════════════════

show_security_loading_bar() {
    local desc="$1" steps="${2:-8}" color="${3:-$PRIMARY}"
    local bar_w=$steps
    # Adjust for small screens
    [[ "$IS_SMALL_SCREEN" == "true" ]] && bar_w=$(( steps / 2 ))
    [[ $bar_w -lt 4 ]] && bar_w=4

    for ((i=1; i<=bar_w; i++)); do
        local filled; filled=$(printf "%${i}s" | tr ' ' "$BLOCK")
        local empty;  empty=$(printf "%$(( bar_w - i ))s" | tr ' ' "$BLOCK_EMPTY")
        local pct=$(( i * 100 / bar_w ))
        printf "\r  %b%s %b[%b%s%b%s] %b%3d%%%b" \
            "$GRAY" "$desc" \
            "$DARK_GRAY" "$color" "$filled" \
            "$DARK_GRAY" "$empty" \
            "$WHITE" "$pct" "$RESET"
        sleep 0.028
    done
    printf " %b%s%b\n" "$NEON_GREEN" "$SUCCESS" "$RESET"
}

show_security_sequence() {
    clear_screen; echo ""; echo ""
    write_centered "$SHIELD INITIALIZING SECURITY PROTOCOLS $SHIELD" "$PRIMARY"
    echo ""
    show_security_loading_bar "$LOCK Initializing AES-256 Encryption"  "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Generating SHA-512 Hashes"         "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Activating Firewall Matrix"        "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Establishing Secure Channel"       "$SECURITY_LOAD_STEPS" "$PRIMARY"
    sleep 0.15
}

# ═══════════════════════════════════════════════════
# ANIMATION: MATRIX RAIN
# Windows-matching: sparse columns, multi-color,
# lead char bright white, fade trail
# ═══════════════════════════════════════════════════

show_multicolor_matrix() {
    local duration="${1:-2}"
    clear_screen
    get_terminal_size

    # Performance tuning per platform
    local col_step=2   # sparse like Windows
    local sleep_time=0.035
    case "$PLATFORM" in
        termux)
            col_step=3; sleep_time=0.055
            duration=$(( duration > 2 ? 2 : duration ))
            ;;
        macos)
            col_step=2; sleep_time=0.030
            ;;
        linux)
            col_step=2; sleep_time=0.030
            ;;
    esac
    [[ "$IS_SMALL_SCREEN" == "true" ]] && { col_step=3; sleep_time=0.055; }

    local chars
    [[ "$MATRIX_MODE" == "Binary" ]] && chars="01" || chars="$MATRIX_CHARS"

    # Initialize drops at random positions (sparse = more empty space like Windows)
    declare -A drops
    for ((col=0; col<TERM_WIDTH; col+=col_step)); do
        drops[$col]=$(( RANDOM % TERM_HEIGHT + 1 ))
    done

    local end_time=$(( SECONDS + duration ))

    while [[ $SECONDS -lt $end_time ]]; do
        # Only update ~60% of columns each frame = sparse feel
        for ((col=0; col<TERM_WIDTH; col+=col_step)); do
            # Skip some columns randomly for sparse effect
            [[ $(( RANDOM % 10 )) -lt 3 ]] && continue

            local char="${chars:$(( RANDOM % ${#chars} )):1}"
            local cidx=$(( col % ${#MATRIX_COLORS[@]} ))
            local color="${MATRIX_COLORS[$cidx]}"
            local row=${drops[$col]:-1}

            if [[ $row -ge 1 && $row -lt $TERM_HEIGHT ]]; then
                # Main char
                move_cursor "$row" "$col"
                printf "%b%s%b" "$color" "$char" "$RESET"

                # Bright lead char (1 below) — Windows style
                local lead=$(( row + 1 ))
                if [[ $lead -lt $TERM_HEIGHT ]]; then
                    move_cursor "$lead" "$col"
                    printf "%b%s%b" "$WHITE" "$char" "$RESET"
                fi

                # Dim trail (fade effect, 2 below)
                local trail=$(( row - 2 ))
                if [[ $trail -ge 1 ]]; then
                    move_cursor "$trail" "$col"
                    printf "%b%s%b" "$DARK_GRAY" "$char" "$RESET"
                fi
            fi

            drops[$col]=$(( row + 1 ))
            # Reset when hit bottom — random chance for sparse look
            if [[ ${drops[$col]} -ge $TERM_HEIGHT ]]; then
                [[ $(( RANDOM % 4 )) -eq 0 ]] && drops[$col]=1 || drops[$col]=$(( TERM_HEIGHT + RANDOM % 8 ))
            fi
        done
        sleep "$sleep_time"
    done
    printf "%b" "$RESET"
}

# ═══════════════════════════════════════════════════
# ANIMATION: GLITCH REVEAL
# Windows-matching: red scramble → gradient logo appear
# ═══════════════════════════════════════════════════

show_glitch_reveal() {
    local art="$1"
    clear_screen
    get_terminal_size

    mapfile -t lines <<< "$art"
    local max_w=0
    for line in "${lines[@]}"; do [[ ${#line} -gt $max_w ]] && max_w=${#line}; done

    local sc=$(( (TERM_WIDTH - max_w) / 2 ))
    [[ $sc -lt 1 ]] && sc=1
    local sr=$(( (TERM_HEIGHT - ${#lines[@]}) / 2 - 1 ))
    [[ $sr -lt 2 ]] && sr=2

    local glitch_chars='!@#$%_+-=:;,.?/\\|~^'

    # Phase 1: Red scramble (glitch)
    for ((g=0; g<GLITCH_INTENSITY; g++)); do
        local row=$sr
        for line in "${lines[@]}"; do
            move_cursor "$row" "$sc"
            local out=""
            for ((i=0; i<${#line}; i++)); do
                local ch="${line:$i:1}"
                if [[ "$ch" != " " && $(( RANDOM % 10 )) -lt 4 ]]; then
                    out+="${glitch_chars:$(( RANDOM % ${#glitch_chars} )):1}"
                else
                    out+="$ch"
                fi
            done
            printf "%b%s%b" "$BRIGHT_RED" "$out" "$RESET"
            row=$(( row + 1 ))
        done
        sleep 0.04
    done

    # Phase 2: Clean gradient reveal
    clear_screen; echo ""
    write_gradient_logo "$art"
    sleep 0.25
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
        n=$(( n + 1 ))
    done
}

# ═══════════════════════════════════════════════════
# SYSTEM STATS
# Linux: /proc/stat dual-read (accurate)
# macOS: vm_stat + top
# Termux: /proc/stat single-read
# ═══════════════════════════════════════════════════

_cpu_linux() {
    [[ ! -r /proc/stat ]] && echo "N/A" && return
    local l1 l2
    read -r l1 < /proc/stat; sleep 0.1; read -r l2 < /proc/stat
    local -a a=($l1) b=($l2)
    local t1=0 t2=0
    for ((i=1;i<=7;i++)); do t1=$(( t1+${a[$i]:-0} )); t2=$(( t2+${b[$i]:-0} )); done
    local dt=$(( t2-t1 )) di=$(( ${b[4]:-0}-${a[4]:-0} ))
    [[ $dt -gt 0 ]] && echo $(( (dt-di)*100/dt )) || echo "N/A"
}

get_system_stats() {
    local cpu="N/A" ram="N/A"
    case "$PLATFORM" in
        macos)
            local idle; idle=$(top -l 1 -n 0 2>/dev/null | awk '/CPU usage/{gsub(/%/,"",$7); print $7}')
            [[ -n "$idle" && "$idle" =~ ^[0-9]+$ ]] && cpu=$(( 100 - idle ))
            if command -v vm_stat &>/dev/null; then
                local pf pa pi pw
                pf=$(vm_stat 2>/dev/null | awk '/Pages free/{gsub(/\./,"",$3); print $3}')
                pa=$(vm_stat 2>/dev/null | awk '/Pages active/{gsub(/\./,"",$3); print $3}')
                pi=$(vm_stat 2>/dev/null | awk '/Pages inactive/{gsub(/\./,"",$3); print $3}')
                pw=$(vm_stat 2>/dev/null | awk '/Pages wired/{gsub(/\./,"",$4); print $4}')
                local tot=$(( ${pf:-0}+${pa:-0}+${pi:-0}+${pw:-0} ))
                [[ $tot -gt 0 ]] && ram=$(( (${pa:-0}+${pw:-0})*100/tot ))
            fi
            ;;
        linux)
            cpu=$(_cpu_linux)
            if [[ -r /proc/meminfo ]]; then
                local mt; mt=$(awk '/MemTotal/{print $2}' /proc/meminfo)
                local ma; ma=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
                [[ -n "$mt" && -n "$ma" && $mt -gt 0 ]] && ram=$(( (mt-ma)*100/mt ))
            fi
            ;;
        termux)
            if [[ -r /proc/stat ]]; then
                local d; d=($(awk 'NR==1{print $2,$3,$4,$5}' /proc/stat))
                local tot=$(( ${d[0]:-0}+${d[1]:-0}+${d[2]:-0}+${d[3]:-0} ))
                [[ $tot -gt 0 ]] && cpu=$(( (tot-${d[3]:-0})*100/tot ))
            fi
            if [[ -r /proc/meminfo ]]; then
                local mt; mt=$(awk '/MemTotal/{print $2}' /proc/meminfo)
                local ma; ma=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
                [[ -n "$mt" && -n "$ma" && $mt -gt 0 ]] && ram=$(( (mt-ma)*100/mt ))
            fi
            ;;
    esac
    echo "$cpu $ram"
}

write_usage_bar() {
    local indent="$1" label="$2" usage="$3" width="${4:-28}"
    [[ "$usage" == "N/A" ]] && return
    local bc="$NEON_GREEN"
    [[ $usage -gt 80 ]] && bc="$BLOOD_RED"
    [[ $usage -gt 60 && $usage -le 80 ]] && bc="$ORANGE"
    local filled=$(( usage * width / 100 ))
    [[ $filled -gt $width ]] && filled=$width
    local empty=$(( width - filled ))
    local bar=""; for ((i=0;i<filled;i++)); do bar+="$BLOCK"; done
    for ((i=0;i<empty;i++)); do bar+="$BLOCK_EMPTY"; done
    printf "%s%b%s%b  %-7s%b %b%s%b %b%3d%%%b\n" \
        "$indent" "$PRIMARY" "$VLINE" \
        "$WHITE" "$label" "$RESET" \
        "$bc" "$bar" "$RESET" \
        "$WHITE" "$usage" "$RESET"
}

# ═══════════════════════════════════════════════════
# DASHBOARD — Matching Windows layout exactly
# ═══════════════════════════════════════════════════

show_dashboard() {
    clear_screen
    get_terminal_size

    local user="${USER:-$(whoami 2>/dev/null || echo 'user')}"
    local host="${HOSTNAME:-$(hostname 2>/dev/null || echo 'localhost')}"
    # Trim domain from hostname
    host="${host%%.*}"

    local os
    case "$PLATFORM" in
        termux) os="Termux (Android)" ;;
        macos)  os="macOS $(sw_vers -productVersion 2>/dev/null)" ;;
        linux)
            # Try to get distro name like Windows shows "Microsoft Windows 11 Pro"
            if [[ -f /etc/os-release ]]; then
                os=$(. /etc/os-release && echo "${PRETTY_NAME:-Linux}")
            else
                os="$(uname -s) $(uname -r | cut -d- -f1)"
            fi
            ;;
        *)      os="$(uname -s 2>/dev/null || echo 'Linux')" ;;
    esac

    local datetime; datetime=$(date '+%Y-%m-%d %H:%M:%S')

    # Uptime — normalized across distros
    local uptime_str="N/A"
    if [[ -r /proc/uptime ]]; then
        local secs; secs=$(awk '{print int($1)}' /proc/uptime)
        local d=$(( secs/86400 )) h=$(( (secs%86400)/3600 )) m=$(( (secs%3600)/60 ))
        if [[ $d -gt 0 ]]; then
            uptime_str="${d}d ${h}h ${m}m"
        else
            uptime_str="${h}h ${m}m"
        fi
    elif command -v uptime &>/dev/null; then
        local raw; raw=$(uptime 2>/dev/null)
        echo "$raw" | grep -q 'up' && uptime_str=$(echo "$raw" | sed 's/.*up[[:space:]]*//' | sed 's/,[[:space:]]*[0-9]* user.*//' | xargs)
    fi

    # Logo
    echo ""
    if [[ "$THEME" == "Unknown" ]]; then
        write_gradient_logo "$(get_unknown_logo)"
    else
        write_gradient_logo "$(get_phantom_logo)"
    fi
    echo ""

    # Box dimensions
    local box_width=67
    local min_w=$(( ${#TITLE} + 12 ))
    [[ $box_width -lt $min_w ]] && box_width=$min_w
    [[ $TERM_WIDTH -lt $(( box_width + 4 )) ]] && box_width=$(( TERM_WIDTH - 4 ))
    [[ $box_width -lt 30 ]] && box_width=30

    local padding=$(( (TERM_WIDTH - box_width) / 2 ))
    [[ $padding -lt 0 ]] && padding=0
    local ind; ind=$(printf "%${padding}s" "")
    local hln; hln=$(printf "%$(( box_width - 2 ))s" "" | tr ' ' "$HLINE")

    # Helper: print a box row with label + value
    _row() {
        local lbl="$1" val="$2" vc="$3"
        local inner=$(( box_width - 2 ))
        local content="  ${lbl}${val}"
        local rpad=$(( inner - ${#content} ))
        if [[ $rpad -lt 0 ]]; then
            local truncate_len=$(( ${#val} + rpad ))
            [[ $truncate_len -lt 0 ]] && truncate_len=0
            val="${val:0:$truncate_len}"
            rpad=0
        fi
        printf "%s%b%s%b  %b%s%b%b%s%b%*s%b%s%b\n" \
            "$ind" "$PRIMARY" "$VLINE" \
            "$WHITE" "$WHITE" "$lbl" "$RESET" \
            "$vc" "$val" "$RESET" \
            "$rpad" "" \
            "$PRIMARY" "$VLINE" "$RESET"
    }

    # Top border
    printf "%s%b%s%s%s%b\n" "$ind" "$PRIMARY" "$TOP_LEFT" "$hln" "$TOP_RIGHT" "$RESET"

    # Title row
    local title_str="$SKULL $TITLE v$SCRIPT_VERSION $SKULL"
    local inner=$(( box_width - 2 ))
    local tpad=$(( inner - ${#title_str} - 1 ))
    [[ $tpad -lt 0 ]] && tpad=0
    printf "%s%b%s %b%s%*s%b%s%b\n" \
        "$ind" "$PRIMARY" "$VLINE" \
        "$SECONDARY" "$title_str" \
        "$tpad" "" \
        "$PRIMARY" "$VLINE" "$RESET"

    printf "%s%b%s%s%s%b\n" "$ind" "$PRIMARY" "$T_LEFT" "$hln" "$T_RIGHT" "$RESET"

    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        _row "Operator: " "$user"        "$NEON_GREEN"
        _row "Host:     " "$host"        "$GOLD"
        _row "System:   " "$os"          "$GOLD"
        _row "Uptime:   " "$uptime_str"  "$NEON_CYAN"
        _row "Time:     " "$datetime"    "$NEON_CYAN"

        printf "%s%b%s%s%s%b\n" "$ind" "$PRIMARY" "$T_LEFT" "$hln" "$T_RIGHT" "$RESET"

        # CPU + RAM bars
        local stats; stats=($( get_system_stats ))
        local cpu_u="${stats[0]:-N/A}" ram_u="${stats[1]:-N/A}"
        if [[ "$cpu_u" != "N/A" || "$ram_u" != "N/A" ]]; then
            local bar_w=$(( box_width - 20 ))
            [[ $bar_w -lt 10 ]] && bar_w=10
            [[ "$cpu_u" != "N/A" ]] && write_usage_bar "$ind" "$CPU CPU" "$cpu_u" "$bar_w"
            [[ "$ram_u" != "N/A" ]] && write_usage_bar "$ind" "$RAM RAM" "$ram_u" "$bar_w"
            printf "%s%b%s%s%s%b\n" "$ind" "$PRIMARY" "$T_LEFT" "$hln" "$T_RIGHT" "$RESET"
        fi
    fi

    # Quote row
    local qi=$(( RANDOM % ${#QUOTES[@]} ))
    local quote="${QUOTES[$qi]}"
    local inner=$(( box_width - 2 ))
    local qpad=$(( inner - ${#quote} - 2 ))
    [[ $qpad -lt 0 ]] && { quote="${quote:0:$(( ${#quote} + qpad ))}"; qpad=0; }
    printf "%s%b%s %b%s%*s%b%s%b\n" \
        "$ind" "$PRIMARY" "$VLINE" \
        "$GRAY" "$quote" \
        "$qpad" "" \
        "$PRIMARY" "$VLINE" "$RESET"

    # Bottom border
    printf "%s%b%s%s%s%b\n" "$ind" "$PRIMARY" "$BOTTOM_LEFT" "$hln" "$BOTTOM_RIGHT" "$RESET"
    echo ""

    local help_cmd="phantom-help"
    [[ "$THEME" == "Unknown" ]] && help_cmd="unknown-help"
    printf "%s%b%s%b\n" "$ind" "$DARK_GRAY" \
        "Type '${GOLD}${help_cmd}${DARK_GRAY}' for commands." "$RESET"
    echo ""
}

# ═══════════════════════════════════════════════════
# MAIN STARTUP SEQUENCE
# ═══════════════════════════════════════════════════

start_phantom_terminal() {
    load_config
    get_theme_colors

    [[ "$ANIMATION_ENABLED" != "true" ]] && { show_dashboard; return; }

    hide_cursor
    show_core_ignition
    show_security_sequence
    show_multicolor_matrix "$MATRIX_DURATION"
    if [[ "$THEME" == "Unknown" ]]; then
        show_glitch_reveal "$(get_unknown_logo)"
    else
        show_glitch_reveal "$(get_phantom_logo)"
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
    echo "  ${GOLD}${p}-theme${WHITE}    - Switch theme (Phantom/Unknown)${RESET}"
    echo "  ${GOLD}${p}-config${WHITE}   - Show config${RESET}"
    echo "  ${GOLD}${p}-config --edit${WHITE} - Edit config${RESET}"
    echo "  ${GOLD}${p}-matrix${WHITE}   - Matrix rain animation${RESET}"
    echo "  ${GOLD}${p}-dash${WHITE}     - Show dashboard${RESET}"
    echo "  ${GOLD}${p}-update${WHITE}   - Check for updates${RESET}"
    echo ""
    echo "  ${GRAY}Hidden commands: ${p}-chosen, ${p}-2829, ${p}-secrets${RESET}"
    echo ""
}

phantom-config() {
    load_config
    if [[ "$1" == "-edit" || "$1" == "--edit" ]]; then
        ${EDITOR:-nano} "$CONFIG_FILE"
        return
    fi
    echo ""
    echo "${NEON_CYAN}Config: $CONFIG_FILE${RESET}"; echo ""
    echo "  ${GOLD}Theme${WHITE}: $THEME${RESET}"
    echo "  ${GOLD}AnimationEnabled${WHITE}: $ANIMATION_ENABLED${RESET}"
    echo "  ${GOLD}MatrixMode${WHITE}: $MATRIX_MODE  ${GRAY}(Letters/Binary)${RESET}"
    echo "  ${GOLD}MatrixDuration${WHITE}: $MATRIX_DURATION${RESET}"
    echo "  ${GOLD}SecurityLoadSteps${WHITE}: $SECURITY_LOAD_STEPS${RESET}"
    echo "  ${GOLD}GlitchIntensity${WHITE}: $GLITCH_INTENSITY  ${GRAY}(0-5)${RESET}"
    echo "  ${GOLD}ShowSystemInfo${WHITE}: $SHOW_SYSTEM_INFO${RESET}"
    echo "  ${GOLD}GradientText${WHITE}: $GRADIENT_TEXT${RESET}"
    echo "  ${GOLD}AutoCheckUpdates${WHITE}: $AUTO_CHECK_UPDATES${RESET}"
    echo ""
    echo "${DARK_GRAY}phantom-config --edit  to change settings${RESET}"; echo ""
}

phantom-theme() {
    local t="$1"; load_config
    if [[ -z "$t" ]]; then
        echo ""; echo "${NEON_CYAN}Themes: Phantom, Unknown${RESET}"
        echo "${GOLD}Current: $THEME${RESET}"
        echo "${DARK_GRAY}Usage: phantom-theme Unknown${RESET}"; echo ""; return
    fi
    case "${t,,}" in
        unknown) THEME="Unknown" ;;
        phantom) THEME="Phantom" ;;
        *) echo "${BLOOD_RED}Available: Phantom, Unknown${RESET}"; return ;;
    esac
    save_config
    echo "${NEON_GREEN}Theme set to: $THEME${RESET}"
    echo "${DARK_GRAY}Run 'phantom-reload' to apply${RESET}"
}

phantom-update() {
    load_config; get_cache
    echo "${NEON_CYAN}Checking for updates...${RESET}"
    command -v curl &>/dev/null || { echo "${BLOOD_RED}curl not found.${RESET}"; return 1; }

    # Date handling: Linux uses -d, macOS uses -j
    local now; now=$(date +%s)
    local cache_valid=false
    if [[ -n "$LAST_UPDATE_CHECK" ]]; then
        local lts
        if [[ "$PLATFORM" == "macos" ]]; then
            lts=$(date -j -f "%Y-%m-%d %H:%M:%S" "$LAST_UPDATE_CHECK" +%s 2>/dev/null || echo 0)
        else
            lts=$(date -d "$LAST_UPDATE_CHECK" +%s 2>/dev/null || echo 0)
        fi
        [[ $(( (now - lts) / 86400 )) -lt $UPDATE_CHECK_DAYS ]] && cache_valid=true
    fi

    local latest
    if [[ "$cache_valid" == "true" && -n "$LATEST_VERSION" ]]; then
        latest="$LATEST_VERSION"; echo "${DARK_GRAY}Using cached result${RESET}"
    else
        latest=$(curl -sf "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" \
            | grep -o '"tag_name"[[:space:]]*:[[:space:]]*"[^"]*"' \
            | sed 's/.*"v\?\([^"]*\)".*/\1/')
        [[ -z "$latest" ]] && { echo "${BLOOD_RED}Update check failed.${RESET}"; return 1; }
        local ua=false; [[ "$latest" > "$SCRIPT_VERSION" ]] && ua=true
        save_cache "$(date '+%Y-%m-%d %H:%M:%S')" "$latest" "$ua"
    fi

    if [[ "$latest" > "$SCRIPT_VERSION" ]]; then
        echo "${GOLD}Updating to v$latest...${RESET}"
        local sp="$HOME/.phantom-terminal/PhantomStartup.sh"
        curl -fsSL "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/PhantomStartup.sh" \
            -o "$sp" && chmod +x "$sp" \
            && echo "${NEON_GREEN}Updated! Restart terminal to apply.${RESET}" \
            || echo "${BLOOD_RED}Update failed.${RESET}"
    else
        echo "${NEON_GREEN}Already on latest version (v$SCRIPT_VERSION)${RESET}"
    fi
}

# ═══════════════════════════════════════════════════
# EASTER EGGS
# ═══════════════════════════════════════════════════

SECRETS_FILE="$CONFIG_DIR/.secrets"
declare -a SECRETS_FOUND=()
[[ -f "$SECRETS_FILE" ]] && mapfile -t SECRETS_FOUND < "$SECRETS_FILE"

_save_secret() {
    [[ " ${SECRETS_FOUND[*]} " =~ " $1 " ]] && return
    SECRETS_FOUND+=("$1")
    printf '%s\n' "${SECRETS_FOUND[@]}" > "$SECRETS_FILE"
}

phantom-chosen() {
    load_config; get_theme_colors; clear_screen; echo ""; echo ""
    write_centered "╔════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║     ${GOLD}✦ THE CHOSEN ONE ✦${PRIMARY}          ║" "$PRIMARY"
    write_centered "╚════════════════════════════════════════╝" "$PRIMARY"
    echo ""
    write_centered "You have been granted access." "$SECONDARY"
    write_centered "Power. Knowledge. Control." "$ACCENT"
    echo ""; write_centered "The path is now open." "$GRAY"; echo ""
    _save_secret "chosen"
}

phantom-2829() {
    load_config; get_theme_colors; clear_screen; hide_cursor
    echo ""; sleep 0.3
    write_centered "Initializing..." "$DARK_GRAY"; sleep 0.6; clear_screen; echo ""
    write_centered "╔══════════════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║         ${NEON_PURPLE}⚡ CREATOR'S MARK ⚡${PRIMARY}                  ║" "$PRIMARY"
    write_centered "╚══════════════════════════════════════════════════╝" "$PRIMARY"
    echo ""; sleep 0.4
    write_centered "${NEON_CYAN}@unknownlll2829${RESET}" "$WHITE"; sleep 0.3
    write_centered "Master of Terminals, Architect of Code" "$GRAY"; echo ""
    write_centered "${HOT_PINK}⟨ The Phantom That Never Sleeps ⟩${RESET}" "$HOT_PINK"; echo ""
    write_centered "${GOLD}\"In the shadows, we code...\"${RESET}" "$GOLD"; echo ""
    write_centered "${NEON_GREEN}✓ Secret Unlocked${RESET}" "$NEON_GREEN"; echo ""
    show_cursor; _save_secret "2829"
}

phantom-secrets() {
    load_config; get_theme_colors; clear_screen; echo ""
    write_centered "╔════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║      ${GOLD}🔍 SECRET HUNTER 🔍${PRIMARY}          ║" "$PRIMARY"
    write_centered "╚════════════════════════════════════════╝" "$PRIMARY"
    echo ""
    local total=3 found=${#SECRETS_FOUND[@]}
    write_centered "Found: ${NEON_GREEN}$found${RESET} / ${GOLD}$total${RESET}" "$WHITE"; echo ""
    if [[ $found -gt 0 ]]; then
        for s in "${SECRETS_FOUND[@]}"; do
            case "$s" in
                chosen)  write_centered "${NEON_GREEN}✓${RESET} phantom-chosen  - The Chosen One" "$WHITE" ;;
                2829)    write_centered "${NEON_GREEN}✓${RESET} phantom-2829    - Creator's Mark"  "$WHITE" ;;
                secrets) write_centered "${NEON_GREEN}✓${RESET} phantom-secrets - You found me!"   "$WHITE" ;;
            esac
        done; echo ""
    fi
    [[ $found -eq $total ]] && {
        write_centered "${GOLD}⚡ ACHIEVEMENT UNLOCKED — Master Secret Hunter ⚡${RESET}" "$GOLD"; echo ""
    } || write_centered "${DARK_GRAY}Hint: try phantom-chosen, phantom-2829${RESET}" "$DARK_GRAY"
    echo ""
    _save_secret "secrets"
}

# Unknown theme aliases
unknown-help()   { phantom-help;       }
unknown-reload() { phantom-reload;     }
unknown-theme()  { phantom-theme  "$@";}
unknown-matrix() { phantom-matrix;     }
unknown-dash()   { phantom-dash;       }
unknown-update() { phantom-update;     }
unknown-config() { phantom-config "$@";}

# ═══════════════════════════════════════════════════
# CUSTOM PROMPT — Colored, git-aware
# ═══════════════════════════════════════════════════

set_phantom_prompt() {
    load_config; get_theme_colors
    [[ "$PROMPT_COMMAND" == *"_phantom_ps1"* ]] && return

    _phantom_ps1() {
        local s=$?
        local path_d
        if [[ "$SHOW_FULL_PATH" == "true" ]]; then
            path_d="$PWD"
        else
            path_d="${PWD##*/}"; [[ -z "$path_d" ]] && path_d="/"
        fi
        local git_b=""
        if git rev-parse --git-dir &>/dev/null 2>&1; then
            local br; br=$(git branch --show-current 2>/dev/null)
            [[ -n "$br" ]] && git_b=" ${DARK_GRAY}on ${HOT_PINK}${br}${RESET}"
        fi
        local sym; [[ $s -eq 0 ]] && sym="${NEON_GREEN}${SUCCESS}" || sym="${BLOOD_RED}${FAILURE}"
        local u="${USER:-user}"
        PS1="${PRIMARY}${u}${DARK_GRAY}@${NEON_CYAN}${path_d}${git_b}${RESET}\n${sym} ${PRIMARY}${PROMPT}${RESET} "
    }
    PROMPT_COMMAND="_phantom_ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

# ═══════════════════════════════════════════════════
# ENTRY POINT — only on interactive shells
# ═══════════════════════════════════════════════════

if [[ $- == *i* ]]; then
    set_phantom_prompt
    start_phantom_terminal
fi
