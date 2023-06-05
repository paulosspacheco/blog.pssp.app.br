#!/bin/bash
# Este comando executa duas ações condicionalmente, onde a segundo só é executada se a primeira foi bem sucedida.
# %1 recebe ação 1
# %2 recebe o tempo em que deve esperar para executar a ção 2.
# %3 recebe a ação 2 e só é executado se a ção 1 for bem sucedida.

echo "Executando o parâmetro 1 = $1"
echo "--------------------------------------------------------------"

$1 & # executa parametro e não espera.  

echo "Executando o parâmetro 2 = $2"
echo "--------------------------------------------------------------"

echo "Aguardando $2 segundos esperando a execução do parâmetro $1.."
echo "--------------------------------------------------------------"

sleep "$2" # aguarda o tempo informado no parametro 2
echo "--------------------------------------------------------------"

echo "Executando o parâmetro 3 = $3"
echo "--------------------------------------------------------------"

$3 #> /dev/null # excuta o terceiro parâmentro

st=$?

#Se houver erro na execução do primeiro parâmetro então executa do terceiro parâmetro
while [ $st -ne 0 ]  
do
    echo "Loop while Status = $st"
    echo "--------------------------------------------------------------"
    sleep 5
    $3 #s> /dev/null  #excuta o terceiro parâmentro
    st=$?
done

echo "Fim do script"
echo "Status = $st"
echo "--------------------------------------------------------------"

exit $st # retorna o numero do erro

