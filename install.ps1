# GitHub Copilot Configuration Installer for Windows
# Compatible with: Windows 7+ with PowerShell 5.0+
# 
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1
#
# Set execution policy if needed:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

param(
    [ValidateSet('install', 'uninstall', 'verify')]
    [string]$Action = 'install'
)

# Configuration
$CopilotDir = "$env:USERPROFILE\.copilot"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Color definitions
function Write-Header {
    param([string]$Message)
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Yellow
}

function Check-Directories {
    Write-Header "Checking Source Directory Structure"
    
    $requiredDirs = @('agents', 'instructions', 'prompts', 'skills')
    $allFound = $true
    
    foreach ($dir in $requiredDirs) {
        $dirPath = Join-Path $ScriptDir $dir
        if (Test-Path $dirPath) {
            Write-Success "Found '$dir' directory"
        } else {
            Write-Error "Missing '$dir' directory"
            $allFound = $false
        }
    }
    
    return $allFound
}

function Create-Directories {
    Write-Header "Creating Copilot Configuration Directories"
    
    $dirs = @('agents', 'instructions', 'prompts', 'skills')
    
    foreach ($dir in $dirs) {
        $dirPath = Join-Path $CopilotDir $dir
        if (-not (Test-Path $dirPath)) {
            New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
            Write-Success "Created $dirPath"
        } else {
            Write-Info "Directory already exists: $dirPath"
        }
    }
}

function Copy-Files {
    Write-Header "Installing Configuration Files"
    
    # Copy agents
    $sourcePath = Join-Path $ScriptDir "agents"
    $destPath = Join-Path $CopilotDir "agents"
    if (Test-Path $sourcePath) {
        Get-ChildItem $sourcePath -Recurse | Copy-Item -Destination {
            if ($_.FullName.StartsWith($sourcePath)) {
                Join-Path $destPath $_.FullName.Substring($sourcePath.Length)
            }
        } -Force 2>$null
        Write-Success "Installed agents"
    }
    
    # Copy instructions
    $sourcePath = Join-Path $ScriptDir "instructions"
    $destPath = Join-Path $CopilotDir "instructions"
    if (Test-Path $sourcePath) {
        Copy-Item -Path (Join-Path $sourcePath "*") -Destination $destPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Success "Installed instructions"
    }
    
    # Copy prompts
    $sourcePath = Join-Path $ScriptDir "prompts"
    $destPath = Join-Path $CopilotDir "prompts"
    if (Test-Path $sourcePath) {
        Copy-Item -Path (Join-Path $sourcePath "*") -Destination $destPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Success "Installed prompts"
    }
    
    # Copy skills
    $sourcePath = Join-Path $ScriptDir "skills"
    $destPath = Join-Path $CopilotDir "skills"
    if (Test-Path $sourcePath) {
        Copy-Item -Path (Join-Path $sourcePath "*") -Destination $destPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Success "Installed skills"
    }
}

function Verify-Installation {
    Write-Header "Verifying Installation"
    
    Write-Host ""
    Write-Host "Agents:" -ForegroundColor Cyan
    $agentsPath = Join-Path $CopilotDir "agents"
    if (Test-Path $agentsPath) {
        Get-ChildItem $agentsPath -Name | ForEach-Object { "  $_" }
    } else {
        Write-Error "Agents directory not found"
    }
    
    Write-Host ""
    Write-Host "Instructions:" -ForegroundColor Cyan
    $instructionsPath = Join-Path $CopilotDir "instructions"
    if (Test-Path $instructionsPath) {
        Get-ChildItem $instructionsPath -Name | ForEach-Object { "  $_" }
    } else {
        Write-Error "Instructions directory not found"
    }
    
    Write-Host ""
    Write-Host "Prompts:" -ForegroundColor Cyan
    $promptsPath = Join-Path $CopilotDir "prompts"
    if (Test-Path $promptsPath) {
        Get-ChildItem $promptsPath -Name | ForEach-Object { "  $_" }
    } else {
        Write-Error "Prompts directory not found"
    }
    
    Write-Host ""
    Write-Host "Skills:" -ForegroundColor Cyan
    $skillsPath = Join-Path $CopilotDir "skills"
    if (Test-Path $skillsPath) {
        Get-ChildItem $skillsPath -Name | ForEach-Object { "  $_" }
    } else {
        Write-Error "Skills directory not found"
    }
}

function Print-NextSteps {
    Write-Header "Installation Complete!"
    
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Green
    Write-Host "  1. Restart Visual Studio Code"
    Write-Host "  2. Open Copilot Chat (Ctrl+Shift+I or @-menu)"
    Write-Host "  3. Your new agents, skills, and instructions will be available"
    Write-Host ""
    Write-Host "Configuration Directory:" -ForegroundColor Yellow
    Write-Host "  $CopilotDir"
    Write-Host ""
}

function Uninstall-Configuration {
    Write-Header "Uninstalling GitHub Copilot Configuration"
    
    $response = Read-Host "Are you sure you want to remove all Copilot customizations? (yes/no)"
    
    if ($response -eq "yes") {
        $dirs = @('agents', 'instructions', 'prompts', 'skills')
        
        foreach ($dir in $dirs) {
            $dirPath = Join-Path $CopilotDir $dir
            if (Test-Path $dirPath) {
                Remove-Item -Path $dirPath -Recurse -Force
                Write-Success "Removed $dir"
            }
        }
        Write-Success "Uninstallation complete"
    } else {
        Write-Info "Uninstallation cancelled"
    }
}

function Show-Help {
    Write-Host "GitHub Copilot Configuration Installer for Windows" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: powershell -ExecutionPolicy Bypass -File install.ps1 [-Action <action>]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Actions:" -ForegroundColor Cyan
    Write-Host "  install    Install GitHub Copilot configuration (default)"
    Write-Host "  uninstall  Remove all Copilot customizations"
    Write-Host "  verify     Verify current installation"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  powershell -ExecutionPolicy Bypass -File install.ps1"
    Write-Host "  powershell -ExecutionPolicy Bypass -File install.ps1 -Action verify"
    Write-Host "  powershell -ExecutionPolicy Bypass -File install.ps1 -Action uninstall"
    Write-Host ""
}

# Main script execution
switch ($Action) {
    'install' {
        Write-Header "GitHub Copilot Configuration Installer for Windows"
        Write-Host ""
        
        if (-not (Check-Directories)) {
            Write-Error "Required directories are missing. Please ensure you're running this script from the repository root."
            exit 1
        }
        
        Create-Directories
        Copy-Files
        Verify-Installation
        Print-NextSteps
    }
    
    'uninstall' {
        Uninstall-Configuration
    }
    
    'verify' {
        Verify-Installation
    }
    
    default {
        Show-Help
        exit 1
    }
}
