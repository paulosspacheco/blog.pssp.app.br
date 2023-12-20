<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como instalar o Servidor Web Apache2 no Linux Debian ou seus derivados  <a href="Instalacao.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. **Pressione as teclas _CTRL+ALT+T_ para entrar no terminal e digite:**

   ```sh
     
      sudo -i    

      # Atualiza o repositório     
      sudo apt update 

      # Atualiza todos os aplicativos instalados
      sudo apt upgrade 

      # Instala o servidor Apache2 
      sudo apt install apache2 

      # Instala a documentação do servidor Apache2
      sudo apt install apache2-doc 

      # Instala o navegador web modo texto usado pelo comando `apachectl fullstatus`
      sudo apt install w3m  

      # instala pacote para para que os protocolos CGI e FastCGI sejam ativados
      sudo apt-get install libapache2-mod-fcgid      

      # Checa se está tudo certo.
      sudo apachectl configtest           

   ```

2. **Ao instalar o pacote [Apache2](https://httpd.apache.org/ABOUT_APACHE.html), o instalador aciona o [systemd](https://en.wikipedia.org/wiki/Systemd) para iniciar e habilitar automaticamente o serviço [apache2](https://httpd.apache.org/ABOUT_APACHE.html). Você pode verificar se o serviço [apache2](https://httpd.apache.org/ABOUT_APACHE.html) está ativo(em execução) e ativado usando os seguintes comandos:**

    ```powershell

      #  Mostra se o servidor está ativo
      sudo systemctl is-active apache2

      #  Mostra se o servidor está habilitado
      sudo systemctl is-enabled apache2

      #  Mostra o status do servidor. Obs: Crt+C para sair da tela de status.
      sudo systemctl status apache2
    
    ```

3. **Configurando a diretiva _ServerName_.**
   1. Caso o comando _sudo apachectl configtest_  mostre o _erro AH00558_, então siga os passos a seguir para resolver:

      ```sh

         # edite o arquivo apache2.conf e adicione no final 
         # do arquivo apache2.conf a diretiva ` ServerName 127.0.0.1 ` 
         sudo xed /etc/apache2/apache2.conf

      ```

      1. O final do arquivo _apache2.conf_ deve ficar igual ao trecho abaixo:

         ```sh

            # Include the virtual host configurations:
            IncludeOptional sites-enabled/*.conf
            
            # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
            
            # A diretiva abaixo é necessário caso apareça `erro AH00558` após o comando `sudo apachectl configtest` ser executado.
            ServerName 127.0.0.1    
   
         ```

4. **Notas:**
   1. Ao instalar o Apache ele adiciona ao arquivo [/etc/hosts](https://linuxhandbook.com/etc-hosts-file/) a seguinte linha:

      ```sh
         
         127.0.0.1	localhost

      ```

## REFERÊNCIAS

1. [Apache2](https://httpd.apache.org/ABOUT_APACHE.html)
2. [Servidor Apache - Wikipedia](https://pt.wikipedia.org/wiki/Servidor_Apache)
3. [**/etc/hosts**](https://linuxhandbook.com/etc-hosts-file/)
4. [**systemd**](https://en.wikipedia.org/wiki/Systemd)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")