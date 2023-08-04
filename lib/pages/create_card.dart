import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../components/my_textfields.dart';
import '../helpers/google_maps.dart';
import '../model/my_card.dart';

class CreateCard extends StatefulWidget {
  const CreateCard({super.key});

  @override
  State<CreateCard> createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  MyCard? mycard;
  // Valor inicial para o DropdownButton
  String selectedSpaceType = 'Casa';

  // Valor inicial para o TextField
  String spaceDescription = '';

  // Opções selecionadas para o que a casa oferece
  List<String> selectedOptions = [];

  //no escopo do ESTADO pois são propriedades que precisam ser atualizadas
  List<MyCard> myCards = [];

// Inicialize a lista de imagens selecionadas
  List<File> selectedImages = [];

/*tem que ser variavel de estado pra ser usada lá no build
não pode estar dentro da função*/
  String selectedLocationName = '';

  // Opções disponíveis para o que a casa oferece
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

  LatLng selectedLocation = const LatLng(-22.9259020, -43.1784924);

  final nomeController = TextEditingController();
  final lugarController = TextEditingController();
  final numeroController = TextEditingController();
  final emailController = TextEditingController();

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

  void _showSpaceTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione o tipo de salão'),
          content: DropdownButton<String>(
            value: selectedSpaceType,
            onChanged: (String? newValue) {
              setState(() {
                selectedSpaceType = newValue!;
              });
            },
            items: <String>['Casa', 'Apartamento', 'Chácara', 'Salão']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Selecionar'),
            ),
          ],
        );
      },
    );
  }

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
              initialValue: selectedOptions,
              onConfirm: (values) {
                setState(() {
                  selectedOptions = values;
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
                children: [
                  ElevatedButton.icon(
                    onPressed: _showSpaceTypeDialog,
                    icon: const Icon(Icons.category),
                    label: const Text('Tipo'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
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
                      setState(() {
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
                          servicos: selectedOptions, // Serviços selecionados
                          descricao: spaceDescription, // Descrição do espaço
                        );
                        myCards.add(mycard);
                      });
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
