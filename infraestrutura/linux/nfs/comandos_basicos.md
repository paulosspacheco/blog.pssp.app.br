<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Comandos básicos do dia a dia para manutenção do serviço NFS<a href="comandos_basicos.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. Reiniciar o serviço NFS _[nfs-kernel-server](https://manpages.debian.org/testing/nfs-kernel-server/mountd.8.en.html)_:

   ```sh

      # systemctl restart
      sudo systemctl restart nfs-kernel-server


   ```

2. Edição do arquivo  _[/etc/exports](https://linux.die.net/man/5/exports)_ para registrar as pastas a serem exportadas:

   ```sh

      sudo xed /etc/exports

   ```

3. Comando _[mount](https://linux.die.net/man/8/mount/)_ para montar as pastas compartilhas do servidor no cliente:

   ```sh

     # Monta o compartilhamento do servidor na pasta do cliente
     sudo mount IP_server_NFS:PastaCompartilhadaServidor PastaOndeSeraMontadaCliente
     # Exemplo: sudo mount 192.168.15.3:/var/nfs/share /home/paulosspacheco/v/share

 

   ```

4. O comando _[exportfs](https://linux.die.net/man/8/exportfs)_ o arquivo de configuração _[/etc/exports](https://linux.die.net/man/5/exports)_ será lido e o kernel atualizado com as mudanças realizadas.

   ```sh

      sudo exportfs

      
   ```

5. O comando _[blkid](https://linux.die.net/man/8/blkid)_ no Linux mostra que tipo de conteúdo um dispositivo de bloco (discos) contém e os seus atributos como nome do dispositivo, e outros metadados.

   ```sh

      sudo blkid


   ```

6. Alterando o modo de acesso da pasta share para que possa:
   1. Suponha que se queira que o dono da pasta /var/nfs/share e o grupo em que a pasta pertença, possa ler, grava e executa arquivos e outros usuários não possam ler, nem grava e nem executar, então execute os seguintes abaixo:

   ```sh

      # Dar acesso ao dono e ao grupo 
      sudo chmod -R ug+xrw /var/nfs/share  

      # Remove o acesso aos outros usuários
      sudo chmod -R o-xrw /var/nfs/share       

   ```

7. Checando o modo de acesso da pasta _/var/nfs/share_ com o comando _[ls](https://man7.org/linux/man-pages/man1/ls.1.html)_:

   ```sh

      sudo ls -l /var/nfs/share 

   ```

8. Crie o diretório _/var/nfs/share_ no servidor para compartilhar com os clientes:
  
   ```sh

      # Criar a pasta compartilhada
      sudo mkdir -p /var/nfs/share

      # Cheque o direito de acesso da pasta compartilhada
      sudo ls -la /var/nfs/share

   ```

9. O comando abaixo o NFS traduzirá toda operação root no cliente para as credenciais _nobody:nogroup_ como uma medida de segurança. Portanto, precisamos alterar a posse do diretório para que corresponda a essas credenciais.

   ```sh

      sudo chown nobody:nogroup /var/nfs/share       

   ```

## REFERÊNCIAS

1. [nfs-kernel-server](https://manpages.debian.org/testing/nfs-kernel-server/mountd.8.en.html)
2. [/etc/exports](https://linux.die.net/man/5/exports)
3. [mount](https://linux.die.net/man/8/mount/)
4. [exportfs](https://linux.die.net/man/8/exportfs)
5. [/etc/exports](https://linux.die.net/man/5/exports)

</main>

<!-- markdownlint-disable-next-line -->
<script>  includeHTML(); FixHeader(window,"myHeader"); </script>
[🔝🔝](#topo "Retorna ao topo")