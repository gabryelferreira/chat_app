require('dotenv').config()
const express = require('express');
const cors = require('cors');
const mongoDB = require('./src/databases/mongodb/index');
const socketIO = require('socket.io');
const shared = require('./src/shared');

const app = express();

app.use(express.json());
app.use(cors());

const server = require('http').createServer(app);
const io = socketIO(server);
shared.io = io;

let users = [];
shared.users = users;

io.on('connection', socket => {
    socket.on("user-in", (user) => {
        users.push({ ...user, socket });
        shared.users = users;
        console.log("users now", users);
    });
    
    socket.on("user-left", () => {
        users = users.filter(x => x.socket.id !== socket.id);
        shared.users = users;
        console.log("user left", users);
    });

    socket.on("disconnect", () => {
        users = users.filter(x => x.socket.id !== socket.id);
        shared.users = users;
        console.log("user disconnected", users);
    });

});

app.use('/', require('./src/routes'));

server.listen('8081', () => {
    console.log("Listening on port 8081");
    mongoDB.connect();
});