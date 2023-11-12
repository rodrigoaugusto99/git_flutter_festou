import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class DenunciarAnuncio extends StatefulWidget {
  final SpaceWithImages space;
  const DenunciarAnuncio({
    super.key,
    required this.space,
  });

  @override
  State<DenunciarAnuncio> createState() => _DenunciarAnuncioState();
}

class _DenunciarAnuncioState extends State<DenunciarAnuncio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('denunciar anuncio'),
      ),
      body: Container(),
    );
  }
}
