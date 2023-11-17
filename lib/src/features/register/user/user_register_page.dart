import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_vm.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  //text editing controllers

  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final confirmPasswordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    //Limpeza do controller
    emailEC.dispose();
    passwordEC.dispose();
    confirmPasswordEC.dispose();
    super.dispose();
  }

  bool isVisible = false;
  bool confirmIsVisible = false;

  @override
  Widget build(BuildContext context) {
    final userRegisterVM = ref.watch(userRegisterVmProvider.notifier);

    ref.listen(userRegisterVmProvider, (_, state) {
      switch (state) {
        case UserRegisterStateStatus.initial:
          break;
        case UserRegisterStateStatus.success:
          Navigator.of(context).pushNamed('/register/user/infos');
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
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: firstContainer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          ImageConstants.serpentinae,
                        ),
                        SizedBox(
                          height: screenHeight * 0.12,
                          child: Stack(
                            children: [
                              const Text(
                                'FESTOU',
                                style: TextStyle(
                                    fontFamily: 'NerkoOne', fontSize: 60, color: Color.fromARGB(255, 13, 46, 89),),
                              ),
                              Positioned(
                                bottom: 0,
                                left: screenWidth * 0.11,
                                child: const Text(
                                  'Cadastro',
                                  style: TextStyle(fontSize: 20, fontFamily: 'Marcellus', color: Color.fromARGB(255, 13, 46, 89),),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          ImageConstants.serpentinad,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: userRegisterVM.validateEmail(),
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                          style: const TextStyle(fontSize: 14),
                          controller: emailEC,
                          obscureText: false,
                        ),
                        //password textfield
                        TextFormField(
                          validator: userRegisterVM.validatePassword(),
                          decoration: InputDecoration(
                            hintText: 'Senha',
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: GestureDetector(
                                onTap: () => setState(
                                      () {
                                    isVisible = !isVisible;
                                  },
                                ),
                                child: isVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),),
                          ),
                          style: const TextStyle(fontSize: 14),
                          controller: passwordEC,
                          obscureText: isVisible ? false : true
                        ),
                        TextFormField(
                          validator: userRegisterVM.confirmEmail(passwordEC),
                          decoration: InputDecoration(
                            hintText: 'Confirme sua senha',
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                    () {
                                  confirmIsVisible = !confirmIsVisible;
                                },
                              ),
                              child: confirmIsVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),),
                          ),
                            style: const TextStyle(fontSize: 14),
                            controller: passwordEC,
                            obscureText: confirmIsVisible ? false : true
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        InkWell(
                          onTap: () {
                            userRegisterVM.validateForm(
                                context, formKey, emailEC, passwordEC);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: googleLoginButtonWidth,
                            height: googleLoginButtonHeight,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 13, 46, 89),
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
                        SizedBox(height: screenHeight * 0.01),
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/login'),
                          child: Container(
                            alignment: Alignment.center,
                            width: googleLoginButtonWidth,
                            height: googleLoginButtonHeight,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 13, 46, 89),
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
