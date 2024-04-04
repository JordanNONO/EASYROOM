const { protect } = require("../../auth/auth");
const db = require("../../models");
const { ValidateParams } = require("../../middlewares/validation");
const { Op } = require("sequelize");
const router = require("express").Router();

router.get("/", protect(), async (req, res) => {
	try {
		const favorites = db.Favorite.findAll({
			where: { user_id: req?.user?.id },
		});
		return res.status(200).json(favorites);
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});
router.post("/set/:house_id", protect(), async (req, res) => {
	try {
		const { house_id } = req.params;
		const getHouse = await db.House.findOne({ where: { id: house_id } });
		if (!getHouse) {
			return res.status(400).send("You have send bad requests");
		}
		const checkFavorite = await db.Favorite.findOne({
			house_id,
			user_id: req.user?.id,
		});
		if (checkFavorite) {
			await db.Favorite.destroy({
				where: { [Op.and]: [{ house_id }, { user_id: req.user?.id }] },
			});
			return res
				.status(200)
				.json({ state: "SUCCESS", message: "Favorite set" });
		} else {
			await db.Favorite.create({ house_id, user_id: req.user?.id });
			return res
				.status(200)
				.json({ state: "SUCCESS", message: "Favorite set" });
		}
	} catch (error) {
		return res.status(500).send("internal error")
	}
});
module.exports = router
