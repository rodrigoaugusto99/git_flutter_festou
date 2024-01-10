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
                    Row(
                      children: [
                        ...buildStarIcons(feedback.rating),
                      ],
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
                const SizedBox(height: 5),
                const Text(
                    'lor ipsum cactildee ebaaa coco de pombo xixi hehehe cocozeento uhul\nComentário:'),
                Text(
                  feedback.content.toString(),
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: feedback.avatar != ''
                          ? Image.network(
                              feedback.avatar,
                              fit: BoxFit.cover, // Ajuste conforme necessário
                            )
                          : const Icon(
                              Icons.person,
                              size: 90,
                            ),
                    ),
                    Text(
                      feedback.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
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
