# GitHub Copilot Configuration Installation Guide

This guide provides step-by-step instructions to install custom agents, skills, instructions, and prompts for GitHub Copilot on Windows, macOS, and Linux.

## Prerequisites

- GitHub Copilot extension installed in VS Code
- Git (optional, for cloning the repository)
- Appropriate shell access (Bash for macOS/Linux, PowerShell for Windows)

## Installation Methods

### Option 1: Quick Installation Scripts (Recommended)

#### Windows (PowerShell)
```powershell
# Run PowerShell as Administrator and execute:
powershell -ExecutionPolicy Bypass -File install.ps1
```

Or copy and paste this directly in PowerShell:
```powershell
# Clone or download the repository
git clone https://github.com/yourusername/copilot-config.git
cd copilot-config

# Run the installation script
powershell -ExecutionPolicy Bypass -File install.ps1
```

#### macOS and Linux (Bash)
```bash
# Clone or download the repository
git clone https://github.com/yourusername/copilot-config.git
cd copilot-config

# Run the installation script
chmod +x install.sh
./install.sh
```

### Option 2: Manual Installation

#### Step 1: Locate Your Copilot Configuration Directory

**Windows:**
```powershell
$copilotDir = "$env:USERPROFILE\.copilot"
```

**macOS and Linux:**
```bash
copilotDir=~/.copilot
```

#### Step 2: Create Required Directories

**Windows (PowerShell):**
```powershell
$dirs = @('agents', 'instructions', 'prompts', 'skills')
foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.copilot\$dir" -Force | Out-Null
}
```

**macOS and Linux (Bash):**
```bash
mkdir -p ~/.copilot/{agents,instructions,prompts,skills}
```

#### Step 3: Copy Configuration Files

**Windows (PowerShell):**
```powershell
# Replace <source-path> with the path to your copilot-config directory
$sourceDir = "<source-path>\copilot-config"
$copilotDir = "$env:USERPROFILE\.copilot"

Copy-Item -Path "$sourceDir\agents\*" -Destination "$copilotDir\agents\" -Recurse -Force
Copy-Item -Path "$sourceDir\instructions\*" -Destination "$copilotDir\instructions\" -Recurse -Force
Copy-Item -Path "$sourceDir\prompts\*" -Destination "$copilotDir\prompts\" -Recurse -Force
Copy-Item -Path "$sourceDir\skills\*" -Destination "$copilotDir\skills\" -Recurse -Force

Write-Host "Installation complete!" -ForegroundColor Green
```

**macOS and Linux (Bash):**
```bash
# Replace <source-path> with the path to your copilot-config directory
SOURCE_DIR="<source-path>/copilot-config"

cp -r "$SOURCE_DIR/agents"/* ~/.copilot/agents/
cp -r "$SOURCE_DIR/instructions"/* ~/.copilot/instructions/
cp -r "$SOURCE_DIR/prompts"/* ~/.copilot/prompts/
cp -r "$SOURCE_DIR/skills"/* ~/.copilot/skills/

echo "Installation complete!"
```

#### Step 4: Verify Installation

**Windows (PowerShell):**
```powershell
$copilotDir = "$env:USERPROFILE\.copilot"

Write-Host "=== Agents ===" -ForegroundColor Cyan
Get-ChildItem "$copilotDir\agents" -Name

Write-Host "`n=== Instructions ===" -ForegroundColor Cyan
Get-ChildItem "$copilotDir\instructions" -Name

Write-Host "`n=== Prompts ===" -ForegroundColor Cyan
Get-ChildItem "$copilotDir\prompts" -Name

Write-Host "`n=== Skills ===" -ForegroundColor Cyan
Get-ChildItem "$copilotDir\skills" -Name
```

**macOS and Linux (Bash):**
```bash
echo "=== Agents ===" && ls -1 ~/.copilot/agents/
echo -e "\n=== Instructions ===" && ls -1 ~/.copilot/instructions/
echo -e "\n=== Prompts ===" && ls -1 ~/.copilot/prompts/
echo -e "\n=== Skills ===" && ls -1 ~/.copilot/skills/
```

## What Gets Installed

### Skills
- **web-design-reviewer** - Visual inspection and fixing of website design issues
- **webapp-testing** - Automated testing with Playwright
- **webcoder** - Web development reference knowledge
- **cpp-programming-guidelines** - C++ development standards
- **web-app-optimization** - Performance optimization techniques
- **readme-generator** - Automated README documentation

### Agents
- **SE: UX/UI Designer** - Jobs-to-be-Done analysis and user journeys
- **Shopify Expert** - Shopify development and theme customization
- **Architect & Clean Code** - Development mode agents

### Instructions
- Next.js + React + TypeScript best practices
- Next.js 14 + Tailwind CSS + SEO optimization
- TypeScript + React + shadcn/ui setup
- React + JavaScript + Tailwind CSS
- DaisyUI component framework
- Next.js + Vercel + Supabase stack

### Prompts
- Task execution strategies
- Task generation workflows

## Troubleshooting

### Installation Not Showing Up

1. **Restart VS Code** - Sometimes VS Code needs to reload the configuration
2. **Check Directory Permissions** - Ensure you have write permissions to `~/.copilot`
3. **Verify File Paths** - Confirm all files were copied to the correct locations
4. **Clear Cache** - Delete and recreate the directories if needed

### PowerShell Execution Policy Error (Windows)

If you see "running scripts is disabled on this system":

```powershell
# Option 1: Set execution policy for current user (permanent)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Option 2: Bypass for this session only (temporary)
powershell -ExecutionPolicy Bypass -File install.ps1
```

### Permission Denied (macOS/Linux)

If you get permission errors:

```bash
# Make script executable
chmod +x install.sh

# Try installation again
./install.sh

# If still having issues, check directory permissions
ls -la ~/.copilot/
```

## Uninstallation

### Windows (PowerShell)
```powershell
# Option 1: Remove individual directories
Remove-Item "$env:USERPROFILE\.copilot\agents" -Recurse -Force
Remove-Item "$env:USERPROFILE\.copilot\instructions" -Recurse -Force
Remove-Item "$env:USERPROFILE\.copilot\prompts" -Recurse -Force
Remove-Item "$env:USERPROFILE\.copilot\skills" -Recurse -Force

# Option 2: Remove entire .copilot directory (careful!)
Remove-Item "$env:USERPROFILE\.copilot" -Recurse -Force
```

### macOS and Linux (Bash)
```bash
# Option 1: Remove individual directories
rm -rf ~/.copilot/agents
rm -rf ~/.copilot/instructions
rm -rf ~/.copilot/prompts
rm -rf ~/.copilot/skills

# Option 2: Remove entire .copilot directory (careful!)
rm -rf ~/.copilot
```

## After Installation

1. **Restart VS Code** to ensure all customizations are loaded
2. **Test Your Agents** by using `/agents` command in Copilot Chat
3. **Check Your Skills** by looking at the skills list in settings
4. **Review Instructions** for technology stacks you're working with

## Support

For issues, updates, or contributions, visit the [copilot-config repository](https://github.com/yourusername/copilot-config).

---

**Last Updated:** March 23, 2026
