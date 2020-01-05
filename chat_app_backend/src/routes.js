const express = require('express');
const router = express.Router();

const UserController = require('./controllers/UserController');

router.get('/', (req, res) => {
    return res.json({
        warn: "me",
    })
});

router.post('/auth', UserController.login);

router.post('/user', UserController.create);

module.exports = router;