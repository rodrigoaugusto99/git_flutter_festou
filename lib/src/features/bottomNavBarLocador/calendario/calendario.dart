import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_vm.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/widgets/show_my_reservations.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/widgets/show_reservations.dart';

class Calendario extends ConsumerStatefulWidget {
  const Calendario({super.key});

  @override
  ConsumerState<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends ConsumerState<Calendario> {
  @override
  Widget build(BuildContext context) {
    final calendarVm = ref.watch(calendarioVmProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: Center(
        child: calendarVm.when(
          data: (CalendarioReservationsState data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Clientes hospedados agora'),
                const Text('Clientes chegando'),
                const Text('Clientes reservados/agendados'),
                Expanded(
                  child: ShowMyReservations(
                    data: data,
                    reservas: calendarVm,
                  ),
                ),
              ],
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return const Stack(children: [
              Center(child: Text('Inserir imagem melhor papai')),
              Center(child: Icon(Icons.error)),
            ]);
          },
          loading: () {
            return const Stack(children: [
              Center(child: Text('Inserir carregamento Personalizado papai')),
              Center(child: CircularProgressIndicator()),
            ]);
          },
        ),
      ),
    );
  }
}
