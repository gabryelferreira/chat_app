const ChatRepository = require('../repositories/ChatRepository');
const ObjectId = require('mongoose').Types.ObjectId;
const Dates = require('../utils/dates');


class ChatController {

    async getChatByUserId(req, res) {
        try {
            const userId = req.params.userId;
            const myId = req._id;

            const lowerId = userId < myId ? userId : myId;
            const higherId = userId > myId ? userId : myId;

            let chat = await ChatRepository.getChatByUsersIds({
                lowerId,
                higherId
            });

            if (!chat) {
                chat = await ChatRepository.create({
                    lowerId,
                    higherId
                });
            }

            return res.json({
                chat
            });

        } catch (err) {
            return res.json({
                error: true,
                errorMessage: "Ocorreu um erro. Tente novamente.",
                err
            })
        }
    }
    async getChats(req, res) {
        try {
            const myId = req._id;
            const chats = await ChatRepository.getUserChats(myId);
            return res.json({
                chats
            });
        } catch (err) {
            return res.json({
                error: true,
                errorMessage: err
            })
        }
    }

    async sendMessage(req, res) {
        try {
            const chatId = req.params.chatId;
            const myId = req._id;
            const { text } = req.body;
            if (!text || !text.trim()) {
                return res.json({
                    error: true,
                    errorMessage: "A mensagem e obrigatoria."
                })
            }
            const chat = await ChatRepository.getChatById(chatId);
            const datetime = Dates.getDateTime();
            const messageId = ObjectId();
            chat.messages.push({
                _id: messageId,
                userId: ObjectId(myId),
                text,
                createdAt: datetime
            })
            console.log("chat agora = ", chat);
            chat.save();
            return res.json({
                chat
            })
        } catch (err) {
            console.error(err);
            return res.json({
                error: true,
                errorMessage: err
            })
        }
    }


}

module.exports = new ChatController();