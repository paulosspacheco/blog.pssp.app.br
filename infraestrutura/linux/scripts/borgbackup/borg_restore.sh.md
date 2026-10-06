# ♻️ Manual do Script `borg_restore.sh`

## 📘 Descrição Geral

O script **`borg_restore.sh`** tem como objetivo **restaurar backups criados com o BorgBackup**, de forma simples, segura e compatível com o formato de repositórios criados pelo script `borg_backup.sh`.  

Ele permite listar snapshots disponíveis, executar **simulações de restauração** (modo *dry-run*) e recuperar os arquivos com estrutura limpa — sem incluir caminhos absolutos desnecessários.

---

## 🧠 Objetivo

- Restaurar backups criados pelo **BorgBackup**.
- Listar snapshots existentes antes da restauração.
- Permitir uma **simulação prévia (dry-run)**.
- Suportar **criptografia opcional**.
- Garantir compatibilidade com o **Borg 1.x (Debian/Ubuntu padrão)**.
- Restaurar conteúdo direto, removendo hierarquia absoluta (`--strip-components 3`).

---

## ⚙️ Parâmetros de Execução

| Parâmetro | Obrigatório | Descrição |
|------------|-------------|------------|
| `REPO` | ✅ | Caminho completo do repositório Borg (ex: `/media/paulo/hd/borg_backup/scripts/borg-repo`) |
| `DESTINO` | ✅ | Diretório onde os arquivos serão restaurados |
| `SNAPSHOT` | ❌ | Nome do snapshot (ex: `backup-2025-10-30`) |
| `ENCRYPTION` | ❌ | Tipo de criptografia (`none`, `repokey`, etc). Padrão: `none` |

---

## 🧰 Exemplo de Uso

### 🔹 Exemplo 1 — Restauração simples
```bash
./borg_restore.sh /media/paulo/borg_backup/scripts/borg-repo /home/paulo/scripts/restaurado
````

### 🔹 Exemplo 2 — Restaurar snapshot específico

```bash
./borg_restore.sh /media/paulo/borg_backup/scripts/borg-repo /home/paulo/scripts/restaurado backup-2025-10-30
```

### 🔹 Exemplo 3 — Restauração automatizada (sem perguntas)

```bash
echo "s" | ./borg_restore.sh /media/paulo/borg_backup/scripts/borg-repo /home/paulo/scripts/restaurado backup-2025-10-30
```

---

## 🧱 Estrutura do Script

```bash
#!/bin/bash
# ======================================================
# Script: borg_restore.sh
# Objetivo: Restaurar backups feitos com BorgBackup
# Autor: Paulo SSPacheco
# Compatível com Borg 1.x
# ======================================================
```

---

## 🧩 Principais Funções

### 1️⃣ `check_dependencies()`

Garante que o **BorgBackup** está instalado.
Caso não esteja, o script realiza a instalação automaticamente:

```bash
sudo apt update && sudo apt install -y borgbackup
```

---

### 2️⃣ `listar_snapshots()`

Lista todos os snapshots (backups) disponíveis no repositório informado:

```bash
borg list "$REPO"
```

Saída típica:

```
backup-2025-10-30    Thu, 2025-10-30 09:31:12 [c5d00a1cc5b...]
backup-2025-10-31    Fri, 2025-10-31 09:35:01 [a1f00e9e3cd...]
```

---

### 3️⃣ `escolher_snapshot()`

Se o usuário não especificar um snapshot, o script lista todos e pede que o operador escolha um manualmente.

Exemplo de prompt:

```
🔍 Nenhum snapshot especificado.
Abaixo estão os backups disponíveis:
📜 Listando backups disponíveis em: /media/paulo/borg_backup/scripts/borg-repo
backup-2025-10-30  Thu, 2025-10-30 09:31:12
Digite o nome do snapshot a restaurar (ex: backup-2025-10-30):
```

---

### 4️⃣ `dry_run_restore()`

Executa uma **simulação** de restauração sem alterar nada no disco.
Permite revisar o que será restaurado antes da execução real.

```bash
borg extract --dry-run --list --strip-components 3 "$REPO::$SNAPSHOT"
```

Se tudo estiver correto, o usuário confirma:

```
Deseja continuar com a restauração real? (s/n):
```

---

### 5️⃣ `real_restore()`

Executa a restauração real no diretório de destino.
Os arquivos são extraídos **sem incluir o caminho completo original**,
graças à opção `--strip-components 3`.

```bash
borg extract --progress --list --strip-components 3 "$REPO::$SNAPSHOT"
```

✅ Ao final, o script exibe:

```
✅ Restauração concluída com sucesso!
Arquivos restaurados em: /home/paulo/scripts/restaurado
```

---

## 🧩 Organização dos Arquivos Restaurados

Durante o backup, o Borg grava caminhos absolutos como:

```
home/paulosspacheco/scripts/arquivo1.sh
```

A opção `--strip-components 3` remove os três primeiros diretórios (`home`, `usuario`, `scripts`)
para restaurar apenas os arquivos desejados diretamente no destino.

Exemplo final:

```
/home/paulo/scripts/restaurado/
 ├── borg_backup.sh
 ├── borg_restore.sh
 └── outros_arquivos.sh
```

---

## 🧱 Estrutura do Repositório de Backup

O repositório é criado automaticamente pelo `borg_backup.sh` e segue o formato:

```
/media/paulo/Novo volume/borg_backup/
 └── scripts/
     └── borg-repo/
         ├── config
         ├── index.1234567890
         ├── data/
         └── integrity/
```

Cada execução de backup cria um snapshot incremental:

```
backup-2025-10-30
backup-2025-10-31
backup-2025-11-01
```

---

## ⚙️ Compatibilidade e Requisitos

| Requisito               | Descrição                         |
| ----------------------- | --------------------------------- |
| **Sistema Operacional** | Debian, Ubuntu, Mint, Pop!_OS     |
| **Versão BorgBackup**   | 1.1.x / 1.2.x                     |
| **Shell**               | Bash 5.x                          |
| **Dependências**        | `borgbackup`, `sudo`              |
| **Compatibilidade**     | Total com script `borg_backup.sh` |

---

## ⚠️ Cuidados Importantes

* **Verifique o ponto de montagem do disco externo** antes da restauração.
* **Evite restaurar sobre diretórios já existentes** (pode sobrescrever arquivos).
* Sempre revise o conteúdo da simulação (`--dry-run`) antes da restauração real.
* Caso use criptografia, mantenha as **chaves e senhas** seguras.

---

## 🧾 Fluxo Completo de Execução

```bash
check_dependencies   # Verifica Borg instalado
escolher_snapshot    # Seleciona snapshot (ou usa argumento)
dry_run_restore      # Simulação (dry-run)
real_restore         # Restauração real dos arquivos
```

---

## 🧩 Exemplo de Execução Real

```
======================================================
♻️  Restaurador genérico de backups BorgBackup
======================================================
Repositório ....: /media/paulo/Novo volume/borg_backup/scripts/borg-repo
Destino ........: /home/paulo/scripts/restaurado
Snapshot .......: backup-2025-10-30
Criptografia ...: none
======================================================

🧪 Etapa 1: Simulação (dry-run)
borg_backup.sh
borg_restore.sh
borg_backup_pasta_corrente.sh
Deseja continuar com a restauração real? (s/n): s

⚙️  Etapa 2: Iniciando restauração real...
✅ Restauração concluída com sucesso!
Arquivos restaurados em: /home/paulo/scripts/restaurado
```

---

## 🧩 Teste Seguro (Dry Run Manual)

Você também pode testar manualmente, sem alterar nada:

```bash
cd /home/paulo/scripts/restaurado
borg extract --dry-run --list /media/paulo/borg_backup/scripts/borg-repo::backup-2025-10-30
```

---

## 🔗 Referências

* 📘 **Site oficial do BorgBackup:**
  [https://www.borgbackup.org/](https://www.borgbackup.org/)

* 📖 **Documentação detalhada:**
  [https://borgbackup.readthedocs.io/en/stable/](https://borgbackup.readthedocs.io/en/stable/)

* 💡 **Guia de comandos Borg (CLI):**

  ```bash
  man borg
  ```

* 💬 **Comunidade e suporte:**
  [https://github.com/borgbackup/borg/discussions](https://github.com/borgbackup/borg/discussions)

---

## 🧾 Histórico de Versões

| Versão | Data       | Alterações                                                        |
| ------ | ---------- | ----------------------------------------------------------------- |
| 1.0    | 2025-10-30 | Versão inicial baseada no modelo genérico                         |
| 1.1    | 2025-10-31 | Compatibilidade Borg 1.x, limpeza de caminhos e simulação dry-run |

---

## ✅ Autor

**Paulo SSPacheco**
💻 Automação e Infraestrutura Linux
📅 Outubro de 2025

---

