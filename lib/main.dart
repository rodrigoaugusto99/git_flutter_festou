import 'package:asyncstate/asyncstate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/firebase_options.dart';
import 'package:git_flutter_festou/src/core/ui/festou_nav_global_key.dart';
import 'package:git_flutter_festou/src/features/auth/auth_page.dart';
import 'package:git_flutter_festou/src/features/auth/login_or_register.dart';
import 'package:git_flutter_festou/src/features/home/home_page.dart';

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
    return AsyncStateBuilder(
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          navigatorObservers: [asyncNavigatorObserver],
          navigatorKey: FestouNavGlobalKey.instance.navKey,
          routes: {
            '/home': (_) => const HomePage(),
            '/loginOrRegister': (_) => const LoginOrRegister(),
            '/auth': (_) => const AuthPage(),
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
          home: const AuthPage(),
        );
      },
    );
  }
}
