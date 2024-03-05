"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
	class House_images extends Model {
		/**
		 * Helper method for defining associations.
		 * This method is not a part of Sequelize lifecycle.
		 * The `models/index` file will call this method automatically.
		 */
		static associate(models) {
			// define association here
			this.belongsTo(models.House, {
				foreignKey: "house_id",
				onDelete: "CASCADE",
			});
		}
	}
	House_images.init(
		{
			label: DataTypes.STRING,
			image: DataTypes.STRING,
			house_id: DataTypes.INTEGER,
		},
		{
			sequelize,
			modelName: "House_images",
		},
	);
	return House_images;
};
