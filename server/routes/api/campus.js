const router = require("express").Router();
const { optionalAuth } = require("../../auth/auth");
const { getCrousResidencesForLimoges, getLimogesStops } = require("../../lib/limoges-data");

router.get("/crous", optionalAuth(), async (req, res) => {
	try {
		const residences = await getCrousResidencesForLimoges();
		return res.status(200).json(residences);
	} catch (error) {
		console.error(error);
		return res.status(500).json({ message: "Internal server error" });
	}
});

router.get("/stops", optionalAuth(), async (req, res) => {
	try {
		const stops = await getLimogesStops();
		return res.status(200).json(stops);
	} catch (error) {
		console.error(error);
		return res.status(500).json({ message: "Internal server error" });
	}
});

module.exports = router;
