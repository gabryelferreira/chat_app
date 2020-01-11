const ChatRepository = require('../repositories/ChatRepository');
const ObjectId = require('mongoose').Types.ObjectId;
const Dates = require('../utils/dates');
const shared = require('../shared/index');


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
                chat = await ChatRepository.getChatById(chat._id);
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
        console.log("entrei aqui no getChats");
        try {
            const myId = req._id;
            console.log("myId", myId);
            const chats = await ChatRepository.getUserChats(myId);
            console.log("peguei os chats", chats);
            return res.json({
                chats
            });
        } catch (err) {
            console.error(err);
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
            const message = {
                _id: messageId,
                userId: ObjectId(myId),
                text,
                createdAt: datetime
            }
            chat.messages.push(message);
            const users = shared.users;
            const findUsers = users.filter(user => (user._id == chat.lowerId._id || user._id == chat.higherId._id) && user._id != myId);
            console.log("findUsers", findUsers);
            findUsers.forEach(user => {
                console.log("emitindo", {
                    ...chat,
                    messages: chat.messages,
                });
                console.log("emitindo para user com socket", user.socket.id);
                user.socket.emit('message', chat);
            })

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