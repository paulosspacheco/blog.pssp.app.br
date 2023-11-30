<!-- markdownlint-disable-next-line -->
<nav><div class="topnav" id="myTopnav"><div w3-include-html="/menu.inc"></div></div></nav>

<!-- markdownlint-disable-next-line -->
#### Criando script para enviar as alterações para o github <a href="criando_script_para_enviar_as_alteracoes_para_o_github.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Crie um arquivo de nome ~/meuProjeto/**pushmain.sh** e cole os comandos a baixo, em seguida de permissão de execução para o arquivo **pushmain.sh**:

    ```sh
        
        #!/bin/bash
        
        # Esse é um parâmetro passado com a descrição do commit
        TextoCommit="$1"  
        
        # Associa o repositório remoto ao repositório local.          
            git remote add origin git@github.com:paulosspacheco/maricarai.git
        
        # Renomeie o branch  atual para main
        # O comando branch -M não precisa ser feito a todo momento, porque o git sempre envia para
        # o ultimo ramo selecionando.
            git branch -M main  
        
        # Este comando pode ser executado várias vezes antes de um commit.  
            git add .
        
        # Use o <msg> fornecido como a mensagem de confirmação. 
            git commit -a -m "$TextoCommit"
        
        # Envia as alterações locais para o repositório remoto.
            git push -u origin main                  
        
        # imprime o status atual do repositório
        git status  
    
    
    ```

2. Sintaxe de execução do script **pushmain.sh**.
   1. Adicione ou altere vários arquivos do repositório  **meuProjeto** em seguida execute os comandos abaixo:

   ```sh

      cd ~/meuProjeto
      ./pushmain.sh "Modificando o arquivo .....etc...."

   ```
<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>      