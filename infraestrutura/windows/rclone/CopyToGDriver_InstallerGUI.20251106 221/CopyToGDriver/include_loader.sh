#!/bin/bash
# ===========================================================
# Módulo: include_loader.sh
# Função: Carregar automaticamente módulos comuns e específicos de plataforma
# ===========================================================

source "$(dirname "$0")/platform_detector.sh"

load_platform_module() {
    local module_name=$1
    local module_file="$PLATFORM_INCLUDE_PATH/${module_name}_utils.sh"
    if [[ -f "$module_file" ]]; then
        source "$module_file"
    else
        echo "⚠️  Módulo de plataforma não encontrado: $module_file"
    fi
}

load_common_module() {
    local module_name=$1
    local module_file="$(dirname "$0")/includes/common/${module_name}.sh"
    if [[ -f "$module_file" ]]; then
        source "$module_file"
    else
        echo "⚠️  Módulo comum não encontrado: $module_file"
    fi
}

load_all_modules() {
    # Módulos comuns
    load_common_module "logging"
    load_common_module "common_functions"
    load_common_module "config"

    # Módulos específicos da plataforma
    load_platform_module "disk"
    load_platform_module "process"
    load_platform_module "path"
}
