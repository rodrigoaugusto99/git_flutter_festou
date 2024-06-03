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

  @override
  void dispose() {
    cpfEC.dispose();
    super.dispose();
  }

  String email = '';

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
    final double voltarButtonWidth = (202 / 412) * screenWidth;
    final double voltarButtonHeight = (37 / 732) * screenHeight;
    /*final double consultarButtonWidth = (74 / 412) * screenWidth;
    final double consultarButtonHeight = (30 / 732) * screenHeight;*/

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
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
                      child: SizedBox(
                        height: screenHeight * 0.12,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
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
                                  fontSize: 60,
                                  color: Colors
                                      .white, // A cor branca será substituída pelo shader
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: -10,
                              child: Text(
                                'Recuperar conta',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Marcellus',
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 450,
                        left: 10,
                        right: 10,
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
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 380,
                        child: InkWell(
                          onTap: cpfEC.text.length < 14
                              ? () =>
                                  Messages.showError('CPF inválido', context)
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
                            width: voltarButtonWidth,
                            height: voltarButtonHeight,
                            decoration: BoxDecoration(
                              gradient: cpfEC.text.length < 14
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xff9747FF),
                                        Color(0xff4300B1),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Colors.grey,
                                        Colors.grey,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                              borderRadius: BorderRadius.circular(
                                  50), // Borda arredondada
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'CONSULTAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      email != ''
                          ? Positioned(
                              bottom: 230,
                              left: 0,
                              right: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Seu e-mail é:'),
                                  Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.red)),
                                      child: Text(email)),
                                ],
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: 70,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            alignment: Alignment.center,
                            width: voltarButtonWidth,
                            height: voltarButtonHeight,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff9747FF),
                                  Color(0xff4300B1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(
                                  10), // Borda arredondada
                            ),
                            child: const Text(
                              'VOLTAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
