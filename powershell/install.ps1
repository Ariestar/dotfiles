# ==============================================================================
# 🚀 PowerShell 自动化配置脚本
# 功能: 链接配置文件、安装依赖模块、配置 Oh My Posh
# ==============================================================================

Write-Host "`n📦 开始配置 PowerShell 环境...`n" -ForegroundColor Cyan

# --- [1. 环境变量与路径定义] ---
$RepoRoot = Resolve-Path "$PSScriptRoot\.."
$TargetProfile = $PROFILE
# 检查是否为 PowerShell Core (pwsh) 或 Windows PowerShell
# 优先配置当前正在使用的宿主 (CurrentUserCurrentHost)
# 如果 $PROFILE 路径所在的文件夹不存在，则创建
$ProfileDir = Split-Path $TargetProfile -Parent
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
}

$SourceProfile = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"

# --- [2. 确保 ~/dotfiles 链接存在] ---
# 因为配置文件中硬编码了 "$HOME/dotfiles"，我们需要建立软链
$HomeDotfiles = Join-Path $HOME "dotfiles"
if (-not (Test-Path $HomeDotfiles)) {
    Write-Host "🔗 建立 ~/dotfiles 软链接 -> $RepoRoot" -ForegroundColor Yellow
    try {
        New-Item -ItemType SymbolicLink -Path $HomeDotfiles -Target $RepoRoot -Force | Out-Null
    } catch {
        Write-Warning "无法创建软链接 (可能需要管理员权限)。请手动将仓库放置在 $HomeDotfiles"
    }
} else {
    # 检查是否指向正确的位置
    $Item = Get-Item $HomeDotfiles
    if ($Item.LinkType -eq "SymbolicLink") {
         # 简单检查，不做强制覆盖，避免误删用户文件
         Write-Host "✅ ~/dotfiles 链接已存在" -ForegroundColor Green
    } else {
         Write-Host "✅ ~/dotfiles 路径已存在 (非软链)" -ForegroundColor Green
    }
}

# --- [3. 链接 Profile 配置文件] ---
Write-Host "🔗 配置 PowerShell Profile..." -ForegroundColor Yellow
if (Test-Path $TargetProfile) {
    # 检查是否已经是软链
    $Item = Get-Item $TargetProfile
    if ($Item.LinkType -eq "SymbolicLink") {
        # 此时 Target 可能是相对路径或绝对路径，简单处理
        Write-Host "ℹ️  Profile 已存在 (软链)，跳过覆盖。" -ForegroundColor Gray
    } else {
        $BackupPath = "$TargetProfile.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Move-Item $TargetProfile $BackupPath -Force
        Write-Host "⚠️  原有 Profile 已备份至: $BackupPath" -ForegroundColor Gray
        
        New-Item -ItemType SymbolicLink -Path $TargetProfile -Target $SourceProfile -Force | Out-Null
        Write-Host "✅ 新 Profile 链接创建成功" -ForegroundColor Green
    }
} else {
    New-Item -ItemType SymbolicLink -Path $TargetProfile -Target $SourceProfile -Force | Out-Null
    Write-Host "✅ 新 Profile 链接创建成功" -ForegroundColor Green
}

# --- [4. 检查并安装依赖模块] ---
Write-Host "`n📦 检查依赖模块..." -ForegroundColor Yellow

# 4.1 Terminal-Icons
if (-not (Get-Module -ListAvailable Terminal-Icons)) {
    Write-Host "⬇️  正在安装 Terminal-Icons..." -ForegroundColor Cyan
    # 确保 NuGet 提供程序存在
    if (-not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
        Write-Host "   安装 NuGet provider..." -ForegroundColor Gray
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
    }
    Install-Module Terminal-Icons -Scope CurrentUser -Force -AllowClobber
} else {
    Write-Host "✅ Terminal-Icons 已安装" -ForegroundColor Green
}

# 4.2 Oh My Posh
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️  未检测到 Oh My Posh" -ForegroundColor Red
    Write-Host "👉 请运行以下命令安装 (Windows):" -ForegroundColor White
    Write-Host "   winget install JanDeDobbeleer.OhMyPosh -s winget" -ForegroundColor Gray
} else {
    Write-Host "✅ Oh My Posh 已安装" -ForegroundColor Green
}

Write-Host "`n🎉 配置完成! 请重启终端生效。" -ForegroundColor Cyan
