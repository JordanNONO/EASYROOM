"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
	class House extends Model {
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
			this.hasOne(models.Payement, {
				foreignKey: "house_id",
				onDelete: "CASCADE",
			});
			this.hasOne(models.Reservation, {
				foreignKey: "house_id",
				onDelete: "CASCADE",
			});
			this.hasMany(models.House_option, {
				foreignKey: "house_id",
				onDelete: "CASCADE",
			});
			this.hasMany(models.House_images, {
				foreignKey: "house_id",
				onDelete: "CASCADE",
			});
			this.hasMany(models.House_adventage, {
				foreignKey: "house_id",
				onDelete: "CASCADE",
			});
		}
	}
	House.init(
		{
			label: DataTypes.STRING,
			location: DataTypes.STRING,
			map_location: DataTypes.STRING,
			has_bathroom: DataTypes.BOOLEAN,
			has_kitchen: DataTypes.BOOLEAN,
			nbre_bedroom: DataTypes.INTEGER,
			is_rent: DataTypes.BOOLEAN,
			price:DataTypes.INTEGER,
			description: DataTypes.TEXT,
			user_id: DataTypes.INTEGER,
		},
		{
			sequelize,
			modelName: "House",
		},
	);
	return House;
};
