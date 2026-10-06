#!/bin/bash
# Script seguro com modo assistente para clonar discos com ddrescue

LOGDIR="$HOME/clonar.log"
mkdir -p "$LOGDIR"
LOGFILE="$LOGDIR/clonar-$(date '+%Y%m%d-%H%M%S').log"

DRYRUN=false
GZIPLOG=false
IGNORE_SIZE=false

# --- Detecta opções ---
while [[ "$1" =~ ^-- ]]; do
    case "$1" in
        --dry-run) DRYRUN=true ;;
        --gzip) GZIPLOG=true ;;
        --ignore-size) IGNORE_SIZE=true ;;
        *) echo "❌ Opção desconhecida: $1"; exit 1 ;;
    esac
    shift
done

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"; }

# --- Lista discos disponíveis ---
echo "Discos disponíveis:"
DISCOS=($(lsblk -d -n -o NAME))
for i in "${!DISCOS[@]}"; do
    NAME="${DISCOS[$i]}"
    SIZE=$(lsblk -d -n -o SIZE /dev/$NAME)
    MODEL=$(lsblk -d -n -o MODEL /dev/$NAME)
    echo "$i) /dev/$NAME - $SIZE - $MODEL"
done

# --- Seleciona origem ---
read -p "Escolha o disco de ORIGEM (número): " IDX_ORIG
ORIGEM="/dev/${DISCOS[$IDX_ORIG]}"
if [ ! -b "$ORIGEM" ]; then
    log "❌ Disco de origem inválido!"
    exit 1
fi

# --- Seleciona destino ---
read -p "Escolha o disco de DESTINO (número): " IDX_DEST
DESTINO="/dev/${DISCOS[$IDX_DEST]}"
if [ ! -b "$DESTINO" ]; then
    log "❌ Disco de destino inválido!"
    exit 1
fi

# --- Verifica se destino está totalmente vazio ---
PARTS_DEST=$(lsblk -n -o NAME "$DESTINO" | grep -v "$(basename $DESTINO)")
FS_DEST=$(blkid "$DESTINO" 2>/dev/null)
if [ -n "$PARTS_DEST" ] || [ -n "$FS_DEST" ]; then
    log "❌ Erro: Destino $DESTINO não está vazio!"
    lsblk "$DESTINO" | tee -a "$LOGFILE"
    blkid "$DESTINO" | tee -a "$LOGFILE"
    log "⚠ Apague todas as partições/sistemas de arquivos antes de prosseguir."
    exit 1
fi

# --- Obtém tamanhos ---
SIZE_ORIGEM=$(blockdev --getsize64 "$ORIGEM")
SIZE_DESTINO=$(blockdev --getsize64 "$DESTINO")

# --- Exibe resumo e confirma ---
log "===== RESUMO ====="
log "Origem: $ORIGEM ($(lsblk -d -n -o SIZE,MODEL $ORIGEM))"
log "Destino: $DESTINO ($(lsblk -d -n -o SIZE,MODEL $DESTINO))"
echo "⚠ ATENÇÃO! Todo o conteúdo do destino será apagado!"

read -p "Digite 'sim' para continuar: " CONF1
if [[ "$CONF1" != "sim" ]]; then
    log "Operação cancelada."
    exit 0
fi

read -p "Digite 'CONFIRMAR' para prosseguir com a clonagem: " CONF2
if [[ "$CONF2" != "CONFIRMAR" ]]; then
    log "Operação cancelada."
    exit 0
fi

# --- Prepara comando ddrescue ---
RESCUE_LOG="$LOGDIR/ddrescue-$(date '+%Y%m%d-%H%M%S').log"
DDRESCUE_CMD="ddrescue -f -n $ORIGEM $DESTINO $RESCUE_LOG"

# --- Simulação ---
if $DRYRUN; then
    log "✅ Modo SIMULAÇÃO ativado."
    log "Comando que seria executado: $DDRESCUE_CMD"
    [ $GZIPLOG = true ] && gzip "$LOGFILE"
    exit 0
fi

# --- Executa clonagem ---
START=$(date +%s)
log "🚀 Iniciando clonagem..."
$DDRESCUE_CMD 2>&1 | tee -a "$LOGFILE"
sync
END=$(date +%s)

ELAPSED=$((END - START))
MBPS=$(awk -v size="$SIZE_ORIGEM" -v time="$ELAPSED" 'BEGIN { if(time>0) printf "%.2f", (size/1024/1024)/time; else print "0" }')
log "✅ Clonagem concluída em ${ELAPSED}s (${MBPS} MB/s)"
log "📄 Log ddrescue salvo em: $RESCUE_LOG"

# --- Compacta logs ---
if $GZIPLOG; then
    gzip "$LOGFILE"
    gzip "$RESCUE_LOG"
    echo "📦 Logs compactados: $LOGFILE.gz e $RESCUE_LOG.gz"
fi
