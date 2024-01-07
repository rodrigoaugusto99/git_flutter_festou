import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/show%20reservations/space_reservations_state.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'space_reservations_vm.g.dart';

@riverpod
class SpaceReservationsVm extends _$SpaceReservationsVm {
  @override
  Future<SpaceReservationsState> build(SpaceModel space) async {
    final reservationRepository =
        ref.read(reservationFirestoreRepositoryProvider);

    final reservationResult =
        await reservationRepository.getReservations(space.spaceId);

    switch (reservationResult) {
      case Success(value: final feedbackData):
        return SpaceReservationsState(
          status: SpaceReservationsStateStatus.success,
          reserva: feedbackData,
        );

      case Failure():
        return SpaceReservationsState(
          status: SpaceReservationsStateStatus.error,
          reserva: [],
        );
    }
  }
}
