import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_page.dart';
import '../login/login_page.dart';

//widget chamado caso o usuario nao esteja logado
//transitar entre paginas de acordo com o bool do onTap

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //booleano para inicialmente mostrar a pagina de login
  bool showLoginPage = true;

  //funcao para transitar entre loginPage e LoginOrRegister.
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    //show LoginPage
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    }
    //show RegisterPage
    else {
      return UserRegisterPage(onTap: togglePages);
    }
  }
}
