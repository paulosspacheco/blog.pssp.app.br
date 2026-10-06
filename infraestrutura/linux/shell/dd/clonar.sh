#!/bin/bash
# Script seguro para clonar discos com dd
# Uso:               
#   sudo ./clonar.sh /dev/sdc /dev/sdb
#   sudo ./clonar.sh --dry-run /dev/sdc /dev/sdb   (simulação, não executa dd)
#   sudo ./clonar.sh --gzip /dev/sdc /dev/sdb      (gera log compactado)
#   sudo ./clonar.sh --ignore-size /dev/sdc /dev/sdb (ignora se destino for menor)

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
    echo "Exemplo real: $0 /dev/sda /dev/sdb"
    echo "Exemplo simulação: $0 --dry-run /dev/sda /dev/sdb"
    echo "Exemplo log compactado: $0 --gzip /dev/sda /dev/sdb"
    echo "Exemplo ignorando tamanho: $0 --ignore-size /dev/sda /dev/sdb"
    exit 1
fi

ORIGEM="$1"
DESTINO="$2"

# --- Função de log ---
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"
}

# --- Confere se os dispositivos existem ---
if [ ! -b "$ORIGEM" ]; then
    log "❌ Erro: Dispositivo de origem $ORIGEM não encontrado."
    exit 1
fi

if [ ! -b "$DESTINO" ]; then
    log "❌ Erro: Dispositivo de destino $DESTINO não encontrado."
    exit 1
fi

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
log "=================================="

# --- Verifica se destino é menor que origem ---
if [ "$SIZE_DESTINO" -lt "$SIZE_ORIGEM" ]; then
    if $IGNORE_SIZE; then
        log "⚠ Aviso: O disco de destino é menor que o de origem, mas a operação continuará devido à opção --ignore-size."
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

# --- Se for simulação, não executa ---
if $DRYRUN; then
    log "✅ Modo SIMULAÇÃO ativado."
    log "O comando que seria executado é:"
    log "dd if=$ORIGEM of=$DESTINO bs=64K status=progress conv=noerror,sync"
    log "📄 Log salvo em: $LOGFILE"
    if $GZIPLOG; then
        gzip "$LOGFILE"
        echo "📦 Log compactado: $LOGFILE.gz"
    fi
    exit 0
fi

# --- Execução do dd com segurança ---
START=$(date +%s)
log "🚀 Iniciando clonagem de $ORIGEM para $DESTINO..."
(dd if="$ORIGEM" of="$DESTINO" bs=64K status=progress conv=noerror,sync 2>&1) | tee -a "$LOGFILE"
sync
END=$(date +%s)

# --- Cálculo de tempo e velocidade ---
ELAPSED=$((END - START))
MBPS=$(awk -v size="$SIZE_ORIGEM" -v time="$ELAPSED" 'BEGIN { if (time>0) printf "%.2f", (size/1024/1024)/time; else print "0" }')

# --- Resumo ---
log "✅ Clonagem concluída!"
log "⏱ Tempo total: ${ELAPSED}s ($(printf "%02d:%02d:%02d" $((ELAPSED/3600)) $((ELAPSED%3600/60)) $((ELAPSED%60))))"
log "⚡ Velocidade média: ${MBPS} MB/s"
log "📄 Log final salvo em: $LOGFILE"

# --- Compacta log se solicitado ---
if $GZIPLOG; then
    gzip "$LOGFILE"
    echo "📦 Log compactado: $LOGFILE.gz"
fi
