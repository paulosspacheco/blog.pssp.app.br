         #!/bin/bash
         # Program bkp.sh
         # Exemplo de uso
         #  $ ./bkp.sh /Documentos /tmp
       
         origem="$1"
         destino="$2"

         echo "Atualiza o diretório $destino com os arquivos diferentes da "
         echo "pasta $origem criado depois da ultima cópia."
         echo "Cópia incremental".               
         sudo cp -upvR $origem $destino

        result_cp="$?"
        if [ $result_cp != 0 ]; then
          echo "algo errado na cópia"
          exit 1;
        fi