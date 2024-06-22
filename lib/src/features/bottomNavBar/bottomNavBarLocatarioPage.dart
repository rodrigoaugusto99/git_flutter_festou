import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/search/search_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/mensagens/mensagens.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/widgets/notifications_counter.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavBarLocatarioPage extends StatefulWidget {
  const BottomNavBarLocatarioPage({super.key});

  @override
  _BottomNavBarLocatarioPageState createState() =>
      _BottomNavBarLocatarioPageState();
}

class _BottomNavBarLocatarioPageState extends State<BottomNavBarLocatarioPage> {
  final Mensagens mensagens = const Mensagens();
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isLocador = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _fetchUserLocadorStatus();
    NotificationCounter();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserLocadorStatus() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Pegue o primeiro documento encontrado
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      setState(() {
        _isLocador = userDoc['locador'];
        _isLoading = false;
      });

      if (_isLocador) {
        // Atualize o campo 'locador' no documento do usuário
        await userDoc.reference.update({'locador': false});
        setState(() {
          _isLocador = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CustomLoadingIndicator());
    }

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: StreamBuilder<int>(
            stream: mensagens.getTotalUnreadMessagesCount(),
            builder: (context, snapshot) {
              int notificationCount = snapshot.data ?? 0;

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
                    title: const Text(
                      'Início',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  BottomBarItem(
                    icon: const Icon(Icons.search_outlined),
                    selectedIcon: const Icon(Icons.search),
                    selectedColor: Colors.blue,
                    title: const Text(
                      'Buscar',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  BottomBarItem(
                    icon: const Icon(
                      CupertinoIcons.heart,
                    ),
                    selectedIcon: const Icon(
                      CupertinoIcons.heart_fill,
                    ),
                    selectedColor: Colors.red,
                    title: const Text(
                      'Favoritos',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  BottomBarItem(
                    icon: const Icon(
                      Icons.person_outline,
                    ),
                    selectedIcon: const Icon(
                      Icons.person,
                    ),
                    selectedColor: Colors.deepPurple,
                    title: const Text(
                      'Perfil',
                      style: TextStyle(fontSize: 12),
                    ),
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
                  return const Profile();
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
