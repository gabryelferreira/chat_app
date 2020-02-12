import 'package:chat_app/src/screens/home/home_controller.dart';
import 'package:chat_app/src/screens/settings/settings_view.dart';
import 'package:chat_app/src/widgets/chat_card.dart';
import 'package:chat_app/src/widgets/custom_app_bar.dart';
import 'package:chat_app/src/widgets/custom_cupertino_sliver_navigation_bar.dart';
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
          appBar: CustomAppBar(
            title: Text(_homeController.loading ? 'Conectando...' : 'Chats'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: usersList(context),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _homeController.openAddChatScreen,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.message,
              color: Theme.of(context).accentColor,
            ),
          ),
        );
      },
    );
  }

  Widget usersList(BuildContext context) {
    // if (_homeController.loading) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: CupertinoActivityIndicator(),
    //     ),
    //   );
    // }
    // if (_homeController.error) {
    //   return SliverFillRemaining(
    //     child: Center(
    //       child: Text('Ocorreu um erro ao buscar suas conversas.'),
    //     ),
    //   );
    // }
    if (_homeController.chats.length == 0) {
      return Center(
        child: Text('Você não possui conversas.'),
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
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: _homeController.chats.map((chat) {
            if (chat.messages.length == 0) {
              return Container(height: 0, width: 0);
            }
            return Column(
              children: <Widget>[
                ChatCard(
                  chat: chat,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
