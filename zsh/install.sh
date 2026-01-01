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

# env 文件 key=value 的更新/补齐（尽量保留用户已有内容）
upsert_env_kv() {
  local file="$1" key="$2" value="$3"
  mkdir -p "$(dirname "$file")"
  if [ -f "$file" ]; then
    if grep -Eq "^[[:space:]]*${key}[[:space:]]*=" "$file"; then
      local tmp
      tmp="$(mktemp)"
      awk -v k="$key" -v v="$value" '
        BEGIN{re="^[ \t]*"k"[ \t]*="}
        $0 ~ /^[ \t]*#/ {print; next}
        $0 ~ re {print k"="v; next}
        {print}
      ' "$file" > "$tmp"
      mv "$tmp" "$file"
      return 0
    fi
  fi
  if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    printf '%s\n' '# Dotfiles cross-shell settings' > "$file"
  fi
  printf '%s=%s\n' "$key" "$value" >> "$file"
}

ensure_env_kv() {
  local file="$1" key="$2" value="$3"
  mkdir -p "$(dirname "$file")"
  if [ -f "$file" ] && grep -Eq "^[[:space:]]*${key}[[:space:]]*=" "$file"; then
    return 0
  fi
  if [ ! -f "$file" ] || [ ! -s "$file" ]; then
    printf '%s\n' '# Dotfiles cross-shell settings' > "$file"
  fi
  printf '%s=%s\n' "$key" "$value" >> "$file"
}

# --- [1. 路径定义] ---
# 获取脚本所在目录的上一级目录 (即仓库根目录)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# 目标文件
TARGET_ZSHRC="$HOME/.zshrc"
SOURCE_ZSHRC="$SCRIPT_DIR/.zshrc"
ZSHENV_FILE="$HOME/.zshenv"
CONFIG_DIR="$REPO_ROOT/config"
CONFIG_ENV_FILE="$CONFIG_DIR/dotfiles.env"

# 插件开关交互（默认启用）
read -r -p "是否启用增强插件 (fzf/zsh-autosuggestions/zsh-syntax-highlighting)? [Y/n] " enable_plugins_input
enable_plugins_input=${enable_plugins_input:-Y}
enable_plugins_input=$(echo "$enable_plugins_input" | tr '[:lower:]' '[:upper:]')

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

# --- [3.1 写入插件开关到共享配置文件 config/dotfiles.env] ---
if [ "$enable_plugins_input" = "N" ]; then
  upsert_env_kv "$CONFIG_ENV_FILE" "DOTFILES_ENABLE_PLUGINS" "false"
else
  upsert_env_kv "$CONFIG_ENV_FILE" "DOTFILES_ENABLE_PLUGINS" "true"
fi
ensure_env_kv "$CONFIG_ENV_FILE" "DOTFILES_ENABLE_PSREADLINE" "true"
ensure_env_kv "$CONFIG_ENV_FILE" "DOTFILES_ENABLE_POSH_GIT" "true"
ensure_env_kv "$CONFIG_ENV_FILE" "DOTFILES_ENABLE_FZF" "true"
ensure_env_kv "$CONFIG_ENV_FILE" "DOTFILES_ENABLE_ZSH_AUTOSUGGESTIONS" "true"
ensure_env_kv "$CONFIG_ENV_FILE" "DOTFILES_ENABLE_ZSH_SYNTAX_HIGHLIGHTING" "true"
echo -e "${GREEN}✅ 插件开关已写入 $CONFIG_ENV_FILE (DOTFILES_ENABLE_PLUGINS=$( [ \"$enable_plugins_input\" = \"N\" ] && echo false || echo true ))${NC}"

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

# --- [4.3 CaskaydiaCove Nerd Font 自动化] ---
FONT_NAME="CaskaydiaCove"
FONT_DIR="$HOME/.local/share/fonts"
GITHUB_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip"

# 确保路径存在
mkdir -p "$FONT_DIR"

if command -v fc-list &> /dev/null && fc-list | grep -qi "Caskaydia"; then
    echo -e "${GREEN}✅ 检测到 ${FONT_NAME} 字体已存在${NC}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}ℹ️  macOS 环境跳过自动安装字体（建议手动安装 Nerd Font）${NC}"
elif ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}ℹ️  未检测到 curl，跳过自动安装字体${NC}"
elif ! command -v unzip &> /dev/null; then
    echo -e "${YELLOW}ℹ️  未检测到 unzip，跳过自动安装字体${NC}"
else
    echo -e "${YELLOW}📥 正在从 GitHub 下载 ${FONT_NAME}...${NC}"
    TEMP_DIR=$(mktemp -d)
    curl -fLo "$TEMP_DIR/font.zip" "$GITHUB_FONT_URL"
    unzip -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
    if find "$TEMP_DIR" -maxdepth 2 -type f -name "*Regular*.ttf" -print -quit | grep -q .; then
      find "$TEMP_DIR" -maxdepth 2 -type f -name "*Regular*.ttf" -exec cp {} "$FONT_DIR/" \;
    else
      find "$TEMP_DIR" -maxdepth 2 -type f -name "*.ttf" -exec cp {} "$FONT_DIR/" \;
    fi
    if command -v fc-cache &> /dev/null; then
      fc-cache -f &> /dev/null || true
    fi
    rm -rf "$TEMP_DIR"
    echo -e "${GREEN}✅ ${FONT_NAME} 安装完成${NC}"
fi

# --- [5. 登录 Shell 自动切换] ---
# 检查当前是否为交互式 Bash，如果是，则切换到 Zsh
if [ -t 1 ] && [ -n "$BASH_VERSION" ]; then
    # 确保 zsh 存在，避免死循环或无法登录
    if command -v zsh &> /dev/null; then
        exec zsh -l
    fi
fi

echo -e "\n${CYAN}🎉 配置完成! 请运行 'source ~/.zshrc' 或重启终端生效。${NC}"
