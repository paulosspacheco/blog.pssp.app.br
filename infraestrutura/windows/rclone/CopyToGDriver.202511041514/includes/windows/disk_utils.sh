#!/bin/bash
# ===========================================================
# Windows: disk_utils.sh
# ===========================================================

get_disk_space_gb() {
    local path="$1"
    local drive_letter
    drive_letter=$(echo "$path" | sed -E 's|^/([a-zA-Z])/.*|\1:|')
    wmic logicaldisk where "DeviceID='${drive_letter}'" get FreeSpace | awk 'NR==2 {print int($1/1024/1024/1024)}'
}

get_disk_usage_gb() {
    local path="$1"
    du -sb "$path" 2>/dev/null | awk '{print int($1/1024/1024)}'
}
