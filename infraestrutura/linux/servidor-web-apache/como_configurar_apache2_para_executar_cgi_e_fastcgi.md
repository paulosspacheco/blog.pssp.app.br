<!-- markdownlint-disable-next-line -->
#### Como configurar apache2 para executar CGI e FASTCGI  <a href="como_configurar_apache2_para_executar_cgi_e_fastcgi.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a> <span id="topo"><span>

1. **INDEX**
   1. [Certifique-se que os arquivos *cgi.load*,...](#id_certifiquese)
   2. [Para habilitar os protocolos *cgi* e *fcgi*,...](#id_habilitar_protocologo)
   3. [Criar pastas *cgi* e *fcgi*...](#id_criar_pastas)
   4. [Configurar pasta */home/cgi_bin/* para que o usuário *'www-data'* seja dono...](#id_configurar_dono_da_pasta)
   5. [Configurar pasta */home/cgi_bin/* e as subpastas *cgi* e *fcgi* para que pertença ao grupo ...](#id_configurar_grupo_da_pasta)
   6. [Configurar o modo de acesso da pasta */home/cgi_bin/*...](#id_configurar_mode_de_acesso_da_pasta)
   7. **Criando sites** *cgi-bin* e *fcgi-bin*:
      1. [Site cgi-bin para os programas acessados com o protocolo CGI...](#id_criar_site_cgi-bin)
      2. [Site fcgi-bin para os programas acessados com o protocolo FastCGI](#id_criar_site_fcgi-bin)
   8. [Referências](#id_referencias)

2. **CONTEÚDO**
      <!-- markdownlint-disable-next-line -->
   1. <span id="id_certifiquese"><span>Certifique-se que os arquivos *cgi.load*, *cgid.load* e *cgid.conf* estejam na pasta */etc/apache2/mods-available*.
      1. *Nota:*
         1. Esses arquivos acompanham a instalação do apache.
            1. Conteúdo do arquivo *cgi.load*

               ```sh
               
                  LoadModule cgi_module /usr/lib/apache2/modules/mod_cgi.so
               
               ```

            2. Conteúdo do arquivo *cgid.load*

               ```sh
               
                  LoadModule cgid_module /usr/lib/apache2/modules/mod_cgid.so
               
               ```

            3. Conteúdo do arquivo *cgi.conf*

               ```sh
               
                  # Socket for cgid communication
                  ScriptSock ${APACHE_RUN_DIR}/cgisock
               
                  # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
               
               ```

      [🔝🔝](#topo "Retorna ao topo")
      <!-- markdownlint-disable-next-line -->
   2. <span id="id_habilitar_protocologo"><span>Para habilitar os protocolos *cgi* e *fcgi*, execute os seguintes comandos:

         ```bash
         
            # O comando a seguir cria os links cgid.load e cgid.conf 
            # na pasta/etc/apache2/mods-enabled
            sudo a2enmod cgid

            #  Reinicia o Apache2 
            systemctl restart apache2
         
         ```

      [🔝🔝](#topo "Retorna ao topo")
   <!-- markdownlint-disable-next-line -->
   3. <span id="id_criar_pastas"><span>Criar pastas *cgi* e *fcgi* dentro da pata */home/cgi_bin/*:

      ```bash
         
         sudo mkdir -p /home/cgi_bin/{cgi,fcgi}

      ```
   <!-- markdownlint-disable-next-line -->
     [🔝🔝](#topo "Retorna ao topo")
      <!-- markdownlint-disable-next-line -->
   4. <span id="id_configurar_dono_da_pasta"><span>Configurar pasta */home/cgi_bin/* para que o usuário *'www-data'* seja dono dela e de suas duas subpastas *cgi* e *fcgi*:

      ```bash
      
         sudo chown  -R www-data /home/cgi_bin/
      
      ```
   <!-- markdownlint-disable-next-line -->
     [🔝🔝](#topo "Retorna ao topo")
   <!-- markdownlint-disable-next-line -->
   5. <span id="id_configurar_grupo_da_pasta"><span>Configurar pasta */home/cgi_bin/* e as subpastas *cgi* e *fcgi* para que pertença ao grupo *paulosspacheco* com objetivo de gravar arquivos nas pastas *cgi* e *fcgi* sem ser preciso o modo root.

      ```bash
      
         sudo chgrp -R paulosspacheco /home/cgi_bin/
      
      ```
   <!-- markdownlint-disable-next-line -->
     [🔝🔝](#topo "Retorna ao topo")
   <!-- markdownlint-disable-next-line -->
   6. <span id="id_configurar_mode_de_acesso_da_pasta"><span>Configurar o modo de acesso da pasta */home/cgi_bin/* e das suas subpastas *cgi* e *fcgi*  para que o usuário dono *www-data* e o grupo *paulosspacheco* possa executar, gravar e ler e *outros usuários* só possam executar:

      ```bash

         # Todos os arquivos da pasta e subpastas podem executar, gravar e ler 
         sudo chmod -R ugo+xwr /home/cgi_bin/
         
         # Todos os arquivos da pasta e subpastas dos outros usuários não podem ler e gravar 
         sudo chmod -R o-wr /home/cgi_bin/         
      
      ```
   <!-- markdownlint-disable-next-line -->
     [🔝🔝](#topo "Retorna ao topo")
   <!-- markdownlint-disable-next-line -->
   7. **Criando sites** *cgi-bin* e *fcgi-bin*:
   <!-- markdownlint-disable-next-line -->
      1. <span id="id_criar_site_cgi-bin"><span>**Site cgi-bin para os programas acessados com o protocolo CGI**
         1. Com editor de sua preferência, crie o arquivo */etc/apache2/sites-available/cgi-bin.conf*;
         2. Adicione as configurações abaixo no arquivo */etc/apache2/sites-available/cgi-bin.conf*, em seguida salve-o:

            ```sh
               
               <VirtualHost *:80>
               
                  DocumentRoot /home/cgi_bin/cgi
                  ServerName cgi-bin
                  
                  # https://httpd.apache.org/docs/2.4/mod/mod_alias.html#scriptalias
                  ScriptAlias "/cgi-bin/" "/home/cgi_bin/cgi"
            
                  # Esta diretiva especifica um valor padrão para o parâmetro charset do 
                  # tipo de mídia (o nome de uma codificação de caractere) 
                  # a ser adicionado a uma resposta se e somente se o tipo de conteúdo 
                  # da resposta for sh/plainou sh/html.
                  AddDefaultCharset utf-8
            
                  # Habilitas as extensões  .cgi .sh .pl para executar script
                  AddHandler cgi-script .cgi .sh .pl
            
                  <Directory /home/cgi_bin/cgi/>
                     Options None
                     Require all granted
                     AllowOverride None
                     Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                     Require all granted
                  </Directory>
            
               </VirtualHost>
               
            ```

         3. Para que o link *http://cgi-bin/testcgi.sh* funcione no Browser, é necessário editar o arquivo */etc/hosts* e adicionar abaixo da linha *127.0.0.1 localhost* a linha *127.0.0.1 cgi-bin*.
            1. Deve ficar assim:

               ```sh

                  127.0.0.1 localhost
                  127.0.0.1 cgi-bin

                  127.0.1.1 lnxmint-server
                  
                  # The following lines are desirable for IPv6 capable hosts
                  ::1     ip6-localhost ip6-loopback
                  fe00::0 ip6-localnet
                  ff00::0 ip6-mcastprefix
                  ff02::1 ip6-allnodes
                  ff02::2 ip6-allrouters
                     
               ```

         4. Para que o link _http://cgi-bin/testcgi.sh_ funcione no Browser, é necessário habilitar o site *cgi-bin* com os  comandos abaixo:

               ```bash
               
                  # O comando a seguir cria os links cgid.load e cgid.conf 
                  # na pasta/etc/apache2/mods-enabled
                  sudo a2ensite cgi-bin.conf

                  #  Reinicia o Apache2 
                  systemctl restart apache2
               
               ```

         5. **Para testar se o protocolo CGI está funcionando, siga os passos de um dos dois exemplos abaixo**
            1. [Teste do protocolo CGI usando a linguagem shell script](./teste_do_protocolo_cgi_usando_a_linguagem_shell_script.html);
            2. [Teste do protocolo CGI usando a linguagem perl](./teste_do_protocolo_cgi_usando_a_linguagem_shell_script.html)
            3. .

     [🔝🔝](#topo "Retorna ao topo")
      <!-- markdownlint-disable-next-line -->
      2. <span id="id_criar_site_fcgi-bin"><span>**Site fcgi-bin para os programas acessados com o protocolo FastCGI**
         1. Com editor de sua preferência, crie o arquivo */etc/apache2/sites-available/fcgi-bin.conf*;
         2. Adicione as configurações abaixo no arquivo */etc/apache2/sites-available/fcgi-bin.conf*, em seguida salve-o:

            ```sh
            
               <VirtualHost *:80>
               
                  DocumentRoot /home/cgi_bin/fcgi
                  ServerName fcgi-bin
                  
                  # https://httpd.apache.org/docs/2.4/mod/mod_alias.html#scriptalias
                  ScriptAlias "/fcgi-bin/" "/home/cgi_bin/fcgi"
               
                  # Esta diretiva especifica um valor padrão para o parâmetro charset do tipo de mídia (o nome de uma codificação de caractere) 
                  # a ser adicionado a uma resposta se e somente se o tipo de conteúdo da resposta for sh/plainou sh/html.
                  AddDefaultCharset utf-8
               
               
                  <Directory /home/cgi_bin/fcgi/>
                     # Habilitas as extensões  .fcgi para executar script
                     AddHandler fcgid-script .fcgi 
                     Options +ExecCGI
                     #Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
            
                     Require all granted
                     AllowOverride None       
                     Require all granted
                  </Directory>
            
               </VirtualHost>             
            
            ```

         3. Para que o link *http://fcgi-bin/testfcgi.fcgi* funcione no Browser, é necessário editar o arquivo */etc/hosts* e adicionar abaixo da linha *127.0.0.1 localhost* a linha *127.0.0.1 fcgi-bin*.
            1. Deve ficar assim:

               ```sh

                  127.0.0.1 localhost
                  127.0.0.1 fcgi-bin
                  127.0.0.1 cgi-bin
                  127.0.1.1 lnxmint-server                
                  # The following lines are desirable for IPv6 capable hosts
                  ::1     ip6-localhost ip6-loopback
                  fe00::0 ip6-localnet
                  ff00::0 ip6-mcastprefix
                  ff02::1 ip6-allnodes
                  ff02::2 ip6-allrouters
                     
               ```

         4. Para que o link *http://fcgi-bin/testfcgi.fcgi* funcione no Browser, é necessário habilitar o site *fcgi-bin* com os  comandos abaixo:

               ```bash
               
                  # O comando a seguir cria os links cgid.load e cgid.conf 
                  # na pasta/etc/apache2/mods-enabled
                  sudo a2ensite fcgi-bin.conf

                  #  Reinicia o Apache2 
                  systemctl restart apache2
               
               ```

         5. **Para testar se o protocolo FastCGI está funcionando, siga os passos de um dos dois exemplos abaixo**
            1. [Teste do protocolo FastCGI usando a linguagem perl](./teste_do_protocolo_fastcgi_usando_a_linguagem_perl.html)

     [🔝🔝](#topo "Retorna ao topo")

3. **REFERÊNCIAS** <span id="id_referencias"><span>
   1. [Configurando o Apache para permitir CGI](https://httpd.apache.org/docs/current/howto/cgi.html)
   2. [Módulo Apache mod_fcgid](https://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html#upgrade)
   3. [Vídeo aula de como instalar um arquivo .sh como cgi](https://www.youtube.com/watch?v=Iw2AapND7jI&t=186s)
   4. [Apache Módulos](https://nightlies.apache.org/httpd/trunk/doxygen/modules.html)
   5. [HABILITAR CGI-SHELL NO APACHE2](https://www.vivaolinux.com.br/dica/Habilitar-CgiShell-no-Apache2)
   6. [Módulo Apache mod_fcgid](https://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html)    
   7. [Módulo Apache mod_fcgid upgrade](https://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html#upgrade)
   8. [Diretiva mod_mime.addhandler](https://httpd.apache.org/docs/current/mod/mod_mime.html#addhandler)
   9. [Directive mod_mime.sethandler](https://httpd.apache.org/docs/current/mod/mod_mime.html#sethandler)
   10. [Suporte a objetos compartilhados dinâmicos (DSO)](https://httpd.apache.org/docs/2.4/dso.html)
   11. [Unix Build Instructions](http://svn.apache.org/repos/asf/httpd/mod_fcgid/trunk/README-FCGID)

[🔝🔝](#topo "Retorna ao topo")
<!-- markdownlint-disable-next-line -->
 <script>    function goBack() {    window.history.back()}</script>
