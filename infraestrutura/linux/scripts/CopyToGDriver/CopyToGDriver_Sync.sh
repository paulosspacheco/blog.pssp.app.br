#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Sync.sh
# Função: Executa a sincronização principal via Rclone e controla logs e backups
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.0.0.22
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém as funções que realizam a sincronização real entre
# a pasta local e o Google Drive utilizando o Rclone.
#
# Estrutura de diretórios no Google Drive:
#   • gdriver:rclone/<PASTA_LOCAL>          → conteúdo ativo
#   • gdriver:rclone.deleted/<PASTA_LOCAL>  → arquivos removidos (backup)
#
# Variáveis globais adicionadas:
#   BASE_REMOTE_FOLDER       → Pasta base padrão no Drive (rclone)
#   DELETED_BASE_FOLDER      → Pasta base de backups (rclone.deleted)
#
# ===========================================================

# ===========================================================
# 🔗 Importar dependências
# ===========================================================
SCRIPT_DIR="$(dirname "$0")"

source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"
source "$SCRIPT_DIR/CopyToGDriver_ConfigFunctions.sh"
source "$SCRIPT_DIR/CopyToGDriver_Checks.sh"
source "$SCRIPT_DIR/CopyToGDriver_Cache.sh"
source "$SCRIPT_DIR/CopyToGDriver_Setup.sh"

# ===========================================================
# 🔧 Variáveis padrão de base remota
# ===========================================================
BASE_REMOTE_FOLDER="${BASE_REMOTE_FOLDER:-rclone}"
DELETED_BASE_FOLDER="${DELETED_BASE_FOLDER:-rclone.deleted}"

# ===========================================================
# 🧩 Função: show_configuration
# ===========================================================
show_configuration() {
    write_color_output "[CONFIGURAÇÃO ATUAL]" "Cyan"
    echo "  Pasta Local:       $LOCAL_FOLDER"
    echo "  Remote:            $REMOTE_NAME"
    echo "  Pasta Base Remota: $BASE_REMOTE_FOLDER"
    echo "  Pasta Remota:      '$REMOTE_FOLDER'"
    echo "  Backup Deletados:  $DELETED_BASE_FOLDER"
    echo ""
    echo "  Retenção Logs:     $LOG_RETENTION_DAYS dias"
    echo "  Compactar Logs:    após $ZIP_AFTER_DAYS dias"
    echo "  Diretório Sync:    $SYNC_ROOT"

    [[ "$DRY_RUN" == "true" ]] && write_color_output "  MODO: SIMULAÇÃO" "Yellow"
    [[ "$RESYNC" == "true" ]] && write_color_output "  MODO: RESSINCRONIZAÇÃO" "Yellow"
    [[ "$VERBOSE" == "true" ]] && write_color_output "  MODO: VERBOSO" "Yellow"
    [[ "$AUTO_CREATE" == "true" ]] && write_color_output "  MODO: AUTO-CRIAR" "Yellow"
    [[ "$CLEAN_CACHE" == "true" ]] && write_color_output "  MODO: LIMPEZA-CACHE" "Yellow"
    echo ""
}

# ===========================================================
# 🚀 Função: sync_folders
# ===========================================================
sync_folders() {
    write_color_output "[INICIANDO SINCRONIZAÇÃO]" "Magenta"

    [[ "$CLEAN_CACHE" == "true" ]] && cleanup_rclone_cache && echo ""

    # --- Validações ---
    [[ ! -d "$LOCAL_FOLDER" ]] && exit_with_error "Pasta local não existe: $LOCAL_FOLDER"
    ! command -v rclone &>/dev/null && exit_with_error "rclone não encontrado."

    # ----------------------------------------------------------
    # ✅ Garante que a pasta base remota "rclone/" existe
    # ----------------------------------------------------------
    if ! rclone lsd "$REMOTE_NAME:$BASE_REMOTE_FOLDER" &>/dev/null; then
        write_color_output "🆕 Criando pasta base remota '$BASE_REMOTE_FOLDER/'..." "Blue"
        rclone mkdir "$REMOTE_NAME:$BASE_REMOTE_FOLDER" &>/dev/null \
            && write_color_output "✅ Pasta base criada: $REMOTE_NAME:$BASE_REMOTE_FOLDER" "Green" \
            || exit_with_error "Falha ao criar pasta base remota."
    fi

    # ----------------------------------------------------------
    # ✅ Garante que a pasta base de backups "rclone.deleted/" existe
    # ----------------------------------------------------------
    if ! rclone lsd "$REMOTE_NAME:$DELETED_BASE_FOLDER" &>/dev/null; then
        write_color_output "🆕 Criando pasta de backups '$DELETED_BASE_FOLDER/'..." "Blue"
        rclone mkdir "$REMOTE_NAME:$DELETED_BASE_FOLDER" &>/dev/null \
            && write_color_output "✅ Pasta de backup criada: $REMOTE_NAME:$DELETED_BASE_FOLDER" "Green" \
            || exit_with_error "Falha ao criar pasta base de backups."
    fi

    # ----------------------------------------------------------
    # 🗂️ Define caminhos finais
    # ----------------------------------------------------------
    local TARGET_REMOTE_PATH="${BASE_REMOTE_FOLDER}/${REMOTE_FOLDER}"
    local TODAY=$(date +"%Y-%m-%d")
    local DELETED_REMOTE_FOLDER="${DELETED_BASE_FOLDER}/${REMOTE_FOLDER}/${TODAY}"

    write_color_output "🔍 Verificando pasta remota: $REMOTE_NAME:$TARGET_REMOTE_PATH" "Cyan"
    if ! rclone lsd "$REMOTE_NAME:$TARGET_REMOTE_PATH" --max-depth 1 &>/dev/null; then
        write_color_output "⚠️  Pasta remota não existe: $REMOTE_NAME:$TARGET_REMOTE_PATH" "Yellow"
        write_color_output "🆕 Criando automaticamente..." "Blue"
        rclone mkdir "$REMOTE_NAME:$TARGET_REMOTE_PATH" &>/dev/null \
            && write_color_output "✅ Pasta remota criada: $REMOTE_NAME:$TARGET_REMOTE_PATH" "Green" \
            || exit_with_error "Falha ao criar pasta remota: $TARGET_REMOTE_PATH"
    fi

    # ----------------------------------------------------------
    # 🧾 Ambiente de log
    # ----------------------------------------------------------
    local BASENAME_FOLDER="$(basename "$LOCAL_FOLDER")"
    local LOG_DIR="$HOME/${BASENAME_FOLDER}_rclone_log"
    ensure_directory "$LOG_DIR"
    local timestamp=$(date +"%Y%m%d-%H%M%S")
    local log_file="$LOG_DIR/sync-$timestamp.log"

    echo "------------------------------------------------------"
    echo "📂 Local : $LOCAL_FOLDER"
    echo "☁️  Remoto: $REMOTE_NAME:$TARGET_REMOTE_PATH"
    echo "🗑️  Backup: $REMOTE_NAME:$DELETED_REMOTE_FOLDER"
    echo "📜 Log: $log_file"
    echo "------------------------------------------------------"
    echo ""

    # ----------------------------------------------------------
    # 🧾 Exclusões via variável de ambiente
    # ----------------------------------------------------------
    [[ -n "$RCLONE_EXCLUDE_FILE" && -f "$RCLONE_EXCLUDE_FILE" ]] \
        && write_color_output "🚫 Aplicando exclusões: $RCLONE_EXCLUDE_FILE" "Yellow" \
        && EXCLUDE_FROM_ARGS=(--exclude-from "$RCLONE_EXCLUDE_FILE") \
        || EXCLUDE_FROM_ARGS=()

    # ----------------------------------------------------------
    # ⚙️ Monta argumentos Rclone
    # ----------------------------------------------------------
    local rclone_args=(
        "sync"
        "$LOCAL_FOLDER"
        "$REMOTE_NAME:$TARGET_REMOTE_PATH"
        "--backup-dir" "$REMOTE_NAME:$DELETED_REMOTE_FOLDER"
        "--fast-list"
        "--transfers" "4"
        "--checkers" "8"
        "--delete-after"
        "--log-file" "$log_file"
        "--stats" "30s"
        "--stats-file-name-length" "0"
    )

    [[ "$VERBOSE" == "true" ]] && rclone_args+=("--verbose") || rclone_args+=("--log-level" "INFO")
    [[ "$DRY_RUN" == "true" ]] && rclone_args+=("--dry-run") && write_color_output "🔍 MODO SIMULAÇÃO ATIVADO" "Yellow"
    [[ "$RESYNC" == "true" ]] && rclone_args+=("--resync") && write_color_output "🔄 RESSINCRONIZAÇÃO COMPLETA" "Yellow"

    # ----------------------------------------------------------
    # ▶️ Executa sincronização
    # ----------------------------------------------------------
    local start_epoch=$(date +%s)
    write_color_output "🚀 Executando sincronização..." "Cyan"
    write_color_output "Comando completo: rclone ${rclone_args[*]} ${EXCLUDE_FROM_ARGS[*]}" "Blue"

    local exit_code=0
    rclone "${rclone_args[@]}" "${EXCLUDE_FROM_ARGS[@]}" || exit_code=$?

    local duration=$(( $(date +%s) - start_epoch ))
    local completion_msg="Tempo total: $((duration/60))m $((duration%60))s — Código: $exit_code"

    if [[ $exit_code -eq 0 ]]; then
        write_color_output "✅ Sincronização concluída com sucesso!" "Green"
    else
        write_color_output "❌ Erro durante sincronização!" "Red"
    fi
    write_color_output "📦 $completion_msg" "Blue"
    write_color_output "📜 Log salvo em: $log_file" "Cyan"

    # ----------------------------------------------------------
    # 🧹 Limpeza de logs
    # ----------------------------------------------------------
    write_color_output "🧹 Limpando logs antigos..." "Cyan"
    find "$LOG_DIR" -type f -name "sync-*.log" -mtime "+$ZIP_AFTER_DAYS" -exec gzip {} \; 2>/dev/null
    find "$LOG_DIR" -type f -name "sync-*.log*" -mtime "+$LOG_RETENTION_DAYS" -delete 2>/dev/null

    write_color_output "🗂️  Itens removidos foram movidos para: $REMOTE_NAME:$DELETED_REMOTE_FOLDER" "Blue"
    write_color_output "✅ Nenhum arquivo foi excluído definitivamente." "Green"
}

# ===========================================================
# 🧩 Função: main
# ===========================================================
main() {
    parse_parameters "$@"
    [[ "$SHOW_HELP" == "true" ]] && show_help && exit 0

    show_configuration
    if check_prerequisites; then
        sync_folders
    else
        exit_with_error "Pré-requisitos não atendidos."
    fi
}

# ===========================================================
# ▶️ Execução direta
# ===========================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Sync.sh
# ===========================================================
