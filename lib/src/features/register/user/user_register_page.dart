import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_vm.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  //text editing controllers

  final emailEC = TextEditingController();
  final cpfEC = TextEditingController();
  final nameEC = TextEditingController();
  final passwordEC = TextEditingController();
  final confirmPasswordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    //Limpeza do controller
    emailEC.dispose();
    cpfEC.dispose();
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

    //final double loginButtonWidth = (115 / 412) * screenWidth;
    //final double loginButtonHeight = (31 / 732) * screenHeight;

    final double googleLoginButtonWidth = (202 / 412) * screenWidth;
    final double googleLoginButtonHeight = (37 / 732) * screenHeight;

    final double firstContainer = (179 / 732) * screenHeight;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
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
                              const SizedBox(
                                  height:
                                      10), // Adicionado para descer o título "Festou"
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
                                    fontSize:
                                        60, // Mantido o tamanho reduzido de 60 para 50
                                    height:
                                        0.8, // Ajusta a altura da linha para reduzir o espaço
                                    color: Colors
                                        .white, // A cor branca será substituída pelo shader
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15.0,
                                        color: Color.fromARGB(75, 0, 0, 0),
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                ),
                              ), // Ajuste o espaço entre os textos
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
                  const SizedBox(
                    height: 40,
                  ),
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
                        const SizedBox(height: 15),
                        CustomTextformfield(
                          label: 'CPF',
                          controller: cpfEC,
                          validator: userRegisterVM.validateCpf(),
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: '###.###.###-##',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy,
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        CustomTextformfield(
                          label: 'E-mail',
                          controller: emailEC,
                          validator: userRegisterVM.validateEmail(),
                        ),
                        const SizedBox(height: 15),
                        CustomTextformfield(
                          hasEye: true,
                          obscureText: true,
                          label: 'Senha',
                          controller: passwordEC,
                          validator: userRegisterVM.validatePassword(),
                        ),
                        const SizedBox(height: 15),
                        CustomTextformfield(
                          hasEye: true,
                          obscureText: true,
                          label: 'Confirme sua senha',
                          controller: confirmPasswordEC,
                          validator: userRegisterVM.confirmPassword(passwordEC),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        Align(
                          child: InkWell(
                            onTap: () {
                              userRegisterVM.validateForm(context, formKey,
                                  emailEC, passwordEC, nameEC, cpfEC);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: googleLoginButtonWidth,
                              height: googleLoginButtonHeight,
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
                                'CADASTRAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Align(
                          child: InkWell(
                            onTap: () =>
                                Navigator.of(context).pushNamed('/login'),
                            child: Container(
                              alignment: Alignment.center,
                              width: googleLoginButtonWidth,
                              height: googleLoginButtonHeight,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
