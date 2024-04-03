const { Op } = require("sequelize")
const { protect } = require("../../auth/auth")
const { ValidateField } = require("../../middlewares/validation")
const db = require("../../models")

const router = require("express").Router()

router.get("/",protect(),async(req,res)=>{
    try {
        const reservation = await db.Reservation.findAll({where:{user_id:req.user.id},include:["User","House"]})
        return res.status(200).json(reservation);
    } catch (error) {
        return res.status(500).send("Internal error")
    }
})

/**
 * @swagger
 * /api/v1/reservation/set:
 *   post:
 *     description: Create or set a reservation for a house
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               house_id:
 *                 type: integer
 *               
 *     responses:
 *       201:
 *         description: Successfully created a new reservation
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 state:
 *                   type: string
 *                 message:
 *                   type: string
 *       400:
 *         description: A reservation for the given house by the user already exists
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 state:
 *                   type: string
 *                 message:
 *                   type: string
 *       500:
 *         description: Internal server error
 */

router.post("/set", ValidateField, protect(), async (req, res) => {
    try {
        const getReservation = await db.Reservation.findOne({
            where: {
                [Op.and]: [
                    { house_id: req.body?.house_id },
                    { user_id: req.user?.id }
                ]
            }
        });
        if (!getReservation) {
            await db.Reservation.create({ ...req.body, visite_date:req.body?.date, user_id: req.user.id });
            return res.status(201).json({
                state: "SUCCESS",
                message: "Reservation was created"
            });
        } else {
            return res.status(400).json({
                state: "ERROR",
                message: "Reservation already exists"
            });
        }
    } catch (error) {
        return res.status(500).send("Internal error");
    }
});

module.exports = router
