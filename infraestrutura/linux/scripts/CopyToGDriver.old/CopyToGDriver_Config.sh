#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Config.sh
# Função: Define variáveis padrão e realiza parsing de parâmetros
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
# ===========================================================


# ===========================================================
# 🔧 VALORES PADRÃO DINÂMICOS
# ===========================================================
DEFAULT_LOCAL_FOLDER=""  # Será definido como diretório atual
DEFAULT_REMOTE_NAME="gdriver"
DEFAULT_REMOTE_FOLDER=""  # Será definido como "rclone/[nome da pasta atual]"
DEFAULT_LOG_RETENTION_DAYS=30
DEFAULT_ZIP_AFTER_DAYS=7
DEFAULT_SYNC_ROOT="$HOME/.rclone-sync"

# ===========================================================
# 🌐 VARIÁVEIS GLOBAIS
# ===========================================================
LOCAL_FOLDER=""
REMOTE_NAME=""
REMOTE_FOLDER=""
LOG_RETENTION_DAYS=""
ZIP_AFTER_DAYS=""
SYNC_ROOT=""
DRY_RUN=false
VERBOSE=false
RESYNC=false
AUTO_CREATE=false
CLEAN_CACHE=false
SHOW_HELP=false
