const Sequelize = require('sequelize');

//import Sequelize from 'sequelize';

//Usando string de conexão
const sequelize = new Sequelize('mariadb://root:Paulo195858@192.168.15.3:3306/mysql');

sequelize.authenticate().then(
    function () {
        console.log('A conexão foi estabelecida com sucesso.');
    }
).catch(
    function (error) {
        console.error('Não foi possível conectar à base de dados::', error);
    }
  );

