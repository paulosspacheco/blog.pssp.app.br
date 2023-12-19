<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# O que é xrdp <a href="modelo01.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## 1. INDEX

---

1. [Resumo do conteúdo](#id_resumo)

2. **Introdução**
   1. [Objetivo.](#id_objetivo)
   2. [Pre-requisitos para usar xrdp para usar xrdp](#id_pre_requisitos)
   3. [Benefícios do servidor de terminais xrdp do servidor de terminais xrdp](#id_beneficios)
   4. [Desvantagens.](#id_desvantagens)

3. [**Conteúdo estudado.**](#id_Conteudo)
   1. [Como instalar o xrdp no Linux Debian ou derivados](#id_como_instalar)
   <!-- 2. [Assunto 02](#id_assunto02)
   3. [Assunto 03](#id_assunto03)
   4. [Assunto 04](#id_assunto04)
   5. [Assunto 05](#id_assunto05)
   6. [Assunto 06](#id_assunto06)
   7. [Assunto 07](#id_assunto07)
   8. [Assunto 08](#id_assunto08)
   9. [Assunto 09](#id_assunto09)
   10. [Assunto 10](#id_assunto10) -->

4. [**Referências globais.**](#id_referencias)

5. [**Histórico.**](#id_historico)

## 2. CONTEÚDO

---
<!-- markdownlint-disable-next-line -->
1. <span id="id_resumo"><span>**Resumo do conteúdo:**
   1. O projeto xrdp é uma solução versátil para acesso remoto gráfico em sistemas Linux, oferecendo uma variedade de Benefícios do servidor de terminais xrdp para administradores de sistemas, desenvolvedores e usuários que precisam gerenciar ou interagir com sistemas Linux remotamente.
   2. Este documento mostra como instalar o xrdp no sistema linux Debian e seus derivados.

2. **Introdução**
<!-- markdownlint-disable-next-line -->
   1. <span id="id_objetivo"><span>**Objetivo:**
      1. O xrdp (Remote Desktop Protocol para Linux) é um software que permite que você faça conexões de desktop remoto para sistemas Linux. Ele usa o protocolo RDP (Remote Desktop Protocol) para permitir que usuários se conectem a uma área de trabalho remota em um sistema Linux a partir de outro dispositivo, como um computador Windows.
      2. O xrdp facilita a administração remota de sistemas Linux, permitindo que você gerencie o desktop de um servidor ou computador Linux a partir de outro local. Ele fornece uma interface gráfica para o usuário (GUI) remota, permitindo que você interaja com o ambiente de desktop do Linux como se estivesse fisicamente presente na máquina.
      3. A configuração do xrdp pode variar dependendo da distribuição Linux específica que você está usando. Geralmente, você precisará instalar o xrdp no sistema Linux que deseja acessar remotamente e, em seguida, usar um cliente RDP em outro dispositivo para estabelecer a conexão remota.
      4. Por exemplo, se estiver usando um sistema Windows, você pode usar o Cliente de Área de Trabalho Remota (Remote Desktop Connection) para se conectar ao desktop remoto do Linux por meio do xrdp.
      5. Lembre-se de que, para garantir a segurança, é importante configurar corretamente as credenciais de acesso e, se possível, usar uma conexão segura, como SSH, juntamente com o xrdp para proteger a transmissão de dados entre os dispositivos..

      6. <text onclick="goBack()">[🔙]</text>

   2. <span id="id_pre_requisitos"></span>**Pre-requisitos para usar xrdp:**
      1. Ambiente de Desktop:
         1. O xrdp requer um ambiente de desktop instalado na máquina. Pode ser o ambiente de desktop padrão do Debian ou qualquer outro ambiente de desktop de sua escolha. Sem um ambiente de desktop, o xrdp não terá uma interface gráfica para fornecer remotamente.
      2. Conexão de Rede:
         1. Garanta que a máquina Debian esteja em uma rede acessível a partir do dispositivo do qual você deseja se conectar remotamente. Isso geralmente envolve configurar o firewall para permitir tráfego na porta usada pelo xrdp (por padrão, a porta 3389).
      3. Cliente RDP:
         1. Você precisará de um cliente RDP em seu dispositivo local para se conectar remotamente ao servidor Debian. Os sistemas Windows geralmente vêm com o "Cliente de Área de Trabalho Remota". Para sistemas Linux, você pode usar o "Remmina" ou outros clientes RDP disponíveis.
      4. Privilégios de Administrador (Opcional):
         1. Para instalar o xrdp e realizar algumas configurações, você pode precisar de privilégios de administrador. Isso pode ser obtido usando o comando sudo ou entrando como usuário root.
      5. Configurações de Segurança:
         1. Considere as configurações de segurança, como senhas fortes, restrição de acesso à porta RDP por meio de firewall, e se possível, a implementação de SSH para uma camada adicional de segurança na comunicação.
      6. ..

      7. <text onclick="goBack()">[🔙]</text>

   3. <span id="id_beneficios"></span>**Benefícios do servidor de terminais xrdp:**
      1. Acesso Remoto Gráfico:
         1. O xrdp permite que os usuários acessem remotamente o ambiente de desktop gráfico de um sistema Linux. Isso é particularmente útil para administradores de sistemas e usuários que precisam interagir com uma interface gráfica de usuário (GUI) em um servidor Linux, sem a necessidade de estar fisicamente presente no local..
      2. Compatibilidade com o Protocolo RDP:
         1. O xrdp usa o protocolo RDP (Remote Desktop Protocol), tornando-o compatível com clientes RDP padrão, como o "Cliente de Área de Trabalho Remota" no Windows. Isso facilita o acesso remoto a partir de uma variedade de sistemas operacionais.
      3. Integração com Ambientes de Desktop Linux:
         1. O xrdp pode ser configurado para trabalhar com diferentes ambientes de desktop Linux, como XFCE, GNOME, KDE, CINNAMON entre outros. Isso oferece flexibilidade para escolher o ambiente de desktop que melhor atenda às necessidades do usuário.
      4. Configuração e Uso Simples:
         1. A instalação e configuração do xrdp geralmente são simples, especialmente em distribuições Linux populares como o Debian. O xrdp é projetado para ser amigável ao usuário, tornando-o acessível mesmo para aqueles que não têm conhecimentos avançados de administração de sistemas.
      5. Segurança:
         1. O xrdp pode ser configurado para trabalhar com protocolos de segurança adicionais, como o SSH, proporcionando uma camada extra de proteção para as conexões remotas. Certificados SSL também podem ser usados para criptografar as comunicações, melhorando a segurança.
      6. Desempenho Adequado:
         1. Em muitos casos, o xrdp oferece um desempenho satisfatório para tarefas gráficas remotas, proporcionando uma experiência de usuário fluída em conexões de área de trabalho remota.
      7. Custo Zero:
         1. O xrdp é de código aberto e gratuito, o que significa que não há custo associado à sua instalação e uso. Isso faz com que seja uma opção econômica para implementações de acesso remoto.
      8. Multiusuário:
         1. O xrdp suporta conexões multiusuário, o que significa que vários usuários podem se conectar simultaneamente ao mesmo servidor e obter ambientes de desktop separados.

      9. <text onclick="goBack()">[🔙]</text>

   4. <span id="id_desvantagens"></span>**Desvantagens**.
      1. Desempenho Gráfico:
         1. O desempenho gráfico pode não ser tão eficiente quanto em um ambiente local, especialmente para tarefas intensivas em gráficos ou em conexões de baixa largura de banda. O rendimento pode variar dependendo do ambiente de desktop usado.
      2. Compatibilidade com Todos os Ambientes de Desktop:
         1. Embora o xrdp suporte vários ambientes de desktop, a compatibilidade total com todos os ambientes pode não ser garantida. Alguns ambientes podem exigir configurações adicionais ou não funcionar tão bem quanto outros.
      3. Configuração Pode Ser Complexa:
         1. A configuração inicial do xrdp pode ser relativamente simples, mas em alguns casos, especialmente em ambientes complexos ou com requisitos específicos, pode ser necessário ajuste adicional e configuração.
      4. Problemas com Impressão:
         1. O suporte à impressão pode ser um desafio em algumas configurações do xrdp. Configurar corretamente a impressão remota pode ser mais complicado e requerer conhecimentos específicos.
      5. Segurança:
         1. Embora o xrdp possa ser configurado com camadas de segurança adicionais, como SSH, a segurança ainda é uma preocupação em ambientes de acesso remoto. A exposição de serviços na Internet sempre traz um risco adicional, e as práticas de segurança adequadas devem ser implementadas.
      6. Reinicialização do Serviço:
         1. Em alguns casos, após atualizações ou modificações na configuração, pode ser necessário reiniciar o serviço xrdp para aplicar as alterações. Isso pode resultar em interrupções temporárias no acesso remoto.
      7. Conexões Perdidas:
         1. Em conexões instáveis ou de baixa largura de banda, o xrdp pode apresentar desconexões ou falhas ocasionais na transmissão, o que pode levar a uma experiência do usuário menos fluida.
      8. Suporte a Dispositivos USB:
         1. O suporte a dispositivos USB pode não ser tão robusto quanto em ambientes locais. Alguns dispositivos podem não funcionar corretamente ou requerer configurações adicionais.
      9. Limitações do Protocolo RDP:
         1. O xrdp utiliza o protocolo RDP, que pode ter algumas limitações em comparação com outras tecnologias de acesso remoto, dependendo dos requisitos específicos do usuário.

      10. <text onclick="goBack()">[🔙]</text>

<!-- markdownlint-disable-next-line -->
3. <span id=id_Conteudo></span>**Conteúdo estudado**
   1. <span id=id_como_instalar></span>**Como instalar o xrdp no Linux Debian ou derivados**
      1. Atualize o Sistema:
         1. Antes de instalar qualquer pacote, é uma boa prática atualizar o sistema para garantir que você tenha as versões mais recentes dos pacotes disponíveis. Execute os seguintes comandos:

            ```bash

               sudo apt update
               sudo apt upgrade

            ```

      2. Instale a interface gráfica de sua preferência caso não possua instalada:

            ```bash
            
               sudo apt install tasksel
               sudo tasksel               

            ```

      3. Instale o xrdp:
         1. Use o seguinte comando para instalar o xrdp:

            ```bash

               sudo apt install xrdp

            ```

      4. Para garantir que o xrdp seja iniciado automaticamente durante o boot, você pode usar o comando:

            ```bash

               sudo systemctl enable xrdp

            ```

      5. Configure o Firewall (Opcional):
         1. Se estiver usando um firewall, abra a porta 3389, que é a porta padrão para o protocolo RDP:

            ```bash

               sudo ufw allow 3389/tcp
               sudo ufw reload

            ```

         2. **Nota**:
            1. Certifique-se de ajustar as configurações do firewall conforme necessário.
            2. Meu maior desafio foi publicar a porta 3389, porque a porta _WAN_ 3389 é bloqueada no meu provedor e ninguém no provedor SMART sabe disso e por isso passei mais tempo do que é necessário para publicar o acesso ao meu computador estando fora da minha rede.

      6. A seguir, pode-se ajustar o arquivo de configuração:

            ```bash

               sudo xed /etc/xrdp/xrdp.ini

            ```

         1. No final o arquivo adicione as linhas abaixo:

            ```bash

               # Defina o nível de criptografia como alto:
               encrypt_level=alto

            ```

            1. encrypt_level=alto

      7. A seguir, crie um arquivo de configuração do polkit:

         ```bash

            sudo xed /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf

         ```

         1. e insira adicione no final do arquivo o código javascript abaixo:

            ```javascript

               polkit.addRule(function(action, subject) {
                  if ((action.id == “org.freedesktop.color-manager.create-device” || action.id == “org.freedesktop.color-manager.create-profile” || action.id == “org.freedesktop.color-manager.delete-device” || action.id == “org.freedesktop.color-manager.delete-profile” || action.id == “org.freedesktop.color-manager.modify-device” || action.id == “org.freedesktop.color-manager.modify-profile”) && subject.isInGroup(“{group}”))
                  {
                  return polkit.Result.YES;
                  }
               });

            ```

      8. Inicie o Serviço xrdp:
         1. Inicie o serviço xrdp com o seguinte comando:

               ```bash

                  sudo service xrdp start

               ```

         2. Se preferir, você pode usar o systemctl:

               ```bash

                  sudo systemctl start xrdp

               ```

      9. Para reiniciar _xrdp_ execute o comando abaixo:

            ```bash

               sudo /etc/init.d/xrdp restart

            ```

      10. Como saber o status do servidor:

            ```bash

               sudo systemctl status xrdp

            ```

      11. Conecte-se ao Servidor:
          1. Use um cliente RDP em outro dispositivo para se conectar ao servidor Debian. Utilize o "Cliente de Área de Trabalho Remota" no Windows ou o "Remmina" ou "rdesktop" em sistemas Linux, por exemplo.

      12. **Referências:**
          1. [xrdp no ubuntu](https://help.ubuntu.com/community/xrdp)

          2. <text onclick="goBack()">[🔙]</text>

   <!-- 2. <span id=id_assunto02></span>**Assunto 02**
      13. Descrição do conteúdo.
      14. **Exemplo do assunto 02**.
         1. Descrição do exemplo

               ```ts
               
               ```

      15. **Referências:**
         1. [title](link)
         2. [title](link)

      16. <text onclick="goBack()">[🔙]</text>

   2. <span id=id_assunto03></span>**Assunto 03**
      1. Descrição do conteúdo.
      2. **Exemplo do assunto 03**.
         1. Descrição do exemplo

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_assunto04></span>**Assunto 04**
      1. Descrição do conteúdo.
      2. **Exemplo do assunto 04**.
         1. Descrição do exemplo

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_assunto05></span>**Assunto 05**
      1. Descrição do conteúdo.
      2. **Exemplo do assunto 05**.
         1. Descrição do exemplo

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   5. <span id=id_assunto06></span>**Assunto 06**
      1. Descrição do conteúdo.
      2. **Exemplo do assunto 06**.
         1. Descrição do exemplo

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   6. <span id=id_assunto07></span>**Assunto 07**
      1. Descrição do conteúdo.
      2. **Exemplo do assunto 07**.
         1. Descrição do exemplo

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   7.  <span id=id_assunto08></span>**Assunto 08**
      1. Descrição do conteúdo.
      2. **Exemplo do assunto 08**.
         1. Descrição do exemplo

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   8.  <span id=id_assunto09></span>**Assunto 09**
      1. Descrição do conteúdo.
      2. **Exemplo do assunto 09**.
         1. Descrição do exemplo

            ```ts
            ```

      3. **Referências:**
         1. [title](link)
         2. [title](link)

      4. <text onclick="goBack()">[🔙]</text>

   9.  <span id=id_assunto10></span>**Assunto 10**
         1. Descrição do conteúdo.
         2. **Exemplo do assunto 10**.
            1. Descrição do exemplo

               ```ts
               ```

         3. **Referências:**
            1. [title](link)
            2. [title](link)

         4. <text onclick="goBack()">[🔙]</text>

   10. <text onclick="goBack()">[🔙]</text> -->
<!-- markdownlint-disable-next-line -->
1. <span id=id_referencias></span>**REFERÊNCIAS GLOBAIS**
   1. [xrdp.org](https://www.xrdp.org/))
   2. [github xrdp](https://github.com/neutrinolabs/xrdp)
   3. [Como ativar o protocolo de área de trabalho remota usando xrdp no Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-enable-remote-desktop-protocol-using-xrdp-on-ubuntu-22-04)

<!-- markdownlint-disable-next-line -->
1. <span id="id_historico"><span>**HISTÓRICO**

   1. 16/12/2023 <!--TODO: HISTÓRICO -->
      - [x] Criar este documento baseado no modelo03.md ;
      - [x] Escrever tópico Objetivos;
      - [x] Escrever tópico Pre-requisitos para usar xrdp
      - [x] Escrever tópico Benefícios do servidor de terminais xrdp
      - [x] Escrever tópico desvantagens
      - [x] Escrever tópico Conteúdo
      <!-- - [ ] Escrever tópico Exemplos -->
      - [x] Escrever tópico Referências
      - [x] Atualizar o histórico deste documento.
      - [ ] Testar este documento depois após uma semana de concluído.

      - <text onclick="goBack()">[🔙]</text>

</main>

[🔝🔝](#topo "Retorna ao topo")
