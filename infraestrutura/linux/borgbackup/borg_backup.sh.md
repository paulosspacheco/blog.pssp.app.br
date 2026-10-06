# 🧩 Manual do Script `borg_backup.sh`

## 📘 Descrição Geral

O script **`borg_backup.sh`** executa **backups incrementais genéricos** utilizando o poderoso utilitário **BorgBackup**.  
Ele foi desenvolvido para uso doméstico e profissional, permitindo criar backups automáticos de pastas, projetos, máquinas virtuais ou qualquer outro diretório de forma **eficiente, incremental e compactada**.

---

## 🧠 Objetivo

- Automatizar **backups incrementais** com BorgBackup.
- Criar **repositórios organizados** por nome.
- Permitir backups **relativos** (sem caminhos absolutos).
- Suportar **criptografia opcional**.
- Compatível com **Debian/Ubuntu e Borg 1.x**.
- Parar máquinas virtuais **VirtualBox** antes do backup, se necessário.

---

## 🧩 Estrutura do Script

```bash
#!/bin/bash
# ======================================================
# Script: borg_backup.sh
# Objetivo: Executar backups incrementais genéricos usando BorgBackup
# Autor: Paulo SSPacheco
# ======================================================
````

O script define parâmetros de entrada, validações e funções para:

1. Verificar dependências.
2. Parar VMs em execução (se houver).
3. Criar e manter o repositório de backup.
4. Executar o backup incremental e aplicar política de retenção.

---

## ⚙️ Parâmetros de Execução

| Parâmetro    | Obrigatório | Descrição                                                                 |
| ------------ | ----------- | ------------------------------------------------------------------------- |
| `NOME`       | ✅           | Nome lógico do backup (ex: `scripts`, `documentos`, `vm-windows10`)       |
| `SRC`        | ✅           | Caminho de origem da pasta a ser copiada                                  |
| `DEST`       | ✅           | Caminho base onde os backups serão armazenados                            |
| `ENCRYPTION` | ❌           | Tipo de criptografia (`none`, `repokey`, `keyfile`, etc) – padrão: `none` |

---

## 🧰 Exemplo de Uso

### 🔹 Exemplo 1 — Backup de scripts pessoais

```bash
./borg_backup.sh scripts /home/paulo/scripts "/media/paulo/Novo volume/borg_backup" none
```

### 🔹 Exemplo 2 — Backup de uma máquina virtual

```bash
./borg_backup.sh "Windows 10 VM" /home/paulo/vms/windows10 "/media/paulo/hdexterno/borg_backup" repokey
```

### 🔹 Exemplo 3 — Automatização com Crontab

Para criar um backup diário às 23h:

```bash
0 23 * * * /home/paulo/scripts/borg_backup.sh scripts /home/paulo/scripts "/media/paulo/Novo volume/borg_backup" none >> /home/paulo/backup.log 2>&1
```

---

## 🧱 Estrutura do Repositório

Ao executar o backup, o script criará automaticamente:

```
<DEST>/<NOME>/borg-repo/
```

Exemplo:

```
/media/paulo/Novo volume/borg_backup/scripts/borg-repo
```

Cada execução gera um snapshot incremental:

```
backup-2025-10-30
backup-2025-10-31
backup-2025-11-01
...
```

---

## 🧩 Principais Funções

### 1️⃣ `check_dependencies()`

Verifica se o BorgBackup está instalado.
Caso não esteja, tenta instalá-lo automaticamente:

```bash
sudo apt update && sudo apt install -y borgbackup
```

---

### 2️⃣ `stop_vm()`

Se o nome do backup corresponder a uma VM do **VirtualBox**, o script irá tentar **desligá-la com segurança** antes do backup.

Fluxo:

* Tenta o desligamento com `acpipowerbutton`.
* Caso falhe, força o desligamento com `poweroff`.

---

### 3️⃣ `run_backup()`

Executa o processo completo de backup incremental:

* Cria o repositório (caso não exista).
* Cria snapshot incremental com:

  ```bash
  borg create --progress --stats "$REPO::backup-$(date +%F)" "$(basename "$SRC")"
  ```
* Mantém apenas os últimos backups:

  * **7 diários**
  * **4 semanais**
  * **3 mensais**

---

## 🧩 Política de Retenção

O script usa `borg prune` para limpar automaticamente backups antigos:

```bash
borg prune -v "$REPO" \
  --keep-daily=7 \
  --keep-weekly=4 \
  --keep-monthly=3
```

Essa política mantém o histórico mais recente sem ocupar muito espaço.

---

## 🧩 Criptografia

Por padrão, a criptografia está **desativada** (`none`).

Mas o Borg suporta diversos modos:

* `none` — sem criptografia.
* `repokey` — chave armazenada no repositório.
* `keyfile` — chave armazenada localmente.
* `authenticated` — dados verificados quanto à integridade.

💡 **Recomendação doméstica:**
Se o disco de backup for local e seguro, use `none`.
Se for remoto ou compartilhado, prefira `repokey`.

---

## ⚠️ Tratamento de Erros

O script verifica e trata situações comuns:

* Dependências ausentes (Borg não instalado).
* Disco de destino não montado.
* Falha ao inicializar repositório.
* Erro durante backup ou prune.

Em qualquer falha crítica, ele encerra com `exit 1`.

---

## 🧪 Teste Seguro (Simulação)

Antes de criar backups reais, você pode testar manualmente com o próprio Borg:

```bash
cd /home/paulo/scripts
borg create --dry-run --list /media/paulo/Novo\ volume/borg_backup/scripts/borg-repo::teste .
```

---

## 📊 Exemplo de Saída

Durante a execução, o script exibe informações como:

```
======================================================
💾 Backup genérico com BorgBackup
======================================================
Nome ...........: scripts
Origem .........: /home/paulo/scripts
Destino ........: /media/paulo/Novo volume/borg_backup
Repositório ....: /media/paulo/Novo volume/borg_backup/scripts/borg-repo
Criptografia ...: none
======================================================

📦 Criando repositório Borg em /media/paulo/Novo volume/borg_backup/scripts/borg-repo ...
💾 Iniciando backup incremental (modo relativo)...
🧹 Limpando backups antigos...
✅ Backup concluído com sucesso!
```

---

## 🧩 Compatibilidade

* **Sistema operacional:** Debian, Ubuntu, Mint, Pop!_OS
* **Versão do BorgBackup:** 1.1.x / 1.2.x
* **Shell:** Bash 5.x
* **Suporte a VirtualBox:** Sim (via `VBoxManage`)

---

## 🧱 Requisitos

| Requisito    | Descrição                                             |
| ------------ | ----------------------------------------------------- |
| `borgbackup` | Utilitário principal para backup incremental          |
| `VirtualBox` | Opcional, caso queira parar VMs durante backup        |
| `sudo`       | Necessário para instalação automática de dependências |

---

## 🔗 Referências

* 📘 **Site oficial do BorgBackup:**
  [https://www.borgbackup.org/](https://www.borgbackup.org/)

* 📖 **Documentação detalhada:**
  [https://borgbackup.readthedocs.io/en/stable/](https://borgbackup.readthedocs.io/en/stable/)

* 💡 **Manual do comando Borg (CLI):**

  ```bash
  man borg
  ```

* 💬 **Comunidade / Discussões:**
  [https://github.com/borgbackup/borg/discussions](https://github.com/borgbackup/borg/discussions)

---

## 🧾 Histórico de Versões

| Versão | Data       | Alterações                                                   |
| ------ | ---------- | ------------------------------------------------------------ |
| 1.0    | 2025-10-30 | Versão inicial                                               |
| 1.1    | 2025-10-31 | Backup relativo, prune automático e compatibilidade Borg 1.x |

---

## ✅ Autor

**Paulo SSPacheco**
💻 Automação e Infraestrutura Linux
📅 Outubro de 2025

---
