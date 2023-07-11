import 'package:flutter/material.dart';

import '../components/my_buttons.dart';
import '../components/my_textformfield.dart';
import '../helpers/form_validator.dart';
import 'locatario_navigation_bottom_bar.dart';

class CadastrarPage extends StatefulWidget {
  const CadastrarPage({super.key});

  @override
  State<CadastrarPage> createState() => _CadastrarPageState();
}

class _CadastrarPageState extends State<CadastrarPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final nascimentoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKeyCadastro = GlobalKey<FormState>();

  void cadastrarFunction() {
    if (formKeyCadastro.currentState?.validate() == true) {
      // A validação do formulário passou, continue com o processamento
      // Código para cadastrar o usuário aqui

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LocatarioNavigationBottomBar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Form(
              key: formKeyCadastro,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: constraints.maxWidth * 0.1),
                    child: Image.asset(
                      'lib/assets/images/festou-logo.png',
                      width: constraints.maxWidth * 0.2,
                    ),
                  ),
                  MyTextFormfield(
                      controller: nameController,
                      hintText: 'Name',
                      validator: (value) {
                        if (value?.isEmpty == true) {
                          return 'por favor, insira seu nome';
                        }
                        return null;
                      }),
                  MyTextFormfield(
                    controller: emailController,
                    hintText: 'Email',
                    validator: FormValidator.validateEmail,
                  ),
                  MyTextFormfield(
                    controller: nascimentoController,
                    hintText: 'Nascimento',
                    validator: FormValidator.validateBirthDate,
                  ),
                  MyTextFormfield(
                    controller: passwordController,
                    hintText: 'Password',
                    validator: FormValidator.validatePassword,
                  ),
                  MyTextFormfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirm password',
                    validator: (value) => FormValidator.validateConfirmPassword(
                        value, passwordController.text),
                  ),
                  MyButton(onPressed: cadastrarFunction, text: 'Cadastrar'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
