#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Cache.v0.0.1.sh
# Função: Limpeza e verificação do cache Rclone e espaço em disco
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.2.0 (multiplataforma real)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém funções relacionadas ao controle de cache
# e verificação de espaço em disco durante a sincronização.
#
# Funções:
#   • cleanup_rclone_cache         → Remove caches antigos e libera espaço
#   • check_disk_space_for_sync    → Verifica se há espaço suficiente
#
# Depende de:
#   • CopyToGDriver_Utils.sh
#   • CopyToGDriver_Config.sh
#   • includes/common + includes/<platform>
# ===========================================================

# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi



# -----------------------------------------------------------
# 🔗 Importar dependências
# -----------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Carregar sistema multiplataforma
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
# 🧠 Detectar plataforma para ajustar caminhos
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
# 🧹 Função: cleanup_rclone_cache
# -----------------------------------------------------------
cleanup_rclone_cache() {
    write_color_output "[LIMPEZA DE CACHE RCLONE]" "Yellow"

    # Ajuste de caminhos multiplataforma
    local cache_dirs=("$HOME/.cache/rclone")

    if [[ "$PLATFORM" == "windows" ]]; then
        cache_dirs+=("/c/Users/$USERNAME/AppData/Local/rclone/cache")
    elif [[ "$PLATFORM" == "macos" ]]; then
        cache_dirs+=("$HOME/Library/Caches/rclone")
    fi

    # Encerrar processos Rclone, se ativos
    if process_is_running "rclone"; then
        write_color_output "  Parando processos Rclone..." "Yellow"
        kill_process "rclone"
        sleep 3
    fi

    local total_freed=0

    for cache_dir in "${cache_dirs[@]}"; do
        if [[ -d "$cache_dir" ]]; then
            local size_before_mb
            size_before_mb=$(get_disk_usage_gb "$cache_dir")
            local size_before_human="${size_before_mb}MB"

            write_color_output "  Limpando: $cache_dir ($size_before_human)" "Cyan"

            # Limpar conteúdo (com aspas para evitar espaços)
            rm -rf "${cache_dir:?}/"* 2>/dev/null
            rm -rf "${cache_dir:?}/".* 2>/dev/null

            local size_after_mb
            size_after_mb=$(get_disk_usage_gb "$cache_dir")
            local freed=$((size_before_mb - size_after_mb))
            total_freed=$((total_freed + freed))

            write_color_output "  Cache limpo: $cache_dir" "Green"
        fi
    done

    if [[ $total_freed -gt 0 ]]; then
        write_color_output "  Espaço liberado: ${total_freed}MB" "Green"
    else
        write_color_output "  Nenhum cache para limpar" "Blue"
    fi
}

# -----------------------------------------------------------
# 💽 Função: check_disk_space_for_sync
# -----------------------------------------------------------
check_disk_space_for_sync() {
    write_color_output "  [ESPAÇO] Verificando espaço para sincronização..." "Cyan"

    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Pasta local não existe, não é possível verificar espaço" "Yellow"
        return 0
    fi

    local available_gb
    available_gb=$(get_disk_space_gb "$LOCAL_FOLDER")

    local min_space_gb=5
    local recommended_gb=10

    write_color_output "  Espaço disponível: ${available_gb}GB" "Blue"

    if [[ $available_gb -lt $min_space_gb ]]; then
        write_color_output "  ❌ Espaço insuficiente para sincronização" "Red"
        write_color_output "  Disponível: ${available_gb}GB (Mínimo: ${min_space_gb}GB)" "Yellow"
        write_color_output "  Use --clean-cache para liberar espaço" "Blue"
        return 1
    elif [[ $available_gb -lt $recommended_gb ]]; then
        write_color_output "  ⚠️  Espaço limitado para sincronização" "Yellow"
        write_color_output "  Disponível: ${available_gb}GB (Recomendado: ${recommended_gb}GB)" "Yellow"
        return 2
    else
        write_color_output "  ✅ Espaço suficiente para sincronização" "Green"
        return 0
    fi
}

# -----------------------------------------------------------
# 🔚 Fim do módulo CopyToGDriver_Cache.sh
# ===========================================================

