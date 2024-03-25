const { protect } = require("../../auth/auth")
const db = require("../../models")

const router = require("express").Router()

router.get("/",protect(),async(req,res)=>{
    try {
        const reservation = await db.Reservation.findAll({where:{user_id:req.user.id}})
        return res.status(200).json(reservation);
    } catch (error) {
        return res.status(500).send("Internal error")
    }
})

router.post("/set",protect(),async(req,res)=>{
    
})