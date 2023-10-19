<!-- markdownlint-disable-next-line -->
<span id="topo"><span>
<!-- markdownlint-disable-next-line -->
# O que é fcl_web <a href="fcl_web.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Tipo de aplicações  registrados no pacote lazweb](#id_Tipos_de_Aplicacoes)
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
         1. O pacote **fcl_web.lpk** é distribuído e mantido pelo projeto [FreePascal](https://www.freepascal.org/) e tem como objetivo implementar o protocolo HTTP para crianção de sites.

         2. O projeto Lazarus criou o pacote LazWeb.lpk com  objetivo de transformar as tenologias implementadas pelo pacote [**fcl_web**](https://github.com/alrieckert/lazarus/tree/master/components/fpweb) em aplicações RAD na IDE Lazarus.

         3. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Descreva os pre-requisitos necessários para compreensão deste documento.

         2. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Descreva um resumo do que este documento pode agregar no meu conhecimento.

         2. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. Descreva um resumo do que preciso sacrificar para adquirir esse conhecimento .

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_Tipos_de_Aplicacoes></span>**Tipo de aplicações  registrados no pacote lazweb**
         1. Quando o pacote [**LazWeb.lpk**](https://github.com/alrieckert/lazarus/tree/master/components/fpweb) é instalado na IDE Lazarus, na opção **Novo Projeto** é disponibilizada os seguintes tipos de aplicações:
            1. fpCGI -> [CGI](https://en.wikipedia.org/wiki/Common_Gateway_Interface)
            2. fpFCGI -> [FastCGI](https://en.wikipedia.org/wiki/FastCGI)
            3. fpApache (requires httpd as well) -> [Apache module](https://en.wikipedia.org/wiki/List_of_Apache_modules)
            4. fpHttpApp -> [embedded server](https://en.wikipedia.org/wiki/Embedded_HTTP_server)
            5. microhttpapp -> embedded server using [GNU libmicrohttp library](https://www.gnu.org/software/libmicrohttpd/#:~:text=GNU%20libmicrohttpd%20is%20a%20small,is%20simple%2C%20expressive%20and%20fully).
            6. fphttpsys -> Windows system support for HTTP protocol. obs: Não achei documento deste assunto

         2. Para cada um desses projetos, um Módulo Web a seguir é criado por padrão:
               1. **WebDataModule (TFPWebModule)**
                  1. Este é um módulo de manipulação de solicitação HTTP de uso geral, que pode ser usado para lidar com qualquer solicitação HTTP para qualquer tipo de dados.

               2. **HTMLModule (TFPHTMLModule)**
                  1. Este é um módulo específico de tratamento de requisições HTTP, voltado especialmente em produzir uma resposta HTML.

         3. Para cada Módulo Web, os seguintes componentes são registrados:
            1. **THTMLDatasetContentProducer**
               1. Cria uma tabela HTML baseada em um descendente TDataset;

            2. **THTMLSelectProducer**
               1. Cria um elemento \<SELECT> baseado em um TStringList;

            3. **THTMLDatasetSelectProducer**
               1. Cria um elemento \<SELECT> com base em um conjunto de dados (uma combinação de pesquisa);

            4. **THTMLEntityProducer**
               1. Cria um documento HTML ENTITY;

            5. **THTMLPageProducer**
               1. Cria uma página HTML usando um manipulador de eventos;

            6. **THTMLDataSetFormShowProducer**
               1. Cria um \<FORM> que permite mostrar um único registro de um conjunto de dados;

            7. **THTMLDataSetFormEditProducer**
               1. Cria um \<FORM> que permite editar um único registro de um conjunto de dados;

            8. **THTMLDataSetFormGridProducer**
               1. Cria uma série de formulários.

         4. O pacote **lazwebextra** registra adicionalmente os seguintes módulos da web e componentes:
            1. ..

            2. 

         5. **Exemplo do Tipo de aplicações  registrados no pacote lazweb**.
            1. Descrição do exemplo

               ```ts
               ```

         6. **Referências:**
            1. [title](link)
            2. [title](link)

         7. <text onclick="goBack()">[🔙]</text>

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
      2. [fpWeb Tutorial](https://wiki.lazarus.freepascal.org/fpWeb_Tutorial)
      3. [#](##)
      4. [#](##)
      5. [#](##)

      6. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. dd/mm/2021 <!--TODO: HISTÓRICO -->

         - <text onclick="goBack()">[🔙]</text>

      2. dd/mm/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] Criar este documento baseado no fcl_web.md ;
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

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
