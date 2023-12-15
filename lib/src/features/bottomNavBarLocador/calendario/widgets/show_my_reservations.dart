import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/widgets/show_my_reservations_infos.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/space_reservations_state.dart';

class ShowMyReservations extends StatefulWidget {
  final CalendarioReservationsState data;
  final AsyncValue reservas;

  const ShowMyReservations({
    super.key,
    required this.data,
    required this.reservas,
  });

  @override
  State<ShowMyReservations> createState() => _ShowMyReservationsState();
}

class _ShowMyReservationsState extends State<ShowMyReservations> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reservas de meus espaços:',
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
          child: ListView.builder(
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
                      //todo: ontap para abrir informacoes do usuario que fez a reserva ()
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
        ),
      ],
    );
  }
}
