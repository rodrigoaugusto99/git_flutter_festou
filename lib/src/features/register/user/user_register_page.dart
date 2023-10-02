import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/ui/widgets/my_squaretile.dart';
import '../../../services/auth_services.dart';

class UserRegisterPage extends StatefulWidget {
  final Function()? onTap;
  const UserRegisterPage({super.key, required this.onTap});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
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
    return Scaffold(
      backgroundColor: Colors.black,
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
                    'Lets create your account!',
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
                          validator: Validatorless.multiple([
                            Validatorless.required('Email obrigatorio'),
                            Validatorless.email('Email invalido')
                          ]),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                          ),
                          controller: emailEC,
                          obscureText: false,
                        ),

                        const SizedBox(height: 10),

                        //password textfield
                        TextFormField(
                          validator: Validatorless.multiple([
                            Validatorless.required('Senha obrigatoria'),
                            Validatorless.min(
                                6, 'Senha deve ter no minimo 6 caracteres'),
                          ]),
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          controller: passwordEC,
                          obscureText: false,
                        ),

                        const SizedBox(height: 10),

                        //confirm password textfield
                        TextFormField(
                          validator: Validatorless.multiple([
                            Validatorless.required('Confirme sua senha'),
                            Validatorless.min(
                                6, 'Senha deve ter no minimo 6 caracteres'),
                            Validatorless.compare(
                                passwordEC, 'Senha precisam ser iguais')
                          ]),
                          decoration: const InputDecoration(
                            hintText: 'Confirm password',
                          ),
                          controller: confirmPasswordEC,
                          obscureText: false,
                        ),
                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () {},
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
                                'Or continue with',
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //google button
                            /*SquareTile(
                              onTap: () => AuthService().signInWithGoogle(),
                              imagePath: 'lib/assets/images/google.png',
                            ),
                            const SizedBox(width: 25),
                            //apple button
                            SquareTile(
                              onTap: () {},
                              imagePath: 'lib/assets/images/apple.png',
                            ),*/
                          ],
                        ),
                        const SizedBox(height: 20),

                        //not a member? register now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: widget.onTap,
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