# 📂 Índice de Scripts de Backup e Restauração — BorgBackup

Este diretório contém um conjunto completo de scripts desenvolvidos para **automação de backups e restaurações incrementais** utilizando o **BorgBackup**.

Cada script possui sua respectiva documentação técnica em formato **Markdown (.md)**, explicando o funcionamento, parâmetros e exemplos de uso.

---

## 📘 Sumário

### 🧩 1. Scripts de Backup

| Script | Descrição | Documentação |
|:--------|:-----------|:--------------|
| [`borg_backup.sh`](./borg_backup.sh) | Script genérico principal para realizar **backups incrementais** com BorgBackup. | [📄 `borg_backup.sh.md`](./borg_backup.sh.md) |
| [`borg_backup_pasta_corrente.sh`](./borg_backup_pasta_corrente.sh) | Script auxiliar para fazer **backup da pasta corrente automaticamente**, usando o script base `borg_backup.sh`. | [📄 `borg_backup_pasta_corrente.sh.md`](./borg_backup_pasta_corrente.sh.md) |

---

### 🔁 2. Scripts de Restauração

| Script | Descrição | Documentação |
|:--------|:-----------|:--------------|
| [`borg_restore.sh`](./borg_restore.sh) | Script genérico de **restauração** de backups Borg, com suporte a *dry-run* e seleção de snapshots. | [📄 `borg_restore.sh.md`](./borg_restore.sh.md) |
| [`borg_restore_pasta_corrente.sh`](./borg_restore_pasta_corrente.sh) | Script auxiliar para **restaurar backups da pasta corrente** de forma automatizada, com base em `borg_restore.sh`. | [📄 `borg_restore_pasta_corrente.sh.md`](./borg_restore_pasta_corrente.sh.md) |

---

## 🗂️ Estrutura de Diretório

```

.
├── borg_backup_pasta_corrente.sh
├── borg_backup_pasta_corrente.sh.md
├── borg_backup.sh
├── borg_backup.sh.md
├── borg_restore_pasta_corrente.sh
├── borg_restore_pasta_corrente.sh.md
├── borg_restore.sh
├── borg_restore.sh.md
└── scripts.md

````

---

## 🧠 Descrição Geral

- **Scripts `.sh`** → Executáveis em Bash, compatíveis com sistemas baseados em Debian/Ubuntu.  
- **Arquivos `.md`** → Documentação técnica e exemplos práticos.  
- **Fluxo completo:**  
  1. `borg_backup.sh` — backup genérico  
  2. `borg_backup_pasta_corrente.sh` — backup automatizado da pasta corrente  
  3. `borg_restore.sh` — restauração genérica  
  4. `borg_restore_pasta_corrente.sh` — restauração automatizada da pasta corrente  

---

## ⚙️ Requisitos

| Dependência | Descrição |
|--------------|------------|
| **BorgBackup** | Ferramenta principal para backups e restaurações incrementais. |
| **Bash 5.x** | Shell de execução dos scripts. |
| **mountpoint** | Utilitário para verificar montagem de discos externos. |

Instalação recomendada:
```bash
sudo apt update && sudo apt install -y borgbackup
````

---

## 🔗 Referências

* 📘 [Site oficial do BorgBackup](https://www.borgbackup.org/)
* 📖 [Documentação completa](https://borgbackup.readthedocs.io/en/stable/)
* 💬 [Fórum e comunidade Borg](https://github.com/borgbackup/borg/discussions)

---

## ✅ Autor

**Paulo SSPacheco**
💻 Automação e Infraestrutura Linux
📅 Outubro de 2025

---
