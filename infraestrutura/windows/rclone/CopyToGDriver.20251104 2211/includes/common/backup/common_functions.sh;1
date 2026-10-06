#!/bin/bash
# ===========================================================
# Módulo comum: common_functions.sh
# Funções utilitárias neutras (usadas em Checks e Cache)
# ===========================================================

normalize_path() {
    local path="$1"
    echo "$path" | sed 's/\\/\//g'
}

ensure_directory() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir"
}

convert_to_gb() {
    local kb=$1
    echo $((kb / 1024 / 1024))
}

file_count() {
    local dir="$1"
    find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l
}
