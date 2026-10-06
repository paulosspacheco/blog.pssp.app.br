#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver.sh
# Função: Script principal que orquestra todos os módulos
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 0.2.3 (multiplataforma + proteção CRLF + CLI documentada)
# ===========================================================
#
# 🧭 Descrição:
# Script principal responsável por iniciar, validar e executar
# o sistema CopyToGDriver em qualquer ambiente (Linux, macOS, Windows).
#
# 💡 Recursos:
# - Auto-correção de CRLF em ambientes Unix
# - Detecção e configuração automática da plataforma
# - Inclusão dinâmica de módulos crossplatform
# - Verificação de dependências críticas
# - Suporte completo a linha de comando (--help, --check-only, etc.)
#
# ===========================================================

# -----------------------------------------------------------
# 🛡️ Proteção CRLF (autocorreção automática)
# -----------------------------------------------------------
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi

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
        # Converte /c/Users/... → C:\Users\...
        echo "$path" | sed -E 's|^/([a-zA-Z])/(.*)|\1:\\\2|' | sed 's|/|\\|g'
    else
        echo "$path"
    fi
}

# -----------------------------------------------------------
# 🧩 Includes universais (CrossPlatform e Proteção)
# -----------------------------------------------------------

# Inclui utilitários universais (cross-platform)
if [[ -f "$SCRIPT_DIR/includes/crossplatform/crossplatform_utils.sh" ]]; then
    source "$SCRIPT_DIR/includes/crossplatform/crossplatform_utils.sh"
else
    echo "⚠️ crossplatform_utils.sh não encontrado — modo turbo desativado."
fi

# Inclui proteção CRLF centralizada
if [[ -f "$SCRIPT_DIR/includes/crossplatform/crlf_protect.sh" ]]; then
    source "$SCRIPT_DIR/includes/crossplatform/crlf_protect.sh"
    crlf_auto_fix "$@"
fi

# Inclui carregador universal de plataforma
if [[ -f "$SCRIPT_DIR/includes/crossplatform/platform_loader.sh" ]]; then
    source "$SCRIPT_DIR/includes/crossplatform/platform_loader.sh"
    load_platform_modules   # 🔹 Garante carregamento imediato dos módulos universais
else
    echo "❌ ERRO: platform_loader.sh não encontrado em $SCRIPT_DIR/includes/crossplatform"
    exit 1
fi

# Inclui utilitários de disco universais
if [[ -f "$SCRIPT_DIR/includes/crossplatform/disk_utils.sh" ]]; then
    source "$SCRIPT_DIR/includes/crossplatform/disk_utils.sh"
fi

# Inclui utilitários de caminho específicos do Windows
if [[ "$PLATFORM" == "windows" && -f "$SCRIPT_DIR/includes/windows/path_utils.sh" ]]; then
    source "$SCRIPT_DIR/includes/windows/path_utils.sh"
fi

# -----------------------------------------------------------
# 🔍 Carregar detectores e includes personalizados
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
# 🧩 Ajuda e exemplos de uso (--help)
# -----------------------------------------------------------
if [[ "$1" == "--help" ]]; then
    sed -n '/# 🧪 EXEMPLO DE USO/,/# ===========================================================/p' "$0" | sed 's/^# //'
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
# 🧪 EXEMPLO DE USO (Demonstração prática)
# -----------------------------------------------------------
# Uso:
#   ./CopyToGDriver.sh [opções]
#
# 🔹 Opções principais:
#   --check-only       → Apenas verifica dependências
#   --sync             → Executa sincronização padrão
#   --dry-run          → Teste de sincronização sem alterações
#   --verbose          → Ativa logs detalhados
#   --target <path>    → Define diretório de destino manualmente
#   --config <arquivo> → Usa um arquivo de configuração específico
#   --help             → Mostra esta ajuda
#
# 🔹 Exemplos práticos:
#   ./CopyToGDriver.sh --check-only
#   ./CopyToGDriver.sh --sync --target "/home/user/Projetos"
#   ./CopyToGDriver.sh --dry-run
#   ./CopyToGDriver.sh --config "./CopyToGDriver.conf"
#
# 🔹 Execução multiplataforma:
#   Windows (Git Bash): ./CopyToGDriver.sh --sync
#   Linux / macOS:      bash CopyToGDriver.sh --sync
#
# ===========================================================
# 🔚 Fim do módulo CopyToGDriver.sh
# ===========================================================
