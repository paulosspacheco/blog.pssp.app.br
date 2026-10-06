#!/bin/bash
# ======================================================
# Script: copyto_hd500gb.sh
# Objetivo: Sincroniza todos os arquivos da pasta atual
#           para o HD externo /media/paulosspacheco/hd500gb
# ======================================================

DESTINO="/media/paulosspacheco/hd500gb"
EXCECOES="./copyto_hd500gb_ignore.txt"
SCRIPT_BASE="./copyto.sh"

echo "======================================================"
echo "🔄 Sincroniza todos os arquivos para: $DESTINO"
echo "======================================================"
echo

# 🔍 Verifica se o HD está montado
if ! mountpoint -q "$DESTINO"; then
  echo "⚠️  O destino $DESTINO não está montado!"
  echo "Conecte o HD externo e monte-o antes de continuar."
  exit 1
fi

# 🧩 Verifica se o script base existe
if [ ! -x "$SCRIPT_BASE" ]; then
  echo "❌ O script base '$SCRIPT_BASE' não foi encontrado ou não tem permissão de execução."
  exit 1
fi

# 🧾 Mostra os parâmetros
echo "Origem .........: Pasta atual ($(pwd))"
echo "Destino ........: $DESTINO"
echo "Exceções .......: $EXCECOES"
echo
sleep 1

# 💡 Teste de simulação (modo seguro)
echo "======================================================"
echo "🔍 Etapa 1: Teste (dry-run) — nenhuma alteração será feita"
echo "======================================================"
$SCRIPT_BASE "$DESTINO" "$EXCECOES" --dry-run
echo
read -p "Deseja continuar com a cópia real? (s/n): " CONFIRMA
if [[ "$CONFIRMA" != "s" && "$CONFIRMA" != "S" ]]; then
  echo "Operação cancelada."
  exit 0
fi

# 🚀 Cópia real
echo
echo "======================================================"
echo "⚙️  Etapa 2: Cópia real iniciada..."
echo "======================================================"
$SCRIPT_BASE "$DESTINO" "$EXCECOES"

# ✅ Verificação final
if [ $? -eq 0 ]; then
  echo
  echo "✅ Sincronização concluída com sucesso."
else
  echo
  echo "⚠️  Ocorreu um erro durante a sincronização."
  exit 1
fi

