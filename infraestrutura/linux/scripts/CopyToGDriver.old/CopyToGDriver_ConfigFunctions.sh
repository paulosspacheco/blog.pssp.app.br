#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_ConfigFunctions.sh
# Função: Implementa funções de configuração e parsing de parâmetros
# Autor: Paulo SSPacheco
# Versão: 0.0.0.21 (baseada em Sync-Folder-Rclone)
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
# 🧩 Função: confirm_sync
# ===========================================================
# Texto original inicia em: "confirm_sync() {"
# e termina em: "write_color_output 'Prosseguindo com a sincronização...' 'Green'"
# ===========================================================

# Funcoes de utilidade
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

# Função para confirmação de sincronização no modo default
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
# Função para calcular valores padrão dinâmicos
# ===========================================================

calculate_defaults() {
    # Pasta local padrão: diretório atual
    if [[ -z "$DEFAULT_LOCAL_FOLDER" ]]; then
        DEFAULT_LOCAL_FOLDER="$(pwd)"
    fi
    
    # Pasta remota padrão: "rclone/[nome da pasta atual]"
    if [[ -z "$DEFAULT_REMOTE_FOLDER" ]]; then
        local basename_folder="$(basename "$(pwd)")"
        DEFAULT_REMOTE_FOLDER="rclone/$basename_folder"
    fi
    
    # Garantir que a pasta remota não seja vazia
    if [[ -z "$DEFAULT_REMOTE_FOLDER" ]]; then
        DEFAULT_REMOTE_FOLDER="rclone/sync-$(date +%Y%m%d)"
    fi
}

# ===========================================================
# 🧩 Função: show_help
# ===========================================================
# Texto original inicia em: "show_help() {"
# e termina no EOF (cat << EOF ... EOF)
# ===========================================================
show_help() {
    # Calcular defaults para mostrar no help
    calculate_defaults
    
    cat << EOF
Uso: $0 [OPCOES]

Sincronizacao bidirecional Rclone com parametros funcionando

VALORES PADRÃO DINÂMICOS:
  • Pasta Local:      Diretório atual ($(basename "$(pwd)"))
  • Pasta Remota:     "rclone/[nome da pasta atual]" no Google Drive ("$DEFAULT_REMOTE_FOLDER")
  • Remote:           "$DEFAULT_REMOTE_NAME"

OPCOES:
    -l, --local-folder DIR      Pasta local (padrao: diretório atual)
    -r, --remote-name NAME      Nome do remote Rclone (padrao: $DEFAULT_REMOTE_NAME)
    -f, --remote-folder PATH    Pasta remota (padrao: "$DEFAULT_REMOTE_FOLDER")
    -d, --log-days DAYS         Dias para reter logs (padrao: $DEFAULT_LOG_RETENTION_DAYS)
    -z, --zip-days DAYS         Dias para compactar logs (padrao: $DEFAULT_ZIP_AFTER_DAYS)
    -s, --sync-root DIR         Diretorio raiz para logs (padrao: $DEFAULT_SYNC_ROOT)
    -n, --dry-run               Modo simulacao (sem alteracoes)
    -v, --verbose               Modo verboso
    -R, --resync                Forcar ressincronizacao completa
    -a, --auto-create           Criar pastas automaticamente sem confirmacao
    -c, --clean-cache           Limpar cache do Rclone antes da sincronizacao
    -h, --help                  Mostrar esta ajuda

EXEMPLOS:
    $0                                  # Pergunta se deseja sincronizar pasta atual com gdriver:rclone/scripts
    $0 --dry-run                       # Teste com pasta atual (com confirmação)
    $0 -f ""                           # Sincroniza com raiz do Google Drive
    $0 -f "rclone/projetos/meu-app"    # Pasta específica dentro de 'rclone' no Google Drive
    $0 -l "/caminho/outra-pasta"       # Pasta local diferente
    $0 --resync --clean-cache          # Sincronização forçada com limpeza

CONFIGURAÇÃO RECOMENDADA:
    • Para sincronizar a pasta atual: Execute sem parâmetros (será perguntado)
    • Para pasta específica: Use -f "rclone/caminho/da/pasta"
    • Para raiz do Google Drive: Use -f ""

INSTRUCOES IMPORTANTES:
    1. Sem parâmetros: pergunta se deseja sincronizar pasta atual com pasta de mesmo nome dentro de 'rclone' no remote '$DEFAULT_REMOTE_NAME'
    2. Use '-f ""' para sincronizar com a pasta raiz do Google Drive
    3. Use '-a' para criar pastas automaticamente sem confirmacao
    4. Use '-c' para limpar cache do Rclone antes da sincronizacao
    5. Sempre teste com '--dry-run' antes da primeira sincronização
EOF
}

# ===========================================================
# 🧩 Função: parse_parameters
# ===========================================================
parse_parameters() {
    local has_parameters=false
    local explicit_remote_folder=false
    
    # Verificar se há parâmetros
    if [[ $# -eq 0 ]]; then
        SHOW_HELP=false  # Não mostra help, usa defaults dinâmicos
    else
        has_parameters=true
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -l|--local-folder)
                LOCAL_FOLDER="$2"
                has_parameters=true
                echo "DEBUG: LOCAL_FOLDER definido para: $LOCAL_FOLDER" >&2
                shift 2
                ;;
            -r|--remote-name)
                REMOTE_NAME="$2"
                has_parameters=true
                echo "DEBUG: REMOTE_NAME definido para: $REMOTE_NAME" >&2
                shift 2
                ;;
            -f|--remote-folder)
                REMOTE_FOLDER="$2"
                explicit_remote_folder=true
                has_parameters=true
                echo "DEBUG: REMOTE_FOLDER definido explicitamente para: '$REMOTE_FOLDER'" >&2
                shift 2
                ;;
            -d|--log-days)
                LOG_RETENTION_DAYS="$2"
                has_parameters=true
                shift 2
                ;;
            -z|--zip-days)
                ZIP_AFTER_DAYS="$2"
                has_parameters=true
                shift 2
                ;;
            -s|--sync-root)
                SYNC_ROOT="$2"
                has_parameters=true
                shift 2
                ;;
            -n|--dry-run)
                DRY_RUN=true
                has_parameters=true
                echo "DEBUG: DRY_RUN ativado" >&2
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                has_parameters=true
                shift
                ;;
            -R|--resync)
                RESYNC=true
                has_parameters=true
                echo "DEBUG: RESYNC ativado" >&2
                shift
                ;;
            -a|--auto-create)
                AUTO_CREATE=true
                has_parameters=true
                echo "DEBUG: AUTO_CREATE ativado" >&2
                shift
                ;;
            -c|--clean-cache)
                CLEAN_CACHE=true
                has_parameters=true
                echo "DEBUG: CLEAN_CACHE ativado" >&2
                shift
                ;;
            -h|--help)
                SHOW_HELP=true
                shift
                ;;
            *)
                write_color_output "Erro: Parametro desconhecido: $1" "Red"
                show_help
                exit 1
                ;;
        esac
    done

    # Calcular defaults dinâmicos
    calculate_defaults

    # Aplicar valores padrão DINÂMICOS
    LOCAL_FOLDER="${LOCAL_FOLDER:-$DEFAULT_LOCAL_FOLDER}"
    REMOTE_NAME="${REMOTE_NAME:-$DEFAULT_REMOTE_NAME}"
    
    # CORREÇÃO CRÍTICA: Só aplica default se -f não foi usado explicitamente
    if [[ "$explicit_remote_folder" == "false" ]]; then
        REMOTE_FOLDER="${REMOTE_FOLDER:-$DEFAULT_REMOTE_FOLDER}"
        echo "DEBUG: REMOTE_FOLDER usando valor padrão dinâmico: '$REMOTE_FOLDER'" >&2
    else
        echo "DEBUG: REMOTE_FOLDER usando valor explícito: '$REMOTE_FOLDER'" >&2
    fi
    
    LOG_RETENTION_DAYS="${LOG_RETENTION_DAYS:-$DEFAULT_LOG_RETENTION_DAYS}"
    ZIP_AFTER_DAYS="${ZIP_AFTER_DAYS:-$DEFAULT_ZIP_AFTER_DAYS}"
    SYNC_ROOT="${SYNC_ROOT:-$DEFAULT_SYNC_ROOT}"
    
    # Se não há parâmetros e não é help, usar modo automático com defaults dinâmicos (confirmação será feita depois)
    if [[ "$has_parameters" == "false" && "$SHOW_HELP" == "false" ]]; then
        confirm_sync
    fi
}
