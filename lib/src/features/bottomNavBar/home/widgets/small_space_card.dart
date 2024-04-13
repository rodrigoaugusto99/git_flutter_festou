import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:glassmorphism/glassmorphism.dart';

class SmallSpaceCard extends ConsumerStatefulWidget {
  final SpaceModel space;
  final bool onMap;
  const SmallSpaceCard({
    super.key,
    required this.space,
    this.onMap = false,
  });

  @override
  ConsumerState<SmallSpaceCard> createState() => _SmallSpaceCardState();
}

class _SmallSpaceCardState extends ConsumerState<SmallSpaceCard> {
  @override
  Widget build(BuildContext context) {
    final spaceRepository = ref.watch(spaceFirestoreRepositoryProvider);

    void close() {
      setState(() {
        widget.space.isFavorited = !widget.space.isFavorited;
      });
      spaceRepository.toggleFavoriteSpace(
          widget.space.spaceId, widget.space.isFavorited);
    }

    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    String capitalizeTitle(String title) {
      List<String> exceptions = ["da", "de", "di", "do", "du"];

      List<String> words = title.toLowerCase().split(' ');

      for (int i = 0; i < words.length; i++) {
        if (!exceptions.contains(words[i]) || i == 0) {
          words[i] =
              words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
        }
      }

      return words.join(' ');
    }

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: x * 0.7,
      height: widget.onMap ? y * 0.22 : null,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Stack(
                  children: [
                    CarouselSlider(
                      items: [
                        Image.network(
                          widget.space.imagesUrl.isNotEmpty
                              ? widget.space.imagesUrl[0]
                              : 'URL de uma imagem padrão ou vazia',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ],
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                          ),
                          color: const Color.fromARGB(125, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                capitalizeTitle(widget.space.titulo),
                                style: const TextStyle(
                                  fontFamily: 'RedHatDisplay',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
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
}
