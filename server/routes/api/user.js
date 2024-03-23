const { hashSync, compareSync } = require("bcryptjs");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");
const db = require("../../models");
const jwt = require("jsonwebtoken");
const { protect } = require("../../auth/auth");
const router = require("express").Router();

router.get("/me", protect(), (req, res) => {
	const { password, ...rest } = req.user;
	return res.status(200).json(rest);
});

router.post("/add", ValidateField, async (req, res) => {
	try {
		const role = await db.Role.findOne({
			where: { label: "client" },
			raw: true,
		});
		const newUser = await db.User.create({
			...req.body,
			role_id: role?.id,
			password: hashSync(req.body?.password, 10),
			ren_house: false,
		});
		return res.status(201).json(newUser);
	} catch (error) {
		console.log(error);
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
			const { id } = req.params;
			const newUser = await db.User.update(
				{
					...req.body,
					password: hashSync(req.body?.password, 10),
					ren_house: req.body?.rent_house ?? false,
				},
				{ where: { id } },
			);
			return res.status(200).json(newUser);
		} catch (error) {
			return res.status(500).send("Internal error");
		}
	},
);
router.post("/rent-house", protect(), async (req, res) => {
	try {
		const id = req.user?.id;
		await db.User.update({ ren_house: true }, { where: { id } });
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
			include: ["Gender", "Role"],
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
		console.log(error);
		return res.status(500).send("Internal error");
	}
});

module.exports = router;
