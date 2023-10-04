import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/firebase_options.dart';
import 'package:git_flutter_festou/src/core/ui/festou_nav_global_key.dart';
import 'package:git_flutter_festou/src/features/auth/auth_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarPage.dart';
import 'package:git_flutter_festou/src/features/login/login_page.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_page.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_page.dart';
import 'package:git_flutter_festou/src/features/test/firebase_teste2.dart';

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
      navigatorKey: FestouNavGlobalKey.instance.navKey,
      routes: {
        '/home': (_) => const BottomNavBarPage(),
        '/auth': (_) => const AuthPage(),
        '/login': (_) => const LoginPage(),
        '/register/user': (_) => const UserRegisterPage(),
        '/register/space': (_) => const EspacoRegisterPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: const FirebaseTest(),
    );
  }
}
