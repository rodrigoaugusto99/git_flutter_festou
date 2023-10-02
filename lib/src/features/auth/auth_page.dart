import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarPage.dart';
import 'package:git_flutter_festou/src/features/home/home_page.dart';
import 'package:git_flutter_festou/src/features/login/login_page.dart';

//transitar entre paginas de acordo com stream
//checar se o usuario está logado ou nao.
//se nao estiver logado, teremos que mostrar o LoginPage, se estiver logado = HomePage

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //se snapshot tem dado, então o usuario está logado.
          if (snapshot.hasData) {
            return const BottomNavBarPage();
            //se não, logar ou registrar.
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
/*stream vai estar constantemente ouvindo se o auth state muda (se esta logado ou nao)
-o stream é o authStateChanges, que é fornecido pelo FirebaseAuth.instance. 
-esse authStateChanges retorna o estado atual de autenticacao do usuario.
-o builder é o callBack do StreamBuilder, é chamada sempre que 
ocorre alteraçoes nos dados do fluxo.
(snapshot - estado atual do fluxo)*/