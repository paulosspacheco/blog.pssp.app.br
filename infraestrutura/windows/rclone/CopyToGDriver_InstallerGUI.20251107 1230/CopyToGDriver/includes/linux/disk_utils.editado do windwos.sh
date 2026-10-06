#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: disk_utils.sh (v0.0.01)
# Função: Utilitários de disco universais (Linux / macOS / Windows - WSL)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================
#
# 🧭 Descrição:
# Este script fornece um conjunto de funções para gerenciamento de disco
# compatíveis com Linux, macOS e Windows (via WSL ou Git Bash).
#
# Ele permite listar discos, verificar espaço livre, medir o uso de diretórios
# e confirmar se há capacidade disponível para uma determinada operação.
#
# 💡 Compatibilidade:
# - ✅ Linux (df, du)
# - ✅ macOS (df, du)
# - ✅ Windows (Git Bash, WSL ou Cygwin)
#
# 🔧 Dependências:
# - df, du, awk, sed (nativos em Unix)
# - wmic (opcional no Windows)
#
# ===========================================================


# -----------------------------------------------------------
# 🧩 Funções principais de detecção e listagem
# -----------------------------------------------------------

# 🔹 Detecta o sistema operacional atual
detect_os() {
    case "$(uname -s)" in
        Darwin*)    echo "macOS" ;;
        Linux*)     echo "Linux" ;;
        CYGWIN*|MINGW*) echo "Windows" ;;
        *)          echo "Unknown" ;;
    esac
}

# 🔹 Lista discos montados com informações básicas
list_disks() {
    local os_type
    os_type=$(detect_os)
    echo "📀 Listando discos disponíveis..."

    case "$os_type" in
        "Linux")
            df -h | awk '
                NR==1 {printf "%-10s %-20s %-10s %-10s %-s\n", "Device", "Mountpoint", "Size", "Available", "Use%"}
                NR>1 {printf "%-10s %-20s %-10s %-10s %-s\n", $1, $6, $2, $4, $5}'
            ;;
        "macOS")
            df -h | awk '
                NR==1 {printf "%-20s %-10s %-10s %-10s %-s\n", "Filesystem", "Size", "Available", "Used", "Use%"}
                NR>1 {printf "%-20s %-10s %-10s %-10s %-s\n", $1, $2, $4, $3, $5}'
            ;;
        "Windows")
            if command -v wmic &> /dev/null; then
                wmic logicaldisk get name,volumename,freespace,size 2>/dev/null | awk 'NR>1 && NF>0'
            else
                echo "WMIC não disponível — executando em WSL ou Git Bash?"
                # Para Git Bash e WSL, mostra unidades montadas
                if [[ -d "/c" ]]; then
                    df -h /[c-z] 2>/dev/null || df -h
                else
                    df -h
                fi
            fi
            ;;
        *)
            df -h
            ;;
    esac
}


# -----------------------------------------------------------
# 🧮 Funções de cálculo de espaço
# -----------------------------------------------------------

# 🔹 Mostra espaço livre de um ponto de montagem
disk_free_space() {
    local path="$1"
    if [[ -z "$path" ]]; then
        echo "Uso: disk_free_space <caminho>"
        return 1
    fi
    
    # Para Windows Git Bash, converte caminhos se necessário
    if [[ $(detect_os) == "Windows" && "$path" == *":\\"* ]]; then
        path=$(echo "$path" | sed 's/\\/\//g' | sed 's/\([a-zA-Z]\):/\/\1/')
    fi
    
    df -h "$path" 2>/dev/null || echo "Erro: Não foi possível acessar o caminho '$path'"
}

# 🔹 Retorna o espaço livre em GB (valor numérico)
get_disk_space_gb() {
    local path="$1"
    if [[ -z "$path" ]]; then
        echo "Uso: get_disk_space_gb <caminho>"
        return 1
    fi
    
    # Para Windows Git Bash, converte caminhos se necessário
    if [[ $(detect_os) == "Windows" && "$path" == *":\\"* ]]; then
        path=$(echo "$path" | sed 's/\\/\//g' | sed 's/\([a-zA-Z]\):/\/\1/')
    fi
    
    df -k "$path" 2>/dev/null | awk 'NR==2 {print int($4/1024/1024)}'
}

# 🔹 Retorna o uso de um diretório em GB
get_disk_usage_gb() {
    local path="$1"
    if [[ -z "$path" ]]; then
        echo "Uso: get_disk_usage_gb <caminho>"
        return 1
    fi

    # Para Windows Git Bash, converte caminhos se necessário
    if [[ $(detect_os) == "Windows" && "$path" == *":\\"* ]]; then
        path=$(echo "$path" | sed 's/\\/\//g' | sed 's/\([a-zA-Z]\):/\/\1/')
    fi

    local os_type
    os_type=$(detect_os)
    
    if [[ "$os_type" == "macOS" ]]; then
        du -sk "$path" 2>/dev/null | awk '{print int($1/1024/1024)}'
    else
        du -sb "$path" 2>/dev/null | awk '{print int($1/1024/1024/1024)}'
    fi
}

# 🔹 Verifica se há espaço suficiente disponível
check_available_space() {
    local path="$1"
    local required_gb="$2"

    if [[ -z "$path" || -z "$required_gb" ]]; then
        echo "Uso: check_available_space <caminho> <gb_necessários>"
        return 1
    fi

    # Para Windows Git Bash, converte caminhos se necessário
    if [[ $(detect_os) == "Windows" && "$path" == *":\\"* ]]; then
        path=$(echo "$path" | sed 's/\\/\//g' | sed 's/\([a-zA-Z]\):/\/\1/')
    fi

    local available_gb
    available_gb=$(get_disk_space_gb "$path")

    if [[ -z "$available_gb" ]]; then
        echo "❌ Erro: Não foi possível verificar o espaço em '$path'"
        return 2
    fi

    if [[ "$available_gb" -ge "$required_gb" ]]; then
        echo "✅ Espaço suficiente: ${available_gb}GB disponíveis em ${path}"
        return 0
    else
        echo "❌ Espaço insuficiente: ${available_gb}GB disponíveis, ${required_gb}GB necessários em ${path}"
        return 1
    fi
}

# 🔹 Mostra informações detalhadas sobre o disco
disk_info() {
    local path="${1:-.}"
    local os_type
    os_type=$(detect_os)

    # Para Windows Git Bash, converte caminhos se necessário
    if [[ "$os_type" == "Windows" && "$path" == *":\\"* ]]; then
        path=$(echo "$path" | sed 's/\\/\//g' | sed 's/\([a-zA-Z]\):/\/\1/')
    fi

    echo "=== Informações do Disco ==="
    echo "Sistema: $os_type"
    echo "Caminho: $path"
    echo ""

    local free_gb
    free_gb=$(get_disk_space_gb "$path")
    if [[ -n "$free_gb" ]]; then
        echo "Espaço livre: ${free_gb}GB"
    else
        echo "Espaço livre: Não disponível"
    fi

    local usage_gb
    usage_gb=$(get_disk_usage_gb "$path")
    if [[ -n "$usage_gb" ]]; then
        echo "Uso do diretório: ${usage_gb}GB"
    else
        echo "Uso do diretório: Não disponível"
    fi
    echo ""

    df -h "$path" 2>/dev/null || echo "Informações detalhadas não disponíveis"
}


# -----------------------------------------------------------
# ⚙️ Função principal (modo CLI)
# -----------------------------------------------------------

main() {
    case "${1:-}" in
        "list")
            list_disks ;;
        "free")
            disk_free_space "${2:-.}" ;;
        "space")
            get_disk_space_gb "${2:-.}" ;;
        "usage")
            get_disk_usage_gb "${2:-.}" ;;
        "check")
            check_available_space "${2:-.}" "${3:-}" ;;
        "info")
            disk_info "${2:-.}" ;;
        *)
            echo "Uso: $0 {list|free|space|usage|check|info} [caminho] [gb_necessários]"
            echo ""
            echo "Comandos disponíveis:"
            echo "  list                    - Lista todos os discos montados"
            echo "  free [caminho]          - Mostra espaço livre de um caminho"
            echo "  space [caminho]         - Retorna o espaço livre em GB"
            echo "  usage [caminho]         - Retorna o uso do diretório em GB"
            echo "  check [caminho] [gb]    - Verifica se há espaço suficiente"
            echo "  info [caminho]          - Exibe informações completas"
            echo ""
            echo "Exemplos:"
            echo "  $0 list"
            echo "  $0 space /home"
            echo "  $0 check /tmp 5"
            echo "  $0 check C:\\Users 10  (Windows)"
            ;;
    esac
}

# -----------------------------------------------------------
# 🧪 Exemplo de uso
# -----------------------------------------------------------
# source ./disk_utils.sh
# echo "📀 Discos disponíveis:"
# list_disks
# echo "💾 Espaço livre no diretório atual: $(get_disk_space_gb "$(pwd)") GB"
# echo "📂 Uso do diretório atual: $(get_disk_usage_gb "$(pwd)") GB"
# check_available_space "$(pwd)" 1
# disk_info "$(pwd)"
# ===========================================================


# Executa main apenas se o script for chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi