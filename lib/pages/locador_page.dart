import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

/*metodo para criar um card, por enquanto as imagens ainda sao padroes*/
  void createCard() {
    LatLng selectedLocation = const LatLng(-23.5505, -46.6333);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Localização'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    Text(
                      'Localização selecionada: $selectedLocation',
                    ),
                    SizedBox(
                      height: 200.0,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: selectedLocation,
                          zoom: 15.0,
                        ),
                        onTap: (LatLng location) async {
                          selectedLocation = location;
                          setState(() {});
                        },
                      ),
                    ),
                    Text(
                      'Localização selecionada: $selectedLocation',
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
                    location: selectedLocation,
                  );
                  myCards.add(mycard);
                });
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
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
            color: Colors.blue[800],
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

                //botao para abrir janela de criar card
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
              //lista geral - do tamanho da lista dos cards
              itemCount: myCards.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Swiper(
                            //lista do swiper - do tamanho da lista de imagens(images) do elemento do index atual da lista myCard,
                            itemCount: myCards[index].images.length,
                            autoplay: true,
                            pagination: const SwiperPagination(),
                            itemBuilder: (context, itemIndex) {
                              //serão varias Image.assets
                              return Image.asset(
                                //index do elemento de myCards, index da propriedade images
                                myCards[index].images[itemIndex],
                                fit: BoxFit.contain,
                              );
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Row(
                          children: [
                            //index do elemento de myCards, propriedade nome.
/*se myCards fosse uma lista de lista, seria myCards[index][0] 
(como é no caso do myCards[index].images[itemIndex],)
onde há images[], pois images é uma lista.*/
                            Text(myCards[index].nome),
                            const SizedBox(width: 10),
                            Text(myCards[index].lugar),
                            const SizedBox(width: 10),
                            Text(myCards[index].numero),
                            const SizedBox(width: 10),
                            Text(
                                'Latitude: ${myCards[index].location.latitude.toStringAsFixed(6)}, Longitude: ${myCards[index].location.longitude.toStringAsFixed(6)}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Ver no mapa'),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Editar'),
                              ),
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
