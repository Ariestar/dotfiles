# env.nu - Nushell 环境变量配置
# 位置: ~/.config/nushell/env.nu
# 此文件在 config.nu 和 login.nu 之前加载

# ═══════════════════════════════════════════════════════════════════════════════
# 环境变量
# ═══════════════════════════════════════════════════════════════════════════════

# 设置 XDG 目录（统一配置文件位置）
$env.XDG_CONFIG_HOME = ($nu.home-dir | path join ".config")
$env.XDG_DATA_HOME = ($nu.home-dir | path join ".local" "share")
$env.XDG_CACHE_HOME = ($nu.home-dir | path join ".cache")

# 编辑器设置
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# 语言设置
$env.LANG = "en_US.UTF-8"

# 使用 Git 附带的 file.exe (支持 -L 参数) - Windows Only
if $nu.os-info.name == 'windows' {
    $env.YAZI_FILE_ONE = 'D:\Workspace\Apps\Scoop\apps\git\current\usr\bin\file.exe'
}

# Define DOTFILES path
$env.DOTFILES = (
    if ("~/dotfiles" | path expand | path exists) {
        ("~/dotfiles" | path expand)
    } else if ($nu.os-info.name == 'windows') {
        "V:\\Coding\\dotfiles"
    } else {
        ($nu.home-dir | path join "dotfiles")
    }
)
