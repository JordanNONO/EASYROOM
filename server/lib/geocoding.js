const MIN_SCORE = 0.4;

// Géocode une adresse via la Base Adresse Nationale (api-adresse.data.gouv.fr),
// gratuite et sans clé. Ne jette jamais : un échec de géocodage ne doit pas
// empêcher la création/mise à jour d'une annonce.
async function geocodeAddress(location) {
	if (!location) return null;

	try {
		const url = `https://api-adresse.data.gouv.fr/search/?q=${encodeURIComponent(location)}&limit=1`;
		const response = await fetch(url);
		if (!response.ok) return null;

		const data = await response.json();
		const feature = data?.features?.[0];
		if (!feature || (feature.properties?.score ?? 0) < MIN_SCORE) return null;

		const [longitude, latitude] = feature.geometry.coordinates;
		return {
			latitude,
			longitude,
			city: feature.properties.city ?? null,
			citycode: feature.properties.citycode ?? null,
		};
	} catch (error) {
		console.warn('Géocodage échoué pour', location, error.message);
		return null;
	}
}

module.exports = { geocodeAddress };
