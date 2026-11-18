import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_state.dart';
import 'package:festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_vm.dart';
import 'package:festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/services/user_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SurroundingSpacesPage extends ConsumerStatefulWidget {
  const SurroundingSpacesPage({super.key});

  @override
  ConsumerState<SurroundingSpacesPage> createState() =>
      _SurroundingSpacesPageState();
}

class _SurroundingSpacesPageState extends ConsumerState<SurroundingSpacesPage> {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  bool isShowing = false;

  List<SpaceModel> filteredList = [];

  List<SpaceModel> allSpaces = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    allSpaces = await getAllSpaces();

    setState(() {});
  }

  void onChangedSearch(String value) {
    log(value, name: 'value');
    if (value == '') {
      isShowing = false;
      setState(() {
        filteredList = [];
      });
      return;
    }
    String searchValue = value.toLowerCase();

    setState(() {
      filteredList = allSpaces
          .where(
              (project) => project.titulo.toLowerCase().contains(searchValue))
          .toList();
    });
    log(filteredList.toString(), name: 'espacos filtrados');
    // Adicionando a busca ao histórico
  }

  Future<List<SpaceModel>> getAllSpaces() async {
    try {
      //pega todos os documentos dos espaços
      final allSpaceDocuments =
          await spacesCollection.where('deletedAt', isNull: true).get();

//await pois retorna future
//pega os favoritos do usuario
      final userSpacesFavorite = await getUserFavoriteSpaces();

/*percorre todos os espaços levando em conta os favoritos
p decidir o isFavorited*/

//todo: mapSpaceDocumentToModel ajustado
      List<SpaceModel> spaceModels =
          await Future.wait(allSpaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      return spaceModels;
    } catch (e) {
      log('Erro ao recuperar todos os espaços: $e');
      return [];
    }
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;
  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    //se esse erro ocorrer la numm metodo que chama getUsrDocument, o (e) do catch vai ter essa msg
    throw Exception("Usuário n encontrado");
  }

  Future<List<String>?> getUserFavoriteSpaces() async {
    final userDocument = await getUserDocument();

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }

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
      backgroundColor: Colors.white,
      body: allSpaces.when(
        data: (SurroundingSpacesState data) {
          // Atualiza o estado anterior quando os dados são carregados
          previousState = data;
          return buildMap(data, context);
        },
        error: (Object error, StackTrace stackTrace) {
          return const Stack(children: [
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

  final userService = UserService();
  void navToPage() {
    userService.updateLastSeen(spaceShowing!.spaceId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewCardInfo(spaceId: spaceShowing!.spaceId),
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
  int currentIndex = 0;

  static const _ink = Color(0xFF1C1426);
  static const _accent = Color(0xFF7C3AED);

  Widget buildMap(SurroundingSpacesState data, BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

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
          },
          markers: data.spaces.map((space) {
            return Marker(
              onTap: () => showSnippet(space),
              markerId: MarkerId(space.spaceId),
              position: LatLng(space.latitude, space.longitude),
            );
          }).toSet(),
        ),

        // Header flutuante
        Positioned(
          top: topInset + 8,
          left: 16,
          right: 16,
          child: Row(
            children: [
              _MapCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x14000000)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Buscar no mapa',
                    style: TextStyle(
                      fontFamily: 'RedHatDisplay',
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: -0.2,
                      color: _ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Botão "Mostrar nessa área"
        Positioned(
          top: topInset + 72,
          left: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: !canRefresh,
            child: AnimatedOpacity(
              opacity: canRefresh ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: AnimatedSlide(
                offset: canRefresh ? Offset.zero : const Offset(0, -0.15),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(99),
                      onTap: () async {
                        if (mapController == null) return;
                        final visibleRegion =
                            await mapController!.getVisibleRegion();
                        log('Visible Region: $visibleRegion');
                        setState(() {
                          rioDeJaneiroBounds = visibleRegion;
                          canRefresh = false;
                        });
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9747FF), Color(0xFF6100FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.my_location_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Mostrar nessa área',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  letterSpacing: -0.1,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        if (isShowingSomeSpace)
          Positioned(
            bottom: 90,
            child: GestureDetector(
              onTap: () => navToPage(),
              child: SizedBox(
                width: 320,
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
                              currentIndex = index;
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
                                width: 270,
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
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                  style: const TextStyle(
                                                    color: Color(0xff5E5E5E),
                                                    fontSize: 10,
                                                  ),
                                                  '(${spaceShowing!.numComments})'),
                                            ],
                                          ),
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
                                              const SizedBox(width: 3),
                                              Text(
                                                style: const TextStyle(
                                                    color: Color(0xff9747FF),
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                "R\$${spaceShowing!.preco}/h",
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.favorite,
                                                size: 20,
                                                color: Color(0xff9747FF),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                  style: const TextStyle(
                                                    color: Color(0xff5E5E5E),
                                                    fontSize: 10,
                                                  ),
                                                  "(${spaceShowing!.numLikes})"),
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

class _MapCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF1C1426), size: 22),
        ),
      ),
    );
  }
}
