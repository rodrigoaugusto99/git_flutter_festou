import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LocatarioPage extends StatefulWidget {
  const LocatarioPage({Key? key}) : super(key: key);

  @override
  State<LocatarioPage> createState() => _LocatarioPageState();
}

class _LocatarioPageState extends State<LocatarioPage> {
  int currentPos = 0;
  List<String> listPaths = [
    "lib/assets/images/festa.png",
    "lib/assets/images/festa2.png",
    "lib/assets/images/festa3.png",
    "lib/assets/images/festa4.png",
  ];

  List<String> listPaths2 = [
    "lib/assets/images/salao1.png",
    "lib/assets/images/salao2.png",
    "lib/assets/images/salao3.png",
    "lib/assets/images/salao4.png",
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

  List<MaterialColor> colors = [
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.blueGrey
  ];

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return SafeArea(
          child: Scaffold(
            body: ListView(
              children: [
                //CONTAINER ROXO
                SizedBox(
                  height: height * 0.25,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      autoPlayCurve: Curves.decelerate,
                      height: height * 0.25,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, _) {
                        setState(() {
                          currentPos = index;
                        });
                      },
                    ),
                    items: listPaths.map((path) {
                      return Image.asset(
                        path,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: height * 0.01),

                //ROLAGEM HORIZONTAL
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        buttonCarouselController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                    ),
                    Expanded(
                      child: SizedBox(
                        height: height * 0.1,
                        child: CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            height: height * 0.1,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: true,
                            scrollDirection: Axis.horizontal,
                          ),
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
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        buttonCarouselController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                    ),
                  ],
                ),

                SizedBox(height: height * 0.01),

                //ROLAGEM VERTICAL
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listPaths2.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: height * 0.25,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1.0,
                            enableInfiniteScroll: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: listPaths2.map((path) {
                            return Image.asset(
                              path,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
