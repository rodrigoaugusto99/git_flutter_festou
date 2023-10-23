import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/firebase_options.dart';
import 'package:git_flutter_festou/src/core/ui/festou_nav_global_key.dart';
import 'package:git_flutter_festou/src/features/auth/auth_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account%20options/dados/dados_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account%20options/help/help_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account%20options/locador/quero_ser_locador.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarPage.dart';
import 'package:git_flutter_festou/src/features/home/all%20space%20mvvm/all_spaces_page.dart';
import 'package:git_flutter_festou/src/features/home/my%20favorite%20spaces%20mvvm/my_favorite_spaces_page.dart';
import 'package:git_flutter_festou/src/features/home/my%20space%20mvvm/my_spaces_page.dart';
import 'package:git_flutter_festou/src/features/login/login_page.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_page.dart';
import 'package:git_flutter_festou/src/features/register/user%20infos/user_register_infos_page.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_page.dart';
import 'package:git_flutter_festou/src/features/splash/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: FestouNavGlobalKey.instance.navKey,
      routes: {
        '/home': (_) => const BottomNavBarPage(),
        '/auth': (_) => const AuthPage(),
        '/login': (_) => const LoginPage(),
        '/register/user': (_) => const UserRegisterPage(),
        '/register/space': (_) => const EspacoRegisterPage(),
        '/register/user/infos': (_) => const UserRegisterInfosPage(),
        '/account/help': (_) => const HelpPage(),
        '/account/dados': (_) => const DadosPage(),
        '/account/locador': (_) => QueroSerLocadorPage(),
        '/account/favorites': (_) => const MyFavoriteSpacePage(),
        '/home/my_spaces': (_) => const MySpacesPage(),
        '/home/all_spaces': (_) => const AllSpacesPage(),
      },
      theme: ThemeData(
        fontFamily: 'inter',
        primarySwatch: Colors.deepPurple,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}
