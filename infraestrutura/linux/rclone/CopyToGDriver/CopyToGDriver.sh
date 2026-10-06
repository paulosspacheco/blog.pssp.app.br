#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver.sh
# Função: Script principal que orquestra todos os módulos
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.0.0.24 (suporte à flag --check-only)
# ===========================================================

SCRIPT_DIR="$(dirname "$0")"

# ===========================================================
# 🔍 VERIFICAÇÃO DE DEPENDÊNCIAS
# ===========================================================
verify_dependencies() {
    local missing_modules=()
    local required_modules=("Utils" "Config" "ConfigFunctions" "Checks" "Cache" "Sync" "Setup")
    
    echo "======================================================"
    echo "🔍 Verificando módulos do CopyToGDriver..."
    echo "======================================================"
    
    for module in "${required_modules[@]}"; do
        local module_file="$SCRIPT_DIR/CopyToGDriver_${module}.sh"
        if [[ ! -f "$module_file" ]]; then
            missing_modules+=("$module_file")
            echo "❌ Módulo faltante: $(basename "$module_file")"
        else
            echo "✅ $(basename "$module_file") encontrado."
        fi
    done
    
    if [[ ${#missing_modules[@]} -gt 0 ]]; then
        echo ""
        echo "🚫 ERRO: Módulos essenciais faltando!"
        echo "💡 Solução: Execute o instalador ou verifique se todos os scripts estão no diretório:"
        echo "   $SCRIPT_DIR"
        echo ""
        exit 1
    fi
    
    echo ""
    echo "✅ Todas as dependências verificadas com sucesso!"
    echo "======================================================"
    echo ""
}

# ===========================================================
# ▶️ OPÇÃO --check-only (verificação sem execução)
# ===========================================================
if [[ "$1" == "--check-only" ]]; then
    verify_dependencies
    echo "✅ Verificação concluída. Nenhuma ação de sincronização executada."
    echo "======================================================"
    exit 0
fi

# ===========================================================
# 🔗 IMPORTAR MÓDULOS COM VERIFICAÇÃO
# ===========================================================
verify_dependencies

source "$SCRIPT_DIR/CopyToGDriver_Utils.sh"
source "$SCRIPT_DIR/CopyToGDriver_Config.sh"
source "$SCRIPT_DIR/CopyToGDriver_ConfigFunctions.sh"
source "$SCRIPT_DIR/CopyToGDriver_Checks.sh"
source "$SCRIPT_DIR/CopyToGDriver_Cache.sh"
source "$SCRIPT_DIR/CopyToGDriver_Setup.sh"
source "$SCRIPT_DIR/CopyToGDriver_Sync.sh"

# ===========================================================
# ▶️ EXECUÇÃO PRINCIPAL
# ===========================================================
if declare -f main >/dev/null; then
    main "$@"
else
    echo "❌ ERRO: Função 'main' não encontrada. Verifique se CopyToGDriver_Sync.sh foi carregado."
    exit 1
fi

# ===========================================================
# 🔚 Fim do módulo CopyToGDriver_Main.sh
# ===========================================================
