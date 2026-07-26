require("dotenv").config();

const dialect = process.env.DB_DIALECT || "postgres";

module.exports = {
	development: {
		username: process.env.DB_USERNAME || "postgres",
		password: process.env.DB_PASSWORD || null,
		database: process.env.DB_NAME || "easyroom_dev",
		host: process.env.DB_HOST || "127.0.0.1",
		port: process.env.DB_PORT || 5432,
		dialect,
	},
	test: {
		username: process.env.DB_USERNAME || "postgres",
		password: process.env.DB_PASSWORD || null,
		database: process.env.DB_NAME_TEST || "easyroom_test",
		host: process.env.DB_HOST || "127.0.0.1",
		port: process.env.DB_PORT || 5432,
		dialect,
	},
	production: {
		use_env_variable: "DATABASE_URL",
		dialect: "postgres",
		dialectOptions: {
			ssl: {
				require: true,
				rejectUnauthorized: false,
			},
		},
	},
};
