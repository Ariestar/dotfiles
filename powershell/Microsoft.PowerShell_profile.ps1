# 1. 设置 UTF-8 编码，防止中文乱码（覆盖控制台/样式/外部进程）
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
if ($IsWindows) {
    chcp.com 65001 > $null
}

# 1.0 从共享配置文件加载开关（便于个性化扩展）
$configPath = Join-Path $HOME "dotfiles/config/dotfiles.env"
if (Test-Path $configPath) {
    Get-Content $configPath | ForEach-Object {
        if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
        $parts = $_ -split '=', 2
        if ($parts.Count -eq 2) {
            $name = $parts[0].Trim()
            $value = $parts[1].Trim()
            if ($name) { [Environment]::SetEnvironmentVariable($name, $value) }
        }
    }
}

# 1.1 交互增强：PSReadLine + posh-git（仅在已安装且未被禁用时启用）
function ConvertTo-Bool([string]$value, [bool]$default=$true) {
    if ([string]::IsNullOrWhiteSpace($value)) { return $default }
    switch ($value.ToLower()) {
        "true" { return $true }
        "1"    { return $true }
        "false" { return $false }
        "0"     { return $false }
        default { return $default }
    }
}

$enablePlugins = ConvertTo-Bool $env:DOTFILES_ENABLE_PLUGINS $true
$enablePsReadLine = ConvertTo-Bool $env:DOTFILES_ENABLE_PSREADLINE $enablePlugins
$enablePoshGit = ConvertTo-Bool $env:DOTFILES_ENABLE_POSH_GIT $enablePlugins

if ($enablePlugins) {
    if (Get-Module -ListAvailable PSReadLine) {
        if ($enablePsReadLine) {
            Import-Module PSReadLine
            Set-PSReadLineOption -PredictionSource HistoryAndPlugin
            Set-PSReadLineOption -PredictionViewStyle InlineView
            Set-PSReadLineOption -Colors @{ Command = '#00ff00'; Error = '#ff5555' }
        }
    }
    if (Get-Module -ListAvailable posh-git) {
        if ($enablePoshGit) {
            Import-Module posh-git
        }
    }
}

# 2. 初始化 Oh My Posh
# 注意：使用 $HOME 变量确保跨机兼容性
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$HOME/dotfiles/posh/theme.omp.json" | Invoke-Expression
}

# 3. 加载图标模块 (需提前 Install-Module Terminal-Icons)
if (Get-Module -ListAvailable Terminal-Icons) {
    Import-Module Terminal-Icons
}

# 4. 自定义 Alias (逻辑映射)
Set-Alias -Name g -Value git

# 列表显示增强
# ll: 详细列表 (Windows 默认 ls 即为详细)
Set-Alias -Name ll -Value ls
# la: 显示所有文件 (含隐藏)
function la { Get-ChildItem -Force @args }
# l:  显示所有文件 (同 la, 对应 Zsh 的 l)
function l { Get-ChildItem -Force @args }
