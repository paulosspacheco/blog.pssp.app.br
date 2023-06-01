<!-- markdownlint-disable-next-line -->
#### <span id="topo"><span>Montando pastas compartilhadas ao iniciar o computador<a href="montando_pastas_ao_iniciar_o_computador.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

1. **Existe três tipos de montagem diferentes quais sejam:**
    1. [_mount_](https://linux.die.net/man/8/mount) – Comando usado para monta um sistema de arquivos.
    2. _/etc/fstab_ – Colocar o ponto de montagem para montar automaticamente ao inicializar o sistema.
    3. _SystemD_ – O queridinho, colocar o ponto de montagem para montar automaticamente ao inicializar o sistema de forma elegante.

2. **Comando [_Mount_](https://linux.die.net/man/8/mount)**
   1. Se você está em uma rede com domínio e deseja realizar o mapeamento de uma pasta compartilhada de uma máquina ou servidor da rede, é possível realizar tal façanha utilizando o comando _mount_ da seguinte forma:

      ```bash

         # mount -t cifs <ORIGEM> <DESTINO> -o user=<USUARIO>,password=<SENHA>,domain=<DOMINIO>
         mount -t cifs //192.168.15.3/publico /mnt/backup/ -o user=paulosspacheco,password=1234,domain=itms

      ```

   2. Notas:
      1. _mount_: Comando utilizado para realizar montagens no Linux.
      2. _-t_: Tipo de montagem. No nosso exemplo para acessar as pastas compartilhadas no Windows, utilizamos o tipo cifs.
      3. _origem_: O caminho de origem do compartilhamento de rede. Ex: //maquina01/publico ou //192.168.50.3/publico.
      4. _destino_: O ponto de montagem onde será montado o compartilhamento Ex: /mnt/backup.
      5. _-o_: Parâmetro utilizado para passar outras opções ao comando mount como por exemplo:
         1. _user_: Nome do usuário do domínio que tem permissão de leitura e gravação na pasta de origem compartilhada.
         2. _password_: Senha do usuário informado.
         3. _domain_: Nome do Domínio em que a máquina de origem esta inserida.
3. ,
