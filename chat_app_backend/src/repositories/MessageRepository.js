const Message = require('../models/MessageModel');

class ChatRepository {

    async create({ chatId, userId, text, userToReceive, sendAt }) {
        return await Message.create({
            chatId,
            userId,
            text,
            sendAt,
            userToReceive,
        });
    }


}

module.exports = new ChatRepository();