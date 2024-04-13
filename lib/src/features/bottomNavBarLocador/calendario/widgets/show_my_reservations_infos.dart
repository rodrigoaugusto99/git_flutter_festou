import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_info_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_info_vm.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';

import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:table_calendar/table_calendar.dart';

class ShowMyReservationsInfos extends ConsumerStatefulWidget {
  final ReservationModel reserva;
  const ShowMyReservationsInfos({
    super.key,
    required this.reserva,
  });

  @override
  ConsumerState<ShowMyReservationsInfos> createState() =>
      _ShowMyReservationsInfosState();
}

class _ShowMyReservationsInfosState
    extends ConsumerState<ShowMyReservationsInfos> {
  @override
  Widget build(BuildContext context) {
    final showMyReservationsInfosVm =
        ref.watch(showMyReservationsInfosVmProvider(widget.reserva.userId));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Informacoes dessa reserva'),
        ),
        body: showMyReservationsInfosVm.when(
          data: (ShowMyReservationsInfosState data) {
            return Column(
              children: [
                //Image.network(data.)
                //Text('Nome do cliente: ${data.user!.name}'),
                Text('Nome do cliente: ${data.user!}'),
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
        ));
  }
}
