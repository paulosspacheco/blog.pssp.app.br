# <span id="topo"><span>[Um servidor de protocolo de área de trabalho remota de código aberto Xrdp](http://xrdp.org/) <a href="teoria_xrdp.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >↵</a><a href="teoria_xrdp.pdf" target="_blank" title="Pressione aqui para visualizar o PDF deste documento em nova aba.">℘</a>

## **1. INDEX**

---

   1. **Objetivo**<span id="topo_Objetivo"><span>

      1. [Objetivo do xrdp](#id_objetivo).

      2. [Pre-requisitos para usar xrdp](#id_pre_requisitos).

      3. [Benefícios adquirido com este documento](#id_beneficios).

   2. [Programa xrdp e suas dependências](#id_xdrp)
      1. [Manual xrdp.ini](https://www.systutorials.com/docs/linux/man/5-xrdp.ini/)
      2. [How to configure xRDP server on Ubuntu 18.04](https://serverspace.io/support/help/how-to-configure-xrdp-server-on-ubuntu-18-04/)

   3. [Referências](#id_referencias)
   4. [Histórico](#id_historico)

## **2. CONTEÚDO**

---

   1. **Objetivo**

      1. <span id="id_objetivo"><span>Objetivo principal do xrp.
         1. O xrdp fornece um login gráfico para máquinas remotas usando RDP (Microsoft Remote Desktop Protocol). O xrdp aceita conexões de vários clientes RDP: FreeRDP, rdesktop, NeutrinoRDP e Microsoft Remote Desktop Client (para Windows, macOS, iOS e Android).
         2. O xrdp oferece suporte não apenas para gráficos remotos, mas também:
            1. transferência bidirecional da área de transferência (texto, bitmap, arquivo);
            2. redirecionamento de áudio;
            3. redirecionamento de unidade (montar unidades de clientes locais na máquina remota).
         3. O transporte RDP é criptografado usando o [protocolo TLS](https://pt.wikipedia.org/wiki/Transport_Layer_Security) por padrão.

      2. <span id="id_pre_requisitos"></span>Pre-requisitos para usar xrdp.
         1. Familiaridade com o sistema operacional linux.
         2. Familiaridade com cliente rdp d windows.

      3. <span id="id_beneficios"></span>Benefícios adquirido com este documento:
         1. Este documento registra tudo que for necessário para conectar-se com uma máquina linux estando em máquinas Windows ou não.

      4. [🔝](#topo_Objetivo "Retorna ao topo")

   2. <span id="id_xdrp"></span>**Programa xrdp e suas dependências**

      1. xrdp:
         1. Xrdp é o principal servidor que aceita conexões de clientes RDP. Xrdp contém as camadas RDP, segurança, MCS, ISO e TCP, um gerenciador de janelas simples e alguns controles. É um servidor de processo único multiencadeado. É neste processo que se mantém a gestão central das sessões. O gerenciamento central inclui o acompanhamento de uma sessão e a administração de pop-ups para os usuários. O Xrdp é controlado pelo arquivo de configuração /etc/xrdp/xrdp.ini.

         2. O RDP tem 3 níveis de segurança entre o servidor RDP e o cliente RDP. Baixo, médio e alto. O baixo é de 40 bits, os dados do cliente para o servidor são criptografados, o médio é a criptografia de 40 bits nos dois sentidos e o alto é a criptografia de 128 bits nos dois sentidos. Xrdp atualmente suporta todos os 3 níveis de criptografia por meio do arquivo /etc/xrdp/xrdp.ini. A troca de chaves RSA é usada com clientes e servidores randoms para estabelecer as chaves RC4 antes da conexão do cliente.

         3. Os módulos são carregados em tempo de execução para fornecer a funcionalidade real. Muitos módulos diferentes podem ser criados para apresentar um dos muitos desktops diferentes ao usuário. Os módulos são carregáveis ​​para economizar memória e suportar módulos GPL e não GPL.

         4. Multi threaded para fornecer o desempenho ideal do usuário. Um cliente não pode atrasar todos eles. Um processo multithread também é necessário para o sombreamento de sessão com qualquer módulo. O módulo não precisa considerar o sombreamento, o servidor xrdp faz isso. Por exemplo, você pode sombrear um VNC, RDP ou uma sessão de módulo customizado, todos com a mesma ferramenta de sombreamento.

         5. Construir no gerenciador de janelas para enviar pop-ups para qualquer usuário executando qualquer módulo. Também pode ser o usuário para fornecer avisos ou erros de conexão.
      2. ..
      3. [🔝](#topo_pessoais "Retorna ao topo")

   3. <span id="id_como_executar_client_xrdp"></span>**Cliente xrdesktop teste.**

      1. <pre>$ rdesktop localhost:3389 </pre>
         1. Mensagens de erro :
            1. <pre>

                  Auto selecting keyboard map 'pt-br' from locale
                  Connection established using plain RDP.

                  Clipboard(error): xclip_handle_SelectionNotify(),
                  unable to find a textual target to satisfy RDP
                  clipboard text request Core(error): tcp_send(),
                  send() failed: Pipe quebrado.

                  Disconnected due to network error, exiting...
                  disconnect: Unknown reason.
            </pre>

      2. [🔝](#topo_pessoais "Retorna ao topo")  

   4. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [Manual do xrdp.ini](https://www.systutorials.com/docs/linux/man/5-xrdp.ini/)
      2. [xrdp/install.txt](https://github.com/neutrinolabs/xrdp/blob/devel/install.txt)
      3. [xrdp é mantido por neutrino labs](https://github.com/neutrinolabs )
      4. [XRDP - Habilitando Recurso de Redirecionamento de Unidades e Área de Transferência](https://c-nergy.be/blog/?p=9285)
      5. [Video - installing Xrdp Server (Remote Desktop RDP ) On Ubuntu 20.04 LTS (Focal Fossa) Desktop](https://www.youtube.com/watch?v=fOkQJ2a69PI)
      6. [Como configurar o XRDP para iniciar o cinnamon como sessão de desktop padrão](https://askubuntu.com/questions/135483/how-to-configure-xrdp-to-start-cinnamon-as-default-desktop-session)
      7. [Notas de versão para xrdp v0.9.15 (2020/12/28)](https://github.com/neutrinolabs/xrdp/releases)
      8. [xrdp.ini (5) - Man Pages Linux](/etc/xrdp/xrdp.ini)
      9. [Como configurar o servidor xRDP no Ubuntu 18.04](https://serverspace.io/support/help/how-to-configure-xrdp-server-on-ubuntu-18-04/).

   5. <span id="id_historico"><span>**HISTÓRICO**

      1. 04/02/2021 <!--TODO: HISTÓRICO -->
         - [x] Criado este documento;

         - [🔝](#topo "Retorna ao topo")

      2. x/xx/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] O xrdp não funcionou no linux mint, por isso fatal estudar porque não funciona;
         - [ ] Antes de tentar fazer funcionar novamente o xrdp, devo primeiro configurar a máquina para que um desktop vnc gráfico funcione primeiro;
           - [ ] [installing_vnc_server_linux_mint](https://linuxhint.com/installing_vnc_server_linux_mint/)
           - [ ] [cesso-remoto-grafico-servidor-e-cliente-pelo-Gnome](https://www.vivaolinux.com.br/dica/Acesso-remoto-grafico-servidor-e-cliente-pelo-Gnome)
         - [🔝](#topo "Retorna ao topo")

[🔝🔝](#topo "Retorna ao topo")
