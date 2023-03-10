/**
 * https://sequelize.org/master/
 * 
 */

const { Sequelize, Model, DataTypes } = require('sequelize');
const sequelize = new Sequelize('sqlite::memory:');

class User extends Model {}
User.init({
  username: DataTypes.STRING,
  birthday: DataTypes.DATE
}, { sequelize, modelName: 'user' });

(async () => {
  await sequelize.sync();
  const jane = await User.create({
    username: 'root',
    birthday: new Date(1980, 6, 20)
  });
  console.log(jane.toJSON());
})();
