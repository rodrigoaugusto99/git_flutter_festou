import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/space_reservations_state.dart';

class ShowReservations extends StatefulWidget {
  final SpaceReservationsState data;
  final AsyncValue reservas;

  const ShowReservations({
    super.key,
    required this.data,
    required this.reservas,
  });

  @override
  State<ShowReservations> createState() => _ShowReservationsState();
}

class _ShowReservationsState extends State<ShowReservations> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: widget.data.reserva.length,
        itemBuilder: (BuildContext context, int index) {
          final reserva = widget.data.reserva[index];
          return Container(
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
                  'id: ${reserva.userId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'range: ${reserva.range}',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
