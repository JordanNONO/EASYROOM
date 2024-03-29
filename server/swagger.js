const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'EASYROOM API Documentation',
      version: '1.0.0',
    },
    servers: [
      {
        url: 'http://localhost:4500',
      },
    ],
  },
  apis: ['./routes/api/*.js'], // Chemin vers les fichiers de route de votre API
};

const specs = swaggerJsdoc(options);

module.exports = {
  specs,
  swaggerUi,
};
