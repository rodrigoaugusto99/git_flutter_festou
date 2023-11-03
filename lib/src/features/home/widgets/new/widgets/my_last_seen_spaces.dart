import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/small_space_card.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';

class MyLastSeenSpaces extends StatelessWidget {
  final data;
  final AsyncValue spaces;
  const MyLastSeenSpaces({
    super.key,
    required this.data,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    final y = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('all spaces (futuro "vistos recentemente")'),
        ),
        SizedBox(
          height: y * 0.21,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.spaces.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpacesWithSugestionPage(
                              space: data.spaces[index]),
                        ),
                      ),
                  child: SmallSpaceCard(space: data.spaces[index]));
            },
          ),
        ),
      ],
    );
  }
}
