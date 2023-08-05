import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/my_card.dart';
import 'create_card.dart';
import 'package:photo_view/photo_view.dart';

class LocadorPage extends StatefulWidget {
  const LocadorPage({super.key});

  @override
  State<LocadorPage> createState() => _LocadorPageState();
}

class _LocadorPageState extends State<LocadorPage> {
  //no escopo do ESTADO pois são propriedades que precisam ser atualizadas
  List<MyCard> myCards = [];

  /*----------------BOTÕES DO CARD------------*/
  void verNoMapa(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Localização no Mapa'),
          content: SizedBox(
            height: 200.0,
            //cada card terá um botao com esse widget
            child: GoogleMap(
              /*vai abrir inicialmente na posição cadastrada do card
                                            (propriedade location(LatLng) do card atual)*/
              initialCameraPosition: CameraPosition(
                target: myCards[index].location,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('location'),
                  position: myCards[index].location,
                ),
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void verFotos(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Todas as fotos'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            //cada card terá um botao com esse widget
            child: Swiper(
              itemCount: myCards[index].allImages.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return Image.file(
                  myCards[index].allImages[itemIndex],
                  fit: BoxFit.cover,
                );
              },
              // Defina a fração da largura ocupada por cada item do carrossel
              viewportFraction: 0.9,
              // Defina o fator de escala para os itens adjacentes ao item central
              scale: 0.95,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void verFotos2(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Todas as fotos'),
          content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.9,
              //cada card terá um botao com esse widget
              child: GridView.builder(
                itemCount: myCards[index].allImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Duas imagens por linha
                ),
                itemBuilder: (BuildContext context, int itemIndex) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoView(
                              initialScale: PhotoViewComputedScale.covered,
                              imageProvider: FileImage(
                                  myCards[index].allImages[itemIndex])),
                        ),
                      );
                    },
                    child: Image.file(
                      myCards[index].allImages[itemIndex],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              )),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void maisDetalhes(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mais detalhes',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),
              const Text(
                'Espaço:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(myCards[index].selectedSpaceType),
              const SizedBox(height: 8),
              const Text(
                'Servicos disponiveis:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Loop forEach para mostrar cada serviço em um Text
              // Obs: Pode usar ListView.builder caso haja muitos itens
              // para melhorar a rolagem.
              ...myCards[index].servicos.map((servico) => Text(servico)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
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
                  height: 25,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    onPressed: () async {
                      MyCard? newCard = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateCard(),
                        ),
                      );

                      if (newCard != null) {
                        setState(() {
                          myCards.add(newCard);
                        });
                      }
                    },
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
            child: ListView.separated(
              // Lista geral - do tamanho da lista dos cards
              itemCount: myCards.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10), // Espaço entre os itens da lista
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.25, // Defina uma altura fixa para o Container
                        child: Swiper(
                          //esquema para o swiper exibir apenas as 4 primeiras imagens
                          //se o numero de imagens for maior q 4, o tamanho da lista é 4
                          itemCount: myCards[index].images.length > 4
                              ? 4
                              : myCards[index].images.length,
                          autoplay: true,
                          pagination: const SwiperPagination(),
                          itemBuilder: (context, itemIndex) {
                            return Image.file(
                              myCards[index].images[itemIndex],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //index do elemento de myCards, propriedade nome.
                            /*se myCards fosse uma lista de lista, seria myCards[index][0] 
            (como é no caso do myCards[index].images[itemIndex],)
            onde há images[], pois images é uma lista.*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Nome do espaço com fontsize maior
                                Text(
                                  myCards[index].nome,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                  onPressed: () => maisDetalhes(index),
                                  child: const Text('Mais Detalhes'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Lugar do espaço com fontsize menor
                            Text(
                              myCards[index].lugar,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            // Descrição do espaço
                            Text(
                              'Descrição: ${myCards[index].descricao}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            // Número de contato e e-mail no canto inferior direito
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Contato:'),
                                    Text(
                                      myCards[index].numero,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      myCards[index].email,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Botões estilizados para exibir fotos e localização no Google Maps
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir as fotos
                                    verFotos(index);
                                  },
                                  child: const Text('Ver Fotos'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir as fotos
                                    verFotos2(index);
                                  },
                                  child: const Text('Ver Fotos'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir a localização no Google Maps
                                    verNoMapa(index);
                                  },
                                  child: const Text('Ver Localização'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
