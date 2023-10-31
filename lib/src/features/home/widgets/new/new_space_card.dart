import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class NewSpaceCard extends ConsumerStatefulWidget {
  final SpaceWithImages space;
  const NewSpaceCard({
    super.key,
    required this.space,
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

    void navigateToInfo() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardInfos(
            space: widget.space.space,
          ),
        ),
      );
    }

    final x = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: 360,
      child: Column(
        children: [
          widget.space.imageUrls.isNotEmpty
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CarouselSlider(
                        items: widget.space.imageUrls
                            .map((imageUrl) => Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ))
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 16 / 16,
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
                )
              : Container(),
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
                      '${widget.space.space.bairro}, ${widget.space.space.cidade}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text('_avaliaçao_'),
                  ],
                ),

                /*Text(widget.space.space.cep),
                Text(widget.space.space.logradouro),
                Text(widget.space.space.numero),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.space.space.name),
                        const Text('_preço_'),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpacesWithSugestionPage(
                                space: widget.space,
                              ),
                            ),
                          ),
                          child: const Icon(Icons.abc),
                        ),
                        InkWell(
                          onTap: navigateToInfo,
                          child: const Icon(Icons.info),
                        ),
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
