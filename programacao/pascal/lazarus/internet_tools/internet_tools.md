<!-- markdownlint-disable-next-line -->
<span id="topo"><span> 
<!-- markdownlint-disable-next-line -->
# Internet Tools - pacote FreePascal<a href="internet_tools.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. [Resumo do conteúdo](#id_resumo)

   2. **Introdução**
      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [Benefícios.](#id_beneficios)
      4. [Desvantagens.](#id_desvantagens)

   3. [**Conteúdos.**](#id_Conteudo)
      1. [Como instalar o componente internet tools](#id_intalacao)
      2. [assunto02](#id_assunto02)

   4. [**Referências globais.**](#id_referencias)

   5. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---
<!-- markdownlint-disable-next-line -->
   1. <span id="id_resumo"><span>**Resumo do conteúdo:**
      1. O projeto [internettools](https://wiki.lazarus.freepascal.org/Internet_Tools#Overview) foi escrito na linguagem pascal e depende dos projetos [FLRE](https://github.com/BeRo1985/flre) e [synapse](https://wiki.lazarus.freepascal.org/Synapse) no qual  podem ser instalados usando o projeto [fpcupdeluxe](https://wiki.lazarus.freepascal.org/fpcupdeluxe).
      2. O _fpcupdeluxe_ tem a opções de instalar o pacote _internettools_, porém a instalação não funciona e quebra a IDE, por isso é recomendado instalar usando a forma manual descrita neste documento.

   2. **Introdução**
      1. <!-- markdownlint-disable-next-line -->
         <span id="id_objetivo"><span>
         **Objetivo:**
         1. Internet Tools é uma biblioteca para processar páginas da web e deve ser facilmente utilizável. [Veja mais...](https://wiki.lazarus.freepascal.org/Internet_Tools)
         2. Internet Tools fornece unidades para processar dados X/HTML e baixá-los por meio de uma conexão HTTP ou HTTPS.
         3. Internet Tools não implementam conexões HTTPS por si só, mas fornecem _wrappers_ em torno dos pacotes _wininet_, _synapse_ e _Apache HttpComponents_.
         4. Internet Tools é totalmente implementada em Pascal, thread-safe e GPL.

         5. <!-- markdownlint-disable-next-line -->
            <text onclick="goBack()">[🔙]</text>

      2. <!-- markdownlint-disable-next-line -->
         <span id="id_pre_requisitos"></span>
         **Pre-requisitos:**
         1. Os wrappers são implementados como classes derivadas de uma interface abstrata, para que o aplicativo possa alternar facilmente entre os dois back-ends. No entanto, é recomendado usar o wrapper wininet no Windows, o wrapper synapse no Linux e o wrapper Apache no Android.

         2. No Linux você também precisa instalar o Synapse e o OpenSSL devel. Para Android, você precisa do Android SDK/NDK padrão e inicializar a referência JVM em bbjniutils. Nas configurações padrão ele usa FLRE como biblioteca de expressões regulares, você pode definir uma definição USE_SOROKINS_REGEX para usar a unidade regexpr do Sorokin/FPC.

         3. Dependências que podem ser instaladas com _fpCupDeLuxe_:
            1. [FLRE](https://github.com/BeRo1985/flre) -  
               1. FLRE - Fast Light Regular Expressions - Uma biblioteca de expressões regulares fast light
            2. [synapse](https://wiki.lazarus.freepascal.org/Synapse).
               1. O Synapse fornece uma porta serial fácil de usar e uma biblioteca TCP/IP síncrona.
            3. .

         4. <!-- markdownlint-disable-next-line -->
            <text onclick="goBack()">[🔙]</text>

      3. <!-- markdownlint-disable-next-line -->
         <span id="id_beneficios"></span>
         **Benefícios:**
         1. Uso essa ferramenta para extrai o título e o corpo do html para criar o campo tags do arquivo _tipuesearch_content.js_ do programa _tipuesearch_.

         2. <!-- markdownlint-disable-next-line -->
            <text onclick="goBack()">[🔙]</text>

      4. <!-- markdownlint-disable-next-line -->
         <span id="id_desvantagens"></span>
         **Desvantagens**.
         1. Difícil de instalar com fpCupDeLuxe porque quebra o lazarus. Para resolver é necessário entrar na configuração das pastas e informa a pasta das dependências.

         2. <!-- markdownlint-disable-next-line -->
            <text onclick="goBack()">[🔙]</text>

<!-- markdownlint-disable-next-line -->
   1. <span id=id_Conteudo></span>**Conteúdo estudado**
      1. <!-- markdownlint-disable-next-line -->
         <span id=id_intalacao></span>**Passo a passo para instalar o componente internet tools**
         1. Executar projeto _FpCupDeLuxe_
            1. Na aba _Modules_ instalar os pacotes:
               1. [FLRE](https://github.com/BeRo1985/flre) -  
                  1. FLRE - Fast Light Regular Expressions - Uma biblioteca de expressões regulares fast light
               2. [synapse](https://wiki.lazarus.freepascal.org/Synapse).
                  1. O Synapse fornece uma porta serial fácil de usar e uma biblioteca TCP/IP síncrona.
               3. Nota:
                  1. Não execute _intertools_ da _Modules_ porque não funciona. É necessário seguir os passos abaixo.

         2. Baixar projeto InternetTools do github

            ```sh
               cd ~/Lazarus/ccr       
               cd ccr
               git clone git@github.com:benibela/internettools.git             
                  
            ```

         3. Executar o lazarus;
         4. Selecionar opção _/pacotes/abri arquivo de pacotes_;
         5. Selecionar pacote _~/Lazarus/ccr/internettools_;
         6. Selecionar _opções/paths_
         7. Na opção _outros caminhos da unidade_  adicionar os seguintes paths criadas pelo programa fpcupdeluxe:
            1. ../synapse
            2. ../flre/src
            3. Nota:
               1. Deletar os caminhos inválido que vem no projeto;
         8. Executar a opção  recompilar tudo requerido
         9. Executar a opção instalar pacote.
         10. Notas
             1. Para usar o pacote _~/Lazarus/ccr/internettools_ é necessário informar em seu projeto o local das units do projeto internettools.

         11. <!-- markdownlint-disable-next-line -->
             <text onclick="goBack()">[🔙]</text>

      2. <!-- markdownlint-disable-next-line -->
         <text onclick="goBack()">[🔙]</text>

   2. <!-- markdownlint-disable-next-line -->
      <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
      1. [Internet-Tools Overview](https://benibela.de/documentation/internettools/)
      2. [BeniBela on-line/internettools](https://benibela.de/sources_en.html#internettools)
      3. [Pattern matching / XPath 3.1 / XQuery 3.1 / CSS 3 Selector Online Tester](https://www.videlibri.de/cgi-bin/xidelcgi)  
      4. [Xidel - ferramenta de extração de dados HTML/XML/JSON](https://www.videlibri.de/xidel.html#downloads)

      5. <!-- markdownlint-disable-next-line -->
         <text onclick="goBack()">[🔙]</text>

   3. <!-- markdownlint-disable-next-line -->
      <span id="id_historico"><span>**HISTÓRICO**
      <!--TODO: HISTÓRICO -->
      1. **27/10/2023** <!--FIXME: Falta fazer os item abaixo: -->
         - [x] Criar este documento baseado no internet_tools.md ;
         - [x] Escrever tópico Objetivos;
         - [x] Escrever tópico Pre-requisitos
         - [x] Escrever tópico Benefícios
         - [x] Escrever tópico desvantagens
         - [ ] Escrever tópico Conteúdo
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Referências
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")
<!-- markdownlint-disable-next-line -->
 <script>    function goBack() {    window.history.back()}</script>
