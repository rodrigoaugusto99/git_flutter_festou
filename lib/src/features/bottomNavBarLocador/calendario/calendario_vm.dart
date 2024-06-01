import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/calendario_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendario_vm.g.dart';

@riverpod
class CalendarioVm extends _$CalendarioVm {
  String errorMessage = '';
  @override
  Future<CalendarioReservationsState> build() async {
    final reserveRepository = ref.read(reservationFirestoreRepositoryProvider);

    try {
      final reservasResult = await reserveRepository.getMyReservedClients();

      switch (reservasResult) {
        case Success(value: final reservaData):
          return CalendarioReservationsState(
            status: CalendarioReservationsStateStatus.success,
            reserva: reservaData,
          );

        case Failure(exception: RepositoryException(:final message)):
          errorMessage = message;

          return CalendarioReservationsState(
            status: CalendarioReservationsStateStatus.error,
            reserva: [],
          );
      }
    } on Exception {
      errorMessage = 'Erro desconhecido';

      return CalendarioReservationsState(
        status: CalendarioReservationsStateStatus.error,
        reserva: [],
      );
    }
  }
}
