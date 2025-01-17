import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/host%20feedback/host_feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/register/posts/register_post_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/calendar_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info_edit_vm.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_feedback_widget_limited.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/show_new_map.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/show_map.dart';
import 'package:git_flutter_festou/src/features/register/feedback/feedback_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_limited.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_all.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/utils.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';
import 'package:git_flutter_festou/src/models/feedback_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/feedback_service.dart';
import 'package:git_flutter_festou/src/services/space_service.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_share/social_share.dart';
import 'package:svg_flutter/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NewCardInfo extends StatefulWidget {
  final String spaceId;
  bool isLocadorFlow;
  NewCardInfo({
    super.key,
    required this.spaceId,
    this.isLocadorFlow = false,
  });

  @override
  State<NewCardInfo> createState() => _NewCardInfoState();
}

int _currentSlide = 0;

bool scrollingUp = false;

class _NewCardInfoState extends State<NewCardInfo>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<VideoPlayerController> controllers = [];

  bool isMySpace = false;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    tabController.dispose();
    spaceService.cancelSpaceSubscription();
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
    String spaceLink = generateSpaceLink(space!);
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
    if (space!.numComments == '0') {
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
    } else if (space!.numComments == '1') {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _getColor(
                double.parse(space!.averageRating),
              ),
            ),
            height: 35, // Ajuste conforme necessário
            width: 25, // Ajuste conforme necessário
            child: Center(
              child: Text(
                double.parse(space!.averageRating).toStringAsFixed(1),
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
            '${space!.numComments} avaliação',
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
                double.parse(space!.averageRating),
              ),
            ),
            height: 35, // Ajuste conforme necessário
            width: 25, // Ajuste conforme necessário
            child: Center(
              child: Text(
                double.parse(space!.averageRating).toStringAsFixed(1),
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
            '${space!.numComments} avaliações',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }
  }

  //NewCardInfoEditVm? newCardInfoEditVm;
  List<String> selectedServices = [];

  SpaceModel? space;
  List<FeedbackModel>? feedbacks;
  late SpaceService spaceService;
  late FeedbackService feedbackService;
  Future<void> init() async {
    spaceService = SpaceService();
    feedbackService = FeedbackService();
    space = await spaceService.getSpaceById(widget.spaceId);
    feedbacks = await feedbackService.getFeedbacksOrdered(widget.spaceId);
    feedbacks!.removeWhere((f) => f.deleteAt != null);
    final user = await UserService().getCurrentUserModel();
    if (user != null) {
      if (user.uid == space!.userId) {
        setState(() {
          isMySpace = true;
        });
      }
    }
    // setState(() {});
    // newCardInfoEditVm = NewCardInfoEditVm(spaceId: space!.spaceId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        precoEC.text = space!.preco;
        visaoGeralEC.text = space!.descricao;
        cepEC.text = space!.cep;
        ruaEC.text = space!.logradouro;
        numeroEC.text = space!.numero;
        bairroEC.text = space!.bairro;
        cidadeEC.text = space!.cidade;
        selectedServices = space!.selectedServices as List<String>;
      });
    });
    tabController = TabController(length: 3, vsync: this);
    for (var video in space!.videosUrl) {
      VideoPlayerController controller = VideoPlayerController.network(video)
        ..initialize().then((_) {
          setState(() {});
        });
      controllers.add(controller);
    }
    await spaceService.setSpaceListener(widget.spaceId, (newSpace) {
      if (!mounted) return;
      setState(() {
        space = newSpace;
      });
    });
    await feedbackService.setSpaceFeedbacksListener(widget.spaceId,
        (newFeedbacks) {
      if (!mounted) return;
      setState(() {
        feedbacks = newFeedbacks;
        feedbacks!.removeWhere((f) => f.deleteAt != null);
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
  final cidadeEC = TextEditingController();

  //todo: verificacao da existencia do endereco.

  double? latitude;
  double? longitude;

  Future<String?> validateForm() async {
    try {
      final response = await calculateLatLng(
          ruaEC.text, numeroEC.text, bairroEC.text, cidadeEC.text);
      latitude = response.latitude;
      longitude = response.longitude;
      log(response.toString(), name: 'response do calculateLtn');
      return null;
    } on Exception catch (e) {
      log(e.toString());

      return 'Localização não existe';
    }
  }

  Future<LatLng> calculateLatLng(
    String logradouro,
    String numero,
    String bairro,
    String cidade,
  ) async {
    try {
      String fullAddress = '$logradouro, $numero, $bairro, $cidade';
      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isNotEmpty) {
        return LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
      } else {
        throw Exception(
            'Não foi possível obter as coordenadas para o endereço: $fullAddress');
      }
    } catch (e) {
      log('Erro ao calcular LatLng: $e');
      rethrow;
    }
  }

  Future<void> toggleEditing() async {
    if (isEditing) {
      final x = validada();
      if (x != null) {
        Messages.showError(x, context);
        return;
      }
      final y = await validateForm();
      if (y != null) {
        Messages.showError(y, context);
        return;
      }

      saveChanges();
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  List<String> networkImagesToDelete = [];
  List<String> networkVideosToDelete = [];

  List<File> imageFilesToDownload = [];
  List<File> videosToDownload = [];

  void saveChanges() {
    log(selectedServices.toString(), name: 'selectedServices');
    Map<String, dynamic> newSpaceInfos = {
      'latitude': latitude,
      'longitude': longitude,
      'preco': precoEC.text,
      'selectedServices': selectedServices,
      'cep': cepEC.text,
      'logradouro': ruaEC.text,
      'numero': numeroEC.text,
      'bairro': bairroEC.text,
      'cidade': cidadeEC.text,
      'descricao': visaoGeralEC.text,
    };

    Messages.showSuccess('Espaço atualizado com sucesso!', context);

    log(networkImagesToDelete.toString(), name: 'networkImagesToDelete');
    log(networkVideosToDelete.toString(), name: 'networkVideosToDelete');
    log(imageFilesToDownload.length.toString(), name: 'imageFilesToDownload');
    log(videosToDownload.length.toString(), name: 'videosToDownload');
    spaceService.updateSpace(
      spaceId: widget.spaceId,
      newSpaceInfos: newSpaceInfos,
      networkImagesToDelete: networkImagesToDelete,
      networkVideosToDelete: networkVideosToDelete,
      imageFilesToDownload: imageFilesToDownload,
      videosToDownload: videosToDownload,
    );
  }

  void pickImage() async {
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();

    int currentTotalImages =
        space!.imagesUrl.length + imageFilesToDownload.length;
    int remainingSlots = 6 - currentTotalImages;

    if (remainingSlots > 0) {
      for (int i = 0; i < images.length && i < remainingSlots; i++) {
        final imageFile = File(images[i].path);
        setState(() {
          imageFilesToDownload.add(imageFile);
        });
      }
    }
  }

  final List<VideoPlayerController> localControllers = [];

  void pickVideo() async {
    final videoPicker = ImagePicker();
    final XFile? video =
        await videoPicker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      int currentTotalVideos =
          space!.videosUrl.length + videosToDownload.length;
      int remainingSlots = 3 - currentTotalVideos;

      if (remainingSlots > 0) {
        final videoFile = File(video.path);
        setState(() {
          videosToDownload.add(videoFile);
          VideoPlayerController controller =
              VideoPlayerController.file(videoFile)
                ..initialize().then((_) {
                  setState(() {});
                });
          localControllers.add(controller);
        });
      }
    }
  }

  String? validada() {
    if (precoEC.text.isEmpty) {
      return 'O campo Preço está vazio.';
    }
    if (visaoGeralEC.text.isEmpty) {
      return 'O campo Visão Geral está vazio.';
    }
    if (cepEC.text.isEmpty) {
      return 'O campo CEP está vazio.';
    }
    if (ruaEC.text.isEmpty) {
      return 'O campo Rua está vazio.';
    }
    if (numeroEC.text.isEmpty) {
      return 'O campo Número está vazio.';
    }
    if (bairroEC.text.isEmpty) {
      return 'O campo Bairro está vazio.';
    }
    if (cidadeEC.text.isEmpty) {
      return 'O campo Cidade está vazio.';
    }

    return null;
  }

//todo: estilizar bottom sheets
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                space!.descricao,
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

  Map<String, String> serviceIconPaths = {
    'Cozinha': 'lib/assets/images/image 3cozinha.png',
    'Estacionamento': 'lib/assets/images/image 3estacionamento.png',
    'Segurança': 'lib/assets/images/image 3seguranca.png',
    'Limpeza': 'lib/assets/images/image 3limpeza.png',
    'Decoração': 'lib/assets/images/image 3decoracao.png',
    'Bar': 'lib/assets/images/image 3bar.png',
    'Garçons': 'lib/assets/images/image 3garcom.png',
    'Ar-condicionado': 'lib/assets/images/image 3arcondicionado.png',
    'Banheiros': 'lib/assets/images/image 3banheiro.png',
    'Som e iluminação': 'lib/assets/images/image 3somiluminacao.png',
  };
  void addOrRemoveService(String service) {
    log(service);
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
    setState(() {});
    log(selectedServices.toString());
  }

  void showBottomSheet2(BuildContext context, List<String> selectedServices) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // void addOrRemoveService(String service) {
            //   log(service);
            //   if (selectedServices.contains(service)) {
            //     selectedServices.remove(service);
            //   } else {
            //     selectedServices.add(service);
            //   }
            //   setState(() {}); // Atualiza o estado local do BottomSheet
            //   log(selectedServices.toString());
            // }

            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Adicione serviços',
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
                    runSpacing:
                        8, // Espaçamento vertical entre as linhas de chips
                    children: serviceIconPaths.entries.map((entry) {
                      final isSelected = selectedServices.contains(entry.key);
                      return GestureDetector(
                        onTap: () {
                          addOrRemoveService(entry.key);
                          setState(
                              () {}); // Atualiza o estado local do BottomSheet
                        },
                        child: Chip(
                          backgroundColor: isSelected
                              ? Colors.grey
                              : const Color.fromARGB(255, 195, 162, 201),
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          avatar: Image.asset(
                            getIconPath(entry.key),
                            width: 40,
                          ),
                          label: Text(entry.key),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getIconPath(String service) {
    if (service == 'Cozinha') {
      return 'lib/assets/images/image 3cozinha.png';
    }
    if (service == 'Estacionamento') {
      return 'lib/assets/images/image 3estacionamento.png';
    }
    if (service == 'Segurança') {
      return 'lib/assets/images/image 3seguranca.png';
    }
    if (service == 'Limpeza ') return 'lib/assets/images/image 3limpeza.png';
    if (service == 'Decoração') {
      return 'lib/assets/images/image 3decoracao.png';
    }
    if (service == 'Bar') return 'lib/assets/images/image 3bar.png';
    if (service == 'Garçons') return 'lib/assets/images/image 3garcom.png';
    if (service == 'Ar-condicionado') {
      return 'lib/assets/images/image 3arcondicionado.png';
    }
    if (service == 'Banheiros') {
      return 'lib/assets/images/image 3banheiro.png';
    }
    if (service == 'Som e iluminação') {
      return 'lib/assets/images/image 3somiluminacao.png';
    }

    return 'lib/assets/images/image 3outros.png';
  }

  bool isCarouselVisible = true;

  @override
  Widget build(BuildContext context) {
    void toggle() {
      setState(() {
        space!.isFavorited = !space!.isFavorited;
      });
      spaceService.toggleFavoriteSpace(
        space!.spaceId,
        space!.isFavorited,
      );
    }

//todo:

    final x = MediaQuery.of(context).size.width;

    Widget myThirdWidget() {
      return Column(
        children: [
          //botao
          if (!isEditing)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => showRatingDialog(space!),
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
          if (space!.numComments != '0')
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
                  '(${feedbacks!.length} avaliações)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff5E5E5E),
                  ),
                ),
              ],
            ),
          // if (space!.numComments != '0')
          //   SpaceFeedbacksPageLimited(
          //     x: 2,
          //     space: space!,
          //   ),
          if (space!.numComments != '0' && feedbacks != null) ...[
            if (feedbacks!.isEmpty)
              const Center(
                child: Text(
                  'Sem avaliações(ainda)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (feedbacks!.isNotEmpty)
              NewFeedbackWidgetLimited(
                x: 2,
                feedbacks: feedbacks!,
              ),
          ],
          if (space!.numComments != '0')
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
                    builder: (context) => SpaceFeedbacksPageAll(space: space!),
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
                '(${space!.imagesUrl.length} ${space!.imagesUrl.length == 1 ? 'foto)' : 'fotos)'}',
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
              int networkImagesCount = space!.imagesUrl.length;
              int localImagesCount = imageFilesToDownload.length;
              int totalImagesCount = networkImagesCount + localImagesCount;
              int maxImages = 6;

              if (index < networkImagesCount) {
                // Mostrar as imagens da lista de URLs
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          height: 90,
                          space!.imagesUrl[index].toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isEditing)
                        decContainer(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      if (isEditing)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              networkImagesToDelete
                                  .add(space!.imagesUrl[index].toString());
                              space!.imagesUrl.removeAt(index);
                            });
                          },
                          child: Image.asset(
                            'lib/assets/images/Ellipse 37lixeira-foto.png',
                            width: 40,
                          ),
                        ),
                    ],
                  ),
                );
              } else if (index < networkImagesCount + localImagesCount) {
                // Mostrar as imagens da lista de arquivos locais
                int localIndex = index - networkImagesCount;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        imageFilesToDownload[localIndex],
                        fit: BoxFit.cover,
                      ),
                      if (isEditing)
                        decContainer(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      if (isEditing)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              imageFilesToDownload.removeAt(localIndex);
                            });
                          },
                          child: Image.asset(
                            'lib/assets/images/Ellipse 37lixeira-foto.png',
                            width: 40,
                          ),
                        ),
                    ],
                  ),
                );
              } else if (index == totalImagesCount &&
                  totalImagesCount < maxImages) {
                // Mostrar a imagem do asset se estiver no próximo índice após a última imagem da lista
                if (isEditing) {
                  return GestureDetector(
                    onTap: pickImage,
                    child: Image.asset(
                      'lib/assets/images/Botao +botao_de_mais.png',
                      width: 25,
                    ),
                  );
                } else {
                  return null;
                }
              } else {
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
                '(${space!.videosUrl.length} ${space!.videosUrl.length == 1 ? 'vídeo' : 'vídeos)'}',
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
              int networkVideosCount = space!.videosUrl.length;
              int localVideosCount =
                  videosToDownload.length > 3 ? 3 : videosToDownload.length;
              int totalVideosCount = networkVideosCount + localVideosCount;
              int maxVideos = 3;

              if (index < networkVideosCount) {
                // Mostrar os vídeos da lista de URLs
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      buildVideoPlayer(index, controllers, context),
                      if (isEditing)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      if (isEditing)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              networkVideosToDelete
                                  .add(space!.videosUrl[index]);
                              space!.videosUrl.removeAt(index);
                              controllers[index].dispose();
                              controllers.removeAt(index);
                            });
                          },
                          child: Image.asset(
                            'lib/assets/images/Ellipse 37lixeira-foto.png',
                            width: 40,
                          ),
                        ),
                    ],
                  ),
                );
              } else if (index < networkVideosCount + localVideosCount) {
                // Mostrar os vídeos da lista de arquivos locais
                int localIndex = index - networkVideosCount;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      buildVideoPlayerFromFile(
                          localIndex, context, controllers),
                      if (isEditing)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      if (isEditing)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              videosToDownload.removeAt(localIndex);
                              localControllers[localIndex].dispose();
                              localControllers.removeAt(localIndex);
                            });
                          },
                          child: Image.asset(
                            'lib/assets/images/Ellipse 37lixeira-foto.png',
                            width: 40,
                          ),
                        ),
                    ],
                  ),
                );
              } else if (index == totalVideosCount &&
                  totalVideosCount < maxVideos) {
                // Mostrar a imagem do asset se estiver no próximo índice após o último vídeo da lista
                if (isEditing) {
                  return GestureDetector(
                    onTap: pickVideo,
                    child: Image.asset(
                      'lib/assets/images/Botao +botao_de_mais.png',
                      width: 25,
                    ),
                  );
                } else {
                  return null;
                }
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
                      itemCount: space!.selectedServices.length,
                      itemBuilder: (context, index) {
                        return Container(
                          constraints: BoxConstraints(minWidth: x / 3.5),
                          child: Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.asset(
                                    getIconPath(space!.selectedServices[index]),
                                    width: 40,
                                  ),
                                  if (isEditing)
                                    Positioned(
                                      top: -3,
                                      right: -3,
                                      child: GestureDetector(
                                        onTap: () => addOrRemoveService(
                                            space!.selectedServices[index]),
                                        child: Image.asset(
                                          'lib/assets/images/Deletardelete_service.png',
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(
                                width: 8,
                              ),
                              // const Icon(Icons.align_vertical_top_sharp),
                              Text(space!.selectedServices[index]),
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
                    GestureDetector(
                      onTap: () => showBottomSheet2(context, selectedServices),
                      child: Image.asset(
                        'lib/assets/images/Botao +botao_de_mais.png',
                        width: 30,
                      ),
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
              GestureDetector(
                onTap: () => showBottomSheet(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    space!.descricao,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                          space: space!,
                        ),
                      ),
                    );
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: ShowMap(
                      space: space!,
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
                    controller: cepEC,
                    hintText: 'CEP',
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Rua',
                    controller: ruaEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Número',
                    controller: numeroEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Bairro',
                    controller: bairroEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Cidade',
                    controller: cidadeEC,
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
                  child: space!.locadorAvatarUrl != ''
                      ? CircleAvatar(
                          backgroundImage: Image.network(
                            space!.locadorAvatarUrl,
                            fit: BoxFit.cover,
                          ).image,
                          radius: 100,
                        )
                      : Text(space!.locadorName[0].toUpperCase()),
                ),
                const SizedBox(width: 10),
                Text(
                  space!.locadorName,
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
                          receiverID: space!.userId,
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

    return space == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
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
                      child: space!.isFavorited
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
                              items: space!.imagesUrl
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
                                            spaceModel: space!,
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
                    children: space!.imagesUrl.map((url) {
                      int index = space!.imagesUrl.indexOf(url);
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
                              Text(
                                space!.titulo,
                                style: const TextStyle(
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
                                    double.parse(space!.averageRating),
                                  ),
                                ),
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: Text(
                                    double.parse(space!.averageRating)
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
                                      "R\$ ${trocarPontoPorVirgula(space!.preco)}",
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
                              SvgPicture.asset(
                                  'lib/assets/images/Vectorcheck.svg'),
                              const SizedBox(width: 7),
                              Text(
                                '${space!.cidade}, Brasil',
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
                  //   space: space!,
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
                  //             SpaceFeedbacksPageAll(space: space!),
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
                              "R\$${space!.preco}",
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
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
                            space: space!,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
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
