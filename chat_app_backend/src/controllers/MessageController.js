const Hash = require('../utils/hash');
const MessageRepository = require('../repositories/MessageRepository');
const PushNotification = require('./PushNotificationController');

class MessageController {

    async send(req, res) {
        try {

            const { to, text } = req.body;
            if (!to || !text) {
                return res.json({
                    error: true,
                    errorMessage: "Dados invalidos"
                })
            }
            const from = req._id;
            const lowerId = from < to ? from : to;
            const higherId = from > to ? from : to;

            const chatId = Hash(lowerId, higherId);

            const message = await MessageRepository.create({
                chatId,
                from,
                to,
                text
            });

            await message.populate('from').populate('to').execPopulate();

            const myName = message.from.name;
            const fcmToken = message.to.fcmToken;

            if (fcmToken) {
                PushNotification.send(myName, text, fcmToken);
            }

            return res.json({
                message,
            })



        } catch (e) {
            return res.json({
                error: true,
                errorMessage: e
            })
        }
    }

    async get(req, res) {
        try {

            const myId = req._id;

            const messages = await MessageRepository.get(myId);

            messages.forEach(message => {
                MessageRepository.setTriedToGet(message._id);
            })

            return res.json({
                messages
            })

        } catch (e) {
            return res.json({
                error: true,
                errorMessage: e
            })
        }
    }

    async delete(req, res) {
        try {

            const messageId = req.params.id;
            const myId = req._id;

            await MessageRepository.delete(messageId, myId);

            return res.json({
                success: true
            })

        } catch (e) {
            return res.json({
                error: true,
                errorMessage: e
            })
        }
    }

    async deleteReceivedMessages(req, res) {
        try {

            const myId = req._id;

            await MessageRepository.deleteReceivedMessages(myId);

            return res.json({
                success: true
            })

        } catch (e) {
            console.error(e);
            return res.json({
                error: true,
                e
            })
        }
    }

}

module.exports = new MessageController();