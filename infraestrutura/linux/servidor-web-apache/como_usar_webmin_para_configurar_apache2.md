#### Como usar Webmin para configurar apache2 <a href="como_usar_webmin_para_configurar_apache2.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. **Objetivo do webmin**.
   1. O Webmin é uma ferramenta de administração de sistema baseada na web para servidores do tipo Unix.

2. **Como instalar**?
   1. A maneira mais simples de obter o Webmin é usar o script [setup-repos.sh](https://github.com/webmin/webmin/blob/master/setup-repos.sh) para configurar o repositório no Debian ou seus derivados. Isso pode ser feito executando os comandos abaixo:

      ```sh
         # Baixa o script setup-repos.sh 
         curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh

         # Executa o script setup_repos.sh
         sudo sh setup-repos.sh  
         
         # Instala o webmim do repositório instalado. 
         sudo apt-get install webmin

      ```

3. **Como executar a interface gráfica webmim**?
   1. Digite no browser o link: _<https://localhost:10000>_;

4. **Como visualizar os sites existentes no servidor apache2**?
   1. Digite no browser o link: _<https://localhost:10000/apache/?xnavigation=1>_;

5. **Como criar um novo site**?
   1. Execute as seguintes ações:
      1. Com direitos de root, crie a pasta do site dentro da pasta _/var/www_;
      2. Entrar na opção _Servidor Web Apache2_. Digite o link: _<https://localhost:10000/apache/?xnavigation=1>_;
      3. Selecionar a guia _Create virtual host_;
      4. Informar a porta que o site deve escutar;
      5. Selecionar a pasta raiz do site;
         1. **Nota**:
            1. Não adianta tentar configurar o site em pasta fora da pasta _/var/www_ que não vai funcionar.
      6. Informar o nome do site no campo _Server Name_.
      7. Pressione o botão _Create Now_.
      8. Selecione o site criado, em seguida pressione no botão _Edit Directives_;
      9. Na opção edite diretivas, altere a linha que contem as palavras _Options None_ para _Options Indexes FollowSymLinks_
      10. Abaixo da diretiva options adicione uma linha e digite a diretiva: _AllowOverride None_;
      11. Pressione o botão _Save_ e retorne a página anterior;
      12. Próximo passo é _associar o ip da máquina local_ ao nome do site.

6. **Como associar o site criado ao ip local onde o apache2 está escutando**?
   1. Execute as seguintes ações:
      1. Selecionar o link _<https://localhost:10000/net/list_hosts.cgi?xnavigation=1>_;
      2. Selecionar a guia _Host Addresses_;
      3. Pressionar o botão _Add a mew host Addresses_ e digite o ip e o nome do site (_Server Name_) informado no passo 5
      4. Pressionar o botão _Create_
      5. Voltar ao link anterior;
      6. Pressionar o botão _Apply Configuration_.

7. **Após criar o novo site e associar ao ip local é necessário reiniciar o servidor apache2**:

   ```sh

      sudo systemctl reload apache2 

   ```