#!/bin/bash
# ===========================================================
# Linux: path_utils.sh
# ===========================================================

# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi



resolve_path() {
    local path="$1"
    readlink -f "$path" 2>/dev/null || echo "$path"
}
