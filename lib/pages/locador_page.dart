import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/my_textfields.dart';
import '../helpers/google_maps.dart';
import '../model/my_card.dart';
import 'calendar_page.dart';

class LocadorPage extends StatefulWidget {
  const LocadorPage({super.key});

  @override
  State<LocadorPage> createState() => _LocadorPageState();
}

class _LocadorPageState extends State<LocadorPage> {
  DateTime today = DateTime.now();

  //conjunto (Set) de DateTime que armazena as datas selecionadas pelo usuário.
  Set<DateTime> selectedDates = {};

  //horario de 1-24 para o dropdownButton
  List<String> hours =
      List.generate(24, (index) => (index + 1).toString().padLeft(2, '0'));

  //listas de horarios pré-selecionados
  List<String> selectedOpeningHours = List<String>.filled(7, '01');
  List<String> selectedClosingHours = List<String>.filled(7, '24');

  //cada row com dia da semana, e DropDownButtons
  Widget myRow({
    required String text,
    required String selectedOpeningHour,
    required String selectedClosingHour,
    required List<String> hours,
    required ValueChanged<String?> onOpeningHourChanged,
    required ValueChanged<String?> onClosingHourChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedOpeningHour,
              onChanged: onOpeningHourChanged,
              items: hours.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(width: 8),
            const Text('às'),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedClosingHour,
              onChanged: onClosingHourChanged,
              items: hours.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

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

//função do calendario
  void configureCalendar(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('calendario'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TableCalendar(
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        focusedDay: today,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 10, 16),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: (day) =>
                            selectedDates.contains(day),
                        onDaySelected: (day, focusedDay) {
                          setState(() {
                            if (selectedDates.contains(day)) {
                              selectedDates.remove(day);
                            } else {
                              selectedDates.add(day);
                            }
                          });
                        },
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple[500],
                          ),
                          defaultDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          weekendDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[400],
                          ),
                          selectedDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green[400],
                          ),
                        ),
                      ),
                      const Text(
                        "Configure os horarios",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      myRow(
                        text: 'segunda',
                        selectedOpeningHour: selectedOpeningHours[0],
                        selectedClosingHour: selectedClosingHours[0],
                        hours: hours,
                        onOpeningHourChanged: (String? newValue) {
                          setState(() {
                            selectedOpeningHours[0] = newValue!;
                          });
                        },
                        onClosingHourChanged: (String? newValue) {
                          setState(() {
                            selectedClosingHours[0] = newValue!;
                          });
                        },
                      ),
                      myRow(
                        text: 'terça',
                        selectedOpeningHour: selectedOpeningHours[1],
                        selectedClosingHour: selectedClosingHours[1],
                        hours: hours,
                        onOpeningHourChanged: (String? newValue) {
                          setState(() {
                            selectedOpeningHours[1] = newValue!;
                          });
                        },
                        onClosingHourChanged: (String? newValue) {
                          setState(() {
                            selectedClosingHours[1] = newValue!;
                          });
                        },
                      ),
                      myRow(
                        text: 'quarta',
                        selectedOpeningHour: selectedOpeningHours[2],
                        selectedClosingHour: selectedClosingHours[2],
                        hours: hours,
                        onOpeningHourChanged: (String? newValue) {
                          setState(() {
                            selectedOpeningHours[2] = newValue!;
                          });
                        },
                        onClosingHourChanged: (String? newValue) {
                          setState(() {
                            selectedClosingHours[2] = newValue!;
                          });
                        },
                      ),
                      myRow(
                        text: 'quinta',
                        selectedOpeningHour: selectedOpeningHours[3],
                        selectedClosingHour: selectedClosingHours[3],
                        hours: hours,
                        onOpeningHourChanged: (String? newValue) {
                          setState(() {
                            selectedOpeningHours[3] = newValue!;
                          });
                        },
                        onClosingHourChanged: (String? newValue) {
                          setState(() {
                            selectedClosingHours[3] = newValue!;
                          });
                        },
                      ),
                      myRow(
                        text: 'sexta',
                        selectedOpeningHour: selectedOpeningHours[4],
                        selectedClosingHour: selectedClosingHours[4],
                        hours: hours,
                        onOpeningHourChanged: (String? newValue) {
                          setState(() {
                            selectedOpeningHours[4] = newValue!;
                          });
                        },
                        onClosingHourChanged: (String? newValue) {
                          setState(() {
                            selectedClosingHours[4] = newValue!;
                          });
                        },
                      ),
                      myRow(
                        text: 'sábado',
                        selectedOpeningHour: selectedOpeningHours[5],
                        selectedClosingHour: selectedClosingHours[5],
                        hours: hours,
                        onOpeningHourChanged: (String? newValue) {
                          setState(() {
                            selectedOpeningHours[5] = newValue!;
                          });
                        },
                        onClosingHourChanged: (String? newValue) {
                          setState(() {
                            selectedClosingHours[5] = newValue!;
                          });
                        },
                      ),
                      myRow(
                        text: 'domingo',
                        selectedOpeningHour: selectedOpeningHours[6],
                        selectedClosingHour: selectedClosingHours[6],
                        hours: hours,
                        onOpeningHourChanged: (String? newValue) {
                          setState(() {
                            selectedOpeningHours[6] = newValue!;
                          });
                        },
                        onClosingHourChanged: (String? newValue) {
                          setState(() {
                            selectedClosingHours[6] = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

//criar o card
  Future<void> createCard() async {
    LatLng selectedLocation = const LatLng(-22.9259020, -43.1784924);

    /*na função, dizemos que ela será atribuida posteriormente 
pelo retorno da funcao getLocationName*/
    selectedLocationName = await getLocationName(selectedLocation);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Escolher Localização'),
            //statebuilder pro dialog poder ser atualizado com setsState
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextField(
                      controller: nomeController,
                      hintText: 'nome',
                    ),

                    MyTextField(
                      controller: lugarController,
                      hintText: 'localidade',
                    ),

                    MyTextField(
                      controller: numeroController,
                      hintText: 'numero para contato',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _openImagePicker,
                          icon: const Icon(Icons.photo),
                          label: const Text(
                            'Escolher Fotos',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            //fixedSize: const Size(10, 10),
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.blue, // Cor do texto do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            configureCalendar(context);
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: const Text(
                            'Calendário',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.green, // Cor do texto do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
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
                  ],
                );
              },
            ),
            actions: [
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
                    onPressed: () {},
                    /*{
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
                      Navigator.pop(context);
                    },*/
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    clear();
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

//retorna a string do local a partir de um objeto LatLng(obtido com o mapa)
  Future<String> getLocationName(LatLng coordinates) async {
    //getAddressFromCoordinates do arquivo de google_maps
    String address = await getAddressFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    return address;
  }

  /*----------------FUNÇÕES DO CARD-----------*/
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

  void verDisponibilidade(int index) {}

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
                              'Localização: ${myCards[index].selectedLocationName}',
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CalendarPage(),
                                  ),
                                );
                              },
                              child: const Text('Ver Calendário'),
                            ),
                            ElevatedButton(
                              onPressed: () => {},
                              child: const Text('Ver calendario 2'),
                            ),
                            ElevatedButton(
                              onPressed: () => verNoMapa(index),
                              child: const Text('Ver no mapa'),
                            ),
                            //botoes para ver as outras fotos selecionadas
                            //ver fotos
                            ElevatedButton(
                              onPressed: () => verFotos(index),
                              child: const Text('Ver mais fotos'),
                            ),
                            //ver fotos com zoom
                            ElevatedButton(
                              onPressed: () => verFotos2(index),
                              child: const Text('Ver mais fotos 2'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Editar'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('serviços disponiveis'),
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
