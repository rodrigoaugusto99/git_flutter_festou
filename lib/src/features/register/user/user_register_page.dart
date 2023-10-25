import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_vm.dart';
import '../../../core/ui/widgets/my_squaretile.dart';
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

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 10),

                  //logo
                  const Icon(
                    Icons.lock,
                    size: 150,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  //lets create your account!
                  Text(
                    TextConstants.letsCreateAccount,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
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

                        const SizedBox(height: 10),

                        //password textfield
                        TextFormField(
                          validator: userRegisterVM.validatePassword(),
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          controller: passwordEC,
                          obscureText: false,
                        ),

                        const SizedBox(height: 10),

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

                        ElevatedButton(
                          onPressed: () {
                            userRegisterVM.validateForm(
                                context, formKey, emailEC, passwordEC);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            foregroundColor: Colors.white,
                            backgroundColor: ColorsConstants.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: const Text('SIGN UP'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                TextConstants.orContinueWith,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        //google + apple sign in buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //google button
                            SquareTile(
                              onTap: () => AuthService().signInWithGoogle(),
                              imagePath: 'lib/assets/images/google.png',
                            ),
                            const SizedBox(width: 25),
                            //apple button
                            SquareTile(
                              onTap: () {},
                              imagePath: 'lib/assets/images/apple.png',
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        //not a member? register now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              TextConstants.alreadyHaveAccount,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed('/login'),
                              child: const Text(
                                'Login now',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
