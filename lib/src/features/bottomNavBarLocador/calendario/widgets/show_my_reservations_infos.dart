import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/widgets/show_my_reservations_info_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/widgets/show_my_reservations_info_vm.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

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
          title: const Text('xoxo'),
        ),
        body: showMyReservationsInfosVm.when(
          data: (ShowMyReservationsInfosState data) {
            return Column(
              children: [
                Text(
                    'Informacoes dessa reserva:\nNome do cliente: ${data.user!.name}'),
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
        ));
  }
}
