const router = require("express").Router();
const db = require("../../models");
const { protect } = require("../../auth/auth");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");

router.get("/", async (_req, res) => {
	try {
		const house = await db.House.findAll({
			include: ["Users", "House_image", "House_option", "House_advantage"],
			raw: true,
		});
		return res.status(200).json(house);
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});

router.post("/add", protect(), ValidateField, async (req, res) => {
	try {
		const newHouse = await db.House.create({
			...req.body,
			is_rent: false,
			user_id: req.user?.id,
		});
		return res.status(201).json(newHouse);
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});
router.post(
	"/update/:id",
	protect(),
	ValidateField,
	ValidateParams,
	async (req, res) => {
		try {
			const newHouse = await db.House.update(
				{
					...req.body,
				},
				{ where: { id: req.params.id, user_id: req.user?.id } },
			);
			return res.status(200).json(newHouse);
		} catch (error) {
			return res.status(500).send("Internal error");
		}
	},
);
router.delete(
	"/delete/:id",
	protect(),
	ValidateField,
	ValidateParams,
	async (req, res) => {
		try {
			const { id } = req.params;
			await db.House.destroy({ where: { id, user_id: req.user?.id } });
			return res.status(200).json({ status: "SUCCESS" });
		} catch (error) {
			return res.status(500).send("Internal error");
		}
	},
);

module.export = router;
