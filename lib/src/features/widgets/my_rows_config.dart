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
import 'package:svg_flutter/svg.dart';

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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InformacoesPessoais(userModel: widget.userModel),
            ),
          ),
          icon1: Image.asset(
            'lib/assets/images/Icon Personinformacoespessoais.png',
          ),
        ),
        const SizedBox(height: 10),
        MyRow(
          text: 'Login e Segurança',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginSeguranca(),
            ),
          ),
          icon1: Image.asset(
              'lib/assets/images/Icon Segurançalogineseguranca.png'),
        ),
        const SizedBox(height: 10),
        MyRow(
          text: 'Pagamentos',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Pagamentos(),
            ),
          ),
          icon1: Image.asset(
            'lib/assets/images/Icon Pagamentometodosdepagamento.png',
          ),
        ),
        const SizedBox(height: 10),
        MyRow(
          text: 'Minhas atividades/Histórico',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MinhasAtividadesPage(userId: widget.userModel.id),
            ),
          ),
          icon1: Image.asset(
            'lib/assets/images/Icon Históricominhnasatividades.png',
          ),
        ),
      ],
    );
  }
}
