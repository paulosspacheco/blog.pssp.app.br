#!/bin/bash
# Script seguro para clonar discos com ddrescue
# Uso:               
#   sudo ./clonar_ddrescue.sh /dev/sdc /dev/sdb
#   sudo ./clonar_ddrescue.sh --dry-run /dev/sdc /dev/sdb
#   sudo ./clonar_ddrescue.sh --gzip /dev/sdc /dev/sdb
#   sudo ./clonar_ddrescue.sh --ignore-size /dev/sdc /dev/sdb

# Diretório de logs na raiz do usuário
LOGDIR="$HOME/clonar.log"
mkdir -p "$LOGDIR"

# Nome do log baseado na data/hora
LOGFILE="$LOGDIR/clonar-$(date '+%Y%m%d-%H%M%S').log"

# Flags
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

# --- Verifica parâmetros obrigatórios ---
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 [--dry-run] [--gzip] [--ignore-size] <origem> <destino>"
    exit 1
fi

ORIGEM="$1"
DESTINO="$2"
RESCUE_LOG="$LOGDIR/ddrescue-$(date '+%Y%m%d-%H%M%S').log"

# --- Função de log ---
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"
}

# --- Confere se os dispositivos existem ---
for DEV in "$ORIGEM" "$DESTINO"; do
    if [ ! -b "$DEV" ]; then
        log "❌ Erro: Dispositivo $DEV não encontrado."
        exit 1
    fi
done

# --- Obtém tamanhos dos discos em bytes ---
SIZE_ORIGEM=$(blockdev --getsize64 "$ORIGEM")
SIZE_DESTINO=$(blockdev --getsize64 "$DESTINO")

# --- Mostra informações dos discos ---
log "===== INFORMAÇÕES DOS DISCOS ====="
log "Origem: $ORIGEM"
lsblk -d -o NAME,SIZE,MODEL,SERIAL "$ORIGEM" | tee -a "$LOGFILE"
log "Tamanho (bytes): $SIZE_ORIGEM"
log "Destino: $DESTINO"
lsblk -d -o NAME,SIZE,MODEL,SERIAL "$DESTINO" | tee -a "$LOGFILE"
log "Tamanho (bytes): $SIZE_DESTINO"
log "================================="

# --- Verifica se destino é menor que origem ---
if [ "$SIZE_DESTINO" -lt "$SIZE_ORIGEM" ]; then
    if $IGNORE_SIZE; then
        log "⚠ Aviso: Destino menor que origem, a clonagem continuará até o limite do destino."
    else
        log "❌ Erro: O disco de destino é MENOR que o de origem!"
        exit 1
    fi
fi

# --- Confirmação do usuário ---
read -p "Tem certeza que deseja clonar $ORIGEM para $DESTINO? (digite 'sim' para continuar) " CONFIRMA
if [[ "$CONFIRMA" != "sim" ]]; then
    log "Operação cancelada pelo usuário."
    exit 0
fi

# --- Comando ddrescue ---
DDRESCUE_CMD="ddrescue -f -n $ORIGEM $DESTINO $RESCUE_LOG"

# --- Simulação ---
if $DRYRUN; then
    log "✅ Modo SIMULAÇÃO ativado."
    log "O comando que seria executado é:"
    log "$DDRESCUE_CMD"
    log "📄 Log salvo em: $LOGFILE"
    if $GZIPLOG; then
        gzip "$LOGFILE"
        echo "📦 Log compactado: $LOGFILE.gz"
    fi
    exit 0
fi

# --- Executa ddrescue ---
START=$(date +%s)
log "🚀 Iniciando clonagem de $ORIGEM para $DESTINO com ddrescue..."
$DDRESCUE_CMD 2>&1 | tee -a "$LOGFILE"
sync
END=$(date +%s)

# --- Tempo e velocidade aproximada ---
ELAPSED=$((END - START))
MBPS=$(awk -v size="$SIZE_ORIGEM" -v time="$ELAPSED" 'BEGIN { if (time>0) printf "%.2f", (size/1024/1024)/time; else print "0" }')

# --- Resumo ---
log "✅ Clonagem concluída!"
log "⏱ Tempo total: ${ELAPSED}s ($(printf "%02d:%02d:%02d" $((ELAPSED/3600)) $((ELAPSED%3600/60)) $((ELAPSED%60))))"
log "⚡ Velocidade média aproximada: ${MBPS} MB/s"
log "📄 Log ddrescue salvo em: $RESCUE_LOG"

# --- Compacta log se solicitado ---
if $GZIPLOG; then
    gzip "$LOGFILE"
    gzip "$RESCUE_LOG"
    echo "📦 Logs compactados: $LOGFILE.gz e $RESCUE_LOG.gz"
fi
