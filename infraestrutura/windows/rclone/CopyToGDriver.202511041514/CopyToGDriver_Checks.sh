#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Checks.sh
# Função: Verifica pré-requisitos, ambiente e condições antes da sincronização
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.1.0 (adaptado para sistema multiplataforma)
# ===========================================================

# ===========================================================
# 🔗 Importar dependências e ambiente multiplataforma
# ===========================================================
SCRIPT_DIR="$(dirname "$0")"

# Carregar sistema de includes multiplataforma
source "$SCRIPT_DIR/include_loader.sh"
load_all_modules

# Carregar módulos internos originais (para manter compatibilidade)
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"

# ===========================================================
# 🧩 Função: check_rclone_installed
# ===========================================================
check_rclone_installed() {
    write_color_output "  [1/5] Verificando Rclone..." "Cyan"
    
    if ! command -v rclone &> /dev/null; then
        write_color_output "  Rclone não encontrado no PATH" "Red"
        write_color_output "  Instalação necessária:" "Yellow"
        write_color_output "     Opção 1: curl https://rclone.org/install.sh | sudo bash" "Blue"
        write_color_output "     Opção 2: sudo apt install rclone (Linux)" "Blue"
        write_color_output "     Opção 3: choco install rclone (Windows via Chocolatey)" "Blue"
        return 1
    else
        local version
        version=$(rclone version | head -n1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        write_color_output "  Rclone encontrado: $version" "Green"
        return 0
    fi
}

# ===========================================================
# 🌐 Função: check_internet_connection
# ===========================================================
check_internet_connection() {
    write_color_output "  [2/5] Verificando conexão com a internet..." "Cyan"
    
    local test_endpoints=(
        "https://www.google.com"
        "https://www.cloudflare.com"
        "https://www.github.com"
        "https://rclone.org"
    )
    
    for endpoint in "${test_endpoints[@]}"; do
        if curl --output /dev/null --silent --head --fail --max-time 10 "$endpoint"; then
            write_color_output "  Conexão detectada via: $(echo "$endpoint" | cut -d'/' -f3)" "Green"
            return 0
        fi
    done
    
    write_color_output "  Sem conexão com a internet" "Red"
    write_color_output "  Solução: Verifique sua conexão de rede e DNS" "Yellow"
    return 1
}

# ===========================================================
# 📂 Função: check_local_folder
# ===========================================================
check_local_folder() {
    write_color_output "  [3/5] Verificando pasta local..." "Cyan"
    
    if [[ -z "$LOCAL_FOLDER" ]]; then
        write_color_output "  Caminho da pasta local está vazio" "Red"
        return 1
    fi

    # Expandir caminhos relativos
    local expanded_local_folder
    expanded_local_folder=$(resolve_path "$LOCAL_FOLDER")
    LOCAL_FOLDER="$expanded_local_folder"
    write_color_output "  Caminho resolvido: $LOCAL_FOLDER" "Blue"
    
    # Criar se necessário
    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Pasta local não encontrada: $LOCAL_FOLDER" "Yellow"
        if [[ "$AUTO_CREATE" == "true" ]]; then
            write_color_output "  Criando pasta automaticamente (--auto-create)..." "Green"
            mkdir -p "$LOCAL_FOLDER"
        else
            read -p "  Deseja criar a pasta? (s/N): " choice
            if [[ "$choice" =~ ^[sS]$ ]]; then
                mkdir -p "$LOCAL_FOLDER" || {
                    write_color_output "  Falha ao criar pasta" "Red"
                    return 1
                }
            else
                write_color_output "  Pasta local necessária para sincronização" "Red"
                return 1
            fi
        fi
    fi

    # Verificar permissões
    if [[ -w "$LOCAL_FOLDER" ]]; then
        local item_count
        item_count=$(file_count "$LOCAL_FOLDER")
        local folder_size_gb
        folder_size_gb=$(get_disk_usage_gb "$LOCAL_FOLDER")
        write_color_output "  Pasta local válida: $LOCAL_FOLDER" "Green"
        write_color_output "  Conteúdo: $item_count arquivos, ${folder_size_gb}MB" "Blue"
    else
        write_color_output "  Sem permissão de escrita na pasta" "Red"
        return 1
    fi

    return 0
}

# ===========================================================
# ☁️ Função: check_rclone_remote
# ===========================================================
check_rclone_remote() {
    write_color_output "  [4/5] Verificando remote Rclone..." "Cyan"
    
    local config_file="$HOME/.config/rclone/rclone.conf"
    if [[ ! -f "$config_file" ]]; then
        write_color_output "  Arquivo de configuração do Rclone não encontrado" "Red"
        write_color_output "  Execute: rclone config" "Yellow"
        return 1
    fi
    
    if ! grep -q "^\[$REMOTE_NAME\]" "$config_file" 2>/dev/null; then
        write_color_output "  Remote '$REMOTE_NAME' não encontrado" "Red"
        rclone listremotes 2>/dev/null || echo "  Nenhum remote configurado"
        return 1
    fi

    if rclone lsd "$REMOTE_NAME:" --max-depth 1 &>/dev/null; then
        write_color_output "  Conexão com remote OK" "Green"
        return 0
    else
        write_color_output "  Falha ao conectar ao remote '$REMOTE_NAME'" "Red"
        return 1
    fi
}

# ===========================================================
# 💽 Função: check_disk_space
# ===========================================================
check_disk_space() {
    write_color_output "  [5/5] Verificando espaço em disco..." "Cyan"

    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Pasta não existe, pulando verificação" "Yellow"
        return 0
    fi

    local available_gb
    available_gb=$(get_disk_space_gb "$LOCAL_FOLDER")
    local usage_gb
    usage_gb=$(get_disk_usage_gb "$LOCAL_FOLDER")

    write_color_output "  Espaço disponível: ${available_gb}GB" "Blue"
    write_color_output "  Espaço utilizado: ${usage_gb}MB" "Blue"

    if [[ $available_gb -lt 1 ]]; then
        write_color_output "  Espaço insuficiente (<1GB livre)" "Red"
        return 1
    elif [[ $available_gb -lt 5 ]]; then
        write_color_output "  Espaço limitado (${available_gb}GB livre)" "Yellow"
        return 0
    fi

    write_color_output "  Espaço suficiente (${available_gb}GB livre)" "Green"
    return 0
}

# ===========================================================
# 🧹 Função: check_rclone_cache_size
# ===========================================================
check_rclone_cache_size() {
    write_color_output "  [CACHE] Verificando cache do Rclone..." "Cyan"

    local cache_dir="$HOME/.cache/rclone"
    if [[ -d "$cache_dir" ]]; then
        local cache_size_mb
        cache_size_mb=$(get_disk_usage_gb "$cache_dir")
        write_color_output "  Tamanho do cache: ${cache_size_mb}MB" "Blue"
        if [[ $cache_size_mb -gt 2048 ]]; then
            write_color_output "  Cache grande detectado (>2GB)" "Yellow"
            return 1
        fi
    else
        write_color_output "  Nenhum cache encontrado" "Green"
    fi
    return 0
}

# ===========================================================
# ⚠️ Função: check_sensitive_location
# ===========================================================
check_sensitive_location() {
    write_color_output "  [LOCALIZAÇÃO] Verificando pasta local..." "Cyan"
    local sensitive_locations=("/" "/home" "/usr" "/var" "C:\Windows" "C:\Program Files")
    for location in "${sensitive_locations[@]}"; do
        if [[ "$LOCAL_FOLDER" == "$location"* ]]; then
            write_color_output "  ⚠️  Pasta em local sensível: $LOCAL_FOLDER" "Yellow"
            return 1
        fi
    done
    write_color_output "  Localização segura" "Green"
    return 0
}

# ===========================================================
# ✅ Função: check_prerequisites
# ===========================================================
check_prerequisites() {
    write_color_output "[VALIDANDO PRÉ-REQUISITOS]" "Cyan"
    echo ""

    local all_checks_passed=true

    check_rclone_installed || all_checks_passed=false
    echo ""
    check_internet_connection || all_checks_passed=false
    echo ""
    check_local_folder || all_checks_passed=false
    echo ""
    check_rclone_remote || all_checks_passed=false
    echo ""
    check_disk_space || all_checks_passed=false
    echo ""
    check_rclone_cache_size
    echo ""
    check_sensitive_location
    echo ""

    if [[ "$all_checks_passed" == "true" ]]; then
        write_color_output "✅ TODOS OS PRÉ-REQUISITOS ATENDIDOS" "Green"
        write_color_output "   Sincronização pode ser iniciada com segurança" "Blue"
        return 0
    else
        write_color_output "❌ PRÉ-REQUISITOS NÃO ATENDIDOS" "Red"
        write_color_output "   Corrija os problemas acima antes de continuar" "Yellow"
        return 1
    fi
}
# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Checks.sh
# ===========================================================
