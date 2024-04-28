import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:svg_flutter/svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NewCardInfo extends ConsumerStatefulWidget {
  final SpaceModel space;
  const NewCardInfo({
    super.key,
    required this.space,
  });

  @override
  ConsumerState<NewCardInfo> createState() => _NewCardInfoState();
}

int _currentSlide = 0;

bool scrollingUp = false;

class _NewCardInfoState extends ConsumerState<NewCardInfo>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8, // Espaçamento horizontal entre os chips
                runSpacing: 8, // Espaçamento vertical entre as linhas de chips
                children: widget.space.selectedServices
                    .map(
                      (service) => Chip(
                        backgroundColor:
                            const Color.fromARGB(255, 195, 162, 201),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        avatar: const Icon(Icons.text_snippet),
                        label: Text(service),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  bool isCarouselVisible = true;

  @override
  Widget build(BuildContext context) {
    final spaceRepository = ref.watch(spaceFirestoreRepositoryProvider);

    void toggle() {
      setState(() {
        widget.space.isFavorited = !widget.space.isFavorited;
      });
      spaceRepository.toggleFavoriteSpace(
          widget.space.spaceId, widget.space.isFavorited);
    }

    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    Widget myThirdWidget() {
      return Column(
        children: [
          //botao
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showRatingDialog(widget.space),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF0F0F0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Image.asset('lib/assets/images/Pencilpencil.png'),
                  const SizedBox(width: 17),
                  const Text(
                    'Deixe sua avaliação!',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff848484)),
                  ),
                  const Spacer(),
                  const Text(
                    '0/256',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff848484)),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 17),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Avaliações ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                '(${widget.space.numComments} avaliações)',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff5E5E5E),
                ),
              ),
            ],
          ),
          SpaceFeedbacksPageLimited(
            x: 2,
            space: widget.space,
          ),
        ],
      );
    }

    Widget mySecondWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Fotos ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                '(6 fotos)',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff5E5E5E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
                crossAxisCount: 3,
              ),
              itemCount: widget.space.imagesUrl.length > 6
                  ? 6
                  : widget.space.imagesUrl.length,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                        widget.space.imagesUrl[index].toString(),
                        fit: BoxFit.cover));
              }),
          const SizedBox(height: 26),
        ],
      );
    }

    Widget myFirstWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.space.selectedServices.length,
              itemBuilder: (context, index) {
                return Container(
                  constraints: BoxConstraints(minWidth: x / 3.5),
                  child: Row(
                    children: [
                      //SvgPicture.asset('assetName'),
                      const Icon(Icons.align_vertical_top_sharp),
                      Text(widget.space.selectedServices[index]),
                    ],
                  ),
                );
              },
            ),
          ),
          const Text(
            'Visão geral',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              widget.space.descricao,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Localização',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
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
          ),
          const SizedBox(height: 15),
          const Text(
            'Agente Locador',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              widget.space.locadorAvatarUrl != ''
                  ? CircleAvatar(
                      backgroundColor: const Color(0xffF3F3F3),
                      backgroundImage: Image.network(
                        widget.space.locadorAvatarUrl,
                        fit: BoxFit.cover,
                      ).image,
                      radius: 25,
                    )
                  : const CircleAvatar(
                      backgroundColor: Color(0xffF3F3F3),
                      radius: 25,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
              const SizedBox(width: 10),
              Text(
                widget.space.locadorName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  //alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xffF3F3F3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble,
                    color: Color(0xff9747FF),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverID: widget.space.userId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
              padding: const EdgeInsets.all(5),
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
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: toggle,
                child: widget.space.isFavorited
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_outline,
                      ),
              ),
            ),
          ),
        ],
        flexibleSpace: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          color: isCarouselVisible ? Colors.transparent : Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                VisibilityDetector(
                  key: const Key('my-widget-key'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    setState(() {
                      isCarouselVisible = info.visibleFraction > 0.0;
                    });
                  },
                  child: CarouselSlider(
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
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.space.imagesUrl.map((url) {
                int index = widget.space.imagesUrl.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentSlide == index
                        ? const Color(0xff9747FF)
                        : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
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
                        const SizedBox(
                          width: 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _getColor(
                              double.parse(widget.space.averageRating),
                            ),
                          ),
                          height: 20,
                          width: 20,
                          child: Center(
                            child: Text(
                              double.parse(widget.space.averageRating)
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Column(
                          children: [
                            Text(
                              style: TextStyle(
                                  color: Color(0xff9747FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                              "R\$800",
                            ),
                            Text('Por hora'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //boolComments('Ainda não tem avaliações.'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        SvgPicture.asset('lib/assets/images/Vectorcheck.svg'),
                        const SizedBox(width: 7),
                        Text(
                          '${widget.space.cidade}, Brasil',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffE4E4E4),
                          width: 1.2,
                        ),
                      ),
                    ),
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: const Color(0xff9747FF),
                      labelPadding: const EdgeInsets.only(bottom: 15),
                      tabs: const [
                        Text(
                          'Sobre',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Galeria',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Avaliação',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: tabController,
                        //physics: const NeverScrollableScrollPhysics(),
                        children: [
                          myFirstWidget(),
                          mySecondWidget(),
                          myThirdWidget(),
                        ],
                      ),
                    ),
                  ),

                  // const SizedBox(height: 10),
                  // const Divider(thickness: 0.4, color: Colors.purple),
                  // const SizedBox(height: 10),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         _showBottomSheet(context);
                  //       },
                  //       child: const Text('Ver descrição'),
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         _showBottomSheet2(context);
                  //       },
                  //       child: const Text('Comodidades'),
                  //     ),
                  //   ],
                  // ),

                  // myFirstWidget(),
                ],
              ),
            ),
            // const Align(
            //   alignment: Alignment.center,
            //   child: Text(
            //     'Avaliações dos hóspedes',
            //     style: TextStyle(fontSize: 23),
            //   ),
            // ),
            // const SizedBox(height: 10),
            // SpaceFeedbacksPageLimited(
            //   x: 3,
            //   space: widget.space,
            // ),
            // InkWell(
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: Container(
            //       margin:
            //           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //       child: const Text(
            //         'Ver tudo',
            //         style: TextStyle(
            //           decoration: TextDecoration.underline,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18,
            //         ),
            //       ),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) =>
            //             SpaceFeedbacksPageAll(space: widget.space),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
                color: const Color(0xff9747FF),
                borderRadius: BorderRadius.circular(50)),
            child: const Text(
              'Alugar',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            )),
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
