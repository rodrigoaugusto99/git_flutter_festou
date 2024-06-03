import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/mensagens/mensagens.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu/menu.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_page.dart';

class BottomNavBarPageLocador extends StatefulWidget {
  final int initialIndex;
  const BottomNavBarPageLocador({super.key, this.initialIndex = 0});

  @override
  _BottomNavBarPageLocadorState createState() =>
      _BottomNavBarPageLocadorState();
}

class _BottomNavBarPageLocadorState extends State<BottomNavBarPageLocador> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const MySpacesPage();
            case 1:
              return const Calendario();
            case 2:
              return const Mensagens();
            case 3:
              return const Profile(true);
            default:
              return Container(); // Lida com índices fora do alcance, se aplicável
          }
        },
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.black,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Espaços',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Calendário',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Mensagens',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'lib/assets/images/Ellipse 10pessoinha.png',
                ),
                label: 'Profile',
              ),
            ],
          ),
          Positioned(
            width: 70,
            height: 70,
            top:
                -35, // Ajuste este valor conforme necessário para posicionar corretamente o botão flutuante
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: FloatingActionButton(
              onPressed: () {},
              disabledElevation: 0,
              elevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              hoverColor: Colors.transparent,
              hoverElevation: 0,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'lib/assets/images/festou-logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
