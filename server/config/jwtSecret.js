require("dotenv").config();
const crypto = require("crypto");

let ephemeralSecret = null;
let warned = false;

// Résout un secret unique partagé par tout le process (signature ET vérification des JWT),
// pour que le fallback de dev reste cohérent même sans JWT_SECRET défini.
function getJwtSecret() {
	if (process.env.JWT_SECRET) return process.env.JWT_SECRET;

	if (!warned) {
		console.warn(
			"JWT_SECRET n'est pas défini : utilisation d'un secret temporaire non sécurisé pour le développement. Définis JWT_SECRET dans .env pour la production.",
		);
		warned = true;
	}
	if (!ephemeralSecret) {
		ephemeralSecret = crypto.randomBytes(32).toString("hex");
	}
	return ephemeralSecret;
}

module.exports = { getJwtSecret };
