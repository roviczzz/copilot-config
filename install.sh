#!/bin/bash

################################################################################
# GitHub Copilot Configuration Installer
# Compatible with: macOS and Linux
# 
# This script installs custom agents, skills, instructions, and prompts
# for GitHub Copilot.
#
# Usage: chmod +x install.sh && ./install.sh
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COPILOT_DIR="${HOME}/.copilot"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Functions
print_header() {
    echo -e "${BLUE}===============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===============================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

check_directories() {
    print_header "Checking Directory Structure"
    
    if [ ! -d "$SCRIPT_DIR/agents" ]; then
        print_error "Missing 'agents' directory in source"
        return 1
    fi
    
    if [ ! -d "$SCRIPT_DIR/instructions" ]; then
        print_error "Missing 'instructions' directory in source"
        return 1
    fi
    
    if [ ! -d "$SCRIPT_DIR/prompts" ]; then
        print_error "Missing 'prompts' directory in source"
        return 1
    fi
    
    if [ ! -d "$SCRIPT_DIR/skills" ]; then
        print_error "Missing 'skills' directory in source"
        return 1
    fi
    
    print_success "All source directories found"
    return 0
}

create_directories() {
    print_header "Creating Copilot Configuration Directories"
    
    mkdir -p "$COPILOT_DIR/agents"
    print_success "Created $COPILOT_DIR/agents"
    
    mkdir -p "$COPILOT_DIR/instructions"
    print_success "Created $COPILOT_DIR/instructions"
    
    mkdir -p "$COPILOT_DIR/prompts"
    print_success "Created $COPILOT_DIR/prompts"
    
    mkdir -p "$COPILOT_DIR/skills"
    print_success "Created $COPILOT_DIR/skills"
}

copy_files() {
    print_header "Installing Configuration Files"
    
    # Copy agents
    if [ -d "$SCRIPT_DIR/agents" ]; then
        cp -r "$SCRIPT_DIR/agents/"* "$COPILOT_DIR/agents/" 2>/dev/null || true
        print_success "Installed agents"
    fi
    
    # Copy instructions
    if [ -d "$SCRIPT_DIR/instructions" ]; then
        cp -r "$SCRIPT_DIR/instructions/"* "$COPILOT_DIR/instructions/" 2>/dev/null || true
        print_success "Installed instructions"
    fi
    
    # Copy prompts
    if [ -d "$SCRIPT_DIR/prompts" ]; then
        cp -r "$SCRIPT_DIR/prompts/"* "$COPILOT_DIR/prompts/" 2>/dev/null || true
        print_success "Installed prompts"
    fi
    
    # Copy skills (merge with existing)
    if [ -d "$SCRIPT_DIR/skills" ]; then
        cp -r "$SCRIPT_DIR/skills/"* "$COPILOT_DIR/skills/" 2>/dev/null || true
        print_success "Installed skills"
    fi
}

verify_installation() {
    print_header "Verifying Installation"
    
    echo -e "\n${BLUE}Agents:${NC}"
    if [ -d "$COPILOT_DIR/agents" ]; then
        ls -1 "$COPILOT_DIR/agents" | sed 's/^/  /'
    else
        print_error "Agents directory not found"
    fi
    
    echo -e "\n${BLUE}Instructions:${NC}"
    if [ -d "$COPILOT_DIR/instructions" ]; then
        ls -1 "$COPILOT_DIR/instructions" | sed 's/^/  /'
    else
        print_error "Instructions directory not found"
    fi
    
    echo -e "\n${BLUE}Prompts:${NC}"
    if [ -d "$COPILOT_DIR/prompts" ]; then
        ls -1 "$COPILOT_DIR/prompts" | sed 's/^/  /'
    else
        print_error "Prompts directory not found"
    fi
    
    echo -e "\n${BLUE}Skills:${NC}"
    if [ -d "$COPILOT_DIR/skills" ]; then
        ls -1 "$COPILOT_DIR/skills" | sed 's/^/  /'
    else
        print_error "Skills directory not found"
    fi
}

print_next_steps() {
    print_header "Installation Complete!"
    
    echo -e "\n${GREEN}Next Steps:${NC}"
    echo "  1. Restart Visual Studio Code"
    echo "  2. Open Copilot Chat (@-menu)"
    echo "  3. Your new agents, skills, and instructions will be available"
    echo ""
    echo -e "${YELLOW}Configuration Directory:${NC}"
    echo "  $COPILOT_DIR"
    echo ""
}

uninstall() {
    print_header "Uninstalling GitHub Copilot Configuration"
    
    read -p "Are you sure you want to remove all Copilot customizations? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$COPILOT_DIR/agents" && print_success "Removed agents"
        rm -rf "$COPILOT_DIR/instructions" && print_success "Removed instructions"
        rm -rf "$COPILOT_DIR/prompts" && print_success "Removed prompts"
        rm -rf "$COPILOT_DIR/skills" && print_success "Removed skills"
        print_success "Uninstallation complete"
    else
        print_info "Uninstallation cancelled"
    fi
}

# Main script
main() {
    case "${1:-install}" in
        install)
            print_header "GitHub Copilot Configuration Installer"
            echo ""
            check_directories || exit 1
            create_directories
            copy_files
            verify_installation
            print_next_steps
            ;;
        uninstall)
            uninstall
            ;;
        verify)
            verify_installation
            ;;
        *)
            echo "Usage: $0 {install|uninstall|verify}"
            echo ""
            echo "Commands:"
            echo "  install    Install GitHub Copilot configuration (default)"
            echo "  uninstall  Remove all Copilot customizations"
            echo "  verify     Verify current installation"
            exit 1
            ;;
    esac
}

main "$@"
