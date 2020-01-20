# FalaComigo
A fully working chat app made with Flutter, Node.js, Socket.io, MongoDB, SQLite and Firebase Messaging.

## Setup the project

To run the project in your local machine, you first need to setup some stuffs:

- Flutter in your path;
- node/npm;
- Create a cluster in MongoDB Atlas and change the `.env` file to your database credentials and some JWT secret.
- In the `chat_app/lib/src/utils/my_urls.dart` file, you will probably need to change the serverUrl to your ethernet adapter + server port (in this case, if you didnt change, 8081). You can find the ethernet adapter in Windows opening the CMD and typing `ipconfig`. Its probably the first IPv4 address. The final result will be something like `http://192.168.0.17:8081`.

## Running the project

After that, to run the mobile app, type `cd chat_app && flutter pub get` in project's directory and `flutter run` (Be sure to have a running emulator).

To run the backend, in project's directory, type `cd chat_app_backend && npm i` and, after that, `npm run dev`.


