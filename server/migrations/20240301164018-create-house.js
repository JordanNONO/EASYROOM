"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
	async up(queryInterface, Sequelize) {
		await queryInterface.createTable("Houses", {
			id: {
				allowNull: false,
				autoIncrement: true,
				primaryKey: true,
				type: Sequelize.INTEGER,
			},
			label: {
				type: Sequelize.STRING,
			},
			location: {
				type: Sequelize.STRING,
			},
			map_location: {
				type: Sequelize.STRING,
			},
			has_bathroom: {
				type: Sequelize.BOOLEAN,
			},
			has_kitchen: {
				type: Sequelize.BOOLEAN,
			},
			nbre_bedroom: {
				type: Sequelize.INTEGER,
			},
			is_rent: {
				type: Sequelize.BOOLEAN,
			},
			user_id: {
				type: Sequelize.INTEGER,
				references: {
					model: "Users",
					key: "id",
				},
				onUpdate: "CASCADE",
				onDelete: "CASCADE",
			},
			createdAt: {
				allowNull: false,
				type: Sequelize.DATE,
			},
			updatedAt: {
				allowNull: false,
				type: Sequelize.DATE,
			},
		});
	},
	async down(queryInterface, Sequelize) {
		await queryInterface.dropTable("Houses");
	},
};
