import 'package:flutter/material.dart';
import 'package:git_flutter_festou/components/my_textbuttons.dart';

import 'locador_page.dart';

class LocatarioAccount extends StatefulWidget {
  const LocatarioAccount({super.key});

  @override
  State<LocatarioAccount> createState() => _LocatarioAccountState();
}

class _LocatarioAccountState extends State<LocatarioAccount> {
  void goToLocatorPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocadorPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/images/smile.png'),
                  const SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Espaco Alegria Kids'),
                      Text(
                        'Locador',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    MyTextbuttons(
                      icon: Icons.chat,
                      onPressed: () {},
                      text: 'chats',
                      text2: 'minhas conversas',
                    ),
                    MyTextbuttons(
                      icon: Icons.notifications,
                      onPressed: () {},
                      text: 'Notificações',
                      text2: 'Minhas notificações',
                    ),
                    MyTextbuttons(
                      icon: Icons.payment,
                      onPressed: () {},
                      text: 'Pagamentos',
                      text2: 'Meus pagamentos',
                    ),
                    MyTextbuttons(
                      icon: Icons.star,
                      onPressed: () {},
                      text: 'Favoritos',
                      text2: 'Meus espaços favoritos',
                    ),
                    MyTextbuttons(
                      icon: Icons.sim_card,
                      onPressed: () {},
                      text: 'Notificações',
                      text2: 'Minhas notificações',
                    ),
                    MyTextbuttons(
                      icon: Icons.payment,
                      onPressed: () {},
                      text: 'Dados',
                      text2: 'Informações da conta',
                    ),
                    MyTextbuttons(
                      icon: Icons.newspaper,
                      onPressed: goToLocatorPage,
                      text: 'Anunciar um espaço',
                      text2: 'Meu perfil locador',
                    ),
                    MyTextbuttons(
                      icon: Icons.help,
                      onPressed: () {},
                      text: 'Ajuda',
                      text2: '',
                    ),
                    MyTextbuttons(
                      icon: Icons.settings,
                      onPressed: () {},
                      text: 'Configurações',
                      text2: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
