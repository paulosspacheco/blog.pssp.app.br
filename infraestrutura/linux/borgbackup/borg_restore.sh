#!/bin/bash
# ======================================================
# Script: borg_restore.sh
# Objetivo: Restaurar backups feitos com BorgBackup
# Autor: Paulo SSPacheco (versão final corrigida)
# Compatível com Borg 1.x
# ======================================================

# ======================
# Parâmetros
# ======================
REPO="$1"          # Caminho do repositório Borg
DESTINO="$2"       # Pasta onde restaurar
SNAPSHOT="$3"      # Nome do snapshot opcional
ENCRYPTION="${4:-none}"  # Tipo de criptografia (padrão: none)

# ======================
# Função: ajuda
# ======================
usage() {
    echo "Uso: $0 <repositório> <destino> [snapshot] [criptografia]"
    echo
    echo "Exemplo: $0 /media/paulo/borg_backup/scripts/borg-repo /home/paulo/scripts/restaurado backup-2025-10-30"
    echo "Criptografia padrão: none"
    exit 1
}

# ======================
# Validação inicial
# ======================
if [ -z "$REPO" ] || [ -z "$DESTINO" ]; then
    usage
fi

if [ ! -d "$REPO" ]; then
    echo "❌ O repositório '$REPO' não existe ou não é um diretório válido."
    exit 1
fi

echo "======================================================"
echo "♻️  Restaurador genérico de backups BorgBackup"
echo "======================================================"
echo "Repositório ....: $REPO"
echo "Destino ........: $DESTINO"
echo "Snapshot .......: ${SNAPSHOT:-(último disponível)}"
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
            echo "❌ Falha ao instalar BorgBackup."
            exit 1
        fi
    fi
}

# ======================
# Função: listar snapshots
# ======================
listar_snapshots() {
    echo "📜 Listando backups disponíveis em: $REPO"
    borg list "$REPO" || {
        echo "❌ Falha ao listar snapshots. Verifique o repositório."
        exit 1
    }
}

# ======================
# Função: escolher snapshot (se não informado)
# ======================
escolher_snapshot() {
    if [ -z "$SNAPSHOT" ]; then
        echo
        echo "🔍 Nenhum snapshot especificado."
        echo "Abaixo estão os backups disponíveis:"
        echo
        listar_snapshots
        echo
        read -p "Digite o nome do snapshot a restaurar (ex: backup-2025-10-30): " SNAPSHOT
        if [ -z "$SNAPSHOT" ]; then
            echo "❌ Nenhum snapshot selecionado. Encerrando."
            exit 1
        fi
    fi
}

# ======================
# Função: simulação (dry-run)
# ======================
dry_run_restore() {
    echo "======================================================"
    echo "🧪 Etapa 1: Simulação (dry-run)"
    echo "======================================================"
    echo
    mkdir -p "$DESTINO"
    (
        cd "$DESTINO" || exit 1
        borg extract --dry-run --list --strip-components 3 "$REPO::$SNAPSHOT"
    )
    echo
    read -p "Deseja continuar com a restauração real? (s/n): " CONFIRMA
    if [[ "$CONFIRMA" != "s" && "$CONFIRMA" != "S" ]]; then
        echo "❌ Operação cancelada pelo usuário."
        exit 0
    fi
}

# ======================
# Função: restauração real
# ======================
real_restore() {
    echo "======================================================"
    echo "⚙️  Etapa 2: Iniciando restauração real..."
    echo "======================================================"
    mkdir -p "$DESTINO"
    (
        cd "$DESTINO" || exit 1
        borg extract --progress --list --strip-components 3 "$REPO::$SNAPSHOT"
    )
    if [ $? -eq 0 ]; then
        echo
        echo "✅ Restauração concluída com sucesso!"
        echo "Arquivos restaurados em: $DESTINO"
    else
        echo
        echo "❌ Erro durante a restauração!"
        exit 1
    fi
}

# ======================
# Execução principal
# ======================
check_dependencies
escolher_snapshot
dry_run_restore
real_restore

