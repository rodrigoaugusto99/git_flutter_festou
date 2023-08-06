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

  List<MyCard> filteredCards = [];

  bool isFiltered = false;

  /*----------------BOTÕES DO CARD------------*/

  //não precisam de int index pois cada card já significa filteredCards[index] ou myCards[index]
  void verNoMapa(MyCard card) {
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
                target: card.location,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('location'),
                  position: card.location,
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

  void verFotos(MyCard card) {
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
              itemCount: card.allImages.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return Image.file(
                  card.allImages[itemIndex],
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

  void verFotos2(MyCard card) {
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
                itemCount: card.allImages.length,
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
                              imageProvider:
                                  FileImage(card.allImages[itemIndex])),
                        ),
                      );
                    },
                    child: Image.file(
                      card.allImages[itemIndex],
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

  void maisDetalhes(MyCard card) {
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
              Text(card.selectedSpaceType),
              const SizedBox(height: 8),
              const Text(
                'Servicos disponiveis:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Loop forEach para mostrar cada serviço em um Text
              // Obs: Pode usar ListView.builder caso haja muitos itens
              // para melhorar a rolagem.
              ...card.servicos.map((servico) => Text(servico)),
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

  void clearFilter() {
    setState(() {
      isFiltered = false; // Definir como false para remover os filtros
    });
  }

  void showFilterAlertDialog(BuildContext context) {
    List<String> filterTypes = [
      'Casa',
      'Apartamento',
      'Chácara',
      'Salão',
    ];
    String spaceTypeToSearch = 'Casa'; // Valor inicial do DropdownButton

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar por Tipo de Espaço'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selecione o Tipo de Espaço:'),
              DropdownButton<String>(
                value: spaceTypeToSearch,
                onChanged: (String? newValue) {
                  spaceTypeToSearch =
                      newValue!; // Atualizar a variável diretamente
                },
                items:
                    filterTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Aqui você pode realizar a filtragem da lista de cards
                // com base no spaceTypeToSearch ou qualquer outro atributo que desejar
                applyFilter(spaceTypeToSearch);
                Navigator.of(context).pop();
              },
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  void applyFilter(String spaceType) {
    setState(() {
      if (spaceType.isNotEmpty) {
        filteredCards = myCards
            .where((card) => card.selectedSpaceType == spaceType)
            .toList();
        isFiltered = true; // Definir como true quando há um filtro aplicado
      } else {
        filteredCards = []; // Limpar a lista de cards filtrados
        isFiltered = false; // Definir como false quando não há filtro aplicado
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Text('Meu Perfil Locador'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Meus espaços cadastrados',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
            ),
          ),

          //botao para abrir janela de criar card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
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
                child: const Text('Criar card'),
              ),
              ElevatedButton(
                onPressed: () => showFilterAlertDialog(context),
                child: const Text('filtrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  clearFilter();
                },
                child: const Text('Limpar Filtros'),
              ),
            ],
          ),
          Expanded(
            //EXPANDED PARA A LISTVIEW PEGAR O RESTANTE E N DAR OVERFLOW
            child: ListView.separated(
//listview terá o tamanho da lista de acordo com o BOOL
              itemCount: isFiltered ? filteredCards.length : myCards.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10), // Espaço entre os itens da lista
              itemBuilder: (context, index) {
//cada card terá o index da respectiva lista de acordo com o BOOL
                MyCard card =
                    isFiltered ? filteredCards[index] : myCards[index];
/*agora, todos os cards que serão criados, ao construir cada elemento, como atributos e funcoes,
eles serao feitos usando o  CARD + atributo OU passando o CARD como parametro da função(verfotos, vermapa, etc) */
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
                          itemCount:
                              card.images.length > 4 ? 4 : card.images.length,
                          autoplay: true,
                          pagination: const SwiperPagination(),
                          itemBuilder: (context, itemIndex) {
                            return Image.file(
                              card.images[itemIndex],
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
                                  card.nome,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                //mandar a lista correta com base no estado do filtro
                                ElevatedButton(
                                  onPressed: () => maisDetalhes(card),
                                  child: const Text('Mais Detalhes'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Lugar do espaço com fontsize menor
                            Text(
                              card.lugar,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            // Descrição do espaço
                            Text(
                              'Descrição: ${card.descricao}',
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
                                      card.numero,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      card.email,
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
                                    verFotos(card);
                                  },
                                  child: const Text('Ver Fotos'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir as fotos
                                    verFotos2(card);
                                  },
                                  child: const Text('Ver Fotos'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir a localização no Google Maps
                                    verNoMapa(card);
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
