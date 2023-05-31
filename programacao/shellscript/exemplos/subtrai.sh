#!/bin/sh
# script subtrai.sh

# função subtrai
subtrai(){
    param1=$1
    param2=$2
    echo parâmetro 01 = $param1
    echo parâmetro 02 = $param2

    echo $param1
    echo $param2
    result=`expr $param1 - $param2`
    return $result
}

# parte principal do programa 
subtrai 5 2
result="$?"
# A sequencia $? contém o valor de return.
echo "O valor retorna da expressão subtrai 5 2 = $result"