/**
 * Exemplo de como conectar-se ao banco de dados mariadb.
 * 
 */

/**
 * O construtor Sequelize aceita várias opções. 
 * Eles estão documentados na [Referência da API](https://sequelize.org/master/class/lib/sequelize.js~Sequelize.html#instance-constructor-constructor) .
 * 
 */
const
    Sequelize = require('sequelize');

/**
 * Cria objeto connection para conecta-ser ao mariadb.
 * https://sequelize.org/v5/manual/dialects.html
 * A seguir criamos uma nova instância do Sequelize usando o seu construtor que 
 * possui a seguinte sintaxe:
 *    conexao = new Sequelize(database, [username=null], [password=null], [options={}])
 *       onde :
 *              1. database: é o nome do schema do banco de dados que vamos acessar. 
 *                           No nosso exemplo usamos o schema mac_demo criado no MySQL;
 *              2. username: é o nome do usuário de acesso ao MySQL, no exemplo estou 
 *                           usando o usuário root;
 *              3. password: é senha do usuário root. Para o exemplo estou usando a 
 *                           senha do usuário root;
 *              4. [options={}] = {host: '192.168.15.3',port: '3306',dialect: 'mariadb'}
 * */
const
    connection = new Sequelize('mysql', 'root', 'Paulo195858',
                               { host: '192.168.15.3', port: '3306', dialect: 'mariadb' });

/**
 * TESTE DA CONEXÃO
 * Conecta-se ao banco de dados mariadb com autenticação.
 * 
 */
   var conexao = connection.authenticate().then(
       function () { console.log('A conexão foi estabelecida com sucesso.'); }
    ).catch(
       function () { console.error('Não foi possível conectar à base de dados::', error); }
    );


/**
 * Fechando a conexão
 * 
 * Sequelize manterá a conexão aberta por padrão e usará a mesma 
 * conexão para todas as consultas. Se você precisar fechar a conexão, 
 * ligue sequelize.close()(que é assíncrona e retorna uma Promessa).
 * 
 */

//sequelize.close();

