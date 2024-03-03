import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/search/search_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/home_page.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
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
      extendBody: true,
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const HomePage();
            case 1:
              return const SearchPage();
            case 2:
              return const MyFavoriteSpacePage();
            case 3:
              return const Profile();
            default:
              return Container(); // Lida com índices fora do alcance, se aplicável
          }
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          elevation: 4,
          onTap: _onTabTapped,
          selectedItemColor: const Color(0xff304571),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedItemColor: const Color(0xff304571),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/Ellipse 7casinha.png',
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/Ellipse 8lupinha.png',
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/Ellipse 9documentozinho.png',
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'lib/assets/images/Ellipse 10pessoinha.png',
              ),
              label: 'Profile',
            ),
          ],
        ),
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
