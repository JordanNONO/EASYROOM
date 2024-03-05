"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
	class Gender extends Model {
		/**
		 * Helper method for defining associations.
		 * This method is not a part of Sequelize lifecycle.
		 * The `models/index` file will call this method automatically.
		 */
		static associate(models) {
			// define association here
			this.hasOne(models.User, {
				foreignKey: "user_id",
				onDelete: "CASCADE",
			});
		}
	}
	Gender.init(
		{
			label: DataTypes.STRING,
		},
		{
			sequelize,
			modelName: "Gender",
		},
	);
	return Gender;
};
