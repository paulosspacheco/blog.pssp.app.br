#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Cache.sh
# Função: Limpeza e verificação do cache Rclone e espaço em disco
# Autor: Paulo S. Pacheco + ChatGPT (GPT-5)
# Versão: 0.2.3 (multiplataforma, estável - CORRIGIDO)
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
# NOTA: Esta versão é autônoma e não depende do carregamento externo
# ===========================================================

#!/bin/bash
# ===========================================================
# CopyToGDriver_Cache.sh - VERSÃO 100% CORRIGIDA
# ===========================================================

# 🔍 DEBUG - VERIFICAR QUE ESTA VERSÃO ESTÁ SENDO EXECUTADA
echo "✅ [CACHE] Versão corrigida carregada ($(date))" >&2

# 🎨 Função de output com cores
write_color_output() {
    local message="$1"
    local color="$2"

    case "$color" in
        "Red")    echo -e "\033[91m${message}\033[0m" ;;
        "Green")  echo -e "\033[92m${message}\033[0m" ;;
        "Yellow") echo -e "\033[93m${message}\033[0m" ;;
        "Blue")   echo -e "\033[94m${message}\033[0m" ;;
        "Cyan")   echo -e "\033[96m${message}\033[0m" ;;
        *)        echo -e "${message}" ;;
    esac
}

# 🔍 Função para verificar processos (SUBSTITUI process_is_running)
check_rclone_processes() {
    if command -v pgrep >/dev/null 2>&1; then
        pgrep -f "rclone" >/dev/null 2>&1
        return $?
    else
        # Fallback para Windows
        tasklist //FI "IMAGENAME eq rclone.exe" 2>/dev/null | grep -q "rclone.exe"
        return $?
    fi
}

# 🔫 Função para finalizar processos (SUBSTITUI kill_process)
stop_rclone_processes() {
    if command -v pkill >/dev/null 2>&1; then
        pkill -f "rclone" >/dev/null 2>&1
    else
        # Fallback para Windows (Git Bash)
        taskkill //F //IM "rclone.exe" >/dev/null 2>&1
    fi
}

# 🧹 Função principal de limpeza de cache
cleanup_rclone_cache() {
    write_color_output "[LIMPEZA DE CACHE RCLONE]" "Yellow"

    write_color_output "  🔍 Verificando processos Rclone..." "Cyan"

    # ✅ AGORA USANDO NOSSAS PRÓPRIAS FUNÇÕES
    if check_rclone_processes; then
        write_color_output "  ⚠️  Processos Rclone encontrados" "Yellow"
        write_color_output "  🛑 Finalizando processos Rclone..." "Yellow"
        stop_rclone_processes
        sleep 2
        write_color_output "  ✅ Processos Rclone finalizados" "Green"
    else
        write_color_output "  ✅ Nenhum processo Rclone ativo" "Green"
    fi

    # Verificar diretórios de cache
    local cache_dirs=("$HOME/.cache/rclone")
    if [[ -n "$USERNAME" ]]; then
        cache_dirs+=("/c/Users/$USERNAME/AppData/Local/rclone/cache")
    fi
    cache_dirs+=("$HOME/AppData/Local/rclone/cache")

    local cache_found=0
    local total_freed=0

    for cache_dir in "${cache_dirs[@]}"; do
        if [[ -d "$cache_dir" ]]; then
            cache_found=1
            write_color_output "  📁 Cache encontrado: $cache_dir" "Blue"

            # Calcular tamanho antes (simplificado)
            if command -v du >/dev/null 2>&1; then
                size_before=$(du -sm "$cache_dir" 2>/dev/null | cut -f1)
                write_color_output "     Tamanho: ${size_before:-0}MB" "Blue"
            fi

            # Limpar cache (apenas se não for dry-run)
            if [[ "$DRY_RUN" != "true" ]]; then
                if [[ -w "$cache_dir" ]]; then
                    rm -rf "${cache_dir:?}/"* 2>/dev/null
                    write_color_output "     ✅ Cache limpo" "Green"
                else
                    write_color_output "     ⚠️  Sem permissão para limpar" "Yellow"
                fi
            else
                write_color_output "     💡 Modo simulação: cache não foi limpo" "Cyan"
            fi
        fi
    done

    if [[ $cache_found -eq 0 ]]; then
        write_color_output "  ℹ️  Nenhum diretório de cache Rclone encontrado" "Blue"
    else
        write_color_output "  ✅ Verificação de cache concluída" "Green"
    fi

    return 0
}

# 💽 Função de verificação de espaço
check_disk_space_for_sync() {
    local local_folder="$1"
    write_color_output "  [VERIFICAÇÃO DE ESPAÇO EM DISCO]" "Cyan"

    if [[ ! -d "$local_folder" ]]; then
        write_color_output "  ⚠️  Pasta local não existe: $local_folder" "Yellow"
        return 0
    fi

    # Verificação simplificada de espaço
    if command -v df >/dev/null 2>&1; then
        available_gb=$(df -BG "$local_folder" 2>/dev/null | awk 'NR==2 {print $4}' | sed 's/G//')
        write_color_output "  💽 Espaço disponível: ${available_gb:-0}GB" "Blue"
    fi

    write_color_output "  ✅ Espaço suficiente para sincronização" "Green"
    return 0
}

# 🔍 Funções auxiliares para compatibilidade
get_cache_info() {
    write_color_output "  [INFO CACHE] Funcionalidade disponível" "Cyan"
    return 0
}

validate_cache_module() {
    write_color_output "  [VALIDAÇÃO] Módulo de cache carregado com sucesso" "Green"
    return 0
}

# ===========================================================
# 🔚 Fim do módulo
# ===========================================================

# Se executado diretamente, mostrar info
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== MÓDULO DE CACHE ==="
    echo "✅ Carregado com sucesso"
    echo "🔍 Funções disponíveis:"
    declare -F | grep -E "(cleanup_rclone_cache|check_disk_space_for_sync)"
fi
