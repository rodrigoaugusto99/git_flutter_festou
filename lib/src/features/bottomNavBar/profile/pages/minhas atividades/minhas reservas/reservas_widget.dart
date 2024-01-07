import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_state.dart';

class ReservasWidget extends StatefulWidget {
  final MinhasReservasState data;
  const ReservasWidget({
    super.key,
    required this.data,
  });

  @override
  State<ReservasWidget> createState() => _ReservasWidgetState();
}

class _ReservasWidgetState extends State<ReservasWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Minhas Reservas'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.data.reservas.length,
          itemBuilder: (BuildContext context, int index) {
            final reserva = widget.data.reservas[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4),
                Container(
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
                        'Reserva: ${reserva.range}\nStatus: ${reserva.status}',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
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
