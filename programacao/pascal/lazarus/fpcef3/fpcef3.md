<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como instalar pacote fpcef3 no lazarus <a href="fpcef3.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## 1. INDEX

---

1. [Resumo do conteúdo](#id_resumo)

2. **Introdução**
   1. [Objetivo.](#id_objetivo)
   2. [Pre-requisitos.](#id_pre_requisitos)
   3. [Benefícios.](#id_beneficios)
   4. [Desvantagens.](#id_desvantagens)

3. [**Conteúdo estudado.**](#id_Conteudo)
   1. [Passo a Passo para Instalação do fpcef3](#id_assunto01)
   2. [Assunto 02](#id_assunto02)

4. [**Referências globais.**](#id_referencias)

5. [**Histórico.**](#id_historico)

## 2. CONTEÚDO

---
<!-- markdownlint-disable-next-line -->
1. <span id="id_resumo"><span>**Resumo do conteúdo:**
   1. Descreve um resumo de como foi feito esse documento com as facilidade encontradas para produzi-lo e dificuldade encontrada.

2. **Introdução**
<!-- markdownlint-disable-next-line -->
   1. <span id="id_objetivo"><span>**Objetivo:**
      1. Este documento descreve passo a passo como testar os exemplos que acompanha o projeto fpcef3.
      2. Preciso deste projeto para testar em tempo real interface maricarai criada automaticamente em html.

      3. <text onclick="goBack()">[🔙]</text>

   2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
      1. Linux ou Windows
      2. Executável do Projeto cef.

      3. <text onclick="goBack()">[🔙]</text>
s
   3. <span id="id_beneficios"></span>**Benefícios:**
      1. Este projeto permite criar interagir com páginas html dentro de um programa Lazarus sem necessidade de usar o browser externo.
      2. Teste de api http;

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id="id_desvantagens"></span>**Desvantagens**.
      1. Ainda não sei....

      2. <text onclick="goBack()">[🔙]</text>

<!-- markdownlint-disable-next-line -->
1. <span id=id_Conteudo></span>**Conteúdo estudado**

   1. <span id=id_assunto01></span>**Passo a Passo para Instalação do fpcef3**
      1. Instalação do projeto fpcef3.
         1. Baixe a versão mais recente do fpcef3 no GitHub:

            ```bash

              # Selecione a pasta lazarus/ccr
              cd ~/lazarus/ccr

              # Baixar a versão mais recente no github
              git clone git@github.com:dliw/fpCEF3.git

            ```

         2. Baixar a versão do executável compilado em c do projeto CEF:

            ```bash

               # Selecione a pasta lazarus/ccr
               cd ~/lazarus/ccr

               # Baixar a versão recomendada pelo projeto fpcef3
               wget https://cef-builds.spotifycdn.com/cef_binary_122.1.13%2Bgde5b724%2Bchromium-122.0.6261.130_linux64.tar.bz2

               # Descompactar arquivo acima baixado
               tar -jxvf cef_binary_121.3.15+g4d3b0b4+chromium-121.0.6167.184_linux64.tar.bz2

               # Copiar o executável do projeto acima para a pasta criada pelo comando git clone git@github.com:dliw/fpCEF3.git
               cd ./cef_binary_121.3.15+g4d3b0b4+chromium-121.0.6167.184_linux64
               cp -af ./Release/*.* ../fpcef3-121.0.6167.184/bin
               cp -af ./Resources/*.* ../fpcef3-121.0.6167.184/bin

            ```

         3. Instalar pacote fpcef3_lazarus.lpk
            1. Entrar na ide Lazarus
            2. Selecionar a opção /Pacotes/Abri arquivo do pacote (.lpk)
            3. Seleciona a pasta ~/lazarus/ccr/fpcef3-121.0.6167.184/packages
            4. Selecionar o pacote fpcef3_lazarus.lpk
            5. Pressione no botão Instalar.

      2. Teste para checar se está funcionando:
         1. Entrar na IDE Lazarus
            1. Selecionar a opção /project/abrir projeto...
               1. Selecionar arquivo ~/lazarus/ccr/fpcef3-121.0.6167.184/demos/Lazarus_Linux_GTK2/MiniBrowser/MiniBrowser.lpi
            2. Selecionar opção /Executar/Executar.

         2. Notas:
            1. Executando no modo gráfico dentro da IDE o programa diz que existe arquivo ausente.
            2. Executando no modo console gera o seguinte erro:

               ```bash

                   (MiniBrowser:38711): Gtk-ERROR **: 11:27:09.620: GTK+ 2.x symbols detected. Using GTK+ 2.x and GTK+ 3 in the same process is not supported
                  [0100/000000.735234:WARNING:sandbox_linux.cc(418)] InitializeSandbox() called with multiple threads in process gpu-process.
                  Trace/breakpoint trap (imagem do núcleo gravada)


               ```

               1. Tentativa de corrigir:
                  1. Baixar executáveis cef do[ link](https://cef-builds.spotifycdn.com/index.html#linux64) para ver se dar certo
            3. ,,

      3. **Referências:**
         1. [fpcef3 é um projeto de código aberto criado por Salvador Díaz Fau](https://www.briskbard.com/index.php?lang=en&pageid=cef)
         2. [github](https://github.com/salvadordf/fpcef3)

      4. <text onclick="goBack()">[🔙]</text>

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

   11. <text onclick="goBack()">[🔙]</text>
<!-- markdownlint-disable-next-line -->
1. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
   1. [#](##)
   2. [#](##)
   3. [#](##)
<!-- markdownlint-disable-next-line -->
   1. <text onclick="goBack()">[🔙]</text>
<!-- markdownlint-disable-next-line -->
1. <span id="id_historico"><span>**HISTÓRICO**

   1. dd/mm/2021 <!--TODO: HISTÓRICO -->
<!-- markdownlint-disable-next-line -->
      - <text onclick="goBack()">[🔙]</text>

   1. dd/mm/2021 <!--FIXME: Falta fazer os item abaixo: -->
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
