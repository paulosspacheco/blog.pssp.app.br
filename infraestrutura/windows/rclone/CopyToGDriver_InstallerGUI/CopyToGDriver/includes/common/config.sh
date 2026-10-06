#!/bin/bash
# ======================================================
# CopyToGDriver – Configuração Comum
# ======================================================

# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi



# Nome do remote do rclone
REMOTE_NAME="gdriver"

# Diretório base remoto e pasta de backups
BASE_REMOTE_FOLDER="rclone"
DELETED_BASE_FOLDER="rclone.deleted"

# Caminho de logs (ajustado conforme sistema)
if [[ "$OS" == "Windows_NT" ]]; then
  USER_HOME="/c/Users/$USERNAME"
else
  USER_HOME="$HOME"
fi

LOG_ROOT="$USER_HOME/CopyToGDriver_Log"
LOG_DIR="$LOG_ROOT/system"
RESTORE_MARKER="$LOG_ROOT/.restore_aborted"
CONFIG_DIR="$USER_HOME/.config/CopyToGDriver"
DISK_REGISTRY="$CONFIG_DIR/disks_registry.conf"
