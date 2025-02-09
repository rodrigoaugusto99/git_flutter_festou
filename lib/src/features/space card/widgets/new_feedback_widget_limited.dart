import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_state.dart';
import 'package:Festou/src/models/avaliacoes_model.dart';

class NewFeedbackWidgetLimited extends StatefulWidget {
  final List<AvaliacoesModel> feedbacks;
  final int? x;

  const NewFeedbackWidgetLimited({
    super.key,
    required this.feedbacks,
    this.x,
  });

  @override
  State<NewFeedbackWidgetLimited> createState() =>
      _NewFeedbackWidgetLimitedState();
}

class _NewFeedbackWidgetLimitedState extends State<NewFeedbackWidgetLimited> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...widget.feedbacks.asMap().entries.map((entry) {
        final feedback = entry.value;
        final index = entry.key;
        if (index > widget.x!) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, top: 19, bottom: 7, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 6,

                  offset: const Offset(0, 7), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: feedback.avatar != ''
                          ? CircleAvatar(
                              backgroundImage: Image.network(
                                feedback.avatar,
                                fit: BoxFit.cover,
                              ).image,
                              radius: 20,
                            )
                          : Text(feedback.userName[0].toUpperCase()),
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
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    feedback.content.toString(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      }),
    ]);
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
