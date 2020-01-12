const UserRepository = require('../repositories/UserRepository');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const jwtConfig = require('../config/jwt');

function generateJwtToken(user){
    const { _id } = user;
    return jwt.sign({
        _id,
    }, jwtConfig.secret);
}


class UserController {

    async create(req, res) {
        try {
            const { name, username, password } = req.body;
            if (!name || !username || !password) {
                return res.json({
                    error: true,
                    errorMessage: "Campos invalidos.",
                })
            }
            const user = {
                name,
                username,
                password,
            }
            const userExists = (await UserRepository.findByUsername(user.username)) != null;
            if (userExists) {
                return res.json({
                    error: true,
                    errorMessage: "Nome de usuario ja cadastrado",
                })
            }
            await UserRepository.create(user);
            const newUser = await UserRepository.findByUsername(user.username);
            const token = generateJwtToken(newUser);
            user.password = undefined;
            return res.json({
                user: newUser,
                token
            })

        } catch (err) {
            return res.json({
                error: true,
                errorMessage: "Ocorreu um erro. Tente novamente.",
                err
            })
        }
    }

    async login(req, res, next){
        try {
            const { username, password } = req.body;
            if (!username || !password) {
                return res.json({ error: true, errorMessage: "Campos invalidos." })
            }
            const user = await UserRepository.findByUsername(username);
            if (!user){
                return res.json({ error: true, errorMessage: "Usuário ou senha inválidos" });
            }
            if (!await bcrypt.compare(password, user.password)){
                return res.json({ error: true, errorMessage: "Usuário ou senha inválidos" });
            }
            const token = generateJwtToken(user);
            user.password = undefined;
            return res.json({
                user,
                token
            });
        } catch (err){
            return res.json({
                error: true,
                errorMessage: err
            })
        }
    }

    async getUsers(req, res) {
        try {
            const myId = req._id;
            const users = await UserRepository.getUsersWhereNot(myId);
            return res.json({
                users
            });
        } catch (err) {
            return res.json({
                error: true,
                errorMessage: err
            })
        }
    }

    async saveFcmToken(req, res) {
        try {
            const { fcmToken } = req.body;
            console.log("fcmToken = ", fcmToken);
            const myId = req._id;
            console.log("myId", myId);
            const myUser = await UserRepository.saveUserFcmToken(myId, fcmToken);
            return res.json({
                user: myUser
            })
        } catch (err) {
            return res.json({
                error: true,
                errorMessage: err
            })
        }
    }


}

module.exports = new UserController();