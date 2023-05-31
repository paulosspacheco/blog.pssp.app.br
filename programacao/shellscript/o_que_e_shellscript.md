# <span id="topo"><span>O que é linguagem shellscript<a href="modelo02.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. **Introdução**

      1. [Objetivo.](#id_objetivo)
      2. [Pre-requisitos.](#id_pre_requisitos)
      3. [benefícios.](#id_beneficios)

   2. [**Descrição.**](#id_Descricao)
      1. [Anotações](#id_anotacoes)
      2. [Functions](#id_functions)

   3. [**Exemplos.**](#id_exemplos)
      1. [Functions](#id_functions_example)

   4. [**Conteúdo01**](#id_instalar)

   5. [**Referências.**](#id_referencias)

   6. [**Histórico.**](#id_historico)

## **2. CONTEÚDO**

---

   1. **Introdução**

      1. <span id="id_objetivo"><span>**Objetivo:**
         1. ShellScript é a linguagem usada pelo linux para automatizar processos.

         2. <text onclick="goBack()">[🔙]</text>

      2. <span id="id_pre_requisitos"></span>**Pre-requisitos:**
         1. Uso de um shell Unix / Linux interativo;
         2. Conhecimento mínimo de programação - o uso de variáveis, funções, é um conhecimento básico útil;
         3. Compreensão de alguns comandos Unix / Linux e competência no uso de alguns dos mais comuns . ( ls , cp , echo , etc);
         4. Programadores de ruby , perl , python , C , Pascal ou qualquer linguagem de programação (mesmo BASIC) que podem ler scripts de shell, mas não sentem que entendem exatamente como funcionam..

         5. <text onclick="goBack()">[🔙]</text>

      3. <span id="id_beneficios"></span>**Benefícios:**
         1. Automatizar processos do sistema operacional linux.

         2. <text onclick="goBack()">[🔙]</text>

   2. <span id=id_Descricao></span>**Descrição**
      1. <scan id="id_anotacoes"></scan> Anotações de meus estudos
         1. As **passagem de parâmetros** e o **retorno das funções** em shellscript é totalmente diferente de todas as linguagens que conheço. Veja abaixo a [descrição de funções](#id_functions) e os [exemplos](#id_functions_example) para melhor compreensão.
         2. O comando **exit** também é diferente, ao invés de sair da função, ele aborta a função (igual a **halt** do pascal). Veja os exemplos abaixo.

         3. <text onclick="goBack()">[🔙]</text>

      2. <scan id="id_functions"></scan>As funções em shellscript tem a sintaxe [**numeDaFunção(){}**](https://www.shellscript.sh/functions.html) e podem retorna valor ou não da seguinte maneira:
         1. Use o comando **exit** para terminar o script e retorna ao script que o chamou  (igual ao halt do pascal);

         2. Use o comando **return** para encerrar a função e retornar o valor numérico (não aceita string) fornecido para a seção de chamada do script;
            1. **Obs:** Para capturar um retorno de uma função é totalmente diferente de qualquer linguagem que eu conhecia. Usa-se as sequência de caractere **$?** após a execução da função.

         3. Alterar o estado de uma variável ou variáveis globais;
            1. Nota: A função shell não pode alterar seus parâmetros e sim parâmetros globais.

         4. Saída de eco para stdout, que será capturada pelo chamador assim que c = `expr $a + $b` for capturada.

      3. <text onclick="goBack()">[🔙]</text>

   3. <span id=id_exemplos></span>**Exemplos.**
      1. <scan id="id_functions_example"></scan>Exemplos de funções:
         1. Este código ShellScript mostra o uso das  função **expr**, **return** e  resultado da função em **$?**.

            ```sh

               # Script subtrai.sh
               #!/bin/sh

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
            ```

         2. Este código ShellScript mostra o uso das  função **expr**, **exit** e  resultado da função em **$?**.

            ```sh

               # Script soma.sh
               #!/bin/sh

               # função soma
               soma(){
                  param1=$1
                  param2=$2
                  echo parâmetro 01 = $param1
                  echo parâmetro 02 = $param2

                  echo $param1
                  echo $param2
                  result=`expr $param1 + $param2`
                  exit $result
               }

               # parte principal do programa 
               soma 1 2
               # A sequencia $? contém o valor de exit mais nunca imprimira 
               # a linha abaixo aqui porque o comando exit aborta o script.
               echo "O valor retorna da expressão soma 1 2 = $?"

            ```

            ```sh
               # Script testsoma.sh
               #!/bin/sh

               # teste da chamada de função estando em outro arquivo.
               ./soma.sh
               echo "O valor retorna da expressão soma 1 2 = $?"
            ```

         3. <text onclick="goBack()">[🔙]</text>

      2. item 02.

      3. <text onclick="goBack()">[🔙]</text>

   4. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [Manual do usuário](https://www.shellscript.sh/)
      2. [ShellScript functions](https://www.shellscript.sh/functions.html)
      3. [Livro inacabado do comando sed](https://silo.tips/download/direitos-autorais-copyright)
      4. [#](##)
      5. [#](##)

      6. <text onclick="goBack()">[🔙]</text>

   5. <span id="id_historico"><span>**HISTÓRICO**

      1.02/06/2021 <!--TODO: HISTÓRICO -->

         - <text onclick="goBack()">[🔙]</text>

      2.02/06/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [x] Criar este documento baseado no modelo02.md ;
         - [ ] Escrever tópico Objetivos;
         - [ ] Escrever tópico Pre-requisitos
         - [ ] Escrever tópico Benefícios
         - [ ] Escrever tópico Descrição
         - [ ] Escrever tópico Exemplos
         - [ ] Escrever tópico Conteúdo 01
         - [ ] Escrever tópico Referências
         - [ ] Atualizar o histórico deste documento.
         - [ ] Testar este documento depois após uma semana de concluído.

         - <text onclick="goBack()">[🔙]</text>

[🔝🔝](#topo "Retorna ao topo")

 <script>    function goBack() {    window.history.back()}</script>
