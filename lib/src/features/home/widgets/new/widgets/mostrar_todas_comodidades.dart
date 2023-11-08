import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MostrarTodasComodidades extends StatefulWidget {
  final SpaceWithImages space;
  const MostrarTodasComodidades({
    super.key,
    required this.space,
  });

  @override
  State<MostrarTodasComodidades> createState() =>
      _MostrarTodasComodidadesState();
}

class _MostrarTodasComodidadesState extends State<MostrarTodasComodidades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mostrar todas comodidades'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.space.space.selectedServices
            .map((service) => Text(service))
            .toList(),
      ),
    );
  }
}
