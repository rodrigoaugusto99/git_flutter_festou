import 'dart:developer';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/small_space_card.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_normal.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SurroundingSpacesPage extends ConsumerStatefulWidget {
  const SurroundingSpacesPage({super.key});

  @override
  ConsumerState<SurroundingSpacesPage> createState() =>
      _SurroundingSpacesPageState();
}

//TODO: spaces by surrounding area

class _SurroundingSpacesPageState extends ConsumerState<SurroundingSpacesPage> {
  SurroundingSpacesState previousState = SurroundingSpacesState(
      status: SurroundingSpacesStateStatus.loaded, spaces: []);
  GoogleMapController? mapController;
  CameraPosition? currentCameraPosition;
  var canRefresh = false;

  LatLngBounds rioDeJaneiroBounds = LatLngBounds(
    southwest: const LatLng(-23.336615865621933, -43.460534401237965),
    northeast: const LatLng(-22.472079364142523, -42.89604641497135),
  );

  @override
  Widget build(BuildContext context) {
    final allSpaces =
        ref.watch(surroundingSpacesVmProvider(rioDeJaneiroBounds));

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Buscar',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: allSpaces.when(
        data: (SurroundingSpacesState data) {
          // Atualiza o estado anterior quando os dados são carregados
          previousState = data;
          return buildMap(data, context);
        },
        error: (Object error, StackTrace stackTrace) {
          return const Stack(children: [
            Center(child: Text('Inserir imagem melhor papai')),
            Center(child: Icon(Icons.error)),
          ]);
        },
        loading: () {
          // Usa o estado anterior durante o carregamento
          return buildMap(previousState, context);
        },
      ),
    );
  }

  bool isShowingSomeSpace = false;
  SpaceModel? spaceShowing;
  void showSnippet(SpaceModel space) {
    isShowingSomeSpace = true;
    spaceShowing = space;
    setState(() {});
  }

  void navToPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewCardInfo(space: spaceShowing!),
      ),
    );
  }

  Color _getColor(double averageRating) {
    if (averageRating >= 4) {
      return Colors.green; // Ícone verde para rating maior ou igual a 4
    } else if (averageRating >= 2 && averageRating < 4) {
      return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
    } else {
      return Colors.red; // Ícone vermelho para rating abaixo de 2
    }
  }

  // Extrai o código do mapa para um método separado
  int _currentIndex = 0;
  Widget buildMap(SurroundingSpacesState data, BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        GoogleMap(
          onTap: (argument) {
            isShowingSomeSpace = false;
            setState(() {});
          },
          onCameraMoveStarted: () {
            if (canRefresh) {
              return;
            } else {
              setState(() {
                canRefresh = true;
              });
            }

            log(canRefresh.toString());
          },
          onMapCreated: (controller) {
            mapController = controller;
          },
          initialCameraPosition: currentCameraPosition ??
              const CameraPosition(
                target: LatLng(-22.9122, -43.2303),
                zoom: 10,
              ),
          onCameraMove: (CameraPosition cameraPosition) async {
            currentCameraPosition = cameraPosition;
            // Esta função será chamada sempre que a câmera do mapa for movida

            // Agora você pode usar a visibleRegion para obter os limites visíveis do mapa
            // e realizar qualquer lógica adicional, como chamar o Firestore para recuperar espaços dentro desses limites.
          },
          // circles: {
          //   ...data.spaces.map((space) {
          //     return Circle(
          //       circleId: CircleId(space.spaceId.toString()),
          //       center: LatLng(space.latitude, space.longitude),
          //       radius: 1000,
          //       strokeWidth: 0,
          //       fillColor: Colors.red.withOpacity(0.3),
          //     );
          //   }),
          // },
          markers: data.spaces.map((space) {
            return Marker(
              onTap: () => showSnippet(space),
              /*
              call method to show snippet
              showSnippet(space: space)
               */
              markerId: MarkerId(space.spaceId),
              position: LatLng(space.latitude, space.longitude),
            );
          }).toSet(),
        ),
        Positioned(
          width: 230,
          top: 200,
          child: ElevatedButton(
            onPressed: canRefresh != false
                ? () async {
                    LatLngBounds visibleRegion =
                        await mapController!.getVisibleRegion();
                    /*eu estava em duvida em sincronizar o initialCameraPosition
                        com o rioDeJaneiroBounds (visao inicial p carregar o espaços).
                        então, printei o valor da regiao visivel logo quando entra no mapa,
                        ou seja, quando é o initialCameraPosition.*/
                    log('Visible Region: $visibleRegion');

                    setState(() {
                      rioDeJaneiroBounds = visibleRegion;
                    });
                    canRefresh = false;
                  }
                : null,
            child: const Text('Carregar espaços nessa área'),
          ),
        ),
        Positioned(
          top: 95,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Color(0xff9747FF),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      hintStyle: TextStyle(fontSize: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isShowingSomeSpace)
          Positioned(
            bottom: 50,
            child: GestureDetector(
              onTap: navToPage,
              child: SizedBox(
                width: 300,
                height: 260,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CarouselSlider(
                        items: spaceShowing!.imagesUrl
                            .map((imageUrl) => Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ))
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 16 / 12,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 20,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            capitalizeFirstLetter(
                                                spaceShowing!.titulo),
                                            style: const TextStyle(
                                              fontFamily: 'RedHatDisplay',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        style: TextStyle(
                                            color: Colors.blueGrey[500],
                                            fontSize: 11),
                                        capitalizeTitle(
                                            "${spaceShowing!.bairro}, ${spaceShowing!.cidade}"),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: _getColor(
                                                double.parse(spaceShowing!
                                                    .averageRating),
                                              ),
                                            ),
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                              child: Text(
                                                double.parse(spaceShowing!
                                                        .averageRating)
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                              style: TextStyle(
                                                color: Color(0xff5E5E5E),
                                                fontSize: 10,
                                              ),
                                              "(105)"),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color:
                                                      const Color(0xff9747FF),
                                                ),
                                                width: 20,
                                                height: 20,
                                                child: const Icon(
                                                  Icons.attach_money,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Text(
                                            style: TextStyle(
                                                color: Color(0xff9747FF),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700),
                                            "R\$800,00/h",
                                          ),
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 20,
                                                color: Color(0xff9747FF),
                                              ),
                                              Text(
                                                  style: TextStyle(
                                                    color: Color(0xff5E5E5E),
                                                    fontSize: 10,
                                                  ),
                                                  "(598)"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
