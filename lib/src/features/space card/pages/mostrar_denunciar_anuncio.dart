import 'package:flutter/material.dart';
import 'package:Festou/src/models/space_model.dart';

class MostrarDenunciarAnuncio extends StatefulWidget {
  final SpaceModel space;
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
