import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';

class MySliverListNormal extends StatelessWidget {
  final data;
  final AsyncValue spaces;
  const MySliverListNormal({
    super.key,
    required this.data,
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
                      builder: (context) =>
                          SpacesWithSugestionPage(space: data.spaces[index]),
                    ),
                  ),
              child: NewSpaceCard(
                hasHeart: true,
                space: data.spaces[index],
                isReview: false,
              )),
          childCount: data.spaces.length),
    );
  }
}
