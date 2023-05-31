#### Clonando repositório do github

1. **Eureca!!!** a forma mais prática que encontrei para usar o github e vscode foi:
   1. No vscode instalei a extensão [**GitLens — Git supercharged**](https://learn.microsoft.com/pt-br/shows/vs-code-livestreams/10-things-about-gitlens)
      1. Essa extensão habilita o vscode a reconhecer o repositório remoto.

   2. Entre no [github](https://github.com/) e crie um repositório de nome **meuProjeto**;

   3. Na pasta de seus projetos clone o repositório **git@github.com:paulosspacheco/meuProjeto.git** :

      ```sh

        # Clona o repositório
        git clone git@github.com:paulosspacheco/meuProjeto.git        

        # Mova-se para o projeto clonado
        cd ./meuProjeto

        # Edite seu os arquivos da pasta ./meuProjeto
        code .
              
       ```

   4. Adicione ou altere os arquivos da pasta **meuProjeto**.

   5. Execute o script [**pushmain.sh**](./pushmain.sh)
      1. Sintaxe de execução do script **./pushmain.sh**

         ```sh

           ./pushmain.sh "Modificando o arquivo .....etc...."
         
         ```

##### REFERÊNCIAS

1. [Clonar um repositório](https://docs.github.com/pt/repositories/creating-and-managing-repositories/cloning-a-repository)