<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Teste do protocolo CGI usando a linguagem shell script <a href="teste_do_protocolo_cgi_usando_a_linguagem_shell_script.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. Com editor de sua preferência, crie o arquivo _/home/cgi_bin/cgi/testcgi.sh_;
2. Adicione o _programa shell script_ abaixo no arquivo _/home/cgi_bin/cgi/testcgi.sh_, em seguida salve-o:

    ```bash

        #!/bin/bash
        echo "Content-type: text/html"
        echo 
        echo "O ARQUIVO <b>testcgi.sh</b> MOSTRA AS VARIÁVEIS DE AMBIENTE USANDO PROTOCOLO CGI<br>"
        echo "<br>------------------------------------------------------------------<br>"

        # Imprime as variáveis de ambiente do console.
        printenv --null

        echo "<br>------------------------------------------------------------------<br>"
        echo "Se as varáveis de ambiente aparecer no browser ao digitar o link <b>http://cgi_bin/testcgi.sh</b>, o site <b>cgi_bin</b> está configurado e funcionando."               
        
    ```

3. Para permitir que o arquivo _testcgi.sh_ seja executados na pasta _/home/cgi_bin/cgi/_, execute os seguintes comandos:

   ```bash

        # todos podem executar, gravar e ler o arquivo testcgi.sh
        sudo chmod -R ugo+xwr /home/cgi_bin/cgi/testcgi.sh              
            
        # Outros usuários não podem ler e gravar o arquivo testcgi.sh 
        sudo chmod -R o-wr /home/cgi_bin/cgi/testcgi.sh 
    
    ```

4. Teste no browser se o programa _http://cgi-bin/testcgi.sh_ funciona.
    1. Notas:
        1. Caso o link _http://cgi-bin/testcgi.sh_ não funcione, edite o arquivo de log na pasta _/var/log/apache2/error.log_ e observe a data dos erros e código do erro, em seguida procure na internet a solução;
        2. Esses passos descritos até aqui, foram testados no _apache2_ do _Linux Mint 21 Cinnamon_.

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")