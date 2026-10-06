#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_Cache.sh
# Função: Limpeza e verificação do cache Rclone e espaço em disco
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.1.0 (adaptado para sistema multiplataforma com includes)
# ===========================================================

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este módulo contém funções relacionadas ao controle de cache
# e verificação de espaço em disco durante a sincronização.
#
# Funções incluídas neste módulo:
#   • cleanup_rclone_cache         → Remove caches antigos e libera espaço
#   • check_disk_space_for_sync    → Verifica se há espaço suficiente para sincronizar
#
# Dependências:
#   👉 Usa funções utilitárias de CopyToGDriver_Utils.sh
#   👉 Usa variáveis globais de CopyToGDriver_Config.sh
#   👉 Usa abstrações multiplataforma (process_utils, disk_utils)
# ===========================================================


# ===========================================================
# 🔗 Importar dependências
# ===========================================================
SCRIPT_DIR="$(dirname "$0")"

# Carregar o sistema de includes multiplataforma
source "$SCRIPT_DIR/include_loader.sh"
load_all_modules

# Carregar módulos originais (mantendo compatibilidade)
source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"


# ===========================================================
# 🧹 Função: cleanup_rclone_cache
# ===========================================================
# Faz limpeza do cache local do Rclone, encerrando processos ativos
# e removendo diretórios temporários em múltiplas localizações conhecidas.
# ===========================================================
cleanup_rclone_cache() {
    write_color_output "[LIMPEZA DE CACHE RCLONE]" "Yellow"
    
    local cache_dirs=(
        "$HOME/.cache/rclone"
        "/media/paulosspacheco/85206044-cf3f-4ca0-a9d0-e25ec4a4e83c/.cache/rclone"
    )

    # 🔸 Parar processos Rclone se estiverem rodando (usando abstração)
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
            
            # Limpar conteúdo mas manter estrutura do diretório
            rm -rf "$cache_dir"/* 2>/dev/null
            rm -rf "$cache_dir"/.* 2>/dev/null
            
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


# ===========================================================
# 💽 Função: check_disk_space_for_sync
# ===========================================================
# Verifica se o espaço livre em disco é suficiente para a sincronização.
# Retorna:
#   0 → Espaço suficiente
#   1 → Espaço insuficiente
#   2 → Espaço limitado (alerta, mas não falha)
# ===========================================================
check_disk_space_for_sync() {
    write_color_output "  [ESPAÇO] Verificando espaço para sincronização..." "Cyan"
    
    if [[ ! -d "$LOCAL_FOLDER" ]]; then
        write_color_output "  Pasta local não existe, não é possível verificar espaço" "Yellow"
        return 0
    fi

    # 🔸 Obter espaço disponível via função multiplataforma
    local available_gb
    available_gb=$(get_disk_space_gb "$LOCAL_FOLDER")
    
    # Requerimentos mínimos de espaço
    local min_space_gb=5      # Mínimo absoluto
    local recommended_gb=10   # Recomendado
    
    write_color_output "  Espaço disponível: ${available_gb}GB" "Blue"
    
    if [[ $available_gb -lt $min_space_gb ]]; then
        write_color_output "  Espaço insuficiente para sincronização" "Red"
        write_color_output "  Disponível: ${available_gb}GB, Mínimo: ${min_space_gb}GB" "Yellow"
        write_color_output "  Execute com --clean-cache para liberar espaço" "Blue"
        return 1
    elif [[ $available_gb -lt $recommended_gb ]]; then
        write_color_output "  Espaço limitado para sincronização" "Yellow"
        write_color_output "  Disponível: ${available_gb}GB, Recomendado: ${recommended_gb}GB" "Yellow"
        write_color_output "  Considere usar --clean-cache" "Blue"
        return 2
    else
        write_color_output "  Espaço suficiente para sincronização" "Green"
        return 0
    fi
}


# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Cache.sh
# ===========================================================
