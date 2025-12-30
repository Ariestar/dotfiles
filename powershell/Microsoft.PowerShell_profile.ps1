# 1. 设置 UTF-8 编码，防止中文乱码
$OutputEncoding = [System.Text.Encoding]::UTF8

# 2. 初始化 Oh My Posh
# 注意：使用 $HOME 变量确保跨机兼容性
oh-my-posh init pwsh --config "$HOME/dotfiles/posh/theme.omp.json" | Invoke-Expression

# 3. 加载图标模块 (需提前 Install-Module Terminal-Icons)
if (Get-Module -ListAvailable Terminal-Icons) {
    Import-Module Terminal-Icons
}

# 4. 自定义 Alias (逻辑映射)
Set-Alias -Name g -Value git
Set-Alias -Name l -Value ls