var admin = require("firebase-admin");
var serviceAccount = require("../easyroom-17f28-firebase-adminsdk-vstmx-16aba3cdca.json");

admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
});

function getAccessToken() {
	return new Promise(function(resolve, reject) {
		const key = require("../easyroom-17f28-firebase-adminsdk-vstmx-16aba3cdca.json");
		const jwtClient = new google.auth.JWT(
			key.client_email,
			null,
			key.private_key,
			SCOPES,
			null,
		);
		jwtClient.authorize(function(err, tokens) {
			if (err) {
				reject(err);
				return;
			}
			resolve(tokens.access_token);
		});
	});
}

module.exports = { admin, getAccessToken };
