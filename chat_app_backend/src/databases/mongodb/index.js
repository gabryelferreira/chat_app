const mongoose = require('mongoose');

const mongoUser = "aeae";
const mongoPassword = "aeae";

const mongoUri = `mongodb+srv://${mongoUser}:${mongoPassword}@cluster0-hbf1g.mongodb.net/chat_app?retryWrites=true&w=majority`;
const mongoUriLocal = 'mongodb://localhost:27017/nutring';

module.exports = {
    
    async connect(){
        try {
            await mongoose.connect(mongoUri, {
                useNewUrlParser: true,
                useUnifiedTopology: true,
                useCreateIndex: true
            })
            console.log("Connected to MongoDB");
        } catch (e){
            console.error("Authentication failed for MongoDB");
        }
    }

}
