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
  const NewSpaceCard({
    super.key,
    required this.space,
    required this.isReview,
    required this.hasHeart,
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

    //final x = MediaQuery.of(context).size.width;
    //final y = MediaQuery.of(context).size.height;

    Widget myCarousel(bool isReview) {
      final x = MediaQuery.of(context).size.width;
      final y = MediaQuery.of(context).size.height;
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
              if (widget.hasHeart)
                if (showLottie)
                  Center(
                    child: Lottie.asset(
                      'lib/assets/animations/heartBeats.json',
                      repeat: false,
                      width: 300,
                      height: 300,
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
                  right: 5,
                  width: 80,
                  height: 80,
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
                          top: y * 0.035,
                          right: x * 0.060,
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
                                      if (widget.hasHeart) {
                                        showLottie = true;
                                      }
                                    });
                                  },
                                  child: const Icon(
                                    Icons.favorite_outline,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
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
      child: Column(
        children: [
          myCarousel(widget.isReview),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.space.cidade,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text('_avaliaçao_'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.space.titulo),
                        const Text('_preço_'),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.edit),
                        ),
                      ],
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
