#!/bin/bash
#set -x # habilita debug
#set +x # desabilita debug

#echo "Executa a maquina virtual ubuntu-server-mate e monta a pasta blogger"
#echo "..."

echo "Compartilhando pastas <blogger> <documentos> <>downloads> <imagens> <modelos> <musicas> <publico> <videos> da máquina virtual <ubuntu-server-mate> e a pasta <HD-3TB-paulosspacheco>"
echo -

#echo "Iniciando Máquina Virtual: <ubuntu-server-mate>"
#echo .

cd ~/Documentos/shell-scripts


echo Monta a pasta blogger
#sh "./exec3.sh" \
#"vboxheadless -v off --startvm ubuntu-server-mate" \
#30 \
#"sudo mount -t cifs //ubuntu-server-mate.local/blogger -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Documentos/blogger"

sudo mount -t cifs //ubuntu-server-mate.local/blogger -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Documentos/blogger

echo Monta a pasta documentos
sudo mount -t cifs //ubuntu-server-mate.local/documentos -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Documentos/documentos

echo Monta a pasta downloads
sudo mount -t cifs //ubuntu-server-mate.local/downloads -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Downloads/downloads

echo Monta a pasta imagens
sudo mount -t cifs //ubuntu-server-mate.local/imagens -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Imagens/imagens

echo Monta a pasta modelos
sudo mount -t cifs //ubuntu-server-mate.local/modelos -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Modelos/modelos

echo Monta a pasta musicas
sudo mount -t cifs //ubuntu-server-mate.local/musicas -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Música/musicas

echo Monta a pasta publico
sudo mount -t cifs //ubuntu-server-mate.local/publico -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Público/publico

echo Monta a pasta videos
sudo mount -t cifs //ubuntu-server-mate.local/videos/ -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Vídeos/videos

echo ...
#echo monta a pasta HD-3TB-paulosspacheco
#sudo mount -B /media/paulosspacheco/HD-3TB/paulosspacheco ~/HD-3TB-paulosspacheco
             
echo .
resp="n"
read -p "Tecle <s> para desmontar a pasta <Blogger>" resp
echo $resp

while [ $resp != "s" ]
do  sleep 5 
    read -p "Tecle <s> para desmontar a pasta Blogger ..." resp
done

echo .
echo Desmontando compartilhamentos
sh ./umountall.sh

#echo Desativando maquina virtual "ubuntu-server-mate"
#vboxmanage controlvm "ubuntu-server-mate" poweroff



