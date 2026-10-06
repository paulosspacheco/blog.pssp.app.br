#!/bin/bash
# ======================================================
# Script: borg_backup.sh
# Objetivo: Executar backups incrementais genéricos usando BorgBackup
# Autor: Paulo SSPacheco (versão final com caminhos relativos)
# ======================================================

# ======================
# Parâmetros
# ======================
NOME="$1"     # Nome do backup (ex: scripts, documentos, VM)
SRC="$2"      # Caminho de origem
DEST="$3"     # Caminho base de destino (ex: /media/.../borg_backup)
ENCRYPTION="${4:-none}"  # Tipo de criptografia (padrão: none)

# ======================
# Validação dos parâmetros
# ======================
if [ -z "$NOME" ] || [ -z "$SRC" ] || [ -z "$DEST" ]; then
    echo "Uso: $0 <nome> <origem> <destino> [criptografia]"
    echo "Exemplo: $0 scripts /home/paulo/scripts '/media/paulo/Novo volume/borg_backup' none"
    exit 1
fi

REPO="$DEST/$NOME/borg-repo"

echo "======================================================"
echo "💾 Backup genérico com BorgBackup"
echo "======================================================"
echo "Nome ...........: $NOME"
echo "Origem .........: $SRC"
echo "Destino ........: $DEST"
echo "Repositório ....: $REPO"
echo "Criptografia ...: $ENCRYPTION"
echo "======================================================"
echo

# ======================
# Função: verificar dependências
# ======================
check_dependencies() {
    if ! command -v borg &> /dev/null; then
        echo "⚠️ BorgBackup não encontrado. Instalando..."
        sudo apt update && sudo apt install -y borgbackup
        if [ $? -ne 0 ]; then
            echo "❌ Falha ao instalar borgbackup."
            exit 1
        fi
    fi
}

# ======================
# Função: parar VM se for VirtualBox
# ======================
stop_vm() {
    if VBoxManage list runningvms | grep -q "$NOME"; then
        echo "🛑 Máquina Virtual '$NOME' está rodando. Desligando..."
        VBoxManage controlvm "$NOME" acpipowerbutton
        sleep 15
        if VBoxManage list runningvms | grep -q "$NOME"; then
            echo "⚠️ Forçando desligamento..."
            VBoxManage controlvm "$NOME" poweroff
        fi
    fi
}

# ======================
# Função: executar backup
# ======================
run_backup() {
    mkdir -p "$(dirname "$REPO")"

    if [ ! -d "$REPO" ]; then
        echo "📦 Criando repositório Borg em $REPO ..."
        borg init --encryption="$ENCRYPTION" "$REPO"
    fi

    echo "💾 Iniciando backup incremental (modo relativo)..."
    (cd "$(dirname "$SRC")" && borg create --progress --stats "$REPO::backup-$(date +%F)" "$(basename "$SRC")")

    echo "🧹 Limpando backups antigos..."
    borg prune -v "$REPO" \
        --keep-daily=7 \
        --keep-weekly=4 \
        --keep-monthly=3

    echo "✅ Backup concluído com sucesso!"
}

# ======================
# Execução principal
# ======================
check_dependencies
stop_vm 2>/dev/null
run_backup

