#!/bin/bash
# ==============================================================================
# 🗑️ Dotfiles Uninstall Script
# Reverts changes made by install.sh (Removes symlinks)
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
    elif [ -e "$target" ]; then
        echo -e "${RED}❌ $target is not a symlink. Skipping to prevent data loss.${NC}"
    else
        echo -e "${CYAN}ℹ️  $target does not exist.${NC}"
    fi
}

# 1. Remove Config Symlinks
echo -e "\n${CYAN}📂 Removing configuration links...${NC}"

remove_link "$HOME/.config/nushell"
remove_link "$HOME/.config/wezterm"
remove_link "$HOME/.config/starship.toml"
remove_link "$HOME/.zshrc"
remove_link "$HOME/dotfiles"

# 2. Restore Backups (Optional hint)
echo -e "\n${CYAN}📦 Backup Restoration Hint:${NC}"
echo -e "This script removed the symlinks pointing to this repo."
echo -e "If install.sh created backups (e.g., .zshrc.bak.2024...), you can restore them manually:"
echo -e "${GREEN}ls -la ~/.zshrc.bak*${NC}"
echo -e "${GREEN}ls -la ~/.config/nushell.bak*${NC}"

# 3. Uninstall Tools Hint
echo -e "\n${CYAN}🛠️  Uninstalling Tools:${NC}"
echo -e "To uninstall the tools, you can usually verify their location and remove them:"

 echo -e "\n1. ${GREEN}Starship${NC}:"
 echo -e "   rm \$(which starship)"

 echo -e "\n2. ${GREEN}Zoxide${NC}:"
 echo -e "   rm \$(which zoxide)"
 echo -e "   rm ~/.cache/.zoxide.nu"

 echo -e "\n3. ${GREEN}Atuin${NC}:"
 echo -e "   atuin uninstall"
 echo -e "   # Or: rm \$(which atuin); rm -rf ~/.local/share/atuin ~/.config/atuin"

echo -e "\n${GREEN}✅ Cleanup of symlinks complete!${NC}"
