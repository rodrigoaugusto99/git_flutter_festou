import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/models/space/space_model_test.dart';

class SpaceCard extends StatefulWidget {
  final SpaceModelTest space;

  const SpaceCard({super.key, required this.space});

  @override
  State<SpaceCard> createState() => _SpaceCardState();
}

class _SpaceCardState extends State<SpaceCard> {
  SpaceModelTest space = SpaceModelTest(
    name: 'rodrigo',
    email: 'email',
    cep: '22221000',
    endereco: 'endereco',
    numero: '123',
    bairro: 'catete',
    cidade: 'rio de janeiro',
    selectedTypes: ['type 1', 'type 2'],
    availableDays: ['Seg', 'Ter', 'Sex', 'Sab'],
    selectedServices: ['Service 1', 'Service 2', 'Service 3'],
    feedbacks: [],
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageConstants.gliterBlackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Color.fromARGB(255, 240, 235, 235),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.space.name),
                      const Text('800,00/h'),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.space.endereco}, ${widget.space.numero} - ${widget.space.cep}\n${widget.space.bairro}, ${widget.space.cidade}',
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardInfos(space: space),
                          ),
                        ),
                        child: const Icon(Icons.info),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 2),
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
