import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/locatario_cards.dart';
import '../widgets/locatario_container.dart';
import '../widgets/locatario_row.dart';

class LocatarioPage extends StatefulWidget {
  const LocatarioPage({Key? key}) : super(key: key);

  @override
  State<LocatarioPage> createState() => _LocatarioPageState();
}

class _LocatarioPageState extends State<LocatarioPage> {
  List<String> listPaths = [
    "lib/assets/images/festa.png",
    "lib/assets/images/festa2.png",
    "lib/assets/images/festa3.png",
    "lib/assets/images/festa4.png",
  ];

  List<List<String>> listPaths2 = [
    ['lib/assets/images/salao1.png', '1', '2', '3'],
    ['lib/assets/images/salao2.png', '4', '5', '6'],
    ['lib/assets/images/salao3.png', '7', '8', '9'],
    ['lib/assets/images/salao4.png', '10', '11', '12'],
  ];

  List<String> listPaths3 = [
    "lib/assets/images/salao5.png",
    "lib/assets/images/salao6.png",
    "lib/assets/images/salao7.png",
    "lib/assets/images/salao8.png",
  ];

  List<List<String>> listPaths4 = [
    ["lib/assets/images/toys.png", 'toys'],
    ["lib/assets/images/quinze.png", 'quinze'],
    ["lib/assets/images/buque.png", 'buque'],
    ["lib/assets/images/cha.png", 'cha'],
    ["lib/assets/images/reuniao.png", 'reuniao'],
  ];

  CarouselController buttonCarouselController = CarouselController();

  void onPressedBack() {
    buttonCarouselController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void onPressedNext() {
    buttonCarouselController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.blueGrey,
            body: ListView(
              children: [
                //CONTAINER
                LocatarioContainer(
                  height: height * 0.25,
                  items: listPaths.map((path) {
                    return Image.asset(
                      path,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
                SizedBox(height: height * 0.01),

                //ROLAGEM HORIZONTAL
                LocatarioRow(
                  height: height * 0.1,
                  onPressedBack: onPressedBack,
                  onPressedNext: onPressedNext,
                  carouselController: buttonCarouselController,
                  items: listPaths4.map((path) {
                    return Row(
                      children: [
                        Image.asset(
                          path[0],
                          fit: BoxFit.cover,
                        ),
                        Text(path[1]),
                      ],
                    );
                  }).toList(),
                ),

                SizedBox(height: height * 0.01),

                //ROLAGEM VERTICAL
                LocatarioCards(
                  itemCount: listPaths2.length,
                  height: height * 0.5,
                  carouselHeight: height * 0.3,
                  items: listPaths2.map((path) {
                    return Image.asset(
                      path[0],
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
