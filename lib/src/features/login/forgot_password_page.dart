import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/login/forgot_email_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailEC = TextEditingController();

  // Método para enviar o link de redefinição de senha para o email digitado
  Future<void> passwordReset() async {
    try {
      // Método do Firebase para enviar o link no email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailEC.text);

      // Mostrar um diálogo de sucesso
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! Check your email'),
          );
        },
      );
    } catch (e) {
      // Tratar erros
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double firstContainer = (179 / 732) * screenHeight;
    final double voltarButtonWidth = (202 / 412) * screenWidth;
    final double voltarButtonHeight = (37 / 732) * screenHeight;
    /*final double enviarButtonWidth = (74 / 412) * screenWidth;
    final double enviarButtonHeight = (30 / 732) * screenHeight;*/

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                              children: [
                                const Text(
                                  'FESTOU',
                                  style: TextStyle(
                                    fontFamily: 'NerkoOne',
                                    fontSize: 60,
                                    color: Color(0xff9747FF),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: screenWidth * 0.11,
                                  child: const Text(
                                    'Cadastro',
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
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'E-mail:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          controller: emailEC,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            hintText: 'Digite aqui seu e-mail',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 9),
                            //border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
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
                                    return const ForgotEmailPage();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              'Esqueci meu e-mail',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xff000000)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          child: InkWell(
                            onTap: passwordReset,
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
                                    50), // Borda arredondada
                              ),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Enviar código',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 100,
              right: 100,
              bottom: 100,
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
                    borderRadius:
                        BorderRadius.circular(10), // Borda arredondada
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
    );
  }
}
