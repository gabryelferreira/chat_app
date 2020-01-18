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
      // await UserTable.recreateTable(db);
      // await ChatTable.recreateTable(db);
      // await MessageTable.recreateTable(db);
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
    try {
      final db = await database;
      await db.insert('tb_user', user.toLocalDatabaseMap());
      return user;
    } catch (err) {
      print("error $err");
      return user;
    }
  }

  Future<User> createUserIfNotExists(User user) async {
    final _user = await getUser(user.id);
    if (_user == null) {
      await createUser(user);
    }
    return user;
  }

  Future<Chat> createChatIfNotExists(Chat chat) async {
    try {
      final db = await database;
      final chats = await db.rawQuery('''
        SELECT * FROM tb_chat
        WHERE _id = '${chat.id}'
      ''');
      if (chats.length == 0) {
        await db.insert('tb_chat', chat.toLocalDatabaseMap());
      }
      return chat;
    } catch (err) {
      print("error $err");
      return chat;
    }
  }

  Future<List<Message>> getChatMessages(String chatId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT tb_message.id_message,
             tb_message._id,
             tb_message.from_user,
             tb_message.to_user,
             tb_message.message,
             tb_message.send_at,
             tb_message.unread_by_me
      FROM tb_message
      WHERE tb_message.chat_id = '$chatId'
      ORDER BY tb_message.send_at DESC
    ''');
    if (maps.length > 0) {
      return maps
          .map((message) => Message.fromLocalDatabaseMap(message))
          .toList();
    }
    return [];
  }

  Future<void> readChatMessages(String id) async {
    final db = await database;
    await db.rawQuery('''
      UPDATE tb_message
      SET unread_by_me = 0
      WHERE chat_id = '$id'
    ''');
  }

  Future<int> addMessage(Message message) async {
    final db = await database;
    final id = await db.insert('tb_message', message.toLocalDatabaseMap());
    return id;
  }

  Future<List<Chat>> getChatsWithMessages() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT tb_chat._id,
             tb_user._id as user_id,
             tb_user.name,
             tb_user.username,
             tb_message._id as message_id,
             tb_message.from_user,
             tb_message.to_user,
             tb_message.message,
             tb_message.send_at,
             tb_message.unread_by_me
      FROM tb_chat
      INNER JOIN tb_message
        ON tb_chat._id = tb_message.chat_id
      INNER JOIN tb_user
        ON tb_user._id = tb_chat.user_id
      ORDER BY tb_message.send_at DESC
    ''');
    if (maps.length > 0) {
      List<Chat> chats = [];

      maps.toList().forEach((map) {
        if (chats.indexWhere((chat) => chat.id == map['_id']) == -1) {
          chats.add(Chat.fromLocalDatabaseMap(map));
        }
        final chat = chats.firstWhere((chat) => chat.id == map['_id']);
        final message = Message.fromLocalDatabaseMap({
            "_id": map['message_id'],
            "from": map['from_user'],
            "to": map['to_user'],
            "message": map['message'],
            "send_at": map['send_at'],
            "unread_by_me": map['unread_by_me'],
          });
          chat.messages.add(message);

      });

      return chats;
    }

    return [];
  }

  /*

  Future<List<Chat>> getChatsWithMessages() async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT tb_chat._id,
             tb_user._id as user_id,
             tb_user.name,
             tb_user.username,
             (SELECT tb_message.message from tb_message WHERE tb_message.chat_id = tb_chat._id ORDER BY tb_message.send_at DESC LIMIT 1) as last_message,
             (SELECT COUNT(tb_message.unread_by_me) as count from tb_message WHERE tb_message.chat_id = tb_chat._id) as unread_messages,
             (SELECT tb_message.send_at from tb_message WHERE tb_message.chat_id = tb_chat._id ORDER BY tb_message.send_at DESC LIMIT 1) as last_message_send_at
      FROM tb_chat
      INNER JOIN tb_user
        ON tb_user._id = tb_chat.user_id
      ORDER BY last_message_send_at DESC
    ''');
    if (maps.length > 0) {
      List<Chat> chats = maps.map((map) => Chat.fromLocalDatabaseMap(map)).toList();
      return chats;
    }

    return [];
  }

  */

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