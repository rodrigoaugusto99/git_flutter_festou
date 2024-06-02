import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_infos.dart';

class ShowMyReservations extends StatefulWidget {
  final CalendarioReservationsState data;

  const ShowMyReservations({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ShowMyReservations> createState() => _ShowMyReservationsState();
}

class _ShowMyReservationsState extends State<ShowMyReservations> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Minhas Reservas'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.data.reserva.length,
          itemBuilder: (BuildContext context, int index) {
            final reserva = widget.data.reserva[index];
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
