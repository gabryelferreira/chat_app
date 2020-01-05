import 'package:chat_app/src/screens/home/home_controller.dart';
import 'package:chat_app/src/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController(context: context);
  }

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _homeController.streamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Usuarios on-line',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: _homeController.logout,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      child: usersList(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget usersList(BuildContext context) {
    if (_homeController.users.length == 0) {
      return Material(
        child: Align(
          alignment: Alignment.center,
          child: Text('Nenhum usuario on-line.'),
        ),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _homeController.users.map((user) {
          return Column(
            children: <Widget>[
              UserCard(
                user: user,
              ),
              SizedBox(
                height: 5,
              ),
            ],
          );
        }).toList());
  }
}
