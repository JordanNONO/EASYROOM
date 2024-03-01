'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  User.init({
    name: DataTypes.STRING,
    lastname: DataTypes.STRING,
    contact: DataTypes.STRING,
    ren_house: DataTypes.BOOLEAN,
    birthday: DataTypes.DATE,
    gender_id: DataTypes.INTEGER,
    role_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'User',
  });
  return User;
};