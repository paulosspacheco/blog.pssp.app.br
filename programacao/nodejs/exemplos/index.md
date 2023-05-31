# EXEMPLOS DE USO DO NODEJS

## OBJETIVO

   1. Este documento descreve tudo de que preciso saber para trabalhar com nodejs.
   2. ..

## ÍNDICES

   1. [Como instalar e configurar node js no vscode](#id-configuracao).
   2. [O que significa é sigla REST no estudo da web](#id-rest).
   3. [Como usar o framework express do node.js](#id_express).

## CONTEÚDOS

   1. Como instalar e configurar node js no vscode. <span id="id-configuracao"><span>
      1. Toda a documentação de como instalar nodejs e suas extensões estão registradas no arquivo [../configuracao.html](../configuracao.html).
   2. O que significa é sigla [REST](https://pt.wikipedia.org/wiki/REST) no estudo da web. <span id="id-rest"><span>
      1. É uma [tese de doutorado](https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm) de [Roy Fielding](https://pt.wikipedia.org/wiki/Roy_Fielding) que descreve um modelo a ser utilizado para se projetar arquiteturas de software distribuído, baseadas em comunicação do protocolo http.
      2. Toda requisição precisa ter um identificado único chamado de URI (Uniform Resource Identifier).
         1. Exemplos:
            1. <http://servicorest.com.br/clientes/GET/id>; (Obter os dados de um recurso.)
            2. <http://servicorest.com.br/clientes/POST> ; (Criar um novo recurso.)
            3. <http://servicorest.com.br/clientes/PUT/id>; (Substituir os dados de um determinado recurso)
            4. <http://servicorest.com.br/clientes/PATCH/id>; (Atualizar parcialmente um determinado recurso)
            5. <http://servicorest.com.br/clientes/DELETE/id>; (Excluir um determinado recurso)
            6. <http://servicorest.com.br/clientes/HEAD>; (Similar ao GET, mas utilizado apenas para se obter os cabeçalhos de resposta, sem os dados em si)
            7. <http://servicorest.com.br/clientes/OPTIONS>; (Obter quais manipulações podem ser realizadas em um determinado recurso)
      3. Representações dos [recursos](https://pt.wikipedia.org/wiki/REST#Recursos):
         1. Um recurso pode ser representado de diversas maneiras, utilizando-se formatos específicos, tais como XML, JSON, HTML, CSV, dentre outros. Exemplo de representação de um recurso no formato XML.
            1. [Exemplos de uma requisição GET com identificador](#id-xml-json).
   3. Como usar o framework express do node.js.<span id=id_express></span>
      1. Exemplos baseado na aula 07 e 10 do Curso de Node.js - Exibindo HTML.
         1. [Exemplo de rota da pasta raiz](./test_express.js).
         2. [Exemplo de rota sem parâmetros](./test_express.js).
         3. [Exemplo de rotas com parâmetros enviados pelo usuário](./test_express.js).
         4. [Exemplo de uso da variável de ambiente __dirname e do método express().sendFile()](./test_express.js).
      2. Exemplos baseado na aula do "Curso de Node.js - Instalando o Mysql #11"
         1. .
   4. .

## ANEXOS

<span id=id-xml-json> </span>

### Exemplo de recurso XML para localizar um cliente usando a requisição GET

```xml

    <clientes>
        <id>1</id>
        <nome>Paulo Pacheco</nome>
        <rua>Rua Francisco oliveira de Souza</rua>
        <numero>15</numero>
        <bairro>Icarai</bairro>
        <municipio>Caucaia</municipio>
        <estado>Ceara</estado>
    </clientes>


```json
    
   {
   "id": 1,
   "nome": "Paulo Pacheco",
   "rua" : "Rua Francisco oliveira de Souza",
   "numero": 15,
   "bairro" : "Icarai",
   "municipio": "caucaia",
   "estado": "ceara"
   }[Como usar o framework express do node.js](#id_express)

```

## HISTÓRICOS

- [x] Criar documento index.md para registrar tudo que preciso saber para trabalhar com nodejs.
- [x] Fazer [exemplo de uso](./test_express.js) do framework express baseado no vídeo [Curso de Node.js - Exibindo HTML #10](https://www.youtube.com/watch?v=UkwLcuzJRDQ&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=10)
- [ ] Fazer exemplo de uso do framework express baseado no vídeo [Curso de Node.js - Instalando o Mysql #11](https://www.youtube.com/watch?v=HmmYkLyVy-c&list=PLJ_KhUnlXUPtbtLwaxxUxHqvcNQndmI4B&index=11).
- [ ] 
