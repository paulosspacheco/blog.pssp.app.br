#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Utils.sh
# Função: Fornece funções utilitárias compartilhadas entre módulos
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém funções auxiliares de uso geral, como:
#   • Saída colorida no terminal
#   • Função genérica de log com timestamp
#   • Tratamento de mensagens de erro e sucesso padronizadas
#
# Todos os demais módulos devem importar este script com:
#   👉 source "$(dirname "$0")/CopyToGDriver_Utils.sh"
# ===========================================================


# ===========================================================
# 🎨 Função: write_color_output
# ===========================================================
# Exibe mensagens coloridas no terminal para facilitar a leitura.
# Uso:
#   write_color_output "mensagem" "Cor"
# Cores disponíveis: Red, Green, Yellow, Blue, Magenta, Cyan
# ===========================================================
write_color_output() {
    local message="$1"
    local color="$2"
    
    case $color in
        "Red") echo -e "\033[31m$message\033[0m" ;;
        "Green") echo -e "\033[32m$message\033[0m" ;;
        "Yellow") echo -e "\033[33m$message\033[0m" ;;
        "Blue") echo -e "\033[34m$message\033[0m" ;;
        "Magenta") echo -e "\033[35m$message\033[0m" ;;
        "Cyan") echo -e "\033[36m$message\033[0m" ;;
        *) echo "$message" ;;
    esac
}


# ===========================================================
# 🧾 Função: log_message
# ===========================================================
# Grava mensagens com timestamp no log especificado.
# Uso:
#   log_message "/caminho/arquivo.log" "mensagem"
# ===========================================================
log_message() {
    local logfile="$1"
    shift
    local message="$*"

    if [[ -z "$logfile" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') [LOG] $message"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') [LOG] $message" >> "$logfile"
    fi
}


# ===========================================================
# ⚠️ Função: exit_with_error
# ===========================================================
# Encerra o script exibindo mensagem de erro colorida e opcionalmente registrando em log.
# Uso:
#   exit_with_error "mensagem de erro" [arquivo.log]
# ===========================================================
exit_with_error() {
    local message="$1"
    local logfile="$2"

    write_color_output "❌ ERRO: $message" "Red"

    if [[ -n "$logfile" ]]; then
        log_message "$logfile" "ERRO: $message"
    fi

    exit 1
}


# ===========================================================
# ✅ Função: success_message
# ===========================================================
# Exibe uma mensagem de sucesso padronizada e registra no log, se fornecido.
# Uso:
#   success_message "mensagem de sucesso" [arquivo.log]
# ===========================================================
success_message() {
    local message="$1"
    local logfile="$2"

    write_color_output "✅ $message" "Green"

    if [[ -n "$logfile" ]]; then
        log_message "$logfile" "SUCESSO: $message"
    fi
}


# ===========================================================
# 🧩 Placeholder para futuras utilidades
# ===========================================================
# Exemplos futuros:
#   - validate_command "rclone"
#   - bytes_to_human 12345678
#   - ensure_directory_exists "/pasta/alvo"
# ===========================================================


# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Utils.sh
# ===========================================================