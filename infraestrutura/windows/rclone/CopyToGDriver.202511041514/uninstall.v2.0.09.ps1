<#
  Desinstalador CopyToGDriver para Windows
  Autor: Paulo SSPacheco + ChatGPT (GPT-5)
  Versão: 2.0.9
  Recursos:
    ✅ Remove pasta de instalação
    ✅ Remove rclone se:
         - tiver sido instalado pelo script, OU
         - usuário pedir explicitamente na falta de registro
    ✅ Remove aliases do Git Bash
    ✅ Limpa diretório .copytogdriver (opcional, sem quebrar log)
#>

param(
    [switch]$silent,
    [switch]$s,
    [switch]$forceRclone  # opcional: força remoção do rclone mesmo se não houver registro
)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "🧹 Desinstalador CopyToGDriver (Windows v2.0.9)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# -----------------------------------------------------------
# 🔧 Ambiente e log
# -----------------------------------------------------------
$UserProfile = [Environment]::GetFolderPath("UserProfile")
$ConfigDir   = Join-Path $UserProfile ".copytogdriver"
$LogFile     = Join-Path $ConfigDir "uninstall_log.txt"

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    try {
        if (-not (Test-Path $ConfigDir)) {
            New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
        }
        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        $line = "[$timestamp] [$Level] $Message"
        Add-Content -Path $LogFile -Value $line
    } catch {
        # Se não conseguir logar, ignora silenciosamente
    }
}

Write-Log "==== Iniciando desinstalação CopyToGDriver v2.0.9 ====" "INFO"

# -----------------------------------------------------------
# 📖 Ler registro da instalação (se existir)
# -----------------------------------------------------------
$RecordFile = Join-Path $ConfigDir "install_record.json"
$InstallDir = "C:\scripts\CopyToGDriver"
$rcloneInstalledByScript = $false
$hasRecord = $false

if (Test-Path $RecordFile) {
    try {
        $record = Get-Content $RecordFile | ConvertFrom-Json
        if ($record.path) { $InstallDir = $record.path }
        if ($record.rclone_installed_by_script -eq $true) { $rcloneInstalledByScript = $true }
        $hasRecord = $true
        Write-Host "📄 Registro de instalação lido." -ForegroundColor Cyan
        Write-Log  "Registro de instalação carregado de $RecordFile" "INFO"
    } catch {
        Write-Host "⚠️ Falha ao ler registro de instalação." -ForegroundColor Yellow
        Write-Log  "Falha ao ler registro de instalação: $($_.Exception.Message)" "WARN"
    }
} else {
    Write-Host "⚠️ Nenhum registro de instalação encontrado." -ForegroundColor Yellow
    Write-Log  "Nenhum install_record.json encontrado." "WARN"
}

Write-Host "📁 Pasta de instalação: $InstallDir" -ForegroundColor Yellow
Write-Log  "Pasta de instalação detectada: $InstallDir" "INFO"

# -----------------------------------------------------------
# ❓ Confirmação
# -----------------------------------------------------------
if (-not ($silent -or $s)) {
    $confirm = Read-Host "Remover o CopyToGDriver de '$InstallDir'? (s/N)"
    if ($confirm -ne "s" -and $confirm -ne "S") {
        Write-Host "❎ Desinstalação cancelada pelo usuário." -ForegroundColor Yellow
        Write-Log  "Desinstalação cancelada pelo usuário." "INFO"
        exit 0
    }
} else {
    Write-Host "⚙️ Modo silencioso ativo — nenhuma confirmação será pedida." -ForegroundColor Yellow
    Write-Log  "Modo silencioso ativo." "INFO"
}

# -----------------------------------------------------------
# 🛑 Encerrar rclone se ativo
# -----------------------------------------------------------
Write-Host "🛑 Encerrando rclone..." -ForegroundColor Cyan
Write-Log  "Tentando encerrar processos rclone.exe" "INFO"
try {
    taskkill /f /im rclone.exe 2>$null | Out-Null
    Write-Host "✅ Nenhum processo ativo." -ForegroundColor Green
    Write-Log  "Nenhum processo rclone ativo após tentativa de encerramento." "INFO"
} catch {
    Write-Host "⚠️ Erro ao encerrar rclone." -ForegroundColor Yellow
    Write-Log  "Erro ao encerrar rclone: $($_.Exception.Message)" "WARN"
}

# -----------------------------------------------------------
# 🧹 Remover pasta do projeto
# -----------------------------------------------------------
if (Test-Path $InstallDir) {
    try {
        Remove-Item -Recurse -Force -Path $InstallDir
        Write-Host "✅ Pasta removida: $InstallDir" -ForegroundColor Green
        Write-Log  "Pasta de instalação removida: $InstallDir" "INFO"
    } catch {
        Write-Host "❌ Falha ao remover $InstallDir" -ForegroundColor Red
        Write-Log  ("Falha ao remover pasta de instalação " + $InstallDir + " - " + $_.Exception.Message) "ERROR"
    }
} else {
    Write-Host "ℹ️ Pasta de instalação não encontrada." -ForegroundColor Yellow
    Write-Log  "Pasta de instalação não encontrada: $InstallDir" "WARN"
}

# -----------------------------------------------------------
# ⚙️ Remover rclone se apropriado
# -----------------------------------------------------------
$RclonePath = "C:\Windows\System32\rclone.exe"

if ($rcloneInstalledByScript -and (Test-Path $RclonePath)) {
    try {
        Remove-Item $RclonePath -Force
        Write-Host "✅ rclone.exe removido (instalado pelo CopyToGDriver)" -ForegroundColor Green
        Write-Log  "rclone.exe removido (instalado pelo script)." "INFO"
    } catch {
        Write-Host "⚠️ Não foi possível remover rclone.exe." -ForegroundColor Yellow
        Write-Log  ("Falha ao remover rclone.exe - " + $_.Exception.Message) "ERROR"
    }
} elseif ((-not $hasRecord) -and (Test-Path $RclonePath)) {
    # Caso especial: sem registro, mas rclone está presente
    if ($forceRclone) {
        try {
            Remove-Item $RclonePath -Force
            Write-Host "✅ rclone.exe removido (remoção forçada sem registro)." -ForegroundColor Green
            Write-Log  "rclone.exe removido com -forceRclone sem registro." "INFO"
        } catch {
            Write-Host "⚠️ Não foi possível remover rclone.exe (modo forçado)." -ForegroundColor Yellow
            Write-Log  ("Falha ao remover rclone.exe em modo forçado - " + $_.Exception.Message) "ERROR"
        }
    } elseif (-not ($silent -or $s)) {
        $ans = Read-Host "rclone.exe foi encontrado em '$RclonePath', mas não há registro. Deseja removê-lo mesmo assim? (s/N)"
        if ($ans -eq "s" -or $ans -eq "S") {
            try {
                Remove-Item $RclonePath -Force
                Write-Host "✅ rclone.exe removido conforme solicitado." -ForegroundColor Green
                Write-Log  "rclone.exe removido por solicitação do usuário (sem registro)." "INFO"
            } catch {
                Write-Host "⚠️ Não foi possível remover rclone.exe." -ForegroundColor Yellow
                Write-Log  ("Falha ao remover rclone.exe por solicitação do usuário - " + $_.Exception.Message) "ERROR"
            }
        } else {
            Write-Host "ℹ️ Mantendo rclone existente." -ForegroundColor Yellow
            Write-Log  "Usuário optou por manter rclone.exe (sem registro)." "INFO"
        }
    } else {
        Write-Host "ℹ️ Mantendo rclone existente (sem registro e modo silencioso)." -ForegroundColor Yellow
        Write-Log  "rclone.exe mantido (sem registro e modo silencioso)." "INFO"
    }
} else {
    Write-Host "ℹ️ Mantendo rclone existente." -ForegroundColor Yellow
    Write-Log  "rclone.exe mantido (não marcado como instalado pelo script)." "INFO"
}

# -----------------------------------------------------------
# 🧩 Remover aliases do Git Bash (~/.bashrc)
# -----------------------------------------------------------
$BashRc = Join-Path $UserProfile ".bashrc"
if (Test-Path $BashRc) {
    try {
        $content = Get-Content $BashRc -Raw
        $pattern = "(?s)# === CopyToGDriver Aliases \(Windows\) START .*? # === CopyToGDriver Aliases \(Windows\) END\s*"
        $newContent = [regex]::Replace($content, $pattern, "")
        if ($newContent -ne $content) {
            $newContent | Set-Content $BashRc -Encoding UTF8
            Write-Host "🧩 Aliases do CopyToGDriver removidos do .bashrc" -ForegroundColor Green
            Write-Log  "Bloco de aliases removido de ~/.bashrc" "INFO"
        } else {
            Write-Log  "Nenhum bloco de aliases CopyToGDriver encontrado em ~/.bashrc" "INFO"
        }
    } catch {
        Write-Host "⚠️ Não foi possível editar ~/.bashrc." -ForegroundColor Yellow
        Write-Log  ("Falha ao editar ~/.bashrc - " + $_.Exception.Message) "WARN"
    }
}

# -----------------------------------------------------------
# 🧾 Remover arquivos de configuração
# -----------------------------------------------------------
if (Test-Path $RecordFile) {
    Remove-Item $RecordFile -Force
    Write-Host "🧾 Registro de instalação removido." -ForegroundColor Green
    Write-Log  "install_record.json removido." "INFO"
}

# Aqui ainda NÃO removo o diretório, para poder logar até o final.
Write-Log  "Desinstalação concluída." "INFO"

# Agora sim: tentar remover diretório de configuração, se estiver vazio
try {
    if (Test-Path $ConfigDir) {
        $remaining = Get-ChildItem $ConfigDir -Recurse -Force | Measure-Object
        if ($remaining.Count -eq 1 -and (Test-Path $LogFile)) {
            # Só o log existe — se quiser ZERO vestígios, descomente a linha abaixo:
            # Remove-Item $LogFile -Force
            # e depois removemos o diretório:
            # Remove-Item $ConfigDir -Force -Recurse
            # Por enquanto, vamos manter o log.
        } elseif ($remaining.Count -eq 0) {
            Remove-Item $ConfigDir -Force
        }
    }
} catch {
    # silencioso
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "✅ Desinstalação concluída!" -ForegroundColor Green
if (Test-Path $LogFile) {
    Write-Host "📄 Log: $LogFile" -ForegroundColor Cyan
} else {
    Write-Host "📄 Log removido (sem vestígios persistentes)." -ForegroundColor Cyan
}
Write-Host "======================================================" -ForegroundColor Cyan
