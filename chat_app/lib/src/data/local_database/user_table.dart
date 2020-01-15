import 'package:sqflite/sqflite.dart';

final String tableUser = 'tb_user';
final String columnLocalId = 'id_user';
final String columnId = '_id';
final String columnName = 'name';
final String columnUsername = 'username';

class UserTable {

  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists $tableUser
        ''');
    await UserTable.createTable(db);
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
          create table $tableUser (
            $columnLocalId integer primary key autoincrement, 
            $columnId text not null,
            $columnName text not null,
            $columnUsername text not null)
          ''');
  }

}
