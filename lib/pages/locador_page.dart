import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/google_maps.dart';
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

  //no escopo do ESTADO pois são propriedades que precisam ser atualizadas
  List<MyCard> myCards = [];

// Inicialize a lista de imagens selecionadas
  List<File> selectedImages = [];

/*tem que ser variavel de estado pra ser usada lá no build
não pode estar dentro da função*/
  String selectedLocationName = '';

  Future<List<File>> _pickImages() async {
    List<File> images = [];
    final picker = ImagePicker();

    try {
      // Permita que o usuário escolha várias imagens
      final pickedImages = await picker.pickMultiImage();

      for (var pickedImage in pickedImages) {
        File image = File(pickedImage.path);
        images.add(image);
      }
    } on PlatformException catch (e) {
      // Trate erros ou negações de permissão
      print('Erro ao selecionar imagens: $e');
    }

    return images;
  }

  Future<void> _openImagePicker() async {
    selectedImages = await _pickImages();
  }

/*metodo para criar um card, por enquanto as imagens ainda sao padroes*/
  Future<void> createCard() async {
    LatLng selectedLocation = const LatLng(-22.9259020, -43.1784924);

    /*na função, dizemos que ela será atribuida posteriormente 
pelo retorno da funcao getLocationName*/
    selectedLocationName = await getLocationName(selectedLocation);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Localização'),
          //statebuilder pro dialog poder ser atualizado com setsState
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
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
                  //printando as coordenadas convertidas em string
                  Text(
                    'Localização selecionada: $selectedLocationName',
                  ),
                  SizedBox(
                    height: 200.0,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        //ponto central da camera inicial do mapa
                        target: selectedLocation,
                        zoom: 15.0,
                      ),
                      /*markers é a lista de posicoes selecionadas
                      no caso, é apenas um, que é sempre
                      o local clicado(onTap)*/
                      markers: {
                        Marker(
                          markerId: const MarkerId('location'),
                          position: selectedLocation,
                        ),
                      },
                      onTap: (LatLng location) async {
                        //onde é clicado, vira o target
                        selectedLocation = location;
                        //aproveita e pega essas coordenadas e transforma em endereço string
                        selectedLocationName =
                            await getLocationName(selectedLocation);
                        setState(() {}); //pra mudar o text no alertDialog
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: _openImagePicker,
                  child: const Text('Escolher Fotos'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //ao adicionar, criar um novo objeto MyCard com todos os atributos recebidos.
                    //setState para atualizar a lista.
                    setState(() {
                      MyCard mycard = MyCard(
                        defaultImages: [
                          "lib/assets/images/festa.png",
                          "lib/assets/images/festa2.png",
                        ],
                        images: selectedImages,
                        nome: nomeController.text,
                        lugar: lugarController.text,
                        numero: numeroController.text,
                        //para mostrar no mapa
                        location: selectedLocation,
                        //para mostrar o nome
                        selectedLocationName: selectedLocationName,
                      );
                      myCards.add(mycard);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Adicionar'),
                ),
              ],
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

//função que retorna a string do local a partir de um objeto LatLng(obtido com o mapa)
  Future<String> getLocationName(LatLng coordinates) async {
    //getAddressFromCoordinates do arquivo de google_maps
    String address = await getAddressFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    return address;
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
                          // lista do swiper - do tamanho da lista de imagens(images) do elemento do index atual da lista myCard,

                          //se a lista que o usuario deveria preencher está vazia, entao o itemCount é o do default
                          itemCount: myCards[index].images.isNotEmpty
                              ? myCards[index].images.length
                              : myCards[index].defaultImages.length,
                          autoplay: true,
                          pagination: const SwiperPagination(),
                          itemBuilder: (context, itemIndex) {
//se a lista não está vazia, imprime os files carregador(seu itemCount já está sincronizado)
                            return myCards[index].images.isNotEmpty
                                ? Image.file(
                                    myCards[index].images[itemIndex],
                                    fit: BoxFit.cover,
                                  )
//se a lista está vazia, imprime as imagens default(seu itemCount já está sincronizado)
                                : Image.asset(
                                    myCards[index].defaultImages[itemIndex],
                                    fit: BoxFit.cover,
                                  );
                          },
                        ),
                      ),
                      /*Image.asset(
                                //index do elemento de myCards, index da propriedade images
                                //[] lista das images da [] lista do mycards
                                myCards[index].images[itemIndex],
                                fit: BoxFit.contain,
                              );*/
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //index do elemento de myCards, propriedade nome.
/*se myCards fosse uma lista de lista, seria myCards[index][0] 
(como é no caso do myCards[index].images[itemIndex],)
onde há images[], pois images é uma lista.*/
                            Text('Nome: ${myCards[index].nome}'),
                            const SizedBox(width: 10),
                            Text('Lugar: ${myCards[index].lugar}'),
                            const SizedBox(width: 10),
                            Text('Numero: ${myCards[index].numero}'),
                            const SizedBox(width: 10),

                            Text(
                                'Localização: ${myCards[index].selectedLocationName}'),
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Localização no Mapa'),
                                        content: SizedBox(
                                          height: 200.0,
                                          //cada card terá um botao com esse widget
                                          child: GoogleMap(
                                            /*vai abrir inicialmente na posição cadastrada do card
                                            (propriedade location(LatLng) do card atual)*/
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: myCards[index].location,
                                              zoom: 15.0,
                                            ),
                                            markers: {
                                              Marker(
                                                markerId:
                                                    const MarkerId('location'),
                                                position:
                                                    myCards[index].location,
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
                                },
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
