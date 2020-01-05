# SecretChatApp
A chat app made with Flutter, Node.js, Socket.io and MongoDB.

The intention in making this project is to have a fully private conversation with friends where messages are not stored anywhere and you cant see then after leaving the chat.

## Setup the project

To run the project in your local machine, you first need to setup some stuffs:

- Flutter in your path;
- node/npm;
- Create a cluster in MongoDB Atlas and change the file `src/databases/mongodb/index.js` to your database credentials.

## Running the project

After that, to run the mobile app, type `cd chat_app && flutter pub get` in project's directory and `flutter run` (Be sure to have a running emulator).

To run the backend, in project's directory, type `cd chat_app_backend && npm i` and, after that, `npm run dev`.


