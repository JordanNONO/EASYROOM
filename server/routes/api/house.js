const router = require("express").Router();
const db = require("../../models");
const { protect } = require("../../auth/auth");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");

router.get("/", async (_req, res) => {
	try {
		const houses = []
		const house = await db.House.findAll({
			include: ["User"],
			raw: true,
		});
		for (const key in house) {
			if (Object.hasOwnProperty.call(house, key)) {
				const getHouse = house[key];
				const images = await db.House_images.findAll({where:{house_id:getHouse?.id},raw:true})??[]
				const options = await db.House_option.findAll({where:{house_id:getHouse?.id},raw:true})??[]
				houses.push({...getHouse,images,options})
				
			}
		}
		
		return res.status(200).json(houses);
		
		
	} catch (error) {
		console.log(error)
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

module.exports = router
