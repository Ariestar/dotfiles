#!/bin/bash
# ==============================================================================
# 🚀 Dotfiles Installation Script (Linux/macOS)
# Installs configuration for Nushell, Starship, WezTerm, etc.
# ==============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}🔧 Starting Dotfiles Installation...${NC}\n"

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
# 1. Link Dotfiles to ~/dotfiles
# ------------------------------------------------------------------------------

if [ ! -d "$DOTFILES_LINK" ] && [ ! -L "$DOTFILES_LINK" ]; then
    echo -e "${CYAN}🔗 Creating ~/dotfiles symlink...${NC}"
    ln -s "$SCRIPT_DIR" "$DOTFILES_LINK"
else
    echo -e "${GREEN}✅ ~/dotfiles currently exists${NC}"
fi

# ------------------------------------------------------------------------------
# 2. Config Symlinks
# ------------------------------------------------------------------------------

echo -e "\n${CYAN}📂 Setting up configuration links...${NC}"

# Nushell
create_symlink "$SCRIPT_DIR/config/nushell" "$CONFIG_DIR/nushell"

# WezTerm
create_symlink "$SCRIPT_DIR/config/wezterm" "$CONFIG_DIR/wezterm"

# Starship
create_symlink "$SCRIPT_DIR/config/starship.toml" "$CONFIG_DIR/starship.toml"

# Zsh (Optional fallback)
if [ -f "$SCRIPT_DIR/config/zsh/.zshrc" ]; then
    create_symlink "$SCRIPT_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
fi

# ------------------------------------------------------------------------------
# 3. Install Tools
# ------------------------------------------------------------------------------

echo -e "\n${CYAN}📦 Checking and installing dependencies...${NC}"

# Starship
if ! check_cmd starship; then
    echo -e "${YELLOW}📥 Installing Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo -e "${GREEN}✅ Starship is already installed${NC}"
fi

# Zoxide
if ! check_cmd zoxide; then
    echo -e "${YELLOW}📥 Installing Zoxide...${NC}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
    echo -e "${GREEN}✅ Zoxide is already installed${NC}"
fi

# Atuin
# Note: Atuin install script might ask for confirmation or be interactive.
# We'll use the official install script.
if ! check_cmd atuin; then
    echo -e "${YELLOW}📥 Installing Atuin...${NC}"
    # Use the official installer, pipe to bash
    curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | bash
else
    echo -e "${GREEN}✅ Atuin is already installed${NC}"
fi

# Nerd Fonts
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
fi

if check_cmd fc-list && fc-list | grep -qi "Caskaydia"; then
    echo -e "${GREEN}✅ CaskaydiaCove Nerd Font detected${NC}"
else
    echo -e "${YELLOW}📥 Downloading CaskaydiaCove Nerd Font...${NC}"
    TEMP_DIR=$(mktemp -d)
    curl -fLo "$TEMP_DIR/font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"
    
    if check_cmd unzip; then
        unzip -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
        find "$TEMP_DIR" -maxdepth 2 -type f -name "*Regular*.ttf" -exec cp {} "$FONT_DIR/" \; || \
        find "$TEMP_DIR" -maxdepth 2 -type f -name "*.ttf" -exec cp {} "$FONT_DIR/" \;
        
        if check_cmd fc-cache; then
            fc-cache -f &> /dev/null
        fi
        echo -e "${GREEN}✅ Font installed${NC}"
    else
        echo -e "${RED}❌ 'unzip' not found. Skipping font installation.${NC}"
    fi
    rm -rf "$TEMP_DIR"
fi

# ------------------------------------------------------------------------------
# 4. Check Nushell
# ------------------------------------------------------------------------------

if ! check_cmd nu; then
    echo -e "\n${YELLOW}⚠️  Nushell (nu) is not detected!${NC}"
    echo -e "This configuration is designed for Nushell."
    echo -e "Please install it using your package manager or from: https://github.com/nushell/nushell"
    echo -e "Example: ${CYAN}brew install nushell${NC} or ${CYAN}cargo install nu${NC}"
else
    echo -e "\n${GREEN}✅ Nushell is installed${NC}"
    
    # Generate cache files required by config.nu
    echo -e "${CYAN}Generating Atuin/Zoxide init files for Nushell...${NC}"
    mkdir -p "$HOME/.cache"
    
    if check_cmd zoxide; then
        zoxide init nu > "$HOME/.cache/.zoxide.nu"
    else
        echo -e "${YELLOW}⚠️  Zoxide not found. Creating empty config to prevent shell errors.${NC}"
        touch "$HOME/.cache/.zoxide.nu"
    fi
    
    if check_cmd atuin; then
        atuin init nu > "$HOME/.cache/.atuin.nu" 
    else
        echo -e "${YELLOW}⚠️  Atuin not found. Creating empty config to prevent shell errors.${NC}"
        touch "$HOME/.cache/.atuin.nu"
    fi
fi

echo -e "\n${GREEN}🎉 Installation Complete!${NC}"
echo -e "Please restart your terminal or run '${CYAN}nu${NC}' to start."
