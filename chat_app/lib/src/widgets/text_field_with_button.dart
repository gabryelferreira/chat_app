import 'dart:io';

import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

class TextFieldWithButton extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onSubmit;
  final Function onEmojiTap;
  final bool showEmojiKeyboard;
  final BuildContext context;

  TextFieldWithButton({
    @required this.context,
    @required this.textEditingController,
    @required this.onSubmit,
    this.onEmojiTap,
    this.showEmojiKeyboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFDDDDDD)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: Platform.isIOS
                          ? EdgeInsets.only(left: 5, right: 5)
                          : EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFDDDDDD),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Platform.isIOS
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    onEmojiTap(showEmojiKeyboard);
                                  },
                                  child: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                ),
                          Expanded(
                            child: Scrollbar(
                              child: TextField(
                                autocorrect: true,
                                maxLines: 5,
                                minLines: 1,
                                showCursor: true,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                cursorColor: Theme.of(context).primaryColor,
                                controller: textEditingController,
                                onSubmitted: (_) {
                                  onSubmit();
                                },
                                onTap: () {
                                  if (showEmojiKeyboard) {
                                    onEmojiTap(showEmojiKeyboard);
                                  }
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  // suffixIcon: Icon(Icons.add),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Digite uma mensagem',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () {
                        onSubmit();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        renderEmojiKeyboard(),
      ],
    );
  }

  Widget renderEmojiKeyboard() {
    if (showEmojiKeyboard) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    if (showEmojiKeyboard && !_keyboardIsVisible()) {
      return EmojiPicker(
        rows: 3,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          final emojiImage = emoji.emoji;
          textEditingController.text =
              "${textEditingController.text}$emojiImage";
        },
      );
    }
    return Container(width: 0, height: 0);
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
