import 'package:chat_app/src/data/local_database/message_table.dart';
import 'package:chat_app/src/data/local_database/user_table.dart';
import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/models/user.dart';
import 'package:sqflite/sqflite.dart';

import 'chat_table.dart';

final String tableChat = 'tb_chat';
final String columnLocalId = 'id_chat';
final String columnId = '_id';
final String columnMyId = 'my_id';
final String columnOtherUserId = 'other_user_id';

class LocalDatabase {
  Database db;

  Future open(String path) async {
    print("creating db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await UserTable.createTable(db);
        await ChatTable.createTable(db);
        await MessageTable.createTable(db);
      },
      onOpen: (Database db) async {
        await UserTable.recreateTable(db);
        await ChatTable.recreateTable(db);
        await MessageTable.recreateTable(db);
      },
    );
  }

  Future<User> createUser(User user) async {
    await db.insert('tb_user', user.toLocalDatabaseMap());
    return user;
  }

  Future<Chat> insert(Chat chat) async {
    await db.insert(tableChat, chat.toLocalDatabaseMap());
    final users = await db.rawQuery("SELECT * FROM tb_user");
    if (users.length > 0) {
      users.forEach((user) {
        print("userrrr $user");
      });
    }
    print("chat atual ${chat.toLocalDatabaseMap()}");
    final chats = await db.rawQuery('''
      SELECT * FROM tb_chat
      INNER JOIN tb_user
        ON tb_chat.user_id = tb_user._id
    ''');
    if (chats.length > 0) {
      chats.forEach((chat) {
        // print("chattttt $chat");
      });
    }
    return chat;
  }

  Future<Message> addMessage(Message message) async {
    await db.insert('tb_message', message.toLocalDatabaseMap());
    final chats = await db.rawQuery('''
      SELECT * FROM tb_chat
      INNER JOIN tb_user
        ON tb_chat.user_id = tb_user._id
    ''');
    if (chats.length > 0) {
      chats.forEach((chat) async {
        print("chat = $chat");
        final chatMessages = await db.rawQuery('''
          SELECT * FROM tb_message
          WHERE chat_id = '${message.chatId}'
        ''');
        if (chatMessages.length > 0) {
          print("chatMessages = $chatMessages");
        }
      });
    }
    return message;
  }

  Future<Chat> getChat(String id) async {
    List<Map> maps = await db.query(tableChat,
        columns: [columnId], where: '$columnId = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Chat.fromLocalDatabaseMap(maps.first);
    }
    return null;
  }

  Future<List<Chat>> getChats() async {
    List<Map> maps = await db.query(tableChat);
    if (maps.length > 0) {
      return maps.map((chat) => Chat.fromLocalDatabaseMap(chat)).toList();
    }
    return [];
  }

  Future<int> delete(String id) async {
    return await db.delete(tableChat, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Chat chat) async {
    return await db.update(tableChat, chat.toLocalDatabaseMap(),
        where: '$columnId = ?', whereArgs: [chat.id]);
  }
}
