# 📘 Documentação do Script CopyToGDriver_Config.sh

## 🧩 Visão Geral

O módulo **CopyToGDriver_Config.sh** é responsável por **definir as variáveis globais e padrões de configuração** utilizados em todos os módulos do projeto **CopyToGDriver**.  
Ele detecta automaticamente a **plataforma** (Linux, macOS ou Windows), ajusta os **caminhos de diretórios** e inicializa o **ambiente de sincronização**.

---

## ⚙️ Função Principal

Este script estabelece a base de configuração que os outros módulos (como Sync, Checks e Cache) utilizam para funcionar corretamente.  
Ele é carregado automaticamente no início da execução do **CopyToGDriver.sh** e não requer execução manual.

---

## 🌍 Detecção de Plataforma

### `detect_platform()`
Função responsável por identificar o sistema operacional atual, retornando um dos valores abaixo:

| Sistema | Valor retornado |
|----------|----------------|
| Linux | `linux` |
| macOS | `macos` |
| Windows (Git Bash, Cygwin ou MSYS) | `windows` |
| Outro | `unknown` |

O resultado é armazenado na variável global `PLATFORM` e usado em diversos pontos para definir caminhos e comportamento.

---

## 🏠 Diretórios Base (por Plataforma)

Após detectar o sistema operacional, o script define automaticamente os diretórios principais utilizados pela aplicação.

| Variável | Linux | macOS | Windows |
|-----------|--------|--------|----------|
| `SYNC_ROOT` | `$HOME/.rclone-sync` | `$HOME/Library/Application Support/CopyToGDriver/rclone-sync` | `/c/Users/<user>/.rclone-sync` |
| `RCLONE_CONFIG_FILE` | `$HOME/.config/rclone/rclone.conf` | `$HOME/.config/rclone/rclone.conf` | `/c/Users/<user>/AppData/Roaming/rclone/rclone.conf` |

---

## 📦 Variáveis Globais do Sistema

| Variável | Descrição | Valor Padrão |
|-----------|------------|---------------|
| `SCRIPT_NAME` | Nome base do projeto/script principal. | `CopyToGDriver` |
| `SCRIPT_VERSION` | Versão atual do módulo de configuração. | `0.1.0` |
| `LOG_DIR` | Diretório onde os logs serão armazenados. | `$SYNC_ROOT/logs` |
| `TMP_DIR` | Diretório temporário para operações intermediárias. | `$SYNC_ROOT/tmp` |
| `CACHE_DIR` | Diretório de cache do rclone. | `$SYNC_ROOT/cache` |
| `HISTORY_FILE` | Caminho do arquivo CSV com histórico de sincronizações. | `$LOG_DIR/SyncHistory.csv` |

---

## 🌐 Localização no Google Drive

| Variável | Descrição | Valor Padrão |
|-----------|------------|---------------|
| `BASE_REMOTE_FOLDER` | Pasta base usada para sincronizações no Google Drive. | `rclone` |
| `DELETED_BASE_FOLDER` | Pasta de backup para itens excluídos. | `rclone.deleted` |

---

## ⚙️ Parâmetros Padrão de Funcionamento

| Variável | Descrição | Valor Padrão |
|-----------|------------|---------------|
| `DEFAULT_REMOTE_NAME` | Nome do remoto configurado no rclone. | `gdriver` |
| `DEFAULT_EXCLUDE_FILE` | Caminho do arquivo que contém padrões de exclusão. | `./CopyToGDriver_ignore.txt` |
| `DEFAULT_LOCAL_FOLDER` | Pasta local padrão usada para sincronização. | `./` |
| `DEFAULT_REMOTE_FOLDER` | Nome padrão da pasta remota. | Nome da pasta atual (`basename "$(pwd)"`) |

---

## 🧾 Logs e Histórico

| Variável | Descrição | Valor |
|-----------|------------|--------|
| `LOG_RETENTION_DAYS` | Dias de retenção dos logs antes da exclusão. | `30` |
| `ZIP_AFTER_DAYS` | Dias após os quais os logs são compactados. | `7` |

---

## 💾 Armazenamento e Cache

| Variável | Descrição | Caminho |
|-----------|------------|----------|
| `RCLONE_CACHE_DIR` | Diretório de cache do rclone. | `$CACHE_DIR/rclone` |
| `RCLONE_TEMP_DIR` | Diretório temporário usado pelo rclone. | `$TMP_DIR/rclone` |

---

## 🧩 Flags de Modo

Estas flags são definidas como `"false"` por padrão e podem ser alteradas dinamicamente por parâmetros de linha de comando ou módulos superiores.

| Variável | Descrição |
|-----------|------------|
| `DRY_RUN` | Modo simulação (sem alterações reais). |
| `VERBOSE` | Exibe logs detalhados. |
| `AUTO_CREATE` | Cria automaticamente pastas remotas inexistentes. |
| `CLEAN_CACHE` | Executa limpeza do cache antes da sincronização. |
| `RESYNC` | Força uma resincronização completa. |
| `SHOW_HELP` | Exibe ajuda e encerra o programa. |

---

## 🎨 Cores do Terminal

O módulo define variáveis ANSI para cores, usadas em todas as mensagens exibidas pelos scripts.

| Cor | Variável | Exemplo |
|------|-----------|----------|
| Vermelho | `COLOR_RED` | Erros críticos |
| Verde | `COLOR_GREEN` | Operações bem-sucedidas |
| Amarelo | `COLOR_YELLOW` | Avisos e alertas |
| Azul | `COLOR_BLUE` | Informações neutras |
| Ciano | `COLOR_CYAN` | Mensagens de status |
| Magenta | `COLOR_MAGENTA` | Destaques visuais |
| Reset | `COLOR_RESET` | Finaliza formatação |

> 💡 No Windows, as cores são desabilitadas automaticamente se o terminal não oferecer suporte ANSI.

---

## 🧰 Função de Inicialização

### `initialize_environment()`
Responsável por criar as pastas e arquivos essenciais para o funcionamento do sistema.

Passos realizados:
1. Cria diretórios `logs`, `tmp` e `cache` dentro do `SYNC_ROOT`.  
2. Garante que o arquivo de histórico (`SyncHistory.csv`) exista.  

```bash
initialize_environment
```

---

## 🔍 Diagnóstico

O script pode ser executado manualmente com a flag `--diag` para exibir informações sobre o ambiente atual.

Exemplo de saída:

```
======================================================
🔧 CopyToGDriver Configuração (Diagnóstico)
======================================================
🖥️  Plataforma ........: linux
🏠 Diretório base .....: /home/usuario/.rclone-sync
📂 Logs ...............: /home/usuario/.rclone-sync/logs
🗂️  Cache ..............: /home/usuario/.rclone-sync/cache
⚙️  Configuração Rclone : /home/usuario/.config/rclone/rclone.conf
======================================================
```

---

## 📜 Versão e Autores

| Campo | Valor |
|--------|--------|
| **Script** | CopyToGDriver_Config.sh |
| **Versão** | 0.1.0 |
| **Autores** | Paulo SSPacheco + ChatGPT (GPT-5) |
| **Data** | 01/11/2025 |
| **Licença** | Uso pessoal / interno |

---

© 2025 Paulo SSPacheco + ChatGPT (GPT-5) — Todos os direitos reservados.
