#!/bin/bash
# ===========================================================
# Windows: process_utils.sh
# ===========================================================

kill_process() {
    local process_name="$1"
    taskkill /f /im "${process_name}.exe" 2>/dev/null
}

process_is_running() {
    local process_name="$1"
    tasklist /fi "imagename eq ${process_name}.exe" | grep -iq "${process_name}.exe"
}
