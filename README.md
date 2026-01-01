# 🔧 Dotfiles

跨平台终端配置文件管理仓库 (Windows & Linux/macOS)。
通过统一的配置和工具链，在不同系统间提供一致的终端体验。

## 📂 目录结构

```text
dotfiles/
├── powershell/     # Windows PowerShell 配置与安装脚本
├── zsh/            # Linux/macOS Zsh 配置与安装脚本
└── posh/           # Oh My Posh 主题配置 (全平台通用)
```

## ✨ 功能特性

*   **多平台统一**: 无论是在 Windows PowerShell 还是 Linux Zsh，享受一致的提示符和操作习惯。
*   **Oh My Posh**: 集成自定义主题 (`posh/theme.omp.json`)，美观且实用。
*   **自动化安装**: 提供开箱即用的安装脚本，自动处理软链接 (Symlink) 和备份旧配置。
*   **常用别名**: 预设 `g` (git), `l` (ls) 等常用别名。
*   **环境隔离**: 配置文件通过软链接指向本仓库，方便通过 Git 进行版本控制和同步。

## 🚀 快速开始

### 前置要求

在安装配置之前，请确保已安装以下基础工具：

1.  **Git**: 用于管理版本控制。
2.  **Oh My Posh**: 终端提示符引擎。
    *   Windows: `winget install JanDeDobbeleer.OhMyPosh -s winget`
    *   Linux/macOS: `curl -s https://ohmyposh.dev/install.sh | bash -s`
3.  **Nerd Fonts**: 为了正确显示图标，请安装并配置 Nerd Font，在脚本中会默认下载 Cascadia Code 字体。

### 📦 安装步骤

#### Windows (PowerShell)

在 PowerShell 中运行安装脚本：

```powershell
# 进入仓库目录
cd dotfiles

# 运行安装脚本
.\powershell\install.ps1
```

> **注意**: 脚本会自动将 `$PROFILE` 链接到仓库中的 `Microsoft.PowerShell_profile.ps1`，并备份原文件。如果遇到权限问题，请以管理员身份运行终端。

#### PowerShell 可选增强

在 PowerShell 中已预置以下增强插件的配置开关，安装后即会自动启用：

*   **PSFzf**：模糊搜索历史/文件/进程。安装 `fzf` 后运行 `Install-Module PSFzf -Scope CurrentUser`。
*   **zoxide**：智能目录跳转 (`z`/`zi`)。使用 `winget install ajeetdsouza.zoxide` 或 Scoop/Chocolatey 安装。
*   **Atuin**：加密同步命令历史与模糊搜索。可通过 `winget install atuin` 或参考官方安装指引。
*   默认环境变量 `DOTFILES_ENABLE_PSFZF=true` `DOTFILES_ENABLE_ZOXIDE=true` `DOTFILES_ENABLE_ATUIN=true` 可在 `config/dotfiles.env` 中按需设为 `false` 关闭。

#### Linux / macOS (Zsh)

在终端中运行安装脚本：

```bash
# 进入仓库目录
cd dotfiles

# 赋予执行权限并运行
chmod +x zsh/install.sh
./zsh/install.sh
```

> **注意**: 脚本会将 `~/.zshrc` 链接到仓库中的 `zsh/.zshrc`，并建立 `~/dotfiles` 的软链接以确保路径一致性。

#### Zsh 可选增强

在 Zsh 配置中也预置了以下增强插件的开关，安装后会自动启用：

*   **fzf**：模糊搜索历史、文件与补全，加速 Ctrl+R/Ctrl+T 流程。
*   **zoxide**：智能目录跳转 (`z`/`zi`)，推荐 `curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash` 或按发行版包管理器安装。
*   **Atuin**：加密同步命令历史并提供模糊搜索，可与 PowerShell 端共用；参考官方脚本或包管理器安装后自动生效。
*   默认环境变量 `DOTFILES_ENABLE_ZOXIDE=true` `DOTFILES_ENABLE_ATUIN=true`（以及 `DOTFILES_ENABLE_FZF=true` 等）在 `config/dotfiles.env` 中可修改为 `false` 关闭。

### 常用别名 (Alias)

| 别名 | Windows (PowerShell) | Linux/macOS (Zsh) | 说明 |
| :--- | :--- | :--- | :--- |
| `g` | `git` | `git` | Git 简写 |
| `ll` | `ls` (详细) | `ls -lh` | 详细列表 |
| `la` | `ls -Force` | `ls -a` | 显示所有文件 (含隐藏) |
| `l` | `ls -Force` | `ls -lah` | 详细列表 + 所有文件 |
| `dot` | `cd ~/dotfiles` | `cd $DOTFILES` | 快速跳转到配置仓库 |

## 🔄 更新配置

当你修改了仓库中的配置文件后：

*   **PowerShell**: 重启终端或运行 `. $PROFILE`
*   **Zsh**: 重启终端或运行 `source ~/.zshrc`
