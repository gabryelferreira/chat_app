const Message = require('../models/MessageModel');
const ObjectId = require('mongoose').Types.ObjectId;

class MessageRepository {

    async create({ chatId, from, to, message }) {
        return await Message.create({
            chatId,
            from,
            to,
            message,
        });
    }

    async get(userId) {
        return await Message.find({ to: ObjectId(userId) }).populate('from').populate("to");
    }

    async setTriedToGet(_id) {
        await Message.findByIdAndUpdate(_id, {
            $set: {
                triedToGet: true
            }
        })
    }

    async delete(_id, userId) {
        await Message.findOneAndDelete({ _id, to: ObjectId(userId) });
    }

    async deleteReceivedMessages(myId) {
        await Message.deleteMany({ to: ObjectId(myId), triedToGet: true });
    }


}

module.exports = new MessageRepository();