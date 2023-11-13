import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class MostrarDenunciarAnuncio extends StatefulWidget {
  final SpaceWithImages space;
  const MostrarDenunciarAnuncio({
    super.key,
    required this.space,
  });

  @override
  State<MostrarDenunciarAnuncio> createState() =>
      _MostrarDenunciarAnuncioState();
}

class _MostrarDenunciarAnuncioState extends State<MostrarDenunciarAnuncio> {
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
