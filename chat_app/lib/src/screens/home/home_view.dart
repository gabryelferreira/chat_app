import 'package:chat_app/src/screens/home/home_controller.dart';
import 'package:chat_app/src/widgets/chat_card.dart';
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
  void didChangeDependencies() {
    _homeController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _homeController.streamController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     'Usuarios on-line',
          //     style: TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          //   actions: [
          //     Material(
          //       color: Colors.transparent,
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.exit_to_app,
          //           color: Colors.white,
          //         ),
          //         onPressed: _homeController.logout,
          //       ),
          //     ),
          //   ],
          // ),
          body: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  'Chats',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: _homeController.logout,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              SliverFillRemaining(
                child: usersList(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _homeController.openAddChatScreen,
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget usersList(BuildContext context) {
    if (_homeController.loading) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    if (_homeController.error) {
      return Center(
        child: Text('Ocorreu um erro ao buscar suas conversas.'),
      );
    }
    if (_homeController.chats.length == 0) {
      return Center(
        child: Text('Voce nao possui conversas.'),
      );
    }
    bool theresChatsWithMessages = _homeController.chats.where((chat) {
          return chat.messages.length > 0;
        }).length >
        0;
    if (!theresChatsWithMessages) {
      return Center(
        child: Text('Voce nao possui conversas.'),
      );
    }
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      children: _homeController.chats.map((chat) {
        if (chat.messages.length == 0) {
          return Container(height: 0, width: 0);
        }
        return Column(
          children: <Widget>[
            ChatCard(
              chat: chat,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        );
      }).toList(),
    );
  }
}
