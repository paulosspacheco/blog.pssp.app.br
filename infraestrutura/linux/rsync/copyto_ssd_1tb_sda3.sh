#!/bin/bash

echo "Sincroniza todos os arquivo para /media/paulosspacheco/ssd_1tb_sda3"

# Sintaxe: copyTo.sh "Arquivo destino da cópia" "Arquivos que contém os arquivos a serem ignorados" 
./copyto.sh "/media/paulosspacheco/ssd_1tb_sda3" "./copyto_ssd_1tb_sda3_ignore.txt"

