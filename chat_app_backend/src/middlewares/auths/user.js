const jwt = require('jsonwebtoken');
const config = require('../../config/jwt');

module.exports = (req, res, next) => {

    const authHeader = req.headers.authorization;

    if (!authHeader) return res.status(401).json({ error: 'No token provided' });

    const arrayAuth = authHeader.split(' ');
    if (arrayAuth.length != 2 || arrayAuth[0] != 'Bearer') return res.status(401).json({ error: 'The provided token is invalid' });

    const token = arrayAuth[1];
    req.bearerToken = token;
    // return next();
    jwt.verify(token, config.secret, (err, decoded) => {
        if (err){
            let error;
            switch(err.name){
                case 'TokenExpiredError':
                    error = 'Expired token';
                    break;
                default:
                    error = 'Invalid token';
                    break;
            }
            return res.status(400).json({
                error
            })
        }
        req.bearerToken = token;
        req.tokenInfo = decoded;
        req._id = decoded._id;
        next();
    });


}
