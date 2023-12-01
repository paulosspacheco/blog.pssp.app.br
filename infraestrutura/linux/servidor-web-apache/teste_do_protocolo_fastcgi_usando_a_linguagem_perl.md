<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Teste do protocolo FastCGI usando a linguagem perl <a href="teste_do_protocolo_fastcgi_usando_a_linguagem_perl.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. Com editor de sua preferência, crie o arquivo `/home/cgi_bin/fcgi/testfcgi.fcgi`;
2. Adicione o `programa perl` abaixo no arquivo `/home/cgi_bin/fcgi/testfcgi.fcgi`, em seguida salve-o:

    ```perl
        
        #!/usr/bin/perl
        use CGI::Fast;
        
        while (my $q = CGI::Fast->new) 
        {
            print("Content-Type: text/plain\n\n");
            print("MOSTRA AS VARIÁVEIS DE AMBIENTE USANDO PROTOCOLO FastCGI\n\n");
            print("------------------------------------------------------------------\n\n");
        
            foreach $var (sort(keys(%ENV))) {
            $val = $ENV{$var};
            $val =~ s|\n|\\n|g;
            $val =~ s|"|\\"|g;
            print "${var}=\"${val}\"\n";
            }                   
        
            print("------------------------------------------------------------------\n\n");
            print("Se as varáveis de ambiente aparecer no browser ao digitar o link http://fcgi_bin/testfcgi.fcgi, o site fcgi_bin está configurado e funcionando/\n");
        }   
    ```

3. Para permite que o arquivo `testfcgi.fcgi` seja executado na pasta `/home/cgi_bin/fcgi/`, execute os seguintes comandos:

    ```bash
    
        # todos podem executar, gravar e ler o arquivo testcgi.fcgi              
        sudo chmod -R ugo+xwr /home/cgi_bin/fcgi/testfcgi.fcgi
        
        # Outros usuários não podem ler e gravar o arquivo testcgi.fcgi               
        sudo chmod -R ugo+xwr /home/cgi_bin/fcgi/testfcgi.fcgi        

    ```

4. Teste no browser se o programa `http://fcgi-bin/testfcgi.fcgi` funciona.
   1. Notas:
      1. Caso o link `http://fcgi-bin/testfcgi.fcgi` não funcione, edite o arquivo de log na pasta `/var/log/apache2/error.log` e observe a data dos erros e código do erro, em seguida procure na internet a solução;
      2. Observe a variável de ambiente `SERVER_SIGNATURE`. Ela informa o nome do protocolo que executou o programa;
      3. Esses passos descritos até aqui, foram testados no `apache2` do `Linux Mint 21 Cinnamon`.

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")
