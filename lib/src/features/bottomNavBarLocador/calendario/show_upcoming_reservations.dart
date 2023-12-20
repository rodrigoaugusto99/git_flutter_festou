import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_infos.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:intl/intl.dart';

class ShowUpcomingReservations extends StatefulWidget {
  final CalendarioReservationsState data;

  const ShowUpcomingReservations({
    super.key,
    required this.data,
  });

  @override
  State<ShowUpcomingReservations> createState() =>
      _ShowUpcomingReservationsState();
}

class _ShowUpcomingReservationsState extends State<ShowUpcomingReservations> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    List<ReservationModel> filteredReservations =
        widget.data.reserva.where((reserva) {
      // Assuming 'range' is a property in your ReservationModel
      DateTime reservationDate = DateFormat('dd/MM/yyyy').parse(reserva.range);

      return reservationDate.isAfter(currentDate) &&
          reservationDate.isBefore(currentDate.add(const Duration(days: 7)));
    }).toList();

    return ExpansionTile(
      title: const Text('Reservas mais proximas'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredReservations.length,
          itemBuilder: (BuildContext context, int index) {
            final ReservationModel reserva = filteredReservations[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ShowMyReservationsInfos(reserva: reserva);
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reserva: ${reserva.range}',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
