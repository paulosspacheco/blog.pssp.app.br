# 🧩 CopyToGDriver_Installer v0.6.0 — Documentação Técnica

## 📘 Sumário

Script instalador do sistema **CopyToGDriver**, responsável por configurar o ambiente de sincronização local com o **Google Drive** via **Rclone**.

Compatível com:

* Execução **manual via terminal (CLI)**
* Execução **automatizada via GUI Free Pascal/Lazarus**

---

## 🧱 Estrutura do Script

| Seção                     | Descrição                                                                      |
| ------------------------- | ------------------------------------------------------------------------------ |
| 🛡️ Proteção CRLF           | Remove quebras de linha do Windows (garante portabilidade Linux/macOS).        |
| 🧭 Parser de Parâmetros   | Interpreta os argumentos enviados pelo instalador Lazarus ou linha de comando. |
| 📦 Instalação Rclone      | Instala o Rclone caso não esteja presente.                                     |
| ⚙️ Configuração do Remote | Cria/configura o remote `gdriver` para acesso ao Google Drive.                 |
| 💽 Registro de Discos     | Detecta e registra volumes montados (ext4, ntfs, btrfs, etc.).                 |
| 📁 Instalação de Scripts  | Copia todos os módulos CopyToGDriver e define permissões de execução.          |
| 🔗 Aliases Globais        | Cria atalhos `copydrive`, `copycheck` e `copyrestore` no `.bashrc`.            |
| 🧩 Finalização            | Exibe resumo e instruções pós-instalação.                                      |

---

## ⚙️ Execução

### ▶️ **Modo Automático (via Lazarus)**

O instalador GUI monta automaticamente os parâmetros e executa:

```bash
bash CopyToGDriver_Installer.sh [opções]
```

### ▶️ **Modo Manual (terminal)**

Exemplo de instalação completa:

```bash
./CopyToGDriver_Installer.sh \
  --auto-install-rclone \
  --auto-config-remote \
  --transfers=4 \
  --retries=3 \
  --exclude="*.tmp,*.log" \
  --verbose
```

---

## 🧩 Parâmetros Disponíveis

| Parâmetro               | Descrição                                        | Exemplo                   | Geração (GUI Lazarus) |
| ----------------------- | ------------------------------------------------ | ------------------------- | --------------------- |
| `--help`, `-h`          | Exibe ajuda e sai                                | `--help`                  | n/a                   |
| `--check`               | Apenas verifica o ambiente atual                 | `--check`                 | (copycheck)           |
| `--dry-run`             | Simula a instalação sem alterações               | `--dry-run`               | `cbDryRun`            |
| `--reinstall`           | Força reinstalação limpa                         | `--reinstall`             | n/a                   |
| `--auto-install-rclone` | Instala Rclone automaticamente                   | `--auto-install-rclone`   | `cbAutoInstallRclone` |
| `--auto-config-remote`  | Cria e autentica o remote `gdriver`              | `--auto-config-remote`    | `cbAutoConfigRemote`  |
| `--force`               | Força sincronização mesmo com dados existentes   | `--force`                 | `cbForceSync`         |
| `--verbose`             | Habilita logs detalhados                         | `--verbose`               | `cbVerboseMode`       |
| `--skip-existing`       | Ignora arquivos já existentes                    | `--skip-existing`         | `cbSkipExisting`      |
| `--transfers=<N>`       | Define número de transferências simultâneas      | `--transfers=5`           | `seMaxTransfers`      |
| `--retries=<N>`         | Define número de tentativas de reconexão         | `--retries=3`             | `seRetryCount`        |
| `--exclude=<padrões>`   | Exclui padrões (ex: logs, temporários)           | `--exclude="*.tmp,*.log"` | `edtExcludePatterns`  |
| `--include=<padrões>`   | Inclui apenas arquivos que combinem com o padrão | `--include="*.cfg,*.sh"`  | `edtIncludePatterns`  |

---

## 🧪 Modos Especiais

### 🔍 **Check Mode**

Apenas valida o ambiente (sem alterar nada):

```bash
./CopyToGDriver_Installer.sh --check
```

**Saída esperada:**

```
🔍 Verificação de ambiente CopyToGDriver
✅ Rclone instalado
✅ Diretório de scripts: /home/user/scripts/CopyToGDriver
✅ Configuração Rclone: ~/.config/rclone/rclone.conf
✅ Registro de discos detectado
```

---

### 🧪 **Dry Run**

Executa a instalação de forma simulada:

```bash
./CopyToGDriver_Installer.sh --dry-run
```

Exibe todas as ações, mas **não altera o sistema**.

---

### ♻️ **Reinstalação Completa**

Remove instalações antigas e reinstala tudo:

```bash
./CopyToGDriver_Installer.sh --reinstall --auto-install-rclone
```

---

## 💻 Integração com Lazarus GUI

O formulário `SetupForm_u.pas` monta os parâmetros automaticamente com:

```pascal
ExecuteProcess('bash', [InstallScript, Parameters]);
```

onde `Parameters` é construído pela função `BuildScriptParameters`.

Exemplo de chamada gerada:

```bash
bash CopyToGDriver_Installer.sh \
  --auto-install-rclone \
  --auto-config-remote \
  --transfers=4 \
  --retries=3 \
  --verbose \
  --exclude="*.tmp,*.log"
```

---

## 📂 Estrutura de Instalação

Após a execução, os arquivos serão organizados da seguinte forma:

```
~/scripts/CopyToGDriver/
 ├─ CopyToGDriver.sh
 ├─ CopyToGDriver_CopyCurrent.sh
 ├─ CopyToGDriver_Restore.sh
 └─ includes/
     ├─ crossplatform/
     └─ linux/
```

Logs:

```
~/CopyToGDriver_Log/system/
```

Registro de discos:

```
~/.config/CopyToGDriver/disks_registry.conf
```

---

## 🔗 Aliases Criados

Adicionados automaticamente ao `~/.bashrc`:

| Alias         | Comando                         | Função                           |
| ------------- | ------------------------------- | -------------------------------- |
| `copydrive`   | `CopyToGDriver_CopyCurrent.sh`  | Sincroniza a pasta atual         |
| `copycheck`   | `CopyToGDriver.sh --check-only` | Verifica ambiente e dependências |
| `copyrestore` | `CopyToGDriver_Restore.sh`      | Restaura último backup da pasta  |

---

## 🧠 Dicas e Observações

* Execute com privilégios de **sudo** se for instalar o Rclone.
* O `--auto-config-remote` abrirá o navegador para autenticação Google.
* Pode ser invocado por **outros programas**, **scripts CI/CD** ou **instaladores gráficos**.
* Suporta **Linux** e **macOS** nativamente (Windows via Git Bash).

---

## 📜 Licença

Este script é fornecido sob a licença MIT, de uso livre e modificação mediante atribuição de crédito ao autor original.

---

## ✍️ Autor

**Paulo S. S. Pacheco** + **ChatGPT (GPT-5)**
📦 Versão 0.6.0 — Atualizado em novembro/2025
💬 “Feito para funcionar igual no terminal e no clique.”

---

