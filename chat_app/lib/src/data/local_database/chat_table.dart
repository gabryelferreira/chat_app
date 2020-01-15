import 'package:sqflite/sqflite.dart';

final String tableChat = 'tb_chat';
final String columnLocalId = 'id_chat';
final String columnId = '_id';
final String columnuserId = 'user_id';

class ChatTable {
  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists $tableChat
        ''');
    await ChatTable.createTable(db);
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
          create table $tableChat (
            $columnLocalId integer primary key autoincrement, 
            $columnId text not null,
            $columnuserId text not null,
            constraint ${tableChat}_user_id_fk foreign key ($columnuserId) references tb_user (_id))
          ''');
  }
}
