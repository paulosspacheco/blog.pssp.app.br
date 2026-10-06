#!/bin/bash
# Program copyto.sh
# Exemplo de uso:
#  ./copyto.sh /PastaDestino /arquivos_de_exessão.txt

echo "Script: copyto.sh"
echo .
origem_invisivel="./.[^.]*"
origem="./*"
destino="$1"
except="$2"
if [ -z destino ]; then
 echo "O destino precisa ser informado"
 exit 1
fi  
echo .
echo "Copia para o DESTINO, somente os arquivos diferentes, ou os que a data de ORIGEM seja inferior a data de DESTINO."
echo "Origem_invisivel..: $origem_invisivel"
echo "Origem............: $origem"
echo "Destino...........: $destino"
echo "Exessão...........: $except"

echo .
echo "Cópia incremental".         
sudo rsync --exclude-from=$except --delete -arRvhui --progress $origem_invisivel $destino
sudo rsync --exclude-from=$except --delete -arRvhui --progress $origem $destino
result_cp="$?"
if [ $result_cp != 0 ]; then
 echo .
 echo algo errado na cópia
 exit 1;
fi


