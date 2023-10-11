import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/models/space/space2.dart';

class SpaceCard extends StatefulWidget {
  const SpaceCard({super.key});

  @override
  State<SpaceCard> createState() => _SpaceCardState();
}

class _SpaceCardState extends State<SpaceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
      child: Card(
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
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageConstants.gliterBlackground),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('San Diego Apart Hotel'),
                              Icon(
                                //Icons.favorite,
                                Icons.favorite_outline,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 250,
                                child: Text(
                                  'Este apart-hotel possui piscina externa e fica perto de Praia de Canasvieiras',
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CardInfos(
                                          space: SpaceModelTest2(),
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
