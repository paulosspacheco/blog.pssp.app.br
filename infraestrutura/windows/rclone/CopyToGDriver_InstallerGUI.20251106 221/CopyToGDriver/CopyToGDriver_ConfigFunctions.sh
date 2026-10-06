#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_ConfigFunctions.sh
# Função: Implementa funções de configuração e parsing de parâmetros
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.1.0 (multiplataforma real)
# ===========================================================

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
# 🌈 Função utilitária: write_color_output (multiplataforma)
# -----------------------------------------------------------
write_color_output() {
    local message="$1"
    local color="$2"

    if [[ "$TERM" == *"xterm"* || "$TERM" == *"ansi"* || "$PLATFORM" != "windows" ]]; then
        case $color in
            "Red") echo -e "\033[31m$message\033[0m" ;;
            "Green") echo -e "\033[32m$message\033[0m" ;;
            "Yellow") echo -e "\033[33m$message\033[0m" ;;
            "Blue") echo -e "\033[34m$message\033[0m" ;;
            "Magenta") echo -e "\033[35m$message\033[0m" ;;
            "Cyan") echo -e "\033[36m$message\033[0m" ;;
            *) echo "$message" ;;
        esac
    else
        echo "$message"
    fi
}

# -----------------------------------------------------------
# 🧩 Função: confirm_sync (segura para bash / git bash)
# -----------------------------------------------------------
confirm_sync() {
    write_color_output "Modo automático: usando pasta atual como padrão" "Cyan"
    write_color_output "   Local:  $LOCAL_FOLDER" "Blue"
    write_color_output "   Remoto: $REMOTE_NAME:$REMOTE_FOLDER" "Blue"
    echo ""

    if [[ "$PLATFORM" == "windows" ]]; then
        echo -n "Deseja sincronizar a pasta corrente '$LOCAL_FOLDER'? (s/N): "
        read choice
    else
        read -p "Deseja sincronizar a pasta corrente '$LOCAL_FOLDER'? (s/N): " choice
    fi

    if [[ ! "$choice" =~ ^[sS]$ ]]; then
        write_color_output "Sincronização cancelada pelo usuário." "Yellow"
        exit 0
    fi

    write_color_output "Prosseguindo com a sincronização..." "Green"
    echo ""
}

# -----------------------------------------------------------
# 🧩 Função: calculate_defaults
# -----------------------------------------------------------
calculate_defaults() {
    if [[ -z "$DEFAULT_LOCAL_FOLDER" ]]; then
        DEFAULT_LOCAL_FOLDER="$(pwd)"
    fi

    if [[ -z "$DEFAULT_REMOTE_FOLDER" ]]; then
        local basename_folder
        basename_folder="$(basename "$(pwd)")"
        DEFAULT_REMOTE_FOLDER="rclone/$basename_folder"
    fi

    if [[ -z "$DEFAULT_REMOTE_FOLDER" ]]; then
        DEFAULT_REMOTE_FOLDER="rclone/sync-$(date +%Y%m%d)"
    fi
}

# -----------------------------------------------------------
# 🧩 Função auxiliar: is_effectively_empty
# -----------------------------------------------------------
is_effectively_empty() {
    local folder="$1"
    if [[ ! -d "$folder" ]]; then return 1; fi

    local useful_count
    useful_count=$(find "$folder" -maxdepth 1 -type f 2>/dev/null \
        ! -iname "CopyToGDriver_CopyCurrent.sh" \
        ! -iname "CopyToGDriver_Restore.sh" \
        ! -iname "CopyToGDriver_*.sh" \
        ! -iname "CopyToGDriverIgnore.txt" \
        ! -iname "CopyToGDriver_ignore.txt" | wc -l)

    [[ "$useful_count" -eq 0 ]]
}

# -----------------------------------------------------------
# 🧩 Função: show_help (padronizada)
# -----------------------------------------------------------
show_help() {
    calculate_defaults
    cat << EOF
======================================================
🧭  CopyToGDriver - Ajuda de Uso
======================================================
Uso: $0 [OPÇÕES]

Sincronização bidirecional com Rclone e pastas locais.

PADRÕES:
  • Pasta Local:      $(pwd)
  • Pasta Remota:     "rclone/$(basename "$(pwd)")"
  • Remote:           "$DEFAULT_REMOTE_NAME"

OPÇÕES DISPONÍVEIS:
  -l, --local-folder DIR      Define pasta local
  -r, --remote-name NAME      Define remote (padrão: $DEFAULT_REMOTE_NAME)
  -f, --remote-folder PATH    Define pasta remota
  -a, --auto-create           Cria pastas automaticamente
  -c, --clean-cache           Limpa cache antes da sincronização
  -n, --dry-run               Modo simulação (sem alterações)
  -v, --verbose               Logs detalhados
  -R, --resync                Reindexação forçada
  -h, --help                  Exibe esta ajuda

EXEMPLOS:
  $0                              # Sincroniza a pasta atual
  $0 --dry-run                    # Simula execução
  $0 -f "rclone/projetos/app"     # Define pasta remota
  $0 -a -c                        # Cria e limpa cache antes de sincronizar
======================================================
EOF
}

# -----------------------------------------------------------
# 🧩 Função: parse_parameters (agora multiplataforma)
# -----------------------------------------------------------
parse_parameters() {
    local has_parameters=false
    local explicit_remote_folder=false

    [[ $# -gt 0 ]] && has_parameters=true

    while [[ $# -gt 0 ]]; do
        case $1 in
            -l|--local-folder) LOCAL_FOLDER="$2"; shift 2 ;;
            -r|--remote-name) REMOTE_NAME="$2"; shift 2 ;;
            -f|--remote-folder) REMOTE_FOLDER="$2"; explicit_remote_folder=true; shift 2 ;;
            -n|--dry-run) DRY_RUN=true; shift ;;
            -v|--verbose) VERBOSE=true; shift ;;
            -R|--resync) RESYNC=true; shift ;;
            -a|--auto-create) AUTO_CREATE=true; shift ;;
            -c|--clean-cache) CLEAN_CACHE=true; shift ;;
            -h|--help) SHOW_HELP=true; shift ;;
            *)
                write_color_output "❌ Erro: parâmetro desconhecido: $1" "Red"
                show_help
                exit 1
                ;;
        esac
    done

    calculate_defaults
    LOCAL_FOLDER="${LOCAL_FOLDER:-$DEFAULT_LOCAL_FOLDER}"
    REMOTE_NAME="${REMOTE_NAME:-$DEFAULT_REMOTE_NAME}"

    if [[ "$explicit_remote_folder" == "false" ]]; then
        REMOTE_FOLDER="${REMOTE_FOLDER:-$DEFAULT_REMOTE_FOLDER}"
        echo "DEBUG: REMOTE_FOLDER (padrão): '$REMOTE_FOLDER'" >&2
    else
        echo "DEBUG: REMOTE_FOLDER (forçado): '$REMOTE_FOLDER'" >&2
    fi

    if [[ "$has_parameters" == "false" && "$SHOW_HELP" == "false" ]]; then
        confirm_sync
    fi

    # -------------------------------------------------------
    # 🔄 Restauração automática se pasta estiver “vazia”
    # -------------------------------------------------------
    if [[ -d "$LOCAL_FOLDER" ]] && is_effectively_empty "$LOCAL_FOLDER"; then
        write_color_output "⚠️  A pasta local '$LOCAL_FOLDER' contém apenas scripts do sistema." "Yellow"
        write_color_output "Tentando restaurar o conteúdo do Google Drive..." "Cyan"

        local restore_script_path
        restore_script_path="$(dirname "$0")/CopyToGDriver_Restore.sh"

        if [[ -x "$restore_script_path" ]]; then
            bash "$restore_script_path" --remote-folder "$(basename "$LOCAL_FOLDER")"
            local restore_exit=$?

            case $restore_exit in
                11)
                    write_color_output "🛑 Restauração concluída (modo seguro)." "Yellow"
                    write_color_output "🚫 Sincronização abortada para evitar sobrescrita." "Red"
                    exit 0 ;;
                0)
                    write_color_output "⚠️  Restauração completa — encerrando sincronização imediata." "Yellow"
                    exit 0 ;;
                *)
                    write_color_output "❌ Falha na restauração (código $restore_exit)" "Red"
                    exit 1 ;;
            esac
        else
            write_color_output "❌ Script de restauração não encontrado em:" "Red"
            write_color_output "   $restore_script_path" "Yellow"
            exit 1
        fi
    fi
}

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_ConfigFunctions.sh
# ===========================================================

