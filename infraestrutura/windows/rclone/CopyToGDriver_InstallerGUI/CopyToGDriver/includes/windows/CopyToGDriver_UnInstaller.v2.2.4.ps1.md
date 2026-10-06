# 🧹 CopyToGDriver UnInstaller v2.1.3 (Windows - Git Bash)
---

## 📘 Descrição Geral
O script **`CopyToGDriver_UnInstaller.ps1` (v2.1.3)** realiza a **remoção completa e segura** do sistema **CopyToGDriver** no Windows, mantendo compatibilidade com o **Git Bash**.  
Ele remove diretórios, aliases, variáveis de ambiente e arquivos de log, garantindo uma desinstalação limpa e segura.

Inclui suporte para **remoção condicional do Rclone**, **limpeza de registros de configuração** e restauração do `.bashrc`.

---

## 🧩 Estrutura e Fluxo Principal

### 1️⃣ Inicialização e Cabeçalho
Exibe um cabeçalho informativo e define diretórios principais com base no perfil do usuário:
```powershell
$UserProfile = [Environment]::GetFolderPath("UserProfile")
$ConfigDir   = Join-Path $UserProfile ".copytogdriver"
$RecordFile  = Join-Path $ConfigDir "install_record.json"
$PathFile    = Join-Path $ConfigDir "install_path.txt"
$LogFile     = Join-Path $ConfigDir "uninstall_log.txt"
```
> 🆕 **Alteração:** o caminho padrão agora usa o diretório `~/scripts` em vez de `C:\scripts`, tornando-o multiplataforma e mais seguro.

---

### 2️⃣ Função de Log
Registra todas as ações realizadas durante a desinstalação:
```powershell
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
}
```

---

### 3️⃣ Detecção do Diretório de Instalação
Detecta o local de instalação em múltiplas fontes (arquivo JSON, TXT ou padrão):
```powershell
$InstallDir = Join-Path $env:USERPROFILE "scripts\CopyToGDriver"
```
Essa abordagem substitui o caminho fixo `C:\scripts\CopyToGDriver` pelo equivalente ao home do usuário (`~/scripts/CopyToGDriver`).

---

### 4️⃣ Confirmação do Usuário
Solicita confirmação antes de remover os arquivos:
```powershell
$confirm = Read-Host "Remover o CopyToGDriver de '$InstallDir'? (s/N)"
if ($confirm -notmatch '^[sS]$') { exit }
```

---

### 5️⃣ Encerramento de Processos Rclone
Finaliza qualquer processo ativo do Rclone:
```powershell
Get-Process rclone -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Process -Id $_.Id -Force
}
```

---

### 6️⃣ Remoção do Diretório de Instalação
Apaga todos os arquivos e pastas do CopyToGDriver:
```powershell
Remove-Item -Recurse -Force -Path $InstallDir
```

---

### 7️⃣ Remoção Condicional do Rclone
Caso o Rclone tenha sido instalado pelo script, é removido automaticamente:
```powershell
if ($rcloneInstalledByScript) {
    Remove-Item -Force "C:\Windows\System32\rclone.exe"
}
```

---

### 8️⃣ Limpeza dos Aliases no Git Bash
Remove todos os aliases do CopyToGDriver no `~/.bashrc` e recarrega o shell:
```powershell
$bashrc = Join-Path $UserProfile ".bashrc"
$content = Get-Content $bashrc | Where-Object { $_ -notmatch "CopyToGDriver" }
$content | Out-File $bashrc -Encoding utf8 -Force
bash -lc "source ~/.bashrc" | Out-Null
```

---

### 9️⃣ Remoção de Registros e Variáveis
Elimina variáveis de ambiente e diretórios de configuração:
```powershell
[Environment]::SetEnvironmentVariable("COPYTOGDRIVER_PATH", $null, "User")
Remove-Item $ConfigDir -Recurse -Force -ErrorAction SilentlyContinue
```

---

### 🔚 Finalização
Ao término, o script informa o status e o caminho do log:
```powershell
Write-Host "✅ Desinstalação concluída!"
Write-Host "📄 Log: $LogFile"
```

---

## ⚙️ Parâmetros Suportados

O desinstalador aceita parâmetros simples para controle de comportamento.  
Eles devem ser passados após o nome do script, por exemplo:

```
CopyToGDriver_UnInstaller.ps1 [--opções]
```

### 🔹 Lista completa de parâmetros

| Parâmetro | Tipo | Descrição | Padrão |
|------------|------|------------|---------|
| `--force` | flag | Executa a desinstalação sem solicitar confirmação do usuário. | `false` |
| `--keep-rclone` | flag | Mantém o `rclone.exe` instalado, mesmo se tiver sido configurado pelo CopyToGDriver. | `false` |
| `--keep-config` | flag | Mantém a pasta `.copytogdriver` e os arquivos de log após a desinstalação. | `false` |
| `--silent` | flag | Executa a desinstalação em modo silencioso (sem prompts visuais). | `false` |

---

## 💡 Exemplos de Uso

### 🔸 Desinstalação padrão (interativa)
```powershell
CopyToGDriver_UnInstaller.ps1
```
Remove o CopyToGDriver, solicitando confirmação antes da exclusão.

---

### 🔸 Desinstalação silenciosa (sem prompts)
```powershell
CopyToGDriver_UnInstaller.ps1 --silent --force
```
Remove todos os arquivos e configurações automaticamente, sem pedir confirmação.

---

### 🔸 Desinstalação mantendo o Rclone
```powershell
CopyToGDriver_UnInstaller.ps1 --keep-rclone
```
Mantém o `rclone.exe` no sistema, útil se ele for usado por outros scripts.

---

### 🔸 Desinstalação mantendo logs e registros
```powershell
CopyToGDriver_UnInstaller.ps1 --keep-config
```
Preserva o diretório `.copytogdriver` com os logs e histórico da instalação.

---

## ⚙️ Ajuste Multiplataforma — Caminho Base
| Antes | Depois |
|--------|---------|
| `C:\scripts\CopyToGDriver` | `$env:USERPROFILE\scripts\CopyToGDriver` |

Equivalente no Git Bash:  
```
~/scripts/CopyToGDriver
```

---

## 🧠 Benefícios da Alteração

| Benefício | Descrição |
|------------|------------|
| 🔄 Multiplataforma real | Funciona em PowerShell e Git Bash sem alterações. |
| 🧩 Sem dependência de C: | Usa o home do usuário como base. |
| 🔐 Instalação e remoção sem privilégios administrativos | Mantém tudo no escopo do usuário. |
| 🧹 Padrão consistente | Mesmo diretório usado pelos scripts `.sh`. |

---

## 🧾 Conclusão
O **`CopyToGDriver_UnInstaller.ps1 v2.1.3`** agora segue o mesmo padrão do instalador revisado (baseado em `~/scripts`), garantindo consistência, segurança e total compatibilidade entre PowerShell e Git Bash.  
A nova versão documenta também todos os parâmetros suportados, permitindo uso interativo ou automatizado.

---
**Autor:** Paulo SSPacheco + ChatGPT (GPT-5)  
**Versão documentada:** 2.1.3  
**Plataforma alvo:** Windows + Git Bash
