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
  final bool hasHeart;
  final bool smallOne;
  const NewSpaceCard({
    super.key,
    required this.space,
    required this.isReview,
    required this.hasHeart,
    this.smallOne = false,
  });

  @override
  ConsumerState<NewSpaceCard> createState() => _NewSpaceCardState();
}

class _NewSpaceCardState extends ConsumerState<NewSpaceCard> {
  bool showLottie = false;
  int _currentIndex = 0;

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

    Widget myCarousel(bool isReview) {
      if (isReview == false) {
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
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            if (widget.hasHeart)
              if (showLottie)
                Positioned(
                  left: x * 0.1,
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
            if (widget.hasHeart)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(59, 255, 255, 255),
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
                        Align(
                          alignment: Alignment.center,
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
                                  child: const Icon(
                                    Icons.favorite_outline,
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.space.imagesUrl.map((url) {
                  int index = widget.space.imagesUrl.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? const Color(0xff9747FF)
                          : Colors.grey.shade300,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      } else {
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
      }
    }

    return Container(
      padding: const EdgeInsets.all(6),
      color: Colors.white,
      height: 380,
      child: Stack(
        children: [
          myCarousel(widget.isReview),
          Padding(
            padding: EdgeInsets.only(bottom: y * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: x * 0.84,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 20,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
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
                              style: TextStyle(color: Colors.blueGrey[500]),
                              capitalizeTitle(
                                  "${widget.space.bairro}, ${widget.space.cidade}"),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 25, right: 25),
                            child: const Divider(
                              thickness: 0.8,
                              color: Color(0xff9747FF),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: _getColor(
                                          double.parse(
                                              widget.space.averageRating),
                                        ),
                                      ),
                                      height: y * 0.035,
                                      width: x * 0.07,
                                      child: Center(
                                        child: Text(
                                          double.parse(
                                                  widget.space.averageRating)
                                              .toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                        style: const TextStyle(
                                          color: Color(0xff5E5E5E),
                                        ),
                                        '(${widget.space.numComments})'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color(0xff9747FF),
                                        ),
                                        width: 20,
                                        height: 20,
                                        child: const Icon(
                                          Icons.attach_money,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        style: const TextStyle(
                                            color: Color(0xff9747FF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                        "R\$${widget.space.preco},00/h",
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, right: 0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        size: 20,
                                        color: Color(0xff9747FF),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                          style: const TextStyle(
                                            color: Color(0xff5E5E5E),
                                          ),
                                          widget.space.numLikes.toString()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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

String capitalizeTitle(String title) {
  List<String> exceptions = ["da", "de", "di", "do", "du"];

  List<String> words = title.toLowerCase().split(' ');

  for (int i = 0; i < words.length; i++) {
    if (!exceptions.contains(words[i]) || i == 0) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
    }
  }

  return words.join(' ');
}
