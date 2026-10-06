#!/bin/bash
# -------------------------------------------------------------------------
# Script: copyto.sh
# Descrição: Sincroniza uma pasta local para outra, deixando o destino idêntico à origem.
#             Arquivos apagados ou sobrescritos são movidos para .deleted/YYYY-MM-DD/
#             e limpos automaticamente após N dias (--keep-days).
# Autor: versão segura e aprimorada
# Uso: ./copyto.sh [--dry-run] [--keep-days N] <pasta_destino> [arquivo_excecoes.txt]
# -------------------------------------------------------------------------

echo "Script: copyto.sh"
echo

# ------------------------------
# Opções padrão
# ------------------------------
dry_run=false
keep_days=30

# ------------------------------
# Parâmetros e flags opcionais
# ------------------------------
while [[ "$1" =~ ^-- ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      ;;
    --keep-days)
      shift
      keep_days="$1"
      ;;
    *)
      echo "❌ ERRO: Opção desconhecida: $1"
      echo "Uso: $0 [--dry-run] [--keep-days N] <pasta_destino> [arquivo_excecoes.txt]"
      exit 1
      ;;
  esac
  shift
done

destino="$1"
except="$2"
origem="$(pwd)"

# ------------------------------
# Validações de segurança
# ------------------------------
if [[ "$origem" == "/" || "$origem" == "$HOME" ]]; then
  echo "❌ ERRO: Não é permitido executar este script a partir de '$origem'."
  echo "Use uma pasta de projeto específica."
  exit 1
fi

if [ -z "$destino" ]; then
  echo "❌ ERRO: O destino precisa ser informado."
  echo "Uso: $0 [--dry-run] [--keep-days N] <pasta_destino> [arquivo_excecoes.txt]"
  exit 1
fi

if [ "$destino" == "/" ] || [ "$destino" == "$HOME" ]; then
  echo "❌ ERRO GRAVE: O destino não pode ser '/' nem '$HOME'."
  exit 1
fi

if [ -n "$except" ] && [ ! -f "$except" ]; then
  echo "⚠️  Aviso: Arquivo de exceções não encontrado ($except). Continuando sem exclusões."
  except=""
fi

# ------------------------------
# Exibe informações e confirma
# ------------------------------
echo "📂 Origem : $origem"
echo "📁 Destino: $destino"
echo "🚫 Exceções: ${except:-nenhuma}"
echo "🗓️  Retenção de backups: $keep_days dias"
[[ "$dry_run" == true ]] && echo "🔍 Modo SIMULAÇÃO ATIVADO — Nenhum arquivo será alterado."
echo

read -p "Deseja realmente sincronizar a origem para o destino? (s/N): " confirm
if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
  echo "Operação cancelada."
  exit 0
fi

# ------------------------------
# Configuração de backup e log
# ------------------------------
today=$(date +"%Y-%m-%d")
deleted_folder="$destino/.deleted/$today"
mkdir -p "$deleted_folder"

# Diretório de log baseado na pasta atual
base_folder="$(basename "$origem")"
log_folder="$HOME/${base_folder}_log"
mkdir -p "$log_folder"

# Arquivo de log com data/hora
timestamp=$(date +"%Y%m%d-%H%M%S")
logfile="$log_folder/copyto_${timestamp}.log"

echo "📜 Log: $logfile"
echo "🗑️  Arquivos removidos serão movidos para: $deleted_folder"
echo

# ------------------------------
# Opções do rsync
# ------------------------------
rsync_opts="-arRvhui --progress --delete --backup --backup-dir=$deleted_folder"

# Evita copiar a própria pasta de backup (.deleted) e a pasta de configuração interna
rsync_opts="$rsync_opts --exclude=.deleted --exclude=.Trash-*/ --exclude=.cache/"

# Se houver arquivo de exceções, adiciona ao rsync
[ -n "$except" ] && rsync_opts="$rsync_opts --exclude-from=$except"

# Se estiver em modo de simulação, adiciona flag correspondente
[[ "$dry_run" == true ]] && rsync_opts="$rsync_opts --dry-run"

# Redireciona o log do rsync para o arquivo configurado
rsync_opts="$rsync_opts --log-file=$logfile"

# ------------------------------
# Execução
# ------------------------------
echo "🕓 Iniciando sincronização..."
echo

sudo rsync $rsync_opts ./ "$destino"
rsync_exit=$?

# ------------------------------
# Limpeza de backups antigos
# ------------------------------
if [[ "$dry_run" == false && "$rsync_exit" -eq 0 ]]; then
  echo
  echo "🧹 Limpando backups com mais de $keep_days dias..."
  find "$destino/.deleted" -mindepth 1 -maxdepth 1 -type d -mtime +$keep_days -exec rm -rf {} \; 2>/dev/null
  echo "✅ Limpeza concluída."
fi

# ------------------------------
# Resultado final
# ------------------------------
echo
if [[ "$dry_run" == true ]]; then
  echo "✅ Simulação concluída. Nenhum arquivo foi alterado."
else
  echo "✅ Sincronização concluída com sucesso!"
  echo "🗂️  Itens removidos foram movidos para: $deleted_folder"
fi

echo "📜 Log salvo em: $logfile"

