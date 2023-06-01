<!-- markdownlint-disable-next-line -->
#### Pre-requisitos para instalar o serviço NFS

1. Linux Debian ou distribuições derivadas.
2. Para servidores que suportam conexões NFSv2 ou NFSv3, o serviço rpcbind deve estar em execução. Para verificar se rpcbind está ativo, use o seguinte comando:

    ```sh
       # Checa o status do serviço 
       systemctl status rpcbind

    ```

3. Caso a máquina que está no servidor esteja por traz de um firewall atente-se para configurar a porta do serviço NFS.
