import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MostrarRegras extends StatefulWidget {
  final SpaceWithImages space;
  const MostrarRegras({
    super.key,
    required this.space,
  });

  @override
  State<MostrarRegras> createState() => _MostrarRegrasState();
}

class _MostrarRegrasState extends State<MostrarRegras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mostrar regras'),
      ),
      body: Container(),
    );
  }
}
