import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/screens/add_chat/add_chat_view.dart';
import 'package:chat_app/src/screens/after_launch_screen/after_launch_screen_view.dart';
import 'package:chat_app/src/screens/contact/contact_view.dart';
import 'package:chat_app/src/screens/home/home_view.dart';
import 'package:chat_app/src/screens/login/login_view.dart';
import 'package:chat_app/src/screens/register/register_view.dart';
import 'package:chat_app/src/screens/settings/settings_view.dart';
import 'package:chat_app/src/widgets/custom_page_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          accentColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          cursorColor: Colors.blue,
          appBarTheme: AppBarTheme().copyWith(
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: TextTheme().copyWith(
              title: Theme.of(context).primaryTextTheme.title.copyWith(color: Colors.black)
            )
          )
        ),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return PageRouteBuilder(
                  pageBuilder: (_, a1, a2) => AfterLaunchScreen(), settings: settings);
            case '/login':
              return PageRouteBuilder(
                  pageBuilder: (_, a1, a2) => LoginScreen(), settings: settings);
            case '/register':
              return CustomPageRoute.build(
                  builder: (_) => RegisterScreen(), settings: settings);
            case '/home':
              return PageRouteBuilder(
                  pageBuilder: (_, a1, a2) => HomeScreen(), settings: settings);
            case '/contact':
              return CustomPageRoute.build(
                  builder: (_) => ContactScreen(), settings: settings);
            case '/add-chat':
              return CustomPageRoute.build(
                  builder: (_) => AddChatScreen(), settings: settings, fullscreenDialog: true);
            case '/settings':
              return CustomPageRoute.build(
                  builder: (_) => SettingsScreen(), settings: settings);
            default:
              return CustomPageRoute.build(
                  builder: (_) => AfterLaunchScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
