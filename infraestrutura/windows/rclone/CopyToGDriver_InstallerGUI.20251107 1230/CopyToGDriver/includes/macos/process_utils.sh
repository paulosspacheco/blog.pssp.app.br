#!/bin/bash
# ===========================================================
# Linux: process_utils.sh
# ===========================================================

kill_process() {
    local process_name="$1"
    pkill "$process_name" 2>/dev/null
}

process_is_running() {
    local process_name="$1"
    pgrep "$process_name" >/dev/null
}
