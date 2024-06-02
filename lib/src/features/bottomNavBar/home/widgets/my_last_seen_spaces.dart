import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/small_space_card.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';

class MyLastSeenSpaces extends StatelessWidget {
  final AllSpaceState data;
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
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 10),
          child: Text(
            'Próximos a você',
            style: TextStyle(color: Colors.blueGrey[500]),
          ),
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
