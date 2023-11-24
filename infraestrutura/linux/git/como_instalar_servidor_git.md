<!-- markdownlint-disable-next-line -->
<nav><div class="topnav" id="myTopnav"><div w3-include-html="/menu.inc"></div></div></nav>   

<!-- markdownlint-disable-next-line -->
#### COMO INSTALAR E CONFIGURAR UM SERVIDOR GIT REMOTO <a href="como_instalar_servidor_git.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." > ➚ </a>

- [COMO INSTALAR E CONFIGURAR UM SERVIDOR GIT REMOTO  ➚ ](#como-instalar-e-configurar-um-servidor-git-remoto---)
  - [INTRODUÇÃO](#introdução)
  - [INSTALANDO SERVIDOR _GIT_ E SERVIDOR _SSH_ NO DEBIAN OU DERIVADOS](#instalando-servidor-git-e-servidor-ssh-no-debian-ou-derivados)
  - [CONFIGURAÇÕES DO REPOSITÓRIO NO SERVIDOR](#configurações-do-repositório-no-servidor)
  - [COMO USAR O REPOSITÓRIO DO SERVIDOR NA MÁQUINA CLIENTE](#como-usar-o-repositório-do-servidor-na-máquina-cliente)

---
---

##### INTRODUÇÃO

1. **Objetivo:**

   1. O _git_ é um projeto criado por , [_Linus Torvalds_](https://pt.wikipedia.org/wiki/Linus_Torvalds) cujo objetivo é criar um repositório de arquivos que possa ser mantido por várias pessoas. O _git_ pode reproduzir várias versões de um projeto onde uma versão anterior possa ser gerada a qualquer momento caso seja necessário.

   2. Basicamente, na maioria dos casos, o _Git_ roda em um servidor que pode ser na _rede local_ ou na _Web_. Nesse servidor mantemos um _repositório central_, o que vamos chamar de _Servidor Git_. Localmente, na sua estação de trabalho, por exemplo, é mantido um _repositório local_, ou seja, um _clone do repositório do Servidor Git_.

   3. Nos arquivos dentro desse _repositório local_ você realiza suas modificações e, ao concluí-las, as envia para o _servidor git_. Aquilo que modificou e seus comentários sobre suas mudanças são armazenados para consulta posterior.

   4. Caso outras pessoas possuam um clone desse repositório, bastará rodar o comando _git pull_ para obter as mudanças que você realizou e que já estarão armazenadas no _servidor git_.
      - **Nota**: Executar _git pull_ antes de enviar modificações para o _servidor git_.

   5. Na imagem abaixo podemos ver um exemplo de um time que pode ser de desenvolvimento, onde todos trabalham em um repositório local e enviam e recebem mudanças do  repositório central (_servidor git_):
      - ![Imagem de vários repositórios e o servidor](images/image01.jpg "Esta imagem mostra de forma visual como funciona as cópias dos arquivos.")

2. **Pre-requisitos**
   1. Conhecimento básico de como se opera um terminal no sistema operacional Linux Debian ou derivados;
   2. Conhecimento básico do projeto [_Servidor OpenSSH_](https://ubuntu.com/server/docs/service-openssh) para entendimento de como funciona as _chaves ssh_ necessárias para que o servidor acesse a máquina local cliente sem necessidade de pedir senha a cada atualização.
   3. Uma máquina linux com Debian ou derivados para instalar o servidor git;
   4. Uma máquina linux para testar o repositório criado no servidor git.

---

##### INSTALANDO SERVIDOR _GIT_ E SERVIDOR _SSH_ NO DEBIAN OU DERIVADOS

1. Comandos para instalar aplicativo _git_:

   ```bash

      # Atualiza sistema lista do apt-get
      sudo apt-get update

      # Instala o git
      sudo apt-get install git-all
      
      # Trocar o nome padrão do branch para main
      # Ao instalar o git o branch padrão é master, porém o github usa main,
      # por isso meus scripts de clientes estão main e o meu servidor git deve acompanhar.
      git config --global init.defaultBranch main
     
   ```

2. Comandos para instalar aplicativo _openssh-server_:

   ```bash
      # Instalando o servidor ssh para que o usuário git client possa acessar 
      # o servidor sem pedir senha 
      apt-get install openssh-server

   ```

   - **Notas**:
     - Editar o arquivo  _/etc/ssh/sshd_config_ com direitos de root e informe a porta que o servidor _ssh_ deve escultar.

       ```bash

         # Obs: A porta 22 esta comentada, remova o comentário e informa porta que desejar.         
         sudo xed  /etc/ssh/sshd_config

       ```

---

##### CONFIGURAÇÕES DO REPOSITÓRIO NO SERVIDOR

1. **Criar um _usuário git_ no servidor que será o proprietário dos repositórios a serem compartilhados com os clientes. Na prática, poderia ser qualquer usuário, mas para não ter que criar um usuário, no servidor, para cada cliente, é interessante usar o _usuário git_. Para criar esse usuário utilizamos o comando _useradd_:.**

   ```bash

      sudo useradd --comment "Git user" --home-dir /home/git --groups users --shell $(which git-shell) git


   ```

   - **Notas:**
     1. Nesse exemplo o grupo do nosso _usuário git_ é _users_. Esse grupo é o grupo padrão para a distribuição Debian. Caso seu servidor seja de outra distribuição coloque o respectivo grupo. Caso não saiba qual é esse grupo, verifique o do seu usuário e utilize-o.
     2. Nesse exemplo a opção _--shell_ sendo atribuída ao utilitário _git-shell_. Fazemos isso para proibir o usuário git de se logar no nosso servidor. Ele somente consegue executar operações do programa _git_. Nada além disso. Isso garante que mesmo que um _hacker roube a senha_ desse usuário ele jamais ganharia um _shell no servidor_.

2. **Após criar o usuário, deve-se criar a pasta _home_ dele, em seguida alterar o dono e grupo da pasta _/home/git_ .**

   ```bash

      # Cria a pasta inicial para o usuário git
      sudo mkdir -p /home/git

      # Conceda permissões de diretório ao usuário git
      sudo chown -R git:users /home/git

   ```

3. **Criar uma senha para o _usuário git_. Para isso iremos utilizar o _comando passwd_. Esse comando irá lhe pedir via prompt de comandos a nova senha:**

   ```bash

      # Definir senha do usuário git
      sudo passwd git

   ```

4. [**Configurar nome e e-mail do _usuário git_ globalmente**](https://git-scm.com/book/pt-br/v2/Come%C3%A7ando-Configura%C3%A7%C3%A3o-Inicial-do-Git):

   ```bash

      #  Definindo nome do usuário
      git config --global user.name "paulosspacheco"

      #  Definindo e-mail do usuário
      git config --global user.email "paulosspacheco@yahoo.com.br"

   ```

   - **Nota**
     - Se em algum momento desejar alterar as informações para um projeto específico, basta reescrever os comandos sem a opção _--global_ dentro da pasta do projeto.

5. **Configurando o protocolo ssh:**

   1. Quando a máquina cliente executa o comando _git clone hrl_do_repositório_, o _git_ está utilizando o protocolo _ssh_ para clonar o repositório remoto.
      - **Nota**: O protocolo HTTP também pode ser utilizado, mas não necessariamente essa comunicação estaria criptografada, autenticada e autorizada.
      - [Dica: Instalando e configurando servidor SSH (Ubuntu)](<https://www.vivaolinux.com.br/dica/Instalando-e-configurando-servidor-SSH-(Ubuntu)>);

   2. Para configurar o _ssh_ do servidor, é necessário editar o arquivo _/etc/ssh/sshd_config_ e adicionar a linha com a diretiva _AllowUsers_ se não existir. No final da linha _AllowUsers_, adicione o nome do _usuário root_ e _usuário git_. Siga os passos abaixo para fazer as alterações:
      1. Editar arquivo _/etc/ssh/sshd_config_:

         ```bash

            # Obs: Uso o editor xed , porém você pode usar que está disponível no momento. 
            sudo xed /etc/ssh/sshd_config

         ```

      2. Exemplo de como deve ficar a linha _AllowUsers_ do arquivo _/etc/ssh/sshd_config_:

         ```bash

            # Authentication:
            #   LoginGraceTime 2m
            #   PermitRootLogin yes
            #   StrictModes yes
            #   MaxAuthTries 6
            #   MaxSessions 10
            AllowUsers root git

         ```

      3. Após gravar a alteração do arquivo _/etc/ssh/sshd_config_ com a adição do _usuário git_ e _usuário root_, deve-se reiniciar o serviço no sistema operacional para que as modificações tenham efeito.

         ```bash

            # System D
            sudo systemctl restart sshd.service

            # ou

            #  Service
            sudo service sshd restart

         ```

         - Dica: O processo _sshd_ é um _daemon_ em nosso servidor com a responsabilidade de receber as conexões vindas das máquinas clientes e garantir que estejam devidamente autorizadas ao logar no servidor.

   3. Para acessar o repositório sem necessidade de digitar senha a todo momento é necessário seguir os seguintes passos:

      1. Na _máquina servidora git_, seguir os passos abaixo, para que a máquina cliente não precise digitar senha para acessar o servidor:

         1. Criar a pasta _ssh_ para o _usuário git_:

            ```bash

               sudo mkdir -p /home/git/.ssh/

            ```

         2. Alterar o _nome do usuário_ e do _grupo_ para _git:users_ na pasta invisível _./ssh_:

            ```bash

               sudo chown -R git:users /home/git/.ssh

            ```

         3. Altere as permissões da pasta _/home/git/.ssh_ para que somente o _usuário git_ possa ler, gravar e executar na pasta:

            ```bash

               sudo chmod 700 /home/git/.ssh

            ```

         4. Cria o arquivo _authorized_keys_ na pasta _/home/git/.ssh_ para cadastrar todas as chaves púbicas das máquinas clientes com acesso aos repositórios:

            ```bash

               sudo touch /home/git/.ssh/authorized_keys

            ```

         5. Altera o _nome do usuário_ e do _grupo_ para _git:users_ do arquivo _authorized_keys_ da pasta _/home/git/.ssh_:

            ```bash

               sudo chown -R git:users /home/git/.ssh/authorized_keys

            ```

         6. Altere as permissões do arquivo _/home/git/.ssh/authorized_keys_ para que somente o _usuário git_ possa ler e gravar no arquivo:

            ```bash

               sudo chmod 600 /home/git/.ssh/authorized_keys

            ```

         7. **Notas:**

            1. Além de criarmos a pasta _.ssh_ e o arquivo _authorized_keys_, demos as devidas permissões a eles.
            2. Para saber os parâmetros de autenticação do _git_ execute o comando abaixo:

               ```bash

                  # Pega os parâmetro de acesso ao git
                  git config --list

                  # Resposta do comando acima:
                  > user.name=paulosspacheco
                  > user.email=paulosspacheco@yahoo.com.br
                  > core.autocrlf=input
                  > core.safecrlf=warn


               ```

      2. <!-- markdownlint-disable-next-line -->
         <span id='id_ssh_client'></span> Em cada _[máquina cliente](./como_instalar_cliente_git_no_linux.html)_ que for acessar o servidor, executar os passos abaixo:

         1. Executar o programa _ssh-keygen_ para criar um par de chaves (privada e pública ) para poder enviar para o servidor a chave pública gerada.

            ```bash
                
               # Move-se para a pasta invisível ~/.ssh 
               cd ~/.ssh

               # O comando ssh-keygen criar o par de chave de 4096 bits cujo protocolo é rsa
               ssh-keygen -t rsa -b 4096 -C "your_email@yahoo.com.br"
               # Em seguida, você vai ser solicitado a Inserir arquivo no qual salvar a chave.
               # Você pode especificar um local de arquivo ou pressionar “Enter” para aceitar o local padrão do arquivo.

               > Enter a file in which to save the key (/.ssh/id_rsa): [Press enter]

               # O próximo prompt vai solicitar uma frase secreta.
               # A frase secreta vai adicionar uma camada adicional de segurança ao SSH e vai ser necessária sempre
               # que a chave SSH for usada. Se alguém obtiver acesso ao computador em que as chaves privadas estão armazenadas,
               # também vai poder obter acesso a qualquer sistema que use essa chave. Adicionar uma frase secreta às
               # chaves vai evitar esse cenário.

               > Enter passphrase (empty for no passphrase): [Type a passphrase]
               > Enter same passphrase again: [Type passphrase again]

               # Pronto: Nesse ponto, vai ser gerada nova chave SSH no caminho do arquivo especificado mais atrás.

            ```

            - **Notas:**
              - Esse comando vai criar novo par de chaves _SSH_ usando o _e-mail_ como categoria.
              - O comando _ssh-keygen_ sugere que vai criar a chave _id_rsa_ na pasta _~/.ssh_, porém salva o arquivo na pasta corrente. Passei um tempão para entender.

         2. Executar o programa [_ssh-add_](https://linux.die.net/man/1/ssh-add) para adicionar as chaves geradas pelo programa _ssh-keygen_ em uma lista de chaves privadas. Além de manter chaves privadas, ele também controla solicitações _SSH_ para que elas sejam transmitidas com segurança.

            1. Antes de adicionar a nova chave _SSH_ ao _ssh-agent_, primeiro verifique se o _ssh-agent_ está sendo executado ao executar o comando abaixo:

               ```bash

                  eval "$(ssh-agent -s)"
                  > Agent pid 19895


               ```

               - **Nota**
                 - Se a resposta for _> Agent pid x_ onde x é o número do processo, é porque está tudo ok.

            2. [_ssh-add_](https://linux.die.net/man/1/ssh-add) - Adiciona identidades de chave privada ao agente de autenticação _OpenSSH_

               ```bash

                  # Mova-se para a pasta ~/.ssh              
                 cd ~/.ssh

                 # Adicionar a chave ./id_rsa ao ssh-agent
                 ssh-add ./id_rsa
                 > Enter passphrase for /home/paulosspacheco/.ssh/id_rsa:   # Obs: A senha é informada em ssh-keygen 
                 > Identity added: /home/paulosspacheco/.ssh/id_rsa (paulosspacheco@yahoo.com.br)

               ```

               - **Notas**

                 - A nova _chave SSH_ agora está registrada e pronta para uso.
                 - A primeira vez que o git usa a chave, o sistema informa que a chave está bloqueada e precisa ser desbloqueada com a senha informada no programa _ssh-keygen_, ao criar a chave.
                   - No _linux mint_ é executado um diálogo no modo gráfico com dois campos, sendo 1 para a _senha_ e o outro campo para o _flag_ que informa que a senha deve ser permanente.
                 - Entre as duas chaves geradas, uma privada e outra pública, a chave com a extensão _.pub_, deve ser enviada para o servidor e ser adicionada ao final do arquivo _/home/git/.ssh/authorized_keys_ do servidor.

      3. <!-- markdownlint-disable-next-line -->
         <span id='id_ssh_server'></span>  Após criar a chave na máquina _cliente git_ a mesma deve ser registrada no _servidor git_ executando os seguintes passos:

         1. Você deve enviar a chave para o servidor pelo meio que estiver configurado na máquina cliente, podendo ser por _e-mail_, _WhatsApp_, _Telegram_, _pasta compartilhada_ e etc...
            - Suponha que a chave _id_rsa.pub_ tenha sido salva na pasta _~/Downloads_ do servidor, então executar os seguintes comandos:

            ```bash

               # Se conecta como root    
               sudo -i

               # Adiciona a chave no final do arquivo /home/git/.ssh/authorized_keys
               cat /home/git/.ssh/authorized_keys /home/NomeSeuUsuário/Downloads/id_rsa.pub >> /home/git/.ssh/authorized_keys

               # Obs: Caso exista pelo menos uma chave o sistema emitirá a mensagem abaixo
               > cat: /home/git/.ssh/authorized_keys: os arquivos de entrada e de saída são os mesmos

            ```

            - **Notas**:
              - O comando acima ao adicionar a segunda chave, mostra um aviso informando que o arquivo de entrada e de saída são os mesmos, porém adiciona normalmente no final do arquivo a chave do arquivo _id_rsa.pub_.
              - O processo acima também pode ser executado com qualquer editor de texto.

6. **Antes de publicar o repositório para os clientes é necessário cria-lo usando a opção --bare do git**:
   1. O nome do repositório depende da necessidade de cada projeto, por exemplo: O _github_, usa uma conta de usuário e dentro de cada conta, usa o nome do repositório; porém este documento foi projetado pensando em apenas um usuário de nome git, por isso os comandos abaixo são para criar o repositório _test.git_ dentro da pasta do _usuário git_:

      ```bash
         
         # Crie a pasta test.git
         sudo mkdir /home/git/test.git

         # Mova-se para  a pasta test.git 
         cd /home/git/test.git

         # Inicializar repositório simples
         sudo git init --bare

         # Trocar o nome do usuário e do grupo dono da pasta
         sudo chown -R git:users /home/git/test.git

      ```

      - **Notas:**
        - Url para o repositório _test.git_:
          - nome: origin
          - url: git@192.168.15.3:/home/git/test.git

7. **Como saber o link que o _cliente git_ deve usar para clonar o repositório do _servidor git_?**
   1. Cada projeto tem sua estrutura de arvore dentro do servidor git, por exemplo, o _github_ usa a seguinte sintaxe:_git@github.com:Usuário/NomeDoRepositório.git_

      ```bash

          # Exemplo de repositório do github           
          git@github.com:paulosspacheco/blog.pssp.app.br.git

      ```

   2. Os exemplos deste documento usa a seguinte sintaxe: _git@ip_server:/home/git/repositório.git_:

      ```bash
          # Exemplo repositório na rede local: ip=192.168.15.3
          git@192.168.15.3:/home/git/test.git
          
      ```

8. **Depois de executar todas as tarefas acima a URL _git@192.168.15.3:/home/git/test.git_ pode ser publicada para os clientes.**

---
---

##### COMO USAR O REPOSITÓRIO DO SERVIDOR NA MÁQUINA CLIENTE

1. **O que o _cliente git_ deve fazer para clonar o repositório _git@192.168.15.3:/home/git/test.git_**
   1. [_instalar o git na máquina cliente_](./como_instalar_cliente_git_no_linux.html);

   2. Criar uma _chave ssh_ privada para que o servidor git permita enviar arquivos sem necessidade de senhas.
      - Esses passos foi descrito no tópico [5.3.2](#id_ssh_client) deste documento.

   3. A _chave ssh_ tem duas partes, sendo um arquivo com a _chave privada_ e um arquivo com a _chave pública_. É necessário registrar no servidor a chave pública da máquina cliente para que o servidor saiba que as solicitações do cliente é segura.
      - Esses passos foi descrito no tópico [5.3.3](#id_ssh_server) deste documento

   4. Clonar o repositório _git@192.168.15.3:/home/git/test.git_ na máquina cliente:

      ```bash

         # Clonar o repositório test
         git clone git@192.168.15.3:/home/git/test.git
      
      ```

      - **Notas**:
        - O comando acima irá criar uma pasta na máquina cliente com todos os dados do repositório no servidor;

2. **O que o _cliente git_ deve fazer antes de editar os arquivos do repositório local?**

   ```bash
      # Atualiza o repositório local com os dados do repositório remoto      
      git pull 

   ```

   - O comando acima não deve ser automático, executando antes do comando _git push -u origin main_, porque a versão _main remota_ pode estar desatualizada.
   - O comando _git pull_ deve ser executado antes das alterações do repositório local.

3. **O que o _cliente git_ deve fazer após alterar os arquivos do repositório local para atualizar repositório remoto?**

   ```bash
      
      # Associa o repositório remoto ao repositório local.          
      git remote add origin git@192.168.15.3:/home/git/test.git 

      # Renomeie o branch  atual para main
      # O comando branch -M não precisa ser feito a todo momento, porque o git sempre envia para
      # o ultimo ramo selecionando.
      git branch -M main  

         # Este comando pode ser executado várias vezes antes de um commit.  
      git add .

      # Use o <msg> fornecido como a mensagem de confirmação. 
      git commit -a -m "Texto descrevendo as alterações realizadas"

      # Envia as alterações locais para o repositório remoto.
      git push -u origin main                  

      # imprime o status atual do repositório
      git status  
   
   ```

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); </script>
