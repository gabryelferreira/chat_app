const express = require('express');
const router = express.Router();

const UserController = require('./controllers/UserController');
const ChatController = require('./controllers/ChatController');

const userMiddleware = require('./middlewares/auths/user');

const middlewares = {
    user: userMiddleware
}

router.get('/', (req, res) => {
    return res.json({
        warn: "me",
    })
});

router.post('/auth', UserController.login);

router.post('/user', UserController.create);
router.get('/users', [middlewares.user], UserController.getUsers);

router.get('/chats', [middlewares.user], ChatController.getChats);
// router.get('/chats/user/:userId', [middlewares.user], ChatController.getChatByUserId);
router.post('/chats/:chatId/message', [middlewares.user], ChatController.sendMessage);
router.post('/chats/:chatId/read', [middlewares.user], ChatController.readChat);

router.post('/fcm-token', [middlewares.user], UserController.saveFcmToken);

module.exports = router;