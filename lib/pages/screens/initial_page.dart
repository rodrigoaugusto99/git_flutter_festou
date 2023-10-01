import 'package:flutter/material.dart';
import 'package:git_flutter_festou/old/components/my_buttons.dart';
import 'package:git_flutter_festou/pages/screens/cadastrar_page.dart';
import 'login_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  void goToLoginPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void goToCadastrarPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CadastrarPage()),
    );
  }

  void loginWithGoogle() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(125, 0, 254, 1),
                  Color.fromRGBO(216, 0, 255, 1),
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: constraints.maxWidth * 0.1),
                  child: Image.asset(
                    'lib/assets/images/festou-logo.png',
                    width: constraints.maxWidth * 0.6,
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(27),
                        topRight: Radius.circular(27),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          //container roxo do bem vindo
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(228, 201, 255, 1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(27),
                              topRight: Radius.circular(27),
                              bottomLeft: Radius.circular(27),
                              bottomRight: Radius.circular(0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 2,
                                offset: const Offset(0, 0),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Text(
                                    'Bem vindo ao\nFestou!',
                                    style: TextStyle(
                                      //color: Colors.indigo[800],
                                      fontSize: 25.0,
                                      fontFamily: 'Valentine',
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 1
                                        ..color = Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(
                                    'Bem vindo ao\nFestou!',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontFamily: 'Valentine',
                                      color: Color.fromRGBO(173, 0, 255, 1),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        MyButton(
                          onPressed: goToLoginPage,
                          text: 'Login',
                        ),
                        MyButton(
                          onPressed: goToCadastrarPage,
                          text: 'Cadastre-se',
                        ),
                        MyButton(
                          onPressed: loginWithGoogle,
                          text: 'Logar com o Google',
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
