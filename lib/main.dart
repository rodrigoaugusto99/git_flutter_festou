import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/firebase_options.dart';
import 'package:git_flutter_festou/src/core/ui/festou_nav_global_key.dart';
import 'package:git_flutter_festou/src/features/auth/auth_page.dart';
import 'package:git_flutter_festou/src/features/auth/verify_email_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarLocatarioPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/home_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/search/search_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/help/help_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarLocadorPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/mensagens/mensagens.dart';
import 'package:git_flutter_festou/src/features/login/forgot_password_page.dart';
import 'package:git_flutter_festou/src/features/login/login_page.dart';
import 'package:git_flutter_festou/src/features/register/user%20infos/user_register_infos_page.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_page.dart';
import 'package:git_flutter_festou/src/features/splash/splash_page.dart';
import 'package:git_flutter_festou/src/helpers/constants.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> setupMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (isTest) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  await initializeDateFormatting('pt_BR', null);
}

Future<void> main() async {
  await setupMain();
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
        '/home': (_) => const BottomNavBarLocatarioPage(),
        '/emailVerification': (_) => const VerifyEmailPage(),
        '/auth': (_) => const AuthPage(),
        '/login': (_) => const LoginPage(),
        '/forgot_password': (_) => const ForgotPasswordPage(),
        '/register/user': (_) => const UserRegisterPage(),
        '/register/user/infos': (_) => const UserRegisterInfosPage(),
        '/account/help': (_) => const HelpPage(),
        '/account/favorites': (_) => const MyFavoriteSpacePage(),
        '/home/my_spaces': (_) => const MySpacesPage(),
        '/home/all_spaces': (_) => const AllSpacesPage(),
        '/home/search_page': (_) => const SearchPage(),
        '/mensagens': (_) => const Mensagens(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home2') {
          final initialIndex = settings.arguments as int? ?? 0;
          return MaterialPageRoute(
            builder: (context) =>
                BottomNavBarLocadorPage(initialIndex: initialIndex),
          );
        }
        return null;
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.purple,
          surfaceTintColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'inter',
        primarySwatch: Colors.purple,
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
