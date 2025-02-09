import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Festou/src/core/ui/constants.dart';
import 'package:Festou/src/core/ui/helpers/messages.dart';
import 'package:Festou/src/features/login/forgot_email_page.dart';
import 'package:Festou/src/features/widgets/custom_textformfield.dart';
import 'package:validatorless/validatorless.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<String?> checkIfEmailExists(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return null;
      } else {
        return 'Esse e-mail não está cadastrado';
      }
    } catch (e) {
      log('Erro ao buscar usuário por e-mail: $e');
    }
    return null;
  }

  // Método para enviar o link de redefinição de senha para o email digitado
  Future<void> passwordReset() async {
    if (emailEC.text == '') {
      Messages.showError('Insira o e-mail', context);
      return;
    }
    if (formKey.currentState?.validate() == false) {
      Messages.showError('E-mail inválido', context);
      return;
    }
    //todo: check if email is registered
    final response = await checkIfEmailExists(emailEC.text);

    if (response != null) {
      Messages.showError(response, context);
      return;
    }
    try {
      // Método do Firebase para enviar o link no email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailEC.text);

      // Mostrar um diálogo de sucesso
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
        },
      );
      Messages.showSuccess(
          'Um link de verificação foi enviado para o e-mail cadastrado',
          context);
      return;
    } catch (e) {
      // Tratar erros
      Messages.showError(e.toString(), context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double firstContainer = (179 / 732) * screenHeight;
    final double buttonWidth = (260 / 412) * screenWidth;
    final double buttonHeight = (37 / 732) * screenHeight;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
              bottom: 80), // Adiciona espaço para o botão "VOLTAR"
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                height: firstContainer,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      height: firstContainer,
                      child: Image.asset(
                        ImageConstants.serpentinae,
                      ),
                    ),
                    Align(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xff9747FF),
                                  Color(0xff5B2B99),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(
                                Rect.fromLTWH(
                                  0,
                                  0,
                                  bounds.width,
                                  bounds.height,
                                ),
                              );
                            },
                            child: const Text(
                              'FESTOU',
                              style: TextStyle(
                                fontFamily: 'NerkoOne',
                                fontSize: 50,
                                height: 0.8,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 15.0,
                                    color: Color.fromARGB(75, 0, 0, 0),
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Recuperar\nconta',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                height: 1,
                                fontFamily: 'Marcellus',
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      height: firstContainer,
                      child: Image.asset(
                        ImageConstants.serpentinad,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextformfield(
                      label: 'E-mail',
                      controller: emailEC,
                      validator: Validatorless.email(emailEC.text),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ForgotEmailPage();
                              },
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            'Esqueci meu e-mail',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      child: InkWell(
                        onTap: passwordReset,
                        child: Container(
                          alignment: Alignment.center,
                          width: buttonWidth,
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff9747FF),
                                Color(0xff4300B1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'ENVIAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 75, left: 75, bottom: 90),
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            alignment: Alignment.center,
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff9747FF),
                  Color(0xff4300B1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'VOLTAR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
