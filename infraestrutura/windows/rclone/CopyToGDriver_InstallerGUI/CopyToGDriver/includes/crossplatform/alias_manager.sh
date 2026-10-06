#!/bin/bash
# ===========================================================
# Script: alias_manager.sh
# Função: Gerenciador universal de aliases de terminal
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 1.2.0 (Open Source, Multiplataforma)
# Licença: MIT
# ===========================================================
#
# 🧭 Descrição:
# Este script instala, remove, reinstala ou verifica aliases globais
# de forma multiplataforma (Linux, macOS e Windows via Git Bash/WSL).
#
# Ele é genérico — pode ser usado em QUALQUER projeto.
# Basta ajustar as variáveis de alias no bloco ALIASES[] abaixo.
# ===========================================================

set -e

# -----------------------------------------------------------
# 🌍 Detectar plataforma
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
# 📂 Diretório base padrão (ajustável)
# -----------------------------------------------------------
if [[ "$PLATFORM" == "windows" ]]; then
    BASE_DIR="/c/scripts"
else
    BASE_DIR="$HOME/scripts"
fi

# -----------------------------------------------------------
# 🧩 Definição de aliases (personalize conforme o projeto)
# -----------------------------------------------------------
ALIASES=(
    "alias copydrive='bash \"$BASE_DIR/CopyToGDriver/CopyToGDriver_CopyCurrent.sh\"'"
    "alias copycheck='bash \"$BASE_DIR/CopyToGDriver/CopyToGDriver.sh\" --check-only'"
)

# -----------------------------------------------------------
# 🧰 Arquivos de inicialização válidos
# -----------------------------------------------------------
BASHRC_FILES=()
[[ -f "$HOME/.bashrc" ]] && BASHRC_FILES+=("$HOME/.bashrc")
[[ -f "$HOME/.bash_profile" ]] && BASHRC_FILES+=("$HOME/.bash_profile")
[[ -f "$HOME/.zshrc" ]] && BASHRC_FILES+=("$HOME/.zshrc")

# -----------------------------------------------------------
# 🎨 Funções auxiliares de formatação
# -----------------------------------------------------------
green()  { echo -e "\033[1;32m$*\033[0m"; }
yellow() { echo -e "\033[1;33m$*\033[0m"; }
red()    { echo -e "\033[1;31m$*\033[0m"; }

# -----------------------------------------------------------
# 🧩 Funções principais
# -----------------------------------------------------------
add_alias() {
    local alias_line="$1"
    local rc_file="$2"
    [[ -f "$rc_file" ]] || return
    if grep -Fq "$alias_line" "$rc_file"; then
        yellow "⚠️  Alias já existe em: $rc_file"
    else
        echo "$alias_line" >> "$rc_file"
        green "🔗 Alias adicionado em: $rc_file"
    fi
}

remove_alias() {
    local alias_line="$1"
    local rc_file="$2"
    [[ -f "$rc_file" ]] || return
    if grep -Fq "$alias_line" "$rc_file"; then
        sed -i "/$(echo "$alias_line" | sed 's/[\/&]/\\&/g')/d" "$rc_file"
        red "🧹 Alias removido de: $rc_file"
    fi
}

check_aliases() {
    echo "======================================================"
    echo "🔍 Verificando aliases instalados"
    echo "======================================================"
    for rc_file in "${BASHRC_FILES[@]}"; do
        echo "📄 $rc_file:"
        grep -E "alias copydrive|alias copycheck" "$rc_file" 2>/dev/null || echo "❌ Nenhum alias encontrado."
    done
    echo "======================================================"
}

install_aliases() {
    echo "======================================================"
    echo "🔗 Instalando aliases universais"
    echo "======================================================"
    for rc_file in "${BASHRC_FILES[@]}"; do
        for alias_line in "${ALIASES[@]}"; do
            add_alias "$alias_line" "$rc_file"
        done
    done
    echo
    green "✅ Aliases instalados com sucesso!"
    yellow "💡 Execute 'source ~/.bashrc' ou reinicie o terminal."
    echo
}

reinstall_aliases() {
    echo "🔁 Reinstalando aliases..."
    for rc_file in "${BASHRC_FILES[@]}"; do
        for alias_line in "${ALIASES[@]}"; do
            remove_alias "$alias_line" "$rc_file"
        done
    done
    install_aliases
}

# -----------------------------------------------------------
# 🆘 Ajuda (CLI)
# -----------------------------------------------------------
show_help() {
    echo "======================================================"
    echo "🧭 alias_manager.sh – Gerenciador Universal de Aliases"
    echo "======================================================"
    echo "Uso: $0 [opção]"
    echo
    echo "Opções disponíveis:"
    echo "  --install       Instala aliases (modo padrão)"
    echo "  --remove        Remove aliases existentes"
    echo "  --reinstall     Remove e reinstala aliases"
    echo "  --check         Verifica aliases configurados"
    echo "  --help, -h      Mostra esta ajuda"
    echo
    echo "Exemplo de uso:"
    echo "  $0 --install"
    echo "  $0 --check"
    echo "  $0 --remove"
    echo
    echo "Multiplataforma: Linux, macOS, Windows (Git Bash/WSL)"
    echo "======================================================"
    exit 0
}

# -----------------------------------------------------------
# ▶️ Execução principal
# -----------------------------------------------------------
case "$1" in
    ""|--install)
        install_aliases ;;
    --remove)
        for rc_file in "${BASHRC_FILES[@]}"; do
            for alias_line in "${ALIASES[@]}"; do
                remove_alias "$alias_line" "$rc_file"
            done
        done
        red "❌ Aliases removidos com sucesso!" ;;
    --reinstall)
        reinstall_aliases ;;
    --check)
        check_aliases ;;
    --help|-h)
        show_help ;;
    *)
        red "❌ Opção inválida: $1"
        echo "Use '$0 --help' para ver as opções disponíveis."
        exit 1 ;;
esac
