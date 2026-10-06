#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Config.sh
# Função: Define variáveis globais e padrões de configuração
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.0.0.22
# ===========================================================

# ===========================================================
# 📦 VARIÁVEIS GERAIS DO SISTEMA
# ===========================================================
SCRIPT_NAME="CopyToGDriver"                    # Nome base do script principal
SCRIPT_VERSION="0.0.0.22"                      # Versão atual do projeto
SYNC_ROOT="$HOME/.rclone-sync"                 # Diretório de sincronização local
LOG_DIR="$SYNC_ROOT/logs"                      # Diretório central de logs
TMP_DIR="$SYNC_ROOT/tmp"                       # Diretório temporário

# ===========================================================
# 🌐 VARIÁVEIS DE LOCALIZAÇÃO NO GOOGLE DRIVE
# ===========================================================
# Essas variáveis controlam onde os arquivos são armazenados no Drive.
# A estrutura final será sempre:
#   gdriver:<BASE_REMOTE_FOLDER>/<pasta_local>
#   gdriver:<DELETED_BASE_FOLDER>/<pasta_local>/<data>
# -----------------------------------------------------------
BASE_REMOTE_FOLDER="rclone"                    # Pasta base principal (conteúdo ativo)
DELETED_BASE_FOLDER="rclone.deleted"           # Pasta base para backups de arquivos removidos
# -----------------------------------------------------------
# Exemplo:
#   Pasta local ........: /home/paulo/Projetos/Backup
#   Remote Rclone ......: gdriver
#   Resultado no Drive .: gdriver:rclone/Backup
#   Backup de deletados : gdriver:rclone.deleted/Backup/2025-10-31
# ===========================================================

# ===========================================================
# ⚙️ PARÂMETROS DE FUNCIONAMENTO PADRÃO
# ===========================================================
DEFAULT_REMOTE_NAME="gdriver"                  # Nome padrão do remote configurado no Rclone
DEFAULT_EXCLUDE_FILE="./CopyToGDriver_ignore.txt" # Arquivo de exclusões padrão
DEFAULT_LOCAL_FOLDER="./"                      # Pasta local padrão (pasta corrente)
DEFAULT_REMOTE_FOLDER="$(basename "$(pwd)")"   # Nome padrão da pasta remota (igual à atual)

# ===========================================================
# 🧾 LOGS E HISTÓRICO
# ===========================================================
LOG_RETENTION_DAYS=30                          # Quantos dias manter logs
ZIP_AFTER_DAYS=7                               # Compactar logs após X dias
HISTORY_FILE="$LOG_DIR/SyncHistory.csv"         # Histórico centralizado de execuções

# ===========================================================
# 💾 ARMAZENAMENTO E CACHE
# ===========================================================
CACHE_DIR="$SYNC_ROOT/cache"                   # Cache local do rclone
RCLONE_CONFIG_FILE="$HOME/.config/rclone/rclone.conf" # Caminho padrão da configuração rclone

# ===========================================================
# 🎨 CORES DO TERMINAL (usadas em Utils)
# ===========================================================
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[0;34m"
COLOR_CYAN="\033[0;36m"
COLOR_MAGENTA="\033[0;35m"
COLOR_RESET="\033[0m"

# ===========================================================
# 🧩 FLAGS DE MODO
# ===========================================================
DRY_RUN="false"                                # Modo simulação (dry-run)
VERBOSE="false"                                # Modo verboso
AUTO_CREATE="false"                            # Cria pastas automaticamente
CLEAN_CACHE="false"                            # Limpa cache rclone após execução
RESYNC="false"                                 # Reforça reindexação (resync)
SHOW_HELP="false"                              # Exibe ajuda e encerra
# ===========================================================

# ===========================================================
# 🔧 FUNÇÃO DE INICIALIZAÇÃO
# ===========================================================
initialize_environment() {
    mkdir -p "$LOG_DIR" "$TMP_DIR" "$CACHE_DIR"
}

initialize_environment

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Config.sh
# ===========================================================
