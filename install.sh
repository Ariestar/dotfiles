#!/bin/bash
# ==============================================================================
# 🚀 Dotfiles Installation Script (Homebrew Edition)
# Installs configuration for Nushell, Starship, WezTerm, etc. using Homebrew
# ==============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}🔧 Starting Dotfiles Installation (Homebrew)...${NC}\n"

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$HOME/.config"
DOTFILES_LINK="$HOME/dotfiles"

# ------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------

backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup_name="${target}.bak.$(date +%Y%m%d%H%M%S)"
        echo -e "${YELLOW}⚠️  Backing up existing $target -> $backup_name${NC}"
        mv "$target" "$backup_name"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    mkdir -p "$(dirname "$target")"
    backup_if_exists "$target"
    
    echo -e "${CYAN}🔗 Linking $target -> $source${NC}"
    ln -s "$source" "$target"
}

check_cmd() {
    command -v "$1" &> /dev/null
}

# ------------------------------------------------------------------------------
# 1. Install Homebrew
# ------------------------------------------------------------------------------

if ! check_cmd brew; then
    echo -e "${YELLOW}🍺 Homebrew not found. Installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Eval brew shellenv for Linux
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "/opt/homebrew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✅ Homebrew is already installed${NC}"
fi

# ------------------------------------------------------------------------------
# 2. Install Packages via Homebrew
# ------------------------------------------------------------------------------

TOOLS=(
    "nushell"
    "starship"
    "zoxide"
    "atuin"
    "bat"
    "lsd"
    "git-delta"
    "bottom"
    "fzf"
    "font-caskaydia-cove-nerd-font"
)

echo -e "\n${CYAN}📦 Installing dependencies with Homebrew...${NC}"

# Update brew first
echo -e "Running brew update..."
brew update

for tool in "${TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null; then
        echo -e "${GREEN}✅ $tool already installed${NC}"
    else
        echo -e "${YELLOW}📥 Installing $tool...${NC}"
        # Nerd font might need cask on macOS, generic install usually works or taps
        if [[ "$tool" == "font-caskaydia-cove-nerd-font" ]]; then
             brew list --cask "$tool" &>/dev/null || brew install --cask "$tool" || echo -e "${RED}⚠️  Font install skipped (Linux/No Cask support potentially)${NC}"
        else
             brew install "$tool"
        fi
    fi
done

# ------------------------------------------------------------------------------
# 3. Link Dotfiles
# ------------------------------------------------------------------------------

# Ensure ~/dotfiles link
if [ ! -d "$DOTFILES_LINK" ] && [ ! -L "$DOTFILES_LINK" ]; then
    echo -e "\n${CYAN}🔗 Creating ~/dotfiles symlink...${NC}"
    ln -s "$SCRIPT_DIR" "$DOTFILES_LINK"
else
    echo -e "\n${GREEN}✅ ~/dotfiles correct${NC}"
fi

echo -e "\n${CYAN}📂 Linking config files...${NC}"

# Nushell
create_symlink "$SCRIPT_DIR/config/nushell" "$CONFIG_DIR/nushell"

# WezTerm
create_symlink "$SCRIPT_DIR/config/wezterm" "$CONFIG_DIR/wezterm"

# Starship
create_symlink "$SCRIPT_DIR/config/starship.toml" "$CONFIG_DIR/starship.toml"

# Zsh
create_symlink "$SCRIPT_DIR/config/zsh/.zshrc" "$HOME/.zshrc"

# ------------------------------------------------------------------------------
# 4. Final Setup (Nushell Caches)
# ------------------------------------------------------------------------------

echo -e "\n${CYAN}⚙️  Generating Nu cache files...${NC}"
mkdir -p "$HOME/.cache"

# Generate init files using the newly installed binaries
zoxide init nu > "$HOME/.cache/.zoxide.nu"
atuin init nu > "$HOME/.cache/.atuin.nu"

echo -e "\n${GREEN}🎉 Installation Complete!${NC}"
echo -e "You are ready to rock with Nushell + Starship + Homebrew tools."
