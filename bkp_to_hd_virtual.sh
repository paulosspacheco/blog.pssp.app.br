#!/bin/bash

#echo "copia todos os arquivo para smb://lnxmint-server.local/homes/Documentos/blog.pssp.app.br"
#bkp.sh . "smb://lnxmint-server.local/homes/Documentos/blog.pssp.app.br"

echo "Sincroniza todos os arquivo para smb://lnxmint-server.local/homes/Documentos/blog.pssp.app.br"
sudo rsync -zrRvh ./* "smb://lnxmint-server.local/homes/Documentos/blog.pssp.app.br"
         

