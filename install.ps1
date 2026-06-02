# Agentic Dev Multi-Tool Installer for Windows
# Compatible with: Windows 7+ with PowerShell 5.0+
#
# Usage:
#   Interactive: powershell -ExecutionPolicy Bypass -File install.ps1
#   Headless:    powershell -ExecutionPolicy Bypass -File install.ps1 -Tools copilot,opencode,cursor
#   Uninstall:   powershell -ExecutionPolicy Bypass -File install.ps1 -Action uninstall -Tools copilot
#   Verify:      powershell -ExecutionPolicy Bypass -File install.ps1 -Action verify
#
# Set execution policy if needed:
#   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

param(
    [ValidateSet('install', 'uninstall', 'verify')]
    [string]$Action = 'install',
    [string]$Tools = '',
    [switch]$DryRun
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserProfile = $env:USERPROFILE

# -- Tool definitions ---------------------------------------------------------
$ToolDefs = @(
    @{ id='copilot';       name='GitHub Copilot (VS Code)';    desc='Installs to ~\.copilot\' }
    @{ id='opencode';      name='OpenCode';                    desc='Symlinks skills to ~\.agents\skills\' }
    @{ id='cursor';        name='Cursor';                      desc='Installs to ~\.cursor\' }
    @{ id='windsurf';      name='Windsurf (Codeium)';          desc='Installs instructions to ~\.windsurf\' }
    @{ id='antigravity';   name='Antigravity';                 desc='Symlinks skills to ~\.agents\skills\' }
    @{ id='claude-code';   name='Claude Code';                 desc='Installs skills to ~\.claude\skills\' }
    @{ id='cline';         name='Cline (VS Code Ext)';         desc='Copies to project .clinerules' }
    @{ id='zed';           name='Zed';                         desc='Installs instructions to ~\.config\zed\' }
)

$SourceDirs = @('agents', 'instructions', 'prompts', 'skills')

# -- Color helpers ------------------------------------------------------------
function Write-Header   { param([string]$M) Write-Host "  $M" -ForegroundColor Cyan }
function Write-Success  { param([string]$M) Write-Host "    $M" -ForegroundColor Green }
function Write-Error    { param([string]$M) Write-Host "    $M" -ForegroundColor Red }
function Write-Info     { param([string]$M) Write-Host "    $M" -ForegroundColor Yellow }
function Write-Warn     { param([string]$M) Write-Host "    $M" -ForegroundColor Magenta }

# -- UI helpers ---------------------------------------------------------------
function Draw-BoxLine {
    param([string]$Char, [int]$Width=60)
    $line = ''
    for ($i = 0; $i -lt $Width; $i++) { $line += $Char }
    Write-Host $line -ForegroundColor Cyan
}

# -- Source checks ------------------------------------------------------------
function Check-SourceDirs {
    $all = $true
    foreach ($d in $SourceDirs) {
        $p = Join-Path $ScriptDir $d
        if (-not (Test-Path $p)) { Write-Error "[MISSING] $d"; $all = $false }
    }
    return $all
}

# -- Tool target paths --------------------------------------------------------
function Get-TargetPaths {
    param([string]$ToolId)
    switch ($ToolId) {
        'copilot'     { return @{ base="$UserProfile\.copilot"; subs=@('agents','instructions','prompts','skills') } }
        'opencode'    { return @{ base="$UserProfile\.agents\skills"; subs=@(); isSymlink=$true } }
        'cursor'      { return @{ base="$UserProfile\.cursor"; subs=@('instructions','agents') } }
        'windsurf'    { return @{ base="$UserProfile\.windsurf"; subs=@('instructions') } }
        'antigravity' { return @{ base="$UserProfile\.agents\skills"; subs=@(); isSymlink=$true } }
        'claude-code' { return @{ base="$UserProfile\.claude\skills"; subs=@(); isSkillCopy=$true } }
        'cline'       { return @{ base="$ScriptDir\.clinerules"; subs=@(); isSingleFile=$true } }
        'zed'         { return @{ base="$UserProfile\.config\zed"; subs=@('instructions') } }
    }
}

# -- Install helpers ----------------------------------------------------------
function Install-ToTool {
    param([string]$ToolId)
    $t = Get-TargetPaths $ToolId
    $config = $ToolDefs | Where-Object { $_.id -eq $ToolId } | Select-Object -First 1

    if ($DryRun) {
        Write-Info "[DRY-RUN] Would install to $($config.name): $($t.base)"
        return
    }

    Write-Header "$($config.name)..."
    if ($t.isSymlink) {
        $skillSource = Join-Path $ScriptDir 'skills'
        if (Test-Path $skillSource) {
            New-Item -Path $t.base -Type Directory -Force | Out-Null
            Get-ChildItem $skillSource -Directory | ForEach-Object {
                $link = Join-Path $t.base $_.Name
                if (-not (Test-Path $link)) {
                    New-Item -Path $link -ItemType Junction -Target $_.FullName | Out-Null
                }
            }
        }
    } elseif ($t.isSingleFile) {
        $src = Join-Path $ScriptDir 'instructions'
        if (Test-Path $src) {
            Copy-Item -Path (Join-Path $src '*') -Destination $t.base -Recurse -Force -ErrorAction SilentlyContinue
        }
    } elseif ($t.isSkillCopy) {
        $skillSource = Join-Path $ScriptDir 'skills'
        if (Test-Path $skillSource) {
            New-Item -Path $t.base -Type Directory -Force | Out-Null
            Copy-Item -Path (Join-Path $skillSource '*') -Destination $t.base -Recurse -Force -ErrorAction SilentlyContinue
        }
    } else {
        foreach ($sub in $t.subs) {
            $src = Join-Path $ScriptDir $sub
            $dst = Join-Path $t.base $sub
            if (Test-Path $src) {
                New-Item -Path $dst -Type Directory -Force | Out-Null
                Copy-Item -Path (Join-Path $src '*') -Destination $dst -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
    Write-Success "$($config.name) -- done"
}

function Uninstall-FromTool {
    param([string]$ToolId)
    $t = Get-TargetPaths $ToolId
    $config = $ToolDefs | Where-Object { $_.id -eq $ToolId } | Select-Object -First 1

    if ($DryRun) {
        Write-Info "[DRY-RUN] Would uninstall from $($config.name): $($t.base)"
        return
    }

    Write-Header "$($config.name)..."

    if ($t.isSymlink) {
        $skillSource = Join-Path $ScriptDir 'skills'
        if (Test-Path $skillSource -and (Test-Path $t.base)) {
            Get-ChildItem $skillSource -Directory | ForEach-Object {
                $link = Join-Path $t.base $_.Name
                if (Test-Path $link) { Remove-Item $link -Recurse -Force -ErrorAction SilentlyContinue }
            }
        }
    } elseif ($t.isSingleFile) {
        if (Test-Path $t.base) { Remove-Item $t.base -Recurse -Force -ErrorAction SilentlyContinue }
    } elseif ($t.isSkillCopy) {
        if (Test-Path $t.base) {
            $skillSource = Join-Path $ScriptDir 'skills'
            if (Test-Path $skillSource) {
                Get-ChildItem $skillSource -Directory | ForEach-Object {
                    $target = Join-Path $t.base $_.Name
                    if (Test-Path $target) { Remove-Item $target -Recurse -Force -ErrorAction SilentlyContinue }
                }
            }
        }
    } else {
        foreach ($sub in $t.subs) {
            $dst = Join-Path $t.base $sub
            if (Test-Path $dst) { Remove-Item $dst -Recurse -Force -ErrorAction SilentlyContinue }
        }
    }
    Write-Success "$($config.name) -- removed"
}

function Verify-Tool {
    param([string]$ToolId)
    $t = Get-TargetPaths $ToolId
    $config = $ToolDefs | Where-Object { $_.id -eq $ToolId } | Select-Object -First 1

    if ($t.isSymlink) {
        if (Test-Path $t.base) {
            $count = (Get-ChildItem $t.base -Directory | Measure-Object).Count
            Write-Success "$($config.name): $count skills linked"
        } else { Write-Error "$($config.name): NOT INSTALLED" }
    } elseif ($t.isSingleFile) {
        if (Test-Path $t.base) { Write-Success "$($config.name): $($t.base) exists" }
        else { Write-Error "$($config.name): NOT INSTALLED" }
    } elseif ($t.isSkillCopy) {
        if (Test-Path $t.base) {
            $count = (Get-ChildItem $t.base -Directory | Measure-Object).Count
            Write-Success "$($config.name): $count skills installed"
        } else { Write-Error "$($config.name): NOT INSTALLED" }
    } else {
        $found = 0
        foreach ($sub in $t.subs) { if (Test-Path (Join-Path $t.base $sub)) { $found++ } }
        if ($found -eq $t.subs.Count -and $found -gt 0) { Write-Success "$($config.name): installed ($found dirs)" }
        elseif ($found -gt 0) { Write-Warn "$($config.name): partial ($found/$($t.subs.Count) dirs)" }
        else { Write-Error "$($config.name): NOT INSTALLED" }
    }
}

# -- Interactive menu with arrow keys + spacebar ------------------------------
function Show-ToolMenu {
    $count = $ToolDefs.Count
    $selected = @($false) * $count
    $cursor = 0
    $selected[0] = $true
    $menuLines = $count + 1

    function Render-Items {
        param([int]$Curs, [bool[]]$Sel)
        for ($i = 0; $i -lt $count; $i++) {
            $check = if ($Sel[$i]) { '[x]' } else { '[ ]' }
            $marker = if ($i -eq $Curs) { '>' } else { ' ' }
            $text = "  $marker $check $($i+1). $($ToolDefs[$i].name)"
            if ($i -eq $Curs) { $text += "  <" }
            if ($i -eq $Curs) {
                Write-Host $text.PadRight(78) -ForegroundColor Cyan
            } else {
                Write-Host $text.PadRight(78)
            }
        }
        Write-Host "  (arrow keys: navigate | space: toggle | enter: confirm)".PadRight(78) -ForegroundColor DarkGray
    }

    Render-Items -Curs $cursor -Sel $selected

    while ($true) {
        $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        $vkey = $key.VirtualKeyCode

        if ($vkey -eq 38) {
            $cursor = ($cursor - 1 + $count) % $count
        } elseif ($vkey -eq 40) {
            $cursor = ($cursor + 1) % $count
        } elseif ($vkey -eq 32) {
            $selected[$cursor] = -not $selected[$cursor]
        } elseif ($vkey -eq 13) {
            break
        } else {
            continue
        }

        Write-Host "`e[${menuLines}A" -NoNewline
        Render-Items -Curs $cursor -Sel $selected
    }

    Write-Host ""
    $result = @()
    for ($i = 0; $i -lt $count; $i++) {
        if ($selected[$i]) { $result += $ToolDefs[$i].id }
    }
    return $result
}

# -- Main ---------------------------------------------------------------------
function Main {
    Draw-BoxLine '='
    Write-Host "  Agentic Dev -- Multi-Tool Installer" -ForegroundColor Cyan
    Draw-BoxLine '='

    if (-not (Check-SourceDirs)) {
        Write-Error "Source directories missing. Run from repo root."
        exit 1
    }
    Write-Success "All source directories found"

    # Resolve target tools
    $targetTools = @()
    if ($Tools -ne '') {
        $targetTools = $Tools -split ',' | ForEach-Object { $_.Trim().ToLower() }
        $valid = $ToolDefs.id
        $targetTools = $targetTools | Where-Object { $_ -in $valid }
        if ($targetTools.Count -eq 0) {
            Write-Error "No valid tools specified. Valid: $($valid -join ', ')"
            exit 1
        }
        Write-Host ""
    } elseif ($Action -eq 'install' -or $Action -eq 'uninstall') {
        Write-Host ""
        $targetTools = Show-ToolMenu
        if ($targetTools.Count -eq 0) {
            Write-Info "No tools selected. Exiting."
            exit 0
        }
    }

    Write-Host ""
    switch ($Action) {
        'install' {
            Draw-BoxLine '='
            Write-Host "  Installing..." -ForegroundColor Cyan
            Draw-BoxLine '='
            foreach ($tid in $targetTools) { Install-ToTool $tid }
            Write-Host ""
            Draw-BoxLine '='
            Write-Host "  Installation Summary" -ForegroundColor Cyan
            Draw-BoxLine '='
            foreach ($tid in $targetTools) { Verify-Tool $tid }
            Write-Host "`n  Next: restart your IDE or agentic tool for changes to take effect." -ForegroundColor Green
        }
        'uninstall' {
            Draw-BoxLine '='
            Write-Host "  Uninstalling..." -ForegroundColor Cyan
            Draw-BoxLine '='
            foreach ($tid in $targetTools) { Uninstall-FromTool $tid }
        }
        'verify' {
            Draw-BoxLine '='
            Write-Host "  Installation Status" -ForegroundColor Cyan
            Draw-BoxLine '='
            $allToolIds = $ToolDefs.id
            foreach ($tid in $allToolIds) { Verify-Tool $tid }
        }
    }
}

Main
