#!/bin/bash
# Script: copyto.sh
# Uso: ./copyto.sh /PastaDestino /arquivos_de_exessao.txt

echo "Script: copyto.sh"
echo

origem_invisivel="./.[^.]*"
origem="./*"
destino="$1"
except="$2"

if [ -z "$destino" ]; then
  echo "Erro: o destino precisa ser informado."
  echo "Uso: $0 <pasta_destino> <arquivo_excecoes>"
  exit 1
fi

if [ ! -f "$except" ]; then
  echo "Aviso: arquivo de exceções não encontrado ($except). Continuando sem exclusões."
  except=""
fi

echo
echo "Cópia incremental iniciada"
echo "Origem_invisivel..: $origem_invisivel"
echo "Origem............: $origem"
echo "Destino...........: $destino"
echo "Exceção...........: ${except:-nenhuma}"
echo

# Copia arquivos ocultos
rsync_opts="-arRvhui --progress --delete"
[ -n "$except" ] && rsync_opts="$rsync_opts --exclude-from=$except"

sudo rsync $rsync_opts $origem_invisivel "$destino"
sudo rsync $rsync_opts $origem "$destino"

if [ $? -ne 0 ]; then
  echo
  echo "⚠️ Algo deu errado na cópia."
  exit 1
fi

echo
echo "✅ Cópia concluída com sucesso."

