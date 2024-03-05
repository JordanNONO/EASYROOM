"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
	class Payement extends Model {
		/**
		 * Helper method for defining associations.
		 * This method is not a part of Sequelize lifecycle.
		 * The `models/index` file will call this method automatically.
		 */
		static associate(models) {
			// define association here
			this.belongsTo(models.User, {
				foreignKey: "user_id",
				onDelete: "CASCADE",
			});
			this.belongsTo(models.House, {
				foreignKey: "house_id",
				onDelete: "CASCADE",
			});
		}
	}
	Payement.init(
		{
			method: DataTypes.STRING,
			user_id: DataTypes.INTEGER,
			house_id: DataTypes.INTEGER,
			ref: DataTypes.STRING,
			amount: DataTypes.INTEGER,
			currency: DataTypes.STRING,
			country: DataTypes.STRING,
		},
		{
			sequelize,
			modelName: "Payement",
		},
	);
	return Payement;
};
