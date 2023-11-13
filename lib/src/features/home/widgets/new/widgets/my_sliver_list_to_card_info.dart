import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/new_card_info.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/new_space_card.dart';

class MySliverListToCardInfo extends StatelessWidget {
  final data;
  final AsyncValue spaces;
  const MySliverListToCardInfo({
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
                        NewCardInfo(space: data.spaces[index]),
                  ),
                ),
                child: NewSpaceCard(space: data.spaces[index]),
              ),
          childCount: data.spaces.length),
    );
  }
}
