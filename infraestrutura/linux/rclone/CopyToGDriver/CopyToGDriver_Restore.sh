#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Restore.sh
# Função: Restaura o backup mais recente da pasta rclone.deleted
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.2.0 (restaura também conteúdo ativo quando não há backup)
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
LOG_ROOT="$HOME/CopyToGDriver_Log"
LOG_DIR="$LOG_ROOT/system"
RESTORE_MARKER="$LOG_ROOT/.restore_aborted"
DISK_REGISTRY="$HOME/.config/CopyToGDriver/disks_registry.conf"

# ===========================================================
# 🧩 Função: show_help
# ===========================================================
show_help() {
    cat <<EOF
Uso:
  CopyToGDriver_Restore.sh [opções]

Se executado sem parâmetros, restaura automaticamente o backup da pasta atual.

Opções:
  --remote-folder <nome>     Pasta remota a restaurar (opcional)
  --restore-mode <copy|move> Restaurar copiando (padrão) ou movendo os arquivos
  --dry-run                  Simula a restauração sem alterar nada
  --verbose                  Exibe detalhes durante a execução
  --help                     Mostra esta ajuda

Observações:
  • Logs ficam em: $LOG_DIR
  • Após restaurar, o script cria o marcador:
        $RESTORE_MARKER
    para impedir sincronizações acidentais.
  • Detecta automaticamente o HD base e o caminho relativo conforme:
        $DISK_REGISTRY
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
# 💽 Função: Detectar o disco base e caminho relativo
# ===========================================================
get_disk_base_path() {
    local folder="$1"
    local registry="$DISK_REGISTRY"

    if [[ ! -f "$registry" ]]; then
        echo "⚠️  Registro de discos não encontrado: $registry"
        echo "/mnt"
        return
    fi

    local best_match=""
    local longest_match=0

    while IFS='=' read -r path _; do
        path=$(echo "$path" | xargs)
        [[ -z "$path" || "$path" == \[*\] ]] && continue
        if [[ "$folder" == "$path"* ]]; then
            local len=${#path}
            (( len > longest_match )) && longest_match=$len && best_match="$path"
        fi
    done < "$registry"

    [[ -z "$best_match" ]] && echo "/mnt" || echo "$best_match"
}

# ===========================================================
# 🚀 Função: restore_from_backup
# ===========================================================
restore_from_backup() {
    mkdir -p "$LOG_DIR"

    # Se nenhum alvo foi informado, usar caminho atual
    if [[ -z "$TARGET_FOLDER" ]]; then
        LOCAL_FOLDER="$(pwd)"
        DISK_BASE=$(get_disk_base_path "$LOCAL_FOLDER")
        RELATIVE_PATH="${LOCAL_FOLDER#${DISK_BASE}/}"
        TARGET_FOLDER="$RELATIVE_PATH"
        TARGET_FOLDER=$(echo "$TARGET_FOLDER" | sed 's|//*|/|g' | sed 's|^/||')
    fi

    # Caminho remoto de backup
    local backup_root="$REMOTE_NAME:$DELETED_BASE_FOLDER/$TARGET_FOLDER"
    local latest_date
    latest_date=$(rclone lsd "$backup_root" 2>/dev/null | awk '{print $5}' | sort -r | head -1)

    # ----------------------------------------------------------
    # 🧭 Se não há backup, tenta restaurar conteúdo ativo
    # ----------------------------------------------------------
    if [[ -z "$latest_date" ]]; then
        write_color_output "⚠️  Nenhum backup encontrado em $backup_root" "Yellow"
        write_color_output "🔍 Tentando restaurar conteúdo ativo em '$REMOTE_NAME:$BASE_REMOTE_FOLDER/$TARGET_FOLDER'..." "Cyan"

        if rclone lsd "$REMOTE_NAME:$BASE_REMOTE_FOLDER/$TARGET_FOLDER" >/dev/null 2>&1; then
            local timestamp=$(date +"%Y%m%d-%H%M%S")
            local log_file="$LOG_DIR/restore-$(basename "$TARGET_FOLDER")-$timestamp.log"
            write_color_output "📁 Pasta ativa encontrada — iniciando restauração..." "Blue"

            local rclone_copy_args=(
                copy
                "$REMOTE_NAME:$BASE_REMOTE_FOLDER/$TARGET_FOLDER"
                "$(pwd)"
                "--progress"
                "--create-empty-src-dirs"
                "--log-file" "$log_file"
            )
            [[ "$DRY_RUN" == "true" ]] && rclone_copy_args+=("--dry-run")
            [[ "$VERBOSE" == "true" ]] && rclone_copy_args+=("--verbose")

            rclone "${rclone_copy_args[@]}"
            local exit_code=$?

            if [[ $exit_code -eq 0 ]]; then
                write_color_output "✅ Restauração concluída com sucesso a partir da pasta ativa!" "Green"
                echo "📜 Log salvo em: $log_file"
                exit 0
            else
                write_color_output "❌ Erro ao restaurar da pasta ativa (código $exit_code)." "Red"
                echo "📜 Log salvo em: $log_file"
                exit 1
            fi
        else
            write_color_output "❌ Nenhum backup nem pasta ativa encontrada para '$TARGET_FOLDER'." "Red"
            write_color_output "🛑 Restauração cancelada para evitar sobrescrita." "Red"
            exit 1
        fi
    fi

    # ----------------------------------------------------------
    # 📦 Se há backup, restaura normalmente
    # ----------------------------------------------------------
    write_color_output "📅 Backup mais recente encontrado: $latest_date" "Blue"

    local source_path="$backup_root/$latest_date"
    local destination_path="$(pwd)"
    local timestamp=$(date +"%Y%m%d-%H%M%S")
    local log_file="$LOG_DIR/restore-$(basename "$TARGET_FOLDER")-$timestamp.log"

    echo "------------------------------------------------------"
    echo "🔄 Restauração de Backup (Google Drive → Local)"
    echo "------------------------------------------------------"
    echo "☁️  Origem (remoto): $source_path"
    echo "📂 Destino local.. : $destination_path"
    echo "🗂️  Modo.......... : $RESTORE_MODE"
    echo "📜 Log............ : $log_file"
    echo "------------------------------------------------------"
    echo ""

    local rclone_args=(
        copy
        "$source_path"
        "$destination_path"
        "--create-empty-src-dirs"
        "--log-file" "$log_file"
        "--stats" "30s"
        "--stats-file-name-length" "0"
    )

    [[ "$DRY_RUN" == "true" ]] && rclone_args+=("--dry-run")
    [[ "$VERBOSE" == "true" ]] && rclone_args+=("--verbose")

    write_color_output "🚀 Restaurando arquivos de backup..." "Cyan"
    echo "rclone ${rclone_args[*]}"
    echo ""

    rclone "${rclone_args[@]}"
    local exit_code=$?

    echo ""
    if [[ $exit_code -eq 0 ]]; then
        write_color_output "✅ Restauração concluída com sucesso!" "Green"
        mkdir -p "$(dirname "$RESTORE_MARKER")"
        echo "restore_abort $(date)" > "$RESTORE_MARKER"
        echo "📜 Log salvo em: $log_file"
        write_color_output "🛑 Sincronizações futuras foram bloqueadas temporariamente." "Yellow"
        write_color_output "👉 Revise os arquivos antes de sincronizar novamente." "Cyan"
        exit 11
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
