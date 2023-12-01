<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como criar vários sites na mesma máquina  <a href="como_criar_varios_sites.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>
## Descrição dos arquivos de configuração do apache2

1. [**/etc/hosts**](https://pt.wikipedia.org/wiki/Hosts_(arquivo))
   1. Usado para associar o endereço IP local ao um nome legível com objetivo de facilitar o uso no dia a dia, visto que, o IP é um só para cada máquina e os nomes dos sites podem variar, sendo que os mesmos são usados pelo apache2 para associá-los a várias pastas dentro da pasta **/etc/www**.
      1. Exemplo de arquivo host os seguintes site: site1.local e site1.local

      ```sh

        127.0.0.1 localhost # Criado na instalação do Linux
        127.0.0.1 site1.local # Editado manualmente
        127.0.0.1 site2.local # Editado manualmente 
        127.0.1.1 serverpp # Criado na instalação do Linux
     
        # As linhas abaixo foram criadas na instalação do Linux
        # The following lines are desirable for IPv6 capable hosts
        ::1     ip6-localhost ip6-loopback
        fe00::0 ip6-localnet
        ff00::0 ip6-mcastprefix
        ff02::1 ip6-allnodes
        ff02::2 ip6-allrouters
        
      ```

2. **/etc/apache2/apache2.conf**
   1. Arquivo de configuração principal com os valores padrões para que o servidor funcione com um site apenas.
   2. Obs: No passado esse arquivo se chamava httpd.conf. [Veja mais...](https://ubuntu.com/server/docs/web-servers-apache)

3. **/etc/apache2/ports.conf**:
   1. Este arquivo de configuração armazena as diretivas que determinam as portas TCP nas quais o Apache está escutando. Aqui está o conteúdo padrão deste arquivo no Linux Mint:

   ```sh

    # Se você apenas alterar a porta ou adicionar mais portas aqui, provavelmente também
    # tem que mudar a instrução VirtualHost em
    # /etc/apache2/sites-enabled/000-default.conf
    
    Listen 80
    
    <IfModule ssl_module>
       Listen 443
    </IfModule>
    
    <IfModule mod_gnutls.c>
       Listen 443
    </IfModule>
    
    # vim: syntax=apache ts=4 sw=4 sts=4 sr noet

   ```

4. **/etc/apache2/sites-available**
   1. Pasta usada para registrar um site novo no apache2, onde cada site registrado deve está em um arquivo com nome do site e extensão .conf.

   2. Exemplo:
      1. Suponha que se queira registrar o site de nome **site1.local**, na pasta **/var/wwww/site1.local/html**, então o arquivo deve criar o seguinte arquivo de nome: **site1.local.conf**.
         1. Exemplo do conteúdo do arquivo de configuração do novo site:

             ```sh
    
               <VirtualHost *:80>
                   # A diretiva ServerName define o esquema de solicitação, hostname e porta que
                   # o servidor usa para se identificar. Isso é usado ao criar
                   # URLs de redirecionamento. No contexto de hosts virtuais, o ServerName
                   # especifica qual nome de host deve aparecer no host da solicitação: cabeçalho para
                   # corresponde a este host virtual. Para o host virtual padrão (este arquivo) este
                   # valor não é decisivo, pois é usado como um host de último recurso independentemente.
                   # No entanto, você deve configurá-lo explicitamente para qualquer outro host virtual.
                   
                   ServerName site1.local
                   
                   # Define o endereço de contato que o servidor inclui em todas as mensagens de erro que retorna ao cliente. 
                   # Se o httpd não reconhecer o argumento fornecido como um URL, ele assumirá que é um endereço de e-mail 
                   # e o anexará aos mailto:destinos do hiperlink. 
                   
                   ServerAdmin webmaster@localhost
                   
                   # Diretório que forma a árvore principal do documento visível da web
                   
                   DocumentRoot /var/www/site1/html
                   
                   # A diretiva <Directory namaDir> define a pasta e diretivas que se aplicam apenas ao diretório e subdiretórios e seus conteúdos.
                   
                   <Directory /var/www/site1/html/>	
                      Options Indexes FollowSymLinks
                      AllowOverride None
                      Require all granted
                   </Directory>
                   
                   # Loglevels disponíveis: trace8, ..., trace1, debug, info, aviso, warning,
                   # erro, crit, alerta, emerg.
                   # Também é possível configurar o nível de log para determinados
                   # módulos, por exemplo
                   #LogLevel info ssl:avisar
                   
                   ErrorLog ${APACHE_LOG_DIR}/error.log
                   CustomLog ${APACHE_LOG_DIR}/access.log combined
                   
                   # Para a maioria dos arquivos de configuração de conf-available/, que são
                   # ativado ou desativado em nível global, é possível
                   # inclua uma linha para apenas um host virtual específico. Por exemplo o
                   # a linha a seguir habilita a configuração CGI apenas para este host
                   # depois de ter sido desabilitado globalmente com "a2disconf".
                   #Include conf-available/serve-cgi-bin.conf
                      
                </VirtualHost>
           
                # vim: syntax=apache ts=4 sw=4 sts=4 sr noet             
           
             ```

         2. Para habilitar o novo site deve-se executar o seguinte comando:

            ```sh
        
             sudo a2ensite site1.local.conf
             sudo systemctl reload apache2
 
            ```

         3. Para desabilitar o novo site deve-se executar o seguinte comando:

            ```sh
        
             sudo a2dissite site1.local.conf
             sudo systemctl reload apache2
 
            ```

5. **/etc/apache2/sites-enabled**
   1. Contém links simbólicos para os arquivos da pasta **/etc/apache2/conf-available** quando o comando o comando **a2ensite** é executado:  

   2. O link simbólico da pasta **/etc/apache2/conf-available** é excluído ao executar o comando **a2dissite**.

6. **/etc/apache2/mods-available**
   1. Contém arquivos de configuração (**.load**) para carregar módulos (**.dll** no Windows e **.so** no Linux) e arquivos de configuração dos módulos (.conf). Os arquivos **.load** dentro deste diretório contêm as **diretivas Apache Load** para carregar os **módulos no servidor web**, e os arquivos **.conf** contêm diretivas de configuração adicionais necessárias para a operação dos módulos indicando as pastas que será usada pelo módulo.
      1. Exemplo:
         1. Suponha que se queira habilitar a lib de nome **/usr/lib/apache2/modules/mod_exemplo.so**:
            1. Deve-se criar o arquivo de configuração de nome **/etc/apache2/mods-available/mod_exemplo.load** com o seguinte conteúdo:

                ```sh
                
                  LoadModule auth_form_module /usr/lib/apache2/modules/mod_exemplo.so
                            
                ```

            2. Para habilitar o módulo executar o comando:

                ```sh
                
                  sudo a2enmod mod_exemplo.load
                  sudo systemctl reload apache2
                            
                ```

            3. Para desabilitar o módulo executar o comando:

                ```sh
                
                  sudo a2dismod mod_exemplo.load
                  sudo systemctl reload apache2
          
                ```

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")