# 🚀 CopyToGDriver Installer v2.2.4 (Windows - Git Bash)
---

## 📘 Descrição Geral
O script **`CopyToGDriver_Installer.ps1` (v2.2.4)** é o instalador completo e automatizado do sistema **CopyToGDriver** para **Windows com Git Bash**.  
Esta versão implementa a nova convenção de instalação baseada em **`~/scripts`** (equivalente a `$env:USERPROFILE/scripts`), garantindo compatibilidade total entre Windows, Git Bash e WSL.

O instalador configura automaticamente o ambiente, cria aliases, instala o Rclone e o Git Bash (se necessário), além de registrar todas as informações da instalação em arquivos de log.

---

## 🧩 Estrutura e Fluxo do Script

### 1️⃣ Cabeçalho e Inicialização
O cabeçalho exibe informações da versão e define diretórios principais:
```powershell
$UserProfile = [Environment]::GetFolderPath("UserProfile")
$DefaultBase = Join-Path $UserProfile "scripts"
$ConfigDir = Join-Path $UserProfile ".copytogdriver"
$RecordFile = Join-Path $ConfigDir "install_record.json"
$LogFile = Join-Path $ConfigDir "install_log.txt"
$InstallPathFile = Join-Path $ConfigDir "install_path.txt"
```
> 🆕 **Alteração importante:** o instalador deixa de usar `C:\scripts` e passa a utilizar `~/scripts`, mantendo a coerência com sistemas Unix-like.

---

### 2️⃣ Função de Log
Todas as ações são registradas no arquivo `install_log.txt`:
```powershell
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
}
```

---

### 3️⃣ Processamento de Parâmetros
Suporte para parâmetros no formato `--flag` e `--chave=valor`, exemplo:
```powershell
CopyToGDriver_Installer.ps1 --auto-install-rclone --auto-config-remote
```
Esses parâmetros permitem automatizar o processo sem interação manual.

---

### 4️⃣ Definição do Caminho de Instalação
Determina o destino de instalação — personalizado ou padrão:
```powershell
$TargetDir = Join-Path $DefaultBase "CopyToGDriver"
```
Caso o diretório não exista, ele é criado automaticamente e registrado em `install_path.txt`.

---

### 5️⃣ Variável de Ambiente
A variável global é configurada para referência futura:
```powershell
[Environment]::SetEnvironmentVariable("COPYTOGDRIVER_PATH", $TargetDir, "User")
```

---

### 6️⃣ Download com Progresso
A função `Download-WithProgress` exibe progresso percentual e tamanho do download, com verificação mínima de integridade (>1MB).

---

### 7️⃣ Instalação do Rclone
Se o Rclone não estiver instalado, o script o baixa e instala automaticamente (opcional via `--auto-install-rclone`):
```powershell
Copy-Item $exe.FullName "C:\Windows\System32\" -Force
```
O status da instalação é registrado e usado na desinstalação futura.

---

### 8️⃣ Configuração do Remote `gdriver`
Cria e autentica automaticamente um **remote Rclone** chamado `gdriver` usando OAuth2.  
A autenticação ocorre no navegador e é validada por até 2 minutos.

---

### 9️⃣ Instalação ou Verificação do Git Bash
Detecta o Git Bash no sistema, adiciona ao PATH se necessário, e realiza instalação automática se usado o parâmetro:
```powershell
--auto-install-gitbash
```
Inclui integração com o `.bashrc` e conversão para formato UNIX (`dos2unix`).

---

### 🔗 Configuração de Aliases no Git Bash
Cria os comandos globais no shell:
```bash
alias copydrive='$COPYTOGDRIVER_PATH/CopyToGDriver_CopyCurrent.sh'
alias copycheck='$COPYTOGDRIVER_PATH/CopyToGDriver.sh --check-only'
alias copyrestore='$COPYTOGDRIVER_PATH/CopyToGDriver_Restore.sh'
```
Esses aliases são adicionados automaticamente ao `~/.bashrc`.

---

### 🖱️ Integração com o Menu de Contexto do Windows
Cria um atalho “Send to Google Drive” no **menu do Explorer**, executando o script principal via Git Bash.

---

### 🧾 Registro da Instalação
Salva as informações no arquivo `install_record.json`:
```json
{
  "installed_on": "2025-11-07 15:00:00",
  "path": "C:/Users/<user>/scripts/CopyToGDriver",
  "rclone_installed": true,
  "gitbash_installed": true,
  "remote_auto_configured": true
}
```

---

### ✅ Finalização
Exibe um resumo com informações essenciais:
```
✅ Instalação concluída com sucesso!
📂 Local: C:/Users/<user>/scripts/CopyToGDriver
📄 Log:   C:/Users/<user>/.copytogdriver/install_log.txt
🌐 Remote 'gdriver' configurado e autenticado (OAuth)
```

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

## 🧠 Benefícios da Nova Estrutura

| Benefício | Descrição |
|------------|------------|
| 🔄 Multiplataforma real | Compatível com Windows, Git Bash e WSL. |
| 🧩 Sem dependência de drive fixo | Usa o diretório do usuário (`%USERPROFILE%`). |
| 🔐 Sem privilégios administrativos | Instala no escopo do usuário. |
| 🧹 Organização consistente | Padrão unificado com módulos `.sh` do CopyToGDriver. |

---

## 📦 Conclusão
O **`CopyToGDriver_Installer.ps1 v2.2.4`** é um instalador totalmente revisado e seguro, com suporte a execução autônoma, integração Git Bash, e nova estrutura baseada em `~/scripts`.  
Ele garante a instalação limpa, confiável e reproduzível do ambiente CopyToGDriver no Windows.

---
**Autor:** Paulo SSPacheco + ChatGPT (GPT-5)  
**Versão documentada:** 2.2.4  
**Plataforma alvo:** Windows + Git Bash  
**Compatibilidade:** PowerShell 5+ e Git Bash 2.4+
