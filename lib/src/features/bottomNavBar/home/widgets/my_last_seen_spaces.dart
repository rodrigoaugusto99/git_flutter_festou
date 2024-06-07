import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/small_space_card.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';

class MyLastSeenSpaces extends StatefulWidget {
  final AllSpaceState data;
  final AsyncValue spaces;
  const MyLastSeenSpaces({
    super.key,
    required this.data,
    required this.spaces,
  });

  @override
  State<MyLastSeenSpaces> createState() => _MyLastSeenSpacesState();
}
//todo: chamar func p inserir id do space no array do user fire

class _MyLastSeenSpacesState extends State<MyLastSeenSpaces> {
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    double y = MediaQuery.of(context).size.height;
    return FutureBuilder<List<SpaceModel>?>(
      future: userService.getLastSeenSpaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: y * 0.21,
              child: const Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No spaces viewed recently."));
        }

        final spaces = snapshot.data!;

        return SizedBox(
          height: y * 0.21,
          child: ListView.builder(
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final space = spaces[index];
              return ListTile(
                title: Text(space
                    .spaceId), // Assumindo que cada espaço tenha um campo 'name'
                // Assumindo que cada espaço tenha um campo 'description'
              );
            },
          ),
        );
      },
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 15.0, bottom: 10),
    //       child: Text(
    //         'Próximos a você',
    //         style: TextStyle(color: Colors.blueGrey[500]),
    //       ),
    //     ),
    //     SizedBox(
    //       height: y * 0.21,
    //       child: ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         itemCount: data.spaces.length,
    //         itemBuilder: (context, index) {
    //           return InkWell(
    //               onTap: () => Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => SpacesWithSugestionPage(
    //                           space: data.spaces[index]),
    //                     ),
    //                   ),
    //               child: SmallSpaceCard(space: data.spaces[index]));
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }
}
