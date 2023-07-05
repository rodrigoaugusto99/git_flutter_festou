import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:git_flutter_festou/model/my_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/locatario_container.dart';
import '../widgets/locatario_row.dart';

class LocatarioHomePage extends StatefulWidget {
  const LocatarioHomePage({Key? key}) : super(key: key);

  @override
  State<LocatarioHomePage> createState() => _LocatarioHomePageState();
}

class _LocatarioHomePageState extends State<LocatarioHomePage> {
  List<String> listPaths = [
    "lib/assets/images/festa.png",
    "lib/assets/images/festa2.png",
    "lib/assets/images/festa3.png",
    "lib/assets/images/festa4.png",
  ];

  List<List<String>> tiposFesta = [
    ["lib/assets/images/toys.png", 'toys'],
    ["lib/assets/images/quinze.png", 'quinze'],
    ["lib/assets/images/buque.png", 'buque'],
    ["lib/assets/images/cha.png", 'cha'],
    ["lib/assets/images/reuniao.png", 'reuniao'],
  ];

  CarouselController buttonCarouselController = CarouselController();

  final nomeController = TextEditingController();
  final lugarController = TextEditingController();
  final numeroController = TextEditingController();

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

  List<MyCard> cardsParaMostrar = [];

  void createCard() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    hintText: 'nome',
                  ),
                ),
                TextField(
                  controller: lugarController,
                  decoration: const InputDecoration(
                    hintText: 'lugar',
                  ),
                ),
                TextField(
                  controller: numeroController,
                  decoration: const InputDecoration(
                    hintText: 'numero',
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Atualize a lista com os valores dos controladores
                    MyCard mycard = MyCard(
                      //imagens estaticas por enquanto
                      images: [
                        'lib/assets/images/salao5.png',
                        'lib/assets/images/salao6.png',
                        'lib/assets/images/salao7.png',
                        'lib/assets/images/salao8.png',
                      ],
                      nome: nomeController.text,
                      lugar: lugarController.text,
                      numero: numeroController.text,
                      location: const LatLng(-23.5505, -46.6333),
                    );

                    cardsParaMostrar.add(mycard);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          );
        });
    clear();
  }

  void clear() {
    nomeController.clear();
    lugarController.clear();
    numeroController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    nomeController.dispose();
    lugarController.dispose();
    numeroController.dispose();
  }

  final confettiController = ConfettiController();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Scaffold(
                appBar: AppBar(
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        if (isPlaying) {
                          confettiController.stop();
                        } else {
                          confettiController.play();
                        }
                        isPlaying = !isPlaying;
                      },
                      child: const Text('confete!'),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: createCard,
                ),
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
                      items: tiposFesta.map((path) {
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cardsParaMostrar.length,
                      itemBuilder: (context, index) {
                        //MyCard card = myCards[index]; // Obtenha o objeto MyCard
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30.0)),
                            child: Container(
                              color: Colors.deepPurple,
                              height: height * 0.45,
                              child: Column(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: height * 0.25,
                                      viewportFraction: 1.0,
                                      enableInfiniteScroll: true,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    items: cardsParaMostrar[index]
                                        .images
                                        .map((image) {
                                      return Image.asset(
                                        image,
                                        fit: BoxFit.contain,
                                      );
                                    }).toList(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Row(
                                      children: [
                                        Text(cardsParaMostrar[index].nome),
                                        const SizedBox(width: 10),
                                        Text(cardsParaMostrar[index].lugar),
                                        const SizedBox(width: 10),
                                        Text(cardsParaMostrar[index].numero),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              ConfettiWidget(
                  confettiController: confettiController,
                  blastDirection: pi / 2,
                  gravity: 0.005,
                  emissionFrequency: 0.01),
            ],
          ),
        );
      },
    );
  }
}
