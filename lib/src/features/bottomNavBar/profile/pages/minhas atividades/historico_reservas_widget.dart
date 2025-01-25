import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/meus%20feedbacks/cancel_reservation_dialog.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';
import 'package:git_flutter_festou/src/services/space_service.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';

class SpaceWithReservation {
  SpaceWithReservation({
    required this.space,
    required this.reserva,
  });
  final SpaceModel space;
  final ReservationModel reserva;
}

class HistoricoReservasWidget extends StatefulWidget {
  const HistoricoReservasWidget({
    super.key,
  });

  @override
  State<HistoricoReservasWidget> createState() =>
      _HistoricoReservasWidgetState();
}

class _HistoricoReservasWidgetState extends State<HistoricoReservasWidget> {
  @override
  void initState() {
    super.initState();
    getMyReservations();
  }

  List<SpaceWithReservation> reservationSpaces = [];
  //todo: mostrar o x se estiver cancelado

  Future<void> getMyReservations() async {
    final reservas = await ReservaService().getReservationsByClienId();

    for (final reserva in reservas) {
      final space = await SpaceService().getSpaceById(reserva.spaceId);
      if (space == null) continue;

      reservationSpaces
          .add(SpaceWithReservation(space: space, reserva: reserva));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.white,
          collapsedShape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          leading: Image.asset('lib/assets/images/icon_avaliacao.png'),
          title: const Text('Minhas reservas'),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reservationSpaces.length,
              itemBuilder: (BuildContext context, int index) {
                final spaceWithReservation = reservationSpaces[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 10),
                  child: HistoricoReservasTile(
                      spaceShowing: spaceWithReservation.space,
                      reservationModel: spaceWithReservation.reserva,
                      showCancelReservationDialog: () {
                        showDialog(
                          context: context,
                          builder: (context) => CancelReservationDialog(
                            reservation: spaceWithReservation.reserva,
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HistoricoReservasTile extends StatefulWidget {
  final SpaceModel spaceShowing;
  final ReservationModel reservationModel;
  final Function()? showCancelReservationDialog;
  const HistoricoReservasTile({
    super.key,
    required this.spaceShowing,
    required this.reservationModel,
    required this.showCancelReservationDialog,
  });

  @override
  State<HistoricoReservasTile> createState() => _HistoricoReservasTileState();
}

String formatDateTime(DateTime date, int startHour, int endHour) {
  // Formatar data para 'dd/MM/yyyy'
  String formattedDate = DateFormat('dd/MM/yyyy').format(date);
  String formattedStartTime;
  // Formatar o horário de início (hh:mm)
  formattedStartTime = '$startHour:00';
  if (startHour.toString().length == 1) {
    formattedStartTime = '0$startHour:00';
  }

  // Formatar o horário de término (hh:mm)
  String formattedEndTime;

  formattedEndTime = '$endHour:59';
  if (endHour.toString().length == 1) {
    formattedEndTime = '0$endHour:59';
  }

  // Montar o formato completo
  return '$formattedDate - $formattedStartTime às ${formattedEndTime}h';
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

class _HistoricoReservasTileState extends State<HistoricoReservasTile> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //  onTap: () => navToPage(),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                CarouselSlider(
                  items: widget.reservationModel.canceledAt != null
                      ? widget.spaceShowing.imagesUrl
                          .map(
                            (imageUrl) => ColorFiltered(
                              colorFilter: const ColorFilter.matrix(
                                <double>[
                                  0.2126, 0.7152, 0.0722, 0, 0, // Red
                                  0.2126, 0.7152, 0.0722, 0, 0, // Green
                                  0.2126, 0.7152, 0.0722, 0, 0, // Blue
                                  0, 0, 0, 1, 0, // Alpha
                                ],
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList()
                      : widget.spaceShowing.imagesUrl
                          .map(
                            (imageUrl) => Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          )
                          .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 305 / 179,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                if (widget.reservationModel.canceledAt != null)
                  Positioned.fill(
                    top: 10,
                    bottom: 50,
                    child: decContainer(
                      child:
                          Image.asset('lib/assets/images/imagem_cancelado.png'),
                    ),
                  ),
                if (widget.reservationModel.canceledAt != null)
                  Positioned(
                    right: 21,
                    top: 19,
                    child: GestureDetector(
                      onTap: () => showCancellationReasonDialog(
                          context, widget.reservationModel.reason!),
                      child: Image.asset(
                        'lib/assets/images/imagem_info.png',
                        scale: 2.5,
                      ),
                    ),
                  )
              ],
            ),
          ),
          Positioned(
            bottom: -40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 270,
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 20,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  capitalizeFirstLetter(
                                      widget.spaceShowing.titulo),
                                  style: const TextStyle(
                                    fontFamily: 'RedHatDisplay',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              style: TextStyle(
                                  color: Colors.blueGrey[500], fontSize: 11),
                              capitalizeTitle(
                                  "${widget.spaceShowing.bairro}, ${widget.spaceShowing.cidade}"),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                              color: Color(0xff9747FF),
                            ),
                          ),
                          Align(
                            child: Text(
                              formatDateTime(
                                widget.reservationModel.selectedDate.toDate(),
                                widget.reservationModel.checkInTime,
                                widget.reservationModel.checkOutTime,
                              ),
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xff5E5E5E),
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
          ),
          if (widget.reservationModel.canceledAt == null)
            Positioned(
              top: 11,
              left: 9,
              child: decContainer(
                onTap: widget.showCancelReservationDialog,
                radius: 50,
                height: 36,
                width: 36,
                align: Alignment.center,
                color: Colors.red,
                child: const Text(
                  'X',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
