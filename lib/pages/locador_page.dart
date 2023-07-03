import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../model/my_card.dart';

class LocadorPage extends StatefulWidget {
  const LocadorPage({super.key});

  @override
  State<LocadorPage> createState() => _LocadorPageState();
}

class _LocadorPageState extends State<LocadorPage> {
  final nomeController = TextEditingController();
  final lugarController = TextEditingController();
  final numeroController = TextEditingController();

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
                    MyCard mycard = MyCard(
                      images: [
                        'lib/assets/images/salao5.png',
                        'lib/assets/images/salao6.png',
                        'lib/assets/images/salao7.png',
                        'lib/assets/images/salao8.png',
                      ],
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
    clear();
  }

  void clear() {
    nomeController.clear();
    lugarController.clear();
    numeroController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil Locador'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Meus espaços cadastrados',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 25, //feio
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    onPressed: createCard,
                    child: const Icon(
                      Icons.add,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            //EXPANDED PARA A LISTVIEW PEGAR O RESTANTE E N DAR OVERFLOW
            child: ListView.builder(
              itemCount: myCards.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Swiper(
                            itemCount: myCards[index].images.length,
                            autoplay: true,
                            pagination: const SwiperPagination(),
                            itemBuilder: (context, itemIndex) {
                              return Image.asset(
                                myCards[index].images[itemIndex],
                                fit: BoxFit.contain,
                              );
                            },
                          )),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.garage,
                                    color: Colors.black,
                                  ),
                                  Icon(
                                    Icons.fastfood,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                height: 18,
                                //width
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(125, 0, 254, 1),
                                      minimumSize: const Size(50, 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      )),
                                  child: const Text('Editar'),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
