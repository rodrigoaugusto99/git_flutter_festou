import 'package:flutter/material.dart';
import 'package:git_flutter_festou/components/my_buttons.dart';
import 'package:git_flutter_festou/components/my_textformfield.dart';

import '../helpers/form_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKeyLogin = GlobalKey<FormState>();

  void loginFunction() {
    if (formKeyLogin.currentState?.validate() == true) {
      // A validação do formulário passou, continue com o processamento
      // Código para cadastrar o usuário aqui
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.deepPurple,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: formKeyLogin,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: constraints.maxWidth * 0.1),
                    child: Image.asset(
                      'lib/assets/images/festou-logo.png',
                      width: constraints.maxWidth * 0.6,
                    ),
                  ),
                  MyTextFormfield(
                    controller: emailController,
                    hintText: 'Email',
                    validator: FormValidator.validateName,
                  ),
                  MyTextFormfield(
                    controller: passwordController,
                    hintText: 'Password',
                    validator: FormValidator.validatePassword,
                  ),
                  MyButton(onPressed: loginFunction, text: 'Login')
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
