# ==============================================================================
# 🐚 全平台统一终端配置文件 (.zshrc)
# 适用环境: Ubuntu / Linux
# ==============================================================================

# --- [1. 路径与环境变量] ---
export PATH="$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
# 将 GitHub 仓库路径参数化，保证平移不变性
export DOTFILES="$HOME/dotfiles"

# 共享配置：自动加载 config/dotfiles.env 以便个性化开关
if [ -f "$DOTFILES/config/dotfiles.env" ]; then
  set -a
  . "$DOTFILES/config/dotfiles.env"
  set +a
fi

# 布尔归一化（仅接受 true/false，默认 true）
_dotfiles_bool() {
  case "$1" in
    true|TRUE|True) echo true ;;
    false|FALSE|False) echo false ;;
    *) echo true ;;
  esac
}

# 通用：从候选路径中加载首个存在的插件脚本
_dotfiles_source_first() {
  local enabled="$1" name="$2"
  shift 2
  [ "$enabled" = "false" ] && return
  for _candidate in "$@"; do
    if [ -f "$_candidate" ]; then
      source "$_candidate"
      return 0
    fi
  done
  return 1
}

# --- [2. 历史记录管理] ---
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt histignorealldups sharehistory  # 忽略重复，实时共享历史

# --- [3. 现代补全系统 (保留并优化你原有的 zstyle)] ---
autoload -Uz compinit && compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' verbose true

# 颜色设置：利用 dircolors 确保 ls 颜色一致
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# --- [4. 视觉引擎：Oh My Posh] ---
if command -v oh-my-posh &> /dev/null; then
    # 映射 $DOTFILES/posh/theme.omp.json 到当前终端提示符
    eval "$(oh-my-posh init zsh --config $DOTFILES/posh/theme.omp.json)"
else
    # 核心修复：必须先 autoload 才能定义 prompt 算子
    autoload -Uz promptinit && promptinit
    # 只有当 OMP 缺失时，才降级使用基础主题
    prompt adam1
fi

# --- [5. 交互增强 (键盘绑定)] ---
bindkey -e  # 使用 Emacs 模式
# 兼容某些终端的 Home/End 键映射
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# --- [5.1 插件生态 (按需加载，已安装则启用)] ---
# 可通过环境变量控制开关：DOTFILES_ENABLE_PLUGINS=false 时跳过
: ${DOTFILES_ENABLE_PLUGINS:=true}
: ${DOTFILES_ENABLE_FZF:=$DOTFILES_ENABLE_PLUGINS}
: ${DOTFILES_ENABLE_ZSH_AUTOSUGGESTIONS:=$DOTFILES_ENABLE_PLUGINS}
: ${DOTFILES_ENABLE_ZSH_SYNTAX_HIGHLIGHTING:=$DOTFILES_ENABLE_PLUGINS}

DOTFILES_ENABLE_PLUGINS=$(_dotfiles_bool "$DOTFILES_ENABLE_PLUGINS")
DOTFILES_ENABLE_FZF=$(_dotfiles_bool "$DOTFILES_ENABLE_FZF")
DOTFILES_ENABLE_ZSH_AUTOSUGGESTIONS=$(_dotfiles_bool "$DOTFILES_ENABLE_ZSH_AUTOSUGGESTIONS")
DOTFILES_ENABLE_ZSH_SYNTAX_HIGHLIGHTING=$(_dotfiles_bool "$DOTFILES_ENABLE_ZSH_SYNTAX_HIGHLIGHTING")

if [ "$DOTFILES_ENABLE_PLUGINS" != "false" ]; then

# fzf 补全与快捷键
if [ "$DOTFILES_ENABLE_FZF" != "false" ] && command -v fzf &> /dev/null; then
  # 常见发行版的安装路径，找到就加载
  _dotfiles_source_first "$DOTFILES_ENABLE_FZF" "fzf key-bindings" \
    /usr/share/doc/fzf/examples/key-bindings.zsh \
    /usr/share/fzf/key-bindings.zsh
  _dotfiles_source_first "$DOTFILES_ENABLE_FZF" "fzf completion" \
    /usr/share/doc/fzf/examples/completion.zsh \
    /usr/share/fzf/completion.zsh
fi

# 自动建议 (zsh-autosuggestions)
_dotfiles_source_first "$DOTFILES_ENABLE_ZSH_AUTOSUGGESTIONS" "zsh-autosuggestions" \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# 语法高亮 (zsh-syntax-highlighting)
_dotfiles_source_first "$DOTFILES_ENABLE_ZSH_SYNTAX_HIGHLIGHTING" "zsh-syntax-highlighting" \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

fi

# --- [6. 别名与快捷算子 (Aliases)] ---
alias g='git'
alias cls='clear'
alias ll='ls -lh --color=auto'
alias la='ls -a --color=auto'
alias l='ls -lah --color=auto'
# 快速进入 dotfiles 仓库
alias dot='cd $DOTFILES'

# --- [7. 插件加载 (可选，需安装 oh-my-zsh)] ---
# 如果你使用了 Oh My Zsh 框架，请取消下行注释
# source $ZSH/oh-my-zsh.sh
