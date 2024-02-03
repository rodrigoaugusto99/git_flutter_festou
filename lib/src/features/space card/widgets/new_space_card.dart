import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:lottie/lottie.dart';

class NewSpaceCard extends ConsumerStatefulWidget {
  final SpaceModel space;
  final bool isReview;

  const NewSpaceCard({
    super.key,
    required this.space,
    required this.isReview,
  });

  @override
  ConsumerState<NewSpaceCard> createState() => _NewSpaceCardState();
}

class _NewSpaceCardState extends ConsumerState<NewSpaceCard> {
  bool showLottie = false;

  @override
  Widget build(BuildContext context) {
    final spaceRepository = ref.watch(spaceFirestoreRepositoryProvider);

    void toggle() {
      setState(() {
        widget.space.isFavorited = !widget.space.isFavorited;
      });
      spaceRepository.toggleFavoriteSpace(
          widget.space.spaceId, widget.space.isFavorited);
    }

    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    double leftPadding = x * 0.8;

    Widget myCarousel(bool isReview) {
      if (isReview == false) {
        if (widget.space.imagesUrl.isNotEmpty) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CarouselSlider(
                  items: widget.space.imagesUrl
                      .map((imageUrl) => Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 16 / 12,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                  ),
                ),
              ),
              if (showLottie)
                Positioned(
                  left: x * 0.14,
                  child: Lottie.asset(
                    'lib/assets/animations/heartBeats.json',
                    repeat: false,
                    width: x * 0.72,
                    onLoaded: (composition) {
                      Timer(const Duration(seconds: 2), () {
                        setState(() {
                          showLottie = false;
                        });
                      });
                    },
                  ),
                ),
              Positioned(
                top: y * 0.009,
                left: x * 0.82,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  width: 50,
                  height: 50,
                  child: InkWell(
                    onTap: toggle,
                    child: Stack(
                      children: [
                        if (!widget.space.isFavorited)
                          Lottie.asset(
                            'lib/assets/animations/heartsFalling.json',
                            height: y * 0.12,
                          ),
                        Positioned(
                          top: y * 0.018,
                          right: x * 0.035,
                          child: widget.space.isFavorited
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      toggle();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      toggle();
                                      showLottie = true;
                                    });
                                  },
                                  child: const Icon(Icons.favorite_outline,
                                      color:
                                          Color.fromARGB(255, 255, 186, 186)),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      } else {
        if (widget.space.imagesUrl.isNotEmpty) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CarouselSlider(
                  items: widget.space.imagesUrl
                      .map((filePath) => Image.file(
                            File(filePath),
                            fit: BoxFit.cover,
                          ))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 16 / 12,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: InkWell(
                  onTap: toggle,
                  child: widget.space.isFavorited
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Colors.pink,
                        ),
                ),
              ),
            ],
          );
        } else {
          return Container(
            height: 100,
            width: 200,
            alignment: Alignment.center,
            color: Colors.grey,
            child: const Text('Sem fotos'),
          );
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(6),
      color: Colors.white,
      width: 370,
      height: 380,
      child: Stack(
        children: [
          myCarousel(widget.isReview),
          Positioned(
            top: y * 0.3,
            left: x * 0.062,
            child: Container(
              width: x * 0.84,
              height: y * 0.14,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Cor do sombreado
                      spreadRadius: 2, // Raio de propagação do sombreado
                      blurRadius: 20, // Raio de desfoque do sombreado
                      offset: const Offset(0,
                          3), // Deslocamento do sombreado em relação ao Container
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          capitalizeFirstLetter(widget.space.titulo),
                          style: const TextStyle(
                              fontFamily: 'RedHatDisplay',
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                        style: const TextStyle(
                          color: Color.fromARGB(255, 156, 156, 156),
                        ),
                        "${widget.space.bairro}, ${widget.space.cidade}"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 25, top: 5, right: 25, bottom: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 223, 223, 223),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: _getColor(
                                double.parse(widget.space.averageRating),
                              ),
                            ),
                            height: y * 0.035, // Ajuste conforme necessário
                            width: x * 0.07, // Ajuste conforme necessário
                            child: Center(
                              child: Text(
                                double.parse(widget.space.averageRating)
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white, // Cor do texto
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                            style: TextStyle(
                              color: Color.fromARGB(255, 156, 156, 156),
                            ),
                            "(105)"),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(
                                      255, 156, 156, 156), //Colors.deepPurple,
                                ),
                                width: 20,
                                height: 20,
                                child: const Icon(
                                  Icons.attach_money,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            style: TextStyle(
                              color: Color.fromARGB(255, 156, 156, 156),
                            ),
                            "R\$800,00/h",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(
                                      255, 156, 156, 156), //Colors.deepPurple,
                                ),
                                width: 20,
                                height: 20,
                                child: const Icon(
                                  Icons.favorite,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                            style: TextStyle(
                              color: Color.fromARGB(255, 156, 156, 156),
                            ),
                            "(598)"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//CRIAR UMA CLASSE UTILITIES

Color _getColor(double averageRating) {
  if (averageRating >= 4) {
    return Colors.green; // Ícone verde para rating maior ou igual a 4
  } else if (averageRating >= 2 && averageRating < 4) {
    return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
  } else {
    return Colors.red; // Ícone vermelho para rating abaixo de 2
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}
