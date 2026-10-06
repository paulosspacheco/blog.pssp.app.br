#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Módulo: CopyToGDriver_AliasSetup.sh
# Função: Instala aliases globais para facilitar o uso do sistema
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Versão: 1.0.0
# Data: 31/10/2025
# ===========================================================

set -e

# ===========================================================
# 📘 DESCRIÇÃO
# ===========================================================
# Este script cria aliases globais no shell do usuário:
#   • copydrive  → executa sincronização da pasta atual
#   • copycheck  → valida se o sistema CopyToGDriver está configurado corretamente
#
# Compatível com:
#   • Linux (bash / zsh)
#   • Git Bash (Windows)
# ===========================================================

# ===========================================================
# ⚙️ CONFIGURAÇÕES INICIAIS
# ===========================================================
BASE_DIR="$HOME/scripts/CopyToGDriver"
ALIAS_LINE_DRIVE="alias copydrive='bash \"$BASE_DIR/CopyToGDriver_CopyCurrent.sh\"'"
ALIAS_LINE_CHECK="alias copycheck='bash \"$BASE_DIR/CopyToGDriver.sh\" --check-only'"
BASHRC_FILES=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc")

# ===========================================================
# 🧩 FUNÇÃO: add_alias
# ===========================================================
add_alias() {
    local alias_line="$1"
    local rc_file="$2"

    # Ignorar se o arquivo não existe
    [[ -f "$rc_file" ]] || return

    # Verificar se o alias já existe
    if grep -Fq "$alias_line" "$rc_file"; then
        echo "✅ Alias já existe em: $rc_file"
    else
        echo "$alias_line" >> "$rc_file"
        echo "🔗 Alias adicionado em: $rc_file"
    fi
}

# ===========================================================
# 🧩 FUNÇÃO: install_aliases
# ===========================================================
install_aliases() {
    echo "======================================================"
    echo "🔗 Instalando aliases globais do CopyToGDriver"
    echo "======================================================"

    for rc_file in "${BASHRC_FILES[@]}"; do
        add_alias "$ALIAS_LINE_DRIVE" "$rc_file"
        add_alias "$ALIAS_LINE_CHECK" "$rc_file"
    done

    echo
    echo "✅ Aliases adicionados com sucesso!"
    echo
    echo "📦 Comandos disponíveis a partir de agora:"
    echo "   • copydrive → sincroniza a pasta atual"
    echo "   • copycheck → verifica o ambiente CopyToGDriver"
    echo
    echo "💡 Dica: execute 'source ~/.bashrc' ou reinicie o terminal."
}

# ===========================================================
# ▶️ EXECUÇÃO PRINCIPAL
# ===========================================================
install_aliases
