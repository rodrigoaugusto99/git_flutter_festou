import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/models/space_model.dart';

class MySliverListFiltered extends StatelessWidget {
  final List<SpaceModel> spaces;
  const MySliverListFiltered({
    super.key,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => InkWell(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewCardInfo(
                        spaceId: spaces[index].spaceId,
                      ),
                    ),
                  ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: NewSpaceCard(
                  hasHeart: true,
                  space: spaces[index],
                  isReview: false,
                ),
              )),
          childCount: spaces.length),
    );
  }
}
