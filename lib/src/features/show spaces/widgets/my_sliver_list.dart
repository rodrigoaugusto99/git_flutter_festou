import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

class MySliverList extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  final AsyncValue spaces;
  const MySliverList({
    super.key,
    required this.data,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Column(
                children: [
                  SpaceCard2(space: data.spaces[index]),
                ],
              ),
          childCount: data.spaces.length),
    );
  }
}