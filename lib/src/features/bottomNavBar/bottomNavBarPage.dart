import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/account.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/notifications.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/search/search_page.dart';
import 'package:git_flutter_festou/src/features/home/home_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20favorite%20spaces%20mvvm/my_favorite_spaces_page.dart';

class BottomNavBarPage extends StatefulWidget {
  final ValueNotifier<String?> previousRouteNotifier;
  BottomNavBarPage({Key? key, String? previousRoute})
      : previousRouteNotifier = ValueNotifier<String?>(previousRoute),
        super(key: key);

  @override
  _BottomNavBarPageState createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    _pages = [
      ValueListenableBuilder<String?>(
        valueListenable: widget.previousRouteNotifier,
        builder: (context, value, child) {
          widget.previousRouteNotifier.value = null;
          return Navigator(
            // Envolver HomePage com Navigator
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) => const HomePage(),
              );
            },
          );
        },
      ),
      const SearchPage(),
      const MyFavoriteSpacePage(),
      const Account(),
    ];
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
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
