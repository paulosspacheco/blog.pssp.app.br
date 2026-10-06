# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_UnInstaller.ps1 (v2.0.11)
# Função: Desinstalador completo e seguro para Windows
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

# -----------------------------------------------------------
# 🧭 Cabeçalho
# -----------------------------------------------------------
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🧹 Desinstalador CopyToGDriver (Windows v2.0.11)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

$UserProfile = [Environment]::GetFolderPath("UserProfile")
$ConfigDir   = Join-Path $UserProfile ".copytogdriver"
$RecordFile  = Join-Path $ConfigDir "install_record.json"
$LogFile     = Join-Path $ConfigDir "uninstall_log.txt"

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

# -----------------------------------------------------------
# 🧾 Função de log
# -----------------------------------------------------------
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    try {
        if (-not (Test-Path (Split-Path $LogFile))) {
            New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force | Out-Null
        }
        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $line = "[$timestamp] [$Level] $Message"
        Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
    } catch {}
}

Write-Log "==== Iniciando desinstalação CopyToGDriver v2.0.11 ===="

# -----------------------------------------------------------
# 🔍 Ler registro de instalação (se existir)
# -----------------------------------------------------------
$InstallDir = "C:\scripts\CopyToGDriver"
$rcloneInstalledByScript = $false
$gitbashConfigured = $false

if (Test-Path $RecordFile) {
    try {
        $info = Get-Content $RecordFile | ConvertFrom-Json
        if ($info.path) { $InstallDir = $info.path }
        if ($info.rclone_installed_by_script) { $rcloneInstalledByScript = $true }
        if ($info.gitbash) { $gitbashConfigured = $true }
        Write-Host "📄 Registro de instalação lido." -ForegroundColor Green
        Write-Log "Registro de instalação lido."
    } catch {
        Write-Host "⚠️ Falha ao ler registro de instalação. Continuando com valores padrão." -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️ Nenhum registro de instalação encontrado." -ForegroundColor Yellow
}

Write-Host "📁 Pasta de instalação: $InstallDir" -ForegroundColor Cyan

# -----------------------------------------------------------
# ⚠️ Confirmação do usuário
# -----------------------------------------------------------
$confirm = Read-Host "Remover o CopyToGDriver de '$InstallDir'? (s/N)"
if ($confirm -notmatch '^[sS]$') {
    Write-Host "❎ Desinstalação cancelada pelo usuário." -ForegroundColor Yellow
    Write-Log "Cancelada pelo usuário."
    exit
}

# -----------------------------------------------------------
# 🛑 Encerrar rclone se estiver ativo
# -----------------------------------------------------------
Write-Host "🛑 Encerrando rclone..." -ForegroundColor Cyan
Get-Process rclone -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        Stop-Process -Id $_.Id -Force
        Write-Log "Processo rclone encerrado (PID=$($_.Id))"
    } catch {}
}
if (-not (Get-Process rclone -ErrorAction SilentlyContinue)) {
    Write-Host "✅ Nenhum processo ativo." -ForegroundColor Green
}

# -----------------------------------------------------------
# 🧹 Remover pasta de instalação
# -----------------------------------------------------------
if (Test-Path $InstallDir) {
    try {
        Remove-Item -Recurse -Force -Path $InstallDir
        Write-Host "✅ Pasta removida: $InstallDir" -ForegroundColor Green
        Write-Log "Pasta $InstallDir removida."
    } catch {
        Write-Host "❌ Falha ao remover a pasta de instalação: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log "Falha ao remover pasta: $($_.Exception.Message)" "ERROR"
    }
} else {
    Write-Host "ℹ️ Pasta de instalação não encontrada." -ForegroundColor Yellow
}

# -----------------------------------------------------------
# 🧩 Remover rclone se foi instalado pelo script
# -----------------------------------------------------------
$rclonePath = "C:\Windows\System32\rclone.exe"

if ($rcloneInstalledByScript -and (Test-Path $rclonePath)) {
    try {
        Remove-Item -Force $rclonePath
        Write-Host "✅ rclone.exe removido (instalado pelo CopyToGDriver)" -ForegroundColor Green
        Write-Log "rclone.exe removido (instalado pelo script)."
    } catch {
        Write-Host "⚠️ Falha ao remover rclone.exe: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} elseif (Test-Path $rclonePath) {
    $manual = Read-Host "rclone.exe foi encontrado em '$rclonePath', mas não há registro. Deseja removê-lo mesmo assim? (s/N)"
    if ($manual -match '^[sS]$') {
        try {
            Remove-Item -Force $rclonePath
            Write-Host "✅ rclone.exe removido conforme solicitado." -ForegroundColor Green
            Write-Log "rclone.exe removido manualmente."
        } catch {
            Write-Host "⚠️ Falha ao remover rclone.exe: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "ℹ️ Mantendo rclone existente." -ForegroundColor Yellow
    }
} else {
    Write-Host "ℹ️ rclone não encontrado no sistema." -ForegroundColor Yellow
}

# -----------------------------------------------------------
# 🧩 Remover aliases do Git Bash
# -----------------------------------------------------------
$bashrc = Join-Path $UserProfile ".bashrc"
if (Test-Path $bashrc) {
    $content = Get-Content $bashrc -ErrorAction SilentlyContinue
    $filtered = $content | Where-Object { $_ -notmatch "CopyToGDriver" }
    $filtered | Set-Content $bashrc -Encoding UTF8
    Write-Host "🧩 Aliases do CopyToGDriver removidos do .bashrc" -ForegroundColor Green
    Write-Log "Aliases removidos do .bashrc"
}

# -----------------------------------------------------------
# 🧾 Remover registro e diretório de configuração
# -----------------------------------------------------------
if (Test-Path $RecordFile) {
    Remove-Item $RecordFile -Force -ErrorAction SilentlyContinue
    Write-Host "🧾 Registro de instalação removido." -ForegroundColor Green
}

if (Test-Path $LogFile) {
    Remove-Item $LogFile -Force -ErrorAction SilentlyContinue
    Write-Host "🧾 Log de desinstalação limpo." -ForegroundColor Green
}

if (Test-Path $ConfigDir) {
    Remove-Item -Recurse -Force $ConfigDir -ErrorAction SilentlyContinue
    Write-Host "🧹 Diretório de configuração removido: $ConfigDir" -ForegroundColor Green
}


# -----------------------------------------------------------
# 🧼 Remover pasta residual do rclone (opcional)
# -----------------------------------------------------------
$rcloneSync = Join-Path $UserProfile ".rclone-sync"
if (Test-Path $rcloneSync) {
    try {
        Remove-Item -Recurse -Force $rcloneSync -ErrorAction SilentlyContinue
        Write-Host "🧼 Pasta residual do rclone removida: ${rcloneSync}" -ForegroundColor Green
        Write-Log "Pasta .rclone-sync removida." "INFO"
    } catch {
        Write-Host "⚠️ Não foi possível remover ${rcloneSync}: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Log "Falha ao remover ${rcloneSync}: $($_.Exception.Message)" "WARN"
    }
}



# -----------------------------------------------------------
# ✅ Finalização
# -----------------------------------------------------------
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "✅ Desinstalação concluída!" -ForegroundColor Green
Write-Host "📄 Log: $LogFile" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Log "Desinstalação concluída com sucesso."
