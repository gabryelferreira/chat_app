const mongoose = require('mongoose');

const MessageSchema = mongoose.Schema({
    chatId: {
        type: String,
        required: true,
    },
    userId: {
        type: String,
        required: true,
    },
    text: {
        type: String,
        required: true,
    },
    sendAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Messages', MessageSchema);
