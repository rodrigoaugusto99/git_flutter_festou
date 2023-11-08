import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/feed.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_vm.dart';
import '../../home/widgets/my_squaretile.dart';
import '../../../services/auth_services.dart';

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

    final double loginButtonWidth = (115 / 412) * screenWidth;
    final double loginButtonHeight = (31 / 732) * screenHeight;

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
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Festou',
                              style: TextStyle(
                                  fontFamily: 'NerkoOne', fontSize: 60),
                            ),
                            Text(
                              'Cadastro',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
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
                            hintText: 'Email',
                          ),
                          controller: emailEC,
                          obscureText: false,
                        ),
                        //password textfield
                        TextFormField(
                          validator: userRegisterVM.validatePassword(),
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          controller: passwordEC,
                          obscureText: false,
                        ),
                        //confirm password textfield
                        TextFormField(
                          validator: userRegisterVM.confirmEmail(passwordEC),
                          decoration: const InputDecoration(
                            hintText: 'Confirm password',
                          ),
                          controller: confirmPasswordEC,
                          obscureText: false,
                        ),

                        const SizedBox(height: 10),

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
