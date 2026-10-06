#!/bin/bash
# ======================================================
# Script: CopyToGDriver_CopyCurrent.sh
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Data: 31/10/2025
# Versão: 0.3.1
#
# Objetivo:
#   Sincronizar a pasta corrente com o Google Drive,
#   usando o sistema modular CopyToGDriver.
#
# Recursos:
#   ✅ Funciona em qualquer diretório
#   ✅ Usa variável de ambiente SCRIPT_NAME (ou padrão)
#   ✅ Detecta automaticamente o script principal
#   ✅ Integra-se às variáveis BASE_REMOTE_FOLDER e DELETED_BASE_FOLDER
#   ✅ Executa simulação antes da sincronização real
#   ✅ Aborta automaticamente se uma restauração ocorrer
# ======================================================

# ======================================================
# 🔧 CONFIGURAÇÕES INICIAIS
# ======================================================
: "${SCRIPT_NAME:=/home/paulosspacheco/scripts/CopyToGDriver/CopyToGDriver.sh}"   # Script principal
: "${BASE_REMOTE_FOLDER:=rclone}"            # Pasta base principal no Drive
: "${DELETED_BASE_FOLDER:=rclone.deleted}"   # Pasta base para backups
REMOTE_NAME="gdriver"                        # Remote configurado no Rclone
ORIGEM="./"                                  # Pasta de origem (padrão: atual)
REMOTE_FOLDER="$(basename "$(pwd)")"         # Nome da pasta remota = pasta atual
EXCECOES="./CopyToGDriver_ignore.txt"        # Lista de exclusões locais
LOG_DIR="$HOME/.rclone-sync/logs"            # Diretório central de logs
RESTORE_MARKER="$LOG_DIR/.restore_aborted"   # Indicador de restauração
# ======================================================

# 📂 Resolve caminho absoluto da pasta local
LOCAL_FOLDER="$(cd "$ORIGEM" && pwd)"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_FILE="$LOG_DIR/sync-$REMOTE_FOLDER-$TIMESTAMP.log"

# ⚙️ Detecta modo automático (--auto)
AUTO_MODE=false
for arg in "$@"; do
  [[ "$arg" == "--auto" ]] && AUTO_MODE=true && break
done

# ======================================================
# 🧩 CABEÇALHO INFORMATIVO
# ======================================================
echo "======================================================"
echo "🔄 Sincronização com Google Drive (CopyToGDriver)"
echo "======================================================"
echo "📂 Pasta origem .....: $ORIGEM"
echo "📂 Pasta local ......: $LOCAL_FOLDER"
echo "☁️  Remote Rclone ....: $REMOTE_NAME"
echo "📁 Pasta remota ......: $REMOTE_FOLDER"
echo "🌐 Pasta base remota .: $BASE_REMOTE_FOLDER/"
echo "🗑️  Pasta de backup ...: $DELETED_BASE_FOLDER/"
echo "🚫 Arquivo ignore ....: ${EXCECOES:-nenhum}"
echo "📜 Log ...............: $LOG_FILE"
echo "======================================================"
echo

# ======================================================
# 🧱 VERIFICAÇÕES BÁSICAS
# ======================================================
if ! command -v rclone &>/dev/null; then
  echo "❌ ERRO: Rclone não está instalado."
  echo "   Instale com: curl https://rclone.org/install.sh | sudo bash"
  exit 1
fi

# 🔍 Localiza o script principal
if [[ -x "$SCRIPT_NAME" ]]; then
  ROOT_PATH="$SCRIPT_NAME"
else
  ROOT_PATH=$(find "$HOME" /mnt /media /srv /opt -maxdepth 5 -type f -name "$(basename "$SCRIPT_NAME")" 2>/dev/null | head -n1)
fi

if [[ -z "$ROOT_PATH" ]]; then
  echo "❌ ERRO: Não encontrei o script principal '$SCRIPT_NAME'."
  echo "   Dica: defina a variável de ambiente SCRIPT_NAME ou coloque o arquivo no PATH."
  echo "   Exemplo: export SCRIPT_NAME=CopyToGDriver.sh"
  exit 1
fi

echo "📄 Script principal localizado em: $ROOT_PATH"
mkdir -p "$LOG_DIR"

# ======================================================
# ⚠️ INTERROMPE SE RESTAURAÇÃO FOI FEITA
# ======================================================
if [[ -f "$RESTORE_MARKER" ]]; then
  echo
  echo "🛑 Detectado processo de restauração recente."
  echo "🚫 A sincronização foi abortada automaticamente para evitar sobrescrita."
  echo "👉 Revise os arquivos restaurados e execute novamente se desejar."
  rm -f "$RESTORE_MARKER"
  exit 0
fi

# ======================================================
# 🧰 FUNÇÃO DE EXECUÇÃO
# ======================================================
run_sync() {
  local mode="$1"  # "dry" ou "real"

  # Se existir arquivo de exclusões, exporta variável
  if [[ -f "$EXCECOES" ]]; then
    export RCLONE_EXCLUDE_FILE="$EXCECOES"
    echo "🚫 Aplicando lista de exclusões: $RCLONE_EXCLUDE_FILE"
  else
    unset RCLONE_EXCLUDE_FILE
    echo "ℹ️  Nenhum arquivo de exclusão encontrado."
  fi

  # Parâmetros padrão enviados ao CopyToGDriver principal
  local args=(
    --auto-create
    --clean-cache
    --verbose
    --local-folder "$LOCAL_FOLDER"
    --remote-name "$REMOTE_NAME"
    --remote-folder "$REMOTE_FOLDER"
  )

  # Modo simulação
  if [[ "$mode" == "dry" ]]; then
    args+=(--dry-run)
    echo "🔍 Modo: simulação (dry-run)"
  else
    echo "🚀 Modo: sincronização real"
  fi

  echo
  echo "📜 Comando completo:"
  echo "   $ROOT_PATH ${args[*]}"
  echo "======================================================"
  echo

  mkdir -p "$(dirname "$LOG_FILE")"
  bash "$ROOT_PATH" "${args[@]}" 2>&1 | tee "$LOG_FILE"
  local rc=$?

  # ======================================================
  # 🛑 Se restauração foi detectada, abortar imediatamente
  # ======================================================
  if [[ -f "$RESTORE_MARKER" ]]; then
    echo
    echo "🛑 Detecção de restauração: processo interrompido com segurança."
    echo "🚫 Sincronização abortada automaticamente para evitar sobrescrita."
    echo "👉 Revise os arquivos restaurados e execute novamente se desejar."
    rm -f "$RESTORE_MARKER"
    exit 0
  fi

  return $rc
}

# ======================================================
# 💡 ETAPA 1: SIMULAÇÃO (DRY-RUN)
# ======================================================
echo
echo "======================================================"
echo "🔍 Etapa 1: Simulação — nenhuma alteração será feita"
echo "======================================================"

run_sync "dry"
DRY_EXIT=$?

# ======================================================
# ⚙️ DECISÃO DE CONTINUIDADE
# ======================================================
if [[ $DRY_EXIT -ne 0 ]]; then
  echo
  echo "⚠️  A simulação retornou erro. Verifique o log:"
  echo "    $LOG_FILE"
  if [[ "$AUTO_MODE" == "false" ]]; then
    read -p "Mesmo assim deseja tentar a sincronização real? (s/n): " CONFIRMA_ERR
    [[ "$CONFIRMA_ERR" =~ ^[sS]$ ]] || { echo "Operação cancelada."; exit 1; }
  else
    echo "⚠️  Continuando automaticamente (--auto)."
  fi
else
  if [[ "$AUTO_MODE" == "false" ]]; then
    echo
    read -p "Deseja continuar com a sincronização real? (s/n): " CONFIRMA
    [[ "$CONFIRMA" =~ ^[sS]$ ]] || { echo "Operação cancelada."; exit 0; }
  fi
fi

# ======================================================
# 🚀 ETAPA 2: EXECUÇÃO REAL
# ======================================================
echo
echo "======================================================"
echo "⚙️  Etapa 2: Sincronização real iniciada..."
echo "======================================================"

run_sync "real"
REAL_EXIT=$?

# ======================================================
# ✅ RESULTADO FINAL
# ======================================================
echo
if [[ $REAL_EXIT -eq 0 ]]; then
  echo "✅ Sincronização concluída com sucesso."
  echo "📄 Log: $LOG_FILE"
else
  echo "⚠️  Ocorreu um erro durante a sincronização."
  echo "📄 Consulte o log: $LOG_FILE"
  exit 1
fi
