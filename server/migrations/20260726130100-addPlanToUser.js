'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
	up: async (queryInterface, Sequelize) => {
		await queryInterface.addColumn('Users', 'plan', {
			type: Sequelize.STRING,
			allowNull: false,
			defaultValue: 'free',
		});
	},

	down: async (queryInterface) => {
		await queryInterface.removeColumn('Users', 'plan');
	},
};
