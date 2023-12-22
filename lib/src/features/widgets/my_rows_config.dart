import 'package:flutter/material.dart';

import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/impostos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/login_seguranca.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas_atividades_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/notificacoes.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/pagamentos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/traducao.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class MyRowsConfig extends StatefulWidget {
  final UserModel userModel;
  const MyRowsConfig({super.key, required this.userModel});

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
              builder: (context) =>
                  InformacoesPessoais(userModel: widget.userModel),
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
        MyRow(
          text: 'Minhas atividades/Histórico',
          icon: const Icon(Icons.abc),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MinhasAtividadesPage(userId: widget.userModel.id),
            ),
          ),
        ),
      ],
    );
  }
}
