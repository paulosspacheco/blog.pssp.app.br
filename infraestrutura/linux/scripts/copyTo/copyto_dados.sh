#!/bin/bash

echo "Sincroniza todos os arquivo para /media/paulosspacheco/dados"

# Sintaxe: copyTo.sh "Arquivo destino da cópia" "Arquivos que contém os arquivos a serem ignorados" 
./copyto.sh "/media/paulosspacheco/dados" "./copyto_dados_ignore.txt"

