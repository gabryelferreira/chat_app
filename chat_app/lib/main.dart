import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/screens/add_chat/add_chat_view.dart';
import 'package:chat_app/src/screens/after_launch_screen/after_launch_screen_view.dart';
import 'package:chat_app/src/screens/contact/contact_view.dart';
import 'package:chat_app/src/screens/home/home_view.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/screens/register/register_view.dart';
import 'package:chat_app/src/widgets/custom_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fala Comigo',
        theme: ThemeData(
          primaryColor: Colors.blue,
          hintColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return CustomPageRoute.build(
                  builder: (_) => AfterLaunchScreen(), settings: settings);
            case '/login':
              return CustomPageRoute.build(
                  builder: (_) => LoginScreen(), settings: settings);
            case '/register':
              return CustomPageRoute.build(
                  builder: (_) => RegisterScreen(), settings: settings);
            case '/home':
              return CustomPageRoute.build(
                  builder: (_) => HomeScreen(), settings: settings);
            case '/contact':
              return CustomPageRoute.build(
                  builder: (_) => ContactScreen(), settings: settings);
            case '/add-chat':
              return CustomPageRoute.build(
                  builder: (_) => AddChatScreen(), settings: settings);
            default:
              return CustomPageRoute.build(
                  builder: (_) => AfterLaunchScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
