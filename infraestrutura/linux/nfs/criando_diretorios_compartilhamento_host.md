<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

### Criando os diretórios de compartilhamento no servidor host<a href="criando_diretorios_compartilhamento_host.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Crie o diretório _/var/nfs/share_ no servidor para compartilhar com os clientes:
  
   ```sh

      # Criar a pasta compartilhada
      sudo mkdir -p /var/nfs/share

      # Cheque o direito de acesso da pasta compartilhada
      sudo ls -la /var/nfs/share

   ```

2. O comando abaixo o NFS traduzirá toda operação root no cliente para as credenciais _nobody:nogroup_ como uma medida de segurança. Portanto, precisamos alterar a posse do diretório para que corresponda a essas credenciais.

   ```sh

      sudo chown nobody:nogroup /var/nfs/share       

   ```

3. Alterando o modo de acesso da pasta share para que possa:
   1. Suponha que se queira que o dono da pasta /var/nfs/share e o grupo em que a pasta pertença, possa ler, grava e executa arquivos e outros usuários não possam ler, nem grava e nem executar, então execute os seguintes abaixo:

   ```sh

      # Dar acesso ao dono e ao grupo 
      sudo chmod -R ug+xrw /var/nfs/share  

      # Remove o acesso aos outros usuários
      sudo chmod -R o-xrw /var/nfs/share       

   ```

4. Checando o modo de acesso da pasta _/var/nfs/share_ com o comando _[ls](https://man7.org/linux/man-pages/man1/ls.1.html)_:

   ```sh

      sudo ls -l /var/nfs/share 

   ```

5. Próximo passo:
   1. [Configurando as exportações NFS no servidor host](./configurando_exportacoes_nfs_servidor_host.html);
