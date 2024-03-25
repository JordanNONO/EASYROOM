const router = require("express").Router();
const db = require("../../models");
const multer = require("multer")
const { protect } = require("../../auth/auth");
const {
	ValidateField,
	ValidateParams,
} = require("../../middlewares/validation");
var storage = multer.diskStorage({
	destination: function (req, file, cb) {
	  cb(null, 'uploads/')
	},
	filename: function (req, file, cb) {
	  cb(null, new Date().getTime()+"."+ /\.([^.]+)$/.exec(file.originalname)[1]) //Appending .jpg
	}
  })
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

router.get("/", protect(), async (_req, res) => {
	try {
		const houses = []
		const house = await db.House.findAll({
			include: ["User"],
			raw: true,
		});
		for (const key in house) {
			if (Object.hasOwnProperty.call(house, key)) {
				const getHouse = house[key];
				const images = await db.House_images.findAll({ where: { house_id: getHouse?.id }, raw: true }) ?? []
				const options = await db.House_option.findAll({ where: { house_id: getHouse?.id }, raw: true }) ?? []
				/* const fImages = []
				for (const iK in images) {
					if (Object.hasOwnProperty.call(images, iK)) {
						const image = images[iK];
						fImages.push({...image,image:`http://192.168.1.71:4500/upload/${image}`})
					}
				} */
				houses.push({ ...getHouse, has_bathroom:getHouse.has_bathroom===1,has_kitchen:getHouse.has_kitchen===1, is_rent:getHouse.is_rent===1, images, options })

			}
		}

		return res.status(200).json(houses);


	} catch (error) {
		console.log(error)
		return res.status(500).send("Internal error");
	}
});



router.post(
	'/add',
	protect(),
	upload.array("images"),
	//ValidateField,
	async (req, res) => {
		try {
			const { title, location, price, bedrooms, bathrooms, description, kitchen } = req.body;
			const images = req.files.map((file) => file.filename);
			const newHouse = await db.House.create({
				label:title,
				location,
				price,
				description,
				nbre_bedroom:bedrooms,
				has_bathroom:bathrooms,
				has_kitchen:kitchen,
				is_rent: false,
				user_id: req.user?.id,
			});
			for (const image of images) {
				await db.House_images.create({image,house_id:newHouse.id})
			}
			return res.status(201).json(newHouse);
			
		} catch (error) {
			
			return res.status(500).send('Internal error');
		}
	}
);

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
