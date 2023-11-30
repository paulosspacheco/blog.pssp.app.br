<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Instruções de instalação para xrdp

* Coisas que você precisa para compilar e instalar.
  * Obs: A maioria dos sistemas, os programas abaixo, não são instalados por padrão.

    ```bash
      sudo apt install gcc -y
      sudo apt install make -y

    ```

  * [Header files for pam](https://pubs.opengroup.org/onlinepubs/8329799/apdxa.htm)
  * Header files for openssll

* Você pode construir o _sesman_ sem _pam_, há um parâmetro _Makefile_ para isso.
* Eu também tenho um substituto _ssl_calls.c_ para evitar a dependência do _openssl_ envie um e-mail para mim (Jay) ou consulte http://server1.xrdp.org/xrdp/openssl. Devido à licença, não posso incluí-lo neste projeto.
  * <http://server1.xrdp.org/xrdp/openssl/>

* descompacte o _tarball_

  ```bash

    # Obs: O comando abaixo cria uma pasta xrdp
    tar -zxvf xrdp-0.1.tar.gz 
     
  
  ```

* mudar para a pasta xrdp e executar make em seguida make install:
  
  ```bash
    cd xrdp
    ./configure
    make
    sudo make install</pre>
  ```

  * Obs:
    * Os comandos acima instalará a maioria dos arquivos em _/usr/local/xrdp_. Alguns arquivos são instalados em _/etc/xrdp_. Estas são configurações arquivos.

* arquivos e localização
  * _/usr/local/xrdp/startwm.sh_ - script que inicia o gerenciador de janelas
  * Você pode precisar editar este arquivo para executar o gerenciador de janelas.
    * _/etc/sesman.ini_ - arquivo de configuração _sesman_
    * _/etc/rsakeys.ini_ - coisas _rsa_
    * _/etc/xrdp.ini_ - arquivo de configuração xrdp
    * _/var/run/sesman.pid_
    * _/var/rub/xrdp.pid_

* _Sesman_ e _xrdp_ devem estar rodando como _root_. Você deve configurá-los para iniciar quando o sistema for iniciado. Você pode usar o script _xrdp_control.sh_ para iniciá-los.

* Para remover completamente o _xrdp_
  * remover diretório _/usr/local/xrdp_
  * remover diretório _/etc/xrdp_
  * remova o arquivo _/var/run/xrdp.pid_
  * remova o arquivo _/var/run/sesman.pid_
  * remova quaisquer links de inicialização adicionados a _/etc/init.d_ ou _/etc/rcX.d_
  
Escrito por: _jay.sorg@gmail.com_

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
