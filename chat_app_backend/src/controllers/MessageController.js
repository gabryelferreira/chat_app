const Hash = require('../utils/hash');
const MessageRepository = require('../repositories/MessageRepository');
const PushNotification = require('./PushNotificationController');
const shared = require('../shared/index');

class MessageController {

    async send(req, res) {
        try {

            const { to, message } = req.body;
            if (!to || !message) {
                return res.json({
                    error: true,
                    errorMessage: "Dados invalidos"
                })
            }
            const from = req._id;
            const lowerId = from < to ? from : to;
            const higherId = from > to ? from : to;

            const chatId = Hash(lowerId, higherId);

            const sentMessage = await MessageRepository.create({
                chatId,
                from,
                to,
                message
            });

            await sentMessage.populate('from').populate('to').execPopulate();

            const myName = sentMessage.from.name;
            const fcmToken = sentMessage.to.fcmToken;

            if (fcmToken) {
                PushNotification.send(myName, message, fcmToken, { chatId });
            }

            const users = shared.users;
            const findUsers = users.filter(user => user._id == to);
            findUsers.forEach(user => {
                user.socket.emit('message', {
                    message: sentMessage
                });
            })

            return res.json({
                message: sentMessage,
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

    async getMessagesAndEmit(user) {
        try {

            const myId = user._id;

            const messages = await MessageRepository.get(myId);

            messages.forEach(message => {
                MessageRepository.setTriedToGet(message._id);
                user.socket.emit('message', { message });
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