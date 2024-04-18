const router = require("express").Router();
const db = require("../../models");
const multer = require("multer")
const { protect } = require("../../auth/auth");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");
const { Sequelize } = require("sequelize");
/* const { admin } = require("../../lib/firebase"); */
import { v2 as cloudinary } from "cloudinary";

cloudinary.config({
	cloud_name: "dvi66ll0e",
	api_key: "878481519687912",
	api_secret: "d1z6ATAHE2bUNH-cGbU0dLVL3_A",
});
// Configuration de Multer pour l'upload de fichiers
var storage = multer.diskStorage({
	destination: function (req, file, cb) {
		cb(null, 'uploads/')
	},
	filename: function (req, file, cb) {
		cb(null, new Date().getTime() + "." + /\.([^.]+)$/.exec(file.originalname)[1])
	}
});

const upload = multer({
	dest: 'uploads/',
	limits: {
		fileSize: 10000000, // Limite la taille des fichiers à 10 Mo
	},
	storage,
	fileFilter(req, file, cb) {
		if (!file.originalname.match(/\.(jpg|jpeg|png)$/)) {
			return cb(new Error('Veuillez télécharger une image (JPG, JPEG ou PNG).'));
		}
		cb(null, true);
	},
});

/**
 * @swagger
 * /api/v1/house/recommanded:
 *   get:
 *     description: Get recommended houses
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successfully retrieved recommended houses
 */

router.get("/recommanded", protect(), async (req, res) => {
	try {
		const Houses = [];

		const popularHouses = await db.House.findAll({
			include: ['User'],
			attributes: {
				include: [
					[
						Sequelize.literal(`(
                            SELECT COUNT(*)
                            FROM Favorites
                            WHERE Favorites.house_id = House.id
                        )`),
						'favorites_count'
					]
				]
			},
			order: [[Sequelize.literal('favorites_count'), 'DESC']],
			limit: 5
		});

		for (const house of popularHouses) {
			const images = await db.House_images.findAll({ where: { house_id: house.id }, raw: true }) ?? [];
			const options = await db.House_option.findAll({ where: { house_id: house.id }, raw: true }) ?? [];

			// Check if Favorite is not null
			const isFavorite = await db.Favorite.findOne({ where: { house_id: house.id } }) !== null;

			Houses.push({
				...house.dataValues,
				has_bathroom: house.has_bathroom === 1,
				has_kitchen: house.has_kitchen === 1,
				is_rent: house.is_rent === 1,
				images,
				options,
				favorite: isFavorite,
			});
		}

		return res.status(200).json(Houses);
	} catch (error) {
		console.log(error);
		return res.status(500).json({ message: 'Internal server error' });
	}
});

/**
 * @swagger
 * /api/v1/house:
 *   get:
 *     description: Get all houses
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successfully retrieved all houses
 */

router.get("/", protect(), async (_req, res) => {
	try {
		const houses = [];
		const house = await db.House.findAll({
			include: ["User", "Favorite"],
			raw: true,
		});
		for (const key in house) {
			if (Object.hasOwnProperty.call(house, key)) {
				const getHouse = house[key];
				const images = await db.House_images.findAll({ where: { house_id: getHouse?.id }, raw: true }) ?? [];
				const options = await db.House_option.findAll({ where: { house_id: getHouse?.id }, raw: true }) ?? [];

				// Check if Favorite is not null
				const isFavorite = getHouse["Favorite.house_id"] !== null;

				houses.push({
					...getHouse,
					has_bathroom: getHouse.has_bathroom === 1,
					has_kitchen: getHouse.has_kitchen === 1,
					is_rent: getHouse.is_rent === 1,
					images,
					options,
					favorite: isFavorite,
				});
			}
		}

		return res.status(200).json(houses);
	} catch (error) {
		console.log(error);
		return res.status(500).send("Internal error");
	}
});

/**
 * @swagger
 * /api/v1/house/me:
 *   get:
 *     description: Get all houses by user
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Successfully retrieved all houses
 */

router.get("/me", protect(), async (_req, res) => {
	try {
		const houses = [];
		const house = await db.House.findAll({
			include: ["User", "Favorite"],
			where: { user_id: _req.user.id },
			raw: true,
		});
		for (const key in house) {
			if (Object.hasOwnProperty.call(house, key)) {
				const getHouse = house[key];
				const images = await db.House_images.findAll({ where: { house_id: getHouse?.id }, raw: true }) ?? [];
				const options = await db.House_option.findAll({ where: { house_id: getHouse?.id }, raw: true }) ?? [];

				// Check if Favorite is not null
				const isFavorite = getHouse["Favorite.house_id"] !== null;

				houses.push({
					...getHouse,
					has_bathroom: getHouse.has_bathroom === 1,
					has_kitchen: getHouse.has_kitchen === 1,
					is_rent: getHouse.is_rent === 1,
					images,
					options,
					favorite: isFavorite,
				});
			}
		}
		return res.status(200).json(houses);
	} catch (error) {
		console.log(error);
		return res.status(500).send("Internal error");
	}
});

/**
 * @swagger
 * /api/v1/house/add:
 *   post:
 *     description: Add a new house
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               location:
 *                 type: string
 *               price:
 *                 type: number
 *               bedrooms:
 *                 type: number
 *               bathrooms:
 *                 type: boolean
 *               description:
 *                 type: string
 *               kitchen:
 *                 type: boolean
 *               images:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       201:
 *         description: Successfully added a new house
 *       500:
 *         description: Internal server error
 */

router.post('/add', protect(), upload.array("images"), ValidateField, async (req, res) => {
	try {
		const { title, location, price, bedrooms, bathrooms, description, kitchen } = req.body;
		const images = req.files
		const newHouse = await db.House.create({
			label: title,
			location,
			price,
			description,
			nbre_bedroom: bedrooms,
			has_bathroom: bathrooms,
			has_kitchen: kitchen,
			is_rent: false,
			user_id: req.user?.id,
		});
		images.map(async (image) => {
			const result = await cloudinary.uploader.upload(image.buffer.toString('base64'));
			const url = result.secure_url;
			await db.House_images.create({ image: url, house_id: newHouse.id });
		})

		/* const suscribers = await db.Notification_suscriber.findAll({ raw: true });
		const tokens = suscribers.map(t => t.token);
		admin.messaging().sendMulticast({ notification: { title: "Easyroom", body: `Nouvelle publication de maison à ${location}`, imageUrl: `${req.headers.origin}/${images?.[0]?.image},` }, token: tokens }); */
		return res.status(201).json(newHouse);
	} catch (error) {
		console.log(error);
		return res.status(500).send('Internal error');
	}
});

/**
 * @swagger
 * /api/v1/house/update/{id}:
 *   post:
 *     description: Update a house by ID
 *     security:
 *       - bearerAuth: []
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
 *               title:
 *                 type: string
 *               location:
 *                 type: string
 *               price:
 *                 type: number
 *               bedrooms:
 *                 type: number
 *               bathrooms:
 *                 type: boolean
 *               description:
 *                 type: string
 *               kitchen:
 *                 type: boolean
 *     responses:
 *       200:
 *         description: Successfully updated the house
 *       500:
 *         description: Internal server error
 */

router.post("/update/:id", protect(), ValidateField, ValidateParams, async (req, res) => {
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
});

/**
 * @swagger
 * /api/v1/house/delete/{id}:
 *   delete:
 *     description: Delete a house by ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Successfully deleted the house
 *       500:
 *         description: Internal server error
 */

router.delete("/delete/:id", protect(), ValidateField, ValidateParams, async (req, res) => {
	try {
		const { id } = req.params;
		await db.House.destroy({ where: { id, user_id: req.user?.id } });
		return res.status(200).json({ status: "SUCCESS" });
	} catch (error) {
		return res.status(500).send("Internal error");
	}
});

module.exports = router;
