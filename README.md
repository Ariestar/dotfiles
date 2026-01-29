# 🔧 Dotfiles

跨平台终端配置文件管理仓库 (Windows & Linux/macOS)。
v2.0.0 起默认终端组合为 WezTerm + Nushell + Starship。

## 📂 目录结构

```text
dotfiles/
├── config/nushell/   # Nushell 配置
├── config/wezterm/   # WezTerm 配置
├── config/starship.toml # Starship 配置
└── zsh/              # Linux/macOS Zsh 配置（可选）
```

## ✨ 功能特性

*   **统一终端栈**: Windows 默认使用 WezTerm + Nushell + Starship。
*   **高可定制**: WezTerm 外观与按键、Nushell 语法与别名、Starship 提示符风格可组合调整。
*   **环境隔离**: 配置文件通过软链接指向本仓库，方便通过 Git 进行版本控制和同步。
*   **常用别名**: 预设 `g` (git), `ll` (ls) 等常用别名。

## 🚀 快速开始

### 前置要求

在安装配置之前，请确保已安装以下基础工具：

1.  **Git**: 用于管理版本控制。
2.  **WezTerm**: 终端模拟器。
3.  **Nushell**: 交互式 shell。
4.  **Starship**: 终端提示符。
5.  **Nerd Fonts**: 为了正确显示图标，请安装并配置 Nerd Font。

### 📦 安装步骤

#### Windows (WezTerm + Nushell + Starship)

安装依赖（示例：winget）：

```powershell
winget install wez.wezterm
winget install nushell.nushell
winget install Starship.Starship
```

将配置链接到标准位置：

```powershell
mkdir $env:USERPROFILE\.config -ea 0
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.config\nushell -Target $PWD\config\nushell
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.config\wezterm -Target $PWD\config\wezterm
New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.config\starship.toml -Target $PWD\config\starship.toml
```

#### Linux / macOS (Zsh)

在终端中运行安装脚本：

```bash
# 进入仓库目录
cd dotfiles

# 赋予执行权限并运行
chmod +x install.sh
./install.sh
```

> **注意**: 脚本会将 `~/.zshrc` 链接到仓库中的 `zsh/.zshrc`，并建立 `~/dotfiles` 的软链接以确保路径一致性。

### 常用别名 (Alias)

| 别名 | Windows (Nushell) | Linux/macOS (Zsh) | 说明 |
| :--- | :--- | :--- | :--- |
| `g` | `git` | `git` | Git 简写 |
| `ll` | `ls` (详细) | `ls -lh` | 详细列表 |
| `la` | `ls -Force` | `ls -a` | 显示所有文件 (含隐藏) |
| `l` | `ls -Force` | `ls -lah` | 详细列表 + 所有文件 |
| `dot` | `cd ~/dotfiles` | `cd $DOTFILES` | 快速跳转到配置仓库 |

## 🔄 更新配置

当你修改了仓库中的配置文件后：

*   **Nushell**: 重启终端或运行 `source ~/.config/nushell/config.nu`
*   **Zsh**: 重启终端或运行 `source ~/.zshrc`

## 🧭 版本 2.0.0 迁移说明

*   Windows 终端方案统一为 WezTerm + Nushell + Starship。
*   不再使用 Windows Terminal / PowerShell / Oh My Posh。
