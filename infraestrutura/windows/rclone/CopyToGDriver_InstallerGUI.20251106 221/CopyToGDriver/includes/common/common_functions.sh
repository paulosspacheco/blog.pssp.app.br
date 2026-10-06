#!/bin/bash
# ======================================================
# CopyToGDriver – Funções comuns
# ======================================================

# Garante que um diretório exista
ensure_directory() {
  local dir="$1"
  [[ -d "$dir" ]] || mkdir -p "$dir"
}

# Conta arquivos em um diretório
file_count() {
  local dir="$1"
  [[ -d "$dir" ]] && find "$dir" -type f | wc -l || echo 0
}

# Resolve caminho absoluto
resolve_path() {
  local path="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$path"
  else
    cd "$(dirname "$path")" && pwd -P
  fi
}

