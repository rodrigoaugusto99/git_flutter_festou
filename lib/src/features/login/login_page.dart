import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/feed.dart';
import 'package:git_flutter_festou/src/features/login/login_state.dart';
import 'package:git_flutter_festou/src/features/login/login_vm.dart';
import '../home/widgets/my_squaretile.dart';
import '../../services/auth_services.dart';
import 'forgot_password_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final loginVM = ref.watch(loginVMProvider.notifier);

    ref.listen(loginVMProvider, (_, state) {
      switch (state) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showError(errorMessage, context);
        case LoginState(status: LoginStateStatus.error):
          Messages.showInfo('Erro ao realizar login', context);
        case LoginState(status: LoginStateStatus.invalidForm):
          Messages.showError('Formulário inválido', context);
        case LoginState(status: LoginStateStatus.userLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
          Messages.showSuccess('Logado com sucesso!', context);
      }
    });

    return Scaffold(
      body: Form(
        key: formKey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      // logo
                      const Icon(
                        Icons.lock,
                        size: 150,
                      ),

                      const SizedBox(height: 14),

                      // lets create your account!
                      Text(
                        TextConstants.welcomeLogin,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            // email textfield
                            TextFormField(
                              validator: loginVM.validateEmail(),
                              controller: emailEC,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              validator: loginVM.validatePassword(),
                              obscureText: isVisible ? false : true,
                              controller: passwordEC,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: GestureDetector(
                                  //troca valor do bool dentro do setState
                                  onTap: () => setState(
                                    () {
                                      isVisible = !isVisible;
                                    },
                                  ),
                                  //operador ternario de acordo com o valor do bool
                                  child: isVisible
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                ),
                              ),
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
                                        return const ForgotPasswordPage();
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // sign in button
                            ElevatedButton(
                              onPressed: () {
                                loginVM.validateForm(
                                  context,
                                  formKey,
                                  emailEC,
                                  passwordEC,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                foregroundColor: Colors.white,
                                backgroundColor: ColorsConstants.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: const Text(
                                'SIGN IN',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Feed(
                    text: TextConstants.notMemberLogin,
                    text2: 'Register now',
                    onTap: () =>
                        Navigator.of(context).pushNamed('/register/user'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
