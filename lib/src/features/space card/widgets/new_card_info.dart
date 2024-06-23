import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/register/host%20feedback/host_feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/register/posts/register_post_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/calendar_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/show_new_map.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/show_map.dart';
import 'package:git_flutter_festou/src/features/register/feedback/feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_limited.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_all.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/single_video_page.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import 'package:social_share/social_share.dart';
import 'package:svg_flutter/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NewCardInfo extends ConsumerStatefulWidget {
  final SpaceModel space;
  bool isLocadorFlow;
  NewCardInfo({
    super.key,
    required this.space,
    this.isLocadorFlow = false,
  });

  @override
  ConsumerState<NewCardInfo> createState() => _NewCardInfoState();
}

int _currentSlide = 0;

bool scrollingUp = false;

class _NewCardInfoState extends ConsumerState<NewCardInfo>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<VideoPlayerController> controllers = [];

  bool isMySpace = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    for (var video in widget.space.videosUrl) {
      VideoPlayerController controller = VideoPlayerController.network(video)
        ..initialize().then((_) {
          setState(() {});
        });
      controllers.add(controller);
    }
    init();
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

  void init() async {
    final user = await UserService().getCurrentUserModel();
    if (user != null) {
      if (user.id == widget.space.userId) {
        setState(() {
          isMySpace = true;
        });
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        precoEC.text = widget.space.preco;
        visaoGeralEC.text = widget.space.descricao;
        cepEC.text = widget.space.cep;
        ruaEC.text = widget.space.logradouro;
        numeroEC.text = widget.space.numero;
        bairroEC.text = widget.space.bairro;
        estadoEC.text = widget.space.estado;
      });
    });
  }

  bool isEditing = false;

  final precoEC = TextEditingController();
  final visaoGeralEC = TextEditingController();
  final cepEC = TextEditingController();
  final ruaEC = TextEditingController();
  final numeroEC = TextEditingController();
  final bairroEC = TextEditingController();
  final estadoEC = TextEditingController();

  //todo: method to delete services clicked
  //todo: method to delete photos and videos clicked
  //todo: metodo para adicionar mais fotos e videos
  void toggleEditing() {
    if (isEditing) {
      //todo: save method
    }
    setState(() {
      isEditing = !isEditing;
    });
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

  Widget buildVideoPlayer(int index) {
    final controller = controllers[index];
    if (controller.value.isInitialized) {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleVideoPage(controller: controller);
            },
          );

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return SingleVideoPage(
          //         controller: controller,
          //       );
          //     },
          //   ),
          // );
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
            ),
            Icon(
              Icons.play_circle_fill,
              color: Colors.white.withOpacity(0.7),
              size: 40,
            )
          ],
        ),
      );
    }
    return Container();
    // return const Column(
    //   children: [
    //     // Row(
    //     //   mainAxisAlignment: MainAxisAlignment.center,
    //     //   children: [
    //     //     IconButton(
    //     //       icon: Icon(
    //     //           controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
    //     //       onPressed: () {
    //     //         setState(() {
    //     //           controller.value.isPlaying
    //     //               ? controller.pause()
    //     //               : controller.play();
    //     //         });
    //     //       },
    //     //     ),
    //     //     IconButton(
    //     //       icon: const Icon(Icons.stop),
    //     //       onPressed: () {
    //     //         setState(() {
    //     //           controller.pause();
    //     //           controller.seekTo(Duration.zero);
    //     //         });
    //     //       },
    //     //     ),
    //     //     IconButton(
    //     //       icon: const Icon(Icons.replay),
    //     //       onPressed: () {
    //     //         setState(() {
    //     //           controller.seekTo(Duration.zero);
    //     //           controller.play();
    //     //         });
    //     //       },
    //     //     ),
    //     //   ],
    //     // ),
    //   ],
    // );
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

//todo:
    String getIconPath(String service) {
      if (service == 'Cozinha') {
        return 'lib/assets/images/Rolling Pincozinha.png';
      }
      if (service == 'Estacionamento') {
        return 'lib/assets/images/Vectorcarro.png';
      }
      if (service == 'Segurança') {
        return 'lib/assets/images/Toilet Bowlvaso.png';
      }
      if (service == 'Limpeza ') return 'lib/assets/images/Toilet Bowlvaso.png';
      if (service == 'Decoração') {
        return 'lib/assets/images/Toilet Bowlvaso.png';
      }
      if (service == 'Bar') return 'lib/assets/images/Toilet Bowlvaso.png';
      if (service == 'Garçons') return 'lib/assets/images/Toilet Bowlvaso.png';
      if (service == 'Ar-condicionado') {
        return 'lib/assets/images/Toilet Bowlvaso.png';
      }
      if (service == 'Banheiros') {
        return 'lib/assets/images/Toilet Bowlvaso.png';
      }
      if (service == 'Som e iluminação') {
        return 'lib/assets/images/Toilet Bowlvaso.png';
      }

      return 'lib/assets/images/Toilet Bowlvaso.svg';
    }

    final x = MediaQuery.of(context).size.width;

    Widget myThirdWidget() {
      return Column(
        children: [
          //botao
          if (!isEditing)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => showRatingDialog(widget.space),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffF0F0F0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
          if (widget.space.numComments != '0')
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
          if (widget.space.numComments != '0')
            SpaceFeedbacksPageLimited(
              x: 2,
              space: widget.space,
            ),
          if (widget.space.numComments != '0')
            InkWell(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: const Text(
                    'Ver tudo',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
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
      );
    }

    Widget mySecondWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Fotos ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                '(${widget.space.imagesUrl.length} ${widget.space.imagesUrl.length == 1 ? 'foto' : 'fotos)'}',
                style: const TextStyle(
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
            itemCount: 6, // Sempre terá 6 itens no grid
            itemBuilder: (BuildContext context, int index) {
              if (index < widget.space.imagesUrl.length) {
                // Mostrar as imagens da lista
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.space.imagesUrl[index].toString(),
                    fit: BoxFit.cover,
                  ),
                );
              } else if (index == widget.space.imagesUrl.length &&
                  widget.space.imagesUrl.length < 6) {
                // Mostrar a imagem do asset se estiver no próximo índice após a última imagem da lista
                return GestureDetector(
                  onTap: () {
                    //todo: add photos
                  },
                  child: Image.asset(
                    'lib/assets/images/Botao +botao_de_mais.png',
                    width: 25,
                  ),
                );
              } else {
                // Mostrar um container vazio para os slots restantes
                return null;
              }
            },
          ),
          const SizedBox(height: 26),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Vídeos ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                '(${widget.space.videosUrl.length} ${widget.space.videosUrl.length == 1 ? 'vídeo' : 'vídeos)'}',
                style: const TextStyle(
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
            itemCount: 3, // Sempre terá 3 itens no grid
            itemBuilder: (BuildContext context, int index) {
              if (index < widget.space.videosUrl.length) {
                // Mostrar os vídeos da lista
                return buildVideoPlayer(index);
              } else if (index == widget.space.videosUrl.length &&
                  widget.space.videosUrl.length < 3) {
                // Mostrar a imagem do asset se estiver no próximo índice após o último vídeo da lista
                return GestureDetector(
                  onTap: () {
                    //todo: add video
                  },
                  child: Image.asset(
                    'lib/assets/images/Botao +botao_de_mais.png',
                    width: 25,
                  ),
                );
              } else {
                return null;
              }
            },
          ),
        ],
      );
    }

    Widget myFirstWidget() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.space.selectedServices.length,
                      itemBuilder: (context, index) {
                        return Container(
                          constraints: BoxConstraints(minWidth: x / 3.5),
                          child: Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.asset(
                                    getIconPath(
                                        widget.space.selectedServices[index]),
                                    width: 40,
                                  ),
                                  if (isEditing)
                                    Positioned(
                                      top: -11,
                                      right: -2,
                                      child: Image.asset(
                                        'lib/assets/images/Deletardelete_service.png',
                                        width: 20,
                                      ),
                                    )
                                ],
                              ),

                              const SizedBox(
                                width: 8,
                              ),
                              // const Icon(Icons.align_vertical_top_sharp),
                              Text(widget.space.selectedServices[index]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (isEditing)
                    const SizedBox(
                      width: 10,
                    ),
                  if (isEditing)
                    Image.asset(
                      'lib/assets/images/Botao +botao_de_mais.png',
                      width: 30,
                    ),
                ],
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
            if (!isEditing)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  widget.space.descricao,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            if (isEditing)
              CustomTextformfield(
                hintText: 'Visão geral',
                controller: visaoGeralEC,
                fillColor: const Color(0xffF0F0F0),
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
            if (!isEditing)
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
            if (isEditing)
              Column(
                children: [
                  CustomTextformfield(
                    height: 40,
                    controller: visaoGeralEC,
                    hintText: 'CEP',
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Rua',
                    controller: visaoGeralEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Número',
                    controller: visaoGeralEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Bairro',
                    controller: visaoGeralEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Estado',
                    controller: visaoGeralEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                ],
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
                CircleAvatar(
                  radius: 20,
                  child: widget.space.locadorAvatarUrl != ''
                      ? CircleAvatar(
                          backgroundImage: Image.network(
                            widget.space.locadorAvatarUrl,
                            fit: BoxFit.cover,
                          ).image,
                          radius: 100,
                        )
                      : Text(widget.space.locadorName[0].toUpperCase()),
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
        ),
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
                  child: Stack(
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
                      if (isMySpace)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return RegisterPostPage(
                                      spaceModel: widget.space,
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text('Fazer post'),
                          ),
                        ),
                    ],
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
                        if (!isEditing)
                          Column(
                            children: [
                              Text(
                                style: const TextStyle(
                                    color: Color(0xff9747FF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                "R\$${widget.space.preco}",
                              ),
                              const Text('Por hora'),
                            ],
                          ),
                        if (isEditing)
                          SizedBox(
                            width: 110,
                            child: CustomTextformfield(
                              hintText: 'Preço',
                              withCrazyPadding: true,
                              keyboardType: TextInputType.number,
                              prefixIcon: const Text(
                                'R\$',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff9747FF),
                                ),
                              ),
                              controller: precoEC,
                              fillColor: const Color(0xffF0F0F0),
                            ),
                          )
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
        child: widget.isLocadorFlow
            ? Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        style: const TextStyle(
                            color: Color(0xff9747FF),
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        "R\$${widget.space.preco}",
                      ),
                      const Text('Por hora'),
                    ],
                  ),
                  const Spacer(),
                  if (!isEditing)
                    GestureDetector(
                      //todo:  excluir
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff9747FF),
                              Color(0xff4300B1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    //todo:
                    onTap: toggleEditing,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff9747FF),
                            Color(0xff4300B1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        isEditing ? 'Salvar' : 'Editar',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(
                      space: widget.space,
                    ),
                  ),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xff9747FF),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    'Alugar',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
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
