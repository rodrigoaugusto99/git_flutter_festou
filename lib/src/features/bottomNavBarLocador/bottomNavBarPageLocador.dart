import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/nova_tela.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/search_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/mensagens.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/menu.dart';
import 'package:git_flutter_festou/src/features/home/home_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20favorite%20spaces%20mvvm/my_favorite_spaces_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_page.dart';

class BottomNavBarPageLocador extends StatefulWidget {
  const BottomNavBarPageLocador({super.key});

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
    _pageController.jumpToPage(
      index,
    );
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
              return const Menu();
            default:
              return Container(); // Lida com índices fora do alcance, se aplicável
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Meus espaços',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Image.asset(
        'lib/assets/images/festou-logo.png',
        scale: 5,
        fit: BoxFit.cover,
      ),
    );
  }
}
