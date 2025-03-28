import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/constants.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/login/login_state.dart';
import 'package:festou/src/features/login/login_vm.dart';
import 'package:glassmorphism/glassmorphism.dart';
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

  bool isVisible = false;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

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
          Messages.showError('E-mail ou senha inválidos', context);
          _isLoggingIn = false;
          break;
        case LoginState(status: LoginStateStatus.invalidForm):
          Messages.showInfo('Formulário inválido', context);
          _isLoggingIn = false;
          break;
        case LoginState(status: LoginStateStatus.userLogin):
          // if (isTest) {
          //   Navigator.of(context)
          //       .pushNamedAndRemoveUntil('/home', (route) => false);
          // } else {

          // }
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/emailVerification', (route) => false);
          _isLoggingIn = false;
          break;
        //changeProviderDialog(dialogMessage);
      }
    });

    bool validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        // return 'Insira um email';
        //todo> chamar message
        Messages.showError('Insira um e-mail', context);
        return false;
      }

      // Regex para validar o formato do email
      RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegExp.hasMatch(value)) {
        // return 'Email inválido';
        Messages.showError('E-mail inválido', context);
        return false;
        //todo: chamar
      }

      return true; // Email válido
    }

    bool validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        // return 'Insira um email';
        //todo> chamar message
        Messages.showError('Insira sua senha', context);
        return false;
      }

      // Regex para validar o formato do email
      // RegExp emailRegExp = RegExp(
      //   r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      // );

      // if (!emailRegExp.hasMatch(value)) {
      //   // return 'Email inválido';
      //   Messages.showError('Email inválido', context);
      //   return false;
      //   //todo: chamar
      // }

      return true; // Email válido
    }

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

    final double emailFieldWidth = (291 / 412) * screenWidth;
    final double emailFieldHeight = (39 / 732) * screenHeight;

    final double passwordFieldWidth = (291 / 412) * screenWidth;
    final double passwordFieldHeight = (39 / 732) * screenHeight;

    final double loginButtonWidth = (202 / 412) * screenWidth;
    final double loginButtonHeight = (37 / 732) * screenHeight;

    final double googleLoginButtonWidth = (202 / 412) * screenWidth;
    final double googleLoginButtonHeight = (37 / 732) * screenHeight;

    final double googleLogoWidth = (23 / 412) * screenWidth;
    final double googleLogoHeight = (23 / 412) * screenHeight;

    final double dividerWidth = (115 / 412) * screenWidth;

    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.loginBackground),
                fit: BoxFit.cover,
              ),
            ),
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
                    blur: 1,
                    border: 0,
                    linearGradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.35),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderGradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0),
                        Color.fromRGBO(0, 0, 0, 0),
                      ],
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 14.0),
                              controller: emailEC,
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              decoration: const InputDecoration(
                                hintText: 'E-mail',
                                hintStyle: TextStyle(fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: EdgeInsetsDirectional.all(11),
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.grey),
                                alignLabelWithHint:
                                    true, // Mantém alinhamento do hint
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            width: passwordFieldWidth,
                            height: passwordFieldHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 14.0),
                              obscureText: !isVisible,
                              controller: passwordEC,
                              decoration: InputDecoration(
                                hintText: 'Senha',
                                hintStyle: const TextStyle(fontSize: 14),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsetsDirectional.all(11),
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.grey),
                                suffixIcon: GestureDetector(
                                  onTap: () =>
                                      setState(() => isVisible = !isVisible),
                                  child: Icon(isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                alignLabelWithHint:
                                    true, // Mantém alinhamento do hint
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
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
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
                              bool isEmailValid = validateEmail(emailEC.text);
                              if (!isEmailValid) return;
                              bool isPasswordValid =
                                  validatePassword(passwordEC.text);
                              if (!isPasswordValid) return;

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
                                    Color(0xff9747FF),
                                    Color(0xff4300B1),
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
                                      fontSize: 12, // Tamanho do texto
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Não tem conta?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/register/user'),
                                child: const Text(
                                  ' Cadastre-se',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffC08FFF),
                                  ),
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
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                            onTap: _isLoggingIn
                                ? null // Desativa o clique se já estiver processando
                                : () async {
                                    setState(() {
                                      _isLoggingIn =
                                          true; // Bloqueia novos cliques
                                    });

                                    try {
                                      await loginVM.loginWithGoogle(
                                          context); // Aguarda o login ser concluído
                                    } catch (e) {
                                      Messages.showError(
                                          "Erro ao logar com Google: $e",
                                          context);
                                    } finally {
                                      setState(() {
                                        _isLoggingIn =
                                            false; // Só libera o botão após conclusão
                                      });
                                    }
                                  },
                            child: Container(
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
                                      fontSize: 11,
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
          ),
        ),
      ),
    );
  }
}
