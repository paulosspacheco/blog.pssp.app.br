<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Projeto Unit Terminal embutido em TForm <a href="EmbeddedTerminalUnit.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## Descrição

O `EmbeddedTerminalUnit` é um componente para Lazarus/Free Pascal que implementa um terminal embutido em um formulário gráfico. Ele foi projetado para ser integrado à IDE do Lazarus, funcionando de forma similar ao terminal do Visual Studio Code (VSCode), com suporte a navegação por histórico de comandos, rolagem automática, e interação com shells Linux como `/bin/bash` e `/bin/sh`.

Este projeto foi desenvolvido com o objetivo de ser doado à comunidade Free Pascal/Lazarus, para que possa ser incluído como uma opção nativa na IDE, permitindo que os usuários executem comandos diretamente dentro do ambiente de desenvolvimento.

## Funcionalidades

- Terminal embutido com suporte a shells POSIX (`/bin/bash`, `/bin/sh`).
- Histórico de comandos salvo em `EmbeddedTerminalUnit.json` com navegação por setas (cima/baixo).
- Suporte a `Ctrl+C` para interromper comandos em execução.
- Roloagem automática para a última linha ao exibir saídas.
- Proteção do prompt contra edição acidental.
- Filtragem de mensagens de erro comuns (como "not found").
- Prompt personalizado que mostra o nome da pasta atual (como `root$`).

## Requisitos

- **Lazarus/Free Pascal**: Versão compatível com POSIX (Linux).
- **Units necessárias**: `Classes`, `SysUtils`, `Forms`, `Controls`, `Graphics`, `Dialogs`, `StdCtrls`, `ExtCtrls`, `Unix`, `BaseUnix`, `unixtype`, `ctypes`, `termio`, `LCLType`, `fpjson`, `jsonparser`.
- **Pacote necessário**: `fcl-json` para manipulação de JSON (geralmente incluído no Lazarus).
- **Sistema operacional**: Linux (devido ao uso de PTYs e shells POSIX). Suporte a outras plataformas (como Windows) pode ser adicionado com contribuições da comunidade.

## Instalação

1. Copie o arquivo `embeddedterminalunit.pas` para o diretório do seu projeto.
2. Adicione a unit ao seu projeto no Lazarus:
   - No menu, vá para `Project` &gt; `Add Editor Files`.
   - Selecione o arquivo `embeddedterminalunit.pas`.
3. Certifique-se de que o pacote `fcl-json` está instalado:
   - No Lazarus, vá para `Package` &gt; `Install/Uninstall Packages`.
   - Verifique se o pacote `fcl-json` está listado e instalado. Caso contrário, instale-o.
4. Compile e execute o projeto:
   - Pressione `Ctrl+F9` para compilar.
   - Pressione `F9` para executar.

## Uso

- O terminal é exibido em um formulário gráfico com um `TMemo` para saída e um `TEdit` para entrada de comandos.
- Digite comandos no `TEdit` (como `ls -l`, `pwd`, etc.) e pressione Enter ou clique no botão "Enviar" para executá-los.
- Use as setas para cima (`↑`) e para baixo (`↓`) para navegar pelo histórico de comandos.
- Pressione `Ctrl+C` para interromper um comando em execução (como `sleep 10`).
- O histórico de comandos é salvo automaticamente no arquivo `EmbeddedTerminalUnit.json` no mesmo diretório do executável.

## Exemplo de saída

Após executar o comando `ls -lR`, o terminal exibe uma saída similar a:

```sh
.:
<spacheco/LazarusProjects/console/EmbeddedTerminal$ 
ls -lR
.:
total 27736
drwxr-xr-x 2 admininistrador administrador     4096 abr 19 19:24 backup
drwxr-xr-x 2 admininistrador administrador     4096 abr 19 19:09 docs
-rwxr-xr-x 1 admininistrador administrador 28086448 abr 19 19:24 EmbeddedTerminal
-rw-r--r-- 1 admininistrador administrador   133345 abr 18 20:50 EmbeddedTerminal.ico
-rw-r--r-- 1 admininistrador administrador     2314 abr 19 18:45 EmbeddedTerminal.lpi
-rw-r--r-- 1 admininistrador administrador      425 abr 19 18:45 EmbeddedTerminal.lpr
-rw-r--r-- 1 admininistrador administrador     7870 abr 19 19:24 EmbeddedTerminal.lps
-rw-r--r-- 1 admininistrador administrador   136112 abr 19 19:30 EmbeddedTerminal.res
-rw-r--r-- 1 admininistrador administrador      124 abr 19 18:15 EmbeddedTerminalUnit.json
drwxr-xr-x 3 admininistrador administrador     4096 abr 18 20:47 lib
drwxr-xr-x 3 admininistrador administrador     4096 abr 19 19:24 units

./backup:
total 16
-rw-r--r-- 1 admininistrador administrador 2314 abr 19 18:31 EmbeddedTerminal.l
pi
-rw-r--r-- 1 admininistrador administrador  425 abr 19 12:38 EmbeddedTerminal.lpr
-rw-r--r-- 1 admininistrador administrador 7863 abr 19 18:45 EmbeddedTerminal.lps

./docs:
total 8
-rw-r--r-- 1 admininistrador administrador 6815 abr 19 19:09 README.md

./lib:
total 4
drwxr-xr-x 2 admininistrador administrador 4096 abr 19 19:24 x86_64-linux

./lib/x86_64-linux:
total 836
-rw-r--r-- 1 admininistrador administrador   1349 abr 19 19:24 EmbeddedTerminal.compiled
-rw-r--r-- 1 admininistrador administrador  43312 abr 19 19:24 EmbeddedTerminal.o
-rw-r--r-- 1 admininistrador administrador 230136 abr 19 19:24 EmbeddedTerminal.or
-rw-r--r-- 1 admininistrador administrador 136112 abr 19 19:24 EmbeddedTerminal.res
-rw-r--r-- 1 admininistrador administrador   1031 abr 19 19:24 embeddedterminalunit.lfm
-rw-r--r-- 1 admininistrador administrador 311672 abr 19 19:24 embeddedterminalunit.o
-rw-r--r-- 1 admininistrador administrador 112821 abr 19 19:24 embeddedterminalunit.ppu

./units:
total 352
drw
xr-xr-x 2 admininistrador administrador   4096 abr 19 19:24 backup
-rw-r--r-- 1 admininistrador administrador   1031 abr 19 19:24 embeddedterminalunit.lfm
-rw-r--r-- 1 admininistrador administrador 351474 abr 19 19:24 embeddedterminalunit.pas

./units/backup:
total 336
-rw-r--r-- 1 admininistrador administrador   1031 abr 19 18:45 embeddedterminalunit.lfm.bak
-rw-r--r-- 1 admininistrador administrador 329565 abr 19 18:45 embeddedterminalunit.pas
-rw-r--r-- 1 admininistrador administrador    124 abr 18 20:51 unit1.lfm.bak
-rw-r--r-- 1 admininistrador administrador    222 abr 18 20:51 unit1.pas
<spacheco/LazarusProjects/console/EmbeddedTerminal$ 

```

## Objetivo

Este projeto foi desenvolvido com o objetivo de ser integrado à IDE do Lazarus como uma opção nativa de terminal embutido, similar ao terminal do Visual Studio Code. Ele pode ser usado como um componente independente ou incorporado ao ambiente de desenvolvimento para facilitar a execução de comandos diretamente na IDE.

## Última Atualização

- **Data**: 19/04/2025
- **Hora**: 18:46:00 hs (Horário de Brasília)

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## Contribuições

Contribuições são bem-vindas! Se você deseja melhorar o `EmbeddedTerminalUnit`, considere as seguintes áreas:

- **Suporte multiplataforma**: Adicionar suporte para Windows (usando `cmd.exe` ou PowerShell) e macOS.
- **Integração à IDE**: Transformar o terminal em uma janela acoplável na IDE do Lazarus, similar ao terminal do VSCode.
- **Personalização**: Adicionar opções para configurar o shell, o prompt, ou o comportamento do terminal.
- **Melhorias no histórico**: Remover duplicatas no histórico de comandos ou adicionar um limite de tamanho.

Para contribuir:

1. Faça um fork do repositório no GitHub.
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`).
3. Faça suas alterações e commit (`git commit -m "Adiciona nova funcionalidade"`).
4. Envie um pull request para o repositório principal.

## Agradecimentos

- Desenvolvido por Grok, com análise de Paulo Pacheco.
- Inspirado na necessidade de um terminal embutido na IDE do Lazarus, similar ao do Visual Studio Code.


</main>

[🔝🔝](#topo "Retorna ao topo")