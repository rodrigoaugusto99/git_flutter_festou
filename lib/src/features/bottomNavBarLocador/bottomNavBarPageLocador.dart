// bottomNavBarPageLocador.dart
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/profile.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/mensagens/mensagens.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_page.dart';

class BottomNavBarPageLocador extends StatefulWidget {
  final int initialIndex;
  const BottomNavBarPageLocador({super.key, this.initialIndex = 0});

  @override
  _BottomNavBarPageLocadorState createState() =>
      _BottomNavBarPageLocadorState();

  // Adicionando um método público para acessar o ConfettiController
  void playConfetti() {
    _BottomNavBarPageLocadorState? state =
        _BottomNavBarPageLocadorState._instance;
    state?.playConfetti();
  }
}

class _BottomNavBarPageLocadorState extends State<BottomNavBarPageLocador> {
  static _BottomNavBarPageLocadorState? _instance;
  late PageController _pageController;
  int _currentIndex = 0;
  late ConfettiController _controllerCenter;

  _BottomNavBarPageLocadorState() {
    _instance = this;
  }

  void playConfetti() {
    _controllerCenter.play();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllerCenter.dispose();
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

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
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
      bottomNavigationBar: SizedBox(
        height: 58, // Ajusta a altura para acomodar o botão flutuante
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.purple,
              unselectedItemColor: Colors.black,
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Espaços',
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
                  icon: Icon(Icons.person),
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
                onPressed: () {
                  playConfetti();
                },
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
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirection: -pi / 2, // radial value - LEFT
                  particleDrag: 0.05, // apply drag to the confetti
                  emissionFrequency: 1, // how often it should emit
                  numberOfParticles: 20, // number of particles to emit
                  gravity: 0.05, // gravity - or fall speed
                  shouldLoop: false,
                  maxBlastForce: 70,
                  /*colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink
              ],*/ // manually specify the colors to be used
                  strokeWidth: 1,
                  strokeColor: Colors.transparent,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                  //createParticlePath: drawStar,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
