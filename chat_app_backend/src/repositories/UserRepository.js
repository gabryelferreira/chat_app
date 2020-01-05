const User = require('../models/UserModel');

class UserRepository {

    async create({ name, username, password }) {
        await User.create({
            name,
            username,
            password,
        });
    }

    async findByUsername(username){
        return await User.findOne({ username }).select({ 'name': 1, 'username': 1, 'password': 1 });
    }


}

module.exports = new UserRepository();