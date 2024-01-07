import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_infos.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:intl/intl.dart';

class ShowMyTodayReservations extends StatefulWidget {
  final CalendarioReservationsState data;

  const ShowMyTodayReservations({
    super.key,
    required this.data,
  });

  @override
  State<ShowMyTodayReservations> createState() =>
      _ShowMyTodayReservationsState();
}

class _ShowMyTodayReservationsState extends State<ShowMyTodayReservations> {
  List<DateTime> parseDateRange(String range) {
    List<DateTime> dateList = [];

    List<String> dateStrings = range.split(' - ');
    for (String dateString in dateStrings) {
      DateTime date = DateFormat('dd/MM/yyyy').parse(dateString);
      dateList.add(date);
    }

    return dateList;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> generateDateListFromRange(String range) {
      List<DateTime> dateList = [];

      List<String> dateStrings = range.split(' - ');
      if (dateStrings.length == 1) {
        // Se houver apenas uma data no range
        DateTime date = DateFormat('dd/MM/yyyy').parse(dateStrings[0]);
        dateList.add(date);
      } else if (dateStrings.length == 2) {
        // Se houver duas datas no range, adiciona todas as datas entre elas
        DateTime startDate = DateFormat('dd/MM/yyyy').parse(dateStrings[0]);
        DateTime endDate = DateFormat('dd/MM/yyyy').parse(dateStrings[1]);

        for (var i = startDate;
            i.isBefore(endDate.add(const Duration(days: 1)));
            i = i.add(const Duration(days: 1))) {
          dateList.add(i);
        }
      }

      return dateList;
    }

    DateTime currentDate = DateTime.now();
    String formattedCurrentDate = DateFormat('dd/MM/yyyy').format(currentDate);

    List<ReservationModel> todayReservations =
        widget.data.reserva.where((reserva) {
      List<DateTime> dateRange = generateDateListFromRange(reserva.range);

      // Verifica se pelo menos uma das datas do range é igual à data atual
      return dateRange.any((date) =>
          DateFormat('dd/MM/yyyy').format(date) == formattedCurrentDate);
    }).toList();

    return ExpansionTile(
      title: const Text('Reservas de hoje'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todayReservations.length,
          itemBuilder: (BuildContext context, int index) {
            final ReservationModel reserva = todayReservations[index];
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
