#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Sync.sh
# Função: Executa a sincronização principal via Rclone e controla logs e backups
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém as funções que realizam a sincronização real entre
# a pasta local e o Google Drive utilizando o Rclone.
#
# Funções incluídas neste módulo:
#   • show_configuration       → Mostra os parâmetros e modos atuais
#   • sync_folders             → Executa a sincronização (rclone sync)
#   • main                     → Função principal que integra todos os módulos
#
# Dependências:
#   👉 Usa funções de utilidade do CopyToGDriver_Utils.sh
#   👉 Depende de variáveis do CopyToGDriver_Config.sh
#   👉 Usa verificações de CopyToGDriver_Checks.sh
#   👉 Pode utilizar funções auxiliares de CopyToGDriver_Cache.sh e Setup.sh
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
# 🧩 Função: show_configuration
# ===========================================================
# Mostra a configuração atual e os modos ativos (dry-run, verbose, etc.)
# Texto original inicia em: "show_configuration() {" 
# e termina antes de "sync_folders()"
# ===========================================================
show_configuration() {
    write_color_output "[CONFIGURACAO ATUAL]" "Cyan"
    echo "  Pasta Local:      $LOCAL_FOLDER"
    echo "  Remote:           $REMOTE_NAME"
    echo "  Pasta Remota:     '$REMOTE_FOLDER'"
    
    # Mostrar informações contextuais baseadas no valor de REMOTE_FOLDER
    if [[ -n "$REMOTE_FOLDER" && "$REMOTE_FOLDER" != "/" ]]; then
        echo "  ID da Pasta:      ${REMOTE_FOLDER##*/}"
        echo "  Link Google Drive: https://drive.google.com/drive/folders/${REMOTE_FOLDER##*/}"
    else
        echo "  ID da Pasta:      (pasta raiz)"
        echo "  Link Google Drive: https://drive.google.com/drive"
    fi
    
    echo "  Retencao Logs:    $LOG_RETENTION_DAYS dias"
    echo "  Compactar Logs:   apos $ZIP_AFTER_DAYS dias"
    echo "  Diretorio Sync:   $SYNC_ROOT"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        write_color_output "  MODO:              SIMULACAO" "Yellow"
    fi
    if [[ "$RESYNC" == "true" ]]; then
        write_color_output "  MODO:              RESSINCRONIZACAO" "Yellow"
    fi
    if [[ "$VERBOSE" == "true" ]]; then
        write_color_output "  MODO:              VERBOSO" "Yellow"
    fi
    if [[ "$AUTO_CREATE" == "true" ]]; then
        write_color_output "  MODO:              AUTO-CRIAR" "Yellow"
    fi
    if [[ "$CLEAN_CACHE" == "true" ]]; then
        write_color_output "  MODO:              LIMPEZA-CACHE" "Yellow"
    fi
    echo ""
}


# ===========================================================
# 🚀 Função: sync_folders
# ===========================================================
# Executa a sincronização principal via Rclone, incluindo:
#   - Criação da pasta base remota "rclone/"
#   - Verificação/criação da pasta remota principal
#   - Aplicação de exclusões
#   - Execução do comando `rclone sync`
#   - Criação de logs, backups e limpeza posterior
#
# Texto original inicia em: "sync_folders() {" 
# e termina antes de "main()"
# ===========================================================
sync_folders() {
    write_color_output "[INICIANDO SINCRONIZACAO]" "Magenta"
    
    # Limpar cache se solicitado
    if [[ "$CLEAN_CACHE" == "true" ]]; then
        cleanup_rclone_cache
        echo ""
    fi

    # Validacoes finais
    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "❌ Pasta local não existe: $LOCAL_FOLDER" "Red"
        exit 1
    fi

    if ! command -v rclone &> /dev/null; then
        write_color_output "❌ rclone não encontrado" "Red"
        exit 1
    fi

    # --------------------------------------------------------------
    # ✅ Garante que a pasta base "rclone/" existe no remoto
    # --------------------------------------------------------------
    if ! rclone lsd "$REMOTE_NAME:rclone" &>/dev/null; then
        write_color_output "🆕 Criando pasta base remota 'rclone/'..." "Blue"
        if rclone mkdir "$REMOTE_NAME:rclone" &>/dev/null; then
            write_color_output "✅ Pasta base criada: $REMOTE_NAME:rclone" "Green"
        else
            write_color_output "❌ Falha ao criar pasta base remota" "Red"
            exit 1
        fi
    fi

    # --------------------------------------------------------------
    # ✅ Verifica e cria automaticamente a pasta remota principal
    # --------------------------------------------------------------
    write_color_output "🔍 Verificando pasta remota: $REMOTE_NAME:$REMOTE_FOLDER" "Cyan"
    if ! rclone lsd "$REMOTE_NAME:$REMOTE_FOLDER" --max-depth 1 &>/dev/null; then
        write_color_output "⚠️  Pasta remota não existe: $REMOTE_NAME:$REMOTE_FOLDER" "Yellow"
        write_color_output "🆕 Criando automaticamente..." "Blue"
        if rclone mkdir "$REMOTE_NAME:$REMOTE_FOLDER" &>/dev/null; then
            write_color_output "✅ Pasta remota criada com sucesso: $REMOTE_NAME:$REMOTE_FOLDER" "Green"
        else
            write_color_output "❌ Falha ao criar pasta remota: $REMOTE_NAME:$REMOTE_FOLDER" "Red"
            exit 1
        fi
    else
        write_color_output "📁 Pasta remota já existe: $REMOTE_NAME:$REMOTE_FOLDER" "Green"
    fi

    # --------------------------------------------------------------
    # 🗂️ Preparar ambiente de log e backup
    # --------------------------------------------------------------
    local BASENAME_FOLDER="$(basename "$LOCAL_FOLDER")"
    local LOG_DIR="$HOME/${BASENAME_FOLDER}_rclone_log"
    local HISTORY_CSV="$LOG_DIR/SyncHistory.csv"
    local TODAY=$(date +"%Y-%m-%d")

    ensure_directory "$LOG_DIR"
    local timestamp=$(date +"%Y%m%d-%H%M%S")
    local log_file="$LOG_DIR/sync-$timestamp.log"

    # Cria pasta de backup remoto para arquivos removidos
    local DELETED_REMOTE_FOLDER="$REMOTE_FOLDER/.deleted/$TODAY"

    echo "------------------------------------------------------"
    echo "📂 Local : $LOCAL_FOLDER"
    echo "☁️  Remoto: $REMOTE_NAME:$REMOTE_FOLDER"
    echo "🗑️  Backup de removidos: $REMOTE_NAME:$DELETED_REMOTE_FOLDER"
    echo "📜 Log: $log_file"
    echo "------------------------------------------------------"
    echo ""

    # --------------------------------------------------------------
    # 🧾 Arquivo de exclusões via variável de ambiente (opcional)
    # --------------------------------------------------------------
    if [[ -n "$RCLONE_EXCLUDE_FILE" && -f "$RCLONE_EXCLUDE_FILE" ]]; then
        write_color_output "🚫 Aplicando exclusões do arquivo: $RCLONE_EXCLUDE_FILE" "Yellow"
        EXCLUDE_FROM_ARGS=(--exclude-from "$RCLONE_EXCLUDE_FILE")
    else
        EXCLUDE_FROM_ARGS=()
    fi



    # --------------------------------------------------------------
    # ⚙️ Monta argumentos do Rclone
    # --------------------------------------------------------------
    local rclone_args=(
        "sync"
        "$LOCAL_FOLDER"
        "$REMOTE_NAME:$REMOTE_FOLDER"
        "--backup-dir" "$REMOTE_NAME:$DELETED_REMOTE_FOLDER"
        "--fast-list"
        "--transfers" "4"
        "--checkers" "8"
        "--delete-after"
        "--log-file" "$log_file"
        "--stats" "30s"
        "--stats-file-name-length" "0"
    )

    # Verbosidade
    if [[ "$VERBOSE" == "true" ]]; then
        rclone_args+=("--verbose")
    else
        rclone_args+=("--log-level" "INFO")
    fi

    # Simulação
    if [[ "$DRY_RUN" == "true" ]]; then
        rclone_args+=("--dry-run")
        write_color_output "🔍 MODO SIMULAÇÃO ATIVADO — Nenhum arquivo será alterado." "Yellow"
    fi

    # Ressincronização
    if [[ "$RESYNC" == "true" ]]; then
        rclone_args+=("--resync")
        write_color_output "🔄 Ressincronização completa habilitada (--resync)" "Yellow"
    fi

    # --------------------------------------------------------------
    # ▶️ Execução do Rclone
    # --------------------------------------------------------------
    local start_time=$(date +"%Y-%m-%d %H:%M:%S")
    local start_epoch=$(date +%s)

    write_color_output "🚀 Executando sincronização..." "Cyan"
    write_color_output "Comando completo: rclone ${rclone_args[*]} ${EXCLUDE_FROM_ARGS[*]}" "Blue"


    local exit_code=0
    if rclone "${rclone_args[@]}" "${EXCLUDE_FROM_ARGS[@]}"; then
        exit_code=0
    else
        exit_code=$?
    fi

    local end_time=$(date +"%Y-%m-%d %H:%M:%S")
    local end_epoch=$(date +%s)
    local duration=$((end_epoch - start_epoch))

    # --------------------------------------------------------------
    # 📈 Resultado
    # --------------------------------------------------------------
    local completion_msg="Tempo total: $((duration / 60))m $((duration % 60))s — Código de saída: $exit_code"
    if [[ $exit_code -eq 0 ]]; then
        write_color_output "✅ Sincronização concluída com sucesso!" "Green"
        write_color_output "📦 $completion_msg" "Blue"
    else
        write_color_output "❌ Erro durante a sincronização!" "Red"
        write_color_output "📦 $completion_msg" "Yellow"
        write_color_output "Verifique o log: $log_file" "Cyan"
    fi

    echo "📜 Log salvo em: $log_file"

    # --------------------------------------------------------------
    # 🧹 Limpeza e manutenção de logs
    # --------------------------------------------------------------
    write_color_output "🧹 Limpando logs antigos e compactando antigos..." "Cyan"

    # Compacta logs com mais de X dias
    find "$LOG_DIR" -name "sync-*.log" -type f -mtime "+$ZIP_AFTER_DAYS" 2>/dev/null | while read -r file; do
        local zip_file="$file.gz"
        if [[ ! -f "$zip_file" ]]; then
            if gzip -c "$file" > "$zip_file" 2>/dev/null; then
                rm -f "$file"
                echo "    Compactado: $(basename "$file")"
            fi
        fi
    done

    # Remove logs antigos
    find "$LOG_DIR" -type f -name "sync-*.log*" -mtime "+$LOG_RETENTION_DAYS" -delete 2>/dev/null

    write_color_output "🗂️  Itens removidos foram movidos para: $REMOTE_NAME:$DELETED_REMOTE_FOLDER" "Blue"
    write_color_output "✅ Nenhum arquivo foi excluído definitivamente." "Green"
}


# ===========================================================
# 🧩 Função: main
# ===========================================================
# Função principal que:
#   - Interpreta os parâmetros
#   - Mostra a configuração
#   - Executa as verificações de ambiente
#   - Chama a sincronização
#
# Texto original inicia em: "main() {" 
# e termina antes da linha:
#   "if [[ \"\${BASH_SOURCE[0]}\" == \"\${0}\" ]]; then"
# ===========================================================
main() {
    parse_parameters "$@"
    
    # Se help foi solicitado, mostrar e sair
    if [[ "$SHOW_HELP" == "true" ]]; then
        show_help
        exit 0
    fi
    
    show_configuration
    
    if check_prerequisites; then
        sync_folders
    else
        write_color_output "[ERRO] Pré-requisitos não atendidos" "Red"
        exit 1
    fi
}



# ===========================================================
# ▶️ Execução direta
# ===========================================================
# Permite executar o módulo diretamente pela linha de comando.
# ===========================================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi


# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Sync.sh
# ===========================================================
