import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/denunciar_anuncio.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/mostrar_disponibilidade.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/mostrar_politica_de_cancelamento.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/mostrar_regras.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/mostrar_todas_comodidades.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/seguran%C3%A7a_propriedade.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page.dart';
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
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: _getColor(
                              double.parse(widget.space.space.averageRating)),
                        ),
                        height: 35, // Ajuste conforme necessário
                        width: 25, // Ajuste conforme necessário
                        child: Center(
                          child: Text(
                            double.parse(widget.space.space.averageRating)
                                .toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white, // Cor do texto
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.space.space.numComments,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Espaço alocado por ${widget.space.space.locadorName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.account_circle, // Substitua pelo ícone desejado
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Aproveite nosso pedacinho do paraiso durante suas ferias em Espaco Doido! Quer oce estteja explorando a floresta tropical ao redor e o ulcao Arenal a longo prazo ou apenas de passagem, esta casa ofrec uma experiencia confrtavel e luxuosa para',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'O que o lugar oferece',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.space.space.selectedServices
                        .take(3)
                        .map((service) => Text(service))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MostrarTodasComodidades(space: widget.space),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Onde você estará',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.space.space.bairro}, ${widget.space.space.cidade}',
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 200, child: Placeholder()),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const Text('Opinião dos clientes'),
                  const Row(
                    children: [
                      Text('Avaliação: averageRating'),
                      Text('Excelente'),
                    ],
                  ),
                  const Text('Opiniões'),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: _getColor(
                            double.parse(widget.space.space.averageRating)),
                      ),
                      Text(
                        '${widget.space.space.averageRating}, \u2022 ${widget.space.space.numComments} comments',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SpaceFeedbacksPage(
              x: 3,
              space: widget.space.space,
            ),
            InkWell(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10), right: Radius.circular(10)),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Mostrar todaos os comentarios',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SpaceFeedbacksPage(space: widget.space.space),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        children: [
                          Text(
                            'Disponibilidade',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Disponibilidade'),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MostrarDisponibilidade(space: widget.space),
                              ),
                            );
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Política de cancelamento',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 300, // Defina a largura desejada aqui
                            child: Text(
                              'Cancelamento gratuito antes de xx/yy. Consulte a política de cancelamento completa do locador, que se aplica mesmo se você cancelar por doenças ou interrupções causadas pela COVID-19',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MostrarPoliticaDeCancelamento(
                                      space: widget.space),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.arrow_forward, // Substitua pelo ícone desejado
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Regras do espaço',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Não é permitido animais de estimação'),
                  const Text('Horário de silêncio'),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MostrarRegras(space: widget.space),
                        ),
                      );
                    },
                    child: const Text(
                      'Mostrar mais',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Segurança e propriedade',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Câmera de segurança/dispositivo de gravação',
                  ),
                  const Text(
                      'O Festou proíbe câmeras e dispositivos sem o conhecimento do locatário.'),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SeguranAPropriedade(space: widget.space),
                        ),
                      );
                    },
                    child: const Text(
                      'Mostrar mais',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.4, color: Colors.grey),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.flag),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DenunciarAnuncio(space: widget.space),
                            ),
                          );
                        },
                        child: const Text(
                          'Denunciar este anúncio',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getColor(double averageRating) {
  if (averageRating >= 4) {
    return Colors.green; // Ícone verde para rating maior ou igual a 4
  } else if (averageRating >= 2 && averageRating < 4) {
    return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
  } else {
    return Colors.red; // Ícone vermelho para rating abaixo de 2
  }
}
