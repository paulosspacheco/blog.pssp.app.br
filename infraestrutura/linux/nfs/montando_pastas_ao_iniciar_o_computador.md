<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como montar um dispositivo ou pasta ao iniciar o computador<a href="montando_pastas_ao_iniciar_o_computador.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. **Existe três tipos de montagem diferentes quais sejam:**
    1. [_mount_](https://linux.die.net/man/8/mount) – Comando usado para monta um sistema de arquivos.
    2. _/etc/fstab_ – Colocar o ponto de montagem para montar automaticamente ao inicializar o sistema.
    3. _SystemD_ – O queridinho, colocar o ponto de montagem para montar automaticamente ao inicializar o sistema de forma elegante.

2. **Comando [_Mount_](https://linux.die.net/man/8/mount)**
   1. O comando _mount_ é usado para montar pastas compartilhada de uma máquina ou de um servidor da rede
      1. Se o compartilhamento for samba do windows, usa-se o comando abaixo:

         ```bash

            # mount -t cifs <ORIGEM> <DESTINO> -o user=<USUARIO>,password=<SENHA>,domain=<DOMINIO>
            mount -t cifs //192.168.15.3/publico /mnt/backup/ -o user=paulosspacheco,password=1234,domain=itms

         ```

      2. Se o compartilhamento for NFS do linux, usa-se o comando abaixo:

           ```bash

               # Criar a pasta ~/LnxMint_Server_home no cliente para compartilhada a pasta /home do servidor         
               sudo mkdir -p ~/LnxMint_Server_Home

               # sudo mount host_ip:/home ~/LnxMint_Server_Home
               # Exemplo para o ip 192.168.15.3: 
               sudo mount 192.168.15.3:/home ~/LnxMint_Server_Home
      

           ```

      3. **Notas:**
         1. _mount_: Comando utilizado para realizar montagens no Linux.
         2. _-t_: Tipo de montagem. No nosso exemplo para acessar as pastas compartilhadas no Windows, utilizamos o tipo cifs.
         3. _origem_: O caminho de origem do compartilhamento de rede. Ex: //maquina01/publico ou //192.168.50.3/publico.
         4. _destino_: O ponto de montagem onde será montado o compartilhamento Ex: /mnt/backup.
         5. _-o_: Parâmetro utilizado para passar outras opções ao comando mount como por exemplo:
            1. _user_: Nome do usuário do domínio que tem permissão de leitura e gravação na pasta de origem compartilhada.
            2. _password_: Senha do usuário informado.
            3.

   2. Exemplo de script para montar uma pasta compartilhada que esteja em uma máquina VirtualBox:
      1. Script _exec3.sh_

         ```bash
            #!/bin/bash
            # Arquivo: ./exec3.sh

            # Este comando executa duas ações condicionalmente, onde a segundo só é executada se a primeira foi bem sucedida.
            # %1 recebe ação 1
            # %2 recebe o tempo em que deve esperar para executar a ção 2.
            # %3 recebe a ação 2 e só é executado se a ção 1 for bem sucedida.

            echo "Executando o parâmetro 1 = $1"
            echo "--------------------------------------------------------------"

            $1 & # executa parametro e não espera.  

            echo "Executando o parâmetro 2 = $2"
            echo "--------------------------------------------------------------"

            echo "Aguardando $2 segundos esperando a execução do parâmetro $1.."
            echo "--------------------------------------------------------------"

            sleep "$2" # aguarda o tempo informado no parametro 2
            echo "--------------------------------------------------------------"

            echo "Executando o parâmetro 3 = $3"
            echo "--------------------------------------------------------------"

            $3 #> /dev/null # excuta o terceiro parâmentro

            st=$?

            #Se houver erro na execução do primeiro parâmetro então executa do terceiro parâmetro
            while [ $st -ne 0 ]  
            do
               echo "Loop while Status = $st"
               echo "--------------------------------------------------------------"
               sleep 5
               $3 #s> /dev/null  #excuta o terceiro parâmentro
               st=$?
            done

            echo "Fim do script"
            echo "Status = $st"
            echo "--------------------------------------------------------------"

            exit $st # retorna o numero do erro


         ```

      2. Script _mount-LnxMint_Server_Home.sh_

         ```bash

            #!/bin/bash
            # Arquivo: ./mount-LnxMint_Server_Home.sh

            #set -x # habilita debug
            #set +x # desabilita debug

            echo "Executa a maquina virtual LnxMint_Server e monta a pasta LnxMint_Server_Home"
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

            echo Desativando maquina virtual "LnxMint_Server"
            echo "*******************************************************************************"
            vboxmanage controlvm "lnxmint-server" poweroff

            echo "Fim do script"
            echo "Status = $?"
            echo "*******************************************************************************"

            exit $? # retorna o numero do erro


         ```

3. **_/etc/fstab_ - Configuração do arquivo _/etc/fstab_ para que o dispositivo ou pasta compartilhada seja montado no boot do sistema.**
   1. Exemplo de configuração de montagem de um dispositivo físico no rquivo _/etc/fstab_:

      ```bash

         # /etc/fstab: static file system information.
         #
         # Use 'blkid' to print the universally unique identifier for a
         # device; this may be used with UUID= as a more robust way to name devices
         # that works even if disks are added and removed. See fstab(5).
         #
         # <file system> <mount point>   <type>  <options>       <dump>  <pass>
         # / was on /dev/sda3 during installation
         UUID=5d3c0e5f-2612-402a-947d-c9a9601d0a91 /               ext4    errors=remount-ro 0       1

         # /boot/efi was on /dev/sda2 during installation
         UUID=33C1-2359  /boot/efi  vfat    umask=0077      0       1               

         # pp Ativar unidade v
         UUID=e8b363f5-e732-4b85-bd68-40f839441e5a /home/paulosspacheco/v  ext4    defaults    0       0         
        

      ```

   2. Exemplo de configuração de montagem de um pasta compartilhada usando protocolo _NFS_ usando o arquivo _/etc/fstab_:
      1. Adiciona ao arquivo _/etc/fstab_ a linha abaixo:

         ```bash

            # host.myserver.com:/home /mnt/home nfs rw,hard,intr,rsize=8192,wsize=8192,timeo=14 0 0            
            192.168.15.3:/home ~/LnxMint_Server_Home nfs rw,hard,intr,rsize=8192,wsize=8192,timeo=14 0 0
            

         ```

         1. Notas:
            1. _192.168.15.3:/home_ : Pasta compartilhada do computador 192.168.15.3;
            2. ~/LnxMint_Server_Home : Nome da pasta na máquina cliente montada na raiz do usuário logado
            3. _rw_ Permitido leitura e escrita
            4. _hard_ : Usar hard quando se deseja que a máquina cliente só inicie se o ip _192.168.15.3_ responder.
            5. _intr_ : O processo pode ser interrompido. Quando o ip _192.168.15.3_ voltar a ficar online, o processo pode ser continuado de onde estava enquanto o servidor não respondia.
            6. _rsize_ e _wsize_ : Define o número máximo de bytes em cada solicitação READ/WRITE (obs: múltiplo inteiro positivo de 1024) que o cliente NFS pode receber/enviar ao se comunicar com um _servidor NFS 192.168.15.3_. O padrão depende da versão do kernel, mas normalmente é de 1.024 bytes.
            7. _time_ : Define o tempo (em décimos de segundo) que o cliente NFS espera por uma resposta antes de tentar novamente uma solicitação NFS.
            8. [Referência...](https://linuxopsys.com/topics/linux-nfs-mount-entry-in-fstab-with-example)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")