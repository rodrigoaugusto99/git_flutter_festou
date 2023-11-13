import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:intl/intl.dart';

class NewFeedbackWidget2 extends StatefulWidget {
  final SpaceFeedbacksState data;
  final AsyncValue spaces;

  const NewFeedbackWidget2({
    super.key,
    required this.data,
    required this.spaces,
  });

  @override
  State<NewFeedbackWidget2> createState() => _NewFeedbackWidget2State();
}

String formatFeedbackDate(String date) {
  final formatter = DateFormat('dd/MM/yyyy - HH'); // Use o formato correto
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

class _NewFeedbackWidget2State extends State<NewFeedbackWidget2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: widget.data.feedbacks.length,
        itemBuilder: (BuildContext context, int index) {
          final feedback = widget.data.feedbacks[index];
          return Container(
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
                  children: [
                    // Avatar aqui (substitua pela implementação do Avatar)
                    CircleAvatar(
                      child: Text(
                        feedback.userName.isNotEmpty
                            ? feedback.userName[0].toUpperCase()
                            : '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
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
