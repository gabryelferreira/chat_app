const mongoose = require('mongoose');

const mongoUri = process.env.MONGO_CONNECTION_STRING;

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
