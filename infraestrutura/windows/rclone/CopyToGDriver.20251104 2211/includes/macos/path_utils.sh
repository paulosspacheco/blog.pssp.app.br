#!/bin/bash
# ===========================================================
# Linux: path_utils.sh
# ===========================================================

resolve_path() {
    local path="$1"
    readlink -f "$path" 2>/dev/null || echo "$path"
}
