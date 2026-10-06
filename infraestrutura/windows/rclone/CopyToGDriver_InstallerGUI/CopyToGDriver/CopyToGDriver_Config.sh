#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Config.sh
# Função: Define variáveis globais e padrões de configuração
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.1.0 (multiplataforma real)
# ===========================================================

# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi



# -----------------------------------------------------------
# 🌍 DETECÇÃO DE PLATAFORMA
# -----------------------------------------------------------
detect_platform() {
    case "$(uname -s)" in
        Linux*)   echo "linux" ;;
        Darwin*)  echo "macos" ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *)        echo "unknown" ;;
    esac
}
PLATFORM=$(detect_platform)

# -----------------------------------------------------------
# 🏠 CONFIGURAÇÃO DE DIRETÓRIOS BASE (por plataforma)
# -----------------------------------------------------------
if [[ "$PLATFORM" == "windows" ]]; then
    USERPROFILE_PATH=$(cygpath -u "$USERPROFILE" 2>/dev/null || echo "$HOME")
    SYNC_ROOT="$USERPROFILE_PATH/.rclone-sync"
    RCLONE_CONFIG_FILE="$USERPROFILE_PATH/AppData/Roaming/rclone/rclone.conf"
elif [[ "$PLATFORM" == "macos" ]]; then
    SYNC_ROOT="$HOME/Library/Application Support/CopyToGDriver/rclone-sync"
    RCLONE_CONFIG_FILE="$HOME/.config/rclone/rclone.conf"
else
    # Linux ou desconhecido → assume estrutura padrão do Linux
    SYNC_ROOT="$HOME/.rclone-sync"
    RCLONE_CONFIG_FILE="$HOME/.config/rclone/rclone.conf"
fi

# -----------------------------------------------------------
# 📦 VARIÁVEIS GERAIS DO SISTEMA
# -----------------------------------------------------------
SCRIPT_NAME="CopyToGDriver"
SCRIPT_VERSION="0.1.0"
LOG_DIR="$SYNC_ROOT/logs"
TMP_DIR="$SYNC_ROOT/tmp"
CACHE_DIR="$SYNC_ROOT/cache"
HISTORY_FILE="$LOG_DIR/SyncHistory.csv"

# -----------------------------------------------------------
# 🌐 VARIÁVEIS DE LOCALIZAÇÃO NO GOOGLE DRIVE
# -----------------------------------------------------------
BASE_REMOTE_FOLDER="rclone"
DELETED_BASE_FOLDER="rclone.deleted"

# -----------------------------------------------------------
# ⚙️ PARÂMETROS DE FUNCIONAMENTO PADRÃO
# -----------------------------------------------------------
DEFAULT_REMOTE_NAME="gdriver"
DEFAULT_EXCLUDE_FILE="./CopyToGDriver_ignore.txt"
DEFAULT_LOCAL_FOLDER="./"
DEFAULT_REMOTE_FOLDER="$(basename "$(pwd)")"

# -----------------------------------------------------------
# 🧾 LOGS E HISTÓRICO
# -----------------------------------------------------------
LOG_RETENTION_DAYS=30
ZIP_AFTER_DAYS=7

# -----------------------------------------------------------
# 💾 ARMAZENAMENTO E CACHE
# -----------------------------------------------------------
RCLONE_CACHE_DIR="$CACHE_DIR/rclone"
RCLONE_TEMP_DIR="$TMP_DIR/rclone"

# -----------------------------------------------------------
# 🧩 FLAGS DE MODO
# -----------------------------------------------------------
DRY_RUN="false"
VERBOSE="false"
AUTO_CREATE="false"
CLEAN_CACHE="false"
RESYNC="false"
SHOW_HELP="false"

# -----------------------------------------------------------
# 🎨 CORES DO TERMINAL (detectando suporte ANSI)
# -----------------------------------------------------------
if [[ "$TERM" == *"xterm"* || "$TERM" == *"ansi"* || "$PLATFORM" != "windows" ]]; then
    COLOR_RED="\033[0;31m"
    COLOR_GREEN="\033[0;32m"
    COLOR_YELLOW="\033[1;33m"
    COLOR_BLUE="\033[0;34m"
    COLOR_CYAN="\033[0;36m"
    COLOR_MAGENTA="\033[0;35m"
    COLOR_RESET="\033[0m"
else
    COLOR_RED=""; COLOR_GREEN=""; COLOR_YELLOW=""
    COLOR_BLUE=""; COLOR_CYAN=""; COLOR_MAGENTA=""
    COLOR_RESET=""
fi

# -----------------------------------------------------------
# 🧰 FUNÇÃO DE INICIALIZAÇÃO DO AMBIENTE
# -----------------------------------------------------------
initialize_environment() {
    mkdir -p "$LOG_DIR" "$TMP_DIR" "$CACHE_DIR"
    touch "$HISTORY_FILE" 2>/dev/null
}

initialize_environment

# -----------------------------------------------------------
# 🧩 EXIBIR INFORMAÇÕES DE DIAGNÓSTICO (opcional)
# -----------------------------------------------------------
if [[ "$1" == "--diag" ]]; then
    echo "======================================================"
    echo "🔧 CopyToGDriver Configuração (Diagnóstico)"
    echo "======================================================"
    echo "🖥️  Plataforma ........: $PLATFORM"
    echo "🏠 Diretório base .....: $SYNC_ROOT"
    echo "📂 Logs ...............: $LOG_DIR"
    echo "🗂️  Cache ..............: $CACHE_DIR"
    echo "⚙️  Configuração Rclone : $RCLONE_CONFIG_FILE"
    echo "======================================================"
fi

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Config.sh
# ===========================================================

