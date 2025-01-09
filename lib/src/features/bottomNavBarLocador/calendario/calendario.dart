import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/contrato_assinado_page.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import 'package:intl/intl.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key});

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  List<ReservationModel>? minhasReservas;
  List<ReservationModel>? minhasReservasProximas;
  UserService userService = UserService();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    //pegando reservas dos meus espacos
    fetchReservas();
  }

  void fetchReservas() async {
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
    minhasReservasProximas = getNearbyReservations(minhasReservas!);
    setState(() {});
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
      body: minhasReservas == null
          ? const CircularProgressIndicator()
          : ListView(
              clipBehavior: Clip.none,
              // padding: const EdgeInsets.all(20),
              children: [
                const Text('Calendário de reservas'),
                CalendarioExpansioWidget(
                    minhasReservas: minhasReservas!,
                    title: 'Todas as reservas'),
                CalendarioExpansioWidget(
                  minhasReservas: minhasReservasProximas!,
                  title: 'Próximas reservas',
                ),
              ],
            ),
    );
  }
}

class CalendarioExpansioWidget extends StatefulWidget {
  final List<ReservationModel> minhasReservas;
  final String title;

  const CalendarioExpansioWidget({
    required this.minhasReservas,
    required this.title,
    super.key,
  });

  @override
  State<CalendarioExpansioWidget> createState() =>
      _CalendarioExpansioWidgetState();
}

class _CalendarioExpansioWidgetState extends State<CalendarioExpansioWidget> {
  UserModel? user;
  // @override
  // void initState() {
  //   super.initState();
  //   getUserById();
  // }

  Future<void> getUserById(String id) async {
    user = await UserService().getCurrentUserModelById(id: id);

    setState(() {});
  }

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
    return ExpansionTile(
      clipBehavior: Clip.none,
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
          Positioned(
            left: 5,
            child: Image.asset('lib/assets/images/IconSearchcalendarbaby.png'),
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
        getUserById(reserva.clientId);

        return Container(
          decoration: BoxDecoration(
            color: eventInFuture ? null : const Color(0xffD4D4D4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.only(left: 23, top: 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '20 de Mai / 2024',
                        style: TextStyle(
                          color: Color(0xff4300B1),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Image.asset('lib/assets/images/Rectangle 108imageBehind.png'),
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
                            CircleAvatar(
                              backgroundImage: user != null
                                  ? Image.network(
                                      user!.avatarUrl,
                                      fit: BoxFit.cover,
                                    ).image
                                  : const AssetImage(
                                          'lib/assets/images/avatar.png')
                                      as ImageProvider,
                              radius: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              user != null ? user!.name : '',
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                            const Spacer(),
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
                              allPadding: 5,
                              radius: 100,
                              color: eventInFuture
                                  ? const Color(0xffF3F3F3)
                                  : const Color(0xff979797),
                              child: Icon(
                                Icons.chat_bubble,
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
                                        text: formatTime(reserva.checkInTime),
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
                                        text: formatTime(reserva.checkOutTime),
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
    );
  }
}
