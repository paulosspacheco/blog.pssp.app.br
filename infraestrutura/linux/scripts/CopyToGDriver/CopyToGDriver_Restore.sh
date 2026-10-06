#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Restore.sh
# Função: Restaura o backup mais recente da pasta rclone.deleted
# Autor: Paulo SSPacheco
# Versão: 0.0.3 (corrigido: cria marcador .restore_aborted)
# ===========================================================

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh" 2>/dev/null || true
source "$SCRIPT_DIR/CopyToGDriver_Config.sh" 2>/dev/null || true

# ===========================================================
# ⚙️ PARÂMETROS PADRÃO
# ===========================================================
REMOTE_NAME="gdriver"
BASE_REMOTE_FOLDER="rclone"
DELETED_BASE_FOLDER="rclone.deleted"
RESTORE_MODE="copy"   # copy = mantém o backup / move = remove após restaurar
DRY_RUN=false
TARGET_FOLDER=""
LOG_DIR="$HOME/.rclone-sync/logs"
RESTORE_MARKER="$LOG_DIR/.restore_aborted"

# ===========================================================
# 🧩 Função: show_help
# ===========================================================
show_help() {
    cat <<EOF
Uso: CopyToGDriver_Restore.sh --remote-folder <nome> [opções]

Opções:
  --remote-folder <nome>     Pasta remota a restaurar (ex: CopyToGDriverTest)
  --restore-mode <copy|move> Restaurar copiando (padrão) ou movendo os arquivos
  --dry-run                  Simula a restauração sem alterar nada
  --verbose                  Exibe detalhes durante a execução
  --help                     Mostra esta ajuda

OBS:
  Após restaurar, o script cria o arquivo:
    ~/.rclone-sync/logs/.restore_aborted
  Esse marcador faz o script principal abortar automaticamente.
EOF
    exit 0
}

# ===========================================================
# 🧠 Função: parse_parameters
# ===========================================================
parse_parameters() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --remote-folder) TARGET_FOLDER="$2"; shift 2 ;;
            --restore-mode) RESTORE_MODE="$2"; shift 2 ;;
            --dry-run) DRY_RUN=true; shift ;;
            --verbose) VERBOSE=true; shift ;;
            --help) show_help ;;
            *) echo "❌ Parâmetro desconhecido: $1"; exit 1 ;;
        esac
    done
}

# ===========================================================
# 🚀 Função: restore_from_backup
# ===========================================================
restore_from_backup() {
    if [[ -z "$TARGET_FOLDER" ]]; then
        write_color_output "❌ Nenhuma pasta especificada (--remote-folder)." "Red"
        exit 1
    fi

    local backup_root="$REMOTE_NAME:$DELETED_BASE_FOLDER/$TARGET_FOLDER"
    local latest_date
    latest_date=$(rclone lsd "$backup_root" 2>/dev/null | awk '{print $5}' | sort -r | head -1)

    if [[ -z "$latest_date" ]]; then
        write_color_output "❌ Nenhum backup encontrado para '$TARGET_FOLDER' em $backup_root" "Red"
        exit 1
    fi

    write_color_output "📅 Backup mais recente encontrado: $latest_date" "Blue"

    local source_path="$backup_root/$latest_date"
    local destination_path="$REMOTE_NAME:$BASE_REMOTE_FOLDER/$TARGET_FOLDER"
    local timestamp
    timestamp=$(date +"%Y%m%d-%H%M%S")
    local log_file="$LOG_DIR/restore-$TARGET_FOLDER-$timestamp.log"

    mkdir -p "$LOG_DIR"

    echo "------------------------------------------------------"
    echo "🔄 Restauração de Backup (do Drive → Local)"
    echo "------------------------------------------------------"
    echo "☁️  Origem (backup remoto): $source_path"
    echo "📂 Destino local......... : $(pwd)"
    echo "🗂️  Modo.................. : $RESTORE_MODE"
    echo "📜 Log.................... : $log_file"
    echo "------------------------------------------------------"

    local rclone_args=(
        copy
        "$source_path"
        "$(pwd)"
        "--create-empty-src-dirs"
        "--log-file" "$log_file"
        "--stats" "30s"
        "--stats-file-name-length" "0"
    )

    [[ "$DRY_RUN" == "true" ]] && rclone_args+=("--dry-run")
    [[ "$VERBOSE" == "true" ]] && rclone_args+=("--verbose")

    echo
    write_color_output "🚀 Baixando arquivos de backup para o local..." "Cyan"
    echo "rclone ${rclone_args[*]}"
    echo

    rclone "${rclone_args[@]}"
    local exit_code=$?

    echo
    if [[ $exit_code -eq 0 ]]; then
        write_color_output "✅ Restauração concluída com sucesso!" "Green"
        write_color_output "🛑 Por segurança, a sincronização foi ABORTADA." "Yellow"
        write_color_output "👉 Verifique os arquivos restaurados em: $(pwd)" "Cyan"
        echo "📜 Log salvo em: $log_file"

        # 🧩 Marca restauração detectada
        echo "restore_abort $(date)" > "$RESTORE_MARKER"

        echo
        write_color_output "🛑 Restauração concluída com segurança." "Yellow"
        write_color_output "🚫 Sincronização interrompida propositalmente para evitar sobrescrita." "Yellow"
        write_color_output "👉 Revise os arquivos restaurados e execute novamente a sincronização." "Cyan"

        exit 11  # código especial: restauração bem-sucedida
    else
        write_color_output "❌ Erro durante a restauração (código $exit_code)" "Red"
        echo "📜 Log salvo em: $log_file"
        exit 1
    fi
}

# ===========================================================
# ▶️ Execução principal
# ===========================================================
main() {
    parse_parameters "$@"
    restore_from_backup
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Restore.sh
# ===========================================================
