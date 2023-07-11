<!-- markdownlint-disable-next-line -->
#### Como registrar biblioteca compartilhada no Linux para que o Lazarus reconheça. <a href="register_lib_so.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba.">  ➚ </a>

1. As bibliotecas normalmente são instaladas usando o gerenciador de pacotes de sua distribuição, porém as biblioteca que criamos ainda não tem um gerenciador de pacotes e por isso é necessário registra-las no Linux na pasta _/usr/lib_ para que o _IDE Lazarus_ reconheça em seus projetos.
2. Além de está na pasta _/usr/lib_, precisa também que o modo de acesso seja alterado da seguinte forma:

   ```sh

      # O dono, o grupo e outros usuários da LibName podem executar, gravar e ler
      sudo chmod ugo+xwr LibName

      # O grupo e outros usuários da LibName não podem gravar
      sudo chmod go-w LibName

   ```

3. Para copiar a _LibName_ para a pasta _/usr/lib_ é necessário ter direitos de usuário _root_.

   1. **EXEMPLO**:
      1. Suponha que ser queira registrar a biblioteca _~/exemplos/libwebview.so_ da pasta _~/exemplos_:

         ```sh

            # Move-se para pasta onde a lib está 
            cd ~/exemplos

            # copia a biblioteca para a pasta /usr/lib
            sudo cp ./libwebview.so /usr/lib

            # Altera o modo de acesso da lib /usr/lib/libwebview.so.
               # O dono, o grupo e outros usuários da LibName podem executar, gravar e ler
               sudo chmod ugo+xwr /usr/lib/libwebview.so

               # O grupo e outros usuários da LibName não podem gravar
               sudo chmod go-w /usr/lib/libwebview.so

           
         ```

4. Programa para registro automático de uma biblioteca:
   1. O programa [registerlib.sh](./registerlib.sh) recebe o _path/namelib.so_ a ser registrada:

      ```bash
        
         #!/bin/bash
         # Registro de biblioteca no Linux.
         # Exemplo de uso: 
            # $ ./registerlib.sh lib.so

         # Variáveis globais
         result_copyToUsrLib=""

         # Função copia para a pasta /usr/lib
         copyToUsrLib() {
            # testa se o arquivo existe.
            if [ -f "/usr/lib/$LibName" ]; then
               read -p 'Arquivo /usr/lib/$LibName já existe. Apaga o arquivo /usr/lib/$LibName ? s/n ' result_copyToUsrLib
            else
               result_copyToUsrLib="s"
            fi

            # Se $result_copyToUsrLib for diferente de s então retorna um 1 indicando um erro
            if [ $result_copyToUsrLib != "s" ]; then
               return 1 #=false
            fi

            # copia a biblioteca para a pasta /usr/lib
            sudo cp -p "$LibName" /usr/lib

            # Se não houver erro então altera o modo de acesso da lib /usr/lib/libwebview.so.
            if [ $? -eq 0 ]; then
               # O dono, o grupo e outros usuários da LibName podem executar, gravar e ler
               sudo chmod ugo+xwr "/usr/lib/$LibName"

               # O grupo e outros usuários da LibName não podem gravar
               sudo chmod go-w "/usr/lib/$LibName"

               echo "Trocado modo de acesso do arquivo /usr/lib/$LibName"
            fi
         }

         # main
         LibName="$1"

         echo " Lib a ser registrada: $LibName"

         # Se a lib passado por "$1" não for informada então sai com erro 1 
         if [ -z $LibName ]; then
            echo "O parâmetro deve ser o nome completo da biblioteca a ser registrada!"
            echo "Exemplo: /registrlib.sh ./lib.so "
            exit 1
         fi

         # Se a lib passado por "$1" existir então faz a cópia
         if [ -f "$LibName" ]; then
            echo Registrando arquivo "$LibName"
            copyToUsrLib
         else
            echo o arquivo "$LibName não existe."
            result_copyToUsrLib="n"
         fi

         # Retorna 0 se a lib foi registrada e 1 se fracasso;
         if [ $result_copyToUsrLib == "s" ]; then
            echo "A lib $LibName foi registrada"    
            exit 0 
         else
            echo "A lib $LibName não foi registrada"
            exit 1 
         fi
         
      ```

5. **Referências**
   1. [Bibliotecas compartilhadas](https://packaging.ubuntu.com/pt-br/html/libraries.html#:~:text=Bibliotecas%20compartilhadas%20s%C3%A3o%20c%C3%B3digos%20compilados,de%20fun%C3%A7%C3%B5es%2C%20classes%20e%20vari%C3%A1veis.)
   2. [Debian Library Packaging guide](https://www.netfort.gr.jp/~dancer/column/libpkg-guide/libpkg-guide.html)
