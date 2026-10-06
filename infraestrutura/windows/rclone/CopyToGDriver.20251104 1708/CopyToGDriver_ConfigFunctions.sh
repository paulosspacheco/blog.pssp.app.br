#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_ConfigFunctions.sh
# Função: Implementa funções de configuração e parsing de parâmetros
# Autor: Paulo SSPacheco
# Versão: 0.0.0.23
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém as funções responsáveis por:
#   • Confirmar execução de sincronização com o usuário
#   • Calcular valores padrão dinâmicos (pasta local, remota, etc.)
#   • Exibir ajuda detalhada e exemplos de uso
#   • Fazer parsing dos parâmetros da linha de comando
# 
# Essas funções utilizam as variáveis globais definidas em:
#   👉 CopyToGDriver_Config.sh
# 
# E utilizam a função de saída colorida definida em:
#   👉 CopyToGDriver_Utils.sh
# ===========================================================


# ===========================================================
# 🌈 Função utilitária: write_color_output
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
# 🧩 Função: confirm_sync
# ===========================================================
confirm_sync() {
    write_color_output "Modo automático: usando pasta atual como padrão" "Cyan"
    write_color_output "   Local:  $LOCAL_FOLDER" "Blue"
    write_color_output "   Remoto: $REMOTE_NAME:$REMOTE_FOLDER" "Blue"
    echo ""
    
    local choice
    read -p "Deseja sincronizar a pasta corrente '$LOCAL_FOLDER' para a pasta de mesmo nome dentro da pasta 'rclone' na nuvem '$REMOTE_NAME'? (s/N): " choice
    
    if [[ "$choice" != "s" && "$choice" != "S" ]]; then
        write_color_output "Sincronização cancelada pelo usuário." "Yellow"
        exit 0
    fi
    
    write_color_output "Prosseguindo com a sincronização..." "Green"
    echo ""
}


# ===========================================================
# 🧩 Função: calculate_defaults
# ===========================================================
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


# ===========================================================
# 🧩 Função auxiliar: is_effectively_empty
# ===========================================================
# Considera a pasta “vazia” se contém apenas scripts do sistema CopyToGDriver.
# ===========================================================
is_effectively_empty() {
    local folder="$1"

    # Conta arquivos que NÃO sejam scripts internos nem ignores
    local useful_count
    useful_count=$(find "$folder" -maxdepth 1 -type f \
        ! -name "CopyToGDriver_CopyCurrent.sh" \
        ! -name "CopyToGDriver_Restore.sh" \
        ! -name "CopyToGDriver_*.sh" \
        ! -name "CopyToGDriverIgnore.txt" \
        ! -name "CopyToGDriver_ignore.txt" \
        2>/dev/null | wc -l)

    [[ "$useful_count" -eq 0 ]]
}


# ===========================================================
# 🧩 Função: show_help
# ===========================================================
show_help() {
    calculate_defaults
    
    cat << EOF
Uso: $0 [OPCOES]

Sincronização bidirecional Rclone com parâmetros dinâmicos.

VALORES PADRÃO:
  • Pasta Local:      Diretório atual ($(basename "$(pwd)"))
  • Pasta Remota:     "rclone/[nome da pasta atual]" no Google Drive ("$DEFAULT_REMOTE_FOLDER")
  • Remote:           "$DEFAULT_REMOTE_NAME"

OPÇÕES:
    -l, --local-folder DIR      Pasta local (padrão: diretório atual)
    -r, --remote-name NAME      Nome do remote Rclone (padrão: $DEFAULT_REMOTE_NAME)
    -f, --remote-folder PATH    Pasta remota (padrão: "$DEFAULT_REMOTE_FOLDER")
    -a, --auto-create           Cria pastas automaticamente
    -c, --clean-cache           Limpa cache do Rclone antes de sincronizar
    -n, --dry-run               Executa em modo simulação (sem alterar nada)
    -v, --verbose               Exibe logs detalhados
    -R, --resync                Força ressincronização completa
    -h, --help                  Mostra esta ajuda

EXEMPLOS:
    $0                                  # Sincroniza a pasta atual
    $0 --dry-run                        # Simula sem alterar nada
    $0 -f "rclone/projetos/app"         # Pasta remota específica
    $0 -a -c                            # Cria pastas e limpa cache

DICA:
  - Se a pasta local contiver apenas scripts do sistema, o sistema tenta restaurar
    automaticamente o backup mais recente do Google Drive (rclone.deleted).
EOF
}


# ===========================================================
# 🧩 Função: parse_parameters
# ===========================================================
parse_parameters() {
    local has_parameters=false
    local explicit_remote_folder=false
    
    if [[ $# -eq 0 ]]; then
        SHOW_HELP=false
    else
        has_parameters=true
    fi
    
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
            *) write_color_output "Erro: Parâmetro desconhecido: $1" "Red"; show_help; exit 1 ;;
        esac
    done

    calculate_defaults

    LOCAL_FOLDER="${LOCAL_FOLDER:-$DEFAULT_LOCAL_FOLDER}"
    REMOTE_NAME="${REMOTE_NAME:-$DEFAULT_REMOTE_NAME}"

    if [[ "$explicit_remote_folder" == "false" ]]; then
        REMOTE_FOLDER="${REMOTE_FOLDER:-$DEFAULT_REMOTE_FOLDER}"
        echo "DEBUG: REMOTE_FOLDER usando valor padrão dinâmico: '$REMOTE_FOLDER'" >&2
    else
        echo "DEBUG: REMOTE_FOLDER usando valor explícito: '$REMOTE_FOLDER'" >&2
    fi

    if [[ "$has_parameters" == "false" && "$SHOW_HELP" == "false" ]]; then
        confirm_sync
    fi

    # =======================================================
    # 🔄 NOVO: restauração automática se a pasta só tiver scripts
    # =======================================================
    if [[ -d "$LOCAL_FOLDER" ]]; then
        if is_effectively_empty "$LOCAL_FOLDER"; then
            write_color_output "⚠️  A pasta local '$LOCAL_FOLDER' contém apenas scripts do sistema." "Yellow"
            write_color_output "Tentando restaurar o conteúdo do Google Drive..." "Cyan"

            local restore_script_path="$(dirname "$0")/CopyToGDriver_Restore.sh"

            if [[ -x "$restore_script_path" ]]; then
                bash "$restore_script_path" --remote-folder "$(basename "$LOCAL_FOLDER")"
                local restore_exit=$?

                # 🔍 Tratamento de retorno do restore
                case $restore_exit in
                    11)
                        write_color_output "🛑 Restauração concluída com segurança." "Yellow"
                        write_color_output "🚫 Sincronização interrompida propositalmente para evitar sobrescrita." "Red"
                        write_color_output "👉 Revise os arquivos restaurados e execute novamente a sincronização." "Cyan"
                        exit 0  # encerra imediatamente
                        ;;
                    0)
                        write_color_output "⚠️  Restauração concluída sem código especial." "Yellow"
                        write_color_output "Encerrando também para evitar sincronização imediata." "Yellow"
                        exit 0  # encerra também
                        ;;
                    *)
                        write_color_output "❌ Falha durante a restauração (código $restore_exit)." "Red"
                        write_color_output "Abortando para evitar perda de dados." "Red"
                        exit 1
                        ;;
                esac

            else
                write_color_output "❌ Script de restauração não encontrado em:" "Red"
                write_color_output "   $restore_script_path" "Yellow"
                write_color_output "Abortando para evitar perda de dados." "Red"
                exit 1
            fi
        fi
    fi
    


}
