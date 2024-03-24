import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_vm.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/show_my_reservations.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/show_upcoming_reservations.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';

import 'show_my_today_reservations.dart';

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
            return ListView(
              children: [
                const Text('Clientes hospedados agora'),
                ShowMyReservations(data: data),
                ShowUpcomingReservations(data: data),
                ShowMyTodayReservations(data: data),
              ],
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return const Stack(children: [
              Center(child: Icon(Icons.error)),
            ]);
          },
          loading: () {
            return const Stack(children: [
              Center(child: CustomLoadingIndicator()),
            ]);
          },
        ),
      ),
    );
  }
}
