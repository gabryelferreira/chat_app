import 'package:chat_app/src/data/models/chat.dart';
import 'package:chat_app/src/data/models/message.dart';
import 'package:chat_app/src/data/providers/chats_provider.dart';
import 'package:chat_app/src/screens/contact/contact_controller.dart';
import 'package:chat_app/src/utils/dates.dart';
import 'package:chat_app/src/widgets/custom_app_bar.dart';
import 'package:chat_app/src/widgets/text_field_with_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker/emoji_picker.dart';

enum MessagePosition { BEFORE, AFTER }

class ContactScreen extends StatefulWidget {
  static final String routeName = "/contact";

  ContactScreen();

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactController _contactController;
  final format = new DateFormat("HH:mm");

  @override
  void initState() {
    super.initState();
    _contactController = ContactController(
      context: context,
    );
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _contactController.initProvider();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _contactController.streamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: CustomAppBar(
              title: GestureDetector(
                onTap: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      child: Text(
                        _contactController.selectedChat.user.name[0]
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      radius: 16,
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _contactController.selectedChat.user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "@${_contactController.selectedChat.user.username}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          controller: _contactController.scrollController,
                          padding: EdgeInsets.only(bottom: 5),
                          reverse: true,
                          itemCount:
                              _contactController.selectedChat.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 0,
                              ),
                              child: renderMessage(
                                  context,
                                  _contactController
                                      .selectedChat.messages[index],
                                  index),
                            );
                          },
                        ),
                      ),
                    ),
                    TextFieldWithButton(
                      onSubmit: _contactController.sendMessage,
                      textEditingController: _contactController.textController,
                      onEmojiTap: (bool showEmojiKeyboard) {
                        _contactController.showEmojiKeyboard =
                            !showEmojiKeyboard;
                      },
                      showEmojiKeyboard: _contactController.showEmojiKeyboard,
                      context: context,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget renderMessage(BuildContext context, Message message, int index) {
    if (_contactController.myUser == null) return Container();
    return Column(
      children: <Widget>[
        renderMessageSendAtDay(message, index),
        Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: message.from == _contactController.myUser.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              renderMessageSendAt(message, MessagePosition.BEFORE),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: message.from == _contactController.myUser.id
                      ? Colors.blue
                      : Color(0xFFEEEEEE),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: message.from == _contactController.myUser.id
                          ? Colors.white
                          : Colors.black,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
              renderMessageSendAt(message, MessagePosition.AFTER),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderMessageSendAt(Message message, MessagePosition position) {
    if (message.from == _contactController.myUser.id &&
        position == MessagePosition.AFTER) {
      return Row(
        children: <Widget>[
          SizedBox(width: 6),
          Text(
            messageDate(message.sendAt),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      );
    }
    if (message.from != _contactController.myUser.id &&
        position == MessagePosition.BEFORE) {
      return Row(
        children: <Widget>[
          Text(
            messageDate(message.sendAt),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          SizedBox(width: 6),
        ],
      );
    }
    return Container(height: 0, width: 0);
  }

  String messageDate(int milliseconds) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return format.format(date);
  }

  Widget renderMessageSendAtDay(Message message, int index) {
    if (index == _contactController.selectedChat.messages.length - 1) {
      return getLabelDay(message.sendAt);
    }
    final lastMessageSendAt = new DateTime.fromMillisecondsSinceEpoch(
        _contactController.selectedChat.messages[index + 1].sendAt);
    final messageSendAt =
        new DateTime.fromMillisecondsSinceEpoch(message.sendAt);
    final formatter = UtilDates.formatDay;
    String formattedLastMessageSendAt = formatter.format(lastMessageSendAt);
    String formattedMessageSendAt = formatter.format(messageSendAt);
    if (formattedLastMessageSendAt != formattedMessageSendAt) {
      return getLabelDay(message.sendAt);
    }
    return Container();
  }

  Widget getLabelDay(int milliseconds) {
    String day = UtilDates.getSendAtDay(milliseconds);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 4,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xFFC0CBFF),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: Text(
              day,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          height: 7,
        ),
      ],
    );
  }
}
