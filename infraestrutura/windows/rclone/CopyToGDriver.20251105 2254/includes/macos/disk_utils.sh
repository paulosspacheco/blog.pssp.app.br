#!/bin/bash
# ===========================================================
# Linux: disk_utils.sh
# ===========================================================

get_disk_space_gb() {
    local path="$1"
    df "$path" 2>/dev/null | awk 'NR==2 {print int($4/1024/1024)}'
}

get_disk_usage_gb() {
    local path="$1"
    du -sb "$path" 2>/dev/null | awk '{print int($1/1024/1024)}'
}
