#!/bin/bash
# ==============================================================================
# 🚀 Zsh 自动化配置脚本
# 适用环境: Linux / macOS
# ==============================================================================

set -e # 遇到错误立即停止

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}📦 开始配置 Zsh 环境...${NC}\n"

# --- [1. 路径定义] ---
# 获取脚本所在目录的上一级目录 (即仓库根目录)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# 目标文件
TARGET_ZSHRC="$HOME/.zshrc"
SOURCE_ZSHRC="$SCRIPT_DIR/.zshrc"

# --- [2. 确保 ~/dotfiles 链接存在] ---
# 配置文件中使用了 export DOTFILES="$HOME/dotfiles"
HOME_DOTFILES="$HOME/dotfiles"

if [ ! -d "$HOME_DOTFILES" ] && [ ! -L "$HOME_DOTFILES" ]; then
    echo -e "${YELLOW}🔗 建立 ~/dotfiles 软链接 -> $REPO_ROOT${NC}"
    ln -s "$REPO_ROOT" "$HOME_DOTFILES"
else
    echo -e "${GREEN}✅ ~/dotfiles 路径已存在${NC}"
fi

# --- [3. 链接 .zshrc] ---
echo -e "${YELLOW}🔗 配置 .zshrc...${NC}"

if [ -f "$TARGET_ZSHRC" ] || [ -L "$TARGET_ZSHRC" ]; then
    # 简单的备份策略
    BACKUP_NAME="$TARGET_ZSHRC.bak.$(date +%Y%m%d%H%M%S)"
    echo -e "${YELLOW}⚠️  备份原有 .zshrc -> $BACKUP_NAME${NC}"
    mv "$TARGET_ZSHRC" "$BACKUP_NAME"
fi

ln -s "$SOURCE_ZSHRC" "$TARGET_ZSHRC"
echo -e "${GREEN}✅ .zshrc 链接创建成功${NC}"

# --- [4. 检查依赖] ---
echo -e "\n${YELLOW}📦 检查依赖工具...${NC}"

# 4.1 Oh My Posh
if ! command -v oh-my-posh &> /dev/null; then
    echo -e "${RED}⚠️  未检测到 Oh My Posh${NC}"
    echo -e "👉 建议运行以下命令安装:"
    echo -e "   curl -s https://ohmyposh.dev/install.sh | bash -s"
else
    echo -e "${GREEN}✅ Oh My Posh 已安装${NC}"
fi

# 4.2 Git (基本检查)
if ! command -v git &> /dev/null; then
     echo -e "${RED}⚠️  未检测到 Git (部分功能可能受限)${NC}"
else
     echo -e "${GREEN}✅ Git 已安装${NC}"
fi

echo -e "\n${CYAN}🎉 配置完成! 请运行 'source ~/.zshrc' 或重启终端生效。${NC}"
