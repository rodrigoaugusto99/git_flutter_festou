import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/meus_feedbacks_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_state.dart';

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
  //? aqui é do "meus feedbacks"
  List<Icon> buildStarIcons(int rating) {
    return List.generate(
      rating,
      (index) => const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 24.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('meus feedbacks'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.data.feedbacks.length,
          itemBuilder: (BuildContext context, int index) {
            final feedback = widget.data.feedbacks[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            feedback.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            feedback.date,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Avaliação:'),
                          const SizedBox(width: 8.0),
                          ...buildStarIcons(feedback.rating),
                        ],
                      ),
                      Text(
                        'Avaliação: ${feedback.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Comentário:'),
                      Text(
                        feedback.content.toString(),
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
