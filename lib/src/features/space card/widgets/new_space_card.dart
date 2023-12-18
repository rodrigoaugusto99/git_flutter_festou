import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class NewSpaceCard extends ConsumerStatefulWidget {
  final SpaceWithImages space;
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
  @override
  Widget build(BuildContext context) {
    final spaceRepository = ref.watch(spaceFirestoreRepositoryProvider);

    void toggle() {
      setState(() {
        widget.space.space.isFavorited = !widget.space.space.isFavorited;
      });
      spaceRepository.toggleFavoriteSpace(
          widget.space.space.spaceId, widget.space.space.isFavorited);
    }

    //final x = MediaQuery.of(context).size.width;
    //final y = MediaQuery.of(context).size.height;

    Widget myCarousel(bool isReview) {
      if (isReview == false) {
        if (widget.space.imageUrls.isNotEmpty) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CarouselSlider(
                  items: widget.space.space.imagesUrl
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
              Positioned(
                top: 20,
                right: 20,
                child: InkWell(
                  onTap: toggle,
                  child: widget.space.space.isFavorited
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                        ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      } else {
        if (widget.space.imageUrls.isNotEmpty) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CarouselSlider(
                  items: widget.space.imageUrls
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
                  child: widget.space.space.isFavorited
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_outline,
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
                      ' ${widget.space.space.cidade} ${widget.space.space.selectedTypes}',
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
                        Text(widget.space.space.titulo),
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
