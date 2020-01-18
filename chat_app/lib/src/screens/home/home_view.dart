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
          body: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  _homeController.loading ? 'Conectando...' : 'Chats',
                ),
                trailing: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _homeController.logout();
                    },
                  ),
                ),
                backgroundColor: Color(0xFFF8F8F8),
              ),
              usersList(context),
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
      return SliverFillRemaining(
        child: Center(
          child: Text('Voce nao possui conversas.'),
        ),
      );
    }
    // bool theresChatsWithMessages = _homeController.chats.where((chat) {
    //       return chat.messages.length > 0;
    //     }).length >
    //     0;
    bool theresChatsWithMessages = _homeController.chats.where((chat) {
      return chat.lastMessage != null;
    }).length > 0;
    if (!theresChatsWithMessages) {
      return SliverFillRemaining(
        child: Center(
          child: Text('Voce nao possui conversas.'),
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 5),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Column(
              children: _homeController.chats.map((chat) {
                if (chat.lastMessage == null) {
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
          childCount: 1,
        ),
      ),
    );
  }
}
