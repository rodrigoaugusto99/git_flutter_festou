import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/search/search_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_flutter_festou/src/features/widgets/notifications_counter.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

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
    NotificationCounter();
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              int notificationCount = 0;
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                var userDoc = snapshot.data!.docs.first;
                notificationCount = userDoc['notifications'] ?? 0;
              }

              return StylishBottomBar(
                option: DotBarOptions(
                  dotStyle: DotStyle.tile,
                  gradient: const LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Colors.pink,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                items: [
                  BottomBarItem(
                    icon: const Icon(
                      Icons.house_outlined,
                    ),
                    selectedIcon: const Icon(Icons.house_rounded),
                    selectedColor: Colors.teal,
                    unSelectedColor: Colors.grey,
                    title: const Text('Início'),
                  ),
                  BottomBarItem(
                    icon: const Icon(Icons.search_outlined),
                    selectedIcon: const Icon(Icons.search),
                    selectedColor: Colors.blue,
                    title: const Text('Buscar'),
                  ),
                  BottomBarItem(
                      icon: const Icon(
                        CupertinoIcons.heart,
                      ),
                      selectedIcon: const Icon(
                        CupertinoIcons.heart_fill,
                      ),
                      selectedColor: Colors.red,
                      title: const Text('Favoritos')),
                  BottomBarItem(
                    icon: const Icon(
                      Icons.person_outline,
                    ),
                    selectedIcon: const Icon(
                      Icons.person,
                    ),
                    selectedColor: Colors.deepPurple,
                    title: const Text('Perfil'),
                    badge: Text(
                        notificationCount > 99 ? '99+' : '$notificationCount'),
                    showBadge: notificationCount > 0,
                    badgeColor: Colors.purple,
                    badgePadding: const EdgeInsets.only(left: 4, right: 4),
                  ),
                ],
                hasNotch: true,
                fabLocation: StylishBarFabLocation.center,
                currentIndex: _currentIndex,
                notchStyle: NotchStyle.square,
                onTap: (index) {
                  if (index == _currentIndex) return;
                  _pageController.jumpToPage(index);
                  setState(() {
                    _currentIndex = index;
                  });
                },
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                  return const Profile(false);
                default:
                  return Container(); // Lida com índices fora do alcance, se aplicável
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Image.asset(
              'lib/assets/images/festou-logo.png',
              scale: 5,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
