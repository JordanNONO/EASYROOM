const fs = require("fs");
const path = require("path");
const admin = require("firebase-admin");

const serviceAccountPath = path.resolve(
	process.env.FIREBASE_SERVICE_ACCOUNT_PATH || "./easyroom-firebase-adminsdk.json",
);

let app = null;
if (fs.existsSync(serviceAccountPath)) {
	const serviceAccount = require(serviceAccountPath);
	app = admin.initializeApp({
		credential: admin.credential.cert(serviceAccount),
	});
} else {
	console.warn(
		`Firebase désactivé : fichier de clé de service introuvable à ${serviceAccountPath}. Définis FIREBASE_SERVICE_ACCOUNT_PATH dans .env pour l'activer.`,
	);
}

async function getAccessToken() {
	if (!app) throw new Error("Firebase n'est pas configuré (clé de service manquante).");
	const { access_token } = await app.options.credential.getAccessToken();
	return access_token;
}

module.exports = { admin, getAccessToken };
