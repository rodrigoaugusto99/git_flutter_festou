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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding:
                const EdgeInsets.only(left: 27, top: 19, bottom: 7, right: 27),
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
                    if (widget.data.feedbacks[0].avatar == '')
                      const CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                    if (widget.data.feedbacks[0].avatar != '')
                      CircleAvatar(
                        backgroundImage: Image.network(
                          widget.data.feedbacks[0].avatar,
                          fit: BoxFit.cover,
                        ).image,
                        radius: 20,
                      ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.feedbacks[0].userName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                        Text(
                          widget.data.feedbacks[0].date,
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
                        ...buildStarIcons(widget.data.feedbacks[0].rating),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.data.feedbacks[0].content.toString(),
                ),
                const SizedBox(height: 10),
                // const Row(
                //   children: [
                //     Row(
                //       children: [
                //         Icon(Icons.check_circle),
                //         SizedBox(width: 5),
                //         Text('(200)'),
                //       ],
                //     ),
                //     Row(
                //       children: [
                //         Icon(Icons.thumb_down),
                //         SizedBox(width: 5),
                //         Text('(0)'),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
        if (widget.x! < 2)
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
                        child: widget.data.feedbacks[1].avatar != ''
                            ? CircleAvatar(
                                backgroundImage: Image.network(
                                  widget.data.feedbacks[1].avatar,
                                  fit: BoxFit.cover,
                                ).image,
                                radius: 100,
                              )
                            : const Icon(
                                Icons.person,
                                size: 90,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.feedbacks[1].userName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000),
                            ),
                          ),
                          Text(
                            widget.data.feedbacks[1].date,
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
                          ...buildStarIcons(widget.data.feedbacks[1].rating),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.data.feedbacks[1].content.toString(),
                  ),
                  const SizedBox(height: 10),
                  // const Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Icon(Icons.check_circle),
                  //         SizedBox(width: 5),
                  //         Text('(200)'),
                  //       ],
                  //     ),
                  //     Row(
                  //       children: [
                  //         Icon(Icons.thumb_down),
                  //         SizedBox(width: 5),
                  //         Text('(0)'),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
      ],
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
