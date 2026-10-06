#!/bin/bash
# ===========================================================
# Projeto: CopyToGDriver
# Script: crlf_protect.sh (v1.0.0)
# Função: Proteção Centralizada contra CRLF (auto-correção)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================
#
# 🧭 Descrição:
# Esta função detecta e remove automaticamente caracteres CRLF
# (caracteres de final de linha de origem Windows) em scripts Bash
# executados em ambientes Unix-like (Linux ou macOS).
#
# Isso evita erros como:
#   → "bad interpreter: No such file or directory"
#   → "command not found" causados por "\r"
#
# 💡 Compatibilidade:
# - ✅ Linux
# - ✅ macOS
# - ⚙️ Windows (não aplica — apenas detecta e ignora)
#
# ===========================================================

# -----------------------------------------------------------
# 🛡️ Função: crlf_auto_fix
# -----------------------------------------------------------
# 📋 Passos Internos:
#  1. Detecta o sistema operacional via `uname -s`
#  2. Se for Linux ou macOS, continua a verificação
#  3. Usa `grep -q $'\r' "$0"` para verificar se o script contém CRLF
#  4. Se houver, executa `sed -i 's/\r$//' "$0"` para remover os CRs
#  5. Reexecuta o script limpo com `exec "$0" "$@"` (mantendo argumentos)
#  6. Encerra o processo antigo com `exit $?`
# -----------------------------------------------------------

crlf_auto_fix() {
    # 🔍 1. Verifica se o sistema é Linux ou macOS
    if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then

        # ⚙️ 2. Remove todos os caracteres CR (\r) do final das linhas
        sed -i 's/\r$//' "$0"

        # 🔁 3. Reexecuta o script com os mesmos argumentos
        exec "$0" "$@"

        # 🚪 4. Encerra o processo antigo imediatamente
        exit $?
    fi
}
