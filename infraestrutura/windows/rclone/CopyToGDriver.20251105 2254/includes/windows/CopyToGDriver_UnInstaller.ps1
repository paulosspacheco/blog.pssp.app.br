# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_UnInstaller.ps1 (v2.1.3)
# Função: Desinstalador completo e seguro para Windows (Git Bash)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

# -----------------------------------------------------------
# 🧭 Cabeçalho
# -----------------------------------------------------------
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🧹 Desinstalador CopyToGDriver (Windows v2.1.3)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

$UserProfile = [Environment]::GetFolderPath("UserProfile")
$ConfigDir   = Join-Path $UserProfile ".copytogdriver"
$RecordFile  = Join-Path $ConfigDir "install_record.json"
$PathFile    = Join-Path $ConfigDir "install_path.txt"
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
        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $line = "[$timestamp] [$Level] $Message"
        Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
    } catch {}
}

Write-Log "==== Iniciando desinstalação CopyToGDriver v2.1.3 ===="

# -----------------------------------------------------------
# 🔍 Detectar diretório de instalação
# -----------------------------------------------------------
$InstallDir = "C:\scripts\CopyToGDriver"
$rcloneInstalledByScript = $false
$gitbashConfigured = $false
$info = $null

if (Test-Path $RecordFile) {
    try {
        $info = Get-Content $RecordFile | ConvertFrom-Json
        if ($info.path) { $InstallDir = $info.path }
        if ($info.rclone_installed_by_script) { $rcloneInstalledByScript = $true }
        if ($info.gitbash) { $gitbashConfigured = $true }
        Write-Host "📄 Registro de instalação lido com sucesso." -ForegroundColor Green
        Write-Log "Registro de instalação lido de $RecordFile"
    } catch {
        Write-Host "⚠️ Falha ao ler registro de instalação. Tentando via install_path.txt..." -ForegroundColor Yellow
    }
}

# 🔹 Fallback: ler install_path.txt se o registro JSON falhar
if ((-not $info) -and (Test-Path $PathFile)) {
    try {
        $InstallDir = Get-Content $PathFile | Select-Object -First 1
        Write-Host "📄 Caminho recuperado de install_path.txt" -ForegroundColor Green
        Write-Log "Caminho lido de install_path.txt: $InstallDir"
    } catch {
        Write-Host "⚠️ Falha ao ler install_path.txt" -ForegroundColor Yellow
    }
}

Write-Host "📁 Pasta de instalação detectada: $InstallDir" -ForegroundColor Cyan

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
Write-Host "🛑 Encerrando processos rclone..." -ForegroundColor Cyan
Get-Process rclone -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        Stop-Process -Id $_.Id -Force
        Write-Log "Processo rclone encerrado (PID=$($_.Id))"
    } catch {}
}
if (-not (Get-Process rclone -ErrorAction SilentlyContinue)) {
    Write-Host "✅ Nenhum processo rclone ativo." -ForegroundColor Green
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
    Write-Host "ℹ️ Pasta de instalação não encontrada (talvez já removida)." -ForegroundColor Yellow
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
        Write-Log "Falha ao remover rclone.exe: $($_.Exception.Message)" "WARN"
    }
} else {
    Write-Host "ℹ️ rclone mantido (não foi instalado pelo script)." -ForegroundColor Yellow
}

# -----------------------------------------------------------
# 🧩 Remover aliases do Git Bash (~/.bashrc)
# -----------------------------------------------------------
$bashrc = Join-Path $UserProfile ".bashrc"
if (Test-Path $bashrc) {
    try {
        $content = Get-Content $bashrc -ErrorAction SilentlyContinue
        $filtered = $content | Where-Object { $_ -notmatch "CopyToGDriver" }
        $filtered | Out-File $bashrc -Encoding utf8 -Force
        try { & dos2unix $bashrc | Out-Null } catch {}
        bash -lc "source ~/.bashrc" | Out-Null
        Write-Host "🧩 Aliases do CopyToGDriver removidos e ~/.bashrc recarregado" -ForegroundColor Green
        Write-Log "Aliases removidos e bashrc recarregado"
    } catch {
        Write-Host "⚠️ Falha ao editar .bashrc: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# -----------------------------------------------------------
# 🧾 Remover registros e variáveis
# -----------------------------------------------------------
if (Test-Path $RecordFile) {
    Remove-Item $RecordFile -Force -ErrorAction SilentlyContinue
    Write-Host "🧾 Registro de instalação removido." -ForegroundColor Green
}
if (Test-Path $PathFile) {
    Remove-Item $PathFile -Force -ErrorAction SilentlyContinue
    Write-Host "🗑️  Caminho de instalação removido (install_path.txt)." -ForegroundColor Green
}

# Remover variável de ambiente
[Environment]::SetEnvironmentVariable("COPYTOGDRIVER_PATH", $null, "User")
Write-Host "🌍 Variável de ambiente 'COPYTOGDRIVER_PATH' removida." -ForegroundColor Green

# -----------------------------------------------------------
# 🧾 Limpar logs e config
# -----------------------------------------------------------
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

