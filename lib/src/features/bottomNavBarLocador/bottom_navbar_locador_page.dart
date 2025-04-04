import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/profile/profile.dart';
import 'package:festou/src/features/bottomNavBarLocador/calendario/calendario.dart';
import 'package:festou/src/features/bottomNavBarLocador/mensagens/mensagens.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_page.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavBarLocadorPage extends StatefulWidget {
  final int initialIndex;
  const BottomNavBarLocadorPage({super.key, this.initialIndex = 0});

  @override
  _BottomNavBarLocadorPageState createState() =>
      _BottomNavBarLocadorPageState();

  // Adicionando um método público para acessar o ConfettiController
  void playConfetti() {
    _BottomNavBarLocadorPageState? state =
        _BottomNavBarLocadorPageState._instance;
    state?.playConfetti();
  }
}

class _BottomNavBarLocadorPageState extends State<BottomNavBarLocadorPage> {
  final Mensagens mensagens = const Mensagens();
  static _BottomNavBarLocadorPageState? _instance;
  late PageController _pageController;
  late ConfettiController _controllerCenter;
  int _currentIndex = 0;
  bool _isLocador = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _fetchUserLocadorStatus();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  void playConfetti() {
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllerCenter.dispose();
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

      if (!_isLocador) {
        // Atualize o campo 'locador' no documento do usuário
        await userDoc.reference.update({'locador': true});
        setState(() {
          _isLocador = true;
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

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
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
                      icon: const Icon(Icons.calendar_month_outlined),
                      selectedIcon: const Icon(Icons.calendar_month),
                      selectedColor: Colors.blue,
                      title: const Text(
                        'Calendário',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    BottomBarItem(
                      icon: const Icon(
                        CupertinoIcons.envelope,
                      ),
                      selectedIcon: const Icon(
                        CupertinoIcons.envelope,
                      ),
                      selectedColor: Colors.red,
                      title: const Text(
                        'Mensagens',
                        style: TextStyle(fontSize: 12),
                      ),
                      badge: Text(notificationCount > 99
                          ? '99+'
                          : '$notificationCount'),
                      showBadge: notificationCount > 0 && _currentIndex != 2,
                      badgeColor: Colors.purple,
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
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
                'lib/assets/images/logo_festou.png',
                scale: 5,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirection: -pi / 2,
              particleDrag: 0.05,
              emissionFrequency: 1,
              numberOfParticles: 20,
              gravity: 0.05,
              shouldLoop: false,
              maxBlastForce: 70,
              strokeWidth: 1,
              strokeColor: Colors.transparent,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }
}
