import 'package:sqflite/sqflite.dart';

class ChatTable {
  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists tb_chat
        ''');
    await ChatTable.createTable(db);
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
          create table tb_chat (
            id_chat integer primary key autoincrement,
            _id text not null,
            user_id text not null,
            constraint tb_chat_user_id_fk foreign key (user_id) references tb_user (_id))
          ''');
    await db.execute('''
      create unique index idx_id_chat
      on tb_chat (_id)
    ''');
  }
}
