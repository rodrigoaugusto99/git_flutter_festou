import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/new_card_info.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class SpaceCard2 extends ConsumerStatefulWidget {
  final SpaceWithImages space;

  const SpaceCard2({
    super.key,
    required this.space,
  });

  @override
  ConsumerState<SpaceCard2> createState() => _SpaceCard2State();
}

final user = FirebaseAuth.instance.currentUser!;

class _SpaceCard2State extends ConsumerState<SpaceCard2> {
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
          builder: (context) => NewCardInfo(
            space: widget.space,
          ),
        ),
      );
    }

    final x = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        color: Colors.grey,
        margin: EdgeInsets.symmetric(horizontal: x * 0.03),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        //TODO: sizedbox e positioned com y(responsiveo)(levando em conta que )
        child: SizedBox(
          height: 300,
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  height: 220,
                  child: widget.space.imageUrls.isNotEmpty
                      ? CarouselSlider(
                          items: widget.space.imageUrls
                              .map((imageUrl) => Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            height: 240, // Set the height here
                            autoPlay: true,
                            aspectRatio:
                                16 / 9, // You can adjust this as needed
                            viewportFraction:
                                1.0, // Set to 1.0 to show one image at a time
                            enableInfiniteScroll:
                                true, // Enable infinite scrolling
                          ),
                        )
                      : Container(),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blueGrey),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.space.space.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
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
                              Text(widget.space.space.bairro),
                              Text(widget.space.space.cidade),
                            ],
                          ),
                          Row(
                            children: [
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
