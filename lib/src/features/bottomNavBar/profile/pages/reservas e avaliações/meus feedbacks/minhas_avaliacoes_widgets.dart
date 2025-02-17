import 'package:festou/src/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/register/avaliacoes/avaliacoes_register_page.dart';
import 'package:festou/src/models/avaliacoes_model.dart';
import 'package:festou/src/models/reservation_model.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/services/avaliacoes_service.dart';
import 'package:festou/src/services/reserva_service.dart';
import 'package:festou/src/services/space_service.dart';

class MinhasAvaliacoesWidget extends StatefulWidget {
  final List<AvaliacoesModel> initialFeedbacks;

  const MinhasAvaliacoesWidget({
    super.key,
    required this.initialFeedbacks,
  });

  @override
  State<MinhasAvaliacoesWidget> createState() => _MinhasAvaliacoesWidgetState();
}

class _MinhasAvaliacoesWidgetState extends State<MinhasAvaliacoesWidget> {
  late List<AvaliacoesModel> feedbacks;

  @override
  void initState() {
    super.initState();
    feedbacks = List.from(widget.initialFeedbacks);
  }

  Future<void> refreshFeedbacks() async {
    List<AvaliacoesModel> updatedFeedbacks = await AvaliacoesService()
        .getMyFeedbacks(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      feedbacks = updatedFeedbacks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.white,
          collapsedShape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          leading: Image.asset(
            'lib/assets/images/icon_avaliacao.png',
            width: 30,
            height: 30,
          ),
          title: const Text(
            'Minhas avaliações',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          children: feedbacks.isEmpty
              ? [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Nenhuma avaliação encontrada.',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ]
              : [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: feedbacks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final feedback = feedbacks[index];
                      return AvaliacoesItem(
                        feedback: feedback,
                        onDelete: () async {
                          await refreshFeedbacks();
                        },
                      );
                    },
                  ),
                ],
        ),
      ),
    );
  }
}

class AvaliacoesItem extends StatefulWidget {
  final bool hideThings;
  final AvaliacoesModel feedback;
  final VoidCallback onDelete;

  const AvaliacoesItem({
    super.key,
    required this.feedback,
    this.hideThings = false,
    required this.onDelete,
  });

  @override
  _AvaliacoesItemState createState() => _AvaliacoesItemState();
}

class _AvaliacoesItemState extends State<AvaliacoesItem> {
  bool isLiked = false;
  bool isDisliked = false;
  bool canShowButtons = false;
  ReservationModel? reservation;
  late AvaliacoesService feedbackService;

  Future<void> _loadReservation() async {
    try {
      final reservations = await ReservaService()
          .getReservationsBySpaceId(widget.feedback.spaceId);

      ReservationModel? latestValidReservation;

      for (var reservation in reservations) {
        if (reservation.canceledAt == null && reservation.hasReview == false) {
          latestValidReservation = reservation;
        }
      }

      if (latestValidReservation != null) {
        setState(() async {
          reservation = latestValidReservation;
          canShowButtons = _validateReservation(latestValidReservation!);
          canShowButtons = await isMyFeedback();
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> isMyFeedback() async {
    final user = await UserService().getCurrentUserModel();
    return user!.uid == widget.feedback.userId;
    // return now.isBefore(threeMonthLimit) && reservation.canceledAt == null;
  }

  bool _validateReservation(ReservationModel reservation) {
    final DateTime now = DateTime.now();
    final DateTime threeMonthLimit;

    DateTime selectedFinalDate;

    selectedFinalDate = (reservation.selectedFinalDate).toDate();
    threeMonthLimit = selectedFinalDate.add(const Duration(days: 90));

    return now.isBefore(threeMonthLimit) && reservation.canceledAt == null;
  }

  @override
  void initState() {
    super.initState();
    feedbackService = AvaliacoesService();
    myFeedback = widget.feedback;
    _checkUserReaction();
    _loadReservation();
    getSpace();
  }

  SpaceModel? space;
  AvaliacoesModel? myFeedback;

  Future<void> getSpace() async {
    space = await SpaceService().getSpaceById(widget.feedback.spaceId);
    setState(() {});
  }

  Future<void> _checkUserReaction() async {
    String reaction =
        await feedbackService.checkUserReaction(widget.feedback.id);
    setState(() {
      isLiked = reaction == "isLiked";
      isDisliked = reaction == "isDisliked";
    });
  }

  updateFeedback() async {
    myFeedback = await AvaliacoesService().getFeedbackById(widget.feedback.id);
    _checkUserReaction();
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, Function onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: const Text(
              "Tem certeza de que deseja excluir esta avaliação? Esta ação não pode ser desfeita."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem excluir
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                onConfirm(); // Chama a função de exclusão
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return space == null || myFeedback == null
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 27, top: 19, bottom: 15, right: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (myFeedback!.avatar == '')
                            const CircleAvatar(
                              radius: 23,
                              child: Icon(Icons.person),
                            ),
                          if (myFeedback!.avatar != '')
                            CircleAvatar(
                              backgroundImage: Image.network(
                                myFeedback!.avatar,
                                fit: BoxFit.cover,
                              ).image,
                              radius: 23,
                            ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myFeedback!.userName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              Text(
                                myFeedback!.date,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff5E5E5E),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: _getColor(
                                  double.parse(
                                      myFeedback!.rating.toStringAsFixed(1)),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    double.parse(myFeedback!.rating.toString())
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!widget.hideThings)
                        Align(
                          child: Column(
                            children: [
                              Text(
                                space!.titulo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${space!.bairro}, ${space!.cidade}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff5E5E5E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 17),
                      Text(myFeedback!.content.toString()),
                      const SizedBox(height: 17),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await feedbackService
                                  .toggleLikeFeedback(myFeedback!.id);
                              updateFeedback();
                            },
                            child: Image.asset(
                              'lib/assets/images/icon_like.png',
                              width: 20,
                              color: isLiked ? Colors.blue : null,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text('(${myFeedback!.likes.length})'),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              await feedbackService
                                  .toggleDislikeFeedback(myFeedback!.id);
                              updateFeedback();
                            },
                            child: Image.asset(
                              'lib/assets/images/icon_dislike.png',
                              width: 20,
                              color: isDisliked ? Colors.red : null,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text('(${myFeedback!.dislikes.length})'),
                          const Spacer(),
                          if (canShowButtons)
                            GestureDetector(
                              onTap: () async {
                                final updatedFeedback =
                                    await showDialog<AvaliacoesModel>(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: AvaliacoesPage(
                                        space: space!,
                                        feedback:
                                            myFeedback, // Passando a avaliação existente
                                      ),
                                    );
                                  },
                                );
                                if (updatedFeedback != null) {
                                  setState(() {
                                    myFeedback = updatedFeedback;
                                  });
                                }
                              },
                              child: const Text(
                                'Editar',
                                style: TextStyle(
                                  color: Color(0xff9747FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(width: 16),
                          if (canShowButtons)
                            GestureDetector(
                              onTap: () async {
                                showDeleteConfirmationDialog(context, () async {
                                  await AvaliacoesService()
                                      .deleteFeedbackByCondition(
                                    widget.feedback.id,
                                    FirebaseAuth.instance.currentUser!.uid,
                                  );

                                  await ReservaService().updateHasReview(
                                      widget.feedback.reservationId, false);

                                  widget
                                      .onDelete(); // Chama refreshFeedbacks() no widget pai
                                });
                              },
                              child: const Text(
                                'Excluir',
                                style: TextStyle(
                                  color: Color(0xffFF0000),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Color _getColor(double averageRating) {
    if (averageRating >= 4) {
      return const Color(0xff00A355);
    } else if (averageRating >= 2 && averageRating < 4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  List<Icon> buildStarIcons(int rating) {
    final List<Icon> stars = List.generate(
      5,
      (index) => Icon(
        Icons.star,
        color: index < rating
            ? rating == 1 || rating == 2
                ? Colors.red
                : rating == 3
                    ? Colors.orange
                    : Colors.green
            : Colors.grey[300],
        size: 14.0,
      ),
    );

    return stars;
  }
}
