<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Exemplo de código usando a linguagem perl <a href="teste_do_protocolo_cgi_usando_a_linguagem_perl.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba."> ➚ </a>

1. Com editor de sua preferência, crie o arquivo _/home/cgi_bin/cgi/testcgi.pl_;
2. Adicione o _programa perl_ abaixo no arquivo /home/cgi_bin/cgi/testcgi.pl, em seguida salve-o:

   ```perl

       #!/usr/bin/perl
       use CGI::Fast;

       while (my $q = CGI::Fast->new)
       {
           print("Content-Type: text/plain\n\n");
           print("MOSTRA AS VARIÁVEIS DE AMBIENTE USANDO PROTOCOLO CGI\n\n");
           print("------------------------------------------------------------------\n\n");

           foreach $var (sort(keys(%ENV))) {
           $val = $ENV{$var};
           $val =~ s|\n|\\n|g;
           $val =~ s|"|\\"|g;
           print "${var}=\"${val}\"\n";
           }

           print("------------------------------------------------------------------\n\n");
           print("Se as varáveis de ambiente aparecer no browser ao digitar o link http://cgi_bin/testcgi.sh, o site cgi_bin está configurado e funcionando/\n");
       }
   ```

3. Para permite que o arquivo _testcgi.pl_ seja executado na pasta /home/cgi_bin/cgi/, execute os seguintes comandos:

   ```bash

       # todos podem executar, gravar e ler o arquivo testcgi.pl
       sudo chmod -R ugo+xwr /home/cgi_bin/cgi/testcgi.pl

       # Outros usuários não podem ler e gravar o arquivo testcgi.pl
       sudo chmod -R ugo+xwr /home/cgi_bin/cgi/testcgi.pl

   ```

4. Teste no browser se o programa _http://cgi-bin/testcgi.pl_ funciona.
   1. Notas:
      1. Caso o link _http://cgi-bin/testcgi.pl_ não funcione, edite o arquivo de log na pasta _/var/log/apache2/error.log_ e observe a data dos erros e código do erro, em seguida procure na internet a solução;
      2. Esses passos descritos até aqui, foram testados no _apache2_ do _Linux Mint 21 Cinnamon_.

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")