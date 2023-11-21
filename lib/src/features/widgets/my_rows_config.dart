import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/impostos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/informacoes_pessoais.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/login_seguranca.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/notificacoes.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/pagamentos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/traducao.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu.dart';

class MyRowsConfig extends StatefulWidget {
  const MyRowsConfig({super.key});

  @override
  State<MyRowsConfig> createState() => _MyRowsConfigState();
}

class _MyRowsConfigState extends State<MyRowsConfig> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyRow(
          text: 'Informaçoes pessoais',
          icon: const Icon(Icons.abc),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InformacoesPessoais(),
            ),
          ),
        ),
        MyRow(
          text: 'Login e Segurança',
          icon: const Icon(Icons.abc),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginSeguranca(),
            ),
          ),
        ),
        MyRow(
          text: 'Pagamentos',
          icon: const Icon(Icons.abc),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Pagamentos(),
            ),
          ),
        ),
        MyRow(
          text: 'Impostos',
          icon: const Icon(Icons.abc),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Impostos(),
            ),
          ),
        ),
        MyRow(
          text: 'Tradução',
          icon: const Icon(Icons.abc),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Traducao(),
            ),
          ),
        ),
        MyRow(
          text: 'Notificações',
          icon: const Icon(Icons.abc),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Notificacoes(),
            ),
          ),
        ),
      ],
    );
  }
}
