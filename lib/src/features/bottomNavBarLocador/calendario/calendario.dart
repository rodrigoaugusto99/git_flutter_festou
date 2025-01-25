import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/contrato_assinado_page.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';
import 'package:git_flutter_festou/src/services/space_service.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
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
    if (mySpaces != null) {}
    selectSpace(mySpaces!.first);

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
    selectedSpaceReservations =
        minhasReservas!.where((r) => r.spaceId == spaceId).toList();
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
      DateTime selectedDate =
          reservation.selectedDate.toDate(); // Converte Timestamp para DateTime
      DateTime selectedDateOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      ); // Remove horas, minutos e segundos

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                //color: Colors.white.withOpacity(0.7),
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificacoesLocatarioPage(),
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
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //clipBehavior: Clip.none,
                  // padding: const EdgeInsets.all(20),
                  children: [
                    const Text('Escolha o espaço'),
                    const SizedBox(height: 20),
                    ...mySpaces!.map((space) {
                      return Column(
                        children: [
                          SpaceWidget(
                            isSelected: selectedSpace!.spaceId == space.spaceId,
                            space: space,
                            onTap: () => selectSpace(space),
                          ),
                          const SizedBox(height: 17),
                        ],
                      );
                    }),
                    const SizedBox(height: 30),
                    const Text('Calendário de reservas'),
                    if (selectedSpaceReservations != null) ...[
                      const SizedBox(height: 20),
                      CalendarioExpansioWidget(
                        minhasReservas: selectedSpaceReservations!,
                        title: 'Todas as reservas desse espaço',
                      ),
                    ],
                    const SizedBox(height: 14),
                    CalendarioExpansioWidget(
                      minhasReservas: minhasReservas!,
                      title: 'Todas as reservas',
                    ),
                    const SizedBox(height: 14),
                    CalendarioExpansioWidget(
                      minhasReservas: minhasReservasProximas!,
                      title: 'Próximas reservas',
                      isNear: true,
                    ),
                  ],
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
              color: Colors.blue,
              width: screenWidth(context) / 2,
              height: 61,
              child: Stack(
                children: [
                  Image.network(
                    space.imagesUrl.isNotEmpty
                        ? space.imagesUrl[0]
                        : 'URL de uma imagem padrão ou vazia',
                    width: screenWidth(context) / 2,
                    height: 61,
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
                          Column(
                            children: [
                              Text(
                                space.titulo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${space.bairro}, ${space.cidade}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff5E5E5E)),
                              ),
                            ],
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
                              child: Center(
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
  //UserModel? user;
  // @override
  // void initState() {
  //   super.initState();
  //   getUserById();
  // }

  String formatTime(int hour) {
    String hourStr = hour.toString().padLeft(2, '0');
    return '$hourStr:00h';
  }

  // String formatDateString(String dateStr) {
  //   DateTime date = DateTime.parse(dateStr);
  //   DateFormat formatter = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR');
  //   return formatter.format(date);
  // }

  String formatDateTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate(); // Converte o Timestamp para DateTime
    DateFormat formatter = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR');
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
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // bool isDateInFuture(String dateStr) {
  //   DateTime date = DateTime.parse(dateStr);
  //   DateTime now = DateTime.now();
  //   return date.isAfter(now);
  // }

  bool isDateInFuture(Timestamp timestamp) {
    DateTime date = timestamp.toDate(); // Converte o Timestamp para DateTime
    DateTime now = DateTime.now();
    return date.isAfter(now);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    'lib/assets/images/Icon SegurançacalendarNow (1).png',
                    height: 25,
                  ),
                ),
              if (!widget.isNear)
                Positioned(
                  left: 5,
                  child: Image.asset(
                      'lib/assets/images/IconSearchcalendarbaby.png'),
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
          //todo:  pra prsquisar reservas, pesqquisar com base no nome do espaco, do cliente, e mais.
          //todo: botao cancelar; check/close icon
          children: widget.minhasReservas.map((reserva) {
            bool eventInFuture = isDateInFuture(reserva.selectedFinalDate);
            //getUserById(reserva.clientId);
            final user = reserva.user;

            return Container(
              decoration: BoxDecoration(
                color: eventInFuture ? null : const Color(0xffD4D4D4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 23, top: 11),
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
                            height: 11,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                          'lib/assets/images/Rectangle 108imageBehind.png'),
                      if (reserva.canceledAt != null)
                        Image.asset(
                          'lib/assets/images/reserva-cancelada.png',
                          height: getResponsiveWidth(context, 108),
                        ),
                      if (reserva.canceledAt == null)
                        Image.asset(
                          'lib/assets/images/reserva-confirmada.png',
                          height: getResponsiveWidth(context, 90),
                        ),
                      decContainer(
                        topPadding: 5,
                        bottomPadding: 9,
                        leftPadding: 23,
                        rightPadding: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (user != null && user.avatarUrl != '')
                                  CircleAvatar(
                                    backgroundImage: Image.network(
                                      user.avatarUrl,
                                      fit: BoxFit.cover,
                                    ).image,
                                    radius: 20,
                                  ),
                                if (user != null && user.avatarUrl.isEmpty)
                                  CircleAvatar(
                                    radius: 20,
                                    child: user.name.isNotEmpty
                                        ? Text(
                                            user.name[0].toUpperCase(),
                                            style:
                                                const TextStyle(fontSize: 25),
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
                                  user != null ? user.name : '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                                const Spacer(),
                                if (reserva.canceledAt != null) ...[
                                  GestureDetector(
                                    onTap: () => showCancellationReasonDialog(
                                        context, reserva.reason!),
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                ],
                                decContainer(
                                  onTap: eventInFuture
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                receiverID: reserva.locadorId,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  allPadding: 4,
                                  radius: 100,
                                  color: eventInFuture
                                      ? const Color(0xffF3F3F3)
                                      : const Color(0xff979797),
                                  child: Icon(
                                    Icons.chat_bubble,
                                    size: 12,
                                    color: eventInFuture
                                        ? const Color(0xff4300B1)
                                        : const Color(0xffD4D4D4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Text(
                              'O evento ${eventInFuture ? "acontecerá" : "aconteceu"} em:',
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: 'Início às ',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                formatTime(reserva.checkInTime),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(text: ' do dia '),
                                          TextSpan(
                                            text: formatDateTimestamp(
                                                reserva.selectedDate),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(text: '.'),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Término às ',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: formatTime(
                                                reserva.checkOutTime),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(text: ' do dia '),
                                          TextSpan(
                                            text: formatDateTimestamp(
                                                reserva.selectedFinalDate),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
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
                            if (eventInFuture)
                              decContainer(
                                topPadding: 5,
                                bottomPadding: 5,
                                leftPadding: 15,
                                rightPadding: 15,
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
                                  'Cancelar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
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
                                    builder: (context) => ContratoAssinadoPage(
                                      summaryData: null,
                                      cupomModel: null,
                                      html: reserva.contratoHtml,
                                    ),
                                  ),
                                );
                              },
                              topPadding: 5,
                              bottomPadding: 5,
                              leftPadding: 15,
                              rightPadding: 15,
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
                                  fontSize: 8,
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
    );
  }
}
