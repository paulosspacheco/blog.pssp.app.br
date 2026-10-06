#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_AliasSetup.sh
# Função: Instala aliases globais para facilitar o uso
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 1.1.0 (multiplataforma real)
# ===========================================================

set -e

# -----------------------------------------------------------
# 🌍 Detectar plataforma (Linux, macOS, Windows Git Bash)
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
# 📂 Definir diretório base
# -----------------------------------------------------------
if [[ "$PLATFORM" == "windows" ]]; then
    # Caminho padrão do instalador no Windows
    BASE_DIR="/c/scripts/CopyToGDriver"
else
    # Caminho padrão no Linux/macOS
    BASE_DIR="$HOME/scripts/CopyToGDriver"
fi

# -----------------------------------------------------------
# 🧩 Definir aliases
# -----------------------------------------------------------
ALIAS_LINE_DRIVE="alias copydrive='bash \"$BASE_DIR/CopyToGDriver_CopyCurrent.sh\"'"
ALIAS_LINE_CHECK="alias copycheck='bash \"$BASE_DIR/CopyToGDriver.sh\" --check-only'"

# Arquivos possíveis para inicialização
BASHRC_FILES=()
[[ -f "$HOME/.bashrc" ]] && BASHRC_FILES+=("$HOME/.bashrc")
[[ -f "$HOME/.bash_profile" ]] && BASHRC_FILES+=("$HOME/.bash_profile")
[[ -f "$HOME/.zshrc" ]] && BASHRC_FILES+=("$HOME/.zshrc")

# -----------------------------------------------------------
# 🧩 Função para adicionar alias em arquivo
# -----------------------------------------------------------
add_alias() {
    local alias_line="$1"
    local rc_file="$2"
    [[ -f "$rc_file" ]] || return

    if grep -Fq "$alias_line" "$rc_file"; then
        echo "✅ Alias já existe em: $rc_file"
    else
        echo "$alias_line" >> "$rc_file"
        echo "🔗 Alias adicionado em: $rc_file"
    fi
}

# -----------------------------------------------------------
# 🧰 Instalar os aliases
# -----------------------------------------------------------
install_aliases() {
    echo "======================================================"
    echo "🔗 Instalando aliases globais do CopyToGDriver"
    echo "======================================================"

    if [[ ${#BASHRC_FILES[@]} -eq 0 ]]; then
        echo "⚠️  Nenhum arquivo de inicialização de shell encontrado!"
        echo "💡 Crie um ~/.bashrc e rode novamente."
        exit 1
    fi

    for rc_file in "${BASHRC_FILES[@]}"; do
        add_alias "$ALIAS_LINE_DRIVE" "$rc_file"
        add_alias "$ALIAS_LINE_CHECK" "$rc_file"
    done

    echo
    echo "✅ Aliases adicionados com sucesso!"
    echo "📦 Comandos disponíveis:"
    echo "   • copydrive → sincroniza a pasta atual"
    echo "   • copycheck → verifica o ambiente CopyToGDriver"
    echo
    echo "💡 Dica: execute 'source ~/.bashrc' ou reinicie o terminal."
    echo
}

# -----------------------------------------------------------
# ▶️ Execução principal
# -----------------------------------------------------------
install_aliases

