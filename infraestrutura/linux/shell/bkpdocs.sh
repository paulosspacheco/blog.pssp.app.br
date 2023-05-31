#!/bin/bash
# Program bkpDocs.sh
# Exemplo de uso:
#   ./bkpdocs.sh /PastaDestino

origem="./Documentos"
destino="$1"
if [-z $destino ]; then
  echo "O destino precisa ser informado"
  exit 1
fi  

echo "Atualiza o diretório $destino com os arquivos diferentes da "
echo "pasta $origem criado depois da ultima cópia."
echo "Cópia incremental".         
sudo cp -upvR $origem $destino

result_cp="$?"
if [ $result_cp != 0 ]; then
  echo algo errado na cópia
  exit 1;
fi
