import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/impostos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/informacoes_pessoais.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/login_seguranca.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/notificacoes.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/pagamentos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/traducao.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarPageLocador.dart';

class NovaTela extends StatefulWidget {
  const NovaTela({super.key});

  @override
  State<NovaTela> createState() => _NovaTelaState();
}

class _NovaTelaState extends State<NovaTela> {
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
                'Perfil',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nome'),
                          Text('Mostrar perfil'),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.fork_right),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 1.5,
              ),
              const SizedBox(height: 10),
              MyText(text: 'Configurações'),
              const SizedBox(height: 25),
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
              const SizedBox(height: 10),
              MyText(text: 'Alocar'),
              const SizedBox(height: 25),
              MyRow(
                text: 'Quero alocar',
                icon: const Icon(Icons.abc),
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBarPageLocador(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MyText(text: 'Atendimento'),
              const SizedBox(height: 25),
              MyRow(
                text: 'Central de Ajuda',
                icon: const Icon(Icons.abc),
                onTap: () {},
              ),
              MyRow(
                text: 'Como funciona o Festou',
                icon: const Icon(Icons.abc),
                onTap: () {},
              ),
              MyRow(
                text: 'Envie-nos seu feedback',
                icon: const Icon(Icons.abc),
                onTap: () {},
              ),
              const SizedBox(height: 10),
              MyText(text: 'Jurídico'),
              const SizedBox(height: 25),
              MyRow(
                text: 'Termos de Serviço',
                icon: const Icon(Icons.abc),
                onTap: () {},
              ),
              MyRow(
                text: 'Política de Privacidade',
                icon: const Icon(Icons.abc),
                onTap: () {},
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
