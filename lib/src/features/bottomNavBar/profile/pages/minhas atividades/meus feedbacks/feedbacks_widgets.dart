import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_state.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/repositories/feedback/feedback_firestore_repository_impl.dart';
import 'package:git_flutter_festou/src/services/space_service.dart';

class FeedbacksWidget extends StatefulWidget {
  final MeusFeedbacksState data;

  const FeedbacksWidget({
    super.key,
    required this.data,
  });

  @override
  State<FeedbacksWidget> createState() => _FeedbacksWidgetState();
}

class _FeedbacksWidgetState extends State<FeedbacksWidget> {
  final feedbackFirestore = FeedbackFirestoreRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        leading: Image.asset('lib/assets/images/Icon ratingmyava.png'),
        title: const Text('meus feedbacks'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.feedbacks.length,
            itemBuilder: (BuildContext context, int index) {
              final feedback = widget.data.feedbacks[index];
              return FeedbackItem(
                feedback: feedback,
                feedbackFirestore: feedbackFirestore,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeedbackItem extends StatefulWidget {
  final FeedbackModel feedback;
  final FeedbackFirestoreRepositoryImpl feedbackFirestore;

  const FeedbackItem({
    super.key,
    required this.feedback,
    required this.feedbackFirestore,
  });

  @override
  _FeedbackItemState createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    super.initState();
    _checkUserReaction();
    getSpace();
  }

  SpaceModel? space;

  Future<void> getSpace() async {
    space = await SpaceService().getSpaceById(widget.feedback.spaceId);
    setState(() {});
  }

  Future<void> _checkUserReaction() async {
    String reaction =
        await widget.feedbackFirestore.checkUserReaction(widget.feedback.id);
    setState(() {
      isLiked = reaction == "isLiked";
      isDisliked = reaction == "isDisliked";
    });
  }

  @override
  Widget build(BuildContext context) {
    return space == null
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 27, top: 19, bottom: 7, right: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.feedback.avatar == '')
                            const CircleAvatar(
                              radius: 23,
                              child: Icon(Icons.person),
                            ),
                          if (widget.feedback.avatar != '')
                            CircleAvatar(
                              backgroundImage: Image.network(
                                widget.feedback.avatar,
                                fit: BoxFit.cover,
                              ).image,
                              radius: 23,
                            ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.feedback.userName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                              Text(
                                widget.feedback.date,
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
                                  double.parse(widget.feedback.rating
                                      .toStringAsFixed(1)),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    double.parse(
                                            widget.feedback.rating.toString())
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
                          // Row(
                          //   children: [
                          //     ...buildStarIcons(widget.feedback.rating),
                          //   ],
                          // ),
                        ],
                      ),
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
                      Text(widget.feedback.content.toString()),
                      const SizedBox(height: 17),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await widget.feedbackFirestore
                                  .toggleLikeFeedback(widget.feedback.id);
                              _checkUserReaction(); // Atualize o estado após a ação
                            },
                            child: Image.asset(
                              'lib/assets/images/Facebook Likelike3x.png',
                              width: 20,
                              color: isLiked ? Colors.blue : null,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text('(${widget.feedback.likes.length})'),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              await widget.feedbackFirestore
                                  .toggleDislikeFeedback(widget.feedback.id);
                              _checkUserReaction(); // Atualize o estado após a ação
                            },
                            child: Image.asset(
                              'lib/assets/images/Thumbs Downdeslike3x.png',
                              width: 20,
                              color: isDisliked ? Colors.red : null,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text('(${widget.feedback.dislikes.length})'),
                          const Spacer(),
                          const Text(
                            'Editar',
                            style: TextStyle(
                              color: Color(0xff9747FF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Excluir',
                            style: TextStyle(
                              color: Color(0xffFF0000),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
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
      return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
    } else {
      return Colors.red; // Ícone vermelho para rating abaixo de 2
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
            : Colors.grey[300], // Cinza claro para estrelas não atingidas
        size: 14.0,
      ),
    );

    return stars;
  }
}
