import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
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

    final x = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: x * 0.03),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Column(
          children: [
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  widget.space.imageUrls.isNotEmpty
                      ? ListView(
                          children: widget.space.imageUrls
                              .map((imageUrl) => Image.network(imageUrl))
                              .toList(),
                        )
                      : const Center(
                          child: Text('Não tem foto'),
                        ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.space.space.email),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.space.space.isFavorited =
                                        !widget.space.space.isFavorited;
                                  });
                                  spaceRepository.toggleFavoriteSpace(
                                      widget.space.space.spaceId,
                                      widget.space.space.isFavorited);
                                },
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.space.space.name,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CardInfos(
                                          space: widget.space.space,
                                        ),
                                      ),
                                    ),
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
                          Text(widget.space.space.cep),
                          Text(widget.space.space.logradouro),
                          Text(widget.space.space.numero),
                          Text(widget.space.space.bairro),
                          Text(widget.space.space.cidade),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
