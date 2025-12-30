# ==============================================================================
# 🐚 全平台统一终端配置文件 (.zshrc)
# 适用环境: Ubuntu / Linux
# ==============================================================================

# --- [1. 路径与环境变量] ---
export PATH="$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
# 将 GitHub 仓库路径参数化，保证平移不变性
export DOTFILES="$HOME/dotfiles"

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
