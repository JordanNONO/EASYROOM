// Middleware pour échapper les données d'entrée
function escapeHtml(unsafe) {
	return String(unsafe).replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function ValidateField(req, res, next) {
	try {
		const body = req.body;

		// Vérifie si le corps de la requête est vide
		if (Object.keys(body).length === 0) {
			return res
				.status(400)
				.json({ error: "Le corps de la requête est vide." });
		}

		// Validez et échappez chaque champ du corps de la requête
		for (const key in body) {
			if (body[key] === null || body[key] === undefined || body[key] === "") {
				return res
					.status(400)
					.json({ error: `Le champ "${key}" ne peut pas être vide.` });
			}

			// Échappez la valeur
			body[key] = escapeHtml(body[key]);
		}

		// Si toutes les validations passent, passez à la route suivante
		next();
	} catch (error) {
		console.error(error);
		return res
			.status(500)
			.send("Une erreur s'est produite. Veuillez réessayer plus tard.");
	}
}
function ValidateParams(req, res, next) {
	try {
		const body = req.params;
		console.log(body);

		// Vérifie si le corps de la requête est vide
		if (Object.keys(body).length === 0) {
			return res
				.status(400)
				.json({ error: "Le corps de la requête est vide." });
		}

		// Validez et échappez chaque champ du corps de la requête
		for (const key in body) {
			if (body[key] === null || body[key] === undefined || body[key] === "") {
				return res
					.status(400)
					.json({ error: `Le champ "${key}" ne peut pas être vide.` });
			}

			// Échappez la valeur
			body[key] = escapeHtml(body[key]);
		}

		// Si toutes les validations passent, passez à la route suivante
		next();
	} catch (error) {
		console.error(error);
		return res
			.status(500)
			.send("Une erreur s'est produite. Veuillez réessayer plus tard.");
	}
}

module.exports = {
	ValidateField,
	ValidateParams,
};
