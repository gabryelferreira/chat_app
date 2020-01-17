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

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await _open();
    return _database;
  }

  Future _open() async {
    print("creating db");
    return await openDatabase('fala_comigo.db', version: 1,
        onCreate: (Database db, int version) async {
      await UserTable.createTable(db);
      await ChatTable.createTable(db);
      await MessageTable.createTable(db);
    }, onOpen: (Database db) async {
    });
  }

  Future<Chat> getChat(String id) async {
    final db = await database;
    final chats = await db.rawQuery('''
      SELECT tb_chat._id,
             tb_user._id as user_id,
             tb_user.name,
             tb_user.username
      FROM tb_chat
      INNER JOIN tb_user
        ON tb_chat.user_id = tb_user._id
        WHERE tb_chat._id = '$id'
    ''');
    if (chats.length > 0) {
      return Chat.fromLocalDatabaseMap(chats.first);
    }
    return null;
  }

  Future<User> getUser(String id) async {
    final db = await database;
    final users = await db.rawQuery('''
      SELECT tb_user._id,
             tb_user.name,
             tb_user.username
      FROM tb_user
      WHERE tb_user._id = '$id'
    ''');
    if (users.length > 0) {
      return User.fromLocalDatabaseMap(users.first);
    }
    return null;
  }

  Future<User> createUser(User user) async {
    final db = await database;
    await db.insert('tb_user', user.toLocalDatabaseMap());
    return user;
  }

  Future<Chat> createOrGetChat(Chat chat) async {
    final db = await database;
    final user = await getUser(chat.user.id);
    if (user == null) {
      await createUser(chat.user);
    }
    final chats = await db.rawQuery('''
      SELECT * FROM tb_chat
      WHERE _id = '${chat.id}'
    ''');
    chats.forEach((chat) {
      print("chat $chat");
    });
    if (chats.length == 0) {
      await db.insert('tb_chat', chat.toLocalDatabaseMap());
    }
    return chat;
  }

  // Future<Message> addMessage(Message message) async {
  //   await db.insert('tb_message', message.toLocalDatabaseMap());
  //   final chats = await db.rawQuery('''
  //     SELECT * FROM tb_chat
  //     INNER JOIN tb_user
  //       ON tb_chat.user_id = tb_user._id
  //   ''');
  //   if (chats.length > 0) {
  //     chats.forEach((chat) async {
  //       print("chat = $chat");
  //       final chatMessages = await db.rawQuery('''
  //         SELECT * FROM tb_message
  //         WHERE chat_id = '${message.chatId}'
  //       ''');
  //       if (chatMessages.length > 0) {
  //         print("chatMessages = $chatMessages");
  //       }
  //     });
  //   }
  //   return message;
  // }

  // Future<Chat> getChat(String id) async {
  //   List<Map> maps = await db.query(tableChat,
  //       columns: [columnId], where: '$columnId = ?', whereArgs: [id]);
  //   if (maps.length > 0) {
  //     return Chat.fromLocalDatabaseMap(maps.first);
  //   }
  //   return null;
  // }

  // Future<List<Chat>> getChats() async {
  //   List<Map> maps = await db.query(tableChat);
  //   if (maps.length > 0) {
  //     return maps.map((chat) => Chat.fromLocalDatabaseMap(chat)).toList();
  //   }
  //   return [];
  // }

  // Future<int> delete(String id) async {
  //   return await db.delete(tableChat, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Future<int> update(Chat chat) async {
  //   return await db.update(tableChat, chat.toLocalDatabaseMap(),
  //       where: '$columnId = ?', whereArgs: [chat.id]);
  // }
}
