const express = require('express');
const router = express.Router();

const UserController = require('./controllers/UserController');
const MessageController = require('./controllers/MessageController');

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

router.post('/message', [middlewares.user], MessageController.send);
router.get('/message', [middlewares.user], MessageController.get);
router.delete('/message', [middlewares.user], MessageController.deleteReceivedMessages);
router.delete('/message/:id', [middlewares.user], MessageController.delete);

router.post('/fcm-token', [middlewares.user], UserController.saveFcmToken);

module.exports = router;