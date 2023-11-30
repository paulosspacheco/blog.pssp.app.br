<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# $bash (1) - página de manual do Linux

1. **Nome**
   1. bash - GNU Bourne-Again SHell
2. **Sinopse**
   1. bash [opções] [arquivo]
3. **direito autoral**
   1. O Bash é protegido por Copyright © 1989-2009 da Free Software Foundation, Inc
4. **Descrição**
   1. O Bash é um interpretador de linguagem de comando compatível com sh que executa comandos lidos a partir da entrada padrão ou de um arquivo. O Bash também incorpora recursos úteis dos shells Korn e C ( ksh e csh ).
   2. O Bash se destina a ser uma implementação em conformidade da parte Shell e utilitários da especificação IEEE POSIX (IEEE Standard 1003.1). O Bash pode ser configurado para estar em conformidade com POSIX por padrão.
5. ***Opções***
   1. Além das opções de shell de caractere único documentadas na descrição do comando set builtin, o bash interpreta as seguintes opções quando é chamado:
      1. **-c string**
         1. Se a opção -c estiver presente, os comandos serão lidos da string . Se houver argumentos após a string , eles serão atribuídos aos parâmetros posicionais, começando com $0.
      2. **-i**
         1. Se a opção -i estiver presente, o shell será interativo.
      3. -I
         1. Faça o bash agir como se tivesse sido invocado como um shell de login (veja INVOCATION abaixo).
      4. **-r**
         1. Se a opção -r estiver presente, o shell se torna restrito (consulte SHELL RESTRITO abaixo).
      5. **-s**
         1. Se a opção -s estiver presente ou se nenhum argumento permanecer após o processamento da opção, os comandos serão lidos a partir da entrada padrão. Esta opção permite que os parâmetros posicionais sejam definidos ao chamar um shell interativo.
      6. **-D**
         1. Uma lista de todas as strings entre aspas precedidas por $ é impressa na saída padrão. Essas são as strings que estão sujeitas à tradução de idioma quando o local atual não é C ou POSIX . Isso implica na opção -n ; nenhum comando será executado.
      7. **[- +] O [ shopt_option ]**
         1. shopt_option é uma das opções de shell aceitas pelo shopt embutido (veja os COMANDOS DE CONSTRUÇÃO DE SHELL abaixo). Se shopt_option estiver presente, -O define o valor dessa opção; + O desarma. Se shopt_option não for fornecido, os nomes e valores das opções de shell aceitas por shopt serão impressos na saída padrão. Se a opção de chamada for + O , a saída será exibida em um formato que pode ser reutilizado como entrada.
      8. **--**
         1. A -- sinaliza o fim das opções e desativa o processamento posterior das opções. Quaisquer argumentos após -- são tratados como nomes de arquivos e argumentos. Um argumento de - é equivalente a -- .
         2. O Bash também interpreta várias opções de vários caracteres. Essas opções devem aparecer na linha de comando antes das opções de caractere único serem reconhecidas.
      9. **--debugger**
         1. Faça com que o perfil do depurador seja executado antes que o shell seja iniciado. Ativa o modo de depuração estendido (veja a descrição da opção extdebug para o shopt embutido abaixo) e rastreamento de função shell (veja a descrição da opção -o functrace para o conjunto embutido abaixo).
      10. **--dump-po-strings**
          1. Equivalente a -D , mas a saída está no formato de arquivo GNU gettext po (objeto portátil).
      11.**--dump-strings**
          1. Equivalente a -D.
      12.**--help.**
          1. Exibir uma mensagem de uso na saída padrão e sair com sucesso.
      13.**--init-file file**
          1. .
      14.**--rcfile file.**
          1. Execute comandos do arquivo em vez do arquivo de inicialização pessoal padrão ~/.bashrc se o shell for interativo (consulte INVOCATION abaixo).
      15.**--login**
          1. Equivalente a -l.
      16.**--noediting**
          1. Não use a biblioteca GNU readline para ler linhas de comando quando o shell for interativo.
      17.**--noprofile**
          1. Não leia o arquivo de inicialização do sistema /etc/ profile ou qualquer um dos arquivos de inicialização pessoal ~/.bash_profile , ~/.bash_login ou ~/.profile. Por padrão, o bash lê esses arquivos quando é chamado como um shell de login (veja INVOCATION abaixo)..
      18.**--norc**
          1. Não leia e execute o arquivo de inicialização pessoal ~/.bashrc se o shell for interativo. Esta opção está ativada por padrão se o shell for chamado como sh.
      19.**--posix**
          1. Altere o comportamento do bash onde a operação padrão difere do padrão POSIX para corresponder ao padrão ( modo posix )
      20.**--restricted**
          1. O shell torna-se restrito (consulte SHELL RESTRITO abaixo).
      21.**--rpm-requires**
          1. Produza a lista de arquivos necessários para a execução do script de shell. Isso implica '-n' e está sujeito às mesmas limitações da verificação de erro em tempo de compilação; Críticas, [] testes e evals não são analisados, portanto, algumas dependências podem ser perdidas.
      22.**--verbose**
          1. Equivalente a -v .
      23.**--version**
          1. Mostra informações de versão para esta instância do bash na saída padrão e sai com sucesso.

6. ***Argumentos.***
   1. Se os argumentos permanecerem após o processamento da opção, e nem a opção -c nem a opção -s foram fornecidas, o primeiro argumento é considerado o nome de um arquivo contendo comandos shell. Se o bash for invocado dessa maneira, $ 0 será definido como o nome do arquivo e os parâmetros posicionais serão definidos como os argumentos restantes. O Bash lê e executa comandos desse arquivo e, em seguida, sai. O status de saída do Bash é o status de saída do último comando executado no script. Se nenhum comando for executado, o status de saída é 0. Primeiro, é feita uma tentativa de abrir o arquivo no diretório atual e, se nenhum arquivo for encontrado, o shell pesquisa os diretórios em PATH para o script.
7. Extensões do vscode.
   1. [shell-syntax](https://marketplace.visualstudio.com/items?itemName=bmalehorn.shell-syntax)

8. **Referências**
   1. [$bash (1) - página de manual do Linux](https://linux.die.net/man/1/bash)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
