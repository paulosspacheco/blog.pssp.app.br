/**
 * https://blog.rocketseat.com.br/nodejs-express-sequelize/
 */
/**
     * Conectando-se a um banco de dados
*/
// Importando a class  Sequelize 
const { Sequelize } = require('sequelize');
// Criar o objeto sequelize passando como parâmetro um string de conexão.
const connection = new Sequelize('mariadb://root:Paulo195858@192.168.15.3:3306/mysql');


/**
* Testando a conexão
* Você pode usar a .authenticate() função para testar se a conexão está OK:
* Conexao retorna uma promessa. (veja: https://nodejs.dev/learn/understanding-javascript-promises)
*/
conexao = connection.authenticate().then(
    //Essa função será executada se o banco de dados está conectado
    function () {
        console.log('A conexão foi estabelecida com sucesso.');
        conectado = true;
    }

).catch(
    //Esta função é executada se o banco de dados não for conectado.
    function (error) {
        console.error('Não foi possível conectar à base de dados::', error);
    }
);

console.log('fim'); 

/**
* Fechando a conexão
* Sequelize manterá a conexão aberta por padrão e usará a mesma 
* conexão para todas as consultas. Se você precisar fechar a conexão, ligue 
* sequelize.close()(que é assíncrona e retorna uma Promessa).
* 
*/
//Desativei a linha abaixo porque dar erro ao ser executado.
//sequelize.close();
