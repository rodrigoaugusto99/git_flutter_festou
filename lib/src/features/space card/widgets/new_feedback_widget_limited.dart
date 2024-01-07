import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';

class NewFeedbackWidgetLimited extends StatefulWidget {
  final SpaceFeedbacksState data;
  final AsyncValue spaces;
  final int? x;

  const NewFeedbackWidgetLimited({
    super.key,
    required this.data,
    required this.spaces,
    this.x,
  });

  @override
  State<NewFeedbackWidgetLimited> createState() =>
      _NewFeedbackWidgetLimitedState();
}

class _NewFeedbackWidgetLimitedState extends State<NewFeedbackWidgetLimited> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.feedbacks.length > 3
            ? widget.x
            : widget.data.feedbacks.length,
        itemBuilder: (BuildContext context, int index) {
          final feedback = widget.data.feedbacks[index];
          return Container(
            width: 240,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey, // Cor da borda
                width: 1.0, // Largura da borda em pixels
              ),
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
          );
        },
      ),
    );
  }

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
}
