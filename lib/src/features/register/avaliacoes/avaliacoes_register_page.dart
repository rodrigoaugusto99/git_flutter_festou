import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/avaliacoes/avaliacoes_register_vm.dart';
import 'package:git_flutter_festou/src/models/avaliacoes_model.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';

class AvaliacoesPage extends ConsumerStatefulWidget {
  final SpaceModel space;
  final AvaliacoesModel? feedback;
  final ReservationModel? reservation;
  const AvaliacoesPage(
      {super.key, required this.space, this.feedback, this.reservation});

  @override
  ConsumerState<AvaliacoesPage> createState() => _RatingViewState();
}

class _RatingViewState extends ConsumerState<AvaliacoesPage> {
  final _ratingPageController = PageController();
  var _starPosition = 180.0;
  var starRatingIndex = 0;
  TextEditingController contentController = TextEditingController();

  bool get _canConfirm => starRatingIndex > 0;

  @override
  void initState() {
    super.initState();
    _initializeFeedback();
  }

  void _initializeFeedback() {
    if (widget.feedback != null) {
      setState(() {
        starRatingIndex = widget.feedback!.rating; // Recupera a nota anterior
        contentController.text =
            widget.feedback!.content; // Recupera o comentário
        _starPosition =
            40.0; // Ajusta a posição das estrelas para a posição correta
      });
    }
  }

  Future<String?> getReservationDocumentId(
      String spaceId, String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('space_id', isEqualTo: spaceId)
          .where('canceledAt', isEqualTo: null)
          .where('hasReview', isEqualTo: false)
          .where('client_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Erro ao buscar reserva: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedbackRegisterVm = ref.watch(feedbackRegisterVmProvider.notifier);

    final errorMessager =
        ref.watch(feedbackRegisterVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (errorMessager.toString() != '') {
        Messages.showError(errorMessager, context);
      }
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SizedBox(
            height: math.max(300, MediaQuery.of(context).size.height * 0.3),
            child: PageView(
                controller: _ratingPageController,
                physics: const NeverScrollableScrollPhysics(),
                children: widget.feedback == null
                    ? [
                        buildThanksNote(),
                        causeOfRating(),
                      ]
                    : [
                        causeOfRating(),
                      ]),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: _canConfirm
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF9747FF),
                          Color(0xFF4300B1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: _canConfirm ? null : Colors.grey,
              ),
              child: MaterialButton(
                onPressed: _canConfirm
                    ? () async {
                        AvaliacoesModel updatedFeedback;
                        String? reservationId = await getReservationDocumentId(
                          widget.space.spaceId,
                          widget.reservation!.clientId,
                        );

                        if (widget.feedback == null) {
                          // Criando novo feedback
                          await feedbackRegisterVm.register(
                            spaceId: widget.space.spaceId,
                            reservationId: reservationId!,
                            rating: starRatingIndex,
                            content: contentController.text,
                          );

                          await ReservaService().updateHasReview(reservationId);

                          updatedFeedback = AvaliacoesModel(
                            id: '', // O ID será gerado pelo Firestore
                            spaceId: widget.space.spaceId,
                            userId:
                                '', // O ID do usuário pode ser recuperado dentro do ViewModel
                            reservationId: reservationId,
                            rating: starRatingIndex,
                            content: contentController.text,
                            userName:
                                '', // Pode ser preenchido com o usuário autenticado
                            date:
                                '', // Pode ser atualizado ao recuperar do Firestore
                            avatar: '', // Avatar do usuário, se aplicável
                            likes: [],
                            dislikes: [],
                            deletedAt: null,
                          );
                        } else {
                          // Atualizando feedback existente
                          await feedbackRegisterVm.updateFeedback(
                            feedbackId: widget.feedback!.id,
                            spaceId: widget.space.spaceId,
                            reservationId: reservationId!,
                            rating: starRatingIndex,
                            content: contentController.text,
                          );

                          updatedFeedback = widget.feedback!.copyWith(
                            rating: starRatingIndex,
                            content: contentController.text,
                          );
                        }

                        setState(() {});

                        Navigator.pop(context,
                            updatedFeedback); // Retorna o feedback atualizado
                      }
                    : null,
                textColor: Colors.white,
                child: const Text('Confirmar'),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 5,
            child: MaterialButton(
              onPressed: _hideDialog,
              child: const Text('Cancelar'),
            ),
          ),
          AnimatedPositioned(
            top: _starPosition,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    // Decorando de acordo com o INDEX
                    index < starRatingIndex ? Icons.star : Icons.star_border,
                    size: 32,
                    color: const Color(0xff4300B1),
                  ),
                  onPressed: () {
                    setState(() {
                      // Animando - trocando a página da PageView
                      _ratingPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );

                      // Animando - trocando valor da posição das estrelas ao clicar em qualquer uma
                      _starPosition = 40.0;

                      //Se clicar na terceira estrela, _starRating receberá o valor do index dessa estrela.
                      //MUDANDO INDEX
                      starRatingIndex = index + 1;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildThanksNote() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08),
      child:
          const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Obrigado!',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xff4300B1),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text('Adoraríamos receber seu feedback'),
        Text('Como foi sua experiência?'),
      ]),
    );
  }

  causeOfRating() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 15, left: 15, top: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              maxLines: 5,
              autofocus: true,
              controller: contentController,
              decoration: InputDecoration(
                  hintText: 'Escreva sua avaliação aqui...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }

  _hideDialog() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}
