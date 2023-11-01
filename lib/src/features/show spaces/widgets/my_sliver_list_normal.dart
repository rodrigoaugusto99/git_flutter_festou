import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/new_space_card.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

class MySliverListNormal extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
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
              child: NewSpaceCard(space: data.spaces[index])),
          childCount: data.spaces.length),
    );
  }
}
