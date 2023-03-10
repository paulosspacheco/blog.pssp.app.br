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
 * Cria objeto sequelize para conecta-ser ao mariadb.
 * https://sequelize.org/v5/manual/dialects.html
 * */
const
    sequelize = new Sequelize('mysql', 'root', 'Paulo195858', {host: '192.168.15.3',port: '3306',dialect: 'mariadb'});

/**
 * Conecta-se ao banco de dados mysql
 * Testando a conexão
 * Você pode usar a .authenticate()função para testar se a conexão está OK:
 * 
 */
async function conectar_mariaDb() {
    try {
        await sequelize.authenticate();
        console.log('A conexão foi estabelecida com sucesso.');
    }
    catch (error) {
        console.error('Não foi possível conectar à base de dados::', error);
    }
}
conectar_mariaDb();

/**
 * Fechando a conexão
 * 
 * Sequelize manterá a conexão aberta por padrão e usará a mesma 
 * conexão para todas as consultas. Se você precisar fechar a conexão, 
 * ligue sequelize.close()(que é assíncrona e retorna uma Promessa).
 * 
 */

sequelize.close();
