import 'package:chat_app/src/screens/login/login_controller.dart';
import 'package:chat_app/src/widgets/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  static final String routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController(context: context);
  }

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: _loginController.streamController.stream,
      builder: (context, snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Para continuar, preencha os campos abaixo.',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: _loginController.usernameController,
                          decoration: InputDecoration(labelText: 'Nome de usuario'),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          cursorColor: Theme.of(context).primaryColor,
                          controller: _loginController.passwordController,
                          decoration: InputDecoration(labelText: 'Senha'),
                          onSubmitted: (_) {
                            _loginController.submitForm();
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        MyButton(
                          title: _loginController.formSubmitting
                              ? 'ENTRANDO...'
                              : 'ENTRAR',
                          onTap: _loginController.submitForm,
                          disabled: !_loginController.isFormValid ||
                              _loginController.formSubmitting,
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Ainda nao possui uma conta? Crie agora.',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
