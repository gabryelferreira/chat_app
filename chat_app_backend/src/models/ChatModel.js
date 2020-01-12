const mongoose = require('mongoose');

const ChatSchema = mongoose.Schema({
    lowerId: {
        type: mongoose.Types.ObjectId,
        required: true,
        ref: 'Users'
    },
    higherId: {
        type: mongoose.Types.ObjectId,
        required: true,
        ref: 'Users'
    },
    messages: [],
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Chats', ChatSchema);
