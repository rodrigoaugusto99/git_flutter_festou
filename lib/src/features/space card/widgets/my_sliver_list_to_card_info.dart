import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';

class MySliverListToCardInfo extends StatelessWidget {
  final data;
  final AsyncValue spaces;
  final bool x;

  const MySliverListToCardInfo({
    super.key,
    required this.data,
    required this.spaces,
    required this.x,
  });

  @override
  Widget build(BuildContext context) {
    final y = MediaQuery.of(context).size.height;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewCardInfo(space: data.spaces[index]),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: y * 0.03),
                  child: NewSpaceCard(
                    hasHeart: x,
                    space: data.spaces[index],
                    isReview: false,
                  ),
                ),
              ),
          childCount: data.spaces.length),
    );
  }
}
