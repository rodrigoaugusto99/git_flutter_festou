import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:git_flutter_festou/model/my_card.dart';

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

  List<MyCard> myCards = [];

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
                      image1: 'lib/assets/images/salao1.png',
                      image2: 'lib/assets/images/salao2.png',
                      image3: 'lib/assets/images/salao3.png',
                      image4: 'lib/assets/images/salao4.png',
                      nome: nomeController.text,
                      lugar: lugarController.text,
                      numero: numeroController.text,
                    );

                    myCards.add(mycard);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(),
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
                  itemCount: myCards.length,
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
                                items: [
                                  Image.asset(
                                    myCards[index].image1,
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    myCards[index].image2,
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    myCards[index].image3,
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    myCards[index].image4,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(40),
                                child: Row(
                                  children: [
                                    Text(myCards[index].nome),
                                    const SizedBox(width: 10),
                                    Text(myCards[index].lugar),
                                    const SizedBox(width: 10),
                                    Text(myCards[index].numero),
                                  ],
                                ),
                              )
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
        );
      },
    );
  }
}
