import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/feed.dart';
import 'package:git_flutter_festou/src/features/login/login_state.dart';
import 'package:git_flutter_festou/src/features/login/login_vm.dart';
import 'package:glassmorphism/glassmorphism.dart';
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

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double logoTop = (54 / 732) * screenHeight;
    final double logoLeft = (81 / 412) * screenWidth;
    final double logoHeight = (336 / 732) * screenHeight;
    final double logoWidth = (250 / 412) * screenWidth;

    final double glassTop = (369 / 732) * screenHeight;
    final double glassLeft = (36 / 412) * screenWidth;
    final double glassHeight = (333 / 732) * screenHeight;
    final double glassWidth = (340 / 412) * screenWidth;

    //final double emailFieldTop = (390 / 732) * screenHeight;
    //final double emailFieldLeft = (62 / 412) * screenWidth;
    final double emailFieldWidth = (291 / 412) * screenWidth;
    final double emailFieldHeight = (39 / 732) * screenHeight;

    //final double passwordFieldTop = (446 / 732) * screenHeight;
    //final double passwordFieldLeft = (61 / 412) * screenWidth;
    final double passwordFieldWidth = (291 / 412) * screenWidth;
    final double passwordFieldHeight = (39 / 732) * screenHeight;

    //final double forgotPasswordTextTop = (497 / 732) * screenHeight;
    //final double forgotPasswordTextLeft = (229 / 412) * screenWidth;

    //final double loginButtonTop = (530 / 732) * screenHeight;
    //final double loginButtonLeft = (149 / 412) * screenWidth;
    final double loginButtonWidth = (115 / 412) * screenWidth;
    final double loginButtonHeight = (31 / 732) * screenHeight;

    //final double registerTextTop = (577 / 732) * screenHeight;
    //final double registerTextLeft = (128 / 412) * screenWidth;

    //final double googleLoginButtonTop = (645 / 732) * screenHeight;
    //final double googleLoginButtonLeft = (106 / 412) * screenWidth;
    final double googleLoginButtonWidth = (202 / 412) * screenWidth;
    final double googleLoginButtonHeight = (37 / 732) * screenHeight;

    final double googleLogoWidth = (23 / 412) * screenWidth;
    final double googleLogoHeight = (23 / 412) * screenHeight;

    final double dividerWidth = (115 / 412) * screenWidth;

    return Scaffold(
      body: Form(
        key: formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  ImageConstants.loginBackground,
                ),
                fit: BoxFit.cover),
          ),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Stack(
                  children: [
                    // logo
                    Positioned(
                      width: logoWidth,
                      height: logoHeight,
                      top: logoTop,
                      left: logoLeft,
                      child: Image.asset(
                        ImageConstants.festouLogo,
                      ),
                    ),
                    //glass
                    Positioned(
                      top: glassTop,
                      left: glassLeft,
                      child: GlassmorphicContainer(
                        width: glassWidth,
                        height: glassHeight,
                        borderRadius: 20,
                        blur: 20,
                        border: 0,
                        linearGradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.35),
                            Color.fromRGBO(0, 0, 0, 0),
                          ],
                        ),
                        borderGradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [],
                        ),
                        child: Align(
                          child: Column(
                            children: [
                              // email textfield
                              SizedBox(
                                height: screenHeight * 0.022,
                              ),
                              Container(
                                width: emailFieldWidth,
                                height: emailFieldHeight,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Cor de fundo branca
                                  borderRadius: BorderRadius.circular(
                                      50.0), // Borda arredondada
                                ),
                                child: TextFormField(
                                  validator: loginVM.validateEmail(),
                                  controller: emailEC,
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    prefixIcon: Icon(
                                      // Ícone à esquerda
                                      Icons.email,
                                      color: Colors.grey, // Cor do ícone
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              Container(
                                width: passwordFieldWidth,
                                height: passwordFieldHeight,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Cor de fundo branca
                                  borderRadius: BorderRadius.circular(
                                      50.0), // Borda arredondada
                                ),
                                child: TextFormField(
                                  validator: loginVM.validatePassword(),
                                  obscureText: isVisible ? false : true,
                                  controller: passwordEC,
                                  decoration: InputDecoration(
                                    hintText: 'Password',

                                    border: InputBorder
                                        .none, // Remove a borda padrão
                                    prefixIcon: const Icon(
                                      // Ícone à esquerda
                                      Icons.lock,
                                      color: Colors.grey, // Cor do ícone
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () => setState(
                                        () {
                                          isVisible = !isVisible;
                                        },
                                      ),
                                      child: isVisible
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: screenWidth * 0.1),
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
                                      'Esqueci minha senha',
                                      style: TextStyle(
                                        //fontFamily: ,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // sign in button
                              SizedBox(
                                height: screenHeight * 0.022,
                              ),
                              InkWell(
                                onTap: () {
                                  loginVM.validateForm(
                                    context,
                                    formKey,
                                    emailEC,
                                    passwordEC,
                                  );
                                },
                                child: Container(
                                  width: loginButtonWidth,
                                  height: loginButtonHeight,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(9, 41, 84, 1),
                                        Color.fromRGBO(29, 63, 111, 1)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        50), // Borda arredondada
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          color: Colors.white, // Cor do texto
                                          fontSize: 11, // Tamanho do texto
                                          fontWeight: FontWeight
                                              .w400 // Estilo de texto em negrito
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Não tem conta?',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    ' Cadastre-se',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 250, 0, 255),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.022,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: dividerWidth,
                                    child: const Divider(
                                      thickness: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      'OU',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: dividerWidth,
                                    child: const Divider(
                                      thickness: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.025,
                              ),
                              InkWell(
                                onTap: () => AuthService().signInWithGoogle(),
                                child: Container(
                                  width: googleLoginButtonWidth,
                                  height: googleLoginButtonHeight,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 13, 46, 89),
                                    borderRadius: BorderRadius.circular(
                                        10), // Borda arredondada
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageConstants.googleLogo,
                                        width: googleLogoWidth,
                                        height: googleLogoHeight * screenHeight,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.03,
                                      ),
                                      const Text(
                                        'LOGIN COM O GOOGLE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
