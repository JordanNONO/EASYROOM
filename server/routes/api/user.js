const { hashSync, compareSync } = require("bcryptjs");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");
const db = require("../../models");
const jwt = require("jsonwebtoken");
const { protect } = require("../../auth/auth");
const { Op, where } = require("sequelize");
const router = require("express").Router();

/**
 * @swagger
 * /api/v1/user/me:
 *   get:
 *     description: Get the authenticated user profile
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successfully retrieved the user profile
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: integer
 *                 name:
 *                   type: string
 *                 contact:
 *                   type: string
 */

router.get("/me", protect(), (req, res) => {
	const { password, ...rest } = req.user;
	return res.status(200).json(rest);
});

/**
 * @swagger
 * /api/v1/user/add:
 *   post:
 *     description: Register a new user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               contact:
 *                 type: string
 *               password:
 *                 type: string
 *               name:
 *                 type: string
 *               lastname:
 *                 type: string
 *     responses:
 *       201:
 *         description: Successfully registered a new user
 *       500:
 *         description: Internal server error
 */

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

/**
 * @swagger
 * /api/v1/user/update/{id}:
 *   post:
 *     description: Update a user by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               contact:
 *                 type: string
 *               password:
 *                 type: string
 *               name:
 *                 type: string
 *               lastname:
 *                 type: string
 *     responses:
 *       200:
 *         description: Successfully updated the user
 *       500:
 *         description: Internal server error
 */

router.post("/update/:id", protect(), ValidateField, ValidateParams, async (req, res) => {
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
});

/**
 * @swagger
 * /api/v1/user/rent-house:
 *   post:
 *     description: Mark a user as renting a house
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successfully updated the user's rent status
 *       500:
 *         description: Internal server error
 */

router.post("/rent-house", protect(), async (req, res) => {
	try {
		const id = req.user?.id;
		await db.User.update({ ren_house: true }, { where: { id } });
		return res.status(200).json({ state: "SUCCESS" });
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});

/**
 * @swagger
 * /api/v1/user/login:
 *   post:
 *     description: Authenticate a user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               contact:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Successfully authenticated the user and returned a token
 *       400:
 *         description: Incorrect login information
 *       500:
 *         description: Internal server error
 */

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

router.get("/me/rdv", protect(), async (req, res) => {
	try {
		const userId = req.user.id;  // Get user_id from authenticated user

		const rdv = await db.Reservation.findAll({
			where: {
				[Op.or]: [
					{ '$House.user_id$': userId },
				]
			},
			include: [{
				model: db.House,

				where: {
					[Op.or]: [
						{ user_id: userId },
					]
				}
			}, { model: db.User }]
		});

		res.status(200).json(rdv);
	} catch (error) {
		console.error(error);
		res.status(500).json({ message: 'Internal server error' });
	}
});

router.get("/gender", async (req, res) => {
	try {
		const genders = await db.Gender.findAll({ raw: true })
		return res.status(200).json(genders)
	} catch (error) {
		console.error(error);
		res.status(500).json({ message: 'Internal server error' });
	}
})


router.post("/suscribe", ValidateField, protect(), async (req, res) => {
	try {
		const { token } = req.body
		const existSuscribe = await db.Notification_suscriber.findOne({ where: { user_id: req.user.id }, raw: true });
		if (!existSuscribe) {
			await db.Notification_suscriber.create({ token, user_id: req.user.id })
			return res.status(201)
		} else {
			await db.Notification_suscriber.update({ token }, { where: { user_id: req.user.id } })
			return res.status(201)
		}
		return res.status(403)
	} catch (error) {
		return res.status(500).send(error)
	}
})
router.get("/:id", protect(), async (req, res) => {
	try {
		const user = await db.User.findOne({ where: { id: req.params.id } });
		return res.status(200).json(user)
	} catch (error) {
		return res.status(500).send("Internal error")
	}
})

module.exports = router;
