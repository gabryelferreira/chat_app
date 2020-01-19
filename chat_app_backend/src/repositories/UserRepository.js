const User = require('../models/UserModel');
const ObjectId = require('mongoose').Types.ObjectId;

class UserRepository {

    async create({ name, username, password }) {
        await User.create({
            name,
            username,
            password,
        });
    }

    async findByUsername(username) {
        return await User.findOne({ username }).select({ 'name': 1, 'username': 1, 'password': 1 });
    }

    async getUsersWhereNot(userId) {
        return await User.find({ _id: { $ne: ObjectId(userId) } });
    }

    async getUserByName(myId, name) {
        return await User.find({
            _id: { $ne: ObjectId(myId), name }
        });
    }

    async saveUserFcmToken(userId, fcmToken) {
        return await User.updateOne({ _id: ObjectId(userId) }, {
            fcmToken
        });
    }


}

module.exports = new UserRepository();