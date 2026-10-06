#!/bin/bash
# ======================================================
# Script: CopyToGDriver_CopyCurrent.sh
# Autor: Paulo SSPacheco + ChatGPT (GPT-5)
# Data: 01/11/2025
# Versão: 0.4.1 (centralização de logs e estrutura aprimorada)
#
# Objetivo:
#   Sincronizar a pasta corrente com o Google Drive,
#   detectando automaticamente o disco e caminho relativo.
#
# Recursos:
#   ✅ Funciona em qualquer diretório de qualquer disco
#   ✅ Usa discos registrados em ~/.config/CopyToGDriver/disks_registry.conf
#   ✅ Monta caminho remoto hierárquico (rclone/<caminho_relativo>)
#   ✅ Protege contra sobrescrita após restauração
#   ✅ Suporta modo automático (--auto)
#   ✅ Logs centralizados em ~/CopyToGDriver_Log/
# ======================================================

# ======================================================
# 🔧 CONFIGURAÇÕES INICIAIS
# ======================================================
# Determina o caminho base usando a variável de ambiente configurada pelo instalador
: "${COPYTOGDRIVER_PATH:=/c/scripts/CopyToGDriver}"
: "${SCRIPT_NAME:=${COPYTOGDRIVER_PATH}/CopyToGDriver.sh}"
: "${BASE_REMOTE_FOLDER:=rclone}"
: "${DELETED_BASE_FOLDER:=rclone.deleted}"
REMOTE_NAME="gdriver"
ORIGEM="./"
EXCECOES="./CopyToGDriver_ignore.txt"


LOG_ROOT="$HOME/CopyToGDriver_Log"
LOG_DIR="$LOG_ROOT/system"
RESTORE_MARKER="$LOG_ROOT/.restore_aborted"
DISK_REGISTRY="$HOME/.config/CopyToGDriver/disks_registry.conf"

# ======================================================
# 🧾 Preparação
# ======================================================
LOCAL_FOLDER="$(cd "$ORIGEM" && pwd)"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/sync-$(basename "$LOCAL_FOLDER")-$TIMESTAMP.log"

AUTO_MODE=false
for arg in "$@"; do
  [[ "$arg" == "--auto" ]] && AUTO_MODE=true && break
done

# ======================================================
# 💽 Função: Detectar o disco base e caminho relativo
# ======================================================
get_disk_base_path() {
  local folder="$1"
  local registry="$DISK_REGISTRY"

  if [[ ! -f "$registry" ]]; then
    echo "⚠️  Registro de discos não encontrado: $registry"
    echo "   Execute novamente o instalador do CopyToGDriver."
    echo "   Usando fallback para base '/mnt'."
    echo "/mnt"
    return
  fi

  local best_match=""
  local longest_match=0

  while IFS='=' read -r path _; do
    path=$(echo "$path" | xargs)
    [[ -z "$path" || "$path" == \[*\] ]] && continue

    if [[ "$folder" == "$path"* ]]; then
      local len=${#path}
      if (( len > longest_match )); then
        longest_match=$len
        best_match="$path"
      fi
    fi
  done < "$registry"

  if [[ -z "$best_match" ]]; then
    echo "⚠️  Nenhum disco correspondente encontrado em $registry."
    echo "   Fallback: usando /mnt como base."
    echo "/mnt"
  else
    echo "$best_match"
  fi
}

# ======================================================
# 🧩 Determina caminho remoto seguro e relativo
# ======================================================
DISK_BASE=$(get_disk_base_path "$LOCAL_FOLDER")
RELATIVE_PATH="${LOCAL_FOLDER#${DISK_BASE}/}"
REMOTE_FOLDER="$RELATIVE_PATH"

REMOTE_FOLDER=$(echo "$REMOTE_FOLDER" | sed 's|//*|/|g' | sed 's|^/||')
[[ -z "$REMOTE_FOLDER" ]] && REMOTE_FOLDER="$(basename "$LOCAL_FOLDER")"

# ======================================================
# 🧭 CABEÇALHO INFORMATIVO
# ======================================================
echo "======================================================"
echo "🔄 Sincronização com Google Drive (CopyToGDriver)"
echo "======================================================"
echo "📂 Pasta local ......: $LOCAL_FOLDER"
echo "💽 Disco base .......: $DISK_BASE"
echo "🧭 Caminho relativo ..: $RELATIVE_PATH"
echo "☁️  Remote Rclone ....: $REMOTE_NAME"
echo "📁 Pasta remota ......: $BASE_REMOTE_FOLDER/$REMOTE_FOLDER"
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

if [[ "$ROOT_PATH" == *"/Trash/"* ]]; then
  echo "❌ ERRO: O script principal está na Lixeira: $ROOT_PATH"
  exit 1
fi

if [[ -z "$ROOT_PATH" ]]; then
  echo "❌ ERRO: Não encontrei o script principal '$SCRIPT_NAME'."
  echo "   Dica: export SCRIPT_NAME=/caminho/para/CopyToGDriver.sh"
  exit 1
fi

echo "📄 Script principal localizado em: $ROOT_PATH"
echo

# ======================================================
# ⚠️ INTERROMPE SE RESTAURAÇÃO FOI FEITA
# ======================================================
if [[ -f "$RESTORE_MARKER" ]]; then
  echo "🛑 Detectado processo de restauração recente."
  echo "🚫 Sincronização abortada para evitar sobrescrita."
  rm -f "$RESTORE_MARKER"
  exit 0
fi

# ======================================================
# 🧰 FUNÇÃO DE EXECUÇÃO
# ======================================================
run_sync() {
  local mode="$1"

  if [[ -f "$EXCECOES" ]]; then
    export RCLONE_EXCLUDE_FILE="$EXCECOES"
    echo "🚫 Aplicando exclusões: $RCLONE_EXCLUDE_FILE"
  else
    unset RCLONE_EXCLUDE_FILE
    echo "ℹ️  Nenhum arquivo de exclusão encontrado."
  fi

  local SAFE_REMOTE_PATH="$BASE_REMOTE_FOLDER/$REMOTE_FOLDER"
  echo "⚙️  Caminho remoto final: $SAFE_REMOTE_PATH"

  local args=(
    --auto-create
    --clean-cache
    --verbose
    --local-folder "$LOCAL_FOLDER"
    --remote-name "$REMOTE_NAME"
    --remote-folder "$SAFE_REMOTE_PATH"
  )

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

  bash "$ROOT_PATH" "${args[@]}" 2>&1 | tee "$LOG_FILE"
  local rc=$?

  [[ -f "$RESTORE_MARKER" ]] && {
    echo "🛑 Restauração detectada — sincronização abortada."
    rm -f "$RESTORE_MARKER"
    exit 0
  }

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
  echo "⚠️  Simulação retornou erro. Verifique o log: $LOG_FILE"
  if [[ "$AUTO_MODE" == "false" ]]; then
    read -p "Mesmo assim deseja continuar (s/n)? " CONF
    [[ "$CONF" =~ ^[sS]$ ]] || exit 1
  fi
else
  if [[ "$AUTO_MODE" == "false" ]]; then
    read -p "Deseja continuar com a sincronização real? (s/n): " CONF
    [[ "$CONF" =~ ^[sS]$ ]] || exit 0
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
