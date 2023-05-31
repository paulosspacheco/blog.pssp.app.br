#### Configurando um servidor local de Git no Debian ou seus derivados <a href="configurando_um_servidor_local_de_git.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

### **Como funciona**

Antes de instalarmos e configurarmos o Git, precisamos entender onde aplica-se seu uso.

Basicamente, na maioria dos casos, o Git roda em um servidor que pode ser na rede local ou na Web. Nesse server mantemos um repositório central, o que vamos chamar de Git Server.
Localmente, na sua estação de trabalho, por exemplo, é mantido um repositório local, ou seja, um clone do repo central. Nos arquivos dentro desse repo local você realiza suas modificações e, ao concluí-las, as envia para o git server. Aquilo que modificou e seus comentários sobre suas mudanças são armazenados para consulta posterior.

Caso outras pessoas possuam um clone desse repo, bastará rodar o comando `git pull` para obter as mudanças que você realizou e que já estarão armazenadas no git server.

Inclusive, recomendo rodar `git pull` antes de enviar modificações para o git server.

Na imagem abaixo podemos ver um exemplo de um time que pode ser de desenvolvimento. Todos trabalham com um repositório local e enviam e recebem mudanças de um repositório central: ![Imagem de vários repositórios e o servidor](images/image01.jpg "Esta imagem mostra de forma visual como funciona as cópias dos arquivos.")

**Configurações feitas no servidor:**

1. Agora é preciso criar o usuário que utilizaremos para acessar o repositório do Git.

    ```sh

       sudo useradd git -s -d /home/git

    ```

2. Agora criaremos o diretório home do usuário ‘git’ (/home/git) e nele o path onde armazenaremos o repositório do nosso primeiro repo que se chamará ‘lab’:

    ```sh

       sudo mkdir -p /home/git/repos/lab.git

    ```

3. Agora ajustaremos o owner:group dos diretórios que criamos:

    ```sh

       sudo chown -R git:git /home/git

    ```

4. Vamos usar o usuário ‘git’ para configurar o repo. Assim não precisaremos ajustar owner:group novamente:

    ```sh

        sudo git -l

    ```

5. Agora entre no path onde manteremos a estrutura do repo:

    ```sh
        cd repos/lab.git
    ```

6. Por fim, vamos iniciar um repo aqui. Para isso, utilizaremos o comando abaixo:

    ```sh
        sudo git --bare init
    ```

7. Fecha a conexão do usuário “git” e faça o login como usuário “root”.

8. Daqui para frente pouco utilizará o usuário “git”. Portanto, vamos aumentar a segurança do user trocando seu shell default.
   1. Altere o shell do usuário “git” para deixar seu repo mais seguro:

      ```sh
    
         sudo usermod -s /usr/bin/git-shell
    
      ```

   2. Com isso, ao tentarmos logar com o usuário “git”, receberá a mensagem abaixo:

    ```sh
        sudo su git -l
    
        fatal: Interactive git shell is not enabled.
        hint: ~/git-shell-commands should exist and have read and execute access.
    ```

## REFERÊNCIAS

1. [Configurando-um-servidor-de-git-no-debian](https://www.blogporta80.com.br/2015/09/24/artigos-configurando-um-servidor-de-git-no-debian/)
