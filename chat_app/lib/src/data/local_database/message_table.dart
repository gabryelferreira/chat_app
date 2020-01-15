import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:sqflite/sqflite.dart';

final String tableMessage = 'tb_message';
final String columnLocalId = 'id_message';
final String columnId = '_id';
final String columnChatId = 'chat_id';
final String columnText = 'text';
final String columnUserId = 'user_id';
final String columnSendAt = 'send_at';
final String columnUnreadByMe = 'unread_by_me';

class MessageTable {

  static Future<void> createTable(Database db) async {
    print("creating it again");
    await db.execute('''
          create table $tableMessage (
            $columnLocalId integer primary key autoincrement, 
            $columnId text not null,
            $columnChatId text not null,
            $columnText text not null,
            $columnUserId text not null,
            $columnSendAt text not null,
            $columnUnreadByMe bool default true,
            constraint ${tableMessage}_user_id_fk foreign key ($columnUserId) references tb_user (_id),
            constraint ${tableMessage}_chat_id_fk foreign key ($columnChatId) references tb_chat (_id))
          ''');
  }
  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists $tableMessage
          ''');
    await MessageTable.createTable(db);
  }


}
