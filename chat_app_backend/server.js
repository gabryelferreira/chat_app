const express = require('express');
const cors = require('cors');
const mongoDB = require('./src/databases/mongodb/index');
const socketIO = require('socket.io')

const app = express();

app.use(express.json());
app.use(cors());

const server = require('http').createServer(app);
const io = socketIO(server);

var users = [];

io.on('connection', socket => {
    socket.on("user-in", (user) => {
        users.push({ ...user, socketId: socket.id });
        io.emit("users-update", users);
    });

    socket.on("entered-chat", (socketId) => {
        socket.broadcast.emit("entered-chat", socket.id);
    });

    socket.on("leave-chat", (socketId) => {
        socket.broadcast.emit("leave-chat", socket.id);
    });

    socket.on("message", (data) => {
        socket.broadcast.to(data.to)
            .emit('message', {
                from: socket.id,
                message: data.message,
            });
    });

    socket.on("user-left", () => {
        users = users.filter(x => x.socketId !== socket.id);
        io.emit("users-update", users);
    });

    socket.on("disconnect", () => {
        users = users.filter(x => x.socketId !== socket.id);
        io.emit("users-update", users);
    });

});

app.use('/', require('./src/routes'));

server.listen('8081', () => {
    console.log("Listening on port 8081");
    mongoDB.connect();
});