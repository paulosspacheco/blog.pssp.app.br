<!-- markdownlint-disable-next-line -->
<span id="topo"><span>
<!-- markdownlint-disable-next-line -->
### Configurando as exportações NFS no servidor host<a href="configurando_exportacoes_nfs_servidor_host.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Com editor de sua preferência, edite o arquivo _/etc/exports_ para adicionar um novo compartilhamento para a pasta _/var/nfs/share_:

   ```sh
      
      # Usando o editor xed 
      sudo xed /etc/exports
      

   ```

2. Adicione no fim do arquivo _/etc/exports_ as seguintes linhas:
  
    ```sh
        
      # Sintaxe das linhas no arquivo /etc/exports: 
      # patas_a_ser_compartilhada ip_cliente(share_option1,...,share_optionN)     

      /var/nfs/share 192.168.15.0(rw,sync,no_subtree_check)
      /home          192.168.15.0(rw,sync,no_root_squash,no_subtree_check)
        

    ```

3. Observe que nas linhas acimas adicionadas ao arquivo _/etc/exports_ está usando as mesmas opções de configuração para ambos os diretórios (_/home_ e _/var/nfs/share_), exceto a o parâmetro _no_root_squash_.
   1. Significados dos parâmetros após os IPs:
      1. _rw_: essa opção fornece ao computador do cliente tanto o acesso à leitura quanto gravação no volume.
      2. _sync_: essa opção obriga o NFS a gravar alterações no disco antes de responder. Isso resulta em um ambiente mais estável e consistente, uma vez que a resposta reflete o estado real do volume remoto. No entanto, isso também reduz a velocidade das operações de arquivos.
      3. _no_subtree_check_: essa opção impede a verificação de subárvore, que é um processo onde o host deve verificar se o arquivo está de fato disponível na árvore exportada para cada pedido. Isso pode causar muitos problemas quando um arquivo é renomeado enquanto o cliente tem ele aberto. Em quase todos os casos, é melhor desativar a verificação de subárvore.
      4. _no_root_squash_: por padrão, o NFS traduz as solicitações de um usuário root remotamente como um usuário sem privilégios no servidor. Isso foi usado como medida de segurança para evitar que uma conta root no cliente utilize o sistema de arquivos do host como root. A opção _no_root_squash_ desativa esse comportamento para certos compartilhamentos.

4. Após salvar as alterações do arquivo _/etc/exports_ reinicie o servidor nfs para que os compartilhamentos fiquem disponíveis para os clientes:

    ```sh
        
       sudo systemctl restart nfs-kernel-server       

    ```

5. Próximo passo:
   1. [Montando pasta compartilhada no servidor na máquina cliente](./montando_pasta_compartilhada_do_servidor_no_cliente.html);

##### REFERÊNCIAS

1. [Como configurar uma montagem NFS no Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04-pt)
