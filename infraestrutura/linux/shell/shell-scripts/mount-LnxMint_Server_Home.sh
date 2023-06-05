#!/bin/bash
#set -x # habilita debug
#set +x # desabilita debug

echo "Executa a maquina virtual ubuntu-server-mate e monta a pasta LnxMint_Server_Home"
echo "********************************************************************************."

echo "Compartilhando pastas <LnxMint_Server_Home> da máquina virtual <lnxmint-server>"
echo "*******************************************************************************"

echo "Iniciando Máquina Virtual: <lnxmint-server>"
echo "*******************************************************************************"

cd ~/blog.pssp.app.br/infraestrutura/linux/shell/shell-scripts
echo Monta a pasta LnxMint_Server_Home
sh "./exec3.sh" \
"vboxheadless -v off --startvm lnxmint-server" \
30 \
"sudo mount 192.168.15.3:/home /home/paulosspacheco/LnxMint_Server_Home"         
             
echo "*******************************************************************************"
resp="n"
read -p "Tecle <s> para desmontar a pasta <LnxMint_Server_Home>" resp
echo $resp

while [ $resp != "s" ]
do  sleep 5 
    read -p "Tecle <s> para desmontar a pasta LnxMint_Server_Home ..." resp
done

echo Desmontando compartilhamentos
echo "*******************************************************************************"

sh ./umount.sh ~/LnxMint_Server_Home

echo Desativando maquina virtual "ubuntu-server-mate"
echo "*******************************************************************************"
vboxmanage controlvm "lnxmint-server" poweroff

echo "Fim do script"
echo "Status = $?"
echo "*******************************************************************************"

exit $? # retorna o numero do erro
