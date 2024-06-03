import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({Key? key}) : super(key: key);

  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final cpfEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    cpfEC.dispose();
    super.dispose();
  }

  String email = '';
  var invisibleOpacity = 0.0;

  Future<int> checkIfCpfExists() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot querySnapshot =
          await users.where('cpf', isEqualTo: cpfEC.text).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Obter o campo "email" do primeiro documento encontrado
        setState(() {
          email = querySnapshot.docs.first.get('email');
        });

        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      log('Erro ao buscar usuário por CPF: $e');
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double firstContainer = (179 / 732) * screenHeight;
    final double buttonWidth = (260 / 412) * screenWidth;
    final double buttonHeight = (37 / 732) * screenHeight;
    /*final double consultarButtonWidth = (74 / 412) * screenWidth;
    final double consultarButtonHeight = (30 / 732) * screenHeight;*/

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
                              'Recuperar\n   conta',
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
                      label: 'CPF',
                      controller: cpfEC,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '###.###.###-##',
                          filter: {"#": RegExp(r'[0-9]')},
                          type: MaskAutoCompletionType.lazy,
                        )
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: cpfEC.text.length < 14
                            ? () => Messages.showError('CPF inválido', context)
                            : () async {
                                checkIfCpfExists().then((value) {
                                  if (value == 1) {
                                    Messages.showError(
                                        'Não existe e-mail cadastrado com esse CPF',
                                        context);
                                  }
                                  if (value == 2) {
                                    Messages.showError(
                                        'Erro ao buscar CPF', context);
                                  }
                                });
                              },
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
                              'CONSULTAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.2),
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: email != '' ? 1 : invisibleOpacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Seu e-mail é:'),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.red),
                              ),
                              child: Text(email),
                            ),
                          ],
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 75, left: 75, bottom: 90),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed('/forgot_password'),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
