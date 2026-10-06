# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_PlatformInstaller.ps1
# Função: Detecta sistema operacional e copia os instaladores corretos para a raiz
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 1.1.1 (Windows dispatcher multiplataforma - Estrutura Include)
# ===========================================================

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🧩 CopyToGDriver Instalador Multiplataforma (Windows Dispatcher)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Pasta atual do script (agora dentro de include/packagers/windows/)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "📁 Diretório do script: $ScriptDir" -ForegroundColor Gray

# Encontrar a raiz do projeto (subindo 3 níveis: windows/packagers/include/)
$RootDir = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $ScriptDir))
$IncludesDir = Join-Path $RootDir "includes"

Write-Host "📁 Raiz do projeto: $RootDir" -ForegroundColor Gray
Write-Host "📁 Includes dir: $IncludesDir" -ForegroundColor Gray

# Detectar plataforma
$Platform = ""
if ($IsWindows) {
    $Platform = "windows"
} elseif ($IsMacOS -or $env:OSTYPE -like "*darwin*") {
    $Platform = "macos"
} elseif ($IsLinux -or $env:OSTYPE -like "*linux*") {
    $Platform = "linux"
} else {
    Write-Host "❌ Plataforma desconhecida. Abortando." -ForegroundColor Red
    exit 1
}

Write-Host "🔍 Plataforma detectada: $Platform" -ForegroundColor Yellow
$PlatformDir = Join-Path $IncludesDir $Platform

if (-not (Test-Path $PlatformDir)) {
    Write-Host "❌ Diretório não encontrado: $PlatformDir" -ForegroundColor Red
    Write-Host "📋 Estrutura esperada:" -ForegroundColor Yellow
    Write-Host "   projeto/includes/windows/ - Scripts Windows" -ForegroundColor Gray
    Write-Host "   projeto/includes/linux/   - Scripts Linux" -ForegroundColor Gray
    Write-Host "   projeto/includes/macos/   - Scripts macOS" -ForegroundColor Gray
    exit 1
}

Write-Host "✅ Diretório da plataforma encontrado: $PlatformDir" -ForegroundColor Green

# Limpar instaladores antigos
Write-Host "🧹 Limpando instaladores antigos..." -ForegroundColor Yellow
Get-ChildItem $RootDir -Filter "CopyToGDriver_Installer.*" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem $RootDir -Filter "CopyToGDriver_UnInstaller.*" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

# Copiar os arquivos corretos
Write-Host "📋 Copiando instaladores para a raiz..." -ForegroundColor Yellow
switch ($Platform) {
    "windows" {
        $sourceInstaller = Join-Path $PlatformDir "CopyToGDriver_Installer.ps1"
        $sourceUninstaller = Join-Path $PlatformDir "CopyToGDriver_UnInstaller.ps1"

        if (Test-Path $sourceInstaller) {
            Copy-Item $sourceInstaller "$RootDir" -Force
            Write-Host "   ✅ CopyToGDriver_Installer.ps1" -ForegroundColor Green
        } else {
            Write-Host "   ❌ CopyToGDriver_Installer.ps1 não encontrado" -ForegroundColor Red
        }

        if (Test-Path $sourceUninstaller) {
            Copy-Item $sourceUninstaller "$RootDir" -Force
            Write-Host "   ✅ CopyToGDriver_UnInstaller.ps1" -ForegroundColor Green
        } else {
            Write-Host "   ❌ CopyToGDriver_UnInstaller.ps1 não encontrado" -ForegroundColor Red
        }
    }
    "linux" {
        $sourceInstaller = Join-Path $PlatformDir "CopyToGDriver_Installer.sh"
        $sourceUninstaller = Join-Path $PlatformDir "CopyToGDriver_UnInstaller.sh"

        if (Test-Path $sourceInstaller) {
            Copy-Item $sourceInstaller "$RootDir" -Force
            Write-Host "   ✅ CopyToGDriver_Installer.sh" -ForegroundColor Green
        }
        if (Test-Path $sourceUninstaller) {
            Copy-Item $sourceUninstaller "$RootDir" -Force
            Write-Host "   ✅ CopyToGDriver_UnInstaller.sh" -ForegroundColor Green
        }
    }
    "macos" {
        $sourceInstaller = Join-Path $PlatformDir "CopyToGDriver_Installer.sh"
        $sourceUninstaller = Join-Path $PlatformDir "CopyToGDriver_UnInstaller.sh"

        if (Test-Path $sourceInstaller) {
            Copy-Item $sourceInstaller "$RootDir" -Force
            Write-Host "   ✅ CopyToGDriver_Installer.sh" -ForegroundColor Green
        }
        if (Test-Path $sourceUninstaller) {
            Copy-Item $sourceUninstaller "$RootDir" -Force
            Write-Host "   ✅ CopyToGDriver_UnInstaller.sh" -ForegroundColor Green
        }
    }
}

# Verificar se os arquivos foram copiados com sucesso
Write-Host ""
Write-Host "📋 Verificando arquivos na raiz:" -ForegroundColor Cyan
Get-ChildItem $RootDir -Filter "CopyToGDriver_*" | ForEach-Object {
    Write-Host "   • $($_.Name)" -ForegroundColor White
}

# Perguntar se deseja executar o instalador
Write-Host ""
$run = Read-Host "Deseja executar o instalador agora? (s/N)"
if ($run -match '^[sS]$') {
    switch ($Platform) {
        "windows" {
            $installerPath = Join-Path $RootDir "CopyToGDriver_Installer.ps1"
            if (Test-Path $installerPath) {
                Write-Host "🚀 Executando instalador Windows..." -ForegroundColor Cyan
                powershell -ExecutionPolicy Bypass -File $installerPath
            } else {
                Write-Host "❌ Instalador não encontrado: $installerPath" -ForegroundColor Red
            }
        }
        default {
            $installerPath = Join-Path $RootDir "CopyToGDriver_Installer.sh"
            if (Test-Path $installerPath) {
                Write-Host "🚀 Executando instalador Bash..." -ForegroundColor Cyan
                bash $installerPath
            } else {
                Write-Host "❌ Instalador não encontrado: $installerPath" -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host "ℹ️ Você pode executar manualmente depois:" -ForegroundColor Yellow
    switch ($Platform) {
        "windows" {
            Write-Host "   PowerShell -ExecutionPolicy Bypass -File CopyToGDriver_Installer.ps1" -ForegroundColor Gray
        }
        default {
            Write-Host "   ./CopyToGDriver_Installer.sh" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "✅ Plataforma '$Platform' preparada com sucesso!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan
