import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class NewCardInfo extends StatefulWidget {
  final SpaceWithImages space;
  const NewCardInfo({
    super.key,
    required this.space,
  });

  @override
  State<NewCardInfo> createState() => _NewCardInfoState();
}

class _NewCardInfoState extends State<NewCardInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${widget.space.space.name} \u2022 500m do Parque Lage',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.space.space.bairro}, ${widget.space.space.cidade}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        '{averageRating}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '{numComments}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 0.4,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Espaço alocado por {nome_do_locador}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.account_circle, // Substitua pelo ícone desejado
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 0.4,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'O que o lugar oferece',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.space.space.selectedServices
                        .map((service) => Text(service))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10)),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Mostrar todas as comodidades',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      // Ação quando o botão for clicado
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 0.4,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Onde você estará',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.space.space.bairro}, ${widget.space.space.cidade}',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 200, child: Placeholder()),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('O local exato é fornecido depois da reserva'),
                  InkWell(
                    child: const Row(
                      children: [
                        Text(
                          'Mostrar mais',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    onTap: () {
                      // Ação quando o botão for clicado
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 0.4,
                    color: Colors.grey,
                  ),
                  const Text('Opinião dos clientes'),
                  const Row(
                    children: [
                      Text('Avaliação: averageRating'),
                      Text('Excelente'),
                    ],
                  ),
                  const Text('Opiniões'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
