import 'dart:developer';

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Festou/src/core/ui/constants.dart';
import 'package:Festou/src/core/ui/helpers/messages.dart';
import 'package:Festou/src/features/register/user/user_register_vm.dart';
import 'package:Festou/src/features/widgets/custom_textformfield.dart';
import 'package:Festou/src/helpers/constants.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  // Text editing controllers
  final emailEC = TextEditingController();
  final cpfOuCnpjEC = TextEditingController();
  final nameEC = TextEditingController();
  final passwordEC = TextEditingController();
  final confirmPasswordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailEC.dispose();
    cpfOuCnpjEC.dispose();
    nameEC.dispose();
    passwordEC.dispose();
    confirmPasswordEC.dispose();
    super.dispose();
  }

  bool isVisible = false;
  bool confirmIsVisible = false;

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final userRegisterVM = ref.watch(userRegisterVmProvider.notifier);

    ref.listen(userRegisterVmProvider, (_, state) {
      switch (state) {
        case UserRegisterStateStatus.initial:
          break;
        case UserRegisterStateStatus.success:
          // if (isTest) {
          //   Navigator.of(context)
          //       .pushNamedAndRemoveUntil('/home', (route) => false);
          // } else {

          // }
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/emailVerification', (route) => false);

        case UserRegisterStateStatus.registrationError:
          Messages.showError('Erro ao registrar usuário', context);
        case UserRegisterStateStatus.formInvalid:
          Messages.showError('Formulário inválido', context);
      }
    });

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = (260 / 412) * screenWidth;
    final double buttonHeight = (37 / 732) * screenHeight;
    final double firstContainer = (179 / 732) * screenHeight;

    String? formattedValue;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
              bottom: 80), // Adiciona espaço para os botões
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
                          const Text(
                            'Cadastro',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Marcellus',
                              color: Color(0xff000000),
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
                      label: 'Nome',
                      controller: nameEC,
                      validator: userRegisterVM.validateName(),
                    ),
                    const SizedBox(height: 20),
                    CustomTextformfield(
                      label: 'CPF / CNPJ',
                      controller: cpfOuCnpjEC,
                      validator: userRegisterVM.validateCpf(),
                      inputFormatters: [
                        TextInputMask(
                            mask: ['999.999.999-99', '99.999.999/9999-99'],
                            reverse: false)
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextformfield(
                      label: 'E-mail',
                      controller: emailEC,
                      validator: userRegisterVM.validateEmail(),
                    ),
                    const SizedBox(height: 20),
                    CustomTextformfield(
                      hasEye: true,
                      obscureText: true,
                      label: 'Senha',
                      controller: passwordEC,
                      validator: userRegisterVM.validatePassword(),
                    ),
                    const SizedBox(height: 20),
                    CustomTextformfield(
                      hasEye: true,
                      obscureText: true,
                      label: 'Confirme sua senha',
                      controller: confirmPasswordEC,
                      validator: userRegisterVM.confirmPassword(passwordEC),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 75, left: 75, bottom: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                userRegisterVM.validateForm(
                    context, formKey, emailEC, passwordEC, nameEC, cpfOuCnpjEC);
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'CADASTRAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/login'),
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
          ],
        ),
      ),
    );
  }
}
