import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MostrarSegurancaPropriedade extends StatefulWidget {
  final SpaceWithImages space;
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
