import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MostrarDescriO extends StatefulWidget {
  final SpaceWithImages space;
  const MostrarDescriO({
    super.key,
    required this.space,
  });

  @override
  State<MostrarDescriO> createState() => _MostrarDescriOState();
}

class _MostrarDescriOState extends State<MostrarDescriO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mais descrição'),
      ),
      body: Container(),
    );
  }
}
