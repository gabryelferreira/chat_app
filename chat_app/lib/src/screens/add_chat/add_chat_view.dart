import 'package:chat_app/src/screens/add_chat/add_chat_controller.dart';
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
            appBar: CupertinoNavigationBar(
              actionsForegroundColor: Colors.white,
              middle: Text(
                'Usuarios',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: SafeArea(
              child: Container(
                child: renderUsers(),
              ),
            ),
          );
        });
  }

  Widget renderUsers() {
    if (_addChatController.loading) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    if (_addChatController.error) {
      return Center(
        child: Text('Ocorreu um erro ao buscar os usuarios.'),
      );
    }
    if (_addChatController.users.length == 0) {
      return Center(
        child: Text('Nenhum usuario encontrado'),
      );
    }
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      children: _addChatController.users.map((user) {
        return Column(
          children: <Widget>[
            UserCard(
              user: user,
              onTap: _addChatController.newChat,
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
