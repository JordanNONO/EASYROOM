'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Chat extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      this.belongsTo(models.User,{
        foreignKey:"sender_id",
        onDelete:"CASCADE"
      })
      this.belongsTo(models.User,{
        foreignKey:"receiver_id",
        onDelete:"CASCADE"
      })
      this.belongsTo(models.House,{
        foreignKey:"house_id",
        onDelete:"CASCADE"
      })
    }
  }
  Chat.init({
    sender_id: DataTypes.INTEGER,
    receiver_id: DataTypes.INTEGER,
    message: DataTypes.TEXT,
    house_id: DataTypes.INTEGER,
    is_read: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'Chat',
  });
  return Chat;
};