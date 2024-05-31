import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/impostos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/pagamentos/pagamentos.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/pages/configuracoes.dart';
import 'package:svg_flutter/svg.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
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
              MyRow(
                text: 'Seu perfil',
                icon1: SvgPicture.asset('lib/assets/images/_sfaxx.svg'),
                onTap: () => {},
              ),
              MyRow(
                text: 'Configurações',
                icon1: SvgPicture.asset('lib/assets/images/_sfaxx.svg'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Configuracoes(),
                  ),
                ),
              ),
              MyRow(
                text: 'Central de Ajuda',
                icon1: SvgPicture.asset('lib/assets/images/_sfaxx.svg'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Pagamentos(),
                  ),
                ),
              ),
              MyRow(
                text: 'Envie-nos seu feedback',
                icon1: SvgPicture.asset('lib/assets/images/_sfaxx.svg'),
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
                    onPressed: () {
                      ref.invalidate(userFirestoreRepositoryProvider);
                      ref.invalidate(userAuthRepositoryProvider);
                      ref.read(logoutProvider.future);
                    },
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
    {required String text,
    required Widget icon1,
    required Function()? onTap,
    bool hasUnreadMessages = false}) {
  return InkWell(
    onTap: onTap,
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      height: 20, width: 20, color: Colors.white, child: icon1),
                  const SizedBox(width: 10),
                  Text(text),
                ],
              ),
              SvgPicture.asset('lib/assets/images/_sfaxx.svg'),
            ],
          ),
        ),
        if (hasUnreadMessages)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    ),
  );
}
