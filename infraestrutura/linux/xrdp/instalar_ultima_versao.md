# Instruções de instalação para xrdp

* Coisas que você precisa para compilar e instalar. A maioria dos sistemas os programas abaixo não são instalados por padrão.
  * <pre>
      sudo apt install gcc -y
      sudo apt install make -y
    </pre>
  * [Header files for pam](https://pubs.opengroup.org/onlinepubs/8329799/apdxa.htm)
  * Header files for openssll

* Você pode construir o sesman sem pam, há um parâmetro Makefile para isso.
* Eu também tenho um substituto ssl_calls.c para evitar a dependência do openssl envie um e-mail para mim (Jay) ou consulte http://server1.xrdp.org/xrdp/openssl. Devido à licença, não posso incluí-lo neste projeto.
  * http://server1.xrdp.org/xrdp/openssl/

* descompacte o tarball
  * <pre>$ tar -zxvf xrdp-0.1.tar.gz </pre>
    * Obs: O comando acima irá criar uma pasta xrdp

* mudar para a pasta xrdp e executar make em seguida make install:
  * <pre>  
        $ cd xrdp
        $ ./configure
        $ make
        $ sudo make install</pre>

* Isso instalará a maioria dos arquivos em /usr/local/xrdp. Alguns arquivos são instalados em /etc/xrdp. Estas são configurações arquivos.

* arquivos e localização
  * /usr/local/xrdp/startwm.sh - script que inicia o gerenciador de janelas
  * Você pode precisar editar este arquivo para executar o gerenciador de janelas.
    * /etc/sesman.ini - arquivo de configuração sesman
    * /etc/rsakeys.ini - coisas rsa
    * /etc/xrdp.ini - arquivo de configuração xrdp
    * /var/run/sesman.pid
    * /var/rub/xrdp.pid

* Sesman e xrdp devem estar rodando como root. Você deve configurá-los para iniciar quando o sistema for iniciado. Você pode usar o script xrdp_control.sh para iniciá-los.

* Para remover completamente o xrdp
  * remover diretório /usr/local/xrdp
  * remover diretório /etc/xrdp
  * remova o arquivo /var/run/xrdp.pid
  * remova o arquivo /var/run/sesman.pid
  * remova quaisquer links de inicialização adicionados a /etc/init.d ou /etc/rcX.d
  
Escrito por: jay.sorg@gmail.com