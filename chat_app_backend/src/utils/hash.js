const crypto = require('crypto');
const secret = require('../config/sha1').secret;

module.exports = (lowerUserId, higherUserId) =>
    crypto.createHmac('sha1', secret).update(`${lowerUserId}_user-divider_${higherUserId}`).digest('hex');