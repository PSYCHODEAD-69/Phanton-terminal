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

# ═══════════════════════════════════════════════════════════════════════════
# VERSION & PATHS
# ═══════════════════════════════════════════════════════════════════════════

SCRIPT_VERSION="3.6.1"
REPO_OWNER="Unknown-2829"
REPO_NAME="Phanton-terminal"
CONFIG_DIR="$HOME/.phantom-terminal"
CONFIG_FILE="$CONFIG_DIR/config.json"
CACHE_FILE="$CONFIG_DIR/cache.json"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# ═══════════════════════════════════════════════════════════════════════════
# PLATFORM DETECTION
# ═══════════════════════════════════════════════════════════════════════════

detect_platform() {
    if [[ "$OSTYPE" == "linux-android"* ]] || [[ -n "$TERMUX_VERSION" ]]; then
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
# COLORS (ANSI Escape Codes)
# ═══════════════════════════════════════════════════════════════════════════

ESC=$'\e'
RESET="${ESC}[0m"
BOLD="${ESC}[1m"

# Theme colors
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

# ═══════════════════════════════════════════════════════════════════════════
# SYMBOLS
# ═══════════════════════════════════════════════════════════════════════════

if [[ "$PLATFORM" == "termux" ]] || [[ "$TERM" != *"xterm"* ]]; then
    # ASCII fallback for better compatibility
    SKULL="[X]"
    SHIELD="[#]"
    LOCK="[=]"
    KEY="[-]"
    HIGH_VOLTAGE="[!]"
    BOMB="[O]"
    SUCCESS="[+]"
    FAILURE="[x]"
    WARNING="[!]"
    PROMPT=">"
    BRANCH="~"
    UPDATE="[U]"
    CPU="[C]"
    RAM="[R]"
    HDD="[D]"
    HLINE="="
    VLINE="|"
    TOP_LEFT="+"
    TOP_RIGHT="+"
    BOTTOM_LEFT="+"
    BOTTOM_RIGHT="+"
    T_LEFT="+"
    T_RIGHT="+"
    BLOCK="#"
    BLOCK_EMPTY="-"
else
    # Unicode symbols for better terminals
    SKULL="☠"
    SHIELD="░"
    LOCK="■"
    KEY="●"
    HIGH_VOLTAGE="⚡"
    BOMB="◆"
    SUCCESS="✔"
    FAILURE="✘"
    WARNING="⚠"
    PROMPT="»"
    BRANCH="→"
    UPDATE="↻"
    CPU="⚙"
    RAM="☰"
    HDD="■"
    HLINE="═"
    VLINE="║"
    TOP_LEFT="╔"
    TOP_RIGHT="╗"
    BOTTOM_LEFT="╚"
    BOTTOM_RIGHT="╝"
    T_LEFT="╠"
    T_RIGHT="╣"
    BLOCK="█"
    BLOCK_EMPTY="░"
fi

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURATION MANAGEMENT
# ═══════════════════════════════════════════════════════════════════════════

load_config() {
    # Default configuration
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

    # Load from config file if exists
    if [[ -f "$CONFIG_FILE" ]]; then
        if command -v jq &> /dev/null; then
            ANIMATION_ENABLED=$(jq -r '.AnimationEnabled // true' "$CONFIG_FILE" 2>/dev/null)
            MATRIX_DURATION=$(jq -r '.MatrixDuration // 2' "$CONFIG_FILE" 2>/dev/null)
            MATRIX_MODE=$(jq -r '.MatrixMode // "Letters"' "$CONFIG_FILE" 2>/dev/null)
            SECURITY_LOAD_STEPS=$(jq -r '.SecurityLoadSteps // 8' "$CONFIG_FILE" 2>/dev/null)
            GLITCH_INTENSITY=$(jq -r '.GlitchIntensity // 3' "$CONFIG_FILE" 2>/dev/null)
            SHOW_SYSTEM_INFO=$(jq -r '.ShowSystemInfo // true' "$CONFIG_FILE" 2>/dev/null)
            SHOW_FULL_PATH=$(jq -r '.ShowFullPath // true' "$CONFIG_FILE" 2>/dev/null)
            GRADIENT_TEXT=$(jq -r '.GradientText // true' "$CONFIG_FILE" 2>/dev/null)
            SMART_SUGGESTIONS=$(jq -r '.SmartSuggestions // true' "$CONFIG_FILE" 2>/dev/null)
            THEME=$(jq -r '.Theme // "Phantom"' "$CONFIG_FILE" 2>/dev/null)
            AUTO_CHECK_UPDATES=$(jq -r '.AutoCheckUpdates // true' "$CONFIG_FILE" 2>/dev/null)
            SILENT_UPDATE=$(jq -r '.SilentUpdate // true' "$CONFIG_FILE" 2>/dev/null)
            UPDATE_CHECK_DAYS=$(jq -r '.UpdateCheckDays // 1' "$CONFIG_FILE" 2>/dev/null)
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

# ═══════════════════════════════════════════════════════════════════════════
# CACHE MANAGEMENT
# ═══════════════════════════════════════════════════════════════════════════

get_cache() {
    if [[ -f "$CACHE_FILE" ]] && command -v jq &> /dev/null; then
        LAST_UPDATE_CHECK=$(jq -r '.LastUpdateCheck // ""' "$CACHE_FILE" 2>/dev/null)
        LATEST_VERSION=$(jq -r '.LatestVersion // ""' "$CACHE_FILE" 2>/dev/null)
        UPDATE_AVAILABLE=$(jq -r '.UpdateAvailable // false' "$CACHE_FILE" 2>/dev/null)
    else
        LAST_UPDATE_CHECK=""
        LATEST_VERSION=""
        UPDATE_AVAILABLE=false
    fi
}

save_cache() {
    local last_check="${1:-}"
    local latest_ver="${2:-}"
    local update_avail="${3:-false}"

    cat > "$CACHE_FILE" <<EOF
{
  "LastUpdateCheck": "$last_check",
  "LatestVersion": "$latest_ver",
  "UpdateAvailable": $update_avail
}
EOF
}

# ═══════════════════════════════════════════════════════════════════════════
# THEMES
# ═══════════════════════════════════════════════════════════════════════════

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
            MATRIX_CHARS='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$'
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

# ═══════════════════════════════════════════════════════════════════════════
# TERMINAL HELPERS
# ═══════════════════════════════════════════════════════════════════════════

hide_cursor() {
    printf '\e[?25l'
}

show_cursor() {
    printf '\e[?25h'
}

clear_screen() {
    clear
    printf '\e[H'
}

get_terminal_size() {
    TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
    TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)

    # Detect small/mobile screens and adjust for Termux
    IS_SMALL_SCREEN=false
    if [[ $TERM_WIDTH -lt 80 ]] || [[ "$PLATFORM" == "termux" ]]; then
        IS_SMALL_SCREEN=true
    fi
}

move_cursor() {
    printf '\e[%d;%dH' "$1" "$2"
}

write_centered() {
    local text="$1"
    local color="${2:-$WHITE}"
    get_terminal_size
    local clean_text=$(echo "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local padding=$(( (TERM_WIDTH - ${#clean_text}) / 2 ))
    [[ $padding -lt 0 ]] && padding=0
    printf "%${padding}s%b%s%b\n" "" "$color" "$text" "$RESET"
}

# ═══════════════════════════════════════════════════════════════════════════
# ANIMATIONS
# ═══════════════════════════════════════════════════════════════════════════

show_security_loading_bar() {
    local description="$1"
    local steps="${2:-8}"
    local color="${3:-$PRIMARY}"

    for ((i=1; i<=steps; i++)); do
        local filled=$(printf "%${i}s" | tr ' ' "$BLOCK")
        local empty=$(printf "%$((steps - i))s" | tr ' ' "$BLOCK_EMPTY")
        local percent=$((i * 100 / steps))
        printf "\r  %b%s %b[%b%s%b%s] %b%3d%%%b" \
            "$GRAY" "$description" "$DARK_GRAY" "$color" "$filled" \
            "$DARK_GRAY" "$empty" "$WHITE" "$percent" "$RESET"
        sleep 0.025
    done
    printf " %b%s%b\n" "$NEON_GREEN" "$SUCCESS" "$RESET"
}

show_multicolor_matrix() {
    local duration="${1:-2}"
    clear_screen
    get_terminal_size

    # Reduce duration on small screens/mobile for performance
    if [[ "$IS_SMALL_SCREEN" == "true" ]]; then
        duration=$((duration / 2))
        [[ $duration -lt 1 ]] && duration=1
    fi

    # Get matrix chars based on mode
    local chars
    if [[ "$MATRIX_MODE" == "Binary" ]]; then
        chars="01"
    else
        chars="$MATRIX_CHARS"
    fi

    # Color list
    local colors=("$PRIMARY" "$SECONDARY" "$NEON_CYAN" "$ELECTRIC_BLUE")

    # Initialize drop positions - reduce on small screens
    declare -a drops
    local col_step=1
    if [[ "$IS_SMALL_SCREEN" == "true" ]]; then
        col_step=2  # Skip every other column on small screens
    fi

    for ((i=0; i<TERM_WIDTH; i+=col_step)); do
        drops[$i]=$((RANDOM % TERM_HEIGHT))
    done

    local end_time=$((SECONDS + duration))
    local sleep_time=0.012
    [[ "$IS_SMALL_SCREEN" == "true" ]] && sleep_time=0.02  # Slower on mobile

    while [[ $SECONDS -lt $end_time ]]; do
        for ((col=0; col<TERM_WIDTH; col+=col_step)); do
            local char="${chars:$((RANDOM % ${#chars})):1}"
            local color_idx=$((col % ${#colors[@]}))
            local color="${colors[$color_idx]}"
            local row=${drops[$col]}

            if [[ $row -ge 1 && $row -lt $TERM_HEIGHT ]]; then
                move_cursor "$row" "$col"
                printf "%b%s" "$color" "$char"

                local lead_pos=$((row + 1))
                if [[ $lead_pos -lt $TERM_HEIGHT ]]; then
                    move_cursor "$lead_pos" "$col"
                    printf "%b%s" "$WHITE" "$char"
                fi
            fi

            drops[$col]=$((row + 1))
            if [[ ${drops[$col]} -ge $TERM_HEIGHT && $((RANDOM % 5)) -eq 0 ]]; then
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
    local y_pos=$((TERM_HEIGHT / 2 - 3))

    local statuses=("[CORE_INIT]" "[ENCRYPTION_KEYS]" "[FIREWALL_MATRIX]" "[AUTH_BYPASS]" "[SYSTEM_ARMED]")

    for status in "${statuses[@]}"; do
        local padding=$(( (TERM_WIDTH - ${#status} - 4) / 2 ))
        [[ $padding -lt 0 ]] && padding=0

        move_cursor "$y_pos" 1
        printf "%${padding}s%b%s %s" "" "$BLOOD_RED" "$HIGH_VOLTAGE" "$status"
        sleep 0.05

        move_cursor "$y_pos" 1
        printf "%${padding}s%b%s %s%b\n" "" "$PRIMARY" "$HIGH_VOLTAGE" "$status" "$RESET"
        y_pos=$((y_pos + 1))
        sleep 0.025
    done
    sleep 0.1
}

show_glitch_reveal() {
    local art="$1"
    local color="${2:-$PRIMARY}"

    clear_screen
    get_terminal_size

    # Split logo into lines
    mapfile -t lines <<< "$art"

    local max_width=0
    for line in "${lines[@]}"; do
        [[ ${#line} -gt $max_width ]] && max_width=${#line}
    done

    local start_col=$(( (TERM_WIDTH - max_width) / 2 ))
    [[ $start_col -lt 1 ]] && start_col=1
    local start_row=$(( (TERM_HEIGHT - ${#lines[@]}) / 2 ))
    [[ $start_row -lt 2 ]] && start_row=2

    local glitch_chars='!@#$%_+-=:;,.?/'

    # Glitch effect
    for ((g=0; g<GLITCH_INTENSITY; g++)); do
        local row=$start_row
        for line in "${lines[@]}"; do
            move_cursor "$row" "$start_col"
            local glitched=""
            for ((i=0; i<${#line}; i++)); do
                local char="${line:$i:1}"
                if [[ "$char" != " " && $((RANDOM % 10)) -lt 3 ]]; then
                    glitched+="${glitch_chars:$((RANDOM % ${#glitch_chars})):1}"
                else
                    glitched+="$char"
                fi
            done
            printf "%b%s%b" "$BRIGHT_RED" "$glitched" "$RESET"
            row=$((row + 1))
        done
        sleep 0.035
    done

    # Final reveal with gradient
    clear_screen
    echo ""
    write_gradient_logo "$art"
    sleep 0.2
}

write_gradient_logo() {
    local art="$1"
    mapfile -t lines <<< "$art"

    get_terminal_size
    local max_width=0
    for line in "${lines[@]}"; do
        [[ ${#line} -gt $max_width ]] && max_width=${#line}
    done

    local start_col=$(( (TERM_WIDTH - max_width) / 2 ))
    [[ $start_col -lt 0 ]] && start_col=0

    local line_num=0
    for line in "${lines[@]}"; do
        local color
        if [[ "$GRADIENT_TEXT" == "true" ]]; then
            local color_idx=$((line_num % ${#GRADIENT_COLORS[@]}))
            color="${GRADIENT_COLORS[$color_idx]}"
        else
            color="$PRIMARY"
        fi
        printf "%${start_col}s%b%s%b\n" "" "$color" "$line" "$RESET"
        line_num=$((line_num + 1))
    done
}

show_security_sequence() {
    clear_screen
    echo ""
    echo ""
    write_centered "$SHIELD INITIALIZING SECURITY PROTOCOLS $SHIELD" "$PRIMARY"
    echo ""

    show_security_loading_bar "$LOCK Initializing AES-256 Encryption" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Generating SHA-512 Hashes" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Activating Firewall Matrix" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    show_security_loading_bar "$LOCK Establishing Secure Channel" "$SECURITY_LOAD_STEPS" "$PRIMARY"
    sleep 0.1
}

# ═══════════════════════════════════════════════════════════════════════════
# SYSTEM STATS
# ═══════════════════════════════════════════════════════════════════════════

get_system_stats() {
    local cpu_usage="N/A"
    local ram_usage="N/A"

    # Get CPU usage
    case "$PLATFORM" in
        macos)
            # macOS: use top to get CPU idle percentage
            local cpu_idle=$(top -l 1 -n 0 2>/dev/null | grep "CPU usage" | awk '{print $7}' | sed 's/%//')
            if [[ -n "$cpu_idle" ]]; then
                cpu_usage=$((100 - cpu_idle))
            fi
            ;;
        linux)
            # Linux: use top or /proc/stat
            if command -v top &>/dev/null; then
                local cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | sed 's/%id,//' | cut -d'.' -f1)
                if [[ -n "$cpu_idle" ]]; then
                    cpu_usage=$((100 - cpu_idle))
                fi
            fi
            ;;
        termux)
            # Termux: use /proc/stat if available
            if [[ -r /proc/stat ]]; then
                local cpu_data=($(head -n1 /proc/stat | awk '{print $2, $3, $4, $5}'))
                local total=$((cpu_data[0] + cpu_data[1] + cpu_data[2] + cpu_data[3]))
                local idle=${cpu_data[3]}
                if [[ $total -gt 0 ]]; then
                    cpu_usage=$(( (total - idle) * 100 / total ))
                fi
            fi
            ;;
    esac

    # Get RAM usage
    case "$PLATFORM" in
        macos)
            # macOS: use vm_stat
            if command -v vm_stat &>/dev/null; then
                local pages_free=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
                local pages_active=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
                local pages_inactive=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
                local pages_wired=$(vm_stat | grep "Pages wired down" | awk '{print $4}' | sed 's/\.//')
                if [[ -n "$pages_free" ]] && [[ -n "$pages_active" ]]; then
                    local total_pages=$((pages_free + pages_active + pages_inactive + pages_wired))
                    local used_pages=$((pages_active + pages_wired))
                    if [[ $total_pages -gt 0 ]]; then
                        ram_usage=$((used_pages * 100 / total_pages))
                    fi
                fi
            fi
            ;;
        linux|termux)
            # Linux/Termux: use /proc/meminfo
            if [[ -r /proc/meminfo ]]; then
                local mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
                local mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
                if [[ -n "$mem_total" ]] && [[ -n "$mem_available" ]] && [[ $mem_total -gt 0 ]]; then
                    local mem_used=$((mem_total - mem_available))
                    ram_usage=$((mem_used * 100 / mem_total))
                fi
            fi
            ;;
    esac

    echo "$cpu_usage $ram_usage"
}

write_usage_bar() {
    local indent="$1"
    local label="$2"
    local usage="$3"
    local width="${4:-30}"

    # Skip if usage is N/A
    if [[ "$usage" == "N/A" ]]; then
        return
    fi

    # Determine color based on usage
    local bar_color="$NEON_GREEN"
    if [[ $usage -gt 80 ]]; then
        bar_color="$BLOOD_RED"
    elif [[ $usage -gt 60 ]]; then
        bar_color="$ORANGE"
    fi

    # Calculate filled and empty blocks
    local filled=$((usage * width / 100))
    [[ $filled -gt $width ]] && filled=$width
    [[ $filled -lt 0 ]] && filled=0
    local empty=$((width - filled))

    # Build bar
    local bar=""
    for ((i=0; i<filled; i++)); do
        bar+="$BLOCK"
    done
    for ((i=0; i<empty; i++)); do
        bar+="$BLOCK_EMPTY"
    done

    printf "%s%b%s %b%-8s%b %b%s%b %b%3d%%%b\n" \
        "$indent" "$PRIMARY" "$VLINE" \
        "$WHITE" "$label" "$RESET" \
        "$bar_color" "$bar" "$RESET" \
        "$WHITE" "$usage" "$RESET"
}

show_dashboard() {
    clear_screen
    get_terminal_size

    # Get system info
    local user="$USER"
    local computer="${HOSTNAME:-$(hostname 2>/dev/null || echo 'unknown')}"
    local os
    case "$PLATFORM" in
        termux) os="Termux (Android)" ;;
        macos) os="macOS $(sw_vers -productVersion 2>/dev/null || echo '')" ;;
        linux) os="$(uname -s) $(uname -r)" ;;
        *) os="$(uname -s)" ;;
    esac
    local datetime=$(date '+%Y-%m-%d %H:%M:%S')

    # Get uptime
    local uptime_str="N/A"
    if command -v uptime &> /dev/null; then
        uptime_str=$(uptime | sed 's/.*up //' | sed 's/,.*//' | xargs)
    fi

    # Display logo with gradient
    echo ""
    if [[ "$THEME" == "Unknown" ]]; then
        write_gradient_logo "$(get_unknown_logo)"
    else
        write_gradient_logo "$(get_phantom_logo)"
    fi
    echo ""

    # Box
    local box_width=65
    [[ $TERM_WIDTH -lt 69 ]] && box_width=$((TERM_WIDTH - 4))
    local padding=$(( (TERM_WIDTH - box_width) / 2 ))
    [[ $padding -lt 0 ]] && padding=0
    local indent=$(printf "%${padding}s" "")
    local hline=$(printf "%$((box_width - 2))s" "" | tr ' ' "$HLINE")

    echo "${indent}${PRIMARY}${TOP_LEFT}${hline}${TOP_RIGHT}${RESET}"

    local title="$SKULL $TITLE v$SCRIPT_VERSION $SKULL"
    local title_pad=$((box_width - ${#title} - 4))
    [[ $title_pad -lt 0 ]] && title_pad=0
    printf "%s%b%s %b%s%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
        "$SECONDARY" "$title" "$title_pad" "" "$PRIMARY" "$VLINE" "$RESET"

    echo "${indent}${PRIMARY}${T_LEFT}${hline}${T_RIGHT}${RESET}"

    # System info (if enabled)
    if [[ "$SHOW_SYSTEM_INFO" == "true" ]]; then
        printf "%s%b%s%b  Operator: %b%s%b%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
            "$WHITE" "$NEON_GREEN" "$user" "$WHITE" \
            $((box_width - 12 - ${#user})) "" "$PRIMARY" "$VLINE" "$RESET"

        printf "%s%b%s%b  Host: %b%s%b%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
            "$WHITE" "$GOLD" "$computer" "$WHITE" \
            $((box_width - 8 - ${#computer})) "" "$PRIMARY" "$VLINE" "$RESET"

        printf "%s%b%s%b  System: %b%s%b%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
            "$WHITE" "$GOLD" "$os" "$WHITE" \
            $((box_width - 10 - ${#os})) "" "$PRIMARY" "$VLINE" "$RESET"

        printf "%s%b%s%b  Uptime: %b%s%b%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
            "$WHITE" "$NEON_CYAN" "$uptime_str" "$WHITE" \
            $((box_width - 10 - ${#uptime_str})) "" "$PRIMARY" "$VLINE" "$RESET"

        printf "%s%b%s%b  Time: %b%s%b%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
            "$WHITE" "$NEON_CYAN" "$datetime" "$WHITE" \
            $((box_width - 8 - ${#datetime})) "" "$PRIMARY" "$VLINE" "$RESET"

        echo "${indent}${PRIMARY}${T_LEFT}${hline}${T_RIGHT}${RESET}"

        # System stats (CPU and RAM)
        local stats=($(get_system_stats))
        local cpu_usage="${stats[0]}"
        local ram_usage="${stats[1]}"

        # Display CPU and RAM bars if available
        if [[ "$cpu_usage" != "N/A" ]] || [[ "$ram_usage" != "N/A" ]]; then
            write_usage_bar "$indent" "$CPU CPU" "$cpu_usage" 30
            write_usage_bar "$indent" "$RAM RAM" "$ram_usage" 30
            echo "${indent}${PRIMARY}${T_LEFT}${hline}${T_RIGHT}${RESET}"
        fi
    fi

    # Quote
    local quote_idx=$((RANDOM % ${#QUOTES[@]}))
    local quote="${QUOTES[$quote_idx]}"
    local quote_pad=$((box_width - ${#quote} - 4))
    [[ $quote_pad -lt 0 ]] && quote_pad=0
    printf "%s%b%s %b%s%*s%b%s%b\n" "$indent" "$PRIMARY" "$VLINE" \
        "$GRAY" "$quote" "$quote_pad" "" "$PRIMARY" "$VLINE" "$RESET"

    echo "${indent}${PRIMARY}${BOTTOM_LEFT}${hline}${BOTTOM_RIGHT}${RESET}"
    echo ""

    # Help command
    local help_cmd="phantom-help"
    [[ "$THEME" == "Unknown" ]] && help_cmd="unknown-help"
    echo "${indent}${DARK_GRAY}Type '${GOLD}${help_cmd}${DARK_GRAY}' for commands.${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN STARTUP
# ═══════════════════════════════════════════════════════════════════════════

start_phantom_terminal() {
    load_config
    get_theme_colors

    if [[ "$ANIMATION_ENABLED" != "true" ]]; then
        show_dashboard
        return
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

# ═══════════════════════════════════════════════════════════════════════════
# COMMANDS
# ═══════════════════════════════════════════════════════════════════════════

phantom-reload() {
    start_phantom_terminal
}

phantom-matrix() {
    load_config
    get_theme_colors
    hide_cursor
    show_multicolor_matrix 5
    show_cursor
}

phantom-dash() {
    load_config
    get_theme_colors
    show_dashboard
}

phantom-help() {
    load_config
    get_theme_colors
    local prefix="phantom"
    [[ "$THEME" == "Unknown" ]] && prefix="unknown"

    echo ""
    echo "${NEON_CYAN}=== $TITLE v$SCRIPT_VERSION ===${RESET}"
    echo ""
    echo "  ${GOLD}${prefix}-reload${WHITE}  - Replay animation${RESET}"
    echo "  ${GOLD}${prefix}-theme${WHITE}   - Switch theme${RESET}"
    echo "  ${GOLD}${prefix}-config${WHITE}  - Show/edit config${RESET}"
    echo "  ${GOLD}${prefix}-matrix${WHITE}  - Matrix animation${RESET}"
    echo "  ${GOLD}${prefix}-dash${WHITE}    - Show dashboard${RESET}"
    echo "  ${GOLD}${prefix}-update${WHITE}  - Check updates${RESET}"
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
        echo "  ${GOLD}AnimationEnabled${WHITE}: $ANIMATION_ENABLED${RESET}"
        echo "  ${GOLD}MatrixDuration${WHITE}: $MATRIX_DURATION${RESET}"
        echo "  ${GOLD}MatrixMode${WHITE}: $MATRIX_MODE${RESET}"
        echo "  ${GOLD}SecurityLoadSteps${WHITE}: $SECURITY_LOAD_STEPS${RESET}"
        echo "  ${GOLD}GlitchIntensity${WHITE}: $GLITCH_INTENSITY${RESET}"
        echo "  ${GOLD}ShowSystemInfo${WHITE}: $SHOW_SYSTEM_INFO${RESET}"
        echo "  ${GOLD}ShowFullPath${WHITE}: $SHOW_FULL_PATH${RESET}"
        echo "  ${GOLD}GradientText${WHITE}: $GRADIENT_TEXT${RESET}"
        echo "  ${GOLD}Theme${WHITE}: $THEME${RESET}"
        echo "  ${GOLD}AutoCheckUpdates${WHITE}: $AUTO_CHECK_UPDATES${RESET}"
        echo ""
        echo "${DARK_GRAY}Run: phantom-config --edit${RESET}"
        echo ""
    fi
}

phantom-theme() {
    local new_theme="$1"
    load_config

    if [[ -z "$new_theme" ]]; then
        echo ""
        echo "${NEON_CYAN}Available themes: Phantom, Unknown${RESET}"
        echo "${GOLD}Current: $THEME${RESET}"
        echo "${DARK_GRAY}Usage: phantom-theme Unknown${RESET}"
        echo ""
        return
    fi

    case "${new_theme,,}" in
        unknown)
            THEME="Unknown"
            save_config
            echo "${NEON_GREEN}Theme changed to: Unknown${RESET}"
            echo "${DARK_GRAY}Run 'phantom-reload' to see changes${RESET}"
            ;;
        phantom)
            THEME="Phantom"
            save_config
            echo "${NEON_GREEN}Theme changed to: Phantom${RESET}"
            echo "${DARK_GRAY}Run 'phantom-reload' to see changes${RESET}"
            ;;
        *)
            echo "${BLOOD_RED}Unknown theme. Available: Phantom, Unknown${RESET}"
            ;;
    esac
}

phantom-update() {
    load_config
    get_cache

    echo "${NEON_CYAN}Checking for updates...${RESET}"

    if ! command -v curl &> /dev/null; then
        echo "${BLOOD_RED}curl not found. Please install curl.${RESET}"
        return 1
    fi

    # Check cache to avoid too frequent API calls
    local now=$(date +%s)
    local cache_valid=false
    if [[ -n "$LAST_UPDATE_CHECK" ]]; then
        local last_check_ts=$(date -d "$LAST_UPDATE_CHECK" +%s 2>/dev/null || date -j -f "%Y-%m-%d %H:%M:%S" "$LAST_UPDATE_CHECK" +%s 2>/dev/null || echo "0")
        local days_since=$(( (now - last_check_ts) / 86400 ))
        if [[ $days_since -lt $UPDATE_CHECK_DAYS ]]; then
            cache_valid=true
        fi
    fi

    # Use cached result if valid
    if [[ "$cache_valid" == "true" ]] && [[ -n "$LATEST_VERSION" ]]; then
        echo "${DARK_GRAY}Using cached result (checked recently)${RESET}"
        local latest_version="$LATEST_VERSION"
    else
        # Query GitHub API
        local latest_version=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | grep -o '"tag_name": *"[^"]*"' | sed 's/"tag_name": *"v\?\(.*\)"/\1/')

        if [[ -z "$latest_version" ]]; then
            echo "${BLOOD_RED}Failed to check for updates.${RESET}"
            return 1
        fi

        # Save to cache
        local check_time=$(date '+%Y-%m-%d %H:%M:%S')
        local is_update_available=false
        if [[ "$latest_version" > "$SCRIPT_VERSION" ]]; then
            is_update_available=true
        fi
        save_cache "$check_time" "$latest_version" "$is_update_available"
    fi

    if [[ "$latest_version" > "$SCRIPT_VERSION" ]]; then
        echo "${GOLD}Updating to v$latest_version...${RESET}"

        local script_path="$HOME/.phantom-terminal/PhantomStartup.sh"
        if ! curl -fsSL "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/PhantomStartup.sh" -o "$script_path"; then
            echo "${BLOOD_RED}Update failed.${RESET}"
            return 1
        fi

        chmod +x "$script_path"
        echo "${NEON_GREEN}Updated! Restart terminal to apply.${RESET}"
    else
        echo "${NEON_GREEN}Already on latest version (v$SCRIPT_VERSION)${RESET}"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# EASTER EGGS
# ═══════════════════════════════════════════════════════════════════════════

# Initialize secrets tracking
declare -a SECRETS_FOUND=()
SECRETS_FILE="$CONFIG_DIR/.secrets"

# Load discovered secrets
if [[ -f "$SECRETS_FILE" ]]; then
    mapfile -t SECRETS_FOUND < "$SECRETS_FILE"
fi

save_secret() {
    local secret="$1"
    if [[ ! " ${SECRETS_FOUND[@]} " =~ " ${secret} " ]]; then
        SECRETS_FOUND+=("$secret")
        printf "%s\n" "${SECRETS_FOUND[@]}" > "$SECRETS_FILE"
    fi
}

phantom-chosen() {
    load_config
    get_theme_colors
    clear_screen
    echo ""
    echo ""
    write_centered "╔════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║                                        ║" "$PRIMARY"
    write_centered "║     ${GOLD}✦ THE CHOSEN ONE ✦${PRIMARY}          ║" "$PRIMARY"
    write_centered "║                                        ║" "$PRIMARY"
    write_centered "╚════════════════════════════════════════╝" "$PRIMARY"
    echo ""
    write_centered "You have been granted access." "$SECONDARY"
    write_centered "Power. Knowledge. Control." "$ACCENT"
    echo ""
    write_centered "The path is now open." "$GRAY"
    echo ""

    save_secret "chosen"
}

phantom-2829() {
    load_config
    get_theme_colors
    clear_screen
    hide_cursor

    echo ""
    echo ""
    sleep 0.3
    write_centered "Initializing..." "$DARK_GRAY"
    sleep 0.5
    clear_screen
    echo ""
    echo ""

    write_centered "╔══════════════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║                                                  ║" "$PRIMARY"
    write_centered "║          ${NEON_PURPLE}⚡ CREATOR'S MARK ⚡${PRIMARY}                 ║" "$PRIMARY"
    write_centered "║                                                  ║" "$PRIMARY"
    write_centered "╚══════════════════════════════════════════════════╝" "$PRIMARY"
    echo ""
    sleep 0.5

    write_centered "${NEON_CYAN}@unknownlll2829${RESET}" "$WHITE"
    sleep 0.3
    write_centered "Master of Terminals, Architect of Code" "$GRAY"
    sleep 0.3
    echo ""
    write_centered "${HOT_PINK}⟨ The Phantom That Never Sleeps ⟩${RESET}" "$HOT_PINK"
    sleep 0.5
    echo ""

    write_centered "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$DARK_GRAY"
    echo ""
    write_centered "${GOLD}\"In the shadows, we code...\"${RESET}" "$GOLD"
    echo ""
    write_centered "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$DARK_GRAY"
    sleep 0.5
    echo ""
    echo ""

    write_centered "${NEON_GREEN}✓ Secret Unlocked${RESET}" "$NEON_GREEN"
    echo ""

    show_cursor
    save_secret "2829"
}

phantom-secrets() {
    load_config
    get_theme_colors
    clear_screen

    echo ""
    echo ""
    write_centered "╔════════════════════════════════════════╗" "$PRIMARY"
    write_centered "║                                        ║" "$PRIMARY"
    write_centered "║     ${GOLD}🔍 SECRET HUNTER 🔍${PRIMARY}          ║" "$PRIMARY"
    write_centered "║                                        ║" "$PRIMARY"
    write_centered "╚════════════════════════════════════════╝" "$PRIMARY"
    echo ""

    local total_secrets=3
    local found_count=${#SECRETS_FOUND[@]}

    write_centered "Secrets Found: ${NEON_GREEN}$found_count${RESET} / ${GOLD}$total_secrets${RESET}" "$WHITE"
    echo ""
    echo ""

    # Display found secrets
    if [[ $found_count -gt 0 ]]; then
        write_centered "${NEON_CYAN}━━━ Discovered ━━━${RESET}" "$NEON_CYAN"
        echo ""
        for secret in "${SECRETS_FOUND[@]}"; do
            case "$secret" in
                chosen) write_centered "${NEON_GREEN}✓${RESET} phantom-chosen - The Chosen One" "$WHITE" ;;
                2829) write_centered "${NEON_GREEN}✓${RESET} phantom-2829 - Creator's Mark" "$WHITE" ;;
                secrets) write_centered "${NEON_GREEN}✓${RESET} phantom-secrets - You found me!" "$WHITE" ;;
            esac
        done
        echo ""
    fi

    # Check if all found
    if [[ $found_count -eq $total_secrets ]]; then
        echo ""
        write_centered "${GOLD}⚡ ACHIEVEMENT UNLOCKED ⚡${RESET}" "$GOLD"
        write_centered "Master Secret Hunter" "$ACCENT"
        echo ""
        write_centered "You've discovered all hidden commands!" "$GRAY"
        echo ""
    else
        write_centered "${DARK_GRAY}Hint: Hidden commands start with 'phantom-'${RESET}" "$DARK_GRAY"
        echo ""
    fi

    save_secret "secrets"
}

# Unknown theme aliases
unknown-help() { phantom-help; }
unknown-reload() { phantom-reload; }
unknown-theme() { phantom-theme "$@"; }
unknown-matrix() { phantom-matrix; }
unknown-dash() { phantom-dash; }
unknown-update() { phantom-update; }
unknown-config() { phantom-config "$@"; }

# ═══════════════════════════════════════════════════════════════════════════
# PROMPT
# ═══════════════════════════════════════════════════════════════════════════

set_phantom_prompt() {
    load_config
    get_theme_colors

    # Only set prompt if not already set
    if [[ "$PROMPT_COMMAND" != *"phantom_prompt"* ]]; then
        phantom_prompt() {
            local last_status=$?

            local path_display
            if [[ "$SHOW_FULL_PATH" == "true" ]]; then
                path_display="$PWD"
            else
                path_display="${PWD##*/}"
                [[ -z "$path_display" ]] && path_display="$PWD"
            fi

            # Git branch
            local git_branch=""
            if [[ -d .git ]] || git rev-parse --git-dir &>/dev/null; then
                local branch=$(git branch --show-current 2>/dev/null)
                [[ -n "$branch" ]] && git_branch=" ${DARK_GRAY}on ${HOT_PINK}$branch"
            fi

            # Status symbol
            local status_symbol
            if [[ $last_status -eq 0 ]]; then
                status_symbol="${NEON_GREEN}${SUCCESS}"
            else
                status_symbol="${BLOOD_RED}${FAILURE}"
            fi

            PS1="${PRIMARY}${user}${DARK_GRAY}@${NEON_CYAN}${path_display}${git_branch}${RESET}\n${status_symbol} ${PRIMARY}${PROMPT}${RESET} "
        }

        PROMPT_COMMAND="phantom_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════

# Only run on interactive shells
if [[ $- == *i* ]]; then
    set_phantom_prompt
    start_phantom_terminal
fi
