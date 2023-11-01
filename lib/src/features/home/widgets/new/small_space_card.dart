import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:glassmorphism/glassmorphism.dart';

class SmallSpaceCard extends ConsumerStatefulWidget {
  final SpaceWithImages space;
  const SmallSpaceCard({
    super.key,
    required this.space,
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
        widget.space.space.isFavorited = !widget.space.space.isFavorited;
      });
      spaceRepository.toggleFavoriteSpace(
          widget.space.space.spaceId, widget.space.space.isFavorited);
    }

    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(3),
      color: Colors.white,
      width: x * 0.6,
      child: Column(
        children: [
          widget.space.imageUrls.isNotEmpty
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CarouselSlider(
                        items: [
                          Image.network(
                            widget.space.imageUrls.isNotEmpty
                                ? widget.space.imageUrls[0]
                                : 'URL de uma imagem padrão ou vazia', // Substituir pela URL da imagem padrão ou vazia
                            fit: BoxFit.cover,
                          ),
                        ],
                        options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                          onTap: close,
                          child: GlassmorphicContainer(
                            width: 16,
                            height: 16,
                            borderRadius: 20,
                            blur: 10,
                            border: 0,
                            linearGradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0.35),
                                Color.fromRGBO(0, 0, 0, 0),
                              ],
                            ),
                            borderGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0.35),
                                Color.fromRGBO(0, 0, 0, 0),
                              ],
                            ),
                            child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                )),
                          )),
                    ),
                    Positioned(
                      bottom: 7,
                      left: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.space.space.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '8, ${widget.space.space.cidade}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(child: Text('Sem fotos')),
        ],
      ),
    );
  }
}
