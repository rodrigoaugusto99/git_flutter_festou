import 'dart:async';

import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:shimmer/shimmer.dart';

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
  Future<void> _loadImage(String url) async {
    final ImageStream stream =
        NetworkImage(url).resolve(ImageConfiguration.empty);
    final Completer<void> completer = Completer();
    final ImageStreamListener listener = ImageStreamListener((_, __) {
      completer.complete();
    }, onError: (Object exception, StackTrace? stackTrace) {
      completer.completeError(exception);
    });
    stream.addListener(listener);
    await completer.future;
    stream.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadImage(widget.space.imagesUrl[0]),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.only(right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 221, 221, 221),
                highlightColor: Colors.white,
                child: Container(
                  height: 150,
                  width: 250,
                  color: Colors.red,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading image'));
        } else {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewCardInfo(spaceId: widget.space.spaceId),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              height: 150,
              width: 250,
              child: Stack(
                children: [
                  if (widget.space.imagesUrl.isEmpty)
                    Container(
                      height: 200,
                      width: 300,
                      color: Colors.grey,
                    ),
                  if (widget.space.imagesUrl.isNotEmpty)
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
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    Text(
                                                      '${widget.space.bairro}, ${widget.space.estado}',
                                                      style: const TextStyle(
                                                          fontSize: 7,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RotatedBox(
                                                quarterTurns: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: _getColor(
                                                      double.parse(widget
                                                          .space.averageRating),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        double.parse(widget
                                                                .space
                                                                .averageRating)
                                                            .toStringAsFixed(1),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
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
      },
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
