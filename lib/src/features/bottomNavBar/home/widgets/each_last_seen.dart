import 'package:festou/src/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:festou/src/models/space_model.dart';

class EachLastSeen extends StatefulWidget {
  final SpaceModel space;
  const EachLastSeen({
    super.key,
    required this.space,
  });

  @override
  State<EachLastSeen> createState() => _EachLastSeenState();
}

class _EachLastSeenState extends State<EachLastSeen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserService().updateLastSeen(widget.space.spaceId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewCardInfo(spaceId: widget.space.spaceId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        height: 150,
        width: 250,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Stack(
                  children: [
                    if (widget.space.imagesUrl.isNotEmpty) ...[
                      Image.network(
                        width: 250,
                        height: 150,
                        widget.space.imagesUrl[0],
                        fit: BoxFit.cover,
                      ),
                    ] else ...[
                      Container(
                        width: 250,
                        height: 150,
                        color: Colors.grey,
                      ),
                    ],
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            //padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            //width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.space.titulo,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Text(
                                              '${widget.space.bairro}, ${widget.space.estado}',
                                              style: const TextStyle(
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.w700,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: _getColor(
                                              double.parse(
                                                  widget.space.averageRating),
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                double.parse(widget
                                                        .space.averageRating)
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

Color _getColor(double averageRating) {
  if (averageRating >= 4) {
    return Colors.green; // Ícone verde para rating maior ou igual a 4
  } else if (averageRating >= 2 && averageRating < 4) {
    return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
  } else {
    return Colors.red; // Ícone vermelho para rating abaixo de 2
  }
}
