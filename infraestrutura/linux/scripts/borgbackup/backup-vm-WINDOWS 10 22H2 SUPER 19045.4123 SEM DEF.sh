#!/bin/bash

# =========================
# Configuração
# =========================
VM_NAME="WINDOWS 10 22H2 SUPER 19045.4123 SEM DEF"
SRC="/home/paulosspacheco/v/VirtualBoxVMs/$VM_NAME"
DEST="/media/paulosspacheco/Novo volume/virtualbox/$VM_NAME"
REPO="$DEST/borg-repo"

# =========================
# Função: instalar Borg se necessário
# =========================
check_dependencies() {
    if ! command -v borg &> /dev/null; then
        echo "⚠️ BorgBackup não encontrado. Instalando com apt..."
        sudo apt update && sudo apt install -y borgbackup
        if [ $? -ne 0 ]; then
            echo "❌ Falha ao instalar borgbackup. Instale manualmente com: sudo apt install borgbackup"
            exit 1
        fi
    fi
}

# =========================
# Função: parar a VM antes do backup
# =========================
stop_vm() {
    if VBoxManage list runningvms | grep -q "$VM_NAME"; then
        echo "🛑 VM $VM_NAME está rodando. Solicitando desligamento..."
        VBoxManage controlvm "$VM_NAME" acpipowerbutton
        sleep 15

        # força desligar se ainda estiver rodando
        if VBoxManage list runningvms | grep -q "$VM_NAME"; then
            echo "⚠️ Forçando desligamento da VM..."
            VBoxManage controlvm "$VM_NAME" poweroff
        fi
    fi
}

# =========================
# Função: backup
# =========================
run_backup() {
    mkdir -p "$DEST"

    # Cria repositório se não existir (sem criptografia)
    if [ ! -d "$REPO" ]; then
        echo "📦 Inicializando repositório Borg sem criptografia em $REPO ..."
        borg init --encryption=none "$REPO"
    fi

    # Executa backup incremental
    echo "💾 Iniciando backup de $VM_NAME..."
    borg create --progress --stats \
        "$REPO::backup-$(date +%F)" \
        "$SRC"

    # Limpeza de backups antigos
    echo "🧹 Limpando backups antigos..."
    borg prune -v "$REPO" \
        --keep-daily=7 \
        --keep-weekly=4 \
        --keep-monthly=3

    echo "✅ Backup concluído com sucesso!"
}

# =========================
# Execução
# =========================
check_dependencies
stop_vm
run_backup

