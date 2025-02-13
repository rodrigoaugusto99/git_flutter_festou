import 'package:flutter/material.dart';
import 'package:festou/src/models/space_model.dart';

class MostrarPoliticaDeCancelamento extends StatefulWidget {
  final SpaceModel space;
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
