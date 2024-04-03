'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Chats', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      sender_id: {
        type: Sequelize.INTEGER,
        references: {
					model: "Users",
					key: "id",
				},
				onUpdate: "CASCADE",
				onDelete: "CASCADE",
      },
      receiver_id: {
        type: Sequelize.INTEGER,
        references: {
					model: "Users",
					key: "id",
				},
				onUpdate: "CASCADE",
				onDelete: "CASCADE",
      },
      message: {
        type: Sequelize.TEXT
      },
      house_id: {
        type: Sequelize.INTEGER,
        references: {
					model: "Houses",
					key: "id",
				},
				onUpdate: "CASCADE",
				onDelete: "CASCADE",
      },
      is_read: {
        type: Sequelize.BOOLEAN,
        default:false
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Chats');
  }
};