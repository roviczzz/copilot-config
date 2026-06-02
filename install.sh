#!/bin/bash
################################################################################
# Agentic Dev Multi-Tool Installer for macOS/Linux
#
# Usage:
#   Interactive: ./install.sh
#   Headless:    ./install.sh --tools copilot,opencode,cursor
#   Uninstall:   ./install.sh --action uninstall --tools copilot
#   Verify:      ./install.sh --action verify
#   Dry-run:     ./install.sh --dry-run --tools copilot,opencode
################################################################################

set -e

# -- Colors -------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
NC='\033[0m'
BOLD='\033[1m'

# -- Config -------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME}"

ACTION="install"
TOOLS=""
DRY_RUN=false

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --action)    ACTION="$2"; shift 2 ;;
    --tools)     TOOLS="$2"; shift 2 ;;
    --dry-run)   DRY_RUN=true; shift ;;
    install|uninstall|verify) ACTION="$1"; shift ;;
    *) echo "Usage: $0 [--action install|uninstall|verify] [--tools copilot,opencode,...] [--dry-run]"; exit 1 ;;
  esac
done

# -- Tool definitions ---------------------------------------------------------
TOOL_IDS=(copilot opencode cursor windsurf antigravity claude-code cline zed)
TOOL_NAMES=(
  "GitHub Copilot (VS Code)"
  "OpenCode"
  "Cursor"
  "Windsurf (Codeium)"
  "Antigravity"
  "Claude Code"
  "Cline (VS Code Ext)"
  "Zed"
)
SOURCE_DIRS=(agents instructions prompts skills)
TOOL_COUNT=${#TOOL_IDS[@]}

# -- Helpers ------------------------------------------------------------------
print_header()  { echo -e "${CYAN}  $1${NC}"; }
print_success() { echo -e "  ${GREEN}$1${NC}"; }
print_error()   { echo -e "  ${RED}$1${NC}"; }
print_info()    { echo -e "  ${YELLOW}$1${NC}"; }
print_warn()    { echo -e "  ${MAGENTA}$1${NC}"; }

draw_box_line() {
  local char="${1:=}"
  local width="${2:=60}"
  printf "${CYAN}"
  for ((i=0; i<width; i++)); do printf "%s" "$char"; done
  printf "${NC}\n"
}

getchar() {
  # Read a single keypress (arrow keys return escape sequences)
  IFS= read -r -s -n1 key 2>/dev/null
  if [[ "$key" == $'\033' ]]; then
    read -r -s -n2 rest 2>/dev/null
    echo "${key}${rest}"
  else
    echo "$key"
  fi
}

# -- Source checks ------------------------------------------------------------
check_source_dirs() {
  local all_ok=true
  for d in "${SOURCE_DIRS[@]}"; do
    if [[ ! -d "$SCRIPT_DIR/$d" ]]; then
      print_error "[MISSING] $d"
      all_ok=false
    fi
  done
  $all_ok
}

# -- Tool target paths --------------------------------------------------------
get_tool_base() {
  local id="$1"
  case "$id" in
    copilot)     echo "$HOME_DIR/.copilot" ;;
    opencode)    echo "$HOME_DIR/.agents/skills" ;;
    cursor)      echo "$HOME_DIR/.cursor" ;;
    windsurf)    echo "$HOME_DIR/.windsurf" ;;
    antigravity) echo "$HOME_DIR/.agents/skills" ;;
    claude-code) echo "$HOME_DIR/.claude/skills" ;;
    cline)       echo "$SCRIPT_DIR/.clinerules" ;;
    zed)         echo "$HOME_DIR/.config/zed" ;;
  esac
}

get_tool_subs() {
  local id="$1"
  case "$id" in
    copilot)  echo "agents instructions prompts skills" ;;
    cursor)   echo "instructions agents" ;;
    windsurf) echo "instructions" ;;
    zed)      echo "instructions" ;;
    *)        echo "" ;;
  esac
}

is_symlink_tool()   { [[ "$1" == "opencode" || "$1" == "antigravity" ]]; }
is_skill_copy_tool() { [[ "$1" == "claude-code" ]]; }
is_single_file_tool(){ [[ "$1" == "cline" ]]; }

# -- Install ------------------------------------------------------------------
install_tool() {
  local id="$1"
  local base; base=$(get_tool_base "$id")
  local name
  for i in "${!TOOL_IDS[@]}"; do
    if [[ "${TOOL_IDS[$i]}" == "$id" ]]; then name="${TOOL_NAMES[$i]}"; break; fi
  done

  if $DRY_RUN; then
    print_info "[DRY-RUN] Would install to $name: $base"
    return
  fi

  print_header "$name..."

  if is_symlink_tool "$id"; then
    local skill_source="$SCRIPT_DIR/skills"
    if [[ -d "$skill_source" ]]; then
      mkdir -p "$base"
      for skill_dir in "$skill_source"/*/; do
        local sname; sname=$(basename "$skill_dir")
        local link="$base/$sname"
        if [[ ! -L "$link" && ! -d "$link" ]]; then
          ln -sf "$skill_dir" "$link" 2>/dev/null || true
        fi
      done
    fi
  elif is_single_file_tool "$id"; then
    local src="$SCRIPT_DIR/instructions"
    if [[ -d "$src" ]]; then
      mkdir -p "$(dirname "$base")"
      cp -r "$src/"* "$base" 2>/dev/null || true
    fi
  elif is_skill_copy_tool "$id"; then
    local skill_source="$SCRIPT_DIR/skills"
    if [[ -d "$skill_source" ]]; then
      mkdir -p "$base"
      cp -r "$skill_source/"* "$base" 2>/dev/null || true
    fi
  else
    local subs; subs=$(get_tool_subs "$id")
    for sub in $subs; do
      local src="$SCRIPT_DIR/$sub"
      local dst="$base/$sub"
      if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        cp -r "$src/"* "$dst" 2>/dev/null || true
      fi
    done
  fi
  print_success "$name -- done"
}

# -- Uninstall ----------------------------------------------------------------
uninstall_tool() {
  local id="$1"
  local base; base=$(get_tool_base "$id")
  local name
  for i in "${!TOOL_IDS[@]}"; do
    if [[ "${TOOL_IDS[$i]}" == "$id" ]]; then name="${TOOL_NAMES[$i]}"; break; fi
  done

  if $DRY_RUN; then
    print_info "[DRY-RUN] Would uninstall from $name: $base"
    return
  fi

  print_header "$name..."

  if is_symlink_tool "$id"; then
    local skill_source="$SCRIPT_DIR/skills"
    if [[ -d "$skill_source" && -d "$base" ]]; then
      for skill_dir in "$skill_source"/*/; do
        local sname; sname=$(basename "$skill_dir")
        local link="$base/$sname"
        rm -rf "$link" 2>/dev/null || true
      done
    fi
  elif is_single_file_tool "$id"; then
    rm -rf "$base" 2>/dev/null || true
  elif is_skill_copy_tool "$id"; then
    if [[ -d "$base" ]]; then
      local skill_source="$SCRIPT_DIR/skills"
      if [[ -d "$skill_source" ]]; then
        for skill_dir in "$skill_source"/*/; do
          local sname; sname=$(basename "$skill_dir")
          rm -rf "$base/$sname" 2>/dev/null || true
        done
      fi
    fi
  else
    local subs; subs=$(get_tool_subs "$id")
    for sub in $subs; do
      rm -rf "$base/$sub" 2>/dev/null || true
    done
  fi
  print_success "$name -- removed"
}

# -- Verify -------------------------------------------------------------------
verify_tool() {
  local id="$1"
  local base; base=$(get_tool_base "$id")
  local name
  for i in "${!TOOL_IDS[@]}"; do
    if [[ "${TOOL_IDS[$i]}" == "$id" ]]; then name="${TOOL_NAMES[$i]}"; break; fi
  done

  if is_symlink_tool "$id"; then
    if [[ -d "$base" ]]; then
      local count; count=$(ls -1d "$base"/*/ 2>/dev/null | wc -l)
      print_success "$name: $count skills linked"
    else print_error "$name: NOT INSTALLED"; fi
  elif is_single_file_tool "$id"; then
    if [[ -f "$base" || -d "$base" ]]; then print_success "$name: $base exists"
    else print_error "$name: NOT INSTALLED"; fi
  elif is_skill_copy_tool "$id"; then
    if [[ -d "$base" ]]; then
      local count; count=$(ls -1d "$base"/*/ 2>/dev/null | wc -l)
      print_success "$name: $count skills installed"
    else print_error "$name: NOT INSTALLED"; fi
  else
    local subs; subs=$(get_tool_subs "$id")
    local found=0 total=0
    for sub in $subs; do
      total=$((total + 1))
      [[ -d "$base/$sub" ]] && found=$((found + 1))
    done
    if [[ $total -gt 0 && $found -eq $total ]]; then print_success "$name: installed ($found dirs)"
    elif [[ $found -gt 0 ]]; then print_warn "$name: partial ($found/$total dirs)"
    else print_error "$name: NOT INSTALLED"; fi
  fi
}

# -- Interactive menu with arrow keys + spacebar ------------------------------
show_tool_menu() {
  local -a selected=()
  for ((i=0; i<TOOL_COUNT; i++)); do selected[$i]=false; done
  selected[0]=true
  local cursor=0
  local key

  tput sc 2>/dev/null || local notput=1
  local menu_lines=$((TOOL_COUNT + 2))

  for ((i=0; i<TOOL_COUNT; i++)); do
    echo "   [ ] $((i+1)). ${TOOL_NAMES[$i]}"
  done
  echo ""
  echo -e "${DARK_GRAY}  (arrow keys: navigate | space: toggle | enter: confirm)${NC}"

  while true; do
    key=$(getchar)
    case "$key" in
      $'\033[A') cursor=$(( (cursor - 1 + TOOL_COUNT) % TOOL_COUNT )) ;;
      $'\033[B') cursor=$(( (cursor + 1) % TOOL_COUNT )) ;;
      ' ') ${selected[$cursor]} && selected[$cursor]=false || selected[$cursor]=true ;;
      '') break ;;
    esac

    if [[ -z "$notput" ]]; then
      tput rc 2>/dev/null
      tput ed 2>/dev/null
    else
      echo -ne "\033[${menu_lines}A\033[J"
    fi

    for ((i=0; i<TOOL_COUNT; i++)); do
      local check; ${selected[$i]} && check="[x]" || check="[ ]"
      local marker; [[ $i -eq $cursor ]] && marker="${CYAN}>${NC}" || marker=" "
      echo -e "  ${marker} ${check} $((i+1)). ${TOOL_NAMES[$i]}"
    done
    echo ""
    echo -e "${DARK_GRAY}  (arrow keys: navigate | space: toggle | enter: confirm)${NC}"
  done

  local result=()
  for ((i=0; i<TOOL_COUNT; i++)); do
    ${selected[$i]} && result+=("${TOOL_IDS[$i]}")
  done
  echo "${result[@]}"
}

# -- Main ---------------------------------------------------------------------
main() {
  draw_box_line "="
  echo -e "${CYAN}  Agentic Dev -- Multi-Tool Installer${NC}"
  draw_box_line "="

  if ! check_source_dirs; then
    print_error "Source directories missing. Run from repo root."
    exit 1
  fi
  print_success "All source directories found"

  local target_tools=()
  if [[ -n "$TOOLS" ]]; then
    IFS=',' read -ra target_tools <<< "$TOOLS"
  elif [[ "$ACTION" == "install" || "$ACTION" == "uninstall" ]]; then
    echo ""
    local menu_result; menu_result=$(show_tool_menu)
    read -ra target_tools <<< "$menu_result"
    if [[ ${#target_tools[@]} -eq 0 ]]; then
      print_info "No tools selected. Exiting."
      exit 0
    fi
  fi

  echo ""
  case "$ACTION" in
    install)
      draw_box_line "="
      echo -e "${CYAN}  Installing...${NC}"
      draw_box_line "="
      for tid in "${target_tools[@]}"; do install_tool "$tid"; done
      echo ""
      draw_box_line "="
      echo -e "${CYAN}  Installation Summary${NC}"
      draw_box_line "="
      for tid in "${target_tools[@]}"; do verify_tool "$tid"; done
      echo -e "\n  ${GREEN}Next: restart your IDE or agentic tool for changes to take effect.${NC}"
      ;;
    uninstall)
      draw_box_line "="
      echo -e "${CYAN}  Uninstalling...${NC}"
      draw_box_line "="
      for tid in "${target_tools[@]}"; do uninstall_tool "$tid"; done
      ;;
    verify)
      draw_box_line "="
      echo -e "${CYAN}  Installation Status${NC}"
      draw_box_line "="
      for tid in "${TOOL_IDS[@]}"; do verify_tool "$tid"; done
      ;;
  esac
}

main
