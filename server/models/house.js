'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class House extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  House.init({
    label: DataTypes.STRING,
    location: DataTypes.STRING,
    map_location: DataTypes.STRING,
    has_bathroom: DataTypes.BOOLEAN,
    has_kitchen: DataTypes.BOOLEAN,
    nbre_bedroom: DataTypes.INTEGER,
    is_rent: DataTypes.BOOLEAN,
    user_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'House',
  });
  return House;
};