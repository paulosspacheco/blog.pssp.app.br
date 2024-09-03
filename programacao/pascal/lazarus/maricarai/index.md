<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Framework Maricarai

## 1. Criação das regras no negócios

1. **Resumo**:
   1. O projeto maricarai tem como finalidade mapear as tabelas de um banco de dados, bem como realizar todos os cálculos que envolvem a tabela, assim como, coletar as informações em uma lista de textos com uma sintaxe específica básica, capaz de fornecer informações necessárias para que os componentes geradores de formulários  possam fazer críticas no tipo de dados de entrada, nas faixas de valores válidos para o campo, bem como informações para que se possa criar campos do tipo CheckBox, comboBox, radioButton, LookupComboBox e options (semelhante  a comboBox, porém o conteúdo possa ser de qualquer tipo de dados).
   2. O módulo onde se descreve o projeto, também faz os cálculos necessários nas tabelas do banco de dados, bem como a descrição das telas usadas nos formulários, não dependem do módulo gerador de formulários.
   3. Os componentes usado para mapear as tabelas, descreve como será os formulários na interface visual abstrata. A interface visual abstrata, deve ser implementada na plataforma destino, por exemplo:  aplicações LCL, WEB, ou mobile.
   4. A aplicação LCL terá opções para criar aplicações clientes, tais como web, ou lcl cliente interagindo usando http restjson  

2. **Componentes necessários**:
   1. TMiDataModule
      1. Este contêiner é usado para concentrar todos os componentes necessários para as regras do negócio onde os eventos dos mesmos possam ser criados visualmente.
   2. TMiConnectionsDb
      1. Este contêiner é usado para concentrar os componentes necessários para conectar-se ao banco de dados onde os mesmos serão necessários no contêiner TMiDataModule.
   3. TDmxScroller_Form é usado para:
      1. Mapear os campos banco de dados;
      2. O mapeamento é realizado através do evento onGetTemplate onde o mesmo retorna um template com a definição dos controles dos formulários.
         1. Cada controle tem uma sintaxe própria onde os caracteres abaixo tem o seguinte significado:
            1. '_~_'
               1. Marcador de início e fim do texto usado para criar controles de formulários LCL, ou WEB ou javascript etc...
                  1. Exemplo:
                     1. ~Nome do Aluno~
            2. _'S' 's'_ (tipo ShortString):
               1. Os caracteres _'S'_ ou _'s'_ encontrado após o caractere _\\_ representa uma posição na string do tipo _shortString_.
                  1. Exemplo:
                     1. _'\Ssssssssss'_
                        1. Representa um string com 10 letras sendo que a primeira é maiúscula e as restantes são minusculas.
            3. _'C' 'c'_ (tipo ansiString):
               1. Os caracteres _'C'_ ou _'c'_ encontrado após o caractere _\\_ representa uma posição na string do tipo _ansiString_.
                  1. Exemplo:
                     1. _\Cccccccccc_
                        1. Representa um tipo ansiString com 10 letras sendo que a primeira é maiúscula e as restantes são minusculas.
            4. _'j'_ (tipo ShotInt)
               1. O caractere _'J'_ encontrado após o caractere _\\_ representa 3 caractere  na  mascara do tipo _ShotInt_.
                  1. Exemplo:
                     1. _'\JJJ'_
                        1. Representa uma posição na memória e 3 posições na mascara de entrada de dados, cujo a faixa de valores permitidos é _-127_ a _+127_.
            5. _'B'_ (tipo byte)
               1. Os caracteres _'B'_ encontrado após o caractere _\\_ representa um caractere  a  mascara do tipo _byte_.
                  1. Exemplo:
                     1. _'\BBB'_
                        1. Representa uma posição na memória e 3 posições na mascara de entrada de dados, cujo o maior valor permitido é _255_.
            6. _'I'_ (tipo smallInt)
               1. Os caracteres _'I'_ encontrado após o caractere _\\_ representa um caractere  na  mascara do tipo _smallInt_.
                  1. Exemplo:
                     1. _'\II,III'_
                        1. Representa duas posição na memória e 5 posições na mascara de entrada de dados, cujo a faixa de valores permitidos é _-32768_ a _+32767_.
            7. _'W'_ (tipo smallWord)
               1. Os caracteres _'W'_ encontrado após o caractere _\\_ representa um caractere  na  mascara do tipo _smallWord_.
                  1. Exemplo:
                     1. _'\WW,WWW'_
                        1. Representa duas posição na memória e 5 posições na mascara de entrada de dados, cujo a faixa de valores permitidos é _0_ a _65535_.
            8. 
      3. Capturar os rótulos e tipos de controles que será usado no formulário de entrada de dados;
      4. 
   4. 
   5. 


## O preciso fazer para que o produto gere formulários LCL?

- 

## O preciso fazer para que o produto gere formulários html dinâmicos?

</main>

[🔝🔝](#topo "Retorna ao topo")
