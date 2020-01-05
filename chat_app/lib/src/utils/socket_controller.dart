import 'package:chat_app/src/utils/my_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {
  static IO.Socket socket = IO.io(MyUrls.serverUrl, <String, dynamic>{
    'transports': ['websocket'],
  });
}
