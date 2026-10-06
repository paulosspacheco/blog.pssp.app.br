# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_Installer.ps1 (v2.1.3)
# Função: Instalador automatizado completo (Windows - Git Bash)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

param([string]$path)

# -----------------------------------------------------------
# 🧭 Cabeçalho
# -----------------------------------------------------------
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🚀 Instalador CopyToGDriver (Windows v2.1.3)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

$DefaultBase = "C:\scripts"
$UserProfile = [Environment]::GetFolderPath("UserProfile")
$ConfigDir   = Join-Path $UserProfile ".copytogdriver"
$RecordFile  = Join-Path $ConfigDir "install_record.json"
$LogFile     = Join-Path $ConfigDir "install_log.txt"
$InstallPathFile = Join-Path $ConfigDir "install_path.txt"

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

# -----------------------------------------------------------
# 🧾 Função de log
# -----------------------------------------------------------
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
}

Write-Log "==== Iniciando instalação CopyToGDriver v2.1.3 ====" "INFO"

# -----------------------------------------------------------
# 📁 Definir caminho de destino
# -----------------------------------------------------------
if ($path) {
    try { $Resolved = Resolve-Path $path -ErrorAction Stop; $TargetDir = $Resolved.Path }
    catch { $TargetDir = $path }
    Write-Host "📁 Caminho especificado pelo usuário: $TargetDir" -ForegroundColor Yellow
} else {
    $TargetDir = Join-Path $DefaultBase "CopyToGDriver"
    Write-Host "📁 Caminho padrão: $TargetDir" -ForegroundColor Yellow
}

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Log "Criado diretório: $TargetDir"
}

# 🔹 Registrar caminho de instalação persistente
Set-Content -Path $InstallPathFile -Value $TargetDir -Encoding UTF8
Write-Host "📦 Caminho de instalação registrado em: $InstallPathFile" -ForegroundColor Green

# 🔹 Criar variável de ambiente opcional
[Environment]::SetEnvironmentVariable("COPYTOGDRIVER_PATH", $TargetDir, "User")
Write-Host "🌍 Variável de ambiente 'COPYTOGDRIVER_PATH' configurada." -ForegroundColor Cyan

# -----------------------------------------------------------
# ⚙️ Função: Download com barra de progresso e re-tentativas
# -----------------------------------------------------------
function Download-WithProgress {
    param([string]$url, [string]$dest, [string]$label)
    $maxRetries = 3; $minSizeBytes = 10000000
    for ($attempt=1; $attempt -le $maxRetries; $attempt++) {
        try {
            Write-Host "⬇️ Baixando $label (tentativa $attempt de $maxRetries)..." -ForegroundColor Cyan
            if (Test-Path $dest) { Remove-Item $dest -Force }
            $request  = [System.Net.HttpWebRequest]::Create($url)
            $response = $request.GetResponse()
            $totalBytes = [int64]$response.ContentLength
            $stream = $response.GetResponseStream()
            $out = [System.IO.File]::Create($dest)
            $buffer = New-Object byte[] 8192; $totalRead = 0; $last = -1
            while (($read = $stream.Read($buffer,0,$buffer.Length)) -gt 0) {
                $out.Write($buffer,0,$read); $totalRead+=$read
                if ($totalBytes -gt 0) {
                    $percent=[math]::Floor(($totalRead/$totalBytes)*100)
                    if ($percent -ne $last) {
                        Write-Progress -Activity "Baixando $label" -Status "$percent% concluído" -PercentComplete $percent
                        $last=$percent
                    }
                }
            }
            $out.Close(); $stream.Close(); Write-Progress -Activity "Baixando $label" -Completed
            $size=(Get-Item $dest).Length
            if ($size -lt $minSizeBytes) { Start-Sleep 2; continue }
            Write-Host "✅ Download concluído: $dest ($size bytes)" -ForegroundColor Green
            Write-Log "Download OK: $label ($size bytes)" "INFO"
            return $true
        } catch {
            Write-Host "❌ Falha ao baixar ${label}: $($_.Exception.Message)" -ForegroundColor Red
            Start-Sleep 3
        }
    }
    Write-Host "🚫 Falha após $maxRetries tentativas." -ForegroundColor Red
    return $false
}

# -----------------------------------------------------------
# 🔍 Localizar Git Bash
# -----------------------------------------------------------
function Get-GitBashPath {
    $candidates = @(
        "C:\Program Files\Git\bin\bash.exe",
        "C:\Program Files (x86)\Git\bin\bash.exe",
        "C:\Program Files\Git\usr\bin\bash.exe",
        "C:\Program Files (x86)\Git\usr\bin\bash.exe"
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    return $null
}

# -----------------------------------------------------------
# ⚙️ Instalar e configurar Rclone (com navegador)
# -----------------------------------------------------------
$rcloneInstalledByScript = $false
if (-not (Get-Command rclone.exe -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ rclone não encontrado. Instalando..." -ForegroundColor Yellow
    $TempZip = Join-Path $env:TEMP "rclone.zip"
    $Url = "https://downloads.rclone.org/rclone-current-windows-amd64.zip"

    if (Download-WithProgress $Url $TempZip "rclone") {
        Expand-Archive -Path $TempZip -DestinationPath $env:TEMP -Force
        Start-Sleep -Seconds 2
        $exe = Get-ChildItem -Path $env:TEMP -Filter "rclone.exe" -Recurse | Select-Object -First 1
        if ($exe) {
            Copy-Item $exe.FullName "C:\Windows\System32\" -Force
            Write-Host "✅ rclone instalado em C:\Windows\System32" -ForegroundColor Green
            $rcloneInstalledByScript = $true
        }
        Remove-Item $TempZip -Force -ErrorAction SilentlyContinue
    } else { exit 1 }
} else {
    Write-Host "✅ rclone já está instalado." -ForegroundColor Green
}

# 🌐 Configurar remote gdriver
$confRemote = Read-Host "Deseja configurar o remote 'gdriver' agora no rclone? (S/N)"
if ($confRemote -match '^[sS]$') {
    Write-Host "`n🔧 Configurando remote 'gdriver' no rclone..." -ForegroundColor Cyan
    try {
        $existing = & rclone listremotes 2>$null
        if ($existing -notmatch "^gdriver:") {
            Write-Host "⚙️ Criando remote 'gdriver' (Google Drive padrão)..." -ForegroundColor Yellow
            & rclone config create gdriver drive scope=drive | Out-Null
        } else {
            Write-Host "✅ Remote 'gdriver' já existe." -ForegroundColor Green
        }

        Write-Host "🌐 Iniciando autenticação no navegador..." -ForegroundColor Cyan
        Start-Job -ScriptBlock { & rclone authorize "drive" } | Out-Null
        Write-Host "🕓 Aguarde o navegador abrir e finalize o login." -ForegroundColor Yellow
        Write-Host "⚙️ Após autorizar, pressione ENTER para continuar." -ForegroundColor Yellow
        Read-Host | Out-Null

        & rclone about gdriver: | Out-Null
        Write-Host "✅ Remote 'gdriver' autenticado e funcional." -ForegroundColor Green
    } catch {
        Write-Host "❌ Falha ao configurar o remote 'gdriver': $($_.Exception.Message)" -ForegroundColor Red
    }
}

# -----------------------------------------------------------
# 🧩 Verificar/instalar Git Bash
# -----------------------------------------------------------
Write-Host "`n🔍 Verificando Git Bash..." -ForegroundColor Cyan
$gitbashPresent = $false
$gitBashPath = Get-GitBashPath
if (Get-Command bash.exe -ErrorAction SilentlyContinue) {
    Write-Host "✅ Git Bash já está no PATH." -ForegroundColor Green
    $gitbashPresent = $true
} elseif ($gitBashPath) {
    Write-Host "⚠️ Git Bash encontrado em: $gitBashPath" -ForegroundColor Yellow
    $binDir = Split-Path $gitBashPath -Parent
    $env:Path += ";$binDir"
    [Environment]::SetEnvironmentVariable("Path", "$env:Path", "User")
    Write-Host "✅ Git Bash adicionado ao PATH." -ForegroundColor Green
    $gitbashPresent = $true
} else {
    Write-Host "⚠️ Git Bash não encontrado." -ForegroundColor Yellow
}

# -----------------------------------------------------------
# 📦 Copiar scripts e estrutura do projeto
# -----------------------------------------------------------
Write-Host "`n📦 Copiando scripts e estrutura completa do projeto..." -ForegroundColor Cyan
try {
    $projectRoot = Join-Path $PSScriptRoot "..\.."
    $resolvedRoot = Resolve-Path $projectRoot
    Copy-Item "$resolvedRoot\*" $TargetDir -Recurse -Force
    Write-Host "✅ Cópia concluída a partir de: $resolvedRoot" -ForegroundColor Green
    Write-Log "Cópia concluída a partir de: $resolvedRoot"
} catch {
    Write-Host "❌ Falha ao copiar arquivos: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# -----------------------------------------------------------
# 🔗 Corrigir gravação de aliases (com quebras de linha e Unix format)
# -----------------------------------------------------------
if ($gitbashPresent) {
    $bashrc = Join-Path $UserProfile ".bashrc"
    $content = Get-Content $bashrc -ErrorAction SilentlyContinue
    $filtered = $content | Where-Object { $_ -notmatch "CopyToGDriver" }

    $bashrcNew = @()
    $bashrcNew += $filtered
    $bashrcNew += ""
    $bashrcNew += "# === CopyToGDriver Aliases ==="
    $bashrcNew += "alias copydrive='/c/scripts/CopyToGDriver/CopyToGDriver_CopyCurrent.sh'"
    $bashrcNew += "alias copycheck='/c/scripts/CopyToGDriver/CopyToGDriver.sh --check-only'"
    $bashrcNew += "alias copyrestore='/c/scripts/CopyToGDriver/CopyToGDriver_Restore.sh'"

    $bashrcNew | Out-File $bashrc -Encoding utf8 -Force

    try { & dos2unix $bashrc | Out-Null } catch {}
    bash -lc "source ~/.bashrc" | Out-Null

    Write-Host "🔗 Aliases adicionados e ativados em ~/.bashrc" -ForegroundColor Green
}

# -----------------------------------------------------------
# 🧾 Registro da instalação
# -----------------------------------------------------------
$installInfo = @{
    installed_on = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    path = $TargetDir
    user = $env:USERNAME
    rclone = (Get-Command rclone.exe -ErrorAction SilentlyContinue) -ne $null
    gitbash = $gitbashPresent
    rclone_installed_by_script = $rcloneInstalledByScript
}
$installInfo | ConvertTo-Json | Out-File $RecordFile -Encoding UTF8
Write-Host "🧾 Registro de instalação criado: $RecordFile" -ForegroundColor Green

# -----------------------------------------------------------
# ✅ Finalização
# -----------------------------------------------------------
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "✅ Instalação concluída!" -ForegroundColor Green
Write-Host "📂 Local: $TargetDir" -ForegroundColor Cyan
Write-Host "📦 Caminho salvo em: $InstallPathFile" -ForegroundColor Cyan
if ($rcloneInstalledByScript) { Write-Host "🔧 rclone instalado pelo script." -ForegroundColor Cyan }
if ($gitbashPresent) { Write-Host "🧩 Git Bash disponível." -ForegroundColor Cyan }
Write-Host "📄 Log: $LogFile" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

