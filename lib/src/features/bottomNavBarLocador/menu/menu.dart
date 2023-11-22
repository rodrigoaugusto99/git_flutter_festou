import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/impostos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/informa%C3%A7%C3%B5es%20pessoais/informacoes_pessoais.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/login_seguranca.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/pagamentos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/pages/configuracoes.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class Menu extends StatefulWidget {
  final UserModel userModel;
  const Menu({super.key, required this.userModel});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menu',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 1.5,
              ),
              const SizedBox(height: 10),
              MyText(text: 'Hospedagem'),
              const SizedBox(height: 25),
              MyRow(
                text: 'Meus espaços',
                icon: const Icon(Icons.abc),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformacoesPessoais(
                      userModel: widget.userModel,
                    ),
                  ),
                ),
              ),
              MyRow(
                text: 'Crie um novo espaço',
                icon: const Icon(Icons.abc),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginSeguranca(),
                  ),
                ),
              ),
              MyText(text: 'Conta'),
              const SizedBox(height: 25),
              MyRow(
                  text: 'Seu perfil',
                  icon: const Icon(Icons.abc),
                  onTap: () => {}),
              MyRow(
                text: 'Configurações',
                icon: const Icon(Icons.abc),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Configuracoes(
                      userModel: widget.userModel,
                    ),
                  ),
                ),
              ),
              MyRow(
                text: 'Central de Ajuda',
                icon: const Icon(Icons.abc),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Pagamentos(),
                  ),
                ),
              ),
              MyRow(
                text: 'Envie-nos seu feedback',
                icon: const Icon(Icons.abc),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Impostos(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavBarPage(),
                      ),
                    ),
                    child: const Text('Quero viajar'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Sair da conta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget MyText({required String text}) {
  return Text(
    text,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Widget MyRow(
    {required String text, required Icon icon, required Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.icecream),
                Text(text),
              ],
            ),
            const Icon(Icons.arrow_circle_right_rounded),
          ],
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
