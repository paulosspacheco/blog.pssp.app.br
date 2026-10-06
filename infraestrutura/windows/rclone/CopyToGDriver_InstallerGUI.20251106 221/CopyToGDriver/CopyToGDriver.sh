#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver.v0.0.0.1.sh
# Função: Script principal que orquestra todos os módulos
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.2.0 (totalmente multiplataforma)
# ===========================================================

# -----------------------------------------------------------
# 📂 Determinar diretório base do script
# -----------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -----------------------------------------------------------
# 🌍 Detectar plataforma automaticamente
# -----------------------------------------------------------
detect_platform() {
    case "$(uname -s)" in
        Linux*)   PLATFORM="linux" ;;
        Darwin*)  PLATFORM="macos" ;;
        CYGWIN*|MINGW*|MSYS*) PLATFORM="windows" ;;
        *)        PLATFORM="unknown" ;;
    esac
    echo "$PLATFORM"
}

PLATFORM=$(detect_platform)

# -----------------------------------------------------------
# 🔧 Ajustar PATHs automaticamente (Windows ↔ Linux)
# -----------------------------------------------------------
normalize_path() {
    local path="$1"
    if [[ "$PLATFORM" == "windows" ]]; then
        # Converte /c/Users/... para C:\Users\...
        echo "$path" | sed -E 's|^/([a-zA-Z])/(.*)|\1:\\\2|' | sed 's|/|\\|g'
    else
        echo "$path"
    fi
}

# -----------------------------------------------------------
# 🔍 Carregar detectores e includes
# -----------------------------------------------------------
if [[ -f "$SCRIPT_DIR/platform_detector.sh" ]]; then
    source "$SCRIPT_DIR/platform_detector.sh"
else
    echo "❌ ERRO: platform_detector.sh não encontrado em $SCRIPT_DIR"
    exit 1
fi

if [[ -f "$SCRIPT_DIR/include_loader.sh" ]]; then
    source "$SCRIPT_DIR/include_loader.sh"
else
    echo "❌ ERRO: include_loader.sh não encontrado em $SCRIPT_DIR"
    exit 1
fi

# -----------------------------------------------------------
# ⚙️ Inicializar módulos de includes (cross-platform)
# -----------------------------------------------------------
if ! load_all_modules; then
    echo "❌ ERRO: Falha ao carregar módulos para plataforma $PLATFORM"
    exit 1
fi

# -----------------------------------------------------------
# 🔍 Verificação de módulos obrigatórios
# -----------------------------------------------------------
verify_dependencies() {
    local missing_modules=()
    local required=("Utils" "Config" "ConfigFunctions" "Checks" "Cache" "Sync" "Setup")

    echo "======================================================"
    echo "🔍 Verificando módulos do CopyToGDriver..."
    echo "======================================================"

    for mod in "${required[@]}"; do
        local mod_file="$SCRIPT_DIR/CopyToGDriver_${mod}.sh"
        if [[ ! -f "$mod_file" ]]; then
            missing_modules+=("$mod_file")
            echo "❌ Módulo ausente: $(basename "$mod_file")"
        else
            echo "✅ $(basename "$mod_file") encontrado."
        fi
    done

    if (( ${#missing_modules[@]} > 0 )); then
        echo ""
        echo "🚫 ERRO: Módulos essenciais faltando!"
        echo "💡 Execute o instalador novamente ou verifique o diretório:"
        echo "   $SCRIPT_DIR"
        echo ""
        exit 1
    fi

    echo ""
    echo "✅ Todas as dependências foram verificadas com sucesso!"
    echo "======================================================"
}

# -----------------------------------------------------------
# ▶️ Modo de verificação apenas (--check-only)
# -----------------------------------------------------------
if [[ "$1" == "--check-only" ]]; then
    verify_dependencies
    echo "✅ Verificação concluída. Nenhuma sincronização executada."
    exit 0
fi

# -----------------------------------------------------------
# 🔗 Importar módulos principais
# -----------------------------------------------------------
verify_dependencies

for mod in Utils Config ConfigFunctions Checks Cache Setup Sync; do
    mod_file="$SCRIPT_DIR/CopyToGDriver_${mod}.sh"
    if [[ -f "$mod_file" ]]; then
        source "$mod_file"
    else
        echo "⚠️ Aviso: $mod_file não encontrado (ignorando)."
    fi
done

# -----------------------------------------------------------
# ▶️ Execução principal
# -----------------------------------------------------------
if declare -f main >/dev/null; then
    log_info "Iniciando CopyToGDriver (plataforma: $PLATFORM)"
    main "$@"
else
    echo "❌ ERRO: Função 'main' não encontrada. Verifique CopyToGDriver_Sync.sh."
    exit 1
fi

# -----------------------------------------------------------
# 🧩 Debug opcional: mostrar ambiente
# -----------------------------------------------------------
# echo "DEBUG: PLATFORM=$PLATFORM"
# echo "DEBUG: SCRIPT_DIR=$SCRIPT_DIR"
# echo "DEBUG: Includes carregados com sucesso."

# -----------------------------------------------------------
# 🔚 Fim do módulo CopyToGDriver.sh
# ===========================================================

