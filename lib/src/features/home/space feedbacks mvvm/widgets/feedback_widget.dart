import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/space%20feedbacks%20mvvm/space_feedbacks_state.dart';

class FeedbackWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final SpaceFeedbacksState data;
  final AsyncValue spaces;
  const FeedbackWidget({
    super.key,
    required this.data,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.feedbacks.map((feedback) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'userName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'date',
                    style: TextStyle(
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
        );
      }).toList(),
    );
  }
}
