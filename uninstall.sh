#!/bin/bash
# ==============================================================================
# 🗑️ Dotfiles Uninstall Script (Homebrew Edition)
# Reverts configuration and optionally uninstalls Homebrew packages
# ==============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}⚠️  Starting Uninstall...${NC}\n"

# Helper to remove symlink
remove_link() {
    local target="$1"
    if [ -L "$target" ]; then
        echo -e "${YELLOW}🔗 Removing symlink: $target${NC}"
        rm "$target"
    fi
}

# 1. Remove Config Symlinks
echo -e "\n${CYAN}📂 Removing configuration links...${NC}"

remove_link "$HOME/.config/nushell"
remove_link "$HOME/.config/wezterm"
remove_link "$HOME/.config/starship.toml"
remove_link "$HOME/.config/nvim"
remove_link "$HOME/.config/yazi"
remove_link "$HOME/.zshrc"
remove_link "$HOME/dotfiles"

# 2. Uninstall Packages (Interactive)
echo -e "\n${CYAN}📦 Homebrew Packages:${NC}"
echo -e "Do you want to uninstall the dotfiles tools via Homebrew?"
echo -e "(nushell, starship, zoxide, atuin, bat, lsd, etc.)"
read -r -p "Uninstall packages? [y/N] " response

if [[ "$response" =~ ^[yY]$ ]]; then
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
        "yazi"
        "neovim"
        "font-caskaydia-cove-nerd-font"
    )
    
    echo -e "${YELLOW}Uninstalling tools...${NC}"
    for tool in "${TOOLS[@]}"; do
        brew uninstall "$tool" || true
    done
    
    # Cleanup caches
    rm -f "$HOME/.cache/.zoxide.nu"
    rm -f "$HOME/.cache/.atuin.nu"
    
    echo -e "${GREEN}✅ Packages uninstalled${NC}"
else
    echo -e "${CYAN}ℹ️  Skipping package uninstallation${NC}"
fi

echo -e "\n${GREEN}✅ Cleanup complete!${NC}"
