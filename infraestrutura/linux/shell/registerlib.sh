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
