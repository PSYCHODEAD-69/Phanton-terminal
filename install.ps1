<#
.SYNOPSIS
    Phantom Terminal - Fast Installer v3.6.1
.DESCRIPTION
    Optimized installer with reliable config persistence.
    Run: irm https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main/install.ps1 | iex
#>

# Fast init
$ErrorActionPreference = "Stop"
$RepoUrl = "https://raw.githubusercontent.com/Unknown-2829/Phanton-terminal/main"
$InstallPath = "$HOME\PhantomStartup.ps1"
$ConfigDir = "$HOME\.phantom-terminal"
$ConfigFile = "$ConfigDir\config.json"

# ANSI Colors (cached)
$E = [char]27
$Purple = "$E[38;5;129m"; $Cyan = "$E[38;5;87m"; $Green = "$E[38;5;118m"
$Blue = "$E[38;5;39m"; $Gold = "$E[38;5;220m"; $Red = "$E[38;5;196m"
$White = "$E[1;37m"; $Gray = "$E[38;5;244m"; $DGray = "$E[38;5;240m"; $R = "$E[0m"

# Fast config load
$cfg = @{ Theme = "Phantom"; MatrixMode = "Letters"; ShowFullPath = $true; GradientText = $true; AutoCheckUpdates = $true; ShowSystemInfo = $true }
if (Test-Path $ConfigFile) {
    try {
        $json = Get-Content $ConfigFile -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
        if ($json.Theme) { $cfg.Theme = $json.Theme }
        if ($json.MatrixMode) { $cfg.MatrixMode = $json.MatrixMode }
        if ($null -ne $json.ShowFullPath) { $cfg.ShowFullPath = $json.ShowFullPath }
        if ($null -ne $json.GradientText) { $cfg.GradientText = $json.GradientText }
        if ($null -ne $json.AutoCheckUpdates) { $cfg.AutoCheckUpdates = $json.AutoCheckUpdates }
        if ($null -ne $json.ShowSystemInfo) { $cfg.ShowSystemInfo = $json.ShowSystemInfo }
    } catch {}
}

# Header
Clear-Host
Write-Host ""
Write-Host "$Purple  ╔══════════════════════════════════════════════════════╗$R"
Write-Host "$Purple  ║$Cyan        PHANTOM TERMINAL INSTALLER v3.6.1          $Purple║$R"
Write-Host "$Purple  ╚══════════════════════════════════════════════════════╝$R"
Write-Host ""

# Clean previous
$isReinstall = Test-Path $InstallPath
if ($isReinstall) {
    Write-Host "  ${Gold}[*]${Gray} Reinstalling (your settings are preserved)...$R"
    Remove-Item $InstallPath -Force -ErrorAction SilentlyContinue
    if (Test-Path $PROFILE) {
        try {
            $p = Get-Content $PROFILE -Raw
            if ($p -match 'PhantomStartup') {
                ($p -split "`n" | Where-Object { $_ -notmatch 'PhantomStartup|Phantom Terminal' }) -join "`n" | Set-Content $PROFILE -Force
            }
        } catch {}
    }
    Write-Host "  ${Green}[+]${White} Ready$R"
    Write-Host ""
}

# === THEME ===
Write-Host "  ${Gold}[1] THEME$R"
$d1 = if ($cfg.Theme -eq "Unknown") { "2" } else { "1" }
Write-Host "  ${Purple}[1] Phantom$R  ${Green}[2] Unknown$R  ${DGray}(current: $($cfg.Theme))$R"
Write-Host "  Choice [Enter=$d1]: " -NoNewline
$c = Read-Host; if (-not $c) { $c = $d1 }
$Theme = if ($c -eq "2") { "Unknown" } else { "Phantom" }
Write-Host "  ${Green}→ $Theme$R"; Write-Host ""

# === MATRIX ===
Write-Host "  ${Gold}[2] MATRIX RAIN$R"
$d2 = if ($cfg.MatrixMode -eq "Binary") { "2" } else { "1" }
Write-Host "  ${Cyan}[1] Letters$R  ${Green}[2] Binary$R  ${DGray}(current: $($cfg.MatrixMode))$R"
Write-Host "  Choice [Enter=$d2]: " -NoNewline
$c = Read-Host; if (-not $c) { $c = $d2 }
$MatrixMode = if ($c -eq "2") { "Binary" } else { "Letters" }
Write-Host "  ${Green}→ $MatrixMode$R"; Write-Host ""

# === PATH ===
Write-Host "  ${Gold}[3] PROMPT PATH$R"
$d3 = if ($cfg.ShowFullPath) { "1" } else { "2" }
Write-Host "  ${Cyan}[1] Full path$R  ${Blue}[2] Folder only$R  ${DGray}(current: $(if ($cfg.ShowFullPath) {'Full'} else {'Folder'}))$R"
Write-Host "  Choice [Enter=$d3]: " -NoNewline
$c = Read-Host; if (-not $c) { $c = $d3 }
$ShowFullPath = $c -ne "2"
Write-Host "  ${Green}→ $(if ($ShowFullPath) {'Full path'} else {'Folder only'})$R"; Write-Host ""

# === OPTIONS ===
Write-Host "  ${Gold}[4] OPTIONS$R"

$dS = if ($cfg.ShowSystemInfo -eq $false) { "n" } else { "Y" }
Write-Host "  Show system info? [Y/n, Enter=$dS]: " -NoNewline
$c = Read-Host; if (-not $c) { $c = $dS }
$ShowSystemInfo = $c -ne "n" -and $c -ne "N"

$dG = if ($cfg.GradientText) { "Y" } else { "n" }
Write-Host "  Gradient logo? [Y/n, Enter=$dG]: " -NoNewline
$c = Read-Host; if (-not $c) { $c = $dG }
$GradientText = $c -ne "n" -and $c -ne "N"

$dA = if ($cfg.AutoCheckUpdates) { "Y" } else { "n" }
Write-Host "  Auto-update? [Y/n, Enter=$dA]: " -NoNewline
$c = Read-Host; if (-not $c) { $c = $dA }
$AutoUpdate = $c -ne "n" -and $c -ne "N"

$dSS = if ($cfg.SmartSuggestions -eq $false) { "n" } else { "Y" }
Write-Host "  Smart Suggestions? [Y/n, Enter=$dSS]: " -NoNewline
$c = Read-Host; if (-not $c) { $c = $dSS }
$SmartSuggestions = $c -ne "n" -and $c -ne "N"
Write-Host ""

# === INSTALL ===
Write-Host "  ${Gold}═══ INSTALLING ═══$R"; Write-Host ""

# Check Dependencies (Smart Suggestions)
if ($SmartSuggestions) {
    Write-Host "  ${Cyan}[1/4]${White} Checking dependencies...$R"
    try {
        $psrl = Get-Module PSReadLine -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
        if (-not $psrl -or $psrl.Version -lt [version]"2.2.0") {
            Write-Host "  ${Gray}Installing PSReadLine 2.2.6+ (required for suggestions)...$R"
            
            # First try CurrentUser scope (no admin needed)
            try {
                Install-Module PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -AllowPrerelease -ErrorAction Stop
                Write-Host "  ${Green}[+] PSReadLine installed (CurrentUser)$R"
            } catch {
                # Retry without AllowPrerelease (fix for generic Install-Module error)
                try {
                    Install-Module PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
                    Write-Host "  ${Green}[+] PSReadLine installed (Stable)$R"
                } catch {
                    Write-Host "  ${Red}[!] Could not auto-install PSReadLine. Try running as Admin.$R"
                    Write-Host "  ${Gray}    Suggestions might not work until installed.$R"
                }
            }
        } else {
            Write-Host "  ${Green}[+] Dependencies OK$R"
        }
    } catch {}
}

try {
    # Download
    Write-Host "  ${Cyan}[2/4]${White} Downloading...$R"
    Invoke-WebRequest -Uri "$RepoUrl/PhantomStartup.ps1" -OutFile $InstallPath -UseBasicParsing -TimeoutSec 30
    Write-Host "  ${Green}[+] Downloaded$R"

    # Profile
    Write-Host "  ${Cyan}[3/4]${White} Profile...$R"
    if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force | Out-Null }
    Add-Content $PROFILE "`n# Phantom Terminal`n. `"$InstallPath`""
    Write-Host "  ${Green}[+] Profile updated$R"

    # Config (reliable save)
    Write-Host "  ${Cyan}[4/4]${White} Config...$R"
    if (!(Test-Path $ConfigDir)) { New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null }
    
    $config = @{
        AnimationEnabled = $true
        MatrixDuration = 2
        MatrixMode = $MatrixMode
        SecurityLoadSteps = 8
        GlitchIntensity = 3
        ShowSystemInfo = $ShowSystemInfo
        ShowFullPath = $ShowFullPath
        GradientText = $GradientText
        SmartSuggestions = $SmartSuggestions
        Theme = $Theme
        AutoCheckUpdates = $AutoUpdate
        SilentUpdate = $true
        UpdateCheckDays = 1
    }
    $config | ConvertTo-Json -Depth 3 | Out-File $ConfigFile -Encoding UTF8 -Force
    Write-Host "  ${Green}[+] Config saved$R"

    Write-Host ""
    Write-Host "  ${Green}╔════════════════════════════════════════════════╗$R"
    Write-Host "  ${Green}║${White}         INSTALLATION COMPLETE!              ${Green}║$R"
    Write-Host "  ${Green}╚════════════════════════════════════════════════╝$R"
    Write-Host ""
    Write-Host "  ${Cyan}Restart terminal to see the animation!$R"
    Write-Host ""
    Write-Host "  ${Gold}Settings:${White} $Theme | $MatrixMode | $(if ($ShowFullPath) {'Full'} else {'Folder'})$R"
    Write-Host "  ${Gold}Commands:${White} ${Gold}phantom-help${Gray} | ${Gold}phantom-theme${Gray} | ${Gold}phantom-config$R"
    Write-Host ""

} catch {
    Write-Host "  ${Red}[x] Failed: $_$R"
    exit 1
}
