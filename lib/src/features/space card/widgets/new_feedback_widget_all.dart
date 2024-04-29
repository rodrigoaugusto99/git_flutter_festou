import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:intl/intl.dart';

class NewFeedbackWidgetAll extends StatefulWidget {
  final SpaceFeedbacksState data;
  final AsyncValue spaces;

  const NewFeedbackWidgetAll({
    super.key,
    required this.data,
    required this.spaces,
  });

  @override
  State<NewFeedbackWidgetAll> createState() => _NewFeedbackWidgetAllState();
}

String formatFeedbackDate(String date) {
  final formatter = DateFormat('dd/MM/yyyy');
  final feedbackDateTime = formatter.parse(date);
  final now = DateTime.now();
  final difference = now.difference(feedbackDateTime);

  if (difference.inDays < 1) {
    return 'Hoje';
  } else if (difference.inDays == 1) {
    return '1 dia atrás';
  } else if (difference.inDays > 1 && difference.inDays <= 7) {
    return '${difference.inDays} dias atrás';
  } else if (difference.inDays > 7 && difference.inDays <= 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks semanas atrás';
  } else {
    return DateFormat('MMMM yyyy', 'pt_BR').format(feedbackDateTime);
  }
}

class _NewFeedbackWidgetAllState extends State<NewFeedbackWidgetAll> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: widget.data.feedbacks.length,
        itemBuilder: (BuildContext context, int index) {
          final feedback = widget.data.feedbacks[index];
          return Container(
            width: 240,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ...buildStarIcons(feedback.rating),
                        const SizedBox(width: 8.0),
                        const Text(
                          '\u2022',
                          style: TextStyle(fontSize: 7),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          formatFeedbackDate(feedback.date),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      feedback.content.toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    // Avatar aqui (substitua pela implementação do Avatar)
                    CircleAvatar(
                      radius: 20,
                      child: feedback.avatar.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: Image.network(
                                feedback.avatar,
                                fit: BoxFit.cover,
                              ).image,
                              radius: 100,
                            )
                          : Text(feedback.userName[0].toUpperCase()),
                    ),

                    const SizedBox(width: 8.0),
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
