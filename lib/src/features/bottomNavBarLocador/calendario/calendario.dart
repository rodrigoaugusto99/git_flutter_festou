import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/minhas%20reservas/cancel_reservation_dialog.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/minhas%20reservas/minhas_reservas_widget.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/register/space/space%20temporary/pages/new_space_register.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:festou/src/features/space%20card/widgets/contrato_assinado_page.dart';
import 'package:festou/src/helpers/helpers.dart';
import 'package:festou/src/models/reservation_model.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/reserva_service.dart';
import 'package:festou/src/services/space_service.dart';
import 'package:festou/src/services/user_service.dart';
import 'package:intl/intl.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key});

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  List<ReservationModel>? minhasReservas;
  List<SpaceModel>? mySpaces;
  List<ReservationModel>? minhasReservasProximas;
  UserService userService = UserService();
  SpaceService spaceService = SpaceService();
  UserModel? userModel;

  List<ReservationModel>? selectedSpaceReservations;

  SpaceModel? selectedSpace;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isLoading = true;
    await fetchReservas();
    await fetchSpaces();
    if (mySpaces != null && mySpaces!.isNotEmpty) {
      selectSpace(mySpaces!.first);
    }

    mountedSetState();
    isLoading = false;
  }

  void fetchReservasDoEspaco(String spaceId) async {
    if (minhasReservas == null) {
      return;
    }
    isLoading = true;
    // selectedSpaceReservations =
    //     await ReservaService().getReservationsBySpaceId(spaceId);
    selectedSpaceReservations = minhasReservas!
        .where((r) => r.spaceId == spaceId)
        .toList()
      ..sort((a, b) => a.selectedDate.compareTo(b.selectedDate));
    if (selectedSpaceReservations == null) {
      log('selectedSpaceReservations null');
      return;
    }
    isLoading = false;
    mountedSetState();
  }

  void selectSpace(SpaceModel space) {
    selectedSpace = space;
    fetchReservasDoEspaco(space.spaceId);
  }

  Future<void> fetchSpaces() async {
    mySpaces = await spaceService.getMySpaces();
  }

  void mountedSetState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchReservas() async {
    userModel = await userService.getCurrentUserModel();
    if (userModel == null) {
      log('user null');
      return;
    }

    minhasReservas =
        await ReservaService().getReservationsByLocadorId(userModel!.uid);

    if (minhasReservas == null) {
      log('minhasReservas null');
      return;
    }
    for (final reserva in minhasReservas!) {
      final user = await getUserById(reserva.clientId);
      reserva.user = user;
    }
    minhasReservasProximas = getNearbyReservations(minhasReservas!);
  }

  List<ReservationModel> getNearbyReservations(
      List<ReservationModel> reservations) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));
    DateTime dayAfterTomorrow = today.add(const Duration(days: 2));

    return reservations.where((reservation) {
      if (reservation.canceledAt != null) return false;
      DateTime selectedDate = reservation.selectedDate.toDate();
      DateTime selectedDateOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      return selectedDateOnly.isAtSameMomentAs(today) ||
          selectedDateOnly.isAtSameMomentAs(tomorrow) ||
          selectedDateOnly.isAtSameMomentAs(dayAfterTomorrow);
    }).toList();
  }

  Future<UserModel?> getUserById(String id) async {
    final user = await UserService().getCurrentUserModelById(id: id);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificacoesPage(
                      locador: true,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Calendário',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfff8f8f8),
      ),
      body: isLoading
          ? const Center(child: CustomLoadingIndicator())
          : mySpaces != null && mySpaces!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Você ainda não cadastrou nenhum espaço!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Cadastre um espaço agora e comece a receber reservas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navegar para tela de cadastro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewSpaceRegister(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Cadastrar meu espaço'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //clipBehavior: Clip.none,
                        // padding: const EdgeInsets.all(20),
                        children: [
                          if (mySpaces != null && mySpaces!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            const Text('Escolha o espaço'),
                            const SizedBox(height: 20),
                            ...mySpaces!.map((space) {
                              return Column(
                                children: [
                                  SpaceWidget(
                                    isSelected:
                                        selectedSpace!.spaceId == space.spaceId,
                                    space: space,
                                    onTap: () => selectSpace(space),
                                  ),
                                  const SizedBox(height: 17),
                                ],
                              );
                            }),
                            const SizedBox(height: 20),
                            const Text('Calendário de reservas'),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                'Reservas referentes ao espaço selecionado',
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            if (selectedSpaceReservations != null) ...[
                              const SizedBox(height: 20),
                              CalendarioExpansioWidget(
                                minhasReservas: selectedSpaceReservations!,
                                title: 'Reservas desse espaço',
                              ),
                            ],
                            const SizedBox(height: 14),
                            CalendarioExpansioWidget(
                              minhasReservas: minhasReservasProximas!,
                              title: 'Próximas reservas',
                              isNear: true,
                            ),
                            const SizedBox(height: 50),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}

class SpaceWidget extends StatelessWidget {
  final SpaceModel space;
  final Function()? onTap;
  final bool isSelected;
  const SpaceWidget({
    super.key,
    required this.space,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            decContainer(
              radius: 8,
              color: const Color.fromARGB(255, 255, 255, 255),
              width: screenWidth(context) * 0.7,
              height: screenHeight(context) * 0.09,
              child: Stack(
                children: [
                  Image.network(
                    space.imagesUrl.isNotEmpty
                        ? space.imagesUrl[0]
                        : 'URL de uma imagem padrão ou vazia',
                    width: screenWidth(context) * 0.7,
                    height: screenHeight(context) * 0.09,
                    // color: Colors.green,

                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: decContainer(
                      color: Colors.white.withOpacity(0.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  space.titulo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${space.bairro}, ${space.cidade}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 66, 66, 66)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: getColor(
                                  double.parse(space.averageRating),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 4.0),
                                child: Text(
                                  double.parse(space.averageRating)
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white, // Cor do texto
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            decContainer(
              allPadding: 3,
              child: isSelected
                  ? decContainer(
                      radius: 20,
                      color: Colors.black,
                    )
                  : null,
              radius: 40,
              height: 12,
              width: 12,
              color: Colors.white,
              borderColor: const Color(0xffC6C6C6),
              borderWidth: 0.8,
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}

class CalendarioExpansioWidget extends StatefulWidget {
  final List<ReservationModel> minhasReservas;
  final String title;
  final bool isNear;

  const CalendarioExpansioWidget({
    required this.minhasReservas,
    required this.title,
    this.isNear = false,
    super.key,
  });

  @override
  State<CalendarioExpansioWidget> createState() =>
      _CalendarioExpansioWidgetState();
}

class _CalendarioExpansioWidgetState extends State<CalendarioExpansioWidget> {
  late List<SpaceWithReservation> reservationSpaces;

  String formatTime(int hour) {
    String hourStr = hour.toString().padLeft(2, '0');
    return '$hourStr:00h';
  }

  String formatDateTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateFormat formatter = DateFormat("d 'de' MMM. yyyy", 'pt_BR');
    return formatter.format(date);
  }

  String? formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return null;
    DateTime date = timestamp.toDate();
    DateFormat formatter = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR');
    return formatter.format(date);
  }

  void showCancellationReasonDialog(BuildContext context, String reason) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Motivo do Cancelamento'),
          content: Text(
            reason.isNotEmpty
                ? reason
                : 'Nenhum motivo foi fornecido para este cancelamento.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  bool isDateInFuture(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    DateTime now = DateTime.now();
    return date.isAfter(now);
  }

  Future<void> getMyReservations() async {
    final reservas = await ReservaService().getReservationsByClientId();

    List<SpaceWithReservation> updatedReservationSpaces = [];

    for (final reserva in reservas) {
      final space = await SpaceService().getSpaceById(reserva.spaceId);
      if (space == null) continue;

      updatedReservationSpaces
          .add(SpaceWithReservation(space: space, reserva: reserva));
    }

    setState(() {
      reservationSpaces = updatedReservationSpaces;
    });
  }

  Future<void> cancelReservation(
      ReservationModel reserva, String reason) async {
    try {
      // Atualiza a reserva para refletir o cancelamento
      if (!mounted) return;
      setState(() {
        reserva.canceledAt = Timestamp.now();
        reserva.reason = reason;
      });

      Messages.showSuccess('Reserva cancelada com sucesso!', context);
    } catch (e) {
      Messages.showError('Erro ao cancelar reserva: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ExpansionTile(
              collapsedBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              // clipBehavior: Clip.hardEdge,
              collapsedShape: const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
              childrenPadding: const EdgeInsets.symmetric(vertical: 10),
              title: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (widget.isNear)
                    Positioned(
                      left: 5,
                      child: Image.asset(
                        'lib/assets/images/icon_calendario_hora.png',
                        height: 25,
                      ),
                    ),
                  if (!widget.isNear)
                    Positioned(
                      left: 2,
                      child: Image.asset(
                        'lib/assets/images/icon_calendar.png',
                        height: 25,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Positioned(
                    left: 40,
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              children: widget.minhasReservas.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            widget.isNear
                                ? "Nenhuma reserva nos próximos 3 dias!"
                                : "Sem reservas para esse espaço",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ]
                  : widget.minhasReservas.map((reserva) {
                      bool eventInFuture =
                          isDateInFuture(reserva.selectedFinalDate);
                      final user = reserva.user;

                      return Container(
                        decoration: BoxDecoration(
                          color: eventInFuture && reserva.canceledAt == null
                              ? null
                              : const Color(0xffD4D4D4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formatTimestamp(reserva.createdAt)!,
                                      style: const TextStyle(
                                        color: Color(0xff4300B1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                    'lib/assets/images/background_confete.png'),
                                if (reserva.canceledAt != null)
                                  Image.asset(
                                    'lib/assets/images/imagem_cancelado.png',
                                    height: getResponsiveWidth(context, 115),
                                  ),
                                if (reserva.canceledAt == null)
                                  Image.asset(
                                    'lib/assets/images/imagem_confirmado.png',
                                    height: getResponsiveWidth(context, 90),
                                  ),
                                decContainer(
                                  topPadding: 10,
                                  bottomPadding: 16,
                                  leftPadding: 10,
                                  rightPadding: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          if (user != null &&
                                              user.avatarUrl != '')
                                            CircleAvatar(
                                              backgroundImage: Image.network(
                                                user.avatarUrl,
                                                fit: BoxFit.cover,
                                              ).image,
                                              radius: 20,
                                            ),
                                          if (user != null &&
                                              user.avatarUrl.isEmpty)
                                            CircleAvatar(
                                              radius: 20,
                                              child: user.name.isNotEmpty
                                                  ? Text(
                                                      user.name[0]
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 25),
                                                    )
                                                  : const Icon(
                                                      Icons.person,
                                                      size: 40,
                                                    ),
                                            ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            user != null
                                                ? (user.name.length > 28
                                                    ? '${user.name.substring(0, 28)}...'
                                                    : user.name)
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (reserva.canceledAt != null) ...[
                                            GestureDetector(
                                              onTap: () =>
                                                  showCancellationReasonDialog(
                                                      context, reserva.reason!),
                                              child: const Icon(
                                                Icons.info,
                                                size: 34,
                                                color: Color.fromARGB(
                                                    255, 43, 128, 255),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                          ],
                                          decContainer(
                                            onTap: eventInFuture &&
                                                    reserva.canceledAt == null
                                                ? () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatPage(
                                                          receiverID:
                                                              reserva.locadorId,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                : null,
                                            allPadding: 4,
                                            radius: 100,
                                            color: eventInFuture &&
                                                    reserva.canceledAt == null
                                                ? const Color(0xff4300B1)
                                                : Colors.grey[600],
                                            child: Icon(
                                              Icons.chat_bubble,
                                              size: 20,
                                              color: eventInFuture &&
                                                      reserva.canceledAt == null
                                                  ? const Color(0XFFFFFFFF)
                                                  : const Color(0xffD4D4D4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 9,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text:
                                              'O evento ${reserva.canceledAt == null ? (eventInFuture ? "acontecerá" : "aconteceu") : "aconteceria"} em:',
                                          style: const TextStyle(
                                            fontSize: 11,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: formatDateTimestamp(
                                                  reserva.selectedFinalDate),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Início às ',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: formatTime(
                                                      reserva.checkInTime),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: [
                                                    const TextSpan(
                                                        text: ' do dia '),
                                                    TextSpan(
                                                      text: formatDateTimestamp(
                                                          reserva.selectedDate),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const TextSpan(text: '.'),
                                                  ],
                                                ),
                                              ),
                                              const Text(
                                                'Término às ',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: formatTime(
                                                      reserva.checkOutTime),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: [
                                                    const TextSpan(
                                                        text: ' do dia '),
                                                    TextSpan(
                                                      text: formatDateTimestamp(
                                                          reserva
                                                              .selectedFinalDate),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const TextSpan(text: '.'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 24,
                                  bottom: 9,
                                  child: Column(
                                    children: [
                                      if (eventInFuture &&
                                          reserva.canceledAt == null)
                                        decContainer(
                                          onTap: eventInFuture &&
                                                  reserva.canceledAt == null
                                              ? () async {
                                                  final reason =
                                                      await showDialog<String?>(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // Impede que o usuário feche sem escolher
                                                    builder: (context) =>
                                                        CancelReservationDialog(
                                                      reservation: reserva,
                                                    ),
                                                  );

                                                  if (reason != null) {
                                                    await cancelReservation(
                                                        reserva, reason);
                                                  }
                                                }
                                              : null,
                                          topPadding: 8,
                                          bottomPadding: 8,
                                          leftPadding: 16,
                                          rightPadding: 16,
                                          color: Colors.red,
                                          radius: 50,
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      decContainer(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ContratoAssinadoPage(
                                                summaryData: null,
                                                cupomModel: null,
                                                html: reserva.contratoHtml,
                                              ),
                                            ),
                                          );
                                        },
                                        topPadding: 8,
                                        bottomPadding: 8,
                                        leftPadding: 16,
                                        rightPadding: 16,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff9747FF),
                                            Color(0xff4300B1),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        radius: 50,
                                        child: const Text(
                                          'Contrato',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
