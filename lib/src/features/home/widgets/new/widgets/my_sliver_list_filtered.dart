import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/new_space_card.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
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
                      builder: (context) => CardInfos(space: spaces[index]),
                    ),
                  ),
              child: NewSpaceCard(space: spaces[index])),
          childCount: spaces.length),
    );
  }
}
