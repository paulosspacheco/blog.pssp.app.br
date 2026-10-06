#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Checks.sh
# Função: Verifica pré-requisitos e ambiente antes da sincronização
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.2.0 (multiplataforma real)
# ===========================================================

# -----------------------------------------------------------
# 🔗 Importar dependências
# -----------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/include_loader.sh" ]]; then
    source "$SCRIPT_DIR/include_loader.sh"
    load_all_modules
else
    echo "❌ ERRO: include_loader.sh não encontrado em $SCRIPT_DIR"
    exit 1
fi

# Carregar módulos principais
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"

# -----------------------------------------------------------
# 🌍 Detectar plataforma (para compatibilidade de caminhos)
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
# 🧩 Função: check_rclone_installed
# -----------------------------------------------------------
check_rclone_installed() {
    write_color_output "  [1/6] Verificando Rclone..." "Cyan"

    if ! command -v rclone &> /dev/null; then
        write_color_output "  Rclone não encontrado no PATH" "Red"
        write_color_output "  Instale usando uma das opções abaixo:" "Yellow"
        case "$PLATFORM" in
            linux)   write_color_output "     ➤ sudo apt install rclone" "Blue" ;;
            macos)   write_color_output "     ➤ brew install rclone" "Blue" ;;
            windows) write_color_output "     ➤ choco install rclone" "Blue" ;;
        esac
        return 1
    fi

    local version
    version=$(rclone version | head -n1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    write_color_output "  Rclone encontrado: $version" "Green"
    return 0
}

# -----------------------------------------------------------
# 🌐 Função: check_internet_connection
# -----------------------------------------------------------
check_internet_connection() {
    write_color_output "  [2/6] Verificando conexão com a internet..." "Cyan"

    local test_endpoints=("https://www.google.com" "https://www.cloudflare.com" "https://rclone.org")
    for endpoint in "${test_endpoints[@]}"; do
        if curl --output /dev/null --silent --head --fail --max-time 10 "$endpoint"; then
            write_color_output "  Conexão OK: $(echo "$endpoint" | cut -d'/' -f3)" "Green"
            return 0
        fi
    done

    write_color_output "  ❌ Sem conexão de rede" "Red"
    write_color_output "  💡 Verifique Wi-Fi, proxy ou DNS" "Yellow"
    return 1
}

# -----------------------------------------------------------
# 📂 Função: check_local_folder
# -----------------------------------------------------------
check_local_folder() {
    write_color_output "  [3/6] Verificando pasta local..." "Cyan"

    if [[ -z "$LOCAL_FOLDER" ]]; then
        write_color_output "  Caminho da pasta local vazio" "Red"
        return 1
    fi

    LOCAL_FOLDER="$(resolve_path "$LOCAL_FOLDER")"
    write_color_output "  Caminho resolvido: $LOCAL_FOLDER" "Blue"

    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Pasta não encontrada: $LOCAL_FOLDER" "Yellow"
        mkdir -p "$LOCAL_FOLDER" && write_color_output "  Pasta criada automaticamente" "Green"
    fi

    if [[ ! -w "$LOCAL_FOLDER" ]]; then
        write_color_output "  Sem permissão de escrita em $LOCAL_FOLDER" "Red"
        return 1
    fi

    local item_count
    item_count=$(file_count "$LOCAL_FOLDER")
    local folder_size_mb
    folder_size_mb=$(get_disk_usage_gb "$LOCAL_FOLDER")
    write_color_output "  Conteúdo: $item_count arquivos (${folder_size_mb}MB)" "Blue"

    return 0
}

# -----------------------------------------------------------
# ☁️ Função: check_rclone_remote
# -----------------------------------------------------------
check_rclone_remote() {
    write_color_output "  [4/6] Verificando remote Rclone..." "Cyan"

    local config_file
    if [[ "$PLATFORM" == "windows" ]]; then
        config_file="/c/Users/$USERNAME/AppData/Roaming/rclone/rclone.conf"
    else
        config_file="$HOME/.config/rclone/rclone.conf"
    fi

    if [[ ! -f "$config_file" ]]; then
        write_color_output "  Arquivo de configuração do Rclone não encontrado" "Red"
        write_color_output "  Execute: rclone config" "Yellow"
        return 1
    fi

    if ! grep -q "^\[$REMOTE_NAME\]" "$config_file"; then
        write_color_output "  Remote '$REMOTE_NAME' não configurado" "Red"
        rclone listremotes || true
        return 1
    fi

    if rclone lsd "$REMOTE_NAME:" --max-depth 1 &>/dev/null; then
        write_color_output "  Remote OK" "Green"
    else
        write_color_output "  Falha ao conectar a '$REMOTE_NAME'" "Red"
        return 1
    fi
}

# -----------------------------------------------------------
# 💽 Função: check_disk_space
# -----------------------------------------------------------
check_disk_space() {
    write_color_output "  [5/6] Verificando espaço em disco..." "Cyan"

    local available_gb
    available_gb=$(get_disk_space_gb "$LOCAL_FOLDER")

    write_color_output "  Espaço disponível: ${available_gb}GB" "Blue"

    if (( available_gb < 2 )); then
        write_color_output "  ❌ Espaço insuficiente (<2GB livre)" "Red"
        return 1
    elif (( available_gb < 5 )); then
        write_color_output "  ⚠️  Espaço limitado (${available_gb}GB livre)" "Yellow"
    else
        write_color_output "  ✅ Espaço suficiente (${available_gb}GB livre)" "Green"
    fi
}

# -----------------------------------------------------------
# ⚠️ Função: check_sensitive_location
# -----------------------------------------------------------
check_sensitive_location() {
    write_color_output "  [6/6] Verificando local sensível..." "Cyan"

    local sensitive_locations
    if [[ "$PLATFORM" == "windows" ]]; then
        sensitive_locations=("/c/Windows" "/c/Program Files" "/c/Users/Public")
    else
        sensitive_locations=("/" "/usr" "/var" "/etc" "/home")
    fi

    for loc in "${sensitive_locations[@]}"; do
        if [[ "$LOCAL_FOLDER" == "$loc"* ]]; then
            write_color_output "  ⚠️  Local sensível detectado: $LOCAL_FOLDER" "Yellow"
            return 1
        fi
    done

    write_color_output "  Localização segura" "Green"
}

# -----------------------------------------------------------
# ✅ Função principal: check_prerequisites
# -----------------------------------------------------------
check_prerequisites() {
    write_color_output "[VALIDANDO PRÉ-REQUISITOS]" "Cyan"
    echo ""

    check_rclone_installed || return 1
    check_internet_connection || return 1
    check_local_folder || return 1
    check_rclone_remote || return 1
    check_disk_space || return 1
    check_sensitive_location || return 1

    write_color_output "✅ Todos os pré-requisitos atendidos." "Green"
    return 0
}

# -----------------------------------------------------------
# 🔚 Fim do módulo
# ===========================================================

