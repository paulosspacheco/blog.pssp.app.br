# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_Installer.ps1 (v2.2.3)
# Função: Instalador automatizado completo (Windows - Git Bash)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

param(
    [string]$path,
    [string]$parameters = ""
)

# -----------------------------------------------------------
# 🧭 Cabeçalho
# -----------------------------------------------------------
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🚀 Instalador CopyToGDriver (Windows v2.2.3)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------
# Diretórios padrão e arquivos de controle
# -----------------------------------------------------------
$DefaultBase      = "C:\scripts"
$UserProfile      = [Environment]::GetFolderPath("UserProfile")
$ConfigDir        = Join-Path $UserProfile ".copytogdriver"
$RecordFile       = Join-Path $ConfigDir "install_record.json"
$LogFile          = Join-Path $ConfigDir "install_log.txt"
$InstallPathFile  = Join-Path $ConfigDir "install_path.txt"

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

# -----------------------------------------------------------
# 🧾 Função de log
# -----------------------------------------------------------
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
    Write-Host $line
}

Write-Log "==== Iniciando instalação CopyToGDriver v2.2.3 ====" "INFO"

# -----------------------------------------------------------
# 🔧 Processamento dos parâmetros extras (estilo --flag=valor)
# -----------------------------------------------------------
$ScriptParams = @{}

if ($parameters) {
    Write-Log "Parâmetros recebidos: $parameters"
    $paramArray = $parameters -split '\s+'
    foreach ($param in $paramArray) {
        if ($param -match '^--([^=]+)=(.+)$') {
            $ScriptParams[$Matches[1]] = $Matches[2]
        } elseif ($param -match '^--(.+)$') {
            $ScriptParams[$Matches[1]] = $true
        }
    }
}

function Test-Parameter {
    param([string]$Name)
    return $ScriptParams.ContainsKey($Name) -and $ScriptParams[$Name] -eq $true
}

# -----------------------------------------------------------
# 📁 Definir caminho de destino
# -----------------------------------------------------------
if ($path) {
    try {
        $Resolved  = Resolve-Path $path -ErrorAction Stop
        $TargetDir = $Resolved.Path
    } catch {
        $TargetDir = $path
    }
    Write-Host "📁 Caminho especificado pelo usuário: $TargetDir" -ForegroundColor Yellow
    Write-Log  "Caminho especificado pelo usuário: $TargetDir"
} else {
    $TargetDir = Join-Path $DefaultBase "CopyToGDriver"
    Write-Host "📁 Caminho padrão: $TargetDir" -ForegroundColor Yellow
    Write-Log  "Caminho padrão: $TargetDir"
}

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Log "Criado diretório de instalação: $TargetDir"
}

# 🔹 Registrar caminho de instalação
Set-Content -Path $InstallPathFile -Value $TargetDir -Encoding UTF8
Write-Host "📦 Caminho de instalação registrado em: $InstallPathFile" -ForegroundColor Green

# 🔹 Variável de ambiente
[Environment]::SetEnvironmentVariable("COPYTOGDRIVER_PATH", $TargetDir, "User")
Write-Host "🌍 Variável de ambiente 'COPYTOGDRIVER_PATH' configurada." -ForegroundColor Cyan

# -----------------------------------------------------------
# ⚙️ Função de download com progresso
# -----------------------------------------------------------
function Download-WithProgress {
    param(
        [string]$url,
        [string]$dest,
        [string]$label
    )

    $maxRetries   = 3
    $minSizeBytes = 1000000   # 1 MB só pra garantir que não baixou lixo

    for ($attempt = 1; $attempt -le $maxRetries; $attempt++) {
        try {
            Write-Host "⬇️ Baixando $label (tentativa $attempt de $maxRetries)..." -ForegroundColor Cyan
            Write-Log  "Baixando $label (tentativa $attempt)"

            if (Test-Path $dest) { Remove-Item $dest -Force }

            $request  = [System.Net.HttpWebRequest]::Create($url)
            $response = $request.GetResponse()
            $totalBytes = [int64]$response.ContentLength
            $stream  = $response.GetResponseStream()
            $outFile = [System.IO.File]::Create($dest)

            $buffer   = New-Object byte[] 8192
            $totalRead = 0
            $lastPercent = -1

            while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                $outFile.Write($buffer, 0, $read)
                $totalRead += $read

                if ($totalBytes -gt 0) {
                    $percent = [math]::Floor(($totalRead / $totalBytes) * 100)
                    if ($percent -ne $lastPercent) {
                        Write-Progress -Activity "Baixando $label" -Status "$percent% concluído" -PercentComplete $percent
                        $lastPercent = $percent
                    }
                }
            }

            $outFile.Close()
            $stream.Close()
            Write-Progress -Activity "Baixando $label" -Completed

            $size = (Get-Item $dest).Length
            if ($size -lt $minSizeBytes) {
                Write-Log "Tamanho muito pequeno ($size bytes). Tentando novamente..." "WARN"
                Start-Sleep 2
                continue
            }

            Write-Host "✅ Download concluído: $dest ($size bytes)" -ForegroundColor Green
            Write-Log  "Download OK: $label ($size bytes)" "INFO"
            return $true
        } catch {
            Write-Host "❌ Falha ao baixar ${label}: $($_.Exception.Message)" -ForegroundColor Red
            Write-Log  "Falha ao baixar ${label}: $($_.Exception.Message)" "ERROR"
            Start-Sleep 3
        }
    }

    Write-Host "🚫 Falha após $maxRetries tentativas para $label." -ForegroundColor Red
    Write-Log  "Falha definitiva no download de $label" "ERROR"
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
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    return $null
}

# -----------------------------------------------------------
# ⚙️ Instalar Rclone (opcional, mas recomendado)
# -----------------------------------------------------------
$rcloneInstalledByScript = $false

if (-not (Get-Command rclone.exe -ErrorAction SilentlyContinue)) {
    if (Test-Parameter "auto-install-rclone") {
        Write-Host "⚠️ rclone não encontrado. Instalando..." -ForegroundColor Yellow
        Write-Log  "rclone não encontrado. Iniciando instalação automática."

        $TempZip = Join-Path $env:TEMP "rclone.zip"
        $Url     = "https://downloads.rclone.org/rclone-current-windows-amd64.zip"

        if (Download-WithProgress $Url $TempZip "rclone") {
            Expand-Archive -Path $TempZip -DestinationPath $env:TEMP -Force
            Start-Sleep -Seconds 2
            $exe = Get-ChildItem -Path $env:TEMP -Filter "rclone.exe" -Recurse | Select-Object -First 1
            if ($exe) {
                Copy-Item $exe.FullName "C:\Windows\System32\" -Force
                Write-Host "✅ rclone instalado em C:\Windows\System32" -ForegroundColor Green
                Write-Log  "rclone instalado em C:\Windows\System32" "INFO"
                $rcloneInstalledByScript = $true
            } else {
                Write-Host "❌ Não foi encontrado rclone.exe após extração." -ForegroundColor Red
                Write-Log  "rclone.exe não encontrado após extração" "ERROR"
            }
            Remove-Item $TempZip -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "❌ Falha ao baixar rclone. Abortando instalação." -ForegroundColor Red
            Write-Log  "Falha ao baixar rclone. Instalação abortada." "ERROR"
            exit 1
        }
    } else {
        Write-Host "❌ rclone não encontrado e instalação automática não habilitada (--auto-install-rclone)." -ForegroundColor Red
        Write-Log  "rclone não encontrado e auto-install-rclone não informado. Abortando instalação." "ERROR"
        exit 1
    }
} else {
    Write-Host "✅ rclone já está instalado." -ForegroundColor Green
    Write-Log  "rclone já está instalado."
}

# -----------------------------------------------------------
# 🌐 Configurar e autenticar remote 'gdriver' (OAuth obrigatório, não bloqueante)
# -----------------------------------------------------------
if (Test-Parameter "auto-config-remote") {
    Write-Host "`n🔧 Configurando remote 'gdriver' no rclone (OAuth obrigatório)..." -ForegroundColor Cyan
    Write-Log  "Iniciando configuração do remote 'gdriver'."

    try {
        $existing = rclone listremotes 2>$null
        if ($existing -notmatch "^gdriver:") {
            Write-Host "⚙️ Criando remote 'gdriver' (tipo drive)..." -ForegroundColor Yellow
            Write-Log  "Criando remote 'gdriver' (drive)."
            & rclone config create gdriver drive scope=drive | Out-Null
        } else {
            Write-Host "✅ Remote 'gdriver' já existe." -ForegroundColor Green
            Write-Log  "Remote 'gdriver' já existe."
        }

        # 🔹 Fluxo OAuth obrigatório – abre navegador (não bloqueante)
        Write-Host "`n🌐 Iniciando autenticação no navegador (rclone authorize drive)..." -ForegroundColor Cyan
        Write-Host "🔑 Faça login com sua conta Google e autorize o acesso." -ForegroundColor Yellow
        Write-Host "   A instalação continuará automaticamente após a autenticação." -ForegroundColor Yellow
        Write-Log  "Executando rclone authorize drive (OAuth, não bloqueante)."

        try {
            # Executa o rclone authorize em background (sem bloquear)
            Start-Process -FilePath "rclone" -ArgumentList "authorize drive" -NoNewWindow -ErrorAction SilentlyContinue | Out-Null
        } catch {
            Write-Host "❌ Falha ao iniciar o navegador: $($_.Exception.Message)" -ForegroundColor Red
            Write-Log  "Erro ao iniciar navegador OAuth: $($_.Exception.Message)" "ERROR"
            exit 2
        }

        # 🔹 Loop de validação (aguarda até 2 minutos ou sucesso)
        $timeout   = [datetime]::Now.AddMinutes(2)
        $validated = $false

        Write-Host "`n⏳ Aguardando conclusão da autenticação (até 2 minutos)..." -ForegroundColor Cyan
        while (-not $validated -and [datetime]::Now -lt $timeout) {
            try {
                & rclone about gdriver: 2>$null | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    $validated = $true
                    break
                }
            } catch {}
            Start-Sleep -Seconds 5
        }

        if ($validated) {
            Write-Host "✅ Remote 'gdriver' autenticado com sucesso!" -ForegroundColor Green
            Write-Log  "Remote 'gdriver' autenticado com sucesso." "INFO"
        } else {
            Write-Host "❌ Timeout de autenticação atingido. O usuário não concluiu o login no navegador." -ForegroundColor Red
            Write-Log  "Falha de autenticação: timeout atingido." "ERROR"
            exit 2
        }
    } catch {
        Write-Host "❌ Erro ao configurar/autenticar o remote 'gdriver': $($_.Exception.Message)" -ForegroundColor Red
        Write-Log  "Erro ao configurar/autenticar 'gdriver': $($_.Exception.Message)" "ERROR"
        exit 2
    }
} else {
    Write-Host "⚠️ Aviso: --auto-config-remote NÃO informado. O remote 'gdriver' não será configurado aqui." -ForegroundColor Yellow
    Write-Log  "auto-config-remote não informado. Remote 'gdriver' não será criado/autenticado." "WARN"
}


# -----------------------------------------------------------
# 🧩 Verificar/instalar Git Bash
# -----------------------------------------------------------
Write-Host "`n🔍 Verificando Git Bash..." -ForegroundColor Cyan
Write-Log  "Verificando Git Bash."

$gitbashPresent  = $false
$gitbashInstalled = $false
$gitBashPath     = Get-GitBashPath

if (Get-Command bash.exe -ErrorAction SilentlyContinue) {
    Write-Host "✅ Git Bash já está no PATH." -ForegroundColor Green
    Write-Log  "Git Bash encontrado no PATH."
    $gitbashPresent = $true
} elseif ($gitBashPath) {
    Write-Host "⚠️ Git Bash encontrado em: $gitBashPath" -ForegroundColor Yellow
    Write-Log  "Git Bash encontrado em: $gitBashPath"
    $binDir = Split-Path $gitBashPath -Parent
    $env:Path += ";$binDir"
    [Environment]::SetEnvironmentVariable("Path", "$env:Path", "User")
    Write-Host "✅ Git Bash adicionado ao PATH." -ForegroundColor Green
    Write-Log  "Git Bash adicionado ao PATH."
    $gitbashPresent = $true
} elseif (Test-Parameter "auto-install-gitbash") {
    # Instalação automática de Git Bash (igual v2.2.2)
    Write-Host "⚠️ Git Bash não encontrado. Instalando automaticamente..." -ForegroundColor Yellow
    Write-Log  "Git Bash não encontrado. Iniciando instalação automática."

    $installer = Join-Path $env:TEMP "Git-Installer.exe"
    $urlGit    = "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe"

    if (Download-WithProgress $urlGit $installer "Git Bash") {
        $process = Start-Process -FilePath $installer -ArgumentList @("/VERYSILENT", "/NORESTART", "/NOCANCEL") -Wait -PassThru
        Start-Sleep -Seconds 10
        if ($process.ExitCode -eq 0) {
            Write-Host "✅ Git Bash instalado com sucesso." -ForegroundColor Green
            Write-Log  "Git Bash instalado com sucesso." "INFO"
            $gitbashPresent   = $true
            $gitbashInstalled = $true
        } else {
            Write-Host "❌ Falha ao instalar Git Bash. Código: $($process.ExitCode)" -ForegroundColor Red
            Write-Log  "Falha na instalação do Git Bash. Código: $($process.ExitCode)" "ERROR"
        }
        Remove-Item $installer -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "⚠️ Git Bash não encontrado. Instale manualmente em: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Log  "Git Bash não encontrado e auto-install-gitbash não informado." "WARN"
}

# -----------------------------------------------------------
# 📦 Copiar scripts e estrutura do projeto (subindo duas pastas)
# -----------------------------------------------------------
Write-Host "`n📦 Copiando scripts e estrutura completa do projeto..." -ForegroundColor Cyan

try {
    $projectRoot  = Join-Path $PSScriptRoot "..\.."
    $resolvedRoot = Resolve-Path $projectRoot

    Write-Log "Copiando a partir da raiz do projeto: $resolvedRoot"

    Copy-Item "$resolvedRoot\*" $TargetDir -Recurse -Force
    Write-Host "✅ Cópia concluída a partir de: $resolvedRoot" -ForegroundColor Green
    Write-Log  "Cópia concluída a partir de: $resolvedRoot" "INFO"
} catch {
    Write-Host "❌ Falha ao copiar arquivos: $($_.Exception.Message)" -ForegroundColor Red
    Write-Log  "Falha ao copiar arquivos: $($_.Exception.Message)" "ERROR"
    exit 1
}

# -----------------------------------------------------------
# 🔗 Configurar aliases no Git Bash
# -----------------------------------------------------------
if ($gitbashPresent) {
    Write-Host "`n🔗 Configurando aliases no Git Bash (~/.bashrc)..." -ForegroundColor Cyan
    Write-Log  "Configurando aliases no .bashrc."

    $bashrc  = Join-Path $UserProfile ".bashrc"
    $content = @()
    if (Test-Path $bashrc) {
        $content = Get-Content $bashrc -ErrorAction SilentlyContinue
    }

    # Remove aliases antigos
    $filtered = $content | Where-Object {
        $_ -notmatch "CopyToGDriver" -and
        $_ -notmatch "copydrive"    -and
        $_ -notmatch "copycheck"    -and
        $_ -notmatch "copyrestore"
    }

    # Caminho no formato /c/...
    $bashPath = $TargetDir -replace "\\", "/" -replace "C:", "/c"

    $bashrcNew = @()
    $bashrcNew += $filtered
    $bashrcNew += ""
    $bashrcNew += "# === CopyToGDriver Aliases ==="
    $bashrcNew += "alias copydrive='$bashPath/CopyToGDriver_CopyCurrent.sh'"
    $bashrcNew += "alias copycheck='$bashPath/CopyToGDriver.sh --check-only'"
    $bashrcNew += "alias copyrestore='$bashPath/CopyToGDriver_Restore.sh'"
    $bashrcNew += "export COPYTOGDRIVER_PATH='$bashPath'"

    $bashrcNew | Out-File $bashrc -Encoding utf8 -Force

    try {
        & dos2unix $bashrc | Out-Null
    } catch {
        # se não tiver dos2unix, segue a vida
    }

    try {
        bash -lc "source ~/.bashrc" | Out-Null
    } catch {
        # se der erro ao fazer source, não é crítico
    }

    Write-Host "🔗 Aliases adicionados e ativados em ~/.bashrc" -ForegroundColor Green
    Write-Log  "Aliases configurados no .bashrc." "INFO"
}

# -----------------------------------------------------------
# 📋 Adicionar ao menu de contexto do Windows (botão direito)
# -----------------------------------------------------------
Write-Host "`n🖱️ Adicionando entrada ao menu de contexto do Windows..." -ForegroundColor Cyan

try {
    $menuKey    = "HKCU:\Software\Classes\*\shell\CopyToGDriver"
    $commandKey = "$menuKey\command"

    if (-not (Test-Path $menuKey))    { New-Item -Path $menuKey    -Force | Out-Null }
    if (-not (Test-Path $commandKey)) { New-Item -Path $commandKey -Force | Out-Null }

    Set-ItemProperty -Path $menuKey    -Name "(Default)" -Value "Send to Google Drive" -Force
    Set-ItemProperty -Path $commandKey -Name "(Default)" -Value "`"$TargetDir\CopyToGDriver.sh`" `"%1`"" -Force

    Write-Host "✅ Entrada 'Send to Google Drive' adicionada ao menu de contexto." -ForegroundColor Green
    Write-Log  "Entrada de menu de contexto adicionada." "INFO"
} catch {
    Write-Host "❌ Falha ao adicionar entrada no menu de contexto: $($_.Exception.Message)" -ForegroundColor Red
    Write-Log  "Falha ao adicionar menu de contexto: $($_.Exception.Message)" "ERROR"
}

# -----------------------------------------------------------
# 🧾 Registro da instalação
# -----------------------------------------------------------
$rcloneAvailable = (Get-Command rclone.exe -ErrorAction SilentlyContinue) -ne $null

$installInfo = @{
    installed_on           = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    path                   = $TargetDir
    user                   = $env:USERNAME
    rclone_installed       = $rcloneAvailable
    gitbash_installed      = $gitbashPresent
    rclone_auto_installed  = $rcloneInstalledByScript
    gitbash_auto_installed = $gitbashInstalled
    remote_auto_configured = (Test-Parameter "auto-config-remote")
}

$installInfo | ConvertTo-Json | Out-File $RecordFile -Encoding UTF8
Write-Host "🧾 Registro de instalação criado: $RecordFile" -ForegroundColor Green
Write-Log  "Registro de instalação salvo em $RecordFile." "INFO"

# -----------------------------------------------------------
# ✅ Finalização
# -----------------------------------------------------------
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "✅ Instalação concluída com sucesso!" -ForegroundColor Green
Write-Host "📂 Local: $TargetDir" -ForegroundColor Cyan
Write-Host "📦 Caminho salvo em: $InstallPathFile" -ForegroundColor Cyan
if ($rcloneInstalledByScript) { Write-Host "🔧 rclone instalado pelo script." -ForegroundColor Cyan }
if ($gitbashPresent)          { Write-Host "🧩 Git Bash disponível." -ForegroundColor Cyan }
Write-Host "📄 Log: $LogFile" -ForegroundColor Cyan
if (Test-Parameter "auto-config-remote") {
    Write-Host "🌐 Remote 'gdriver' configurado e autenticado (OAuth)." -ForegroundColor Cyan
} else {
    Write-Host "⚠️ Remote 'gdriver' NÃO foi configurado aqui (sem --auto-config-remote)." -ForegroundColor Yellow
}
Write-Host "======================================================" -ForegroundColor Cyan

exit 0

# ===========================================================
# Projeto: CopyToGDriver
# Script: CopyToGDriver_Installer.ps1 (v2.2.3)
# Função: Instalador automatizado completo (Windows - Git Bash)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

param(
    [string]$path,
    [string]$parameters = ""
)

# -----------------------------------------------------------
# 🧭 Cabeçalho
# -----------------------------------------------------------
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🚀 Instalador CopyToGDriver (Windows v2.2.3)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------
# Diretórios padrão e arquivos de controle
# -----------------------------------------------------------
$DefaultBase      = "C:\scripts"
$UserProfile      = [Environment]::GetFolderPath("UserProfile")
$ConfigDir        = Join-Path $UserProfile ".copytogdriver"
$RecordFile       = Join-Path $ConfigDir "install_record.json"
$LogFile          = Join-Path $ConfigDir "install_log.txt"
$InstallPathFile  = Join-Path $ConfigDir "install_path.txt"

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

# -----------------------------------------------------------
# 🧾 Função de log
# -----------------------------------------------------------
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
    Write-Host $line
}

Write-Log "==== Iniciando instalação CopyToGDriver v2.2.3 ====" "INFO"

# -----------------------------------------------------------
# 🔧 Processamento dos parâmetros extras (estilo --flag=valor)
# -----------------------------------------------------------
$ScriptParams = @{}

if ($parameters) {
    Write-Log "Parâmetros recebidos: $parameters"
    $paramArray = $parameters -split '\s+'
    foreach ($param in $paramArray) {
        if ($param -match '^--([^=]+)=(.+)$') {
            $ScriptParams[$Matches[1]] = $Matches[2]
        } elseif ($param -match '^--(.+)$') {
            $ScriptParams[$Matches[1]] = $true
        }
    }
}

function Test-Parameter {
    param([string]$Name)
    return $ScriptParams.ContainsKey($Name) -and $ScriptParams[$Name] -eq $true
}

# -----------------------------------------------------------
# 📁 Definir caminho de destino
# -----------------------------------------------------------
if ($path) {
    try {
        $Resolved  = Resolve-Path $path -ErrorAction Stop
        $TargetDir = $Resolved.Path
    } catch {
        $TargetDir = $path
    }
    Write-Host "📁 Caminho especificado pelo usuário: $TargetDir" -ForegroundColor Yellow
    Write-Log  "Caminho especificado pelo usuário: $TargetDir"
} else {
    $TargetDir = Join-Path $DefaultBase "CopyToGDriver"
    Write-Host "📁 Caminho padrão: $TargetDir" -ForegroundColor Yellow
    Write-Log  "Caminho padrão: $TargetDir"
}

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Log "Criado diretório de instalação: $TargetDir"
}

# 🔹 Registrar caminho de instalação
Set-Content -Path $InstallPathFile -Value $TargetDir -Encoding UTF8
Write-Host "📦 Caminho de instalação registrado em: $InstallPathFile" -ForegroundColor Green

# 🔹 Variável de ambiente
[Environment]::SetEnvironmentVariable("COPYTOGDRIVER_PATH", $TargetDir, "User")
Write-Host "🌍 Variável de ambiente 'COPYTOGDRIVER_PATH' configurada." -ForegroundColor Cyan

# -----------------------------------------------------------
# ⚙️ Função de download com progresso
# -----------------------------------------------------------
function Download-WithProgress {
    param(
        [string]$url,
        [string]$dest,
        [string]$label
    )

    $maxRetries   = 3
    $minSizeBytes = 1000000   # 1 MB só pra garantir que não baixou lixo

    for ($attempt = 1; $attempt -le $maxRetries; $attempt++) {
        try {
            Write-Host "⬇️ Baixando $label (tentativa $attempt de $maxRetries)..." -ForegroundColor Cyan
            Write-Log  "Baixando $label (tentativa $attempt)"

            if (Test-Path $dest) { Remove-Item $dest -Force }

            $request  = [System.Net.HttpWebRequest]::Create($url)
            $response = $request.GetResponse()
            $totalBytes = [int64]$response.ContentLength
            $stream  = $response.GetResponseStream()
            $outFile = [System.IO.File]::Create($dest)

            $buffer   = New-Object byte[] 8192
            $totalRead = 0
            $lastPercent = -1

            while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                $outFile.Write($buffer, 0, $read)
                $totalRead += $read

                if ($totalBytes -gt 0) {
                    $percent = [math]::Floor(($totalRead / $totalBytes) * 100)
                    if ($percent -ne $lastPercent) {
                        Write-Progress -Activity "Baixando $label" -Status "$percent% concluído" -PercentComplete $percent
                        $lastPercent = $percent
                    }
                }
            }

            $outFile.Close()
            $stream.Close()
            Write-Progress -Activity "Baixando $label" -Completed

            $size = (Get-Item $dest).Length
            if ($size -lt $minSizeBytes) {
                Write-Log "Tamanho muito pequeno ($size bytes). Tentando novamente..." "WARN"
                Start-Sleep 2
                continue
            }

            Write-Host "✅ Download concluído: $dest ($size bytes)" -ForegroundColor Green
            Write-Log  "Download OK: $label ($size bytes)" "INFO"
            return $true
        } catch {
            Write-Host "❌ Falha ao baixar ${label}: $($_.Exception.Message)" -ForegroundColor Red
            Write-Log  "Falha ao baixar ${label}: $($_.Exception.Message)" "ERROR"
            Start-Sleep 3
        }
    }

    Write-Host "🚫 Falha após $maxRetries tentativas para $label." -ForegroundColor Red
    Write-Log  "Falha definitiva no download de $label" "ERROR"
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
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    return $null
}

# -----------------------------------------------------------
# ⚙️ Instalar Rclone (opcional, mas recomendado)
# -----------------------------------------------------------
$rcloneInstalledByScript = $false

if (-not (Get-Command rclone.exe -ErrorAction SilentlyContinue)) {
    if (Test-Parameter "auto-install-rclone") {
        Write-Host "⚠️ rclone não encontrado. Instalando..." -ForegroundColor Yellow
        Write-Log  "rclone não encontrado. Iniciando instalação automática."

        $TempZip = Join-Path $env:TEMP "rclone.zip"
        $Url     = "https://downloads.rclone.org/rclone-current-windows-amd64.zip"

        if (Download-WithProgress $Url $TempZip "rclone") {
            Expand-Archive -Path $TempZip -DestinationPath $env:TEMP -Force
            Start-Sleep -Seconds 2
            $exe = Get-ChildItem -Path $env:TEMP -Filter "rclone.exe" -Recurse | Select-Object -First 1
            if ($exe) {
                Copy-Item $exe.FullName "C:\Windows\System32\" -Force
                Write-Host "✅ rclone instalado em C:\Windows\System32" -ForegroundColor Green
                Write-Log  "rclone instalado em C:\Windows\System32" "INFO"
                $rcloneInstalledByScript = $true
            } else {
                Write-Host "❌ Não foi encontrado rclone.exe após extração." -ForegroundColor Red
                Write-Log  "rclone.exe não encontrado após extração" "ERROR"
            }
            Remove-Item $TempZip -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "❌ Falha ao baixar rclone. Abortando instalação." -ForegroundColor Red
            Write-Log  "Falha ao baixar rclone. Instalação abortada." "ERROR"
            exit 1
        }
    } else {
        Write-Host "❌ rclone não encontrado e instalação automática não habilitada (--auto-install-rclone)." -ForegroundColor Red
        Write-Log  "rclone não encontrado e auto-install-rclone não informado. Abortando instalação." "ERROR"
        exit 1
    }
} else {
    Write-Host "✅ rclone já está instalado." -ForegroundColor Green
    Write-Log  "rclone já está instalado."
}

# -----------------------------------------------------------
# 🌐 Configurar e autenticar remote 'gdriver' (OAuth obrigatório, não bloqueante)
# -----------------------------------------------------------
if (Test-Parameter "auto-config-remote") {
    Write-Host "`n🔧 Configurando remote 'gdriver' no rclone (OAuth obrigatório)..." -ForegroundColor Cyan
    Write-Log  "Iniciando configuração do remote 'gdriver'."

    try {
        $existing = rclone listremotes 2>$null
        if ($existing -notmatch "^gdriver:") {
            Write-Host "⚙️ Criando remote 'gdriver' (tipo drive)..." -ForegroundColor Yellow
            Write-Log  "Criando remote 'gdriver' (drive)."
            & rclone config create gdriver drive scope=drive | Out-Null
        } else {
            Write-Host "✅ Remote 'gdriver' já existe." -ForegroundColor Green
            Write-Log  "Remote 'gdriver' já existe."
        }

        # 🔹 Fluxo OAuth obrigatório – abre navegador (não bloqueante)
        Write-Host "`n🌐 Iniciando autenticação no navegador (rclone authorize drive)..." -ForegroundColor Cyan
        Write-Host "🔑 Faça login com sua conta Google e autorize o acesso." -ForegroundColor Yellow
        Write-Host "   A instalação continuará automaticamente após a autenticação." -ForegroundColor Yellow
        Write-Log  "Executando rclone authorize drive (OAuth, não bloqueante)."

        try {
            # Executa o rclone authorize em background (sem bloquear)
            Start-Process -FilePath "rclone" -ArgumentList "authorize drive" -NoNewWindow -ErrorAction SilentlyContinue | Out-Null
        } catch {
            Write-Host "❌ Falha ao iniciar o navegador: $($_.Exception.Message)" -ForegroundColor Red
            Write-Log  "Erro ao iniciar navegador OAuth: $($_.Exception.Message)" "ERROR"
            exit 2
        }

        # 🔹 Loop de validação (aguarda até 2 minutos ou sucesso)
        $timeout   = [datetime]::Now.AddMinutes(2)
        $validated = $false

        Write-Host "`n⏳ Aguardando conclusão da autenticação (até 2 minutos)..." -ForegroundColor Cyan
        while (-not $validated -and [datetime]::Now -lt $timeout) {
            try {
                & rclone about gdriver: 2>$null | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    $validated = $true
                    break
                }
            } catch {}
            Start-Sleep -Seconds 5
        }

        if ($validated) {
            Write-Host "✅ Remote 'gdriver' autenticado com sucesso!" -ForegroundColor Green
            Write-Log  "Remote 'gdriver' autenticado com sucesso." "INFO"
        } else {
            Write-Host "❌ Timeout de autenticação atingido. O usuário não concluiu o login no navegador." -ForegroundColor Red
            Write-Log  "Falha de autenticação: timeout atingido." "ERROR"
            exit 2
        }
    } catch {
        Write-Host "❌ Erro ao configurar/autenticar o remote 'gdriver': $($_.Exception.Message)" -ForegroundColor Red
        Write-Log  "Erro ao configurar/autenticar 'gdriver': $($_.Exception.Message)" "ERROR"
        exit 2
    }
} else {
    Write-Host "⚠️ Aviso: --auto-config-remote NÃO informado. O remote 'gdriver' não será configurado aqui." -ForegroundColor Yellow
    Write-Log  "auto-config-remote não informado. Remote 'gdriver' não será criado/autenticado." "WARN"
}


# -----------------------------------------------------------
# 🧩 Verificar/instalar Git Bash
# -----------------------------------------------------------
Write-Host "`n🔍 Verificando Git Bash..." -ForegroundColor Cyan
Write-Log  "Verificando Git Bash."

$gitbashPresent  = $false
$gitbashInstalled = $false
$gitBashPath     = Get-GitBashPath

if (Get-Command bash.exe -ErrorAction SilentlyContinue) {
    Write-Host "✅ Git Bash já está no PATH." -ForegroundColor Green
    Write-Log  "Git Bash encontrado no PATH."
    $gitbashPresent = $true
} elseif ($gitBashPath) {
    Write-Host "⚠️ Git Bash encontrado em: $gitBashPath" -ForegroundColor Yellow
    Write-Log  "Git Bash encontrado em: $gitBashPath"
    $binDir = Split-Path $gitBashPath -Parent
    $env:Path += ";$binDir"
    [Environment]::SetEnvironmentVariable("Path", "$env:Path", "User")
    Write-Host "✅ Git Bash adicionado ao PATH." -ForegroundColor Green
    Write-Log  "Git Bash adicionado ao PATH."
    $gitbashPresent = $true
} elseif (Test-Parameter "auto-install-gitbash") {
    # Instalação automática de Git Bash (igual v2.2.2)
    Write-Host "⚠️ Git Bash não encontrado. Instalando automaticamente..." -ForegroundColor Yellow
    Write-Log  "Git Bash não encontrado. Iniciando instalação automática."

    $installer = Join-Path $env:TEMP "Git-Installer.exe"
    $urlGit    = "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe"

    if (Download-WithProgress $urlGit $installer "Git Bash") {
        $process = Start-Process -FilePath $installer -ArgumentList @("/VERYSILENT", "/NORESTART", "/NOCANCEL") -Wait -PassThru
        Start-Sleep -Seconds 10
        if ($process.ExitCode -eq 0) {
            Write-Host "✅ Git Bash instalado com sucesso." -ForegroundColor Green
            Write-Log  "Git Bash instalado com sucesso." "INFO"
            $gitbashPresent   = $true
            $gitbashInstalled = $true
        } else {
            Write-Host "❌ Falha ao instalar Git Bash. Código: $($process.ExitCode)" -ForegroundColor Red
            Write-Log  "Falha na instalação do Git Bash. Código: $($process.ExitCode)" "ERROR"
        }
        Remove-Item $installer -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "⚠️ Git Bash não encontrado. Instale manualmente em: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Log  "Git Bash não encontrado e auto-install-gitbash não informado." "WARN"
}

# -----------------------------------------------------------
# 📦 Copiar scripts e estrutura do projeto (subindo duas pastas)
# -----------------------------------------------------------
Write-Host "`n📦 Copiando scripts e estrutura completa do projeto..." -ForegroundColor Cyan

try {
    $projectRoot  = Join-Path $PSScriptRoot "..\.."
    $resolvedRoot = Resolve-Path $projectRoot

    Write-Log "Copiando a partir da raiz do projeto: $resolvedRoot"

    Copy-Item "$resolvedRoot\*" $TargetDir -Recurse -Force
    Write-Host "✅ Cópia concluída a partir de: $resolvedRoot" -ForegroundColor Green
    Write-Log  "Cópia concluída a partir de: $resolvedRoot" "INFO"
} catch {
    Write-Host "❌ Falha ao copiar arquivos: $($_.Exception.Message)" -ForegroundColor Red
    Write-Log  "Falha ao copiar arquivos: $($_.Exception.Message)" "ERROR"
    exit 1
}

# -----------------------------------------------------------
# 🔗 Configurar aliases no Git Bash
# -----------------------------------------------------------
if ($gitbashPresent) {
    Write-Host "`n🔗 Configurando aliases no Git Bash (~/.bashrc)..." -ForegroundColor Cyan
    Write-Log  "Configurando aliases no .bashrc."

    $bashrc  = Join-Path $UserProfile ".bashrc"
    $content = @()
    if (Test-Path $bashrc) {
        $content = Get-Content $bashrc -ErrorAction SilentlyContinue
    }

    # Remove aliases antigos
    $filtered = $content | Where-Object {
        $_ -notmatch "CopyToGDriver" -and
        $_ -notmatch "copydrive"    -and
        $_ -notmatch "copycheck"    -and
        $_ -notmatch "copyrestore"
    }

    # Caminho no formato /c/...
    $bashPath = $TargetDir -replace "\\", "/" -replace "C:", "/c"

    $bashrcNew = @()
    $bashrcNew += $filtered
    $bashrcNew += ""
    $bashrcNew += "# === CopyToGDriver Aliases ==="
    $bashrcNew += "alias copydrive='$bashPath/CopyToGDriver_CopyCurrent.sh'"
    $bashrcNew += "alias copycheck='$bashPath/CopyToGDriver.sh --check-only'"
    $bashrcNew += "alias copyrestore='$bashPath/CopyToGDriver_Restore.sh'"
    $bashrcNew += "export COPYTOGDRIVER_PATH='$bashPath'"

    $bashrcNew | Out-File $bashrc -Encoding utf8 -Force

    try {
        & dos2unix $bashrc | Out-Null
    } catch {
        # se não tiver dos2unix, segue a vida
    }

    try {
        bash -lc "source ~/.bashrc" | Out-Null
    } catch {
        # se der erro ao fazer source, não é crítico
    }

    Write-Host "🔗 Aliases adicionados e ativados em ~/.bashrc" -ForegroundColor Green
    Write-Log  "Aliases configurados no .bashrc." "INFO"
}

# -----------------------------------------------------------
# 📋 Adicionar ao menu de contexto do Windows (botão direito)
# -----------------------------------------------------------
Write-Host "`n🖱️ Adicionando entrada ao menu de contexto do Windows..." -ForegroundColor Cyan

try {
    $menuKey    = "HKCU:\Software\Classes\*\shell\CopyToGDriver"
    $commandKey = "$menuKey\command"

    if (-not (Test-Path $menuKey))    { New-Item -Path $menuKey    -Force | Out-Null }
    if (-not (Test-Path $commandKey)) { New-Item -Path $commandKey -Force | Out-Null }

    Set-ItemProperty -Path $menuKey    -Name "(Default)" -Value "Send to Google Drive" -Force
    Set-ItemProperty -Path $commandKey -Name "(Default)" -Value "`"$TargetDir\CopyToGDriver.sh`" `"%1`"" -Force

    Write-Host "✅ Entrada 'Send to Google Drive' adicionada ao menu de contexto." -ForegroundColor Green
    Write-Log  "Entrada de menu de contexto adicionada." "INFO"
} catch {
    Write-Host "❌ Falha ao adicionar entrada no menu de contexto: $($_.Exception.Message)" -ForegroundColor Red
    Write-Log  "Falha ao adicionar menu de contexto: $($_.Exception.Message)" "ERROR"
}

# -----------------------------------------------------------
# 🧾 Registro da instalação
# -----------------------------------------------------------
$rcloneAvailable = (Get-Command rclone.exe -ErrorAction SilentlyContinue) -ne $null

$installInfo = @{
    installed_on           = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    path                   = $TargetDir
    user                   = $env:USERNAME
    rclone_installed       = $rcloneAvailable
    gitbash_installed      = $gitbashPresent
    rclone_auto_installed  = $rcloneInstalledByScript
    gitbash_auto_installed = $gitbashInstalled
    remote_auto_configured = (Test-Parameter "auto-config-remote")
}

$installInfo | ConvertTo-Json | Out-File $RecordFile -Encoding UTF8
Write-Host "🧾 Registro de instalação criado: $RecordFile" -ForegroundColor Green
Write-Log  "Registro de instalação salvo em $RecordFile." "INFO"

# -----------------------------------------------------------
# ✅ Finalização
# -----------------------------------------------------------
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "✅ Instalação concluída com sucesso!" -ForegroundColor Green
Write-Host "📂 Local: $TargetDir" -ForegroundColor Cyan
Write-Host "📦 Caminho salvo em: $InstallPathFile" -ForegroundColor Cyan
if ($rcloneInstalledByScript) { Write-Host "🔧 rclone instalado pelo script." -ForegroundColor Cyan }
if ($gitbashPresent)          { Write-Host "🧩 Git Bash disponível." -ForegroundColor Cyan }
Write-Host "📄 Log: $LogFile" -ForegroundColor Cyan
if (Test-Parameter "auto-config-remote") {
    Write-Host "🌐 Remote 'gdriver' configurado e autenticado (OAuth)." -ForegroundColor Cyan
} else {
    Write-Host "⚠️ Remote 'gdriver' NÃO foi configurado aqui (sem --auto-config-remote)." -ForegroundColor Yellow
}
Write-Host "======================================================" -ForegroundColor Cyan

exit 0


