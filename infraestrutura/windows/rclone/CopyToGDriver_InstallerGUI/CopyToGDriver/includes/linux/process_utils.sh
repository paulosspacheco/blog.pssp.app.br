#!/bin/bash
# ===========================================================
# Linux: process_utils.sh
# ===========================================================

# 🛡️ Proteção CRLF (5 linhas mágicas)
if [[ "$(uname -s)" =~ (Linux|Darwin) ]] && grep -q $'\r' "$0"; then
    sed -i 's/\r$//' "$0"
    exec "$0" "$@"
    exit $?
fi



kill_process() {
    local process_name="$1"
    pkill "$process_name" 2>/dev/null
}

process_is_running() {
    local process_name="$1"
    pgrep "$process_name" >/dev/null
}
