import 'package:chat_app/src/screens/add_chat/add_chat_controller.dart';
import 'package:chat_app/src/widgets/custom_cupertino_navigation_bar.dart';
import 'package:chat_app/src/widgets/custom_cupertino_sliver_navigation_bar.dart';
import 'package:chat_app/src/widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddChatScreen extends StatefulWidget {
  static final String routeName = '/add-chat';

  @override
  _AddChatScreenState createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  AddChatController _addChatController;

  @override
  void initState() {
    super.initState();
    _addChatController = AddChatController(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _addChatController.streamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverPersistentHeader(
                  delegate: CustomCupertinoNavigationBar(
                    leading: Container(),
                    trailing: FlatButton(
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: _addChatController.closeScreen,
                    ),
                    middle: Text('Novo chat')
                  ),
                  pinned: true,
                  floating: false,
                ),
                // CustomCupertinoSliverNavigationBar(
                //   previousPageTitle: 'Cancelar',
                //   largeTitle: Text(
                //     'Usuarios',
                //   ),
                // ),
                renderUsers(),
              ],
            ),
          );
        });
  }

  Widget renderUsers() {
    if (_addChatController.loading) {
      return SliverFillRemaining(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    if (_addChatController.error) {
      return SliverFillRemaining(
        child: Center(
          child: Text('Ocorreu um erro ao buscar os usuarios.'),
        ),
      );
    }
    if (_addChatController.users.length == 0) {
      return SliverFillRemaining(
        child: Center(
          child: Text('Nenhum usuario encontrado'),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: _addChatController.users.map((user) {
              return Column(
                children: <Widget>[
                  UserCard(
                    user: user,
                    onTap: _addChatController.newChat,
                  ),
                ],
              );
            }).toList(),
          );
        },
        childCount: 1,
      ),
    );
  }
}
