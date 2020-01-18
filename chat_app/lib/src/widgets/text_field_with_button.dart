import 'package:flutter/material.dart';

class TextFieldWithButton extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onSubmit;

  TextFieldWithButton({
    this.textEditingController,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFDDDDDD)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
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
                    decoration: InputDecoration(
                      // suffixIcon: Icon(Icons.add),
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.insert_emoticon,
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 9.0, horizontal: 0),
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
                        borderSide:
                            const BorderSide(color: Color(0xFFDDDDDD), width: 1.0),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
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
    );
  }
}
