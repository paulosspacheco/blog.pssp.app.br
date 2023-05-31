#!/bin/sh
# script soma.sh

# função soma
soma(){
  param1=$1
  param2=$2
  echo parâmetro 01 = $param1
  echo parâmetro 02 = $param2

  echo $param1
  echo $param2
  result=`expr $param1 + $param2`

  exit $result # aborta o script e retorna o resuldo para quem chamou.
}

# parte principal do programa 
soma 1 2
# A sequencia $? contém o valor de exit mais nunca imprimira 
# esta linha porque o comando exist aborta o script.
echo "O valor retorna da expressão soma 1 2 = $?"
