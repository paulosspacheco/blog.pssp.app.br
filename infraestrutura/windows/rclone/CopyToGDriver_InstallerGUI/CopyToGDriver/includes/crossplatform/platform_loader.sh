#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: platform_loader.sh (v1.2.1)
# Função: Carregador automático e independente de módulos por plataforma
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================
#
# 🧭 Descrição:
# Detecta o sistema operacional e carrega automaticamente
# os módulos universais do CopyToGDriver.
#
# 💡 Pode ser usado sozinho para diagnóstico ou integrado
# ao script principal CopyToGDriver.sh.
#
# 🔧 Compatibilidade:
# - ✅ Linux
# - ✅ macOS
# - ✅ Windows (Git Bash / WSL / Cygwin)
# ===========================================================

# -----------------------------------------------------------
# 🛡️ Proteção CRLF automática
# -----------------------------------------------------------
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi

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
# 🧩 Carregador universal de módulos
# -----------------------------------------------------------
load_platform_modules() {
    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local BASE_PATH="$SCRIPT_DIR/../.."
    local CROSS_PATH="$BASE_PATH/includes/crossplatform"
    local WIN_PATH="$BASE_PATH/includes/windows"

    echo "🔧 Carregando módulos universais..."
    echo "📂 Diretório base: $BASE_PATH"
    echo "🖥️ Plataforma detectada: $PLATFORM"
    echo "------------------------------------------------------"

    # 🔹 Módulo universal de disco
    if [[ -f "$CROSS_PATH/disk_utils.sh" ]]; then
        source "$CROSS_PATH/disk_utils.sh"
        echo "✅ Módulo de disco universal carregado: disk_utils.sh"
    else
        echo "⚠️  Módulo universal de disco não encontrado em: $CROSS_PATH"
    fi

    # 🔹 Utilitários universais (crossplatform)
    if [[ -f "$CROSS_PATH/crossplatform_utils.sh" ]]; then
        source "$CROSS_PATH/crossplatform_utils.sh"
        echo "✅ Módulo crossplatform_utils carregado"
    else
        echo "⚠️  crossplatform_utils.sh não encontrado"
    fi

    # 🔹 Proteção CRLF (opcional)
    if [[ -f "$CROSS_PATH/crlf_protect.sh" ]]; then
        source "$CROSS_PATH/crlf_protect.sh"
        echo "✅ Proteção CRLF ativada"
    fi

    # 🔹 Utilitários específicos do Windows
    if [[ "$PLATFORM" == "windows" ]]; then
        if [[ -f "$WIN_PATH/path_utils.sh" ]]; then
            source "$WIN_PATH/path_utils.sh"
            echo "✅ Módulo path_utils (Windows) carregado"
        else
            echo "⚠️  path_utils.sh não encontrado em: $WIN_PATH"
        fi
    fi

    echo "------------------------------------------------------"
    echo "✅ Carregamento concluído com sucesso para: $PLATFORM"
}

# -----------------------------------------------------------
# 🧪 Teste de diagnóstico (modo independente)
# -----------------------------------------------------------
run_diagnostics() {
    echo ""
    echo "======================================================"
    echo "🧪 Diagnóstico do Ambiente CopyToGDriver"
    echo "======================================================"
    echo "🖥️ Sistema Operacional: $(detect_platform)"
    echo "📂 Local do Script: $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo ""
    echo "Verificando módulos..."
    echo "------------------------------------------------------"
    load_platform_modules
    echo ""
    echo "✅ Diagnóstico finalizado!"
    echo "======================================================"
}

# -----------------------------------------------------------
# 🆘 Ajuda (modo CLI)
# -----------------------------------------------------------
show_help() {
    echo ""
    echo "======================================================"
    echo "🧭  CopyToGDriver - platform_loader.sh (v1.2.1)"
    echo "======================================================"
    echo "Uso: ./platform_loader.sh [opções]"
    echo ""
    echo "🔹 Opções disponíveis:"
    echo "  --help            Mostra esta ajuda e sai"
    echo "  --test            Executa teste rápido de carregamento"
    echo "  --diagnose        Executa diagnóstico completo do ambiente"
    echo "  --verbose         Alias de --diagnose"
    echo ""
    echo "🔹 Exemplos:"
    echo "  ./platform_loader.sh --test"
    echo "  ./platform_loader.sh --diagnose"
    echo ""
    echo "🔹 Localização esperada:"
    echo "  includes/crossplatform/platform_loader.sh"
    echo ""
    echo "======================================================"
    exit 0
}

# -----------------------------------------------------------
# ▶️ Execução direta (CLI)
# -----------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "$1" in
        --help|-h)
            show_help ;;
        --test)
            load_platform_modules ;;
        --diagnose|--verbose)
            run_diagnostics ;;
        *)
            echo "Uso inválido. Tente '--help' para ver as opções."
            exit 1 ;;
    esac
fi

# -----------------------------------------------------------
# 🧪 Exemplo de uso (em CopyToGDriver.sh)
# -----------------------------------------------------------
# if [[ -f "$SCRIPT_DIR/includes/crossplatform/platform_loader.sh" ]]; then
#     source "$SCRIPT_DIR/includes/crossplatform/platform_loader.sh"
#     load_platform_modules
# else
#     echo "❌ ERRO: platform_loader.sh não encontrado!"
#     exit 1
# fi
#
# -----------------------------------------------------------
# 🔚 Fim do arquivo platform_loader.sh (v1.2.1)
# ===========================================================
