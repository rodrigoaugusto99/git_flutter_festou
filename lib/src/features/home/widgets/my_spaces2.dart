import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

class MySpaces2 extends StatefulWidget {
  const MySpaces2({super.key});

  @override
  State<MySpaces2> createState() => _MySpaces2State();
}

final user = FirebaseAuth.instance.currentUser!;

final CollectionReference _usersStream =
    FirebaseFirestore.instance.collection('users');

class _MySpaces2State extends State<MySpaces2> {
  List<Map<String, dynamic>> userSpacesList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAVORITES'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: ((context, index) {
          return const SpaceCard();
        }),
      ),
    );
  }
}
