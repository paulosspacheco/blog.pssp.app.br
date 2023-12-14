
<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# O que é IDE Lazarus <a href="o_que_e_lazarus.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Como instalar o Lazarus](#id_assunto01)
      2. [Assunto 02](#id_assunto02)
      3. [Assunto 03](#id_assunto03)
      4. [Assunto 04](#id_assunto04)
      5. [Assunto 05](#id_assunto05)
      6. [Assunto 06](#id_assunto06)
      7. [Assunto 07](#id_assunto07)
      8. [Assunto 08](#id_assunto08)
      9. [Assunto 09](#id_assunto09)
      10. [Assunto 10](#id_assunto10)

   4. [**Referências globais.**](#id_referencias)

   5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. <span id="id_resumo"><span>**Resumo do conteúdo:**
      1. Descreve um resumo de como foi feito esse documento com as facilidade encontradas para produzi-lo e dificuldade encontrada.

   2. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. O Lazarus é um ambiente de desenvolvimento integrado (IDE) para programação em Pascal. Ele é utilizado principalmente para o desenvolvimento de software usando a linguagem de programação Object Pascal. O Lazarus é uma alternativa de código aberto à IDE Delphi, que é amplamente conhecida por facilitar o desenvolvimento rápido de aplicativos para Windows.
         2. O Lazarus é conhecido por ser multiplataforma, o que significa que os aplicativos desenvolvidos nele podem ser compilados e executados em diferentes sistemas operacionais, como Windows, Linux, macOS, entre outros. Ele utiliza o framework Free Pascal, que é um compilador Pascal de código aberto.
         3. Além disso, o Lazarus oferece uma interface gráfica de usuário (GUI) para facilitar o design de interfaces de usuário para aplicativos. Ele fornece ferramentas para desenvolvimento rápido e possui recursos que simplificam a criação de aplicativos visuais.
         4. O Lazarus é uma escolha popular para desenvolvedores que desejam criar aplicativos usando Pascal, especialmente aqueles que desejam criar software de desktop multiplataforma..

         5. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Para utilizar o Lazarus, você precisa atender a certos requisitos dependendo do sistema operacional em que deseja desenvolver. Aqui estão os requisitos básicos para alguns sistemas operacionais comuns:
            1. Conhecer a linguagem Pascal versão turbo pascal,  Delphi ou Free pascal.
            2. Requisitos Gerais:
               1. Lazarus IDE: Baixe e instale a versão mais recente do Lazarus IDE no site oficial (https://www.lazarus-ide.org/).
               2. Para Windows:
                  1. Sistema Operacional: Windows XP ou posterior.
                  2. Compilador: O Lazarus geralmente usa o Free Pascal Compiler (FPC), que é incluído no pacote de instalação.
               3. Para Linux:
                  1. Sistema Operacional: Lazarus é suportado em várias distribuições Linux. Certifique-se de atender aos requisitos específicos da sua distribuição.
                  2. Compilador: O Free Pascal Compiler (FPC) também deve ser instalado. Você pode instalá-lo usando o gerenciador de pacotes da sua distribuição.
               4. Para macOS:
                  1. Sistema Operacional: macOS 10.5 ou posterior.
                  2. Xcode: Certifique-se de ter o Xcode instalado, pois ele inclui ferramentas necessárias para o desenvolvimento.
               5. Para Desenvolvimento Multiplataforma:
                  1. Se você planeja criar aplicativos que podem ser executados em várias plataformas, é importante garantir que o código seja compatível. Evite dependências específicas do sistema operacional sempre que possível e teste seu aplicativo em diferentes sistemas para garantir a compatibilidade.
            3. Lembre-se de verificar a documentação oficial do Lazarus para obter informações mais detalhadas e atualizadas sobre os requisitos de sistema, pois eles podem ter mudado desde a última atualização deste conhecimento.

         2. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. O Lazarus oferece vários benefícios como uma IDE para o desenvolvimento de software, especialmente para projetos que utilizam a linguagem de programação Pascal. Aqui estão alguns dos benefícios associados ao uso do Lazarus:
         2. Código Fonte Aberto:
            1. Lazarus é uma IDE de código aberto, o que significa que você pode acessar, modificar e distribuir o código-fonte conforme necessário. Isso proporciona uma grande flexibilidade aos desenvolvedores.
         3. Multiplataforma:
            1. Permite o desenvolvimento de aplicativos que podem ser compilados e executados em diferentes sistemas operacionais, como Windows, Linux e macOS. Isso é possível devido à compatibilidade do Lazarus com o compilador Free Pascal.
         4. Compatibilidade com Delphi:
            1. O Lazarus é compatível com a linguagem de programação Object Pascal e compartilha muitas semelhanças com o Delphi, uma popular IDE para Pascal. Isso significa que os desenvolvedores que estão familiarizados com o Delphi podem encontrar o Lazarus mais fácil de aprender e usar.
         5. Desenvolvimento Rápido de Interfaces Gráficas:
            1. Oferece ferramentas gráficas para o design rápido de interfaces de usuário (GUI). Isso é particularmente útil para o desenvolvimento de aplicativos com interfaces visuais complexas.
         6. Comunidade Ativa:
            1. O Lazarus possui uma comunidade ativa de desenvolvedores que oferecem suporte e colaboração. Fóruns, grupos de discussão e outros recursos estão disponíveis para ajudar os desenvolvedores a superar desafios e trocar conhecimentos.
         7. Totalmente Gratuito:
            1. Lazarus é distribuído sob a licença GPL (General Public License), o que significa que é totalmente gratuito para uso. Isso é particularmente atraente para desenvolvedores e organizações que desejam evitar custos de licenciamento.
         8. Extensibilidade:
            1. Pode ser estendido com componentes e plugins adicionais para fornecer funcionalidades adicionais. Isso permite que os desenvolvedores personalizem o ambiente de desenvolvimento conforme necessário.
         9. Suporte a Banco de Dados:
            1. Integra facilmente com diversos bancos de dados, facilitando o desenvolvimento de aplicativos que requerem interação com sistemas de gerenciamento de banco de dados.
         10. Ferramentas de Depuração:
             1. Oferece ferramentas de depuração robustas para ajudar os desenvolvedores a identificar e corrigir problemas no código.
         11. Documentação Abundante:
             1. O Lazarus possui uma documentação abrangente que ajuda os desenvolvedores a entenderem e utilizarem eficientemente todas as funcionalidades oferecidas pela IDE.
         12. A IDE Lazarus permite criar formulários visualmente, compila-los e executa-los ao pressionar a tela f9.
         13. A IDE possui o programa **FPDebug** que permite executar o programa passo a passo pressionado a tecla F7.
         14. Lembrando que a escolha de uma IDE depende das necessidades específicas do desenvolvedor e do projeto em questão. O Lazarus é uma opção atraente para aqueles que buscam uma solução de desenvolvimento Pascal de código aberto e multiplataforma.

         15. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. Considerando ferramenta gráfica multiplataforma para desenvolvimento pascal não tem concorrente, por isso fica difícil relatar as desvantagens da IDE em relação a outras.

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_assunto01></span>**Como instalar o Lazarus e FreePascal**
         1. Instalar o aplicativo **FPCupDeLuxe** no Linux Debian ou derivados.
            1. Instalando as dependências:

               ```sh

                sudo apt-get install libx11-dev
                sudo apt-get install libgtk2.0-dev 
                sudo apt-get install libcairo2-dev  
                sudo apt-get install libpango1.0-dev 
                sudo apt-get install libxtst-dev 
                sudo apt-get install libgdk-pixbuf2.0-dev 
                sudo apt-get install libatk1.0-dev  
                sudo apt-get install libghc-x11-dev 
                sudo apt-get install libgl1-mesa-dev
                sudo apt-get install git
                sudo apt-get install mercurial

               ```

            2. Criar pasta **~/Download/FpCupDeLuxe**

                 ```sh

                   mkdir ~/Downloads/FpCupDeLuxe
                   
                 ```

            3. Baixar o programa **FpCupDeLuxe** para a pasta **~/Downloads/FpCupDeLuxea** :
               1. [Download do FpCupDeLuxe](https://github.com/LongDirtyAnimAlf/fpcupdeluxe/releases).

            4. Executar programa  **fpcupdeluxe-x86_64-linux**

               ```sh

                cd ~/Downloads/FpCupDeLuxe
                ./fpcupdeluxe-x86_64-linux
                   

               ```

            5. Configurar **FpCupeDeLuxe** para instalar o **FPC** com opção de debug de todos os pacotes, inclusive a FCL, LCL etc...
               1. Selecionar a opção Setup+ do FpCupDeLuxe:
                  1. ![Opção Setup+](img/setup_fpcupdeluxe.png)
                  2. ![Formulário de Opções avançadas](img/Opcoes_Avancadas.jpeg)

               2. Pressione o botão [**Setup+**](img/Opcoes_Avancadas.jpeg) do **FpCupDeLuxe**, para editar o formulário de **Opções Avançadas**:
                  1. Adicione os comandos **-g -gl -O-** no campo "FPC Options".

         2. **Instalar Lazarus com o programa FPCupDeLuxe:**
            1. Executar programa **FpCupDeLuxe**

            2. No painel **GitLab** selecione a versão **Fixed** para o compilador **FPC** e para IDE **Lazarus**.
               1. ![Painel GitLab](img/painel_gitlab.jpeg).

            3. Pressionar o botão:
               1. ![Botão instalar](img/botao_instalar_fpc_lazarus.jpeg).

         3. **Instalar pacotes opcionais**.
            1. Na área de trabalho seleciona o ícone **Lazarus_fpcupdeluxe**.
            2. Selecione a opção [**/Pacotes/instalar/disponíveis para instalação/**](img/form_instalar_pacotes.jpeg):
               1. No painel **Disponíveis para instalar** selecione os seguintes pacotes:
                  1. Para transformar em janela única:
                     1. [**AnchorDockingDsgn**](https://wiki.freepascal.org/AnchorDockingDsgn);
                     2. [**Sparta_DockedFormEditor**](https://github.com/alrieckert/lazarus/blob/master/components/sparta/dockedformeditor/sparta_dockedformeditor.pas).

                  2. Instalar a opção de grupo de projetos.
                     1. [**LazProjectGroups**](https://wiki.freepascal.org/Project_Groups).

               2. No painel **Disponíveis para instalar** pressione o botão **Instalar pacotes selecionados**.
               3. No painel de botões abaixo do painel **Disponíveis para instalar** pressione o botão **Salvar e reconstruir a IDE**

         4. **Referências:**
            1. [usando-como-instalador-o-fpcupdeluge-nivel-medio](https://gladiston.net.br/programacao/lazarus-ide/usando-como-instalador-o-fpcupdeluge-nivel-medio/)
            2. [Download do FpCupDeLuxe](https://github.com/LongDirtyAnimAlf/fpcupdeluxe/releases)

         5. <text onclick="goBack()">[🔙]</text>

      2. <span id=id_assunto02></span>**Assunto 02**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 02**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      3. <span id=id_assunto03></span>**Assunto 03**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 03**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      4. <span id=id_assunto04></span>**Assunto 04**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 04**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      5. <span id=id_assunto05></span>**Assunto 05**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 05**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      6. <span id=id_assunto06></span>**Assunto 06**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 06**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      7. <span id=id_assunto07></span>**Assunto 07**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 07**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      8. <span id=id_assunto08></span>**Assunto 08**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 08**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      9. <span id=id_assunto09></span>**Assunto 09**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 09**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

      10. <span id=id_assunto10></span>**Assunto 10**
          1. Descrição do conteúdo.
          2. **Exemplo do assunto 10**.
             1. Descrição do exemplo

                  ```ts
                  ```

          3. **Referências:**
             1. [title](link)
             2. [title](link)

          4. <text onclick="goBack()">[🔙]</text>

      11. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
      1. [Site oficial para produzir este documento](#1)
      2. [#](##)
      3. [#](##)
      4. [#](##)
      5. [#](##)

      6. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. dd/mm/2021 <!--TODO: HISTÓRICO -->

         - <text onclick="goBack()">[🔙]</text>

      2. dd/mm/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] Criar este documento baseado no modelo03.md ;
         - [ ] Escrever tópico Objetivos;
         - [ ] Escrever tópico Pre-requisitos
         - [ ] Escrever tópico Benefícios
         - [ ] Escrever tópico desvantagens
         - [ ] Escrever tópico Conteúdo
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Referências
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

</main>

[🔝🔝](#topo "Retorna ao topo")