"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
	class User extends Model {
		/**
		 * Helper method for defining associations.
		 * This method is not a part of Sequelize lifecycle.
		 * The `models/index` file will call this method automatically.
		 */
		static associate(models) {
			// define association here
			this.hasMany(models.House, {
				foreignKey: "user_id",
				onDelete: "CASCADE",
			});
			this.hasOne(models.Reservation, {
				foreignKey: "user_id",
				onDelete: "CASCADE",
			});
			this.belongsTo(models.Gender, {
				foreignKey: "gender_id",
				onDelete: "CASCADE",
			});
			this.belongsTo(models.Role, {
				foreignKey: "role_id",
				onDelete: "CASCADE",
			});
			this.hasMany(models.Favorite, {
				foreignKey: "user_id",
				onDelete: "CASCADE",
			});
			this.hasMany(models.Chat, {
				foreignKey: "sender_id",
				as:"Sender",
				onDelete: "CASCADE",
			});
			this.hasMany(models.Chat, {
				foreignKey: "receiver_id",
				as:"Receiver",
				onDelete: "CASCADE",
			});
			this.hasMany(models.Payement, {
				foreignKey: "user_id",
				onDelete: "CASCADE",
			});
		}
	}
	User.init(
		{
			name: DataTypes.STRING,
			lastname: DataTypes.STRING,
			contact: DataTypes.STRING,
			ren_house: DataTypes.BOOLEAN,
			birthday: DataTypes.DATE,
			gender_id: DataTypes.INTEGER,
			role_id: DataTypes.INTEGER,
			password: DataTypes.STRING,
		},
		{
			sequelize,
			modelName: "User",
		},
	);
	return User;
};
