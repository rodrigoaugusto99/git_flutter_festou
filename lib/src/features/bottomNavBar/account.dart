import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account%20options/help/help_page.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    showConfirmationDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmação"),
            content: const Text(
                "Tem certeza de que deseja se tornar um locador? Isso atualizará seu status no aplicativo."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/account/locador');
                },
                child: const Text("Confirmar"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/assets/images/smile.png'),
                const SizedBox(width: 20.0),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Espaco Alegria Kids'),
                    Text(
                      'Locatário',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
            AcountButton(
              text: 'Chats',
              text2: 'Minhas conversas',
              icon: const Icon(Icons.chat),
              onTap: () {},
            ),
            AcountButton(
              text: 'Notificações',
              text2: 'Minhas notificações',
              icon: const Icon(Icons.notifications),
              onTap: () {},
            ),
            AcountButton(
              text: 'Pagamentos',
              text2: 'Meus pagamentos',
              icon: const Icon(Icons.payment),
              onTap: () {},
            ),
            AcountButton(
              text: 'Favoritos',
              text2: 'Meus espaços favoritos',
              icon: const Icon(Icons.star),
              onTap: () =>
                  Navigator.of(context).pushNamed('/account/favorites'),
            ),
            AcountButton(
              text: 'Dados',
              text2: 'Minhas informações da conta',
              icon: const Icon(Icons.dataset),
              onTap: () => Navigator.of(context).pushNamed('/account/dados'),
            ),
            const SizedBox(height: 40),
            AcountButton(
              text: 'Anunciar um espaço',
              icon: const Icon(Icons.chat),
              onTap: showConfirmationDialog,
            ),
            const SizedBox(height: 40),
            AcountButton(
              text: 'Ajuda',
              icon: const Icon(Icons.help),
              onTap: () => Navigator.of(context).pushNamed('/account/help'),
            ),
            AcountButton(
              text: 'Configurações',
              icon: const Icon(Icons.settings),
              onTap: () {},
            ),
            AcountButton(
              text: 'Segurança',
              icon: const Icon(Icons.security),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class AcountButton extends StatelessWidget {
  final String text;
  final String? text2;
  final Icon icon;
  final Function() onTap;

  const AcountButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  icon,
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_right_outlined,
                color: Colors.black,
              ),
            ],
          ),
          if (text2 != null)
            Padding(
              padding: const EdgeInsets.only(top: 3.0, left: 5.0),
              child: Text(
                text2!,
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(left: 5.0, right: 12.0),
            child: Divider(
              height: 2.0,
              color: Colors.black,
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
