import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space/space_model_test.dart';

class CardInfos extends StatefulWidget {
  final SpaceModelTest space;
  const CardInfos({
    super.key,
    required this.space,
  });

  @override
  State<CardInfos> createState() => _CardInfosState();
}

class _CardInfosState extends State<CardInfos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Infos'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  /*await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservaPage(card: card),
                    ),
                  );*/
                },
                child: const Text(
                  'Fazer Reserva',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: const Text('Avalie'),
              ),
              ElevatedButton(
                onPressed: () => {},
                child: const Text('Mais Detalhes'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Fotos'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Fotos'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Ver Localização'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Avalie'),
              ),
              ElevatedButton.icon(
                onPressed: () => {},
                icon: const Icon(Icons.comment),
                label: const Text('Comments'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
