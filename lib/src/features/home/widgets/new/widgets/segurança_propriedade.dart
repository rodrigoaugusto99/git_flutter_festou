import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class SeguranAPropriedade extends StatefulWidget {
  final SpaceWithImages space;
  const SeguranAPropriedade({
    super.key,
    required this.space,
  });

  @override
  State<SeguranAPropriedade> createState() => _SeguranAPropriedadeState();
}

class _SeguranAPropriedadeState extends State<SeguranAPropriedade> {
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
