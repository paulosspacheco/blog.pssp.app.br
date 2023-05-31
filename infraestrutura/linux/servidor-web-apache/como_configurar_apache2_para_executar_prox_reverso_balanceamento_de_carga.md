#### Como configurar apache2 para executar proxy reverso com balanceamento de carga <a href="como_configurar_apache2_para_executar_prox_reverso_balanceamento_de_carga.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>
1. Checar se as configurações do apache estão **ok**.

   ```sh
     
      sudo apachectl configtest

   ```

2. Configurar Apache para funcionar como **proxy reverso**  (encaminhando solicitações de clientes para aplicativos de back-end.) com **mod_proxy**.

   ```sh

      #  implementa proxy no servidor Apache.
      sudo a2enmod proxy

      # Lida com solicitações de proxy HTTP e HTTPS.
      sudo a2enmod proxy_http

      # Ativa o balanceamento de carga.
      sudo a2enmod proxy_balancer
  
      # Túneis de conexões de soquete da web para um servidor de back-end.    
      sudo a2enmod proxy_wstunnel 

      # Testa se as configurações estão ok.   
      sudo apachectl configtest  

      # Reinicia o servidor apache2
      sudo systemctl restart apache2

       

   ```

3. Habilita módulo **proxy_fcgi** para fornece suporte para o protocolo FastCGI, associado **setenvif** que define as variáveis ​​enviadas ao FastCGI.

   ```sh

     # Permite prox em aplicações FastCGI
     sudo a2enmod proxy_fcgi setenvif

     # Reinicia o servidor apache2
     sudo systemctl restart apache2   

   ```

4. Crie o site /**etc/apache2/sites-available/cgi-bin-80-to-8080.conf** para lidar aplicação redirecionadas da porta 80 para a porta 8080 e adicione o seguinte arquivo:
   1. Arquivo texto na pasta sites-available

      ```sh

         <VirtualHost *:80>
         
               ServerName cgi-bin-80-to-8080.conf

               # Encaminha o cabeçalho do host original para o aplicativo de back-end.
               ProxyPreserveHost On

               # Especifica que todas as solicitações **/** são encaminhadas para a porta do aplicativo de **back-end**.
               
               # Nega ProxyPass modificando os cabeçalhos de resposta do aplicativo de back-end.
               ProxyPass / http://127.0.0.1:8080/

               # Nega ProxyPass modificando os cabeçalhos de resposta do aplicativo de back-end.
               ProxyPassReverse / http://127.0.0.1:8080/
         
         </VirtualHost>

      ```

   2. Habilite o site **cgi-bin-80-to-8080** no arquivo **/etc/host** ou no servidor DNS instalado.

5. Ative o arquivo de configuração **cgi-bin-80-to-8080.conf**

   ```sh
     
      # Ativa o site cgi-bin-80-to-8080 
      sudo a2ensite cgi-bin-80-to-8080.conf

      # Recarrega as configurações do apache2
      sudo systemctl reload apache2 

   ```

##### REFERÊNCIAS

 1. [Módulo Apache mod_proxy](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html)
 2. [Módulo Apache mod_proxy_fcgi](https://httpd.apache.org/docs/2.4/mod/mod_proxy_fcgi.html)
 3. [Como configurar o Apache como um proxy reverso com mod_proxy](https://www.vultr.com/docs/how-to-configure-apache-as-a-reverse-proxy-with-mod-proxy-54152/?utm_source=performance-max-latam&utm_medium=paidmedia&obility_id=17096555207&utm_adgroup=&utm_campaign=&utm_term=&utm_content=&gclid=CjwKCAjwl6OiBhA2EiwAuUwWZT7N_XoTrf3vqMja69M7ub1rV9dfn96XCLGGBd99glDrdlxWHkJPDBoCEd0QAvD_BwE)
 4. [Certbot is usually meant to be used to switch an existing HTTP site to work in HTTPS...](https://eff-certbot.readthedocs.io/en/stable/intro.html)
 5. [O que é um Certificado?](https://eff-certbot.readthedocs.io/en/stable/what.html)
 6. ...
