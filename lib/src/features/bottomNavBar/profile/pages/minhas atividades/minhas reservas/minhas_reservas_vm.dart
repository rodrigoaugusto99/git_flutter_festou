import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_state.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'minhas_reservas_vm.g.dart';

@riverpod
class MinhasReservasVm extends _$MinhasReservasVm {
  @override
  Future<MinhasReservasState> build(String userId) async {
    final myReservationRepository =
        ref.read(reservationFirestoreRepositoryProvider);

    final reservationResult =
        await myReservationRepository.getMyReservations(userId);

    switch (reservationResult) {
      case Success(value: final reservationData):
        return MinhasReservasState(
          status: MinhasReservasStateStatus.success,
          reservas: reservationData,
        );

      case Failure():
        return MinhasReservasState(
          status: MinhasReservasStateStatus.error,
          reservas: [],
        );
    }
  }
}
