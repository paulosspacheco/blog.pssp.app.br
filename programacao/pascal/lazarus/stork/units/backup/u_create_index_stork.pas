unit u_Create_index_Stork;
{:< A unit @name tem como objetivo criar o arquivo de configuração do
    projeto stork.

    - **VERSÃO**:
      - Alpha - 0.0.0.0

    - **CÓDIGO FONTE**:
      - @html(<a href="../units/u_create_index_stork.pas</a>)

    - **HISTÓRICO**
      - Criado por: Paulo Sérgio da Silva Pacheco e-mail: paulosspacheco@@yahoo.com.br
      - DATA:
        - **20/07/2023**
          - 16:30 a 17:00: Criar a unit u_Create_index_Stork.pas
          - 20:20 a 21:00: Criar a Classe TCreate_index_Stork
        -

}
{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils
  ,mi.rtl.Objectss

  ;


Type
  {: A classe **@name** cria o arquivo de configuração do projeto de pesquisa Stork
     escrito por [James Little.](https://stork-search.net/#:~:text=By-,James%20Little.,-SEARCH%20THE%20FEDERALIST)

     - Descrição do arquivo de configuração do projeto [stork](https://stork-search.net/)

       - O projeto stork, espera um arquivo com formação [TOML](https://github.com/toml-lang/toml)
         com as seguintes campos preenchidos:
         - **base_directory**
         - **url_prefix**
         - **files**
           - Nota: Files é um matriz com os seguintes campos:
             - **path**
             - **url**
             - **title**

       - Exemplo de template principal:

         ```pascal

           [input]
             base_directory = "[-__base_directory__-]"
             url_prefix = "[-__url_prefix__-]"
             files = [
              [-__files__-]
             ]

         ```

       - Exemplo de template secundário de uma linha da matriz **files**


         ```pascal

            { path  = "__path__"  ,
              url   = "__url__",
              title = "__title__"
            },

         ```

         - A variavel path deve obtida da lista que a função
           TObjectss.FindFilesAll retorna
  }
  TCreate_index_Stork = class(TObjectss)

  end;

implementation

end.

