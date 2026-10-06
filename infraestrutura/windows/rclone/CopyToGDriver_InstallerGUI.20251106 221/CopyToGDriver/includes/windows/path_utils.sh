#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: disk_utils.sh (v0.0.5)
# Função: Utilitários de disco e conversão de caminhos para Windows (Git Bash)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================
#
# 🧭 Descrição:
# Este script oferece funções auxiliares para:
#   - Listar discos montados no Windows.
#   - Consultar espaço livre e uso de diretórios.
#   - Converter caminhos entre os formatos Git Bash (/c/Users/...) e Windows (C:\Users\...).
#
# 💡 Compatibilidade:
# - ✅ Windows nativo (PowerShell + WMIC)
# - ✅ Git Bash (MINGW64, Cygwin)
# - ✅ Máquinas virtuais (VirtualBox, VMWare)
# - ⚙️ Linux (modo compatível, usa df/du)
#
# 🔧 Dependências:
# - wmic (Windows)
# - PowerShell
# - awk
# - du / df (modo fallback)
# ===========================================================


# -----------------------------------------------------------
# 🧩 Funções de conversão de caminho
# -----------------------------------------------------------

# 🔹 Converte /c/Users/... → C:\Users\...
to_windows_path() {
    local path="$1"
    echo "$path" | sed -E 's|^/([a-zA-Z])/(.*)|\1:\\\2|' | sed 's|/|\\|g'
}

# 🔹 Converte C:\Users\... → /c/Users/...
to_gitbash_path() {
    local path="$1"
    echo "$path" | sed -E 's|^([A-Za-z]):\\|/\L\1/|' | sed 's|\\|/|g'
}

# 🔹 Detecta se é caminho Windows (ex: C:\...)
is_windows_path() {
    [[ "$1" =~ ^[A-Za-z]:\\ ]]
}

# 🔹 Conversão automática (auto detecta direção)
path_convert_auto() {
    local p="$1"
    if is_windows_path "$p"; then
        to_gitbash_path "$p"
    else
        to_windows_path "$p"
    fi
}


# -----------------------------------------------------------
# 🧮 Funções de disco
# -----------------------------------------------------------

# 🔹 Lista discos montados com informações básicas
list_disks() {
    echo "📀 Listando discos disponíveis..."
    if command -v wmic >/dev/null 2>&1; then
        wmic logicaldisk get name,volumename,freespace,size 2>/dev/null |
            tr -d '\r' | awk 'NR>1 && NF>0 {print $0}'
    else
        df -h | awk 'NR>1 {print $0}'
    fi
}

# 🔹 Mostra espaço livre (modo texto bruto, útil para debug)
disk_free_space() {
    local drive="$1"
    if [ -z "$drive" ]; then
        echo "Uso: disk_free_space <letra_da_unidade>"
        return 1
    fi
    wmic logicaldisk where "name='${drive}:'" get FreeSpace,Size 2>/dev/null | tr -d '\r'
}

# 🔹 Retorna o espaço livre em GB (valor numérico)
get_disk_space_gb() {
    local path="$1"
    if [ -z "$path" ]; then
        echo "Uso: get_disk_space_gb <caminho>"
        return 1
    fi

    # Extrai letra da unidade (ex: /c → C:)
    local drive_letter
    drive_letter=$(echo "$path" | sed -E 's|^/([a-zA-Z]).*|\1:|')

    # 🧩 Detecta ambiente e escolhe comando
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows/Git Bash
        local space
        space=$(powershell -NoProfile -Command "(Get-PSDrive -Name '${drive_letter:0:1}').Free / 1GB" |
            tr -d '\r' | awk '{print int($1)}')
        echo "${space:-0}"
    else
        # Linux fallback
        df -BG "$path" | awk 'NR==2 {print $4+0}'
    fi
}

# 🔹 Retorna o uso de um diretório em MB
get_disk_usage_gb() {
    local path="$1"
    if [ -z "$path" ]; then
        echo "Uso: get_disk_usage_gb <caminho>"
        return 1
    fi

    # Converte /c/... → C:\...
    local winpath
    winpath=$(to_windows_path "$path")

    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # PowerShell - mede uso da pasta em MB
        local usage
        usage=$(powershell -NoProfile -Command "
            Try {
                \$size = (Get-ChildItem -LiteralPath '$winpath' -Recurse -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum).Sum
                if (-not \$size) { \$size = 0 }
                [math]::Round(\$size / 1MB)
            } Catch { 0 }
        " | tr -d '\r' | tail -n 1)
        echo "${usage:-0}"
    else
        # Linux fallback
        du -sm "$path" 2>/dev/null | awk '{print $1}'
    fi
}


# -----------------------------------------------------------
# ⚙️ Detecção de ambiente VirtualBox (ajuste automático)
# -----------------------------------------------------------
if systeminfo 2>/dev/null | grep -qi "VirtualBox"; then
    echo "⚙️  Detecção: VirtualBox – usando df/du nativos (modo compatível)."
    get_disk_space_gb() {
        local path="$1"
        df -BG "$path" | awk 'NR==2 {print $4+0}'
    }
    get_disk_usage_gb() {
        local path="$1"
        du -sm "$path" 2>/dev/null | awk '{print $1}'
    }
fi


# -----------------------------------------------------------
# 🧪 Exemplo de uso (teste no Git Bash ou PowerShell)
# -----------------------------------------------------------
# source ./disk_utils.sh
# echo "📀 Discos disponíveis:"
# list_disks
# echo "💾 Espaço livre no C: $(get_disk_space_gb "/c") GB"
# echo "📂 Uso da pasta atual: $(get_disk_usage_gb "$(pwd)") MB"
# echo "🪟 Caminho Windows atual: $(to_windows_path "$(pwd)")"
# echo "🐧 Caminho Git Bash de C:\\Temp: $(to_gitbash_path "C:\\Temp")"
# ===========================================================
