const { hashSync, compareSync } = require("bcryptjs");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");
const db = require("../../models");
const jwt = require("jsonwebtoken");
const router = require("express").Router();

router.get("/:id", (req, res) => {});

router.post("/add", ValidateField, async (req, res) => {
	try {
		const newUser = await db.User.create({
			...req.body,
			password: hashSync(req.body?.password, 10),
			rent_house: req.body?.rent_house ?? false,
		});
		return res.status(201).json(newUser);
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});
router.post("/update/:id", ValidateField, ValidateParams, async (req, res) => {
	try {
		const { id } = req.params;
		const newUser = await db.User.update(
			{
				...req.body,
				password: hashSync(req.body?.password, 10),
				rent_house: req.body?.rent_house ?? false,
			},
			{ where: { id } },
		);
		return res.status(200).json(newUser);
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});
router.post("/rent-house/:id", ValidateParams, async (req, res) => {
	try {
		const { id } = req.params;
		await db.User.update({ rent_house: true }, { where: { id } });
		return res.status(200).json({ state: "SUCCESS" });
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});
router.post("/login", ValidateField, async (req, res) => {
	try {
		const { contact, password } = req.body;
		const user = await db.User.findOne({
			where: { contact },
			include: ["Gender"],
			raw: true,
		});
		if (!user)
			return res.status(400).json({
				state: "ERROR",
				message: "Les informations de connexion ne sont pas correct!",
			});
		const isMatch = compareSync(password, user?.password);
		if (!isMatch)
			return res.status(400).json({
				state: "ERROR",
				message: "Les informations de connexion ne sont pas correct!",
			});
		if (user && isMatch) {
			//extraire le password de l'objet
			const { password, ...getPayload } = user;
			const payload = { ...getPayload };
			const token = jwt.sign(
				payload,
				process.env.SECRET ?? "hjshd@°#§@¦@°§°§¬¬|@°§°@§#¬§575dAj",
				{ expiresIn: "1d" },
			);
			return res.status(200).json({ state: "SUCCESS", token });
		}
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});

module.exports = router;
