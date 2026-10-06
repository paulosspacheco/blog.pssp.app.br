#!/bin/bash
# ===========================================================
# Módulo comum: logging.sh
# Funções de log e saída colorida padronizadas
# ===========================================================

write_color_output() {
    local message="$1"
    local color="$2"
    case "$color" in
        Red) echo -e "\033[31m$message\033[0m" ;;
        Green) echo -e "\033[32m$message\033[0m" ;;
        Yellow) echo -e "\033[33m$message\033[0m" ;;
        Blue) echo -e "\033[34m$message\033[0m" ;;
        Cyan) echo -e "\033[36m$message\033[0m" ;;
        *) echo "$message" ;;
    esac
}

log_info()    { write_color_output "[INFO] $1" "Blue"; }
log_warn()    { write_color_output "[WARN] $1" "Yellow"; }
log_error()   { write_color_output "[ERRO] $1" "Red"; }
log_success() { write_color_output "[OK] $1" "Green"; }
