const ChatRepository = require('../repositories/ChatRepository');
const ObjectId = require('mongoose').Types.ObjectId;
const shared = require('../shared/index');
const PushNotificationController = require('./PushNotificationController');


function formatChatMessageTime(chat) {
    chat.messages = chat.messages.map(message => {
        message.createdAt = new Date(message.createdAt).getTime();
        return message;
    });
    return chat;
}

class ChatController {

    async getChats(req, res) {
        try {
            const myId = req._id;
            const chats = await ChatRepository.getUserChats(myId);
            const formattedChats = chats.map(formatChatMessageTime);
            return res.json({
                chats: formattedChats
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
            const isLowerIdUser = chat.lowerId._id == myId;
            const messageId = ObjectId();
            const message = {
                _id: messageId,
                userId: ObjectId(myId),
                text,
                createdAt: Date.now(),
                unreadByLowerIdUser: isLowerIdUser ? false : true,
                unreadByHigherIdUser: isLowerIdUser ? true : false,
            }
            chat.messages.push(message);
            const users = shared.users;
            const findUsers = users.filter(user => (user._id == chat.lowerId._id || user._id == chat.higherId._id) && user._id != myId);
            findUsers.forEach(user => {
                user.socket.emit('message', chat);
            })
            chat.save();
            let userFcmToken;
            let myName;
            if (isLowerIdUser) {
                userFcmToken = chat.higherId.fcmToken;
                myName = chat.lowerId.name;
            } else {
                userFcmToken = chat.lowerId.fcmToken;
                myName = chat.higherId.name;
            }
            console.log("fcmToken para mandar notificacao", userFcmToken);
            if (userFcmToken) {
                PushNotificationController.sendNotification(myName, text, userFcmToken);
            }

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

    async readChat(req, res) {
        try {
            const chatId = req.params.chatId;
            const myId = req._id;
            const chat = await ChatRepository.getChatById(chatId);
            const isLowerIdUser = chat.lowerId._id == myId;
            const messages = chat.messages.map(message => {
                if (isLowerIdUser) {
                    message.unreadByLowerIdUser = false;
                } else {
                    message.unreadByHigherIdUser = false;
                }
                return message;
            });

            const updatedChat = await ChatRepository.updateChatMessages(chat._id, messages);

            const formatedChat = formatChatMessageTime(updatedChat);

            return res.json({
                chat: formatedChat
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