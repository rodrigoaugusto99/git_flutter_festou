import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class MostrarDisponibilidade extends StatefulWidget {
  final SpaceModel space;
  const MostrarDisponibilidade({
    super.key,
    required this.space,
  });

  @override
  State<MostrarDisponibilidade> createState() => _MostrarDisponibilidadeState();
}

class _MostrarDisponibilidadeState extends State<MostrarDisponibilidade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mostrar disponbiilidade'),
      ),
      body: Container(),
    );
  }
}
