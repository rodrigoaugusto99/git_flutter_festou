import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card_state.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card_vm.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpaceCard2 extends ConsumerStatefulWidget {
  final SpaceModel space;

  const SpaceCard2({
    super.key,
    required this.space,
  });

  @override
  ConsumerState<SpaceCard2> createState() => _SpaceCard2State();
}

final user = FirebaseAuth.instance.currentUser!;

class _SpaceCard2State extends ConsumerState<SpaceCard2> {
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final spaceCardVm = ref.watch(spaceCardVmProvider(widget.space));

    return spaceCardVm.when(
      loading: () {
        return const CircularProgressIndicator(); // Ou qualquer widget de carregamento que você deseja mostrar.
      },
      data: (SpaceCardState data) {
        return buildCard(data.imageUrls.cast<String>());
      },
      error: (error, stackTrace) {
        log('Erro ao carregar as imagens: $error');
        return buildCard(null);
      },
    );
  }

  Widget buildCard(List<String>? imageUrls) {
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
                  imageUrls != null && imageUrls.isNotEmpty
                      ? CarouselSlider(
                          items: imageUrls.map((url) {
                            return Image.network(url, fit: BoxFit.cover);
                          }).toList(),
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: 220,
                            autoPlay: true,
                          ),
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
                              Text(widget.space.email),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.space.isFavorited =
                                        !widget.space.isFavorited;
                                  });
                                  spaceRepository.toggleFavoriteSpace(
                                      widget.space.spaceId,
                                      widget.space.isFavorited);
                                },
                                child: widget.space.isFavorited
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
                                widget.space.name,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CardInfos(
                                          space: widget.space,
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
                          Text(widget.space.cep),
                          Text(widget.space.logradouro),
                          Text(widget.space.numero),
                          Text(widget.space.bairro),
                          Text(widget.space.cidade),
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
