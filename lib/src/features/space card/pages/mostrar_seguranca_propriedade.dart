import 'package:flutter/material.dart';
import 'package:festou/src/models/space_model.dart';

class MostrarSegurancaPropriedade extends StatefulWidget {
  final SpaceModel space;
  const MostrarSegurancaPropriedade({
    super.key,
    required this.space,
  });

  @override
  State<MostrarSegurancaPropriedade> createState() =>
      _MostrarSegurancaPropriedadeState();
}

class _MostrarSegurancaPropriedadeState
    extends State<MostrarSegurancaPropriedade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sgurança propriedade'),
      ),
      body: Container(),
    );
  }
}
