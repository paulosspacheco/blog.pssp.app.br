<!-- markdownlint-disable-next-line -->
<span id="topo"><span>
<!-- markdownlint-disable-next-line -->
### Montando pasta compartilhada do servidor na máquina cliente<a href="montando_pasta_compartilhada_do_servidor_no_cliente.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Para acessar os compartilhamentos do _servidor nfs_ é necessário criar pasta na máquina cliente e usar o comando _mount_ da seguinte forma:.
   1. Criando pasta na máquina cliente:

       ```sh

         # Criar a pasta ~/LnxMint_Server_Share no cliente para compartilhada a pasta /var/nfs/share do servidor
         sudo mkdir -p ~/LnxMint_Server_Share

        # Criar a pasta ~/LnxMint_Server_home no cliente para compartilhada a pasta /home do servidor         
        sudo mkdir -p ~/LnxMint_Server_Home

       ```

   2. Montando as pastas compartilhadas do servidor nas pastas criadas acima:

       ```sh

          sudo mount host_ip:/var/nfs/share ~/LnxMint_Server_Share
          # Exemplo: sudo mount 192.168.15.3:/var/nfs/share ~/LnxMint_Server_Share

          sudo mount host_ip:/home ~/LnxMint_Server_Home
          # Exemplo: sudo mount 192.168.15.3:/home ~/LnxMint_Server_Home
       
       ```

##### NOTA

- _Se houver arquivos e diretórios em seu ponto de montagem, eles se tornarão ocultos e você pode perde-los_.

##### REFERÊNCIAS

1. [Passo 5 — Criando os pontos de montagem e montando diretórios no cliente.](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04-pt#passo-5-criando-os-pontos-de-montagem-e-montando-diretorios-no-cliente)