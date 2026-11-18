import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/each_last_seen.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/services/user_service.dart';
import 'package:shimmer/shimmer.dart';

class MyLastSeenSpaces extends StatefulWidget {
  const MyLastSeenSpaces({super.key});

  @override
  State<MyLastSeenSpaces> createState() => _MyLastSeenSpacesState();
}

class _MyLastSeenSpacesState extends State<MyLastSeenSpaces> {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SpaceModel>?>(
      future: userService.getLastSeenSpaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 22, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Últimos vistos',
                      style: TextStyle(
                        fontFamily: 'RedHatDisplay',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: Color(0xFF1C1426),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Espaços que você visitou há pouco',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8A8096),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 14),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xFFEDE7F6),
                          highlightColor: Colors.white,
                          child: Container(
                            width: 240,
                            color: Colors.white,
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

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final spaces = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 22, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Últimos vistos',
                    style: TextStyle(
                      fontFamily: 'RedHatDisplay',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: Color(0xFF1C1426),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Espaços que você visitou há pouco',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8A8096),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: spaces.length,
                itemBuilder: (context, index) {
                  return EachLastSeen(space: spaces[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
