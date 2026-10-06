# 📘 Documentação do Script CopyToGDriver_Sync.v.0.0.35.sh

## 🧩 Visão Geral

O script **CopyToGDriver_Sync.v.0.0.35.sh** é o módulo principal do projeto **CopyToGDriver**, responsável por **sincronizar pastas locais com o Google Drive** utilizando o **rclone**.  
Ele garante execução **segura**, **sem instâncias duplicadas**, e mantém **logs organizados** por pasta e data.

---

## ⚙️ Parâmetros e Variáveis Principais

### 🔹 Variáveis de Configuração

| Variável | Descrição | Valor Padrão |
|-----------|------------|---------------|
| `BASE_REMOTE_FOLDER` | Pasta base de sincronização no Google Drive. | `rclone` |
| `DELETED_BASE_FOLDER` | Pasta de backup/lixeira remota. | `rclone.deleted` |
| `REMOTE_NAME` | Nome do remoto configurado no rclone. | Definido em `CopyToGDriver_Config.sh` |
| `LOCAL_FOLDER` | Caminho local da pasta a ser sincronizada. | Definido via parâmetro |
| `REMOTE_FOLDER` | Caminho remoto de destino relativo ao `BASE_REMOTE_FOLDER`. | Definido via parâmetro |
| `RCLONE_EXCLUDE_FILE` | Arquivo de exclusões. | Opcional |
| `LOG_RETENTION_DAYS` | Dias de retenção dos logs antes da exclusão. | Definido em config |
| `ZIP_AFTER_DAYS` | Dias para compressão automática de logs. | Definido em config |

---

### 🔹 Parâmetros de Linha de Comando

Os parâmetros são processados pela função `parse_parameters()` do módulo `CopyToGDriver_ConfigFunctions.sh`.

| Parâmetro | Descrição | Tipo |
|------------|------------|------|
| `--dry-run` | Executa em modo de simulação (sem enviar arquivos). | Opcional |
| `--resync` | Força uma resincronização completa. | Opcional |
| `--clean-cache` | Limpa o cache local do rclone antes da execução. | Opcional |
| `--auto-create` | Cria automaticamente pastas remotas ausentes. | Opcional |
| `--verbose` | Ativa logs detalhados. | Opcional |
| `--quiet` | Desativa exibição de progresso. | Opcional |
| `--help` | Exibe ajuda e encerra o script. | Opcional |

---

## 🧠 Funções Internas

### `show_configuration()`
Exibe no terminal as configurações atuais do ambiente, incluindo pastas locais, remotas e modos ativos.  
Indica visualmente se está em modo **simulação**, **resync**, **verbose**, ou **limpeza de cache**.

---

### `normalize_remote_paths(incoming)`
Normaliza caminhos remotos fornecidos pelo usuário.  
Converte entradas como `"blog"` → `rclone/blog` e remove barras redundantes.  
Gera duas variáveis úteis:
- `NORMALIZED_TARGET_REMOTE_PATH`: caminho completo remoto (`rclone/paulo/docs`)
- `NORMALIZED_CLEAN_REMOTE_PATH`: caminho relativo (`paulo/docs`)

---

### `check_rclone_safety()`
Garante que **não há processos rclone ativos** antes da sincronização.  
Realiza verificações multiplataforma:
- `pgrep` (Linux/macOS)  
- `tasklist` (Windows)  
- `ps` (fallback universal)

🔒 **Bloqueia completamente** a execução caso detecte múltiplas instâncias do rclone.

---

### `lock_protect()`
Evita **sincronizações concorrentes** da mesma pasta.  
Cria lockfiles únicos em `/tmp/copytogdriver` baseados no caminho da pasta.  
Remove automaticamente o lock ao final da execução (via `trap EXIT`).

---

### `sync_folders()`
Função principal de sincronização.  
Executa as seguintes etapas:

1. Garante exclusividade de execução (`lock_protect` + `check_rclone_safety`)
2. Limpa cache se solicitado (`--clean-cache`)
3. Cria e valida pastas remotas e de backup
4. Configura logs locais e sistema de resumo
5. Monta parâmetros otimizados para o `rclone`
6. Executa sincronização real ou simulação
7. Registra resultados e limpa logs antigos

Principais parâmetros do rclone utilizados:

```bash
rclone sync <LOCAL_FOLDER> <REMOTE_NAME>:<REMOTE_PATH>   --backup-dir <REMOTE_NAME>:<DELETED_REMOTE_PATH>   --fast-list --transfers 4 --checkers 8   --delete-after --log-file <log_file>   [--dry-run] [--verbose] [--quiet] [--resync]
```

---

### `show_last_log()`
Permite visualizar o log mais recente da pasta sincronizada.  
Detecta o sistema operacional e abre o log de forma apropriada:

- 🪟 Windows → Notepad  
- 🍎 macOS → open  
- 🐧 Linux → less  

---

### `main()`
Função principal executada quando o script é chamado diretamente.  
Etapas:
1. Lê parâmetros via `parse_parameters()`  
2. Exibe ajuda (`--help`) se solicitado  
3. Mostra configuração atual  
4. Executa `sync_folders()` após validar pré-requisitos  

---

## 🧾 Estrutura de Logs

Os logs são armazenados de forma hierárquica:

```
~/CopyToGDriver_Log/
├── system/
│   └── summary.log     # Registro resumido de todas as execuções
└── <nome_da_pasta>/
    ├── sync-YYYYMMDD-HHMMSS.log
    ├── sync-YYYYMMDD-HHMMSS.log.gz  # logs antigos compactados
```

---

## 🚫 Mecanismos de Segurança

- Bloqueio de múltiplas instâncias (lockfile + verificação de processo)
- Detecção de `rclone` ativo antes da execução
- Criação automática de pastas base e backup
- Backup de itens removidos em `<rclone.deleted>/<path>/<data>`
- Nenhum arquivo é excluído permanentemente

---

## 🧰 Exemplo de Uso

```bash
# Sincronização normal
./CopyToGDriver_Sync.v.0.0.35.sh --local-folder ./meus_docs --remote-folder projetos/docs

# Simulação sem alterações
./CopyToGDriver_Sync.v.0.0.35.sh --dry-run

# Execução silenciosa e sem prompts
./CopyToGDriver_Sync.v.0.0.35.sh --auto-create --quiet
```

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver_Sync.v.0.0.35.sh |
| **Versão** | 0.0.0.36 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5 Thinking) |
| **Data** | 01/11/2025 |
| **Licença** | Uso pessoal / interno |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
