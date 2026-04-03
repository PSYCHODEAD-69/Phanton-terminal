<#
.SYNOPSIS
    Phantom Terminal - Advanced PowerShell Startup Animation v3.6.1
.DESCRIPTION
    Cinematic startup animation with multiple themes, effects, and customization.
    Features: Matrix/Binary rain, gradients, themes.
    Cross-platform support: Windows, Linux (via WSL), with Bash companion script.
.NOTES
    Creator: @unknownlll2829 (Telegram)
    GitHub: https://github.com/Unknown-2829/Phanton-terminal
    Version: 3.6.1
#>

# ═══════════════════════════════════════════════════════════════════════════
# VERSION & PATHS
# ═══════════════════════════════════════════════════════════════════════════

$Script:Version = "3.6.1"
$Script:RepoOwner = "Unknown-2829"
$Script:RepoName = "Phanton-terminal"
$Script:ConfigDir = "$env:USERPROFILE\.phantom-terminal"
$Script:ConfigFile = "$Script:ConfigDir\config.json"
$Script:CacheFile = "$Script:ConfigDir\cache.json"

if (-not (Test-Path $Script:ConfigDir)) {
    New-Item -ItemType Directory -Path $Script:ConfigDir -Force | Out-Null
}

# ═══════════════════════════════════════════════════════════════════════════
# DEFAULT CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

$Script:DefaultConfig = @{
    # Animation
    AnimationEnabled   = $true
    MatrixDuration     = 2
    MatrixMode         = "Letters"    # Letters or Binary
    SecurityLoadSteps  = 8
    GlitchIntensity    = 3
    
    # Display
    ShowSystemInfo     = $true
    ShowFullPath       = $true
    GradientText       = $true        # Gradient colors for logo
    
    # Smart Suggestions (local history-based, no data collection)
    SmartSuggestions   = $true
    
    # Theme
    Theme              = "Phantom"
    
    # Updates
    AutoCheckUpdates   = $true
    SilentUpdate       = $true
    UpdateCheckDays    = 1
}

# ═══════════════════════════════════════════════════════════════════════════
# THEMES (Extended)
# ═══════════════════════════════════════════════════════════════════════════

$Script:Themes = @{
    Phantom = @{
        Name = "Phantom"
        Primary = "NeonPurple"
        Secondary = "NeonCyan"
        Accent = "HotPink"
        GradientColors = @("NeonPurple", "NeonCyan", "HotPink")
        Logo = @'
 ____  _   _    _    _   _ _____ ___  __  __ 
|  _ \| | | |  / \  | \ | |_   _/ _ \|  \/  |
| |_) | |_| | / _ \ |  \| | | || | | | |\/| |
|  __/|  _  |/ ___ \| |\  | | || |_| | |  | |
|_|   |_| |_/_/   \_\_| \_| |_| \___/|_|  |_|
'@
        Title = "PHANTOM TERMINAL"
        Tagline = "Ghost in the Machine"
        Quotes = @(
            'In the shadows, we code...',
            'Access denied. Until now.',
            'The system fears what it cannot control.',
            'We are the ghosts in the machine.',
            'Invisible. Untraceable. Unstoppable.',
            'Haunting the digital realm...',
            'Where others see darkness, we see opportunity.',
            'The phantom never sleeps.'
        )
        MatrixChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$'
    }
    Unknown = @{
        Name = "Unknown"
        Primary = "NeonGreen"
        Secondary = "ElectricBlue"
        Accent = "Gold"
        GradientColors = @("NeonGreen", "ElectricBlue", "Gold")
        Logo = @'
 _   _ _   _ _  ___   _  _____        ___   _ 
| | | | \ | | |/ / \ | |/ _ \ \      / / \ | |
| | | |  \| | ' /|  \| | | | \ \ /\ / /|  \| |
| |_| | |\  | . \| |\  | |_| |\ V  V / | |\  |
 \___/|_| \_|_|\_\_| \_|\___/  \_/\_/  |_| \_|
'@
        Title = "UNKNOWN TERMINAL"
        Tagline = "Anonymous by Design"
        Quotes = @(
            'Hidden in plain sight...',
            'Anonymous by design.',
            'The unknown cannot be traced.',
            'Identity: NULL',
            'No name. No trace. No limits.',
            'In anonymity, we trust.',
            'The best hackers are never known.',
            'Lost in the noise, found in the code.'
        )
        MatrixChars = 'UNKNOWN01?_-=+[]{}|;:,./'
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# CONFIG MANAGEMENT (PowerShell 5.1+ compatible)
# ═══════════════════════════════════════════════════════════════════════════

function Get-PhantomConfig {
    $config = $Script:DefaultConfig.Clone()
    
    if (Test-Path $Script:ConfigFile) {
        try {
            $json = Get-Content $Script:ConfigFile -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            
            # Manually copy each property (PS5.1 compatible)
            if ($null -ne $json.AnimationEnabled) { $config.AnimationEnabled = $json.AnimationEnabled }
            if ($null -ne $json.MatrixDuration) { $config.MatrixDuration = $json.MatrixDuration }
            if ($json.MatrixMode) { $config.MatrixMode = $json.MatrixMode }
            if ($null -ne $json.SecurityLoadSteps) { $config.SecurityLoadSteps = $json.SecurityLoadSteps }
            if ($null -ne $json.GlitchIntensity) { $config.GlitchIntensity = $json.GlitchIntensity }
            if ($null -ne $json.ShowSystemInfo) { $config.ShowSystemInfo = $json.ShowSystemInfo }
            if ($null -ne $json.ShowFullPath) { $config.ShowFullPath = $json.ShowFullPath }
            if ($null -ne $json.GradientText) { $config.GradientText = $json.GradientText }
            if ($json.Theme) { $config.Theme = $json.Theme }
            if ($null -ne $json.AutoCheckUpdates) { $config.AutoCheckUpdates = $json.AutoCheckUpdates }
            if ($null -ne $json.SilentUpdate) { $config.SilentUpdate = $json.SilentUpdate }
            if ($null -ne $json.UpdateCheckDays) { $config.UpdateCheckDays = $json.UpdateCheckDays }
            
            return $config
        } catch {
            # Config file corrupted, use defaults
        }
    }
    
    # Save defaults if no config exists
    Save-PhantomConfig -Config $config
    return $config
}

function Save-PhantomConfig {
    param([hashtable]$Config)
    try {
        if (-not (Test-Path $Script:ConfigDir)) {
            New-Item -ItemType Directory -Path $Script:ConfigDir -Force | Out-Null
        }
        $Config | ConvertTo-Json -Depth 3 | Out-File $Script:ConfigFile -Encoding UTF8 -Force
    } catch {}
}

function Get-PhantomCache {
    if (Test-Path $Script:CacheFile) {
        try {
            $json = Get-Content $Script:CacheFile -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            return @{
                LastUpdateCheck = $json.LastUpdateCheck
                LatestVersion = $json.LatestVersion
                UpdateAvailable = $json.UpdateAvailable
                UpdateDownloaded = $json.UpdateDownloaded
            }
        } catch {}
    }
    return @{ LastUpdateCheck = $null; LatestVersion = $null; UpdateAvailable = $false; UpdateDownloaded = $false }
}

function Save-PhantomCache {
    param([hashtable]$Cache)
    try {
        $Cache | ConvertTo-Json | Out-File $Script:CacheFile -Encoding UTF8 -Force
    } catch {}
}

$Script:Config = Get-PhantomConfig

# Load theme (case-insensitive)
$Script:CurrentTheme = $null
foreach ($key in $Script:Themes.Keys) {
    if ($key -ieq $Script:Config.Theme) {
        $Script:CurrentTheme = $Script:Themes[$key]
        $Script:Config.Theme = $key
        break
    }
}
if (-not $Script:CurrentTheme) { 
    $Script:CurrentTheme = $Script:Themes["Phantom"]
    $Script:Config.Theme = "Phantom"
}

# ═══════════════════════════════════════════════════════════════════════════
# AUTO-UPDATE (Fully Automatic)
# ═══════════════════════════════════════════════════════════════════════════

$Script:UpdateAvailable = $null
$Script:UpdateDownloaded = $false

function Test-PhantomUpdate {
    param([switch]$Force)
    
    if (-not $Script:Config.AutoCheckUpdates -and -not $Force) { return $null }
    
    $cache = Get-PhantomCache
    $now = Get-Date
    
    # Check if we need to check (respect UpdateCheckDays)
    if (-not $Force -and $cache.LastUpdateCheck) {
        try {
            $lastCheck = [DateTime]::Parse($cache.LastUpdateCheck)
            if (($now - $lastCheck).TotalDays -lt $Script:Config.UpdateCheckDays) {
                # Return cached result
                if ($cache.UpdateDownloaded) {
                    $Script:UpdateDownloaded = $true
                    return $cache.LatestVersion
                }
                if ($cache.LatestVersion -and $cache.LatestVersion -gt $Script:Version) {
                    return $cache.LatestVersion
                }
                return $null
            }
        } catch {}
    }
    
    # Check GitHub for updates
    try {
        $apiUrl = "https://api.github.com/repos/$Script:RepoOwner/$Script:RepoName/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 3 -ErrorAction Stop
        $latestVersion = $response.tag_name -replace '^v', ''
        
        $cache.LastUpdateCheck = $now.ToString("o")
        $cache.LatestVersion = $latestVersion
        
        if ($latestVersion -gt $Script:Version) {
            # Auto-download if SilentUpdate enabled
            if ($Script:Config.SilentUpdate) {
                try {
                    $scriptUrl = "https://raw.githubusercontent.com/$Script:RepoOwner/$Script:RepoName/main/PhantomStartup.ps1"
                    $tempFile = "$env:TEMP\PhantomStartup_new.ps1"
                    Invoke-WebRequest -Uri $scriptUrl -OutFile $tempFile -UseBasicParsing -TimeoutSec 5
                    
                    # Replace script
                    Copy-Item $tempFile "$HOME\PhantomStartup.ps1" -Force
                    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
                    
                    $cache.UpdateDownloaded = $true
                    $Script:UpdateDownloaded = $true
                } catch {
                    $cache.UpdateDownloaded = $false
                }
            }
            
            $cache.UpdateAvailable = $true
            Save-PhantomCache -Cache $cache
            return $latestVersion
        } else {
            $cache.UpdateAvailable = $false
            $cache.UpdateDownloaded = $false
            Save-PhantomCache -Cache $cache
        }
    } catch {}
    
    return $null
}

function Start-BackgroundUpdateCheck {
    if (-not $Script:Config.AutoCheckUpdates) { return }
    
    # Run update check
    try {
        $Script:UpdateAvailable = Test-PhantomUpdate
    } catch {
        $Script:UpdateAvailable = $null
    }
}

function Update-PhantomTerminal {
    Write-Host "$($Script:Colors.NeonCyan)Checking for updates...$($Script:Colors.Reset)"
    
    try {
        $apiUrl = "https://api.github.com/repos/$Script:RepoOwner/$Script:RepoName/releases/latest"
        $response = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 10 -ErrorAction Stop
        $latestVersion = $response.tag_name -replace '^v', ''
        
        if ($latestVersion -gt $Script:Version) {
            Write-Host "$($Script:Colors.Gold)Updating to v$latestVersion...$($Script:Colors.Reset)"
            $scriptUrl = "https://raw.githubusercontent.com/$Script:RepoOwner/$Script:RepoName/main/PhantomStartup.ps1"
            Invoke-WebRequest -Uri $scriptUrl -OutFile "$HOME\PhantomStartup.ps1" -UseBasicParsing
            Write-Host "$($Script:Colors.NeonGreen)Updated! Restart terminal to apply.$($Script:Colors.Reset)"
        } else {
            Write-Host "$($Script:Colors.NeonGreen)Already on latest version (v$Script:Version)$($Script:Colors.Reset)"
        }
    } catch {
        Write-Host "$($Script:Colors.BloodRed)Update failed: $_$($Script:Colors.Reset)"
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════════════════════════════

$Script:ESC = [char]27

$Script:Colors = @{
    Reset        = "$Script:ESC[0m"
    Bold         = "$Script:ESC[1m"
    NeonGreen    = "$Script:ESC[38;5;118m"
    NeonPurple   = "$Script:ESC[38;5;129m"
    NeonCyan     = "$Script:ESC[38;5;87m"
    ElectricBlue = "$Script:ESC[38;5;39m"
    HotPink      = "$Script:ESC[38;5;205m"
    Gold         = "$Script:ESC[38;5;220m"
    BloodRed     = "$Script:ESC[38;5;196m"
    BrightRed    = "$Script:ESC[1;91m"
    White        = "$Script:ESC[1;37m"
    Gray         = "$Script:ESC[38;5;244m"
    DarkGray     = "$Script:ESC[38;5;240m"
    Shadow       = "$Script:ESC[38;5;235m"
    Yellow       = "$Script:ESC[38;5;226m"
    Orange       = "$Script:ESC[38;5;208m"
}

function Get-ThemeColor { param([string]$Type)
    $colorName = $Script:CurrentTheme[$Type]
    return $Script:Colors[$colorName]
}

function Get-GradientColor { param([int]$Index)
    $gradients = $Script:CurrentTheme.GradientColors
    $colorName = $gradients[$Index % $gradients.Count]
    return $Script:Colors[$colorName]
}

# ═══════════════════════════════════════════════════════════════════════════
# SYMBOLS
# ═══════════════════════════════════════════════════════════════════════════

$Script:Symbols = @{
    Skull = "[X]"; Shield = "[#]"; Lock = "[=]"; Key = "[-]"
    HighVoltage = "[!]"; Bomb = "[O]"; Success = "[+]"; Failure = "[x]"
    Warning = "[!]"; Prompt = ">"; Branch = "~"; Update = "[U]"
    CPU = "[C]"; RAM = "[R]"; HDD = "[D]"
    HLine = "="; VLine = "|"
    TopLeft = "+"; TopRight = "+"; BottomLeft = "+"; BottomRight = "+"
    TLeft = "+"; TRight = "+"
    Block = "#"; BlockEmpty = "-"
}

try {
    if ($Host.UI.RawUI.OutputEncoding.EncodingName -match "Unicode|UTF") {
        $Script:Symbols = @{
            Skull = [char]0x2620; Shield = [char]0x2591; Lock = [char]0x25A0; Key = [char]0x25CF
            HighVoltage = [char]0x26A1; Bomb = [char]0x25C6; Success = [char]0x2714; Failure = [char]0x2718
            Warning = [char]0x26A0; Prompt = [char]0x00BB; Branch = [char]0x2192; Update = [char]0x21BB
            CPU = [char]0x2699; RAM = [char]0x2630; HDD = [char]0x25A0
            HLine = [char]0x2550; VLine = [char]0x2551
            TopLeft = [char]0x2554; TopRight = [char]0x2557; BottomLeft = [char]0x255A; BottomRight = [char]0x255D
            TLeft = [char]0x2560; TRight = [char]0x2563
            Block = [char]0x2588; BlockEmpty = [char]0x2591
        }
    }
} catch {}

# ═══════════════════════════════════════════════════════════════════════════
# RENDERING
# ═══════════════════════════════════════════════════════════════════════════

function New-RenderBuffer { return [System.Text.StringBuilder]::new(4096) }
function Add-ToBuffer { param([System.Text.StringBuilder]$Buffer, [string]$Text); [void]$Buffer.Append($Text) }
function Write-Buffer { param([System.Text.StringBuilder]$Buffer); Write-Host $Buffer.ToString() -NoNewline; [void]$Buffer.Clear() }
function Move-CursorFast { param([int]$Row, [int]$Col); return "$Script:ESC[$Row;${Col}H" }

function Hide-Cursor { Write-Host "$Script:ESC[?25l" -NoNewline }
function Show-Cursor { Write-Host "$Script:ESC[?25h" -NoNewline }
function Clear-TerminalScreen { Clear-Host; Write-Host "$Script:ESC[H" -NoNewline }

function Get-TerminalSize {
    try { return @{ Width = $Host.UI.RawUI.WindowSize.Width; Height = $Host.UI.RawUI.WindowSize.Height } }
    catch { return @{ Width = 120; Height = 30 } }
}

function Write-Centered {
    param([string]$Text, [string]$Color = $Script:Colors.White)
    $size = Get-TerminalSize
    $cleanText = $Text -replace '\x1b\[[0-9;]*m', ''
    $padding = [Math]::Max(0, [Math]::Floor(($size.Width - $cleanText.Length) / 2))
    Write-Host "$(' ' * $padding)$Color$Text$($Script:Colors.Reset)"
}

# ═══════════════════════════════════════════════════════════════════════════
# TYPING EFFECT
# ═══════════════════════════════════════════════════════════════════════════

function Write-TypingEffect {
    param([string]$Text, [string]$Color = $Script:Colors.Gray, [int]$DelayMs = 30)
    
    if (-not $Script:Config.TypingEffect) {
        Write-Host "$Color$Text$($Script:Colors.Reset)" -NoNewline
        return
    }
    
    foreach ($char in $Text.ToCharArray()) {
        Write-Host "$Color$char$($Script:Colors.Reset)" -NoNewline
        Start-Sleep -Milliseconds $DelayMs
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# GRADIENT LOGO
# ═══════════════════════════════════════════════════════════════════════════

function Write-GradientLogo {
    param([string]$Art)
    
    $lines = $Art -split "`n" | Where-Object { $_.Trim() }
    $size = Get-TerminalSize
    $maxWidth = ($lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
    $startCol = [Math]::Max(0, [Math]::Floor(($size.Width - $maxWidth) / 2))
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $color = if ($Script:Config.GradientText) { Get-GradientColor -Index $i } else { Get-ThemeColor "Primary" }
        Write-Host "$(' ' * $startCol)$color$($lines[$i])$($Script:Colors.Reset)"
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# CPU/RAM BARS
# ═══════════════════════════════════════════════════════════════════════════

function Get-SystemStats {
    $stats = @{ CPU = 0; RAM = 0; RAMUsed = 0; RAMTotal = 0 }
    
    try {
        # CPU (quick sample)
        $cpu = (Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue).LoadPercentage
        if ($cpu) { $stats.CPU = $cpu }
        
        # RAM
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        if ($os) {
            $stats.RAMTotal = [Math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
            $stats.RAMUsed = [Math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 1)
            $stats.RAM = [Math]::Round(($stats.RAMUsed / $stats.RAMTotal) * 100, 0)
        }
    } catch {}
    
    return $stats
}

function Write-UsageBar {
    param([string]$Label, [int]$Percent, [string]$Color, [int]$Width = 20)
    
    $filled = [Math]::Floor($Width * $Percent / 100)
    $empty = $Width - $filled
    
    $bar = "$($Script:Symbols.Block)" * $filled + "$($Script:Symbols.BlockEmpty)" * $empty
    
    # Color based on usage
    $barColor = $Color
    if ($Percent -gt 80) { $barColor = $Script:Colors.BloodRed }
    elseif ($Percent -gt 60) { $barColor = $Script:Colors.Orange }
    
    Write-Host "  $($Script:Colors.Gray)$Label $($Script:Colors.DarkGray)[$barColor$bar$($Script:Colors.DarkGray)] $($Script:Colors.White)$($Percent.ToString().PadLeft(3))%$($Script:Colors.Reset)"
}

# ═══════════════════════════════════════════════════════════════════════════
# ANIMATIONS
# ═══════════════════════════════════════════════════════════════════════════

function Show-SecurityLoadingBar {
    param([string]$Description, [int]$Steps = 8, [string]$Color)
    if (-not $Color) { $Color = Get-ThemeColor "Primary" }
    
    $buffer = New-RenderBuffer
    for ($i = 1; $i -le $Steps; $i++) {
        $filled = [string]::new([char]$Script:Symbols.Block, $i)
        $empty = [string]::new([char]$Script:Symbols.BlockEmpty, ($Steps - $i))
        $percent = [Math]::Floor(($i / $Steps) * 100)
        
        [void]$buffer.Clear()
        Add-ToBuffer $buffer "`r  $($Script:Colors.Gray)$Description $($Script:Colors.DarkGray)[$Color$filled$($Script:Colors.DarkGray)$empty] $($Script:Colors.White)$($percent.ToString().PadLeft(3))%"
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 25
    }
    Write-Host " $($Script:Colors.NeonGreen)$($Script:Symbols.Success)$($Script:Colors.Reset)"
}

function Show-MultiColorMatrix {
    param([int]$DurationSeconds = 2)
    
    Clear-TerminalScreen
    $size = Get-TerminalSize
    
    # Get chars based on mode
    $chars = if ($Script:Config.MatrixMode -eq "Binary") {
        "01"
    } else {
        $Script:CurrentTheme.MatrixChars
    }
    
    $primary = Get-ThemeColor "Primary"
    $secondary = Get-ThemeColor "Secondary"
    $colorList = @($primary, $secondary, $Script:Colors.NeonCyan, $Script:Colors.ElectricBlue)
    
    $drops = New-Object int[] $size.Width
    for ($i = 0; $i -lt $size.Width; $i++) { $drops[$i] = (Get-Random -Minimum 0 -Maximum $size.Height) }
    
    $endTime = (Get-Date).AddSeconds($DurationSeconds)
    $buffer = New-RenderBuffer
    
    while ((Get-Date) -lt $endTime) {
        [void]$buffer.Clear()
        for ($col = 0; $col -lt [Math]::Min($size.Width, $drops.Count); $col++) {
            $char = $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)]
            $color = $colorList[$col % $colorList.Length]
            $row = $drops[$col]
            
            if ($row -lt $size.Height -and $row -ge 1) {
                Add-ToBuffer $buffer (Move-CursorFast -Row $row -Col $col)
                Add-ToBuffer $buffer "$color$char"
                $leadPos = $row + 1
                if ($leadPos -lt $size.Height) {
                    Add-ToBuffer $buffer (Move-CursorFast -Row $leadPos -Col $col)
                    Add-ToBuffer $buffer "$($Script:Colors.White)$char"
                }
            }
            $drops[$col]++
            if ($drops[$col] -ge $size.Height -and (Get-Random -Minimum 0 -Maximum 5) -eq 0) { $drops[$col] = 1 }
        }
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 12
    }
    Write-Host $Script:Colors.Reset
}

function Show-CoreIgnition {
    Clear-TerminalScreen
    $size = Get-TerminalSize
    $yPos = [Math]::Floor($size.Height / 2) - 3
    $primary = Get-ThemeColor "Primary"
    
    $statuses = @("[CORE_INIT]", "[ENCRYPTION_KEYS]", "[FIREWALL_MATRIX]", "[AUTH_BYPASS]", "[SYSTEM_ARMED]")
    $buffer = New-RenderBuffer
    
    foreach ($text in $statuses) {
        $padding = [Math]::Max(0, [Math]::Floor(($size.Width - $text.Length - 4) / 2))
        
        [void]$buffer.Clear()
        Add-ToBuffer $buffer (Move-CursorFast -Row $yPos -Col 1)
        Add-ToBuffer $buffer "$(' ' * $padding)$($Script:Colors.BloodRed)$($Script:Symbols.HighVoltage) $text"
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 50
        
        [void]$buffer.Clear()
        Add-ToBuffer $buffer (Move-CursorFast -Row $yPos -Col 1)
        Add-ToBuffer $buffer "$(' ' * $padding)$primary$($Script:Symbols.HighVoltage) $text$($Script:Colors.Reset)"
        Write-Buffer $buffer
        Write-Host ""
        $yPos++
        Start-Sleep -Milliseconds 25
    }
    Start-Sleep -Milliseconds 100
}

function Show-GlitchReveal {
    param([string]$Art, [string]$Color)
    if (-not $Color) { $Color = Get-ThemeColor "Primary" }
    
    Clear-TerminalScreen
    $size = Get-TerminalSize
    $lines = $Art -split "`n" | Where-Object { $_.Trim() }
    
    $maxWidth = ($lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
    $startCol = [Math]::Max(1, [Math]::Floor(($size.Width - $maxWidth) / 2))
    $startRow = [Math]::Max(2, [Math]::Floor(($size.Height - $lines.Count) / 2))
    
    $glitchChars = '!@#$%_+-=:;,.?/'
    $buffer = New-RenderBuffer
    
    for ($g = 0; $g -lt $Script:Config.GlitchIntensity; $g++) {
        [void]$buffer.Clear()
        $row = $startRow
        foreach ($line in $lines) {
            Add-ToBuffer $buffer (Move-CursorFast -Row $row -Col $startCol)
            $glitched = -join ($line.ToCharArray() | ForEach-Object {
                if ($_ -ne ' ' -and (Get-Random -Max 10) -lt 3) { $glitchChars[(Get-Random -Max $glitchChars.Length)] } else { $_ }
            })
            Add-ToBuffer $buffer "$($Script:Colors.BrightRed)$glitched$($Script:Colors.Reset)"
            $row++
        }
        Write-Buffer $buffer
        Start-Sleep -Milliseconds 35
    }
    
    # Final reveal with gradient
    Clear-TerminalScreen
    Write-Host ""
    Write-GradientLogo -Art $Art
    Start-Sleep -Milliseconds 200
}

function Show-SecuritySequence {
    Clear-TerminalScreen
    Write-Host "`n"
    $primary = Get-ThemeColor "Primary"
    
    Write-Centered "$primary$($Script:Symbols.Shield) INITIALIZING SECURITY PROTOCOLS $($Script:Symbols.Shield)$($Script:Colors.Reset)"
    Write-Host ""
    
    @("Initializing AES-256 Encryption", "Generating SHA-512 Hashes", "Activating Firewall Matrix", "Establishing Secure Channel") | ForEach-Object {
        Show-SecurityLoadingBar -Description "$($Script:Symbols.Lock) $_" -Steps $Script:Config.SecurityLoadSteps -Color $primary
    }
    Start-Sleep -Milliseconds 100
}

function Show-Dashboard {
    Clear-TerminalScreen
    $size = Get-TerminalSize
    $primary = Get-ThemeColor "Primary"
    $secondary = Get-ThemeColor "Secondary"
    
    $user = $env:USERNAME
    $computer = $env:COMPUTERNAME
    $os = try { (Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue).Caption } catch { "Windows" }
    $datetime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $uptime = try { 
        $span = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
        "{0}d {1}h {2}m" -f $span.Days, $span.Hours, $span.Minutes
    } catch { "N/A" }
    
    $boxWidth = [Math]::Min(65, $size.Width - 4)
    $padding = [Math]::Max(0, [Math]::Floor(($size.Width - $boxWidth) / 2))
    $indent = " " * $padding
    $hLine = [string]::new([char]$Script:Symbols.HLine, ($boxWidth - 2))
    
    # Logo with gradient
    Write-Host ""
    Write-GradientLogo -Art $Script:CurrentTheme.Logo
    Write-Host ""
    
    # Box
    Write-Host "$indent$primary$($Script:Symbols.TopLeft)$hLine$($Script:Symbols.TopRight)$($Script:Colors.Reset)"
    
    $title = "$($Script:Symbols.Skull) $($Script:CurrentTheme.Title) v$Script:Version $($Script:Symbols.Skull)"
    $titlePad = [Math]::Max(0, $boxWidth - $title.Length - 4)
    Write-Host "$indent$primary$($Script:Symbols.VLine) $secondary$title$(' ' * $titlePad)$primary$($Script:Symbols.VLine)$($Script:Colors.Reset)"
    
    Write-Host "$indent$primary$($Script:Symbols.TLeft)$hLine$($Script:Symbols.TRight)$($Script:Colors.Reset)"
    
    # System info (only if enabled)
    if ($Script:Config.ShowSystemInfo) {
        @(
            @{ L = "Operator"; V = $user; C = $Script:Colors.NeonGreen },
            @{ L = "Host"; V = $computer; C = $Script:Colors.Gold },
            @{ L = "System"; V = $os; C = $Script:Colors.Gold },
            @{ L = "Uptime"; V = $uptime; C = $Script:Colors.NeonCyan },
            @{ L = "Time"; V = $datetime; C = $Script:Colors.NeonCyan }
        ) | ForEach-Object {
            $content = "  $($_.L): $($_.C)$($_.V)$($Script:Colors.White)"
            $cleanLen = ("  " + $_.L + ": " + $_.V).Length
            $rightPad = [Math]::Max(0, $boxWidth - $cleanLen - 3)
            Write-Host "$indent$primary$($Script:Symbols.VLine)$($Script:Colors.White)$content$(' ' * $rightPad)$primary$($Script:Symbols.VLine)$($Script:Colors.Reset)"
        }
        
        Write-Host "$indent$primary$($Script:Symbols.TLeft)$hLine$($Script:Symbols.TRight)$($Script:Colors.Reset)"
    }
    
    # Quote inside box
    $quote = $Script:CurrentTheme.Quotes[(Get-Random -Max $Script:CurrentTheme.Quotes.Count)]
    $quotePad = [Math]::Max(0, $boxWidth - $quote.Length - 4)
    Write-Host "$indent$primary$($Script:Symbols.VLine) $($Script:Colors.Gray)$quote$(' ' * $quotePad)$primary$($Script:Symbols.VLine)$($Script:Colors.Reset)"
    
    Write-Host "$indent$primary$($Script:Symbols.BottomLeft)$hLine$($Script:Symbols.BottomRight)$($Script:Colors.Reset)"
    Write-Host ""
    
    # Update notification
    if ($Script:UpdateAvailable) {
        if ($Script:UpdateDownloaded) {
            Write-Host "$indent$($Script:Colors.NeonGreen)$($Script:Symbols.Update) Updated to v$Script:UpdateAvailable! Reopen terminal to apply.$($Script:Colors.Reset)"
        } else {
            Write-Host "$indent$($Script:Colors.Gold)$($Script:Symbols.Update) Update v$Script:UpdateAvailable available (run 'phantom-update')$($Script:Colors.Reset)"
        }
        Write-Host ""
    }
    
    $helpCmd = if ($Script:CurrentTheme.Name -eq "Unknown") { "unknown-help" } else { "phantom-help" }
    Write-Host "$indent$($Script:Colors.DarkGray)Type '$($Script:Colors.Gold)$helpCmd$($Script:Colors.DarkGray)' for commands.$($Script:Colors.Reset)"
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════

function Start-PhantomTerminal {
    if (-not $Script:Config.AnimationEnabled) { Show-Dashboard; return }
    
    try {
        Hide-Cursor
        Show-CoreIgnition
        Show-SecuritySequence
        Show-MultiColorMatrix -DurationSeconds $Script:Config.MatrixDuration
        Show-GlitchReveal -Art $Script:CurrentTheme.Logo -Color (Get-ThemeColor "Primary")
        Show-Dashboard
    } catch {
        Write-Host "$($Script:Colors.BloodRed)Animation error: $_$($Script:Colors.Reset)"
        Show-Dashboard
    } finally { Show-Cursor }
    
    # Check for updates AFTER dashboard loads (non-blocking background job)
    if ($Script:Config.AutoCheckUpdates) {
        Start-Job -ScriptBlock {
            param($RepoOwner, $RepoName, $CurrentVersion, $ConfigDir, $CacheFile, $ScriptPath, $SilentUpdate)
            
            try {
                # Load cache
                $cache = @{ LastUpdateCheck = $null; LatestVersion = $null; UpdateDownloaded = $false }
                if (Test-Path $CacheFile) {
                    try {
                        $json = Get-Content $CacheFile -Raw | ConvertFrom-Json
                        $cache.LastUpdateCheck = $json.LastUpdateCheck
                        $cache.LatestVersion = $json.LatestVersion
                        $cache.UpdateDownloaded = $json.UpdateDownloaded
                    } catch {}
                }
                
                # Check if already checked today
                if ($cache.LastUpdateCheck) {
                    try {
                        $lastCheck = [DateTime]::Parse($cache.LastUpdateCheck)
                        if (((Get-Date) - $lastCheck).TotalDays -lt 1) { return }
                    } catch {}
                }
                
                # Check GitHub
                $apiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/releases/latest"
                $response = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 5
                $latestVersion = $response.tag_name -replace '^v', ''
                
                $cache.LastUpdateCheck = (Get-Date).ToString("o")
                $cache.LatestVersion = $latestVersion
                
                if ($latestVersion -gt $CurrentVersion -and $SilentUpdate) {
                    # Download update
                    $scriptUrl = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/main/PhantomStartup.ps1"
                    $tempFile = "$env:TEMP\PhantomStartup_new.ps1"
                    Invoke-WebRequest -Uri $scriptUrl -OutFile $tempFile -UseBasicParsing -TimeoutSec 10
                    Copy-Item $tempFile $ScriptPath -Force
                    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
                    $cache.UpdateDownloaded = $true
                }
                
                # Save cache
                $cache | ConvertTo-Json | Out-File $CacheFile -Encoding UTF8 -Force
            } catch {}
        } -ArgumentList $Script:RepoOwner, $Script:RepoName, $Script:Version, $Script:ConfigDir, $Script:CacheFile, "$HOME\PhantomStartup.ps1", $Script:Config.SilentUpdate | Out-Null
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# PROMPT
# ═══════════════════════════════════════════════════════════════════════════

function Set-PhantomPrompt {
    function global:prompt {
        $lastSuccess = $?
        
        if ($Script:Config.ShowFullPath) {
            $pathDisplay = (Get-Location).Path
        } else {
            $pathDisplay = Split-Path (Get-Location).Path -Leaf
            if (-not $pathDisplay) { $pathDisplay = (Get-Location).Path }
        }
        
        $gitBranch = ""
        if (Test-Path .git -ErrorAction SilentlyContinue) {
            try { $b = git branch --show-current 2>$null; if ($b) { $gitBranch = " $($Script:Colors.DarkGray)on $($Script:Colors.HotPink)$b" } } catch {}
        }
        
        $status = if ($lastSuccess) { "$($Script:Colors.NeonGreen)$($Script:Symbols.Success)" } else { "$($Script:Colors.BloodRed)$($Script:Symbols.Failure)" }
        $primary = Get-ThemeColor "Primary"
        
        "$primary$env:USERNAME$($Script:Colors.DarkGray)@$($Script:Colors.NeonCyan)$pathDisplay$gitBranch$($Script:Colors.Reset)`n$status $primary$($Script:Symbols.Prompt)$($Script:Colors.Reset) "
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# SMART SUGGESTIONS (Local history-based predictions - No data collection)
# ═══════════════════════════════════════════════════════════════════════════

function Set-SmartSuggestions {
    if (-not $Script:Config.SmartSuggestions) { return }
    
    try {
        # Try to load latest version if available (fixes 2.0.0 default issue)
        $latest = Get-Module PSReadLine -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
        if ($latest -and $latest.Version -ge [version]"2.2.0") {
            if ((Get-Module PSReadLine).Version -lt $latest.Version) {
                Remove-Module PSReadLine -ErrorAction SilentlyContinue
                Import-Module PSReadLine -Version $latest.Version -ErrorAction SilentlyContinue
            }
        }

        # Check PSReadLine version (2.2.0+ required)
        $psrl = Get-Module PSReadLine -ErrorAction SilentlyContinue
        if (-not $psrl -or $psrl.Version -lt [version]"2.2.0") { return }
        
        # === CORE: Enable inline predictions ===
        Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
        Set-PSReadLineOption -PredictionViewStyle InlineView -ErrorAction SilentlyContinue
        
        # Theme-based color (purple for Phantom, green for Unknown)
        $color = if ($Script:CurrentTheme.Name -eq "Unknown") { "DarkGreen" } else { "DarkMagenta" }
        Set-PSReadLineOption -Colors @{ InlinePrediction = $color } -ErrorAction SilentlyContinue
        
        # === PERFORMANCE ===
        Set-PSReadLineOption -BellStyle None -ErrorAction SilentlyContinue
        Set-PSReadLineOption -HistoryNoDuplicates $true -ErrorAction SilentlyContinue
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd $true -ErrorAction SilentlyContinue
        Set-PSReadLineOption -MaximumHistoryCount 5000 -ErrorAction SilentlyContinue
        
        # === SIMPLE KEYBINDINGS (guaranteed to work) ===
        # F2 = Accept full suggestion (never conflicts)
        Set-PSReadLineKeyHandler -Key F2 -Function AcceptSuggestion -ErrorAction SilentlyContinue
        
        # Ctrl+F = Accept suggestion (like terminal convention)
        Set-PSReadLineKeyHandler -Key Ctrl+f -Function AcceptSuggestion -ErrorAction SilentlyContinue
        
        # End = Accept suggestion
        Set-PSReadLineKeyHandler -Key End -Function AcceptSuggestion -ErrorAction SilentlyContinue
        
    } catch {
        # Silent fail
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# COMMANDS
# ═══════════════════════════════════════════════════════════════════════════

function global:phantom-reload { Start-PhantomTerminal }
function global:phantom-matrix { Hide-Cursor; Show-MultiColorMatrix -DurationSeconds 5; Show-Cursor }
function global:phantom-dash { Show-Dashboard }
function global:phantom-update { Update-PhantomTerminal }

function global:phantom-help {
    $prefix = if ($Script:CurrentTheme.Name -eq "Unknown") { "unknown" } else { "phantom" }
    Write-Host ""
    Write-Host "$($Script:Colors.NeonCyan)=== $($Script:CurrentTheme.Title) v$Script:Version ===$($Script:Colors.Reset)"
    Write-Host ""
    Write-Host "  $($Script:Colors.Gold)$prefix-reload$($Script:Colors.White)  - Replay animation$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)$prefix-theme$($Script:Colors.White)   - Switch theme$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)$prefix-config$($Script:Colors.White)  - Show/edit config$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)$prefix-matrix$($Script:Colors.White)  - Matrix animation$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)$prefix-dash$($Script:Colors.White)    - Show dashboard$($Script:Colors.Reset)"
    Write-Host "  $($Script:Colors.Gold)$prefix-update$($Script:Colors.White)  - Check updates$($Script:Colors.Reset)"
    Write-Host ""
}

# Unknown theme aliases
function global:unknown-help { phantom-help }
function global:unknown-reload { Start-PhantomTerminal }
function global:unknown-theme { param([string]$ThemeName) phantom-theme $ThemeName }
function global:unknown-matrix { Show-MultiColorMatrix -DurationSeconds $Script:Config.MatrixDuration }
function global:unknown-dash { Show-Dashboard }
function global:unknown-update { Update-PhantomTerminal }
function global:unknown-config { param([switch]$Edit) if ($Edit) { notepad $Script:ConfigFile } else { phantom-config } }

function global:phantom-config {
    param([switch]$Edit)
    if ($Edit) { notepad $Script:ConfigFile } 
    else {
        Write-Host "`n$($Script:Colors.NeonCyan)Config: $Script:ConfigFile$($Script:Colors.Reset)`n"
        $Script:Config.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host "  $($Script:Colors.Gold)$($_.Key)$($Script:Colors.White): $($_.Value)$($Script:Colors.Reset)"
        }
        Write-Host "`n$($Script:Colors.DarkGray)Run: phantom-config -Edit$($Script:Colors.Reset)`n"
    }
}

function global:phantom-theme {
    param([string]$ThemeName)
    
    $available = $Script:Themes.Keys -join ", "
    
    if (-not $ThemeName) {
        Write-Host "`n$($Script:Colors.NeonCyan)Available themes: $available$($Script:Colors.Reset)"
        Write-Host "$($Script:Colors.Gold)Current: $($Script:Config.Theme)$($Script:Colors.Reset)"
        Write-Host "$($Script:Colors.DarkGray)Usage: phantom-theme Unknown$($Script:Colors.Reset)`n"
        return
    }
    
    $matchedKey = $null
    foreach ($key in $Script:Themes.Keys) {
        if ($key -ieq $ThemeName) { $matchedKey = $key; break }
    }
    
    if ($matchedKey) {
        $Script:Config.Theme = $matchedKey
        Save-PhantomConfig -Config $Script:Config
        $Script:CurrentTheme = $Script:Themes[$matchedKey]
        Write-Host "$($Script:Colors.NeonGreen)Theme changed to: $matchedKey$($Script:Colors.Reset)"
        Write-Host "$($Script:Colors.DarkGray)Run 'phantom-reload' to see changes$($Script:Colors.Reset)"
    } else {
        Write-Host "$($Script:Colors.BloodRed)Unknown theme. Available: $available$($Script:Colors.Reset)"
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# [REDACTED]
# ═══════════════════════════════════════════════════════════════════════════

$Script:SecretsFound = @()

# Secret 1: Type phantom-chosen to unlock
function global:phantom-chosen {
    if ("chosen" -notin $Script:SecretsFound) { $Script:SecretsFound += "chosen" }
    Write-Host ""
    Write-Host "  YOU ARE THE CHOSEN ONE" -ForegroundColor Yellow
    Write-Host "  The Matrix has you..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Secret unlocked!" -ForegroundColor Magenta
    Write-Host ""
}

function global:phantom-2829 {
    if ("2829" -notin $Script:SecretsFound) { $Script:SecretsFound += "2829" }
    
    Clear-Host
    Hide-Cursor
    
    # Get console width for centering
    $width = $Host.UI.RawUI.WindowSize.Width
    function Center($text) { 
        $pad = [math]::Max(0, ($width - $text.Length) / 2)
        return (" " * $pad) + $text
    }
    
    Write-Host ""
    Write-Host ""
    Write-Host ""
    
    Start-Sleep -Milliseconds 500
    Write-Host (Center "PHANTOM TERMINAL") -ForegroundColor Magenta
    Start-Sleep -Milliseconds 400
    
    Write-Host (Center "=================") -ForegroundColor DarkMagenta
    Start-Sleep -Milliseconds 600
    
    Write-Host ""
    Write-Host ""
    Write-Host (Center "Created with <3 by") -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 500
    
    Write-Host ""
    Write-Host (Center "UNKNOWN-2829") -ForegroundColor Cyan
    Start-Sleep -Milliseconds 600
    
    Write-Host ""
    Write-Host ""
    Write-Host (Center "Github:- github.com/Unknown-2829") -ForegroundColor Blue
    Start-Sleep -Milliseconds 400
    
    Write-Host (Center "Telegram:- @unknownll2829") -ForegroundColor Cyan
    Start-Sleep -Milliseconds 600
    
    Write-Host ""
    Write-Host ""
    Write-Host (Center "'Build different. Think different.'") -ForegroundColor Yellow
    Start-Sleep -Milliseconds 700
    
    Write-Host ""
    Write-Host ""
    Write-Host (Center "Thank you for using Phantom Terminal!") -ForegroundColor Green
    Start-Sleep -Milliseconds 800
    
    Write-Host ""
    Write-Host ""
    Write-Host (Center "---") -ForegroundColor DarkGray
    Start-Sleep -Milliseconds 300
    Write-Host (Center "Secret unlocked!") -ForegroundColor Magenta
    Write-Host ""
    
    Show-Cursor
}

function global:phantom-secrets {
    if ("secrets" -notin $Script:SecretsFound) { $Script:SecretsFound += "secrets" }
    
    Write-Host ""
    Write-Host "  === SECRETS DISCOVERED ===" -ForegroundColor Yellow
    Write-Host ""
    
    $total = 3
    $found = $Script:SecretsFound.Count
    
    if ("chosen" -in $Script:SecretsFound) {
        Write-Host "  [+] The Chosen One" -ForegroundColor Green
    } else {
        Write-Host "  [?] ???" -ForegroundColor DarkGray
    }
    
    if ("2829" -in $Script:SecretsFound) {
        Write-Host "  [+] Creator's Mark" -ForegroundColor Green
    } else {
        Write-Host "  [?] ???" -ForegroundColor DarkGray
    }
    
    if ("secrets" -in $Script:SecretsFound) {
        Write-Host "  [+] Secret Hunter" -ForegroundColor Green
    } else {
        Write-Host "  [?] ???" -ForegroundColor DarkGray
    }
    
    Write-Host ""
    Write-Host "  $found/$total secrets found" -ForegroundColor DarkGray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════
# ENTRY
# ═══════════════════════════════════════════════════════════════════════════

Set-PhantomPrompt
Set-SmartSuggestions
Start-PhantomTerminal

