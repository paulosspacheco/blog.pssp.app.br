#!/bin/bash
# ===========================================================
# CopyToGDriver – Windows Process Utilities (v1.0.0)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

# 🔹 Mata processo por nome (silencioso)
kill_process() {
    local proc="$1"
    taskkill //F //IM "$proc" 2>/dev/null || true
}

# 🔹 Verifica se processo está ativo
is_process_running() {
    local proc="$1"
    tasklist | grep -i "$proc" | grep -v grep >/dev/null
}

# 🔹 Lista processos que correspondem ao padrão
list_processes() {
    local pattern="$1"
    tasklist | grep -i "$pattern"
}

