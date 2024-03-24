import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20by%20type/spaces_by_type_page.dart';

class MenuSpaceTypes extends StatefulWidget {
  const MenuSpaceTypes({super.key});

  @override
  State<MenuSpaceTypes> createState() => _MenuSpaceTypesState();
}

class _MenuSpaceTypesState extends State<MenuSpaceTypes> {
  final user = FirebaseAuth.instance
      .currentUser!; //TODO: Remover os botões de "Todos os espaços" e "Meus espaços" dessa classe

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return SizedBox(
      height: y * 0.12,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: x * 0.03),
          SizedBox(
            width: 170,
            child: ElevatedButton(
              /*onPressed: () => Navigator.of(context)
                  .pushNamed('/spaces/spaces_by_types', arguments: ['Kids']),*/
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SpacesByTypePage(
                      type: ['Kids'],
                    ); // Substitua NovaPagina com o widget da sua nova tela
                  },
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/iconKids.png',
                    width: x * 0.12,
                  ),
                  SizedBox(width: x * 0.02),
                  const Text(
                    'Kids',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: x * 0.025),
          SizedBox(
            width: 185,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SpacesByTypePage(
                      type: ['Casamento'],
                    ); // Substitua NovaPagina com o widget da sua nova tela
                  },
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/iconBuque.png',
                    width: x * 0.12,
                  ),
                  SizedBox(width: x * 0.02),
                  const Text(
                    'Casamento',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: x * 0.025),
          SizedBox(
            width: 185,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SpacesByTypePage(
                      type: ['Debutante'],
                    ); // Substitua NovaPagina com o widget da sua nova tela
                  },
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/iconQuinze.png',
                    width: x * 0.12,
                  ),
                  SizedBox(width: x * 0.02),
                  const Text(
                    'Debutante',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: x * 0.025),
          SizedBox(
            width: 170,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SpacesByTypePage(
                      type: ['Religioso'],
                    ); // Substitua NovaPagina com o widget da sua nova tela
                  },
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/iconReligioso.png',
                    width: x * 0.12,
                  ),
                  SizedBox(width: x * 0.02),
                  const Text(
                    'Religioso',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: x * 0.025),
          SizedBox(
            width: 170,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SpacesByTypePage(
                      type: ['Cha'],
                    ); // Substitua NovaPagina com o widget da sua nova tela
                  },
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/iconCha.png',
                    width: x * 0.12,
                  ),
                  SizedBox(width: x * 0.02),
                  const Text(
                    'Chá',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: x * 0.025),
          SizedBox(
            width: 170,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SpacesByTypePage(
                      type: ['Reuniao'],
                    ); // Substitua NovaPagina com o widget da sua nova tela
                  },
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/iconReuniao.png',
                    width: x * 0.12,
                  ),
                  SizedBox(width: x * 0.02),
                  const Text(
                    'Reunião',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: x * 0.025),
          SizedBox(
            width: 170,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SpacesByTypePage(
                      type: ['Outros'],
                    ); // Substitua NovaPagina com o widget da sua nova tela
                  },
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/iconOutros.png',
                    width: x * 0.12,
                  ),
                  SizedBox(width: x * 0.02),
                  const Text(
                    'Outros',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: x * 0.025),
        ],
      ),
    );
  }
}
