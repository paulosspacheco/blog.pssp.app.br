<!-- markdownlint-disable-next-line -->
#### Instalação do Serviço NFS

1. Para instalar o servidor NFS instale o pacote _nfs-kernel-server_.

   ```sh

      sudo apt update

      # Este app deve ser instalado na máquina que vai compartilhar os arquivos.
      sudo apt install nfs-kernel-server

   ```

2. Para instalar o cliente NFS na máquina cliente instale o pacote _nfs-common_.

   ```sh

      sudo apt update

      # Este app deve ser instalado na máquina cliente
      sudo apt install nfs-common

   ```

3. Próximo passo:
   1. [Criando os diretórios de compartilhamento no servidor host](./criando_diretorios_compartilhamento_host.html)
