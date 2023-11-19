import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MySliverListFiltered extends StatelessWidget {
  final List<SpaceWithImages> spaces;
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
                      builder: (context) => NewCardInfo(space: spaces[index]),
                    ),
                  ),
              child: NewSpaceCard(
                space: spaces[index],
                isReview: false,
              )),
          childCount: spaces.length),
    );
  }
}
