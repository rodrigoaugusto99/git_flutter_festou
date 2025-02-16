import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/post_single_page.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/meus%20feedbacks/minhas_avaliacoes_widgets.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/register/host%20feedback/host_feedback_register_page.dart';
import 'package:festou/src/features/register/posts/register_post_page.dart';
import 'package:festou/src/features/space%20card/widgets/calendar_page.dart';
import 'package:festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:festou/src/features/space%20card/widgets/show_new_map.dart';
import 'package:festou/src/features/space%20card/widgets/show_map.dart';
import 'package:festou/src/features/register/avaliacoes/avaliacoes_register_page.dart';
import 'package:festou/src/features/show%20spaces/space%20feedbacks%20mvvm/space_feedbacks_page_all.dart';
import 'package:festou/src/features/space%20card/widgets/utils.dart';
import 'package:festou/src/features/widgets/custom_textformfield.dart';
import 'package:festou/src/helpers/helpers.dart';
import 'package:festou/src/models/avaliacoes_model.dart';
import 'package:festou/src/models/reservation_model.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/services/avaliacoes_service.dart';
import 'package:festou/src/services/reserva_service.dart';
import 'package:festou/src/services/space_service.dart';
import 'package:festou/src/services/user_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:social_share/social_share.dart';
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
  List<ReservationModel> validReservations = <ReservationModel>[];
  bool isMySpace = false;
  bool canLeaveReview = false;

  @override
  void initState() {
    super.initState();
    checkUserReservation();
    init();
  }

  @override
  void dispose() {
    tabController.dispose();
    spaceService.cancelSpaceSubscription();
    reservaService.cancelReservationListener();
    super.dispose();
  }

  void showRatingDialog(SpaceModel space, ReservationModel reservation) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: AvaliacoesPage(space: space, reservation: reservation),
        );
      },
    );
  }

  void showRateHostDialog(SpaceModel space, ReservationModel reservation) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: HostFeedbackRegisterPage(
            space: space,
            reservation: reservation,
          ),
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

  Future<void> checkUserReservation() async {
    validReservations = await getValidReservations();

    setState(() {
      canLeaveReview = validReservations.isNotEmpty;
    });
  }

  Future<List<ReservationModel>> getValidReservations() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    DateTime now = DateTime.now();

    try {
      // Obter todas as reservas do usuário
      List<ReservationModel> reservations = await ReservaService()
          .getReservationsByClientIdAndSpaceId(widget.spaceId);

      // Filtrar reservas válidas
      var validReservations = reservations.where((reservation) {
        if (reservation.clientId != userId ||
            reservation.canceledAt != null ||
            reservation.hasReview) {
          return false;
        }

        // Converter selectedFinalDate para DateTime
        DateTime selectedFinalDate = reservation.selectedFinalDate.toDate();

        // Calcular o limite de 90 dias
        DateTime threeMonthLimit =
            selectedFinalDate.add(const Duration(days: 90));

        // Verificar se estamos dentro dos 90 dias ou se a reserva não foi cancelada
        return now.isBefore(threeMonthLimit) && reservation.canceledAt == null;
      }).toList();

      return validReservations;
    } catch (e) {
      return [];
    }
  }

  Future<void> refreshFeedbacks() async {
    List<AvaliacoesModel> updatedFeedbacks = await AvaliacoesService()
        .getMyFeedbacks(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      feedbacks = updatedFeedbacks;
    });
  }

  UserModel? user;

  List<String> selectedServices = [];

  double customHeight = 510;

  SpaceModel? space;
  List<AvaliacoesModel>? feedbacks;
  late SpaceService spaceService;
  late AvaliacoesService feedbackService;
  late ReservaService reservaService;
  double averageRating = 0;
  Future<void> init() async {
    spaceService = SpaceService();
    feedbackService = AvaliacoesService();
    reservaService = ReservaService();
    space = await spaceService.getSpaceById(widget.spaceId);
    feedbacks = await feedbackService.getFeedbacksOrdered(widget.spaceId);
    feedbacks!.removeWhere((f) => f.deletedAt != null);
    if (feedbacks!.isNotEmpty) {
      int totalRating = 0;
      for (final feedback in feedbacks!) {
        totalRating += feedback.rating;
      }
      averageRating = totalRating / feedbacks!.length;
    }
    final user = await UserService().getCurrentUserModel();
    if (user != null) {
      if (user.uid == space!.userId) {
        setState(() {
          isMySpace = true;
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        precoEC.text = space!.preco;
        visaoGeralEC.text = space!.descricao;
        cepEC.text = space!.cep;
        ruaEC.text = space!.logradouro;
        numeroEC.text = space!.numero;
        bairroEC.text = space!.bairro;
        cidadeEC.text = space!.cidade;
        estadoEC.text = space!.estado;
        selectedServices = space!.selectedServices as List<String>;
      });
    });
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      log(tabController.index.toString());
      if (tabController.index == 2) {
        if (feedbacks!.length == 2) {
          customHeight = 660;
        } else if (feedbacks!.length == 3) {
          customHeight = 900;
        }
      } else {
        customHeight = 510;
      }
      setState(() {});
    });
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
        feedbacks!.removeWhere((f) => f.deletedAt != null);
      });
    });
    await reservaService.setReservationListener(
      widget.spaceId,
      FirebaseAuth.instance.currentUser!.uid,
      (reservation) {
        if (!mounted) return;
        setState(() {
          canLeaveReview = reservation != null; // Atualiza UI dinamicamente
        });
      },
    );
  }

  bool isEditing = false;

  TextEditingController precoEC = TextEditingController();
  TextEditingController visaoGeralEC = TextEditingController();
  TextEditingController cepEC = TextEditingController();
  TextEditingController ruaEC = TextEditingController();
  TextEditingController numeroEC = TextEditingController();
  TextEditingController bairroEC = TextEditingController();
  TextEditingController cidadeEC = TextEditingController();
  TextEditingController estadoEC = TextEditingController();

  double? latitude;
  double? longitude;

  Future<String?> validateForm() async {
    try {
      final response = await calculateLatLng(ruaEC.text, numeroEC.text,
          bairroEC.text, cidadeEC.text, estadoEC.text);
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
    String estado,
  ) async {
    try {
      String fullAddress = '$logradouro, $numero, $bairro, $cidade, $estado';
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

  Future<void> toggleEditing({bool isSaved = true}) async {
    if (isEditing && isSaved) {
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
    if (!mounted) return;
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
      'estado': estadoEC.text,
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
    if (estadoEC.text.isEmpty) {
      return 'O campo Estado está vazio.';
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
    'Cozinha': 'lib/assets/images/icon_cozinha.png',
    'Estacionamento': 'lib/assets/images/icon_estacionamento.png',
    'Segurança': 'lib/assets/images/icon_seguranca.png',
    'Limpeza': 'lib/assets/images/icon_limpeza.png',
    'Decoração': 'lib/assets/images/icon_decoracao.png',
    'Bar': 'lib/assets/images/icon_bar.png',
    'Garçons': 'lib/assets/images/icon_garcom.png',
    'Ar-condicionado': 'lib/assets/images/icon_ar_condicionado.png',
    'Banheiros': 'lib/assets/images/icon_banheiro.png',
    'Iluminação': 'lib/assets/images/icon_iluminacao.png',
    'Som': 'lib/assets/images/icon_som.png',
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
    switch (service) {
      case 'Cozinha':
        return 'lib/assets/images/icon_cozinha.png';
      case 'Estacionamento':
        return 'lib/assets/images/icon_estacionamento.png';
      case 'Segurança':
        return 'lib/assets/images/icon_seguranca.png';
      case 'Limpeza ':
        return 'lib/assets/images/icon_limpeza.png';
      case 'Decoração':
        return 'lib/assets/images/icon_decoracao.png';
      case 'Bar':
        return 'lib/assets/images/icon_bar.png';
      case 'Garçons':
        return 'lib/assets/images/icon_garcom.png';
      case 'Ar-condicionado':
        return 'lib/assets/images/icon_ar_condicionado.png';
      case 'Banheiros':
        return 'lib/assets/images/icon_banheiro.png';
      case 'Iluminação':
        return 'lib/assets/images/icon_iluminacao.png';
      case 'Som':
        return 'lib/assets/images/icon_som.png';
      case 'Som e Iluminação':
        return 'lib/assets/images/som_e_iluminacao.png';
      default:
        return 'lib/assets/images/icon_mais.png';
    }
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

    Widget myThirdWidget() {
      return Column(
        children: [
          if (!isEditing && canLeaveReview)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => showRatingDialog(space!, validReservations.last),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffF0F0F0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/icon_lapis.png',
                      height: 24,
                    ),
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
                '(${feedbacks!.length} avaliações)',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff5E5E5E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (feedbacks != null) ...[
            if (feedbacks!.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 54),
                  child: Text(
                    'Sem avaliações',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (feedbacks!.isNotEmpty)
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedbacks!.length,
                itemBuilder: (BuildContext context, int index) {
                  final feedback = feedbacks![index];
                  return AvaliacoesItem(
                    feedback: feedback,
                    onDelete: () async {
                      await refreshFeedbacks();
                    },
                  );
                },
              ),
          ],
          if (feedbacks != null && feedbacks!.length > 3)
            InkWell(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff9747FF),
                        Color(0xff44300b1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: const Text(
                    'Ver mais',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpaceFeedbacksPageAll(
                      space: space!,
                      feedbacks: feedbacks!,
                    ),
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
            children: [
              const Text(
                'Fotos ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '(${space!.imagesUrl.length} ${space!.imagesUrl.length == 1 ? 'foto)' : 'fotos)'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff5E5E5E),
                  ),
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoDetailScreen(
                                  photoUrls: space!.imagesUrl,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: space!.imagesUrl[index],
                            child: Image.network(
                              height: 90,
                              space!.imagesUrl[index].toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      if (isEditing)
                        decContainer(
                          radius: 10,
                          height: 90,
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
                            'lib/assets/images/icon_lixeira.png',
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
                            'lib/assets/images/icon_lixeira.png',
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
                      'lib/assets/images/imagem_mais.png',
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
            children: [
              const Text(
                'Vídeos ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '(${space!.videosUrl.length} ${space!.videosUrl.length == 1 ? 'vídeo)' : 'vídeos)'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff5E5E5E),
                  ),
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
                            'lib/assets/images/icon_lixeira.png',
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
                            'lib/assets/images/icon_lixeira.png',
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
                      'lib/assets/images/imagem_mais.png',
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
            if (space!.selectedServices.isNotEmpty)
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: space!.selectedServices.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  decContainer(
                                    height: 35,
                                    width: 35,
                                    allPadding: 5,
                                    radius: 30,
                                    color: const Color(0xffF3F3F3),
                                    child: Image.asset(
                                      getIconPath(
                                          space!.selectedServices[index]),
                                    ),
                                  ),
                                  if (isEditing)
                                    Positioned(
                                      top: -3,
                                      right: -3,
                                      child: GestureDetector(
                                        onTap: () => addOrRemoveService(
                                            space!.selectedServices[index]),
                                        child: Image.asset(
                                          'lib/assets/images/icon_delete.png',
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(space!.selectedServices[index]),
                              const SizedBox(
                                width: 12,
                              ),
                            ],
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
                        onTap: () =>
                            showBottomSheet2(context, selectedServices),
                        child: Image.asset(
                          'lib/assets/images/imagem_mais.png',
                          width: 30,
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
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
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            if (isEditing)
              CustomTextformfield(
                isBig: true,
                hintText: 'Visão geral',
                controller: visaoGeralEC,
                fillColor: const Color(0xffF0F0F0),
              ),
            const SizedBox(height: 16),
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
                  const SizedBox(height: 10),
                  CustomTextformfield(
                    height: 40,
                    hintText: 'Estado',
                    controller: estadoEC,
                    fillColor: const Color(0xffF0F0F0),
                  ),
                ],
              ),
            const SizedBox(height: 24),
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
                if (!isMySpace)
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(7),
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
              child: CustomLoadingIndicator(),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: InkWell(
                        onTap: () => share(),
                        child: const Icon(Icons.share),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
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
                                enableInfiniteScroll: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentSlide = index;
                                  });
                                },
                              ),
                            ),
                            if (isMySpace)
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () {
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff9747FF),
                                          Color(0xff44300b1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: const Text(
                                      'Postar feed',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
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
                                    averageRating,
                                  ),
                                ),
                                height: 26,
                                width: 26,
                                child: Center(
                                  child: Text(
                                    averageRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 12,
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
                                    const Text(
                                      'Por hora',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Image.asset('lib/assets/images/icon_gps.png',
                                  height: 28),
                              const SizedBox(width: 4),
                              Text(
                                '${space!.cidade}, ${space!.estado}',
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
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  if (tabController.index == 0)
                                    myFirstWidget(), // Sobre
                                  if (tabController.index == 1)
                                    mySecondWidget(), // Galeria
                                  if (tabController.index == 2)
                                    myThirdWidget(), // Avaliação
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: widget.isLocadorFlow
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (!isEditing) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Center(
                                                child: Lottie.asset(
                                                  'lib/assets/animations/warning_exit.json',
                                                  width: 100,
                                                  height: 100,
                                                  repeat: true,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              const Center(
                                                child: Text(
                                                  'Exclusão do espaço',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              const Text(
                                                'Tem certeza que deseja excluir o espaços?',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                final now = DateTime.now();
                                                final querySnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'reservations')
                                                        .where('space_id',
                                                            isEqualTo:
                                                                space!.spaceId)
                                                        .get();

                                                for (var doc
                                                    in querySnapshot.docs) {
                                                  bool canceledDate = false;
                                                  final selectedDate =
                                                      (doc['selectedDate']
                                                              as Timestamp)
                                                          .toDate();

                                                  if (doc['canceledAt'] !=
                                                      null) {
                                                    canceledDate = true;
                                                  }

                                                  if (selectedDate
                                                          .isAfter(now) &&
                                                      !canceledDate) {
                                                    Messages.showError(
                                                        'Você não pode excluir esse espaço pois há reservas',
                                                        context);
                                                    return;
                                                  }
                                                }
                                                try {
                                                  final spaceSnapshot =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('spaces')
                                                          .where('space_id',
                                                              isEqualTo: space!
                                                                  .spaceId)
                                                          .get();

                                                  for (var doc
                                                      in spaceSnapshot.docs) {
                                                    await doc.reference
                                                        .delete();
                                                  }
                                                  Messages.showSuccess(
                                                    'O espaço foi excluído',
                                                    context,
                                                  );
                                                } on Exception catch (e) {
                                                  log(e.toString());
                                                  Messages.showError(
                                                    'Houve algum erro ao tentar excluir o espaço. Entre em contato conosco',
                                                    context,
                                                  );
                                                }
                                              },
                                              child: const Text('Sim, excluir'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    toggleEditing(isSaved: false);
                                  }
                                  //pode deletar
                                },
                                child: Container(
                                  width: 80,
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isEditing
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xff9747FF),
                                              Color(0xff4300B1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                        : const LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 255, 0, 0),
                                              Color.fromARGB(255, 255, 0, 0),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: isEditing
                                      ? const Text(
                                          'Cancelar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        )
                                      : const Text(
                                          'Excluir',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: toggleEditing,
                                child: Container(
                                  width: 80,
                                  height: 32,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CalendarPage(
                                          space: space!,
                                          isIndisponibilizar: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 170,
                                    height: 32,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
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
                                      'Indisponibilizar horário',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : isMySpace
                        ? GestureDetector(
                            onTap: () {
                              if (isMySpace) return;
                              if (user != null && user!.cpf.isEmpty) {
                                Messages.showInfo(
                                    'Você precisa de um CPF cadastrado para alugar um espaço',
                                    context);
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalendarPage(
                                    space: space!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey),
                              child: const Text(
                                'Alugar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (isMySpace) return;
                              if (user != null && user!.cpf.isEmpty) {
                                Messages.showInfo(
                                    'Você precisa de um CPF cadastrado para alugar um espaço',
                                    context);
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalendarPage(
                                    space: space!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff9747FF),
                                    Color(0xff44300b1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: const Text(
                                'Alugar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
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
