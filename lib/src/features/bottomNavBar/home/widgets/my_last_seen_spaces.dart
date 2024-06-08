import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/small_space_card.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import 'package:shimmer/shimmer.dart';

class MyLastSeenSpaces extends StatefulWidget {
  final AllSpaceState data;
  final AsyncValue spaces;
  const MyLastSeenSpaces({
    super.key,
    required this.data,
    required this.spaces,
  });

  @override
  State<MyLastSeenSpaces> createState() => _MyLastSeenSpacesState();
}
//todo: chamar func p inserir id do space no array do user fire

class _MyLastSeenSpacesState extends State<MyLastSeenSpaces> {
  UserService userService = UserService();

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
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return FutureBuilder<List<SpaceModel>?>(
      future: userService.getLastSeenSpaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.only(left: 10),
            height: 150,
            width: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 221, 221, 221),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 250,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No spaces viewed recently."));
        }

        final spaces = snapshot.data!;

        return Container(
          padding: const EdgeInsets.only(left: 10),
          height: 150,
          child: ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final space = spaces[index];
              return GestureDetector(
                //todo: nav to new_card_info
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 150,
                  width: 250,
                  child: Stack(
                    children: [
                      if (space.imagesUrl.isEmpty)
                        Container(
                          height: 200,
                          width: 300,
                          color: Colors.grey,
                        ),
                      if (space.imagesUrl.isNotEmpty)
                        ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Stack(
                              children: [
                                Image.network(
                                  width: 250,
                                  height: 150,
                                  space.imagesUrl[0],
                                  fit: BoxFit.cover,
                                ),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          space.titulo,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        Text(
                                                          '${space.bairro}, ${space.estado},${space.bairro}, ${space.estado}',
                                                          style: const TextStyle(
                                                              fontSize: 7,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              overflow:
                                                                  TextOverflow
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
                                                            BorderRadius
                                                                .circular(5),
                                                        color: _getColor(
                                                          double.parse(space
                                                              .averageRating),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            double.parse(space
                                                                    .averageRating)
                                                                .toStringAsFixed(
                                                                    1),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
            },
          ),
        );
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
