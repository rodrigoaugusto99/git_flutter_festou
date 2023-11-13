import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MostrarPoliticaDeCancelamento extends StatefulWidget {
  final SpaceWithImages space;
  const MostrarPoliticaDeCancelamento({
    super.key,
    required this.space,
  });

  @override
  State<MostrarPoliticaDeCancelamento> createState() =>
      _MostrarPoliticaDeCancelamentoState();
}

class _MostrarPoliticaDeCancelamentoState
    extends State<MostrarPoliticaDeCancelamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('politica cancelamnto'),
      ),
      body: Container(),
    );
  }
}
