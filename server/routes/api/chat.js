const express = require('express');
const router = express.Router();
const db = require('../../models');
const { protect } = require('../../auth/auth');
const { ValidateField } = require('../../middlewares/validation');
// Récupérer tous les messages d'un chat spécifique
router.get('/:houseId', protect(), async (req, res) => {
  try {
    const { houseId } = req.params;
    
    const chats = await db.Chat.findAll({
      where: { house_id: houseId, },
      include: [
        { model: db.User, as: 'Sender', attributes: ['id', 'name', 'lastname'] },
        { model: db.User, as: 'Receiver', attributes: ['id', 'name', 'lastname'] },
        { model: db.House, as:"House", attributes: ['id', 'label', 'location'] }
      ]
    });

    res.status(200).json(chats);

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

// Ajouter un nouveau message au chat
router.post('/add',protect(),ValidateField, async (req, res) => {
  try {
    const { receiver_id, message, house_id } = req.body;

    const newChat = await db.Chat.create({
      sender_id:req.user.id,
      receiver_id,
      message,
      house_id,
      is_read: false // Par défaut, le message n'est pas lu
    });

    res.status(201).json({ message: 'Message sent successfully', chat: newChat });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

// Marquer un message comme lu
router.put('/:chatId/mark-as-read', protect(), async (req, res) => {
  try {
    const { chatId } = req.params;

    const chat = await db.Chat.findByPk(chatId);

    if (!chat) {
      return res.status(404).json({ message: 'Chat not found' });
    }

    chat.is_read = true;
    await chat.save();

    res.status(200).json({ message: 'Message marked as read', chat });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

module.exports = router;
