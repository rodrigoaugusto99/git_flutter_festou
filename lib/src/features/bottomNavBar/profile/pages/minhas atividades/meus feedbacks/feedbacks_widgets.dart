import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_state.dart';
import 'package:git_flutter_festou/src/repositories/feedback/feedback_firestore_repository_impl.dart';

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

  final feedbackFirestore = FeedbackFirestoreRepositoryImpl();

  // void toggle() {
  //     setState(() {
  //       widget.space.isFavorited = !widget.space.isFavorited;
  //     });
  //     spaceRepository.toggleFavoriteSpace(
  //         widget.space.spaceId, widget.space.isFavorited);
  //   }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        leading: Image.asset('lib/assets/images/Icon ratingmyava.png'),
        title: const Text('meus feedbacks'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.feedbacks.length,
            itemBuilder: (BuildContext context, int index) {
              final feedback = widget.data.feedbacks[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 27, top: 19, bottom: 7, right: 27),
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
                            children: [
                              if (feedback.avatar == '')
                                const CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    Icons.person,
                                  ),
                                ),
                              if (feedback.avatar != '')
                                CircleAvatar(
                                  backgroundImage: Image.network(
                                    feedback.avatar,
                                    fit: BoxFit.cover,
                                  ).image,
                                  radius: 20,
                                ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feedback.userName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  Text(
                                    feedback.date,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff5E5E5E),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  ...buildStarIcons(feedback.rating),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            feedback.content.toString(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => feedbackFirestore
                                    .toggleLikeFeedback(feedback.id),
                                child: Image.asset(
                                  'lib/assets/images/Facebook Likelike3x.png',
                                  width: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text('(${feedback.likes.length})'),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () => feedbackFirestore
                                    .toggleDislikeFeedback(feedback.id),
                                child: Image.asset(
                                  'lib/assets/images/Thumbs Downdeslike3x.png',
                                  width: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text('(${feedback.dislikes.length})'),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Editar',
                                  style: TextStyle(color: Color(0xff9747FF)),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Excluir',
                                  style: TextStyle(color: Color(0xffFF0000)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
