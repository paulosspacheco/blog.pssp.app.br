#!/bin/bash
# ===========================================================
# meu_script_turbo.sh - Exemplo de uso das utilities
# ===========================================================

# 🛡️ INCLUI PROTEÇÃO TURBO
source ./crossplatform_utils.sh

# 🛡️ AUTO-CORREÇÃO (primeira coisa após o source)
auto_fix_current_script "$@"

# ===========================================================
# SEU CÓDIGO NORMAL (com proteção turbo!)
# ===========================================================

echo "🚀 Script executando em: $(detect_os_type)"
echo "📁 Diretório: $(get_script_directory)"

# Valida dependências
validate_dependencies "curl" "git" "python3"

# Normaliza caminhos (útil para inputs)
caminho_normalizado=$(normalize_path "$1")
echo "🔧 Caminho normalizado: $caminho_normalizado"


# Demonstração interativa
./crossplatform_utils.sh

# Correção em lote de todo projeto
fix_project_scripts "/caminho/do/projeto"

# Verificar dependências
validate_dependencies "node" "npm" "docker"


# Seu código continua...