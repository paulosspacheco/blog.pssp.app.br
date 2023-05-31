#!/bin/bash
# Usando o comando return na função
function valor {
 read -p "Digite um número entre 0 e 255: " num
 return $[ $num ]
}

valor
echo "O valor do status retornado é $?"