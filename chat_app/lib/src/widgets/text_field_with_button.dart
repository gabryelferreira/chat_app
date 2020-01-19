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
              height: 40,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: TextField(
                        autocorrect: false,
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
                          // suffixIcon: Icon(Icons.add),
                          prefixIcon: !Platform.isIOS
                              ? IconButton(
                                  icon: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    onEmojiTap(showEmojiKeyboard);
                                  },
                                )
                              : null,
                          contentPadding: Platform.isIOS
                              ? EdgeInsets.symmetric(
                                  vertical: 9.0, horizontal: 15)
                              : EdgeInsets.symmetric(
                                  vertical: 9.0, horizontal: 5),
                          hintText: 'Digite uma mensagem',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFDDDDDD), width: 1.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                        ),
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
                        width: 40,
                        height: 40,
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
          textEditingController.text = "${textEditingController.text}$emojiImage";
        },
      );
    }
    return Container(width: 0, height: 0);
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
