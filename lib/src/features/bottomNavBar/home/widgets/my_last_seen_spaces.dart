import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/each_last_seen.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/small_space_card.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import 'package:shimmer/shimmer.dart';

class MyLastSeenSpaces extends StatefulWidget {
  const MyLastSeenSpaces({
    super.key,
  });

  @override
  State<MyLastSeenSpaces> createState() => _MyLastSeenSpacesState();
}
//todo: chamar func p inserir id do space no array do user fire

class _MyLastSeenSpacesState extends State<MyLastSeenSpaces> {
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return FutureBuilder<List<SpaceModel>?>(
      future: userService.getLastSeenSpaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return const SizedBox();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 16, top: 30),
                  child: Text(''),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16),
                height: 150,
                width: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 221, 221, 221),
                          highlightColor: Colors.white,
                          child: Container(
                            width: 250,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container();
        }

        final spaces = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 16, top: 30),
              child: Text('Últimos vistos'),
            ),
            // ...spaces.asMap().entries.map((entry) {
            //   final space = entry.value;
            //   return EachLastSeen(space: space);
            // }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 150,
              child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: spaces.length,
                itemBuilder: (context, index) {
                  final space = spaces[index];
                  return EachLastSeen(space: space);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
