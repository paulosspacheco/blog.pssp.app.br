#### Comandos mais usados na manutenção dos sites <a href="comandos_basicos.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. Comandos para ver o status do servidor:

    ```sh
    
       # Mostra os serviços ativos e as pastas onde estão localizado os mesmos
       sudo systemctl status
    
       # Mostra as tarefas sendo executadas no momento.
       sudo apachectl fullstatus
    
       sudo systemctl status apache2.service

    
    ```

2. Comandos para **parar** e **iniciar** servidor

    ```sh

      # stop apache2
      sudo systemctl stop apache2  

      # start apache2
      sudo systemctl start apache2 

   
   ```

3. Comando para carregar as configurações de um novo **virtual host** sem que os outros sites saiam fora do ar:

   ```sh

      # recarrega as configurações sem reiniciar.
      sudo systemctl reload apache2   

   ```

4. Comando para reiniciar o servidor apache2 desconectando todos os sites que estiverem ativos:

   ```sh

      sudo systemctl restart apache2  

   ```

5. Comandos para habilitar (a2ensite)  e desabilitar (a2dissite) um site (**virtual host**)

   ```sh
   
       # HABILITAR SITE
       #   Move o arquivo /etc/apache2/sites-available/nome_do_site.conf para a pasta /etc/apache2/sites-enabled/nome_do_site.conf
       sudo a2ensite nome_do_site.conf
    
       # DESABILITAR SITE
       #   Move o arquivo /etc/apache2/sites-enabled/nome_do_site.conf para a pasta /etc/apache2/sites-available/nome_do_site.conf:
       sudo a2dissite nome_do_site.con
          
       # Atualizar o servidor apache2 com a nova configuração do host virtual
       sudo systemctl reload apache2  
    
   ```

6. Comandos para habilitar (a2enmod)  e desabilitar (a2dismod) um módulo;

   ```sh
   
       # HABILITAR MÓDULO
       #   Move o arquivo /etc/apache2/mods-available/nome_do_módulo para a pasta /etc/apache2/mods-enabled/nome_do_módulo   
       sudo a2enmod nome_do_módulo
    
       # DESABILITAR MÓDULO
       # Move o arquivo /etc/apache2/mods-enabled/nome_do_site para a pasta /etc/apache2/mods-available/nome_do_módulo
       sudo a2dissite nome_do_site.con
        
       # Atualizar o servidor apache2 com a nova configuração do host virtual
       sudo systemctl reload apache2  

   ```

7. Para listar todos os módulos do Apache2 que estão disponíveis nos repositórios;

   ```sh
        
      sudo apt-cache search apache2-mod
   
   ```

8. Checar se as configurações do apache estão **ok**.

   ```sh

     sudo apachectl configtest

   ```

9. Comando para listar todo o log:

   ```sh

     sudo journalctl -u apache2.service --since today --no-pager

   ```

10. Como habilitar o módulo cgi e FastCGI:

    ```powershell
       # O comando a seguir cria os links simbólicos cgid.load e cgid.conf 
       # da pasta /etc/apache2/mods-available para a pasta /etc/apache2/mods-enabled
       sudo a2enmod cgid
    ```

11. Como desabilitar o módulo cgi e FastCGI:

    ```powershell
       # O comando a seguir remove os links cgid.load e cgid.conf 
       # da pasta/etc/apache2/mods-enabled
       sudo a2dismod cgid
    ```

