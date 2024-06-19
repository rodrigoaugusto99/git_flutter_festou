import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import 'package:svg_flutter/svg.dart';

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
        await ReservaService().getReservationsByLocadorId(userModel!.id);
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
      DateTime selectedDate = DateTime.parse(reservation.selectedDate);
      return selectedDate.isAtSameMomentAs(today) ||
          selectedDate.isAtSameMomentAs(tomorrow) ||
          selectedDate.isAtSameMomentAs(dayAfterTomorrow);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    builder: (context) => const NotificacoesPage(),
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
        backgroundColor: const Color(0XFFF0F0F0),
      ),
      body: minhasReservas == null
          ? const CircularProgressIndicator()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Calendário de reservas'),
                CalendarioExpansioWidget(minhasReservas: minhasReservas!),
                CalendarioExpansioWidget(
                    minhasReservas: minhasReservasProximas!),
              ],
            ),
    );
  }
}

class CalendarioExpansioWidget extends StatelessWidget {
  List<ReservationModel> minhasReservas;
  CalendarioExpansioWidget({
    required this.minhasReservas,
    super.key,
  });

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
      //backgroundColor: const Color(0xff9747FF),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 33),
      title: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 5,
              child:
                  Image.asset('lib/assets/images/IconSearchcalendarbaby.png')),
          const SizedBox(width: 10),
          const Positioned(
            left: 40,
            child: Text(
              'Todas as reservas',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
      children: [
        Text(minhasReservas.length.toString()),
      ],
    );
  }
}
