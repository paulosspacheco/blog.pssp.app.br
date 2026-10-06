# Estrutura de Diretórios do Sistema Linux

    /
    ├── bin
    ├── boot
    ├── dev
    ├── etc
    ├── home
    │   ├── user1
    │   ├── user2
    │   └── user3
    ├── lib
    ├── mnt
    ├── opt
    ├── proc
    ├── root
    ├── sbin
    ├── tmp
    ├── usr
    └── var

------------------------------------------------------------------------

## Descrição dos Diretórios

### `/`

O diretório raiz do sistema. É o ponto inicial de toda a hierarquia de
diretórios. Todos os outros diretórios e arquivos estão contidos nele.

### `/bin`

Contém os **executáveis essenciais** do sistema, como comandos básicos
(por exemplo: `ls`, `cp`, `mv`, `cat`). Estes comandos são necessários
mesmo quando outras partições não estão montadas.

### `/boot`

Armazena os **arquivos necessários para inicializar o sistema**,
incluindo o kernel do Linux e o carregador de boot (como o GRUB).

### `/dev`

Contém **arquivos de dispositivos**, que representam o hardware do
sistema (ex: discos, terminais, impressoras). O Linux trata tudo como um
arquivo, inclusive dispositivos físicos.

### `/etc`

Armazena **arquivos de configuração** do sistema e dos serviços
instalados. Exemplo: configuração de rede, usuários e inicialização de
serviços.

### `/home`

Diretório onde ficam os **arquivos pessoais dos usuários comuns**. Cada
usuário tem uma subpasta dentro de `/home`: - `/home/user1` -
`/home/user2` - `/home/user3`

### `/lib`

Contém as **bibliotecas essenciais** compartilhadas usadas pelos
binários em `/bin` e `/sbin`. Essas bibliotecas são semelhantes às DLLs
no Windows.

### `/mnt`

Utilizado para **montar temporariamente sistemas de arquivos** externos,
como pendrives, CDs ou partições adicionais.

### `/opt`

Diretório reservado para a **instalação de softwares opcionais** de
terceiros que não fazem parte do sistema base.

### `/proc`

Um **sistema de arquivos virtual** que fornece informações sobre
processos e recursos do kernel. É usado para monitorar e configurar o
sistema em tempo real.

### `/root`

É o **diretório pessoal do usuário root (administrador)**. Diferente de
`/`, ele serve como "home" apenas do superusuário.

### `/sbin`

Contém **executáveis administrativos** usados principalmente pelo root
para gerenciar o sistema (ex: `ifconfig`, `fdisk`, `reboot`).

### `/tmp`

Pasta usada para armazenar **arquivos temporários** criados por
programas durante a execução. Geralmente é limpa automaticamente após
reinicializações.

### `/usr`

Armazena **programas, bibliotecas e documentação** que não são
essenciais para a inicialização. É o diretório mais volumoso em muitos
sistemas.

### `/var`

Contém **arquivos variáveis** que mudam durante o uso do sistema, como
logs, e-mails, caches e filas de impressão.

------------------------------------------------------------------------

📘 **Resumo:**\
Esta estrutura padronizada torna o Linux modular, organizado e seguro,
permitindo que diferentes distribuições mantenham compatibilidade e
funcionamento consistente entre si.
