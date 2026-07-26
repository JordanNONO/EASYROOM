const AdmZip = require('adm-zip');

const TTL_MS = 24 * 60 * 60 * 1000;

const crousCache = { data: null, fetchedAt: 0 };
const stopsCache = { data: null, fetchedAt: 0 };

const CROUS_API_URL =
	'https://data.enseignementsup-recherche.gouv.fr/api/records/1.0/search/?dataset=fr_crous_logement_france_entiere&refine.zone=Limoges+(87)&rows=100';

const LIMOGES_GTFS_ZIP_URL =
	'https://www.pigma.org/public/opendata/nouvelle_aquitaine_mobilites/publication/ca_limoges_metropole-aggregated-gtfs.zip';

function isFresh(cache) {
	return cache.data !== null && Date.now() - cache.fetchedAt < TTL_MS;
}

// Parseur CSV minimal, suffisant pour stops.txt (gère les champs entre guillemets).
function parseCsv(text) {
	const lines = text.split(/\r?\n/).filter((line) => line.length > 0);
	if (lines.length === 0) return [];

	const parseLine = (line) => {
		const fields = [];
		let current = '';
		let inQuotes = false;
		for (let i = 0; i < line.length; i++) {
			const char = line[i];
			if (char === '"') {
				inQuotes = !inQuotes;
			} else if (char === ',' && !inQuotes) {
				fields.push(current);
				current = '';
			} else {
				current += char;
			}
		}
		fields.push(current);
		return fields;
	};

	const headers = parseLine(lines[0]);
	return lines.slice(1).map((line) => {
		const values = parseLine(line);
		const row = {};
		headers.forEach((header, index) => {
			row[header.trim()] = values[index];
		});
		return row;
	});
}

async function getCrousResidencesForLimoges() {
	if (isFresh(crousCache)) return crousCache.data;

	try {
		const response = await fetch(CROUS_API_URL);
		if (!response.ok) throw new Error(`CROUS API HTTP ${response.status}`);
		const data = await response.json();

		const residences = (data.records ?? [])
			.filter((record) => record.fields?.zone === 'Limoges (87)')
			.map((record) => {
				// geocalisation est un geo_point_2d au format [lat, lon] (ordre inverse de BAN/GeoJSON).
				const [lat, lon] = record.fields.geocalisation ?? [null, null];
				return {
					id: record.recordid,
					title: record.fields.title ?? null,
					address: record.fields.address ?? null,
					lat,
					lon,
				};
			});

		crousCache.data = residences;
		crousCache.fetchedAt = Date.now();
		return residences;
	} catch (error) {
		console.warn('Récupération des résidences CROUS échouée:', error.message);
		return crousCache.data ?? [];
	}
}

async function getLimogesStops() {
	if (isFresh(stopsCache)) return stopsCache.data;

	try {
		const response = await fetch(LIMOGES_GTFS_ZIP_URL);
		if (!response.ok) throw new Error(`GTFS zip HTTP ${response.status}`);
		const buffer = Buffer.from(await response.arrayBuffer());

		const zip = new AdmZip(buffer);
		const stopsEntry = zip.getEntry('stops.txt');
		if (!stopsEntry) throw new Error('stops.txt introuvable dans le zip GTFS');

		const rows = parseCsv(stopsEntry.getData().toString('utf8'));
		const stops = rows
			.map((row) => ({
				id: row.stop_id,
				name: row.stop_name,
				lat: parseFloat(row.stop_lat),
				lon: parseFloat(row.stop_lon),
			}))
			.filter((stop) => Number.isFinite(stop.lat) && Number.isFinite(stop.lon));

		stopsCache.data = stops;
		stopsCache.fetchedAt = Date.now();
		return stops;
	} catch (error) {
		console.warn('Récupération des arrêts de transport Limoges échouée:', error.message);
		return stopsCache.data ?? [];
	}
}

module.exports = { getCrousResidencesForLimoges, getLimogesStops };
