import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/meus%20feedbacks/minhas_avaliacoes_widgets.dart';
import 'package:festou/src/helpers/helpers.dart';
import 'package:festou/src/models/avaliacoes_model.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/avaliacoes_service.dart';
import 'package:festou/src/services/space_service.dart';
import 'package:festou/src/services/user_service.dart';

class AvaliacoesMeusEspacosPage extends StatefulWidget {
  const AvaliacoesMeusEspacosPage({super.key});

  @override
  State<AvaliacoesMeusEspacosPage> createState() =>
      _AvaliacoesMeusEspacosPageState();
}

class _AvaliacoesMeusEspacosPageState extends State<AvaliacoesMeusEspacosPage> {
  List<AvaliacoesModel>? meusFeedbacks;
  List<SpaceModel>? mySpaces;
  UserService userService = UserService();
  SpaceService spaceService = SpaceService();
  UserModel? userModel;

  List<AvaliacoesModel>? selectedSpaceFeedbacks;

  SpaceModel? selectedSpace;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isLoading = true;
    userModel = await userService.getCurrentUserModel();
    await fetchSpaces();
    if (mySpaces != null && mySpaces!.isNotEmpty) {
      selectSpace(mySpaces!.first);
    }

    await fetchFeedbacksDoEspaco();

    if (mySpaces != null) {}

    mountedSetState();
    isLoading = false;
  }

  Future<void> fetchFeedbacksDoEspaco() async {
    if (selectedSpace == null) {
      return;
    }
    isLoading = true;
    // selectedSpaceReservations =
    //     await ReservaService().getReservationsBySpaceId(spaceId);
    selectedSpaceFeedbacks =
        await AvaliacoesService().getFeedbacksOrdered(selectedSpace!.spaceId);
    if (selectedSpaceFeedbacks == null) {
      log('selectedSpaceFeedbacks null');
      return;
    }
    isLoading = false;
    mountedSetState();
  }

  void selectSpace(SpaceModel space) {
    selectedSpace = space;
    fetchFeedbacksDoEspaco();
  }

  Future<void> fetchSpaces() async {
    mySpaces = await spaceService.getMySpaces();
  }

  void mountedSetState() {
    if (mounted) {
      setState(() {});
    }
  }

  // Future<void> fetchFeedbacks(String spaceId) async {
  //   // userModel = await userService.getCurrentUserModel();
  //   // if (userModel == null) {
  //   //   log('user null');
  //   //   return;
  //   // }

  //   selectedSpaceFeedbacks =
  //       await FeedbackService().getFeedbacksOrdered(spaceId);

  //   if (meusFeedbacks == null) {
  //     log('minhasReservas null');
  //     return;
  //   }
  //   // for (final feedback in meusFeedbacks!) {
  //   //   final user = await getUserById(feedback.userId);
  //   //   feedback.user = user;
  //   // }
  //   //  minhasReservasProximas = getNearbyReservations(minhasReservas!);
  // }

  Future<UserModel?> getUserById(String id) async {
    final user = await UserService().getCurrentUserModelById(id: id);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Avaliações recebidas',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfff8f8f8),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : selectedSpaceFeedbacks == null
              ? const Center(
                  child: Text(
                    'Você não tem espaços',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //clipBehavior: Clip.none,
                    // padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'Escolha o espaço',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...mySpaces!.map((space) {
                        return Column(
                          children: [
                            SpaceWidget(
                              isSelected:
                                  selectedSpace!.spaceId == space.spaceId,
                              space: space,
                              onTap: () => selectSpace(space),
                            ),
                            const SizedBox(height: 17),
                          ],
                        );
                      }),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Text(
                            'Avaliações ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '(${selectedSpaceFeedbacks!.length} avaliações)',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xff5E5E5E),
                            ),
                          ),
                        ],
                      ),
                      if (selectedSpaceFeedbacks != null &&
                          selectedSpaceFeedbacks!.isNotEmpty) ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selectedSpaceFeedbacks!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final feedback = selectedSpaceFeedbacks![index];
                            if (feedback.content == '' ||
                                feedback.deletedAt != null) {
                              return const SizedBox.shrink();
                            }
                            return AvaliacoesItem(
                              hideThings: true,
                              feedback: feedback,
                              onDelete: () {
                                selectedSpaceFeedbacks!.removeAt(index);
                              },
                            );
                          },
                        ),
                      ] else ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Nenhuma avaliação',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class SpaceWidget extends StatelessWidget {
  final SpaceModel space;
  final Function()? onTap;
  final bool isSelected;
  const SpaceWidget({
    super.key,
    required this.space,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            decContainer(
              radius: 8,
              color: const Color.fromARGB(255, 255, 255, 255),
              width: screenWidth(context) * 0.7,
              height: screenHeight(context) * 0.09,
              child: Stack(
                children: [
                  Image.network(
                    space.imagesUrl.isNotEmpty
                        ? space.imagesUrl[0]
                        : 'URL de uma imagem padrão ou vazia',
                    width: screenWidth(context) * 0.7,
                    height: screenHeight(context) * 0.09,
                    // color: Colors.green,

                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: decContainer(
                      color: Colors.white.withOpacity(0.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  space.titulo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${space.bairro}, ${space.cidade}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 66, 66, 66)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: getColor(
                                  double.parse(space.averageRating),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 4.0),
                                child: Text(
                                  double.parse(space.averageRating)
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white, // Cor do texto
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            decContainer(
              allPadding: 3,
              child: isSelected
                  ? decContainer(
                      radius: 20,
                      color: Colors.black,
                    )
                  : null,
              radius: 40,
              height: 12,
              width: 12,
              color: Colors.white,
              borderColor: const Color(0xffC6C6C6),
              borderWidth: 0.8,
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
