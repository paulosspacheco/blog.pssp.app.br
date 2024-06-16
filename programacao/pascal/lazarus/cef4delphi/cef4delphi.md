<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Como instalar pacote [cef4delphi](https://github.com/salvadordf/CEF4Delphi) no lazarus <a href="cef4delphi.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## 1. INDEX

---

1. [Resumo do conteúdo](#id_resumo)

2. **Introdução**
   1. [Objetivo.](#id_objetivo)
   2. [Pre-requisitos.](#id_pre_requisitos)
   3. [Benefícios.](#id_beneficios)
   4. [Desvantagens.](#id_desvantagens)

3. [**Conteúdo estudado.**](#id_Conteudo)
   1. [Passo a Passo para Instalação do Cef4Delphi](#id_assunto01)
   2. [CEF é o anacrônico de Chromium Embedded Framework, é uma interface para o Chromium em outras aplicações.](#id_assunto02)


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
      1. Este documento descreve passo a passo como testar os exemplos que acompanha o projeto [cef4Delphi](https://www.briskbard.com/index.php?lang=en&pageid=cef).
      2. Preciso deste projeto porque o projeto  [WBotCE](https://github.com/OpenSourceCommunityBrasil/WBotCE/blob/main/README.md) usado para comunicação com [WhatsApp](https://www.whatsapp.com/?lang=pt_BR) depende do cef4Delphi.

      3. <text onclick="goBack()">[🔙]</text>

   2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
      1. Linux ou Windows
      2. No Linux usar pacote [cef_binary_121.3.15+g4d3b0b4+chromium-121.0.6167.184_linux64](https://cef-builds.spotifycdn.com/cef_binary_122.1.13%2Bgde5b724%2Bchromium-122.0.6261.130_linux64.tar.bz2).

      3. <text onclick="goBack()">[🔙]</text>
s
   3. <span id="id_beneficios"></span>**Benefícios:**
      1. Este projeto permite criar interagir com páginas html dentro de um programa Lazarus ou Delphi sem necessidade de usar o browser externo.
      2. Comunicação com o aplicativo WhatsApp usado no projeto Assistente Virtual para Médicos.

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id="id_desvantagens"></span>**Desvantagens**.
      1. Estou tendo muita dificuldade para fazer funcionar e até momento não sei porque.

      2. <text onclick="goBack()">[🔙]</text>

<!-- markdownlint-disable-next-line -->
1. <span id=id_Conteudo></span>**Conteúdo estudado**

   1. <span id=id_assunto01></span>**Passo a Passo para Instalação do Cef4Delphi**
      1. Instalação do projeto Cef4Delphi.
         1. Baixe a versão mais recente do CEF4Delphi no GitHub:

            ```bash

              # Selecione a pasta lazarus/ccr
              cd ~/lazarus/ccr

              # Baixar a versão mais recente no github
              # git clone git@github.com:salvadordf/CEF4Delphi.git
              git clone https://gitlab.com/salvadordf/CEF4Delphi.git

            ```

         2. Baixar a versão do executável compilado em c do projeto CEF:

            ```bash

               # Selecione a pasta lazarus/ccr
               cd ~/lazarus/ccr

               # Baixar a versão recomendada pelo projeto cef4delphi
               wget https://cef-builds.spotifycdn.com/cef_binary_123.0.8%2Bg43f22da%2Bchromium-123.0.6312.46_linux64.tar.bz2

               # Descompactar arquivo acima baixado
               tar -jxvf https://cef-builds.spotifycdn.com/cef_binary_123.0.8%2Bg43f22da%2Bchromium-123.0.6312.46_linux64.tar.bz2

               # Copiar o executável do projeto acima para a pasta criada pelo comando git clone git@github.com:salvadordf/CEF4Delphi.git
               cd ./https://cef-builds.spotifycdn.com/cef_binary_123.0.8%2Bg43f22da%2Bchromium-123.0.6312.46_linux64.tar.bz2
               cp -af ./Release/*.* ../CEF4Delphi-121.0.6167.184/bin
               cp -af ./Resources/*.* ../CEF4Delphi-121.0.6167.184/bin

            ```

         3. Instalar pacote cef4delphi_lazarus.lpk
            1. Entrar na ide Lazarus
            2. Selecionar a opção /Pacotes/Abri arquivo do pacote (.lpk)
            3. Seleciona a pasta ~/lazarus/ccr/CEF4Delphi-121.0.6167.184/packages
            4. Selecionar o pacote cef4delphi_lazarus.lpk
            5. Pressione no botão Instalar.

      2. Teste para checar se está funcionando:
         1. Entrar na IDE Lazarus
            1. Selecionar a opção /project/abrir projeto...
               1. Selecionar arquivo ~/lazarus/ccr/CEF4Delphi-121.0.6167.184/demos/Lazarus_Linux_GTK2/MiniBrowser/MiniBrowser.lpi
            2. Selecionar opção /Executar/Executar.

         2. .

      3. **Referências:**
         1. .

      4. <text onclick="goBack()">[🔙]</text>

   2. <span id=id_assunto02></span>**CEF é o anacrônico de Chromium Embedded Framework, é uma interface para o Chromium em outras aplicações.**
      1. Descrição do conteúdo.
      2. **Exemplo do CEF é o anacrônico de Chromium Embedded Framework, é uma interface para o Chromium em outras aplicações.**.
         1. [Instalação CEF no Linux](https://maurinsoft.com.br/instalacao-cef-no-linux/):
            1. Link para instalação: [Link](https://maurinsoft.com.br/instalacao-cef-no-linux/)
            2. Baixe os repositórios dos projetos no seguinte repositório GIT:
               1. [Baixar do repositório CEF](https://bitbucket.org/%7Bdc443723-7652-4c63-b340-033e522146db%7D/)
               2. 

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   3.  <text onclick="goBack()">[🔙]</text>
<!-- markdownlint-disable-next-line -->
1. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
   1. [Readme cef4delphi](https://github.com/salvadordf/CEF4Delphi)
   2. [Site oficial para produzir este documento](#1)
   3. [CEF4Delphi é um projeto de código aberto criado por Salvador Díaz Fau ](https://www.briskbard.com/index.php?lang=en&pageid=cef)
   4. [Instalação CEF no Linux](https://maurinsoft.com.br/instalacao-cef-no-linux/)
   5. [#](##)
   6. [#](##)
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
