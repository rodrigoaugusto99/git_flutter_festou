import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class MostrarOndeVoceEstara extends StatefulWidget {
  final SpaceModel space;
  const MostrarOndeVoceEstara({
    super.key,
    required this.space,
  });

  @override
  State<MostrarOndeVoceEstara> createState() => _MostrarOndeVoceEstaraState();
}

class _MostrarOndeVoceEstaraState extends State<MostrarOndeVoceEstara> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Onde voce estará',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '${widget.space.bairro}, ${widget.space.cidade}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
                'O Bairro dos Mellos é um bairro rural e familiar. Não possui mercados, mas fica bem próximo do centro da cidade Piranguçu. Estamos a 1h40min de Campos de Jordão'),
          ],
        ),
      ),
    );
  }
}
