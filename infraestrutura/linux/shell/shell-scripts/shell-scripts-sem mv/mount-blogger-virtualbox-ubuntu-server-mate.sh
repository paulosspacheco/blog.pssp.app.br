#!/bin/bash
#set -x # habilita debug
#set +x # desabilita debug

#echo "Executa a maquina virtual ubuntu-server-mate e monta a pasta blogger"
#echo "..."

echo "Compartilhando pastas <blogger> da máquina virtual <ubuntu-server-mate>"
echo -

#echo "Iniciando Máquina Virtual: <ubuntu-server-mate>"
#echo .


cd ~/Documentos/shell-scripts


echo Monta a pasta blogger

#sh "./exec3.sh" \
#"vboxheadless -v off --startvm ubuntu-server-mate" \
#30 \
#"sudo mount -t cifs //ubuntu-server-mate.local/blogger -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 / ~/Documentos/blogger
                                                                                                                                            

echo .
sudo mount -t cifs //ubuntu-server-mate.local/blogger -o username=paulosspacheco,password=Paulo195858,user,dir_mode=0777,file_mode=0777 ~/Documentos/blogger
             
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
sh ./umount.sh ~/Documentos/blogger

#echo Desativando maquina virtual "ubuntu-server-mate"
#vboxmanage controlvm "ubuntu-server-mate" poweroff


