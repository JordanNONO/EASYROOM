'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class House_adventage extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  House_adventage.init({
    label: DataTypes.STRING,
    house_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'House_adventage',
  });
  return House_adventage;
};