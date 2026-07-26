const router = require("express").Router();
const db = require("../../models");
const multer = require("multer")
const { protect, optionalAuth } = require("../../auth/auth");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");
const { Sequelize, where, Op } = require("sequelize");
/* const { admin } = require("../../lib/firebase"); */
const cloudinary  =require("cloudinary");
const { geocodeAddress } = require("../../lib/geocoding");
const { getLimogesStops } = require("../../lib/limoges-data");
const { nearestStop } = require("../../lib/geo");

function slugify(text) {
	return String(text ?? "house")
		.toLowerCase()
		.normalize("NFD")
		.replace(/[̀-ͯ]/g, "")
		.replace(/[^a-z0-9]+/g, "-")
		.replace(/(^-|-$)/g, "") || "house";
}

cloudinary.config({
	cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
	api_key: process.env.CLOUDINARY_API_KEY,
	api_secret: process.env.CLOUDINARY_API_SECRET,
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

// Récupère images/options/favori pour un lot de maisons en 3 requêtes au total
// (au lieu d'aller-retours par maison), et ne considère comme "favori" que celui
// de l'utilisateur courant.
async function attachHouseExtras(houses, userId) {
	const houseIds = houses.map((h) => h.id ?? h["id"]).filter(Boolean);
	if (houseIds.length === 0) return [];

	const [images, options, favorites, stops] = await Promise.all([
		db.House_images.findAll({ where: { house_id: { [Op.in]: houseIds } }, raw: true }),
		db.House_option.findAll({ where: { house_id: { [Op.in]: houseIds } }, raw: true }),
		userId
			? db.Favorite.findAll({ where: { user_id: userId, house_id: { [Op.in]: houseIds } }, raw: true })
			: [],
		getLimogesStops(),
	]);

	const imagesByHouse = new Map();
	for (const image of images) {
		if (!imagesByHouse.has(image.house_id)) imagesByHouse.set(image.house_id, []);
		imagesByHouse.get(image.house_id).push(image);
	}
	const optionsByHouse = new Map();
	for (const option of options) {
		if (!optionsByHouse.has(option.house_id)) optionsByHouse.set(option.house_id, []);
		optionsByHouse.get(option.house_id).push(option);
	}
	const favoritedHouseIds = new Set(favorites.map((f) => f.house_id));

	return houses.map((house) => ({
		...house,
		has_bathroom: house.has_bathroom === 1 || house.has_bathroom === true,
		has_kitchen: house.has_kitchen === 1 || house.has_kitchen === true,
		is_rent: house.is_rent === 1 || house.is_rent === true,
		images: imagesByHouse.get(house.id) ?? [],
		options: optionsByHouse.get(house.id) ?? [],
		favorite: favoritedHouseIds.has(house.id),
		nearest_stop: nearestStop(house.latitude, house.longitude, stops),
	}));
}

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

router.get("/recommanded", optionalAuth(), async (req, res) => {
	try {
		const popularHouses = await db.House.findAll({
			include: [{ association: 'User', attributes: { exclude: ['password'] } }],
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

		const Houses = await attachHouseExtras(
			popularHouses.map((h) => h.toJSON()),
			req.user?.id,
		);

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

router.get("/", optionalAuth(), async (req, res) => {
	try {
		const city = req.query.city || "Limoges";
		const house = await db.House.findAll({
			include: [{ association: "User", attributes: { exclude: ["password"] } }],
			where: {
				status: "published",
				[Op.or]: [{ city }, { city: null }],
			},
			raw: true,
		});
		const houses = await attachHouseExtras(house, req.user?.id);
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

router.get("/me", protect(), async (req, res) => {
	try {
		const house = await db.House.findAll({
			include: [{ association: "User", attributes: { exclude: ["password"] } }],
			where: { user_id: req.user.id },
			raw: true,
		});
		const houses = await attachHouseExtras(house, req.user.id);
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
			slug: `${slugify(title)}-${Date.now()}`,
		});

		const geocoded = await geocodeAddress(location);
		if (geocoded) {
			await newHouse.update({ ...geocoded, geocoding_status: "ok" });
		} else {
			await newHouse.update({ geocoding_status: "failed" });
		}

		await Promise.all(
			images.map(async (image) => {
				try {
					const result = await cloudinary.v2.uploader.upload("./uploads/" + image.filename);
					await db.House_images.create({ image: result.secure_url, house_id: newHouse.id });
				} catch (error) {
					console.log(error);
				}
			}),
		);

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
		const { label, location, map_location, price, description, nbre_bedroom, has_bathroom, has_kitchen } = req.body;
		const updates = { label, location, map_location, price, description, nbre_bedroom, has_bathroom, has_kitchen };

		if (location) {
			const geocoded = await geocodeAddress(location);
			updates.geocoding_status = geocoded ? "ok" : "failed";
			if (geocoded) Object.assign(updates, geocoded);
		}

		const newHouse = await db.House.update(updates, {
			where: { id: req.params.id, user_id: req.user?.id },
		});
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


router.get("/search", optionalAuth(), async (req, res) => {
	try {
		const { q } = req.query;
		const city = req.query.city || "Limoges";
		const house = await db.House.findAll({
			where: {
				label: { [Op.like]: `%${q ?? ""}%` },
				status: "published",
				[Op.or]: [{ city }, { city: null }],
			},
			include: [{ association: "User", attributes: { exclude: ["password"] } }],
			raw: true,
		});
		const houses = await attachHouseExtras(house, req.user?.id);

		return res.status(200).json(houses);
	} catch (error) {
		return res.status(500).send("Internal error");
	}

})

// IMPORTANT: doit rester la dernière route GET du fichier — un paramètre générique
// ":id" enregistré plus tôt intercepterait les routes littérales ci-dessus
// (/recommanded, /me, /search).
router.get("/:id", optionalAuth(), async (req, res) => {
	try {
		const house = await db.House.findOne({
			where: { id: req.params.id, status: "published" },
			include: [{ association: "User", attributes: { exclude: ["password"] } }],
			raw: true,
		});
		if (!house) {
			return res.status(404).json({ message: "House not found" });
		}
		const [enriched] = await attachHouseExtras([house], req.user?.id);
		return res.status(200).json(enriched);
	} catch (error) {
		console.log(error);
		return res.status(500).send("Internal error");
	}
});

module.exports = router;
