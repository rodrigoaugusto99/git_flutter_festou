import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_flutter_festou/model/card_comment.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../components/my_textfields.dart';
import '../helpers/google_maps.dart';
import '../model/card_reserve.dart';
import '../model/my_card.dart';

class CreateCard extends StatefulWidget {
  const CreateCard({super.key});

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  //no escopo do ESTADO pois são propriedades que precisam ser atualizadas

  //O CARD A SER CRIADO
  MyCard? mycard;
  List<Reserva> reservas = [];
  List<DateTime> markedDates = [];
  List<Comentario> comentarios = [];

  /*--------------------------------------------------*/
  /*---------------ELEMENTOS DO CARD-----------------*/
  /*--------------------------------------------------*/

  //controllers dos textfields DO CARD
  final nomeController = TextEditingController();
  final lugarController = TextEditingController();
  final numeroController = TextEditingController();
  final emailController = TextEditingController();

  //local inicial do mapa(atualizar para o local do usuario)
  LatLng selectedLocation = const LatLng(-22.9259020, -43.1784924);

  //valor inicial do tipo de espaço
  String selectedSpaceType = 'Casa';

  //valor inicial da disponibilidade
  String selectedAvailability = 'Todos os dias';

  //opções selecionadas para os servicos disponiveis
  List<String> selectedServices = [];

  //lista de imagens selecionadas
  List<File> selectedImages = [];

  //nome do local
  String selectedLocationName = '';

  //valor inicial para o TextField
  String spaceDescription = '';

  /*------------------------------------------------*/
  /*---------------ELEMENTOS DE SELEÇÃO-------------*/
  /*------------------------------------------------*/

  //Opções para os servicos disponiveis
  List<MultiSelectItem<String>> availableServices = [
    MultiSelectItem<String>('Cozinha', 'Cozinha'),
    MultiSelectItem<String>('Garçons', 'Garçons'),
    MultiSelectItem<String>('Decoração', 'Decoração'),
    MultiSelectItem<String>('Som e Iluminação', 'Som e Iluminação'),
    MultiSelectItem<String>('Estacionamento', 'Estacionamento'),
    MultiSelectItem<String>('Banheiros', 'Banheiros'),
    MultiSelectItem<String>('Segurança', 'Segurança'),
    MultiSelectItem<String>('Ar-condicionado', 'Ar-condicionado'),
    MultiSelectItem<String>('Limpeza ', 'Limpeza'),
    MultiSelectItem<String>('Bar', 'Bar'),
  ];

  //Opções para os tipos de espaçocs
  List<String> availableTypes = [
    'Casa',
    'Apartamento',
    'Chácara',
    'Salão',
  ];

  List<String> availability = [
    'Todos os dias',
    'Dias de semana',
    'Fins de semana',
  ];

  /*--------------------------------------------------*/
  /*---------------------FUNÇÕES-------------------- */
  /*--------------------------------------------------*/

  //função para lidar com a seleção de imagens
  Future<List<File>> _pickImages() async {
    List<File> images = [];
    final picker = ImagePicker();

    try {
      // Permita que o usuário escolha várias imagens
      final pickedImages = await picker.pickMultiImage();

//percorrendo e jogando as imagens no lista
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

//função para solicitar o usuario escolher as imagens
  Future<void> _openImagePicker() async {
    selectedImages = await _pickImages();
  }

  //retorna a string do local a partir de um objeto LatLng(obtido com o mapa)
  Future<String> getLocationName(LatLng coordinates) async {
    //getAddressFromCoordinates do arquivo de google_maps
    String address = await getAddressFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    return address;
  }

  //limpar controllers
  void clear() {
    nomeController.clear();
    lugarController.clear();
    numeroController.clear();
    selectedImages = [];
  }

  @override
  void dispose() {
    super.dispose();
    nomeController.dispose();
    lugarController.dispose();
    numeroController.dispose();
  }

  //função para selecionar os serviços disponiveis
  void _showServicesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione os serviços prestados'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: MultiSelectDialogField<String>(
              buttonText: const Text('Servicos'),
              items: availableServices,
              initialValue: selectedServices,
              onConfirm: (values) {
                setState(() {
                  selectedServices = values;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar card'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                child: Text(
                  'Insira os dados do seu espaço!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              MyTextField(
                controller: nomeController,
                hintText: 'Nome',
              ),

              MyTextField(
                controller: lugarController,
                hintText: 'Lugar',
              ),
              MyTextField(
                controller: numeroController,
                hintText: 'Numero para contato',
              ),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('Tipo de espaço'),
                  Text('Disponibilidade'),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: selectedSpaceType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSpaceType = newValue!;
                      });
                    },
                    items: availableTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: selectedAvailability,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAvailability = newValue!;
                      });
                    },
                    items: availability
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _showServicesDialog,
                    icon: const Icon(Icons.settings),
                    label: const Text('Serviços'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _openImagePicker,
                    icon: const Icon(Icons.photo),
                    label: const Text(
                      'Fotos',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),

              // TextField grande para descrição do espaço
              SizedBox(
                height: 100,
                child: TextField(
                  maxLines: null, // Permite múltiplas linhas
                  onChanged: (value) {
                    setState(() {
                      spaceDescription = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Descrição do espaço',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              //printando as coordenadas convertidas em string
              const Text(
                'Localização:',
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
              Text(
                selectedLocationName,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //ao adicionar, criar um novo objeto MyCard com todos os atributos recebidos.
                      //setState para atualizar a lista.

                      MyCard mycard = MyCard(
                          defaultImages: [
                            "lib/assets/images/festa.png",
                            "lib/assets/images/festa2.png",
                          ],
                          allImages: selectedImages,
                          images: selectedImages,
                          nome: nomeController.text,
                          lugar: lugarController.text,
                          numero: numeroController.text,
                          email: emailController
                              .text, // Adicionando o atributo email, caso ele exista no MyCard
                          selectedSpaceType:
                              selectedSpaceType, // Tipo de espaço selecionado
                          //para mostrar no mapa
                          location: selectedLocation,
                          //para mostrar o nome
                          selectedLocationName: selectedLocationName,
                          servicos: selectedServices, // Serviços selecionados
                          descricao: spaceDescription, // Descrição do espaço
                          selectedAvailability: selectedAvailability,
                          reservas: reservas,
                          markedDates: markedDates,
                          comentarios: comentarios);

                      Navigator.pop(context, mycard);
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
