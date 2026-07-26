'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
	up: async (queryInterface, Sequelize) => {
		await queryInterface.addColumn('Houses', 'latitude', {
			type: Sequelize.DECIMAL(9, 6),
			allowNull: true,
		});
		await queryInterface.addColumn('Houses', 'longitude', {
			type: Sequelize.DECIMAL(9, 6),
			allowNull: true,
		});
		await queryInterface.addColumn('Houses', 'city', {
			type: Sequelize.STRING,
			allowNull: true,
		});
		await queryInterface.addColumn('Houses', 'citycode', {
			type: Sequelize.STRING,
			allowNull: true,
		});
		await queryInterface.addColumn('Houses', 'geocoding_status', {
			type: Sequelize.STRING,
			allowNull: false,
			defaultValue: 'pending',
		});
		await queryInterface.addColumn('Houses', 'slug', {
			type: Sequelize.STRING,
			allowNull: true,
		});
		await queryInterface.addColumn('Houses', 'status', {
			type: Sequelize.STRING,
			allowNull: false,
			defaultValue: 'published',
		});
	},

	down: async (queryInterface) => {
		await queryInterface.removeColumn('Houses', 'latitude');
		await queryInterface.removeColumn('Houses', 'longitude');
		await queryInterface.removeColumn('Houses', 'city');
		await queryInterface.removeColumn('Houses', 'citycode');
		await queryInterface.removeColumn('Houses', 'geocoding_status');
		await queryInterface.removeColumn('Houses', 'slug');
		await queryInterface.removeColumn('Houses', 'status');
	},
};
