"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
	class Favorite extends Model {
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
		}
	}
	Favorite.init(
		{
			house_id: DataTypes.INTEGER,
			user_id: DataTypes.INTEGER,
		},
		{
			sequelize,
			modelName: "Favorite",
		},
	);
	return Favorite;
};
