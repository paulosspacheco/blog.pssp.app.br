<span id="topo"><span>

# Como usar funções assíncronas em javascript <a href="functions_async.html" target="_blank" title="Pressione aqui para expandir este documento em nova aba." >  ➚ </a>

## **1. INDEX**

---

   1. **Objetivo**<span id="topo_Objetivo"><span>

      1. [Objetivo deste documento](#id_objetivo).
      2. [Pre-requisitos para compreensão deste documento](#id_pre_requisitos).
      3. [Os benefícios que este documento pode me trazer](#id_beneficios).

   2. [Como fazer 01](#Como_fazer_01)
      1. ...
      2. ..
   3. [Referências](#id_referencias)
   4. [Histórico](#id_historico)

## **2. CONTEÚDO**

---

   1. **Objetivo**

      1. <span id="id_objetivo"><span>As funções assíncronas (**async**) permitem escrever código baseado em promessa (promises) como se fosse síncrono (synch), mas sem bloquear o segmento principal. Elas tornam o seu código assíncrono menos "inteligente" e mais legível. Se usar a palavra-chave async antes de uma definição de função, você pode usar **await** (aguardam) dentro da função.
         1. Exemplo de function que usa promessa:

            ```javascript

               async function myFirstAsyncFunction() {
                  try {
                     const fulfilledValue = await promise; //Aguarda até que o evento seja executado. 
                  }
                  catch (rejectedValue) {
                     // Executa este código se houver fracasso …
                  }
               }

            ```

      2. <span id="id_pre_requisitos"></span> Para entender o que é uma promessa (promise) é preciso conhecer como funciona a programação orientada a evento do javascript.
         1. 
      3. <span id="id_beneficios"></span>Descreva um resumo do que este documento pode agregar no meu conhecimento.

      4. [🔝](#topo_Objetivo "Retorna ao topo")

   2. <span id=Como_fazer_01></span>**Como fazer 01**

      1. Descrição de como fazer ...
      2. ...
      3. ...

      4. [🔝](#topo_pessoais "Retorna ao topo")

   3. <span id=id_referencias></span>**REFERÊNCIAS**
      1. [ref01](ref01)
      2. ...

   4. <span id="id_historico"><span>**HISTÓRICO**

      1. 04/02/2021 <!--TODO: HISTÓRICO -->
         - [x] Criado este documento;

         - [🔝](#topo "Retorna ao topo")

      2. 04/02/2021 <!--FIXME: Falta fazer os item abaixo: -->
         - [ ] projeto 01;
         - [ ] bug 01;
         - [🔝](#topo "Retorna ao topo")

[🔝🔝](#topo "Retorna ao topo")
