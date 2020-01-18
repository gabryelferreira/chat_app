import 'package:sqflite/sqflite.dart';
class UserTable {

  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists tb_user
        ''');
    await UserTable.createTable(db);
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
          create table tb_user (
            id_user integer primary key autoincrement, 
            _id text not null,
            name text not null,
            username text not null)
          ''');
    await db.execute('''
      CREATE UNIQUE INDEX idx_id_user
      ON tb_user (_id)
    ''');
  }

}
