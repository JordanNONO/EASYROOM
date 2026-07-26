const EARTH_RADIUS_METERS = 6371000;

function toRadians(degrees) {
	return (degrees * Math.PI) / 180;
}

function haversineMeters(lat1, lon1, lat2, lon2) {
	const dLat = toRadians(lat2 - lat1);
	const dLon = toRadians(lon2 - lon1);
	const a =
		Math.sin(dLat / 2) ** 2 +
		Math.cos(toRadians(lat1)) * Math.cos(toRadians(lat2)) * Math.sin(dLon / 2) ** 2;
	return EARTH_RADIUS_METERS * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

function nearestStop(lat, lon, stops) {
	if (lat == null || lon == null || !stops || stops.length === 0) return null;

	let closest = null;
	let closestDistance = Infinity;
	for (const stop of stops) {
		const distance = haversineMeters(lat, lon, stop.lat, stop.lon);
		if (distance < closestDistance) {
			closestDistance = distance;
			closest = stop;
		}
	}
	if (!closest) return null;
	return { name: closest.name, distanceMeters: Math.round(closestDistance) };
}

module.exports = { haversineMeters, nearestStop };
