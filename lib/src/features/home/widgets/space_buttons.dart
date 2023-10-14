import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SpaceButtons extends StatefulWidget {
  const SpaceButtons({super.key});

  @override
  State<SpaceButtons> createState() => _SpaceButtonsState();
}

class _SpaceButtonsState extends State<SpaceButtons> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: x * 0.13, vertical: y * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () =>
                Navigator.of(context)
                    .pushNamed('/home/all_spaces', arguments: user),
            child: Container(
              padding: EdgeInsets.all(
                  x * 0.03),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Text(
                'Todos os espaços',
                style: TextStyle(color: Colors.blueGrey[500], fontSize: 11),
              ),
            ),
          ),
          InkWell(
            onTap: () =>
                Navigator.of(context)
                    .pushNamed('/home/my_spaces', arguments: user),
            child: Container(
              padding: EdgeInsets.all(
                  x * 0.03),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Text(
                'Meus espaços cadastrados',
                style: TextStyle(color: Colors.blueGrey[500], fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}