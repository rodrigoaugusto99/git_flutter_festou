import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:git_flutter_festou/src/features/register/host%20feedback/host_feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/register/reserva/reserva_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/space_reservations_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_descricao.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/descricao_teste.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/show_new_map.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/show_map.dart';
import 'package:git_flutter_festou/src/features/register/feedback/feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_limited.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_all.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_disponibilidade.dart';
import 'package:git_flutter_festou/src/features/space%20card/pages/mostrar_todas_comodidades.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:social_share/social_share.dart';

class NewCardInfo extends StatefulWidget {
  final SpaceModel space;
  const NewCardInfo({
    super.key,
    required this.space,
  });

  @override
  State<NewCardInfo> createState() => _NewCardInfoState();
}

int _currentSlide = 0;

bool scrollingUp = false;

class _NewCardInfoState extends State<NewCardInfo> {
  void showRatingDialog(SpaceModel space) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FeedbackPage(space: space),
        );
      },
    );
  }

  void showRateHostDialog(SpaceModel space) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: HostFeedbackRegisterPage(space: space),
        );
      },
    );
  }

  void showDateDialog(SpaceModel space) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservaRegisterPage(space: space),
      ),
    );
  }

  share() {
    String spaceLink = generateSpaceLink(widget.space);
    SocialShare.shareOptions('Confira este espaço: $spaceLink');
  }

  String generateSpaceLink(SpaceModel space) {
    // Substitua pelo código do projeto do Firebase
    String projectId = 'flutterfestou';

    // Use o domínio padrão fornecido pelo Firebase para o ambiente de desenvolvimento
    String baseUrl = 'https://$projectId.web.app/espaco/';

    // Substitua pelo campo correto do seu modelo
    String spaceId = space.spaceId.toString();

    return '$baseUrl$spaceId';
  }

  Widget boolComments(String text) {
    if (widget.space.numComments == '0') {
      return const Row(
        children: [
          Icon(
            Icons.star,
            size: 16,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            'Sem avaliações',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else if (widget.space.numComments == '1') {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _getColor(
                double.parse(widget.space.averageRating),
              ),
            ),
            height: 35, // Ajuste conforme necessário
            width: 25, // Ajuste conforme necessário
            child: Center(
              child: Text(
                double.parse(widget.space.averageRating).toStringAsFixed(1),
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
            '${widget.space.numComments} avaliação',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _getColor(
                double.parse(widget.space.averageRating),
              ),
            ),
            height: 35, // Ajuste conforme necessário
            width: 25, // Ajuste conforme necessário
            child: Center(
              child: Text(
                double.parse(widget.space.averageRating).toStringAsFixed(1),
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
            '${widget.space.numComments} avaliações',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.space.descricao,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fechar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'O que esse lugar oferece',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.space.selectedServices
                    .map((service) => Column(
                          children: [
                            Text(service),
                            const SizedBox(height: 10),
                            const Divider(thickness: 0.4, color: Colors.grey),
                            const SizedBox(height: 10),
                          ],
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: scrollingUp == true
          ? AppBar(
              foregroundColor: Colors.black,
              leading: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () => share(),
                      child: const Icon(Icons.share),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!scrollingUp) setState(() => scrollingUp = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            if (scrollingUp) setState(() => scrollingUp = false);
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    items: widget.space.imagesUrl
                        .map((imageUrl) => Image.network(
                              imageUrl.toString(),
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                    options: CarouselOptions(
                      aspectRatio: 16 / 12,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlide = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: Text(
                        '${_currentSlide + 1}/${widget.space.imagesUrl.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () => showRatingDialog(widget.space),
                child: const Text('Avalie'),
              ),
              /*
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SpaceReservationsPage(space: widget.space),
                    ),
                  );
                },
                child: const Text('ver reservas'),
              ),
              ElevatedButton(
                onPressed: () => showDateDialog(widget.space),
                child: const Text('Reserve'),
              ),
              ElevatedButton(
                onPressed: () => showRateHostDialog(widget.space),
                child: const Text('Avalie o anfitrião'),
              ),*/
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      //widget.space.titulo,
                      'Cabana dos Alpes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    boolComments('Ainda não tem avaliações.'),
                    Text(
                      //mostrar bairro(localizacao mais precisa) apenas se o locador permitir
                      /*${widget.space.bairro}*/
                      //'${widget.space.cidade}, ${widget.space.city}',
                      '${widget.space.cidade}, Brasil',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.black),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          child: const Text('Ver descrição'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showBottomSheet2(context);
                          },
                          child: const Text('Comodidades'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.black),
                    const SizedBox(height: 10),
                    const Text(
                      'Onde você estará',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowNewMap(
                              space: widget.space,
                            ),
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: ShowMap(
                          space: widget.space,
                          scrollGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: false,
                          height: 200,
                          width: double.infinity,
                          x: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.black),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: widget.space.locadorAvatarUrl != ''
                              ? Image.network(
                                  widget.space.locadorAvatarUrl,
                                  fit: BoxFit
                                      .cover, // Ajuste conforme necessário
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 90,
                                ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              'Locador: ${widget.space.locadorName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Fale com o locador',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      //receiverName: widget.space.locadorName,
                                      receiverID: widget.space.userId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.black),
                    /*Text(
                        '${widget.space.bairro}, ${widget.space.cidade}',
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'O Bairro dos Mellos é um bairro rural e familiar. \nNão possui mercados, mas fica bem próximo do centro da cidade Piranguçu. Estamos a 1h40min de Campos de Jordão',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      InkWell(
                        child: const Row(
                          children: [
                            Text(
                              'Mostrar mais',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MostrarOndeVoceEstara(space: widget.space),
                            ),
                          );
                        },
                      ),*/
                    const SizedBox(height: 10),
                    const Divider(thickness: 0.4, color: Colors.grey),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Avaliações dos hóspedes',
                      style: TextStyle(fontSize: 23),
                    ),
                    InkWell(
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Ver tudo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SpaceFeedbacksPageAll(space: widget.space),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SpaceFeedbacksPageLimited(
                x: 3,
                space: widget.space,
              ),
            ],
          ),
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
