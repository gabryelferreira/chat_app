const mongoose = require('mongoose');
const ObjectId = mongoose.Schema.Types.ObjectId;

const MessageSchema = mongoose.Schema({
    chatId: {
        type: String,
        required: true,
    },
    from: {
        type: ObjectId,
        required: true,
        ref: 'User',
    },
    to: {
        type: ObjectId,
        required: true,
        ref: 'User',
    },
    text: {
        type: String,
        required: true,
    },
    triedToGet: {
        type: Boolean,
        default: false,
        select: false,
    },
    sendAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Message', MessageSchema);
