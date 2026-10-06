#!/bin/bash
# ===========================================================
# CopyToGDriver – Windows Path Utilities (v1.0.0)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

# 🔹 Converte /c/Users/... → C:\Users\...
to_windows_path() {
    local path="$1"
    echo "$path" | sed -E 's|^/([a-zA-Z])/(.*)|\1:\\\2|' | sed 's|/|\\|g'
}

# 🔹 Converte C:\Users\... → /c/Users/...
to_gitbash_path() {
    local path="$1"
    echo "$path" | sed -E 's|^([A-Za-z]):\\|/\L\1/|' | sed 's|\\|/|g'
}

# 🔹 Detecta se é caminho Windows ou Git Bash
is_windows_path() {
    [[ "$1" =~ ^[A-Za-z]:\\ ]]
}

