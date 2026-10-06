#!/bin/bash
# ===========================================================
# CopyToGDriver – Windows Disk Utilities (v1.0.0)
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# ===========================================================

# 🔹 Lista discos montados com informações básicas
list_disks() {
    wmic logicaldisk get name,volumename,freespace,size 2>/dev/null | awk 'NR>1 && NF>0'
}

# 🔹 Mostra espaço livre (texto bruto, útil para debug)
disk_free_space() {
    local drive="$1"
    wmic logicaldisk where "name='${drive}:'" get FreeSpace,Size 2>/dev/null
}

# 🔹 Retorna o espaço livre em GB (valor numérico)
get_disk_space_gb() {
    local path="$1"
    local drive_letter
    drive_letter=$(echo "$path" | sed -E 's|^/([a-zA-Z])/.*|\1:|')
    wmic logicaldisk where "DeviceID='${drive_letter}'" get FreeSpace 2>/dev/null | awk 'NR==2 {print int($1/1024/1024/1024)}'
}

# 🔹 Retorna o uso de um diretório em MB
get_disk_usage_gb() {
    local path="$1"
    du -sb "$path" 2>/dev/null | awk '{print int($1/1024/1024)}'
}

