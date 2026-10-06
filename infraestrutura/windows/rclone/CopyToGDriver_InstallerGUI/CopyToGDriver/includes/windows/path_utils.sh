#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: path_utils.sh (v1.0.2)
# Função: Utilitários de conversão de caminhos para Windows ↔ Git Bash
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================
#
# 🧭 Descrição:
# Este módulo contém funções simples e confiáveis para converter caminhos
# entre o formato Windows (C:\Users\...) e Git Bash (/c/Users/...).
# Compatível com ambientes Windows nativos, Git Bash e WSL.
#
# ===========================================================

# -----------------------------------------------------------
# 🔹 Converte /c/Users/... → C:\Users\...
# -----------------------------------------------------------
to_windows_path() {
    local path="$1"
    echo "$path" | sed -E 's|^/([a-zA-Z])/(.*)|\1:\\\2|' | sed 's|/|\\|g'
}

# -----------------------------------------------------------
# 🔹 Converte C:\Users\... → /c/Users/...
# -----------------------------------------------------------
to_gitbash_path() {
    local path="$1"
    echo "$path" | sed -E 's|^([A-Za-z]):\\|/\L\1/|' | sed 's|\\|/|g'
}

# -----------------------------------------------------------
# 🔹 Detecta se é caminho Windows (C:\...) ou Git Bash (/c/...)
# -----------------------------------------------------------
is_windows_path() {
    [[ "$1" =~ ^[A-Za-z]:\\ ]]
}

# -----------------------------------------------------------
# 🧪 Exemplo de uso
# -----------------------------------------------------------
# source ./includes/windows/path_utils.sh
#
# echo "🪟 Windows → Bash:"
# echo "   $(to_gitbash_path 'C:\\Users\\Paulo\\Documentos')"
#
# echo "🐧 Bash → Windows:"
# echo "   $(to_windows_path '/c/Users/Paulo/Documentos')"
#
# echo "🔍 Detectar tipo:"
# is_windows_path "C:\\Temp" && echo "É Windows" || echo "Não é Windows"
#
# ===========================================================
