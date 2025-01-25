import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/edit_dialog.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_state.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/repositories/feedback/feedback_firestore_repository_impl.dart';
import 'package:git_flutter_festou/src/services/feedback_service.dart';
import 'package:git_flutter_festou/src/services/space_service.dart';

class FeedbacksWidget extends StatefulWidget {
  final List<FeedbackModel> feedbacks;

  const FeedbacksWidget({
    super.key,
    required this.feedbacks,
  });

  @override
  State<FeedbacksWidget> createState() => _FeedbacksWidgetState();
}

class _FeedbacksWidgetState extends State<FeedbacksWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        //borderRadius: BorderRadius.circular(18),
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
          leading: Image.asset('lib/assets/images/icon_avaliacao.png'),
          title: const Text('Minhas avaliações'),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.feedbacks.length,
              itemBuilder: (BuildContext context, int index) {
                final feedback = widget.feedbacks[index];
                if (feedback.content == '' || feedback.deleteAt != null) {
                  return const SizedBox.shrink();
                }
                return FeedbackItem(
                  feedback: feedback,
                  onDelete: () {
                    widget.feedbacks.removeAt(index);
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

class FeedbackItem extends StatefulWidget {
  final FeedbackModel feedback;
  final VoidCallback onDelete;

  const FeedbackItem({
    super.key,
    required this.feedback,
    required this.onDelete,
  });

  @override
  _FeedbackItemState createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  bool isLiked = false;
  bool isDisliked = false;
  late FeedbackService feedbackService;

  @override
  void initState() {
    super.initState();
    feedbackService = FeedbackService();
    myFeedback = widget.feedback;
    _checkUserReaction();
    getSpace();
  }

  SpaceModel? space;
  FeedbackModel? myFeedback;

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
    myFeedback = await FeedbackService().getFeedbackById(widget.feedback.id);
    _checkUserReaction();
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
                            // mainAxisAlignment: MainAxisAlignment.start,
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
                          GestureDetector(
                            onTap: () async {
                              final result = await showDialog<String>(
                                context: context,
                                builder: (context) => EditTextDialog(
                                  initialText: myFeedback!.content,
                                ),
                              );
                              if (result == null) return;

                              await FeedbackService().updateFeedbackContent(
                                widget.feedback.id,
                                result,
                              );
                              updateFeedback();
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
                          GestureDetector(
                            onTap: () async {
                              await FeedbackService().deleteFeedbackByCondition(
                                widget.feedback.id,
                              );
                              updateFeedback();
                              widget.onDelete();
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
