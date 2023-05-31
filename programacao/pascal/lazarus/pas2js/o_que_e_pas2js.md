# <span id="topo"><span>O que é o projeto pas2js <a href="o_que_e_pas2js.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)
      5. [Repositório do projeto](https://gitlab.com/freepascal.org/fpc/pas2js)

   3. [**Conteúdo estudado.**](#id_Conteudo)
      1. [Exemplo demo/apiclient](#id_apiclient)
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
         1. O [Pas2js](https://wiki.freepascal.org/pas2js) é um transpiler Pascal para JavaScript de código aberto . Ele analisa Object Pascal e emite JavaScript. O JavaScript está atualmente no nível ECMAScript 5 e deve rodar em qualquer navegador ou no Node.js (target "nodejs"). Está disponível em 5 formas:
            1. como uma biblioteca;
            2. como um programa de linha de comando;
            3. como servidor web;
            4. como um programa node.js;
            5. como um programa em execução no navegador.
         2. Documento oficial do projeto pode ser lido [aqui...](https://wiki.freepascal.org/pas2js)

         3. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Conhecimento da linguagem pascal, html, javascript, nodejs e tecnologias web necessárias para pode publicar uma site na nuvem.

         2. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span> **Benefícios:**
         1. Permitir programar com uma linguagem tipada como o pascal para construção de aplicações clientes e usar a linguagem  pascal como aplicação servidora.

         2. As aplicações clientes web facilita a vida do usuário, porque eles tem em sua máquina o browser instalado e o browse há protege de acesso a sua máquina em dados que o mesmo não deseja compartilhar com fornecedores de software.

         3. Programadores pascal não precisam dominar as nuncias de uma nova linguagem para produzir aplicações web.

         4. É possível dentro do pascal instanciar uma classe javascript usando a palavra reservada [external](https://gitlab.com/freepascal.org/fpc/pas2js/-/blob/main/demo/library/main.lpr). [Veja mais...](https://wiki.freepascal.org/pas2js#Compiler);

         5. O pas2js permite criar módulos javascript usando a sintaxe library do pascal. [Veja mais...](https://wiki.freepascal.org/pas2js_modules);

         6. 

         7. <text onclick="goBack()">[🔙]</text>

      4. <span id="id_desvantagens"></span>**Desvantagens**.
         1. Ainda não tenho opinião formada para dar o meu parecer.

         2. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <span id=id_apiclient></span>**Exemplo demo/apiclient**

         1. O objetivo deste exemplo é demostrar a interação dos códigos escritos em pascal e o browser através do código javascript gerado pelo transpilador pas2js.

         2. Arquivos do projeto:
            1. **apiclient.dpr**
               1. Arquivo de projeto principal com código pascal.

            2. **Index.html**
               1. Arquivo html editado com editor de página html e o mesmo é obrigatório para poder executar o arquivo **apiclient.js** gerado pelo transpilador **pas2js**.

            3. **bulma.min.css**
               1. Arquivo com a formatação dos códigos .css criador com editor de .css;

            4. **apiclient.js**
               1. Arquivo javascript gerado pelo transpilador pas2js ele contém toda programação feita no arquivo **apiclient.dpr**.

            5. **apiclient.js.map**
               1. Um mapa de origem é usado para que possa depurar o código usando o browser. [Veja mais...](https://wiki.freepascal.org/pas2js)
            6. ..

         3. **Exemplo do Exemplo demo/apiclient**.
            1. Descrição do exemplo

               ```ts
               ```

         4. **Referências:**
            1. [Como usar o vscode para debugar o projeto](https://code.visualstudio.com/docs/editor/debugging#_launch-configurations)
            2. [title](link)
            3. [title](link)

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
         - [ ] Criar este documento baseado no o_que_e_pas2js.md ;
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
