import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/screens/add_chat/add_chat_view.dart';
import 'package:chat_app/src/screens/after_launch_screen/after_launch_screen_view.dart';
import 'package:chat_app/src/screens/contact/contact_view.dart';
import 'package:chat_app/src/screens/home/home_view.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/screens/register/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatsProvider()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return CupertinoPageRoute(
                  builder: (_) => AfterLaunchScreen(), settings: settings);
            case '/login':
              return CupertinoPageRoute(
                  builder: (_) => LoginScreen(), settings: settings);
            case '/register':
              return CupertinoPageRoute(
                  builder: (_) => RegisterScreen(), settings: settings);
            case '/home':
              return CupertinoPageRoute(
                  builder: (_) => HomeScreen(), settings: settings);
            case '/contact':
              return CupertinoPageRoute(
                  builder: (_) => ContactScreen(), settings: settings);
            case '/add-chat':
              return CupertinoPageRoute(
                  builder: (_) => AddChatScreen(), settings: settings);
            default:
              return CupertinoPageRoute(
                  builder: (_) => AfterLaunchScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
