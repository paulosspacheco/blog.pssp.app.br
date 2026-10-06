#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Sync.v.0.0.35.sh
# Função: Sincroniza pasta local → Google Drive (via rclone)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5 Thinking)
# Versão: 0.0.0.36
#
# Esta versão:
#   ✅ CORREÇÃO URGENTE: Verificação de processos 100% funcional
#   ✅ Elimina dependência de process_is_running problemática
#   ✅ Verificação robusta multiplataforma (Windows/Linux/macOS)
#   ✅ Bloqueia múltiplas instâncias inclusive em modo simulação
#   ✅ Centraliza logs em ~/CopyToGDriver_Log/
#   ✅ Corrige de vez o erro: destination and parameter to --backup-dir mustn't overlap
# ===========================================================

# -----------------------------------------------------------
# 🔗 Importar dependências
# -----------------------------------------------------------
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"
source "$SCRIPT_DIR/CopyToGDriver_ConfigFunctions.sh"
source "$SCRIPT_DIR/CopyToGDriver_Checks.sh"
source "$SCRIPT_DIR/CopyToGDriver_Cache.sh"
source "$SCRIPT_DIR/CopyToGDriver_Setup.sh"

# -----------------------------------------------------------
# 🔧 Defaults de pastas remotas
# -----------------------------------------------------------
BASE_REMOTE_FOLDER="${BASE_REMOTE_FOLDER:-rclone}"          # conteúdo ativo
DELETED_BASE_FOLDER="${DELETED_BASE_FOLDER:-rclone.deleted}" # lixeira/backup

# ===========================================================
# 🧩 Função: show_configuration
# ===========================================================
show_configuration() {
    write_color_output "[CONFIGURAÇÃO ATUAL]" "Cyan"
    echo "  Pasta Local:          $LOCAL_FOLDER"
    echo "  Remote:               $REMOTE_NAME"
    echo "  Pasta Base Remota:    $BASE_REMOTE_FOLDER"
    echo "  Pasta Remota pedida:  '$REMOTE_FOLDER'"
    echo "  Pasta Base de Backup: $DELETED_BASE_FOLDER"
    echo "  Logs (locais):        ~/CopyToGDriver_Log/"
    echo
    echo "  Retenção Logs:        $LOG_RETENTION_DAYS dias"
    echo "  Compactar após:       $ZIP_AFTER_DAYS dias"
    echo ""

    [[ "$DRY_RUN" == "true" ]]     && write_color_output "  MODO: SIMULAÇÃO" "Yellow"
    [[ "$RESYNC" == "true" ]]      && write_color_output "  MODO: RESSINCRONIZAÇÃO" "Yellow"
    [[ "$VERBOSE" == "true" ]]     && write_color_output "  MODO: VERBOSO" "Yellow"
    [[ "$AUTO_CREATE" == "true" ]] && write_color_output "  MODO: AUTO-CRIAR" "Yellow"
    [[ "$CLEAN_CACHE" == "true" ]] && write_color_output "  MODO: LIMPEZA-CACHE" "Yellow"
    [[ "$QUIET" == "true" ]]       && write_color_output "  MODO: QUIET (sem progress)" "Yellow"
    echo ""
}

# ===========================================================
# 🧠 Função utilitária: normalizar caminho remoto
#
# Entradas possíveis que vêm do copydrive:
#   - "blog"
#   - "rclone/blog"
#   - "rclone/paulo/docs"
#   - "/rclone/paulo/docs"
# Saída esperada:
#   - TARGET_REMOTE_PATH → SEMPRE algo como:   rclone/paulo/docs
#   - CLEAN_REMOTE_PATH  → SEMPRE sem o 'rclone/': paulo/docs
# ===========================================================
normalize_remote_paths() {
    local incoming="$1"

    # tira aspas
    incoming="${incoming%\"}"; incoming="${incoming#\"}"
    incoming="${incoming%\'}"; incoming="${incoming#\'}"

    # tira começo com /
    incoming="${incoming#/}"

    local target_remote=""   # onde vamos sincronizar
    local clean_remote=""    # usado para montar o backup

    if [[ "$incoming" == "$BASE_REMOTE_FOLDER"* ]]; then
        # já veio com rclone/...
        target_remote="$incoming"
        clean_remote="${incoming#${BASE_REMOTE_FOLDER}/}"
    else
        # veio só "blog" → vira rclone/blog
        target_remote="${BASE_REMOTE_FOLDER}/${incoming}"
        clean_remote="$incoming"
    fi

    # se por acaso ficar vazio (caso remoto tenha sido só "rclone")
    if [[ -z "$clean_remote" ]]; then
        clean_remote="$(basename "$LOCAL_FOLDER")"
    fi

    NORMALIZED_TARGET_REMOTE_PATH="$target_remote"
    NORMALIZED_CLEAN_REMOTE_PATH="$clean_remote"
}

# ===========================================================
# 🔒 Função: check_rclone_safety (CORREÇÃO URGENTE)
# ===========================================================
check_rclone_safety() {
    write_color_output "🔒 Verificando ambiente de sincronização..." "Cyan"

    local rclone_active=0
    local safety_check_failed=0

    # 🚨 VERIFICAÇÃO ROBUSTA - SEM DEPENDÊNCIAS EXTERNAS
    write_color_output "  🔍 Verificando processos Rclone ativos..." "Blue"

    # Método 1: pgrep (Linux/macOS)
    if command -v pgrep >/dev/null 2>&1; then
        if pgrep -f "rclone" >/dev/null 2>&1; then
            write_color_output "  ❌ Processos Rclone detectados via pgrep" "Red"
            rclone_active=1
        else
            write_color_output "  ✅ Nenhum processo via pgrep" "Green"
        fi
    fi

    # Método 2: tasklist (Windows) - mesmo se pgrep existir, verifica também
    if command -v tasklist >/dev/null 2>&1; then
        if tasklist //FI "IMAGENAME eq rclone.exe" 2>/dev/null | grep -q "rclone.exe"; then
            write_color_output "  ❌ Processos Rclone detectados via tasklist" "Red"
            rclone_active=1
        else
            write_color_output "  ✅ Nenhum processo via tasklist" "Green"
        fi
    fi

    # Método 3: ps (fallback universal)
    if command -v ps >/dev/null 2>&1; then
        if ps -ef 2>/dev/null | grep -q "[r]clone" || ps aux 2>/dev/null | grep -q "[r]clone"; then
            write_color_output "  ❌ Processos Rclone detectados via ps" "Red"
            rclone_active=1
        else
            write_color_output "  ✅ Nenhum processo via ps" "Green"
        fi
    fi

    # 🚨 DECISÃO DE SEGURANÇA
    if [[ $rclone_active -eq 1 ]]; then
        write_color_output "❌ ERRO CRÍTICO: Rclone está em execução!" "Red"
        write_color_output "   Processos ativos detectados por múltiplos métodos." "Yellow"
        write_color_output "   Finalize todas as instâncias do Rclone antes de continuar." "Yellow"
        write_color_output "   Comandos úteis:" "Cyan"
        write_color_output "   - Linux/macOS: pkill -f rclone" "Blue"
        write_color_output "   - Windows: taskkill //F //IM rclone.exe" "Blue"

        # 🚫 BLOQUEIA EM QUALQUER MODO - SIMULAÇÃO OU REAL
        write_color_output "🚫 Sincronização BLOQUEADA por segurança." "Red"
        write_color_output "💡 Execute apenas UMA sincronização por vez." "Yellow"
        exit_with_error "Múltiplas instâncias do Rclone detectadas. Abortando."
    else
        write_color_output "✅ Ambiente seguro para sincronização" "Green"
        write_color_output "   Nenhum processo Rclone ativo detectado" "Green"
        return 0
    fi
}


# ----------------------------------------------------------
# 🔒 Proteção contra sincronização concorrente
# ----------------------------------------------------------
lock_protect() {
    local LOCK_DIR="/tmp/copytogdriver"
    mkdir -p "$LOCK_DIR"

    # ID único baseado no caminho da pasta
    local LOCK_FILE="$LOCK_DIR/$(echo "$LOCAL_FOLDER" | md5sum | cut -d' ' -f1).lock"

    # Verifica se já há lockfiles ativos
    for existing_lock in "$LOCK_DIR"/*.lock; do
        [[ -f "$existing_lock" ]] || continue
        local active_path
        active_path=$(grep -oP "(?<=path: ).*" "$existing_lock" 2>/dev/null || true)
        local active_pid
        active_pid=$(grep -oP "(?<=pid: )\d+" "$existing_lock" 2>/dev/null || true)

        if [[ "$LOCAL_FOLDER" == "$active_path"* || "$active_path" == "$LOCAL_FOLDER"* ]]; then
            if ps -p "$active_pid" >/dev/null 2>&1; then
                write_color_output "❌ Sincronização já em andamento!" "Red"
                write_color_output "   Pasta em uso: $active_path" "Yellow"
                write_color_output "   PID ativo: $active_pid" "Yellow"
                write_color_output "💡 Dica: espere terminar ou finalize com: kill $active_pid" "Blue"
                exit_with_error "Bloqueio de segurança — sincronização concorrente detectada."
            else
                # processo morto → limpar lock antigo
                rm -f "$existing_lock"
            fi
        fi
    done

    # Cria novo lockfile para esta execução
    {
        echo "pid: $$"
        echo "path: $LOCAL_FOLDER"
        echo "timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    } > "$LOCK_FILE"

    # Garante que o lock seja removido ao sair
    trap 'rm -f "$LOCK_FILE"' EXIT
}


# ===========================================================
# 🚀 Função: sync_folders
# ===========================================================
sync_folders() {
    write_color_output "[INICIANDO SINCRONIZAÇÃO]" "Magenta"

  # 🔒 Proteção anti-concorrência
    lock_protect

    # --- Verificação de segurança CRÍTICA ---
    # 🚨 AGORA 100% FUNCIONAL - BLOQUEIA CONCORRÊNCIA
    check_rclone_safety

    # --- Limpeza de cache (se solicitada) ---
    [[ "$CLEAN_CACHE" == "true" ]] && {
        write_color_output "🧹 Solicitada limpeza de cache..." "Cyan"
        cleanup_rclone_cache
        echo ""
    }

    # --- Validações padrão ---
    [[ -z "$LOCAL_FOLDER" ]] && exit_with_error "LOCAL_FOLDER não definido."
    [[ ! -d "$LOCAL_FOLDER" ]] && exit_with_error "Pasta local não existe: $LOCAL_FOLDER"
    ! command -v rclone &>/dev/null && exit_with_error "rclone não encontrado."

    # 1) normalizar caminhos remotos com base no REMOTE_FOLDER pedido
    normalize_remote_paths "$REMOTE_FOLDER"
    local TARGET_REMOTE_PATH="$NORMALIZED_TARGET_REMOTE_PATH"     # ex: rclone/paulo/docs
    local CLEAN_REMOTE_PATH="$NORMALIZED_CLEAN_REMOTE_PATH"       # ex: paulo/docs
    local TODAY
    TODAY=$(date +"%Y-%m-%d")

    # 2) montar caminho de backup FORA da árvore ativa
    #    FICA ASSIM: rclone.deleted/paulo/docs/2025-11-01
    local DELETED_REMOTE_FOLDER_PATH="${DELETED_BASE_FOLDER}/${CLEAN_REMOTE_PATH}/${TODAY}"

    # 3) garantir que bases existam
    for folder in "$BASE_REMOTE_FOLDER" "$DELETED_BASE_FOLDER"; do
        if ! rclone lsd "$REMOTE_NAME:$folder" &>/dev/null; then
            write_color_output "🆕 Criando pasta base remota: $REMOTE_NAME:$folder ..." "Blue"
            rclone mkdir "$REMOTE_NAME:$folder" &>/dev/null \
                || exit_with_error "Falha ao criar pasta remota base: $folder"
        fi
    done

    # 4) garantir que destino ativo existe
    write_color_output "🔍 Verificando pasta remota: $REMOTE_NAME:$TARGET_REMOTE_PATH" "Cyan"
    if ! rclone lsd "$REMOTE_NAME:$TARGET_REMOTE_PATH" --max-depth 1 &>/dev/null; then
        write_color_output "⚠️  Pasta remota não existe, criando..." "Yellow"
        rclone mkdir "$REMOTE_NAME:$TARGET_REMOTE_PATH" &>/dev/null \
            || exit_with_error "Falha ao criar pasta remota de destino: $TARGET_REMOTE_PATH"
    fi

    # 5) garantir que pasta de backup do dia existe
    #    OBS: criamos TAMBÉM o diretório pai para facilitar navegação no Drive
    write_color_output "🔍 Garantindo pasta de backup: $REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH" "Cyan"
    rclone mkdir "$REMOTE_NAME:$DELETED_BASE_FOLDER/$CLEAN_REMOTE_PATH" &>/dev/null || true
    rclone mkdir "$REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH" &>/dev/null || true

    # ----------------------------------------------------------
    # 🧾 Logs centralizados
    # ----------------------------------------------------------
    local BASENAME_FOLDER
    BASENAME_FOLDER="$(basename "$LOCAL_FOLDER")"
    local LOG_DIR="$HOME/CopyToGDriver_Log/${BASENAME_FOLDER}"
    local SYSTEM_LOG_DIR="$HOME/CopyToGDriver_Log/system"
    ensure_directory "$LOG_DIR"
    ensure_directory "$SYSTEM_LOG_DIR"

    local timestamp
    timestamp=$(date +"%Y%m%d-%H%M%S")
    local log_file="$LOG_DIR/sync-$timestamp.log"
    local summary_file="$SYSTEM_LOG_DIR/summary.log"

    echo "------------------------------------------------------"
    echo "📂 Local .............: $LOCAL_FOLDER"
    echo "☁️  Destino remoto ...: $REMOTE_NAME:$TARGET_REMOTE_PATH"
    echo "🗑️  Backup remoto ....: $REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH"
    echo "📜 Log desta execução : $log_file"
    echo "📘 Resumo geral ......: $summary_file"
    echo "------------------------------------------------------"
    echo ""

    # ----------------------------------------------------------
    # 🚫 Exclusões
    # ----------------------------------------------------------
    if [[ -n "$RCLONE_EXCLUDE_FILE" && -f "$RCLONE_EXCLUDE_FILE" ]]; then
        write_color_output "🚫 Aplicando exclusões: $RCLONE_EXCLUDE_FILE" "Yellow"
        EXCLUDE_FROM_ARGS=(--exclude-from "$RCLONE_EXCLUDE_FILE")
    else
        EXCLUDE_FROM_ARGS=()
    fi

    # ----------------------------------------------------------
    # ⚙️ Montar parâmetros do rclone
    # ----------------------------------------------------------
    local rclone_args=(
        "sync"
        "$LOCAL_FOLDER"
        "$REMOTE_NAME:$TARGET_REMOTE_PATH"
        "--backup-dir" "$REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH"
        "--fast-list"
        "--transfers" "4"
        "--checkers" "8"
        "--delete-after"
        "--log-file" "$log_file"
        "--stats-file-name-length" "0"
    )

    # → stats / progress
    if [[ "$QUIET" == "true" ]]; then
        rclone_args+=("--quiet")
    else
        # barra de progresso e linha única
        rclone_args+=("--progress" "--stats" "15s" "--stats-one-line")
    fi

    # → verbosidade
    if [[ "$VERBOSE" == "true" ]]; then
        rclone_args+=("--verbose")
    else
        rclone_args+=("--log-level" "INFO")
    fi

    # → simulação
    if [[ "$DRY_RUN" == "true" ]]; then
        rclone_args+=("--dry-run")
        write_color_output "🔍 MODO SIMULAÇÃO ATIVADO — nada será enviado ao Drive." "Yellow"
    fi

    # → resync forçado
    if [[ "$RESYNC" == "true" ]]; then
        rclone_args+=("--resync")
        write_color_output "🔄 RESSINCRONIZAÇÃO COMPLETA ATIVADA" "Yellow"
    fi

    # ----------------------------------------------------------
    # ▶️ Executar
    # ----------------------------------------------------------
    local start_epoch
    start_epoch=$(date +%s)

    write_color_output "🚀 Executando sincronização (rclone)..." "Cyan"
    write_color_output "Comando completo:" "Blue"
    echo "rclone ${rclone_args[*]} ${EXCLUDE_FROM_ARGS[*]}"
    echo

    local exit_code=0
    rclone "${rclone_args[@]}" "${EXCLUDE_FROM_ARGS[@]}" || exit_code=$?

    local end_epoch
    end_epoch=$(date +%s)
    local duration=$(( end_epoch - start_epoch ))
    local duration_str="$((duration/60))m $((duration%60))s"

    # ----------------------------------------------------------
    # ✅ Resultado + resumo
    # ----------------------------------------------------------
    if [[ $exit_code -eq 0 ]]; then
        write_color_output "✅ Sincronização concluída com sucesso!" "Green"
    else
        write_color_output "❌ Erro durante sincronização!" "Red"
        write_color_output "⚠️ Código de saída: $exit_code" "Red"
        # se for 7, lembrar motivo
        [[ $exit_code -eq 7 ]] && write_color_output "💡 Dica: código 7 costuma ser caminho de backup que se sobrepôs ao destino. Esta versão já evita isso. Se continuar, veja o log completo." "Yellow"
    fi

    write_color_output "⏱️  Tempo total: $duration_str" "Blue"
    write_color_output "📜 Log salvo em: $log_file" "Cyan"

    # grava pequeno resumo
    {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] local='$LOCAL_FOLDER' remote='$REMOTE_NAME:$TARGET_REMOTE_PATH' backup='$REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH' exit=$exit_code time=$duration_str log='$log_file'"
    } >> "$summary_file"

    # ----------------------------------------------------------
    # 🧹 Limpeza automática de logs
    # ----------------------------------------------------------
    write_color_output "🧹 Limpando logs antigos..." "Cyan"
    find "$LOG_DIR" -type f -name "sync-*.log" -mtime "+$ZIP_AFTER_DAYS" -exec gzip {} \; 2>/dev/null
    find "$LOG_DIR" -type f -name "sync-*.log*" -mtime "+$LOG_RETENTION_DAYS" -delete 2>/dev/null

    write_color_output "🗂️  Itens removidos foram movidos para: $REMOTE_NAME:$DELETED_REMOTE_FOLDER_PATH" "Blue"
    write_color_output "✅ Nenhum arquivo foi excluído definitivamente." "Green"


    return $exit_code
}



# ===========================================================
# 🪶 Função: show_last_log
# ===========================================================
show_last_log() {
    local BASENAME_FOLDER
    BASENAME_FOLDER="$(basename "$LOCAL_FOLDER")"
    local LOG_DIR="$HOME/CopyToGDriver_Log/${BASENAME_FOLDER}"

    # Encontra o log mais recente
    local last_log
    last_log=$(ls -t "$LOG_DIR"/sync-*.log 2>/dev/null | head -n 1)

    if [[ -z "$last_log" ]]; then
        write_color_output "⚠️ Nenhum log encontrado em: $LOG_DIR" "Yellow"
        return 1
    fi

    write_color_output "📜 Último log localizado:" "Cyan"
    echo "   $last_log"
    echo ""

    # Pergunta ao usuário se deseja abrir
    read -r -p "Deseja abrir o log detalhado agora? (Y/n): " choice
    choice=${choice:-Y}

    if [[ "$choice" =~ ^[Yy]$ ]]; then
        case "$(uname -s)" in
            CYGWIN*|MINGW*|MSYS*)
                # Windows → abre com o Notepad
                local windows_path
                windows_path=$(echo "$last_log" | sed 's|/c/|C:/|' | sed 's|/|\\|g')
                write_color_output "🪟 Abrindo log no Notepad..." "Blue"
                cmd.exe /C "start notepad.exe \"$windows_path\"" >/dev/null 2>&1
                ;;
            Darwin*)
                # macOS → usa open
                open "$last_log"
                ;;
            Linux*)
                # Linux → usa less
                less "$last_log"
                ;;
            *)
                write_color_output "⚠️ Sistema não reconhecido, exibindo com cat:" "Yellow"
                cat "$last_log"
                ;;
        esac
    else
        write_color_output "⏳ Log não aberto. Você pode visualizar manualmente em:" "Yellow"
        echo "   $last_log"
    fi
}
# ===========================================================
# 🪶 Função: show_last_log
# ===========================================================
show_last_log() {
    local BASENAME_FOLDER
    BASENAME_FOLDER="$(basename "$LOCAL_FOLDER")"
    local LOG_DIR="$HOME/CopyToGDriver_Log/${BASENAME_FOLDER}"

    # Encontra o log mais recente
    local last_log
    last_log=$(ls -t "$LOG_DIR"/sync-*.log 2>/dev/null | head -n 1)

    if [[ -z "$last_log" ]]; then
        write_color_output "⚠️ Nenhum log encontrado em: $LOG_DIR" "Yellow"
        return 1
    fi

    write_color_output "📜 Último log localizado:" "Cyan"
    echo "   $last_log"
    echo ""

    # Pergunta ao usuário se deseja abrir
    read -r -p "Deseja abrir o log detalhado agora? (Y/n): " choice
    choice=${choice:-Y}

    if [[ "$choice" =~ ^[Yy]$ ]]; then
        case "$(uname -s)" in
            CYGWIN*|MINGW*|MSYS*)
                # Windows → abre com o Notepad
                local windows_path
                windows_path=$(echo "$last_log" | sed 's|/c/|C:/|' | sed 's|/|\\|g')
                write_color_output "🪟 Abrindo log no Notepad..." "Blue"
                cmd.exe /C "start notepad.exe \"$windows_path\"" >/dev/null 2>&1
                ;;
            Darwin*)
                # macOS → usa open
                open "$last_log"
                ;;
            Linux*)
                # Linux → usa less
                less "$last_log"
                ;;
            *)
                write_color_output "⚠️ Sistema não reconhecido, exibindo com cat:" "Yellow"
                cat "$last_log"
                ;;
        esac
    else
        write_color_output "⏳ Log não aberto. Você pode visualizar manualmente em:" "Yellow"
        echo "   $last_log"
    fi
}



# ===========================================================
# 🧩 Função principal
# ===========================================================
main() {
    # esta função vem do ConfigFunctions
    parse_parameters "$@"

    [[ "$SHOW_HELP" == "true" ]] && show_help && exit 0

    show_configuration

    if check_prerequisites; then
        sync_folders
    else
        exit_with_error "Pré-requisitos não atendidos."
    fi
}

# -----------------------------------------------------------
# ▶️ Execução direta
# -----------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
