import 'package:flutter/material.dart';
import 'package:git_flutter_festou/old/pages/locatario/locatario_account.dart';
import 'package:git_flutter_festou/old/pages/locatario/locatario_home_page.dart';
import 'package:git_flutter_festou/old/pages/locatario/locatario_search.dart';
import 'package:git_flutter_festou/old/pages/locatario/locatario_settings.dart';

class LocatarioNavigationBottomBar extends StatefulWidget {
  const LocatarioNavigationBottomBar({super.key});

  @override
  State<LocatarioNavigationBottomBar> createState() =>
      _LocatarioNavigationBottomBarState();
}

class _LocatarioNavigationBottomBarState
    extends State<LocatarioNavigationBottomBar> {
  int selectedIndex = 0;

  void navigate(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    const LocatarioHomePage(),
    const LocatarioSearch(),
    const LocatarioSettings(),
    const LocatarioAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: navigate,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
